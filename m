From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 1/4] bcache: convert cached_dev.count from atomic_t to
 refcount_t
Date: Mon, 23 Oct 2017 06:45:09 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B802B41FC@IRSMSX102.ger.corp.intel.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-2-git-send-email-elena.reshetova@intel.com>
 <8bd05fae-d41f-24e7-4e58-bf07d9a09a99@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <8bd05fae-d41f-24e7-4e58-bf07d9a09a99@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "koverstreet@google.com" <koverstreet@google.com>, "ejt@redhat.comg" <ejt@redhat.comg>, "snitzer@redhat.com" <snitzer@redhat.com>, "shli@kernel.org" <shli@kernel.org>, "agk@redhat.com" <agk@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "keescook@chromium.org" <keescook@chromium.org>
List-Id: dm-devel.ids

PiBPbiAxMC8yMC8yMDE3IDEyOjM3IEFNLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4gYXRv
bWljX3QgdmFyaWFibGVzIGFyZSBjdXJyZW50bHkgdXNlZCB0byBpbXBsZW1lbnQgcmVmZXJlbmNl
DQo+ID4gY291bnRlcnMgd2l0aCB0aGUgZm9sbG93aW5nIHByb3BlcnRpZXM6DQo+ID4gIC0gY291
bnRlciBpcyBpbml0aWFsaXplZCB0byAxIHVzaW5nIGF0b21pY19zZXQoKQ0KPiA+ICAtIGEgcmVz
b3VyY2UgaXMgZnJlZWQgdXBvbiBjb3VudGVyIHJlYWNoaW5nIHplcm8NCj4gPiAgLSBvbmNlIGNv
dW50ZXIgcmVhY2hlcyB6ZXJvLCBpdHMgZnVydGhlcg0KPiA+ICAgIGluY3JlbWVudHMgYXJlbid0
IGFsbG93ZWQNCj4gPiAgLSBjb3VudGVyIHNjaGVtYSB1c2VzIGJhc2ljIGF0b21pYyBvcGVyYXRp
b25zDQo+ID4gICAgKHNldCwgaW5jLCBpbmNfbm90X3plcm8sIGRlY19hbmRfdGVzdCwgZXRjLikN
Cj4gPg0KPiA+IFN1Y2ggYXRvbWljIHZhcmlhYmxlcyBzaG91bGQgYmUgY29udmVydGVkIHRvIGEg
bmV3bHkgcHJvdmlkZWQNCj4gPiByZWZjb3VudF90IHR5cGUgYW5kIEFQSSB0aGF0IHByZXZlbnRz
IGFjY2lkZW50YWwgY291bnRlciBvdmVyZmxvd3MNCj4gPiBhbmQgdW5kZXJmbG93cy4gVGhpcyBp
cyBpbXBvcnRhbnQgc2luY2Ugb3ZlcmZsb3dzIGFuZCB1bmRlcmZsb3dzDQo+ID4gY2FuIGxlYWQg
dG8gdXNlLWFmdGVyLWZyZWUgc2l0dWF0aW9uIGFuZCBiZSBleHBsb2l0YWJsZS4NCj4gPg0KPiA+
IFRoZSB2YXJpYWJsZSBjYWNoZWRfZGV2LmNvdW50IGlzIHVzZWQgYXMgcHVyZSByZWZlcmVuY2Ug
Y291bnRlci4NCj4gPiBDb252ZXJ0IGl0IHRvIHJlZmNvdW50X3QgYW5kIGZpeCB1cCB0aGUgb3Bl
cmF0aW9ucy4NCj4gPg0KPiA+IFN1Z2dlc3RlZC1ieTogS2VlcyBDb29rIDxrZWVzY29va0BjaHJv
bWl1bS5vcmc+DQo+ID4gUmV2aWV3ZWQtYnk6IERhdmlkIFdpbmRzb3IgPGR3aW5kc29yQGdtYWls
LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSGFucyBMaWxqZXN0cmFuZCA8aXNoa2FtaWVsQGdtYWls
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92
YUBpbnRlbC5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogTWljaGFlbCBMeWxlIDxtbHlsZUBseWxl
Lm9yZz4NCj4gDQo+IFRoYW5rcyBmb3IgdGhpcy0tIEknbSBpbmNsdWRpbmcgaXQgaW4gbXkgdHJl
ZSBmb3IgcG9zc2libGUgaW5jbHVzaW9uIGluDQo+IDQuMTUgKEkndmUgYWxyZWFkeSBzZW50IG15
IG1haW4gY2h1bmsgb2YgY2hhbmdlcyB1cHdhcmRzKS4NCg0KVGhhbmsgeW91IE1pa2UhIEkgYW0g
ZHJvcHBpbmcgdGhlbiB0aGlzIHBhdGNoIGZyb20gbXkgbGlzdCBvZiBtYWludGFpbmVkDQpjb252
ZXJzaW9ucy4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KPiANCj4gTWlrZQ0K
