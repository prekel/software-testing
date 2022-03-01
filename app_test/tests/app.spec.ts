import { test } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto(process.env.APP_URL);
});

test.describe('q', () => {
  test('w', async ({ page }) => {
    console.log(page.url());
  });
})
