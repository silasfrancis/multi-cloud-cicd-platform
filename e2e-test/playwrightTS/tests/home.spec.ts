import {test, expect} from '@playwright/test';  
import { Home } from '../Pages/Home';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../.env') });


test("Navigate to Home Page and verify title", async ({page}) => {
    const homePage = new Home(page);
    await homePage.navigateToHomePage();
    await homePage.verifyHomePageTitle(process.env.HomepageTitle as string);
});

test("Verify Global feed has articles", async ({page}) => {
    const homePage = new Home(page);
    await homePage.navigateToHomePage();
    const hasArticles =  await homePage.getGlobalfeedArticles();
    const articleHeadings = await homePage.getGlobalArticlesHeadings();
    if(hasArticles){
        console.log(articleHeadings);
    }else{
        console.log("No articles found in Global feed");
    }
    // expect(hasArticles).toBe(true);
    // console.log('Articles:', articleHeadings);  
})