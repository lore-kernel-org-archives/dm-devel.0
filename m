From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation
 failure
Date: Tue, 26 Sep 2017 13:55:13 +0000
Message-ID: <1506434112.3787.4.camel@wdc.com>
References: <20170922013506.22510-1-ming.lei@redhat.com>
         <1506092775.2512.5.camel@wdc.com> <20170922174431.GA21108@ming.t460p>
         <1506102888.2512.9.camel@wdc.com> <20170925030641.GB7090@ming.t460p>
         <1506352994.2641.4.camel@wdc.com> <20170925161014.GB16470@ming.t460p>
         <20170925161702.GA29036@redhat.com> <20170926085007.GD518@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170926085007.GD518@ming.t460p>
Content-Language: en-US
Content-ID: <5A3EEBDC1EBE9D48A59DAF6EB964B6C8@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE3LTA5LTI2IGF0IDE2OjUwICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gSWYg
eW91IGRvbid0IGNvbnNpZGVyIHRvIGNoYW5nZSBtcGF0aCBpbnRvIGJsb2NrIGluIC5xdWV1ZV9y
cSgpIG5vdywNCj4gcGxlYXNlIHRha2UgdGhpcyBwYXRjaCBmaXJzdCwgYW5kIEkgYW0gc3VyZSB0
aGlzIHdheSBpcyBjb3JyZWN0LCBhbmQNCj4gZXZlbiBpdCBjYW4gYmUgdGhvdWdodCBhcyBhIGZp
eC4NCg0KQXMgSSBleHBsYWluZWQgZWFybGllciwgaXQgd291bGQgYmUgd3JvbmcgdG8gdGFrZSB0
aGlzIHBhdGNoIHVwc3RyZWFtIHdpdGhvdXQNCmhhdmluZyB0ZXN0ZWQgYW5kIG1lYXN1cmVkIHRo
ZSBhbHRlcm5hdGl2ZSBJIGhhZCBwcm9wb3NlZCBmaXJzdA0KKGh0dHBzOi8vd3d3LnNwaW5pY3Mu
bmV0L2xpc3RzL2RtLWRldmVsL21zZzMyMjgyLmh0bWwpLiBNeSBhbHRlcm5hdGl2ZSBoYW5kbGVz
DQpTQ1NJIGhvc3RzIHdpdGggbXVsdGlwbGUgTFVOcyBwcm9wZXJseSBidXQgdGhlIHBhdGNoIGF0
IHRoZSBzdGFydCBvZiB0aGlzDQplLW1haWwgdGhyZWFkIG5vdC4NCg0KQmFydC4=
