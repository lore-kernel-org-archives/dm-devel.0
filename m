From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/3] multipathd: move __setup_multipath to
 multipathd
Date: Mon, 19 Mar 2018 14:07:42 +0100
Message-ID: <1521464862.3798.50.camel@suse.com>
References: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
	<1521235867-29476-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521235867-29476-3-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAzLTE2IGF0IDE2OjMxIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gX19zZXR1cF9tdWx0aXBhdGggaXMgb25seSBjYWxsZWQgZnJvbSBtdWx0aXBhdGhkLCBz
byBpdCBzaG91bGRuJ3QgYmUKPiBpbgo+IGxpYm11bHRpcGF0aC4gIE1vdmUgaXQsIHVwZGF0ZV9t
dWx0cGF0aCAod2hpY2ggY2FsbHMgaXQpIGFuZAo+IHNldF9ub19wYXRoX3JldHJ5ICh3aGljaCBp
cyBhIGhlbHBlciBmdW5jdGlvbiBmb3IgaXQpIGludG8KPiBtdWx0aXBhdGhkLgo+IE5vbmUgb2Yg
dGhlc2UgZnVuY3Rpb25zIHdlcmUgY2hhbmdlZCwgb25seSBjb3BpZWQuCj4gCj4gU2lnbmVkLW9m
Zi1ieTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgoKT25lIGRheSB3
ZSBtYXkgbmVlZCB0byBzcGxpdCB1cCBtdWx0aXBhdGhkL21haW4uYyBhIGJpdC4uLgoKQWNrZWQt
Ynk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgoKLS0gCkRyLiBNYXJ0aW4gV2lsY2sg
PG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGludXgg
R21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRv
bgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==
