From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/10] kpartx: avoid ioctl error for loop
	devices
Date: Thu, 11 May 2017 11:33:39 +0200
Message-ID: <1494495219.6093.8.camel@suse.com>
References: <20170505220559.7248-1-mwilck@suse.com>
	<20170505220559.7248-3-mwilck@suse.com>
	<20170508204611.GE22856@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508204611.GE22856@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gTW9uLCAyMDE3LTA1LTA4IGF0IDE1OjQ2IC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gZG1fbm9fcGFydGl0aW9ucygpIGNoZWNrcyBpZiBmZWF0dXJlcyBpbmNsdWRlcyAibm9f
cGFydGl0aW9ucyIsIGJ1dAo+IHRoZQo+IHVwc3RyZWFtIGtlcm5lbCBkb2Vzbid0IGFsbG93IHRo
YXQgZmVhdHVyZS7CoMKgVGhlIHBhdGNoIHRvIGFkZCBpdCBnb3QKPiBOQUtlZCB3aGVuIEhhbm5l
cyBwb3N0ZWQgaXQsIElJUkMuIFRoYXQncyB3aHkgSSB3ZW50IHRoZSByb3V0ZSBvZgo+IHVzaW5n
Cj4gdWRldiBmbGFncyB0byBhdm9pZCBydW5uaW5nIGtwYXJ0eC7CoMKgVW5sZXNzIFNVU0UgKG9y
IHNvbWUgb3RoZXIKPiBkaXN0cm8pCj4gaXMgdXNpbmcgdGhlICJub19wYXJ0aXRpb25zIiBwYXRj
aCBpbiB0aGVpciBrZXJuZWwsIHdlIGNhbiBwdWxsIHRoZQo+IGRtX25vX3BhcnRpdGlvbnMgY29k
ZSBjb21wbGV0ZWx5Lgo+IAo+IElmIHlvdSdyZSBzdGlsbCB1c2luZyBpdCwgSSdtIGZpbmUgd2l0
aCB0aGlzIHBhdGNoLgoKVGhlIFNVU0Uga2VybmVsIHN1cHBvcnRzIHRoaXMgZmVhdHVyZS4gQnV0
IGFmdGVyIGRpc2N1c3Npbmcgd2l0aApIYW5uZXMsIEkgc2VlIG5vIHByb2JsZW0gd2l0aCByZW1v
dmluZyBpdCBmcm9tIHVwc3RyZWFtIG11bHRpcGF0aC10b29scyAKYW5kIG1ha2luZyBpdCBhIFNV
U0Utc3BlY2lmaWMgZmVhdHVyZSBpbiBvdXIgY29kZSBiYXNlLgoKTWFydGluCgotLSAKRHIuIE1h
cnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLsKgKzQ5ICgwKTkxMSA3NDA1MyAyMTA3
ClNVU0VMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCAg
R3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbA==
