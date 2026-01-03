import { defineConfig, Locator } from '@playwright/test';
import {test, expect} from '@playwright/test';
import { Page } from '@playwright/test';

export class Home {

        readonly global_feed: Locator;
        readonly global_feed_articles: Locator;
        readonly global_feed_article_headings: Locator;


    constructor(public page:Page) {
        this.global_feed = page.locator("//a[normalize-space()='Global Feed']");
        this.global_feed_articles = page.locator("(//div[@class='article-preview'])");
        this.global_feed_article_headings = page.locator("app-article-preview a.preview-link h1");
    }

    async navigateToHomePage() {
        await this.page.goto('/');
    }

    async verifyHomePageTitle(expectedTitle: string) {
        await expect(this.page).toHaveTitle(expectedTitle);
    }

    async getGlobalfeedArticles(): Promise<boolean> {
        await this.global_feed.click();
        const articlesCount = await this.global_feed_articles.count();
        return articlesCount > 0;
    }

    async getGlobalArticlesHeadings(): Promise<string[]> {
        await this.global_feed.click();
        const articleHeadings: string[] = await this.global_feed_article_headings.allTextContents();
        return articleHeadings.map(heading => heading.trim());
    }

}