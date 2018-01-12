From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 19:53:25 +0000
Message-ID: <AT5PR8401MB0387801D9DC1686503921AE5AB170@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180111060159.12991-1-ming.lei@redhat.com>
         <20180111220742.GA31944@redhat.com>
 <1515710256.2752.72.camel@sandisk.com>
         <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
         <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>         <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>         <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com> <1515783288.2396.37.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1515783288.2396.37.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtYmxvY2stb3du
ZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtYmxvY2stDQo+IG93bmVyQHZnZXIua2Vy
bmVsLm9yZ10gT24gQmVoYWxmIE9mIEJhcnQgVmFuIEFzc2NoZQ0KLi4uDQo+IFRoZSBpbnRlbnRp
b24gb2YgY29tbWl0IDYwNzdjMmQ3MDYwOTdjMCB3YXMgdG8gYWRkcmVzcyB0aGUgbGFzdCBtZW50
aW9uZWQNCj4gY2FzZS4gSXQgbWF5IGJlIHBvc3NpYmxlIHRvIG1vdmUgdGhlIGRlbGF5ZWQgcXVl
dWUgcmVydW4gZnJvbSB0aGUNCj4gZG1fcXVldWVfcnEoKSBpbnRvIGRtX3JlcXVldWVfb3JpZ2lu
YWxfcmVxdWVzdCgpLiBCdXQgSSB0aGluayBpdCB3b3VsZCBiZQ0KPiB3cm9uZyB0byByZXJ1biB0
aGUgcXVldWUgaW1tZWRpYXRlbHkgaW4gY2FzZSBhIFNDU0kgdGFyZ2V0IHN5c3RlbSByZXR1cm5z
DQo+ICJCVVNZIi4NCg0KU2VlaW5nIFNDU0kgQlVTWSBtZW50aW9uZWQgaGVyZS4uLg0KDQpPbiBp
dHMgb3duLCBwYXRjaCA2MDc3YzJkNzA2IHNlZW1zIHRvIGJlIGFkZGluZyBhbiBhcmJpdHJhcmls
eSBzZWxlY3RlZA0KbWFnaWMgdmFsdWUgb2YgMTAwIG1zIHdpdGhvdXQgZXhwbGFuYXRpb24gaW4g
dGhlIHBhdGNoIGRlc2NyaXB0aW9uIG9yDQppbiB0aGUgYWRkZWQgY29kZS4NCg0KQnV0LCBkbV9y
ZXF1ZXN0X29yaWdpbmFsX3JlcXVlc3QoKSBhbHJlYWR5IHNlZW1zIHRvIGhhdmUgY2hvc2VuIHRo
YXQgdmFsdWUNCmZvciBzaW1pbGFyIHB1cnBvc2VzOg0KICAgICAgICB1bnNpZ25lZCBsb25nIGRl
bGF5X21zID0gZGVsYXlfcmVxdWV1ZSA/IDEwMCA6IDA7DQoNClNvLCBtYWtpbmcgdGhlbSBzaGFy
ZSBhICNkZWZpbmUgd291bGQgaW5kaWNhdGUgdGhlcmUncyBhIHJlYXNvbiBmb3IgdGhhdA0KcGFy
dGljdWxhciB2YWx1ZS4gIEFueSBjaGFuZ2UgdG8gdGhlIHZhbHVlIHdvdWxkIGJlIHBpY2tlZCB1
cCBldmVyeXdoZXJlLg0KDQpBbGwgdGhlIG90aGVyIGNhbGxlcnMgb2YgYmxrX21xX2RlbGF5X3J1
bl9od19xdWV1ZSgpIHVzZSBtYWNyb3M6DQpkcml2ZXJzL21kL2RtLXJxLmM6ICAgICAgICAgICAg
IGJsa19tcV9kZWxheV9ydW5faHdfcXVldWUoaGN0eCwgMTAwLyptcyovKTsNCmRyaXZlcnMvbnZt
ZS9ob3N0L2ZjLmM6ICAgICAgICAgYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZShxdWV1ZS0+aGN0
eCwgTlZNRUZDX1FVRVVFX0RFTEFZKTsNCmRyaXZlcnMvc2NzaS9zY3NpX2xpYi5jOiAgICAgICAg
ICAgICAgICBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKGhjdHgsIFNDU0lfUVVFVUVfREVMQVkp
Ow0KZHJpdmVycy9zY3NpL3Njc2lfbGliLmM6ICAgICAgICAgICAgICAgICAgICAgICAgYmxrX21x
X2RlbGF5X3J1bl9od19xdWV1ZShoY3R4LCBTQ1NJX1FVRVVFX0RFTEFZKTsNCg0KVGhvc2UgYm90
aCBoYXBwZW4gdG8gYmUgc2V0IHRvIDMgKG1zKS4NCg0KDQotLS0NClJvYmVydCBFbGxpb3R0LCBI
UEUgUGVyc2lzdGVudCBNZW1vcnkNCg0KDQoNCg==
