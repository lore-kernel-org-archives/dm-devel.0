From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] dm-zoned: Avoid triggering reclaim from inside
 dmz_map()
Date: Thu, 5 Jul 2018 20:01:59 +0000
Message-ID: <6a3ec4d0768c0be014f35eec1c16382f36c6e044.camel@wdc.com>
References: <20180622150911.6066-1-bart.vanassche@wdc.com>
         <alpine.LRH.2.02.1806271106010.21570@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1806271106010.21570@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Content-ID: <37636003E8A2FC4BA42F56B5F15B8F57@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "mpatocka@redhat.com" <mpatocka@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

T24gV2VkLCAyMDE4LTA2LTI3IGF0IDExOjE0IC0wNDAwLCBNaWt1bGFzIFBhdG9ja2Egd3JvdGU6
DQo+IE9LIC0gYnV0IEkgdGhpbmsgYSBwcm9wZXIgZml4IHdvdWxkIGJlIHRvIHByZWFsbG9jYXRl
IHRoZSBjaHVua3MgYW5kIHRoZSANCj4gcmFkaXggdHJlZSB3aGVuIHRoZSBkZXZpY2UgaXMgY3Jl
YXRlZC4NCj4gDQo+IElmIHRoZSBzeXN0ZW0gaXMgaGlnaGx5IHN0cmVzc2VkLCBpdCBtYXkgYmUg
cG9zc2libGUgdGhhdCB0aGUgR0ZQX05PSU8gDQo+IGFsbG9jYXRpb24gd291bGQgd2FpdCBmb3Ig
c29tZSBkYXRhIGJlaW5nIHdyaXR0ZW4gYmFjayAtIGFuZCB0aGUgd3JpdGUgDQo+IGJhY2sgbWF5
IGJlIGRpcmVjdGVkIGJhY2sgdG8gdGhlIGRtLXpvbmVkIGRldmljZSwgd2FpdGluZyBmb3IgdGhl
IEdGUF9OT0lPIA0KPiBhbGxvY2F0aW9uIHRvIHN1Y2NlZWQuDQoNCkhlbGxvIE1pa3VsYXMsDQoN
ClRoYW5rIHlvdSBmb3IgdGhlIGZlZWRiYWNrLiBXZSB3aWxsIGxvb2sgZnVydGhlciBpbnRvIHRo
aXMuDQoNCkJhcnQuDQoNCg0KDQo=
