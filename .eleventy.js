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
        formats: ["gif", "webp"],
        sharpOptions: {
            animated: true
        },
    });
};
