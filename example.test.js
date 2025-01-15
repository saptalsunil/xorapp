// example.test.js
const { test, expect } = require('@playwright/test');

test('should open the Playwright homepage and check the title', async ({ page }) => {
  // Navigate to the Playwright homepage
  await page.goto('https://playwright.dev/');

  // Check if the title contains 'Playwright'
  await expect(page).toHaveTitle(/Playwright/);
});