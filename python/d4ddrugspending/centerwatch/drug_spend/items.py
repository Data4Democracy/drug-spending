# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class Drug(scrapy.Item):
    name = scrapy.Field()
    company = scrapy.Field()
    approval_status = scrapy.Field()
    specific_treatment = scrapy.Field()
    therapeutic_areas = scrapy.Field()
    general_info = scrapy.Field()
    clinical_results = scrapy.Field()
    side_effects = scrapy.Field()
    mechanism = scrapy.Field()
    additional_info = scrapy.Field()
