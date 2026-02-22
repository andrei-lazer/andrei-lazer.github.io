import { eleventyImageTransformPlugin } from "@11ty/eleventy-img";
import footnote_plugin from 'markdown-it-footnote';
import mila from "markdown-it-link-attributes";
import eleventyNavigationPlugin from "@11ty/eleventy-navigation";
import { feedPlugin } from "@11ty/eleventy-plugin-rss";

export default async function(eleventyConfig) {
    // Order matters, put this at the top of your configuration file.
    eleventyConfig.setInputDirectory("src");
    eleventyConfig.setQuietMode(true);
    eleventyConfig.addPassthroughCopy("src/assets")
    eleventyConfig.addPassthroughCopy("src/assets/docs")
    eleventyConfig.addPassthroughCopy("src/style")
    eleventyConfig.addPassthroughCopy("src/assets");
    eleventyConfig.addPassthroughCopy("src/scripts");
    eleventyConfig.addPassthroughCopy("src/robots.txt");

    eleventyConfig.addPlugin(eleventyImageTransformPlugin, {
        formats: ["webp", "gif"],
        sharpOptions: {
            animated: true
        },
    });
	eleventyConfig.addPlugin(eleventyNavigationPlugin);

    eleventyConfig.amendLibrary("md", (mdLib) => mdLib
        .use(footnote_plugin)
        .use(mila, {
            matcher(href, config) {
                return href.startsWith("https:");
            },
            attrs: {
                target: "_blank",
                rel: "noopener",
                class: "external"
            },
        })
    );

    eleventyConfig.addCollection("posts", function(collectionApi) {
        return collectionApi.getFilteredByGlob("src/posts/**/*.md");
    })


    eleventyConfig.addFilter("formatDate", (dateObj) => {
        const d = new Date(dateObj);
        const month = d.toLocaleString("en-US", { month: "long" });
        const year = d.getFullYear();
        return `${month} ${year}`;
    });

    // RSS config
    eleventyConfig.addPlugin(feedPlugin, {
		type: "atom", // or "rss", "json"
		outputPath: "/feed.xml",
		collection: {
			name: "posts", // iterate over `collections.posts`
			limit: 0,     // 0 means no limit
		},
		metadata: {
			language: "en",
			title: "andrei's posts",
			subtitle: "blog posts and projects abound maths, computer science, and languages.",
			base: "https://andreilazer.me/",
			author: {
				name: "Andrei Lazer",
				email: "andrei.lucian.lazer@gmail.com",
			}
		}
	});


    return {
        markdownTemplateEngine: "njk", // <-- use Nunjucks for Markdown
        htmlTemplateEngine: "njk",     // <-- use Nunjucks for HTML
        templateFormats: ["html", "njk", "md"], // include your template formats
    };
};

