import { eleventyImageTransformPlugin } from "@11ty/eleventy-img";
import eleventyNavigationPlugin from "@11ty/eleventy-navigation";
import { feedPlugin } from "@11ty/eleventy-plugin-rss";

import footnote_plugin from 'markdown-it-footnote';
import mila from "markdown-it-link-attributes";
import markdownItGitHubAlerts from "markdown-it-github-alerts";
import markdownItMathjax3 from "markdown-it-mathjax3";

import interlinker from "@photogabble/eleventy-plugin-interlinker";
import callouts from "markdown-it-obsidian-callouts";




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

    eleventyConfig.addPlugin(interlinker, {
        defaultLayout: "layouts/embed.liquid", // only needed if you use ![[note]] transclusion
        deadLinkReport: "none"
    });
    eleventyConfig.amendLibrary("md", (md) => md.use(callouts));

    eleventyConfig.amendLibrary("md", (mdLib) => mdLib
        .use(footnote_plugin)
        .use(markdownItMathjax3)
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

    eleventyConfig.addCollection("cards", function(collectionApi) {
        return collectionApi.getFilteredByGlob("src/cards/**/*.md");
    })


    eleventyConfig.addFilter("formatDate", (dateObj) => {
        const d = new Date(dateObj);
        const month = d.toLocaleString("en-US", { month: "long" });
        const year = d.getFullYear();
        return `${month} ${year}`;
        return d.toISOString().slice(0, 10);
    });

    // RSS config
    eleventyConfig.addPlugin(feedPlugin, {
		type: "atom", // or "rss", "json"
		outputPath: "/feed.xml",
		collection: {
			name: "cards", // iterate over `collections.posts`
			limit: 0,     // 0 means no limit
		},
		metadata: {
			language: "en",
			title: "andrei's cards",
			base: "https://andreilazer.me/",
			author: {
				name: "Andrei Lazer",
				email: "andrei.lucian.lazer@gmail.com",
			}
		}
	});

    // render images from wikilinks properly (find and replace, may be fragile)
    eleventyConfig.addPreprocessor("obsidianImages", "md", (data, content) =>
        content.replace(
            /!\[\[([^\]|]+?\.(?:png|jpe?g|gif|svg|webp|avif|bmp))(?:\|([^\]]+))?\]\]/gi,
            (_, file, opt) => {
                const width = /^\d+$/.test(opt ?? "") ? opt : null;
                const alt = (width ? "" : opt?.trim()) || file.trim();
                return `<img src="/assets/${encodeURIComponent(file.trim())}" alt="${alt}"${width ? ` width="${width}"` : ""}>`;
            }
        )
    );




    return {
        markdownTemplateEngine: "njk", // <-- use Nunjucks for Markdown
        htmlTemplateEngine: "njk",     // <-- use Nunjucks for HTML
        templateFormats: ["html", "njk", "md"], // include your template formats
    };
};

