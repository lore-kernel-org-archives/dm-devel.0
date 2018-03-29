From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 17/20] multipath.rules: find_multipaths
	"smart" logic
Date: Thu, 29 Mar 2018 11:15:08 +0200
Message-ID: <1522314908.3669.4.camel@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-18-mwilck@suse.com>
	<20180327210339.GX3103@octiron.msp.redhat.com>
	<1522186440.13140.47.camel@suse.com>
	<20180327230706.GY3103@octiron.msp.redhat.com>
	<1522248672.5251.25.camel@suse.com>
	<20180329080437.51205fda@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180329080437.51205fda@pentland.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTAzLTI5IGF0IDA4OjA0ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
Cj4gCj4gPiBUaGUgb25seSB3YXkgSSBzZWUgdG8gYXZvaWQgdGhpcyBpcyB0byB0cnkgY2FsbGlu
ZyBvcGVuKE9fRVhDTCkgb24KPiA+IHRoZQo+ID4gcGF0aCBkZXZpY2UgaW4gIm11bHRpcGF0aCAt
dSIuIFNvIGZhciB3ZSd2ZSBhdm9pZGVkIHRoYXQgYmVjYXVzZQo+ID4gaXQncwo+ID4gbm90IGNv
bXBsZXRlbHkgcmFjZS1mcmVlLiBCdXQgd2UncmUgbm90IHRhbGtpbmcgYWJvdXQgYSByYWNlIGhl
cmUsCj4gPiBidXQKPiA+IGEgc2l0dWF0aW9uIHdoZXJlIHNvbWUgZW50aXR5IGdyYWJiZWQgYSBk
ZXZpY2UgYmVmb3JlIHBpdm90LXJvb3QuCj4gPiBTbyB3ZSBjb3VsZCBhdHRlbXB0IG9wZW4oT19F
WENMKSBvbmx5IGluIHRoZSAiaXMgbWF5YmUgYSB2YWxpZAo+ID4gcGF0aCIKPiA+IGNhc2UsIGFu
ZCBvbmx5IHJldHVybiAibWF5YmUiIGlmIHRoYXQgb3BlbiBzdWNjZWVkcy4gT3RoZXJ3aXNlIHdl
J2QKPiA+IHJldHVybiAibm8iLCBhcyB3ZSBhbHJlYWR5IGNoZWNrZWQgdGhhdCB0aGUgZGV2aWNl
IGlzbid0IGN1cnJlbnRseQo+ID4gcGFydCBvZiBhIG11bHRpcGF0aCBtYXAuCj4gPiAKPiAKPiBI
by1odW0uCj4gCj4gV2F0Y2ggb3V0IHdoZW4geW91IGRvIHRoaXM7IHN5c3RlbWQgd2lsbCBnZW5l
cmF0ZSBhbm90aGVyIGV2ZW50Cj4gd2hlbmV2ZXIgeW91IGNsb3NlIHRoaXMgZmQsIGFuZCBzdWRk
ZW5seSB5b3UgZmluZCB5b3Vyc2VsZiBpbiBhCj4gbWlkZGxlCj4gb2YgYW4gZXZlbnQgc3Rvcm0g
Li4uCgpUaGFua3MgZm9yIG1lbnRpb25pbmcgdGhhdC4KClVkZXYgbGlzdGVucyBmb3IgaW5vdGlm
eSBldmVudHMgZm9yICJjbG9zZSBhZnRlciB3cml0ZSIuIFdlIHdpbGwgZG8gdGhlCnRlc3Qgd2l0
aCBPX1JET05MWXxPX0VYQ0wsIHNvIG5vIGV2ZW50IHNob3VsZCBiZSBnZW5lcmF0ZWQuIE1vcmVv
dmVyLApldmVudHMgc2hvdWxkIG9ubHkgb2NjdXIgaWYgdWRldiBpcyB3YXRjaGluZyB0aGUgZGV2
aWNlLCB3aGljaApzaG91bGRuJ3QgYmUgdGhlIGNhc2Ugd2hpbGUgYW4gZXZlbnQgaXMgcHJvY2Vz
c2VkIChidXQgSSdtIG5vdCAxMDAlCmNlcnRhaW4gYWJvdXQgdGhhdCkuIEFueXdheSwgSSdsbCB0
ZXN0IHRoaXMuCiAKQ2hlZXJzLApNYXJ0aW4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tA
c3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdG
OiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIx
Mjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
