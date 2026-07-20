"""
================================================================================
Hands-On 5: Locators & Explicit Wait Mechanisms
================================================================================
"""

import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException, ElementNotInteractableException
from webdriver_manager.chrome import ChromeDriverManager


def run_locator_showcase():
    """Demonstrate all locator strategies on LambdaTest Simple Form Demo"""
    
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
    driver.maximize_window()
    
    try:
        print("\n" + "=" * 70)
        print("STEP 1.32: All 6 Locator Strategies")
        print("=" * 70)
        
        # Navigate directly to Simple Form Demo
        driver.get("https://www.lambdatest.com/selenium-playground/simple-form-demo")
        
        # Wait for the input field to be present
        wait = WebDriverWait(driver, 10)
        wait.until(EC.presence_of_element_located((By.ID, "user-message")))
        time.sleep(2)  # Extra wait for stability
        
        print("\n📝 Locating the 'Enter Message' input field...")
        print("-" * 50)
        
        # ✅ 1. By.ID - BEST PRACTICE
        print("\n1️⃣ By.ID (RECOMMENDED):")
        try:
            el_id = driver.find_element(By.ID, "user-message")
            el_id.clear()
            el_id.send_keys("Testing ID locator")
            print(f"   ✅ Found using ID: '{el_id.get_attribute('value')}'")
            el_id.clear()
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ 2. By.NAME - FIXED: Use JavaScript to send keys
        print("\n2️⃣ By.NAME:")
        try:
            el_name = driver.find_element(By.NAME, "message")
            # Scroll to element
            driver.execute_script("arguments[0].scrollIntoView(true);", el_name)
            time.sleep(0.5)
            # Use JavaScript to set value directly
            driver.execute_script("arguments[0].value = 'Testing NAME locator';", el_name)
            print(f"   ✅ Found using NAME (via JS): '{el_name.get_attribute('value')}'")
            # Clear using JS
            driver.execute_script("arguments[0].value = '';", el_name)
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ 3. By.CLASS_NAME (with filtering)
        print("\n3️⃣ By.CLASS_NAME:")
        try:
            elements = driver.find_elements(By.CLASS_NAME, "form-control")
            for el in elements:
                if el.get_attribute("id") == "user-message":
                    el.clear()
                    el.send_keys("Testing CLASS_NAME locator")
                    print(f"   ✅ Found using CLASS_NAME: '{el.get_attribute('value')}'")
                    el.clear()
                    break
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ 4. By.TAG_NAME (with filtering)
        print("\n4️⃣ By.TAG_NAME:")
        try:
            inputs = driver.find_elements(By.TAG_NAME, "input")
            for el in inputs:
                if el.get_attribute("id") == "user-message":
                    el.clear()
                    el.send_keys("Testing TAG_NAME locator")
                    print(f"   ✅ Found using TAG_NAME: '{el.get_attribute('value')}'")
                    el.clear()
                    break
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ 5. By.XPATH - Relative (RECOMMENDED)
        print("\n5️⃣ By.XPATH - Relative (RECOMMENDED):")
        try:
            el_xp_r = driver.find_element(By.XPATH, "//input[@id='user-message']")
            el_xp_r.clear()
            el_xp_r.send_keys("Testing XPath with ID")
            print(f"   ✅ Found using XPath: '{el_xp_r.get_attribute('value')}'")
            el_xp_r.clear()
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ 6. By.XPATH - Using contains() - FIXED
        print("\n6️⃣ By.XPATH - Using contains():")
        try:
            # Using partial placeholder text
            el_xp_contains = driver.find_element(By.XPATH, "//input[contains(@placeholder, 'Enter your Message')]")
            el_xp_contains.clear()
            el_xp_contains.send_keys("Testing XPath contains()")
            print(f"   ✅ Found using XPath contains(): '{el_xp_contains.get_attribute('value')}'")
            el_xp_contains.clear()
        except Exception as e:
            print(f"   ⚠️ contains() not working, trying alternative...")
            try:
                # Alternative: Use starts-with
                el_xp_contains = driver.find_element(By.XPATH, "//input[starts-with(@placeholder, 'Please enter')]")
                el_xp_contains.clear()
                el_xp_contains.send_keys("Testing XPath starts-with()")
                print(f"   ✅ Found using XPath starts-with(): '{el_xp_contains.get_attribute('value')}'")
                el_xp_contains.clear()
            except Exception as e2:
                print(f"   ❌ Error: {str(e2)[:80]}")
        
        print("\n" + "=" * 70)
        print("STEP 1.33: 3 CSS Selector Strategies")
        print("=" * 70)
        
        print("\n📝 Testing 3 different CSS selectors...")
        print("-" * 50)
        
        # ✅ CSS Selector 1: By ID
        print("\nCSS Selector 1 - By ID (#user-message):")
        try:
            css_by_id = driver.find_element(By.CSS_SELECTOR, "#user-message")
            css_by_id.clear()
            css_by_id.send_keys("CSS: #user-message")
            print(f"   ✅ Found: '{css_by_id.get_attribute('value')}'")
            css_by_id.clear()
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ CSS Selector 2: By Attribute - FIXED
        print("\nCSS Selector 2 - By Attribute ([placeholder]):")
        try:
            css_by_attr = driver.find_element(By.CSS_SELECTOR, "input[placeholder='Please enter your Message']")
            css_by_attr.clear()
            css_by_attr.send_keys("CSS: [placeholder]")
            print(f"   ✅ Found: '{css_by_attr.get_attribute('value')}'")
            css_by_attr.clear()
        except Exception as e:
            print(f"   ⚠️ Error: {str(e)[:60]}, trying with partial match...")
            try:
                css_by_attr = driver.find_element(By.CSS_SELECTOR, "input[placeholder*='Message']")
                css_by_attr.clear()
                css_by_attr.send_keys("CSS: [placeholder*='Message']")
                print(f"   ✅ Found using partial placeholder: '{css_by_attr.get_attribute('value')}'")
                css_by_attr.clear()
            except Exception as e2:
                print(f"   ❌ Error: {str(e2)[:80]}")
        
        # ✅ CSS Selector 3: By Parent-Child - FIXED
        print("\nCSS Selector 3 - By Parent-Child (div > input):")
        try:
            css_by_parent = driver.find_element(By.CSS_SELECTOR, ".form-group input")
            css_by_parent.clear()
            css_by_parent.send_keys("CSS: .form-group input")
            print(f"   ✅ Found using .form-group input: '{css_by_parent.get_attribute('value')}'")
            css_by_parent.clear()
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        print("\n" + "=" * 70)
        print("STEP 1.34: XPath text() and contains() on Checkbox Demo")
        print("=" * 70)
        
        # Navigate to Checkbox Demo
        driver.get("https://www.lambdatest.com/selenium-playground/checkbox-demo")
        wait.until(EC.presence_of_element_located((By.XPATH, "//label[contains(text(), 'Option')]")))
        time.sleep(1)
        
        print("\n📝 Testing XPath text() and contains()...")
        print("-" * 50)
        
        # ✅ XPath with text() - Exact match
        print("\n1️⃣ XPath with text() (Exact Match):")
        try:
            label_exact = driver.find_element(By.XPATH, "//label[text()='Option 1']")
            print(f"   ✅ Found label: '{label_exact.text}'")
            
            # Find the checkbox associated with this label
            checkbox = driver.find_element(By.XPATH, "//input[@type='checkbox' and @value='Option 1']")
            checkbox.click()
            print(f"   ✅ Checkbox clicked! Selected: {checkbox.is_selected()}")
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        # ✅ XPath with contains() - Partial match
        print("\n2️⃣ XPath with contains() (Partial Match):")
        try:
            label_contains = driver.find_elements(By.XPATH, "//label[contains(text(), 'Option')]")
            print(f"   ✅ Found {len(label_contains)} labels containing 'Option':")
            for i, label in enumerate(label_contains[:8], 1):
                print(f"      {i}. '{label.text}'")
        except Exception as e:
            print(f"   ❌ Error: {str(e)[:80]}")
        
        print("\n" + "=" * 70)
        print("✅ LOCATOR SHOWCASE COMPLETED!")
        print("=" * 70)
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)[:200]}")
    finally:
        driver.quit()


