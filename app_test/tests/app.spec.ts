import { expect, test } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto(process.env.APP_URL);
});

test.describe('q', () => {
  test('w1', async ({ page }) => {
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("1");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 1))");
    await page.locator('.form').fill("+");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitArgument (acc 1) (op Add))");
    await page.locator('.form').fill("2");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(Calculation (acc 1) (op Add) (arg 2))");
    await page.locator('.form').fill("=");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 3))");
    await page.locator('.form').fill("");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(Finish 3)");
  });
})
