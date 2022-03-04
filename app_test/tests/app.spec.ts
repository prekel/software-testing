import { expect, test } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto(process.env.APP_URL);
});

test.describe('Generic tests', () => {
  test('Test init', async ({ page }, ti) => {
    await expect(page.locator('.form')).toHaveValue("");
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await expect(page.locator('.radio-float')).toBeChecked();
    await expect(page.locator('.radio-int')).not.toBeChecked();
    await expect(page.locator('.radio-vector0')).not.toBeChecked();
    await expect(page.locator('.radio-vector1')).not.toBeChecked();
    await expect(page.locator('.radio-vector2')).not.toBeChecked();
    await page.locator('.root').screenshot({ path: `screenshots/${ti.project.name}/1-init.png` });
  });
})

test.describe('Test float calculator', () => {
  test('Simple test', async ({ page }, ti) => {
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
    await page.locator('.root').screenshot({ path: `screenshots/${ti.project.name}/2-float.png` });
  });

  test('Testing Back button', async ({ page }, ti) => {
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("1");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 1))");
    await page.locator('.back').click();
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("3");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 3))");
    await page.locator('.form').fill("+");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitArgument (acc 3) (op Add))");
    await page.locator('.form').fill("2");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(Calculation (acc 3) (op Add) (arg 2))");
    await page.locator('.form').fill("=");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 5))");
    await page.locator('.form').fill("");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(Finish 5)");
    await page.locator('.root').screenshot({ path: `screenshots/${ti.project.name}/3-float-back.png` });
  });

  test('Testing Reset button', async ({ page }, ti) => {
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("1");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 1))");
    await page.locator('.back').click();
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("3");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 3))");
    await page.locator('.form').fill("+");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitArgument (acc 3) (op Add))");
    await page.locator('.reset').click();
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
    await page.locator('.root').screenshot({ path: `screenshots/${ti.project.name}/4-float-reset.png` });
  });

  test('Testing Empty and Calc buttons', async ({ page }, ti) => {
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("1");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 1))");
    await page.locator('.back').click();
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
    await page.locator('.calc').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc 3))");
    await page.locator('.empty').click();
    await expect(page.locator('.state')).toHaveText("(Finish 3)");
    await page.locator('.root').screenshot({ path: `screenshots/${ti.project.name}/5-float-empty-calc.png` });
  });
})

test.describe('Test vector2 calculator', () => {
  test('Simple test', async ({ page }, ti) => {
    await page.locator('.radio-vector2').check()
    await expect(page.locator('.state')).toHaveText("WaitInitial");
    await page.locator('.form').fill("(1,-123)");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc (1 (-123 ()))))");
    await page.locator('.form').fill("+");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitArgument (acc (1 (-123 ()))) (op Add))");
    await page.locator('.form').fill("(2,12)");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(Calculation (acc (1 (-123 ()))) (op Add) (arg (2 (12 ()))))");
    await page.locator('.form').fill("=");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(WaitOperation (acc (3 (-111 ()))))");
    await page.locator('.form').fill("");
    await page.locator('.enter').click();
    await expect(page.locator('.state')).toHaveText("(Finish (3 (-111 ())))");
    await page.locator('.root').screenshot({ path: `screenshots/${ti.project.name}/6-vector2.png` });
  });
})
