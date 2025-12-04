from playwright.sync_api import sync_playwright

# Example: Testing a skills repository viewer web application
# This is unique to the skills repository and demonstrates testing
# a webapp that displays and filters skill information

url = "http://localhost:3000"  # Skills repo viewer URL

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(viewport={"width": 1920, "height": 1080})

    # Navigate to skills viewer
    page.goto(url)
    page.wait_for_load_state("networkidle")

    # Test 1: Verify skills are loaded
    print("Test 1: Checking if skills are displayed...")
    skill_cards = page.locator('[data-testid="skill-card"]').all()
    print(f"✓ Found {len(skill_cards)} skill cards")

    # Test 2: Search functionality
    print("\nTest 2: Testing search functionality...")
    page.fill('input[placeholder*="Search"]', "kubernetes")
    page.wait_for_timeout(500)
    filtered_cards = page.locator('[data-testid="skill-card"]').all()
    print(f"✓ After searching 'kubernetes': {len(filtered_cards)} results")

    # Test 3: Category filtering
    print("\nTest 3: Testing category filters...")
    page.click("text=Troubleshooting")
    page.wait_for_timeout(500)
    troubleshoot_cards = page.locator('[data-testid="skill-card"]').all()
    print(f"✓ Troubleshooting category: {len(troubleshoot_cards)} skills")

    # Test 4: Verify specific skills are present
    print("\nTest 4: Verifying expected skills...")
    expected_skills = [
        "kubernetes-troubleshoot",
        "writing-plans",
        "test-driven-development",
    ]
    page.click("text=All Skills")  # Reset filter
    page.fill('input[placeholder*="Search"]', "")  # Clear search
    page.wait_for_timeout(500)

    for skill_name in expected_skills:
        skill_visible = page.locator(f'text="{skill_name}"').is_visible()
        status = "✓" if skill_visible else "✗"
        print(f"{status} Skill '{skill_name}' found: {skill_visible}")

    # Test 5: Skill detail view
    print("\nTest 5: Testing skill detail navigation...")
    page.click('text="brainstorming"')
    page.wait_for_timeout(500)
    detail_visible = page.locator('[data-testid="skill-detail"]').is_visible()
    print(f"✓ Skill detail view displayed: {detail_visible}")

    # Capture screenshots
    page.screenshot(path="/tmp/skills_viewer_overview.png", full_page=True)
    print("\n✓ Screenshot saved to /tmp/skills_viewer_overview.png")

    browser.close()

print("\n✅ Skills repository viewer tests completed!")