def run_waits_showcase():
    """Demonstrate explicit waits, FluentWait, and wait conditions"""
    
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
    driver.maximize_window()
    
    try:
        print("\n" + "=" * 70)
        print("STEP 2.36 & 2.37: Explicit Wait vs time.sleep()")
        print("=" * 70)
        
        # Navigate to Bootstrap Alerts - FIXED URL
        driver.get("https://www.lambdatest.com/selenium-playground/bootstrap-alert-demo")
        
        # Wait for page to load
        wait = WebDriverWait(driver, 15)
        wait.until(EC.presence_of_element_located((By.XPATH, "//button[contains(text(), 'Success Message')]")))
        time.sleep(2)
        
        print("\n📝 Testing explicit wait...")
        print("-" * 50)
        
        # ✅ FIXED: Find and click the "Success Message" button
        start_time = time.time()
        
        # Try multiple selectors for the success button
        try:
            success_btn = driver.find_element(By.XPATH, "//button[contains(text(), 'Success Message')]")
            success_btn.click()
            print("   ✅ Clicked 'Success Message' button (XPath)")
        except:
            try:
                success_btn = driver.find_element(By.CSS_SELECTOR, ".btn-success")
                success_btn.click()
                print("   ✅ Clicked 'Success Message' button (CSS)")
            except:
                try:
                    success_btn = driver.find_element(By.XPATH, "//button[contains(@class, 'success')]")
                    success_btn.click()
                    print("   ✅ Clicked 'Success Message' button (class)")
                except Exception as e:
                    print(f"   ❌ Could not find success button: {str(e)[:60]}")
                    return
        
        # ✅ Explicit wait for alert to appear
        try:
            alert_div = wait.until(
                EC.visibility_of_element_located((By.CSS_SELECTOR, ".alert-success"))
            )
            elapsed = time.time() - start_time
            
            print(f"   ✅ Alert found in {elapsed:.3f} seconds")
            print(f"   ✅ Alert text: '{alert_div.text}'")
            
            if "successfully" in alert_div.text.lower():
                print("   ✅ Alert contains 'successfully' - TEST PASSED")
            else:
                print(f"   ⚠️ Alert text: '{alert_div.text}'")
        except Exception as e:
            print(f"   ❌ Alert not found: {str(e)[:80]}")
        
        print("\n" + "=" * 70)
        print("STEP 2.38: element_to_be_clickable")
        print("=" * 70)
        
        print("\n📚 Understanding element_to_be_clickable:")
        print("-" * 50)
        print("   visibility_of_element_located:")
        print("   • Checks if element is present in DOM AND visible")
        print("   • Does NOT check if element is enabled or clickable")
        print("   • Example: A disabled button is visible but not clickable")
        print("\n   element_to_be_clickable:")
        print("   • Checks if element is visible AND enabled AND not obscured")
        print("   • Waits for element to be ready for interaction")
        print("   • This is the SAFEST way to wait before clicking")
        
        print("\n🔍 Demonstrating element_to_be_clickable:")
        print("-" * 50)
        
        # ✅ Wait for button to be clickable
        try:
            autoclose_btn = wait.until(
                EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Auto Close')]"))
            )
            print(f"   ✅ Button found and is clickable!")
            print(f"   📝 Button text: '{autoclose_btn.text}'")
            autoclose_btn.click()
            print("   ✅ Button clicked successfully!")
        except Exception as e:
            print(f"   ⚠️ Auto Close button not found: {str(e)[:60]}")
            try:
                close_btn = driver.find_element(By.XPATH, "//button[contains(text(), 'Close')]")
                close_btn.click()
                print("   ✅ Close button clicked successfully!")
            except Exception as e2:
                print(f"   ❌ Alternative also failed: {str(e2)[:60]}")
        
        print("\n" + "=" * 70)
        print("STEP 2.39: FluentWait Implementation")
        print("=" * 70)
        
        # Navigate to Table Sort page
        driver.get("https://www.lambdatest.com/selenium-playground/table-sort-search-demo")
        
        print("\n📝 Testing FluentWait with custom polling...")
        print("-" * 50)
        
        # ✅ FluentWait: Poll every 500ms for up to 10 seconds
        fluent_wait = WebDriverWait(
            driver, 
            timeout=10, 
            poll_frequency=0.5, 
            ignored_exceptions=[NoSuchElementException]
        )
        
        # Wait for table to load
        try:
            table_cell = fluent_wait.until(
                EC.presence_of_element_located((By.XPATH, "//table/tbody/tr[1]/td[1]"))
            )
            
            print(f"   ✅ Table cell found!")
            print(f"   📝 Cell text: '{table_cell.text}'")
            print(f"   ⏱️ Poll frequency: 0.5 seconds")
            print(f"   ⏱️ Timeout: 10 seconds")
            print(f"   ✅ Ignored exceptions: NoSuchElementException")
        except Exception as e:
            print(f"   ⚠️ Table cell not found, trying alternative...")
            try:
                # Try alternative XPath
                table_cell = fluent_wait.until(
                    EC.presence_of_element_located((By.XPATH, "//table/tbody/tr/td"))
                )
                print(f"   ✅ Table cell found! Text: '{table_cell.text}'")
            except Exception as e2:
                print(f"   ❌ Table not found: {str(e2)[:80]}")
        
        print("\n" + "=" * 70)
        print("✅ WAIT SHOWCASE COMPLETED!")
        print("=" * 70)
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)[:200]}")
    finally:
        driver.quit()


if __name__ == "__main__":
    print("=" * 70)
    print("HANDS-ON 5: LOCATORS & EXPLICIT WAITS")
    print("Target: LambdaTest Selenium Playground")
    print("=" * 70)
    
    print("\n--- Running Locator Strategies Showcase ---")
    run_locator_showcase()
    
    print("\n--- Running Wait Verification Showcase ---")
    run_waits_showcase()
    
    print("\n" + "=" * 70)
    print("✅ ALL TESTS COMPLETED!")
    print("=" * 70)