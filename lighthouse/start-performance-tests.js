#!/usr/bin/env node

const fs = require('fs-extra');
const lighthouse = require('lighthouse');
const ReportGeneratorV2 = require('./node_modules/lighthouse/lighthouse-core/report/report-generator');

const chromeLauncher = require('chrome-launcher');
const customConfig = require('./base/lighthouse-config');
const categoriesByThresholds = require('./thresholds/performance-thresholds');

const args = process.argv.slice(2);

const REPORTS_DIR = '/lighthouse/reports';

const testUrl = args[0];

const opts = {
  chromeFlags: [''],
};

function isPassed(results) {
  const categoryByResults = results.categories;
  return Object.keys(categoriesByThresholds).every((category) => {
    const threshold = categoriesByThresholds[category];
    const categoryResult = categoryByResults[category];
    return categoryResult.score >= threshold;
  });
}

function launchChromeAndRunLighthouse(url, opts, config = null) {
  return chromeLauncher
    .launch({
      chromeFlags: opts.chromeFlags,
    })
    .then(chrome => {
      opts.port = chrome.port;
      return lighthouse(url, opts, config).then(results => {
        return chrome.kill().then(() => results.lhr);
      });
    });
}

launchChromeAndRunLighthouse(testUrl, opts, customConfig).then(results => {
  const fileName = 'report.html';
  const outputPath = `./${REPORTS_DIR}/${fileName}`;
  const reportInHtml = ReportGeneratorV2.generateReportHtml(results);
  fs.outputFile(outputPath, reportInHtml);
  const passed = isPassed(results);
  if (!passed) {
    process.exit(1);
  }
})
  .catch(error => {
    throw new Error('Lighthouse error: ' + error);
    process.exit(1);
  });
