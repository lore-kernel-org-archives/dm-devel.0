From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Mon, 13 Jun 2016 23:59:20 +0000
Message-ID: <1465861755.3504.185.camel@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
Content-Language: en-US
Content-ID: <DF5A1A6EBDFA55499CE1E49E24D9B5DD@NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-kernel-owner@vger.kernel.org
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gTW9uLCAyMDE2LTA2LTEzIGF0IDE2OjE4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFRoYW5rcyBUb3NoaSENCj4gDQo+IE9uIE1vbiwgSnVuIDEzLCAyMDE2IGF0IDM6MjEgUE0sIFRv
c2hpIEthbmkgPHRvc2hpLmthbmlAaHBlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gVGhpcyBwYXRj
aC1zZXQgYWRkcyBEQVggc3VwcG9ydCB0byBkZXZpY2UtbWFwcGVyIGRtLWxpbmVhciBkZXZpY2Vz
DQo+ID4gdXNlZCBieSBMVk0uwqDCoEl0IHdvcmtzIHdpdGggTFZNIGNvbW1hbmRzIGFzIGZvbGxv
d3M6DQo+ID4gwqAtIENyZWF0aW9uIG9mIGEgbG9naWNhbCB2b2x1bWUgd2l0aCBhbGwgREFYIGNh
cGFibGUgZGV2aWNlcyAoc3VjaA0KPiA+IMKgwqDCoGFzIHBtZW0pIHNldHMgdGhlIGxvZ2ljYWwg
dm9sdW1lIERBWCBjYXBhYmxlIGFzIHdlbGwuDQo+ID4gwqAtIE9uY2UgYSBsb2dpY2FsIHZvbHVt
ZSBpcyBzZXQgdG8gREFYIGNhcGFibGUsIHRoZSB2b2x1bWUgbWF5IG5vdA0KPiA+IMKgwqDCoGJl
IGV4dGVuZGVkIHdpdGggbm9uLURBWCBjYXBhYmxlIGRldmljZXMuDQo+DQo+IEkgZG9uJ3QgbWlu
ZCB0aGlzLCBidXQgaXQgc2VlbXMgYSBwb2xpY3kgZGVjaXNpb24gdGhhdCB0aGUga2VybmVsIGRv
ZXMNCj4gbm90IG5lZWQgdG8gbWFrZS7CoMKgQSBzdWZmaWNpZW50bHkgc29waGlzdGljYXRlZCB1
c2VyIGNvdWxkIGNvcGUgd2l0aA0KPiBEQVggYmVpbmcgYXZhaWxhYmxlIGF0IHZhcnlpbmcgTEJB
cy7CoMKgV291bGQgaXQgYmUgc3VmZmljaWVudCB0byBtb3ZlDQo+IHRoaXMgcG9saWN5IGRlY2lz
aW9uIHRvIHVzZXJzcGFjZSB0b29saW5nPw0KDQpJIHRoaW5rIHRoaXMgaXMgYSBrZXJuZWwgcmVz
dHJpY3Rpb24uIMKgV2hlbiBhIGJsb2NrIGRldmljZSBpcyBkZWNsYXJlZCBhcw0KREFYIGNhcGFi
bGUsIGl0IHNob3VsZCBtZWFuIHRoYXQgdGhlIHdob2xlIGRldmljZSBpcyBEQVggY2FwYWJsZS4g
wqBTbywgSQ0KdGhpbmsgd2UgbmVlZCB0byBhc3N1cmUgdGhlIHNhbWUgdG8gYSBtYXBwZWQgZGV2
aWNlLg0KDQpJbiBMVk0gbGV2ZWwsIGEgdm9sdW1lIGdyb3VwIG1heSBjb250YWluIGJvdGggREFY
IGFuZCBub24tREFYIGNhcGFibGUNCmRldmljZXMuIMKgVGhlcmUgaXMgbm8gcmVzdHJpY3Rpb24g
Zm9yIGNyZWF0aW5nL2V4dGVuZGluZyBhIHZvbHVtZSBncm91cC4NCg0KPiA+IFRoZSBkaXJlY3Rf
YWNjZXNzIGludGVyZmFjZSBpcyBhZGRlZCB0byBkbSBhbmQgZG0tbGluZWFyIHRvIG1hcA0KPiA+
IGEgcmVxdWVzdCB0byBhIHRhcmdldCBkZXZpY2UuDQo+DQo+IEkgaGFkIGRtLWxpbmVhciBhbmQg
bWQtcmFpZDAgc3VwcG9ydCBvbiBteSBsaXN0IG9mIHRoaW5ncyB0byBsb29rIGF0LA0KPiBkaWQg
eW91IGhhdmUgcmFpZDAgaW4geW91ciBwbGFucz8NCg0KWWVzLCBJIGhvcGUgdG8gZXh0ZW5kIGZ1
cnRoZXIgYW5kIHJhaWQwIGlzIGEgZ29vZCBjYW5kaWRhdGUuIMKgwqANCg0KVGhhbmtzLA0KLVRv
c2hpDQo=
