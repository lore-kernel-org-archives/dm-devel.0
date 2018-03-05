From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 5/6] libmultipath: Fix sgio_get_vpd()
Date: Tue, 06 Mar 2018 00:35:43 +0100
Message-ID: <1520292943.7660.61.camel@suse.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
	<20180301192935.14643-6-bart.vanassche@wdc.com>
	<1520268808.7660.23.camel@suse.com> <1520269758.7660.29.camel@suse.com>
	<1520277283.7660.46.camel@suse.com> <1520277522.2826.34.camel@wdc.com>
	<1520282850.7660.49.camel@suse.com> <1520284430.2826.39.camel@wdc.com>
	<1520292243.7660.57.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520292243.7660.57.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE4LTAzLTA2IGF0IDAwOjI0ICswMTAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4g
T24gTW9uLCAyMDE4LTAzLTA1IGF0IDIxOjEzICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gPiBZZXMuICJQQVRDSCB2MiAwMC8yMF0gVmFyaW91cyBtdWx0aXBhdGgtdG9vbHMgZml4ZXMi
IGZmLgo+ID4gPiBodHRwczovL3d3dy5yZWRoYXQuY29tL2FyY2hpdmVzL2RtLWRldmVsLzIwMTgt
SmFudWFyeS9tc2cwMDIxOS5odAo+ID4gPiBtbAo+ID4gCj4gPiBBaCwgdGhhbmtzLCBidXQgdW5m
b3J0dW5hdGVseSB0aGVzZSBwYXRjaGVzIGFyZSBubyBsb25nZXIgaW4gbXkKPiA+IG1haWxib3gu
IEkKPiA+IHB1bGxlZCB0aGVzZSBmcm9tIGh0dHBzOi8vZ2l0aHViLmNvbS9vcGVuU1VTRS9tdWx0
aXBhdGgtdG9vbHMuIEknbQo+ID4gZmluZSB3aXRoCj4gPiBteSBwYXRjaGVzIGJlaW5nIHJlYmFz
ZWQgb24gdG9wIG9mIHlvdXIgc2VyaWVzLCB3aGV0aGVyIG9yIG5vdCB0aGUKPiA+IGZvbGxvd2lu
Zwo+ID4gaXNzdWVzIGdldCBhZGRyZXNzZWQ6CgpJIHB1c2hlZCBteSBsYXRlc3Qgc3RhdGUsIGlu
Y2x1ZGluZyBteSByZWJhc2Ugb2YgeW91ciBwYXRjaGVzLCAKdG8gaHR0cHM6Ly9naXRodWIuY29t
L29wZW5TVVNFL211bHRpcGF0aC10b29scy9jb21taXRzL3Vwc3RyZWFtLXF1ZXVlLgpJIHBsYW4g
dG8gbWVyZ2UgYWxzbyBCZW4ncyBhbmQgQ2hvbmd5dW4ncyBsYXRlIHN1Ym1pc3Npb25zLCBidXQK
SSBkaWRuJ3QgZ2V0IGFyb3VuZCB0byBpdCB5ZXQuCgpSZWdhcmRzLApNYXJ0aW4KCi0tIApEci4g
TWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEw
NwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQs
IEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=
