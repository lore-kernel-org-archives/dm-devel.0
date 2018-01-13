From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Sat, 13 Jan 2018 01:00:57 +0000
Message-ID: <1515805255.2396.94.camel@wdc.com>
References: <20180112014232.GB25090@ming.t460p>
         <20180112015721.GB32298@redhat.com> <20180112033308.GC25090@ming.t460p>
         <20180112171840.GA4541@redhat.com> <1515778013.2396.3.camel@wdc.com>
         <20180112174000.GB5134@redhat.com> <1515779211.2396.11.camel@wdc.com>
         <20180112180635.GD5134@redhat.com> <1515783288.2396.37.camel@wdc.com>
         <AT5PR8401MB0387801D9DC1686503921AE5AB170@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
         <20180113005213.GB7207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180113005213.GB7207@redhat.com>
Content-Language: en-US
Content-ID: <0F71D6578632B54086DB3C2A00361EC9@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>, "elliott@hpe.com" <elliott@hpe.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "axboe@fb.com" <axboe@fb.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAxLTEyIGF0IDE5OjUyIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IEl0IHdhcyA1MCBtcyBiZWZvcmUgaXQgd2FzIDEwMCBtcy4gIE5vIHJlYWwgZXhwbGFpbmF0aW9u
IGZvciB0aGVzZQ0KPiB2YWx1ZXMgb3RoZXIgdGhhbiB0aGV5IHNlZW0gdG8gbWFrZSBCYXJ0J3Mg
SUIgU1JQIHRlc3RiZWQgaGFwcHk/DQoNCkJ1dCB0aGF0IGNvbnN0YW50IHdhcyBub3QgaW50cm9k
dWNlZCBieSBtZSBpbiB0aGUgZG0gY29kZS4gU2VlIGUuZy4gdGhlDQpmb2xsb3dpbmcgY29tbWl0
czoNCg0KY29tbWl0IGQ1NDhiMzRiMDYyYjYwYjRmNGRmMjk1YTBiNDgyM2RmZGExZjFmYzQNCkF1
dGhvcjogTWlrZSBTbml0emVyIDxzbml0emVyQHJlZGhhdC5jb20+DQpEYXRlOiAgIFRodSBNYXIg
NSAyMjoyMToxMCAyMDE1IC0wNTAwDQoNCiAgICBkbTogcmVkdWNlIHRoZSBxdWV1ZSBkZWxheSB1
c2VkIGluIGRtX3JlcXVlc3RfZm4gZnJvbSAxMDBtcyB0byAxMG1zDQogICAgIA0KICAgIENvbW1p
dCA3ZWFjZWFjY2FiICgiYmxvY2s6IHJlbW92ZSBwZXItcXVldWUgcGx1Z2dpbmciKSBkaWRuJ3Qg
anVzdGlmeQ0KICAgIERNJ3MgdXNlIG9mIGEgMTAwbXMgZGVsYXk7IHN1Y2ggYW4gZXh0ZW5kZWQg
ZGVsYXkgaXMgYSBsaWFiaWxpdHkgd2hlbg0KICAgIHRoZXJlIGlzIHJlYXNvbiB0byByZS1raWNr
IHRoZSBxdWV1ZS4NCiAgICAgDQogICAgU2lnbmVkLW9mZi1ieTogTWlrZSBTbml0emVyIDxzbml0
emVyQHJlZGhhdC5jb20+DQoNCmNvbW1pdCA3ZWFjZWFjY2FiNWY0MGJiZmRhMDQ0NjI5YTYyOTg2
MTZhZWFlZDUwDQpBdXRob3I6IEplbnMgQXhib2UgPGpheGJvZUBmdXNpb25pby5jb20+DQpEYXRl
OiAgIFRodSBNYXIgMTAgMDg6NTI6MDcgMjAxMSArMDEwMA0KDQogICAgYmxvY2s6IHJlbW92ZSBw
ZXItcXVldWUgcGx1Z2dpbmcNCiAgICAgDQogICAgQ29kZSBoYXMgYmVlbiBjb252ZXJ0ZWQgb3Zl
ciB0byB0aGUgbmV3IGV4cGxpY2l0IG9uLXN0YWNrIHBsdWdnaW5nLA0KICAgIGFuZCBkZWxheSB1
c2VycyBoYXZlIGJlZW4gY29udmVydGVkIHRvIHVzZSB0aGUgbmV3IEFQSSBmb3IgdGhhdC4NCiAg
ICBTbyBsZXRzIGtpbGwgb2ZmIHRoZSBvbGQgcGx1Z2dpbmcgYWxvbmcgd2l0aCBhb3BzLT5zeW5j
X3BhZ2UoKS4NCiAgICAgDQogICAgU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8amF4Ym9lQGZ1
c2lvbmlvLmNvbT4NCg0KQmFydC4g
