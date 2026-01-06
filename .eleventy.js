import { eleventyImageTransformPlugin } from "@11ty/eleventy-img";

export default async function(eleventyConfig) {
    // Order matters, put this at the top of your configuration file.
        eleventyConfig.setInputDirectory("src");
    eleventyConfig.setQuietMode(true);
    eleventyConfig.addPassthroughCopy("src/assets")
    eleventyConfig.addPassthroughCopy("src/assets/docs")
    eleventyConfig.addPassthroughCopy("src/style")
    eleventyConfig.addPassthroughCopy("src/assets");
    eleventyConfig.addPassthroughCopy("src/scripts");

    eleventyConfig.addPlugin(eleventyImageTransformPlugin, {
        formats: ["webp", "gif"],
        sharpOptions: {
            animated: true
        },
    });

    eleventyConfig.addCollection("posts", function(collectionApi) {
        return collectionApi.getFilteredByGlob("src/posts/**/*.md");
    })


    eleventyConfig.addFilter("formatDate", (dateObj) => {
        const d = new Date(dateObj);
        const month = d.toLocaleString("en-US", { month: "long" });
        const year = d.getFullYear();
        return `${month} ${year}`;
    });

    return {
        markdownTemplateEngine: "njk", // <-- use Nunjucks for Markdown
        htmlTemplateEngine: "njk",     // <-- use Nunjucks for HTML
        templateFormats: ["html", "njk", "md", "webp"], // include your template formats
    };
};

