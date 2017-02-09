from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors.lxmlhtml import LxmlLinkExtractor
from drug_spend.items import Drug


class Centerwatch(CrawlSpider):
    name = 'centerwatch'

    allowed_domains = ['centerwatch.com']
    start_urls = ["http://www.centerwatch.com/drug-information/fda-approved-drugs/therapeutic-areas"]

    rules = (
        Rule(LxmlLinkExtractor(restrict_xpaths=('.//li/a[contains(@id, "ctl00")]'))
             ),
        Rule(LxmlLinkExtractor(restrict_xpaths=('//div[@id="ctl00_BodyContent_AreaDetails"]')),
             callback='parse_drug'),
        )

    def parse_drug(self, response):
        page = response.xpath('//div[@class="row"]')[3]
        summary_cols = page.xpath('.//div[@id="SummaryColumn"]/div/div/p')

        drug = Drug(
            name=page.xpath('.//h1/text()').extract_first(),
            company=summary_cols[1].xpath('./a/text()').extract_first(),
            approval_status=summary_cols[3].xpath('./text()').extract_first(),
            specific_treatment=summary_cols[5].xpath('./text()').extract_first(),
            therapeutic_areas=summary_cols[7].xpath('./a/text()').extract()
            )

        yield drug
