From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v4 10/20] libmultipath: indicate wwid failure
 in dm_addmap_create()
Date: Fri, 13 Apr 2018 00:43:44 +0200
Message-ID: <1523573024.4346.122.camel@suse.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-11-mwilck@suse.com>
	<20180412183343.GM3103@octiron.msp.redhat.com>
	<1523564202.4346.29.camel@suse.com> <1523564539.4346.34.camel@suse.com>
	<20180412213211.GA3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180412213211.GA3103@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTA0LTEyIGF0IDE2OjMyIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gT24gVGh1LCBBcHIgMTIsIDIwMTggYXQgMTA6MjI6MTlQTSArMDIwMCwgTWFydGluIFdp
bGNrIHdyb3RlOgo+ID4gCj4gPiBCdXQgSSBzdXBwb3NlIEknbSBzdGlsbCBtaXNzaW5nIHlvdXIg
cG9pbnQuCj4gCj4gQW55IGZhaWx1cmUgaW4gZXZfYWRkX3BhdGgoKSBiZWZvcmUgdGhlIGNhbGwg
dG8gZG9tYXAoKSBjb3VsZCBjYXVzZQo+IG11bHRpcGF0aCBkZXZpY2UgY3JlYXRpb24gdG8gZmFp
bCwgd2l0aG91dCB0cmlnZ2VyaW5nIHRoaXMuIEZvcgo+IGluc3RhbmNlCj4gYWRkX21hcF93aXRo
X3BhdGgoKSBvciBzZXR1cF9tYXAoKSBjYW4gZmFpbCBmb3IgYSBob3N0IG9mIHJlYXNvbnMuCgpP
SywgZ290IGl0LCBmaW5hbGx5LiBUaGUgc2VtYW50aWNzIG9mIG15IGZhaWxlZCBtYXJrZXIgd2Vy
ZSBpbnRlbmRlZCB0bwpiZSBleGFjdGx5IHdoYXQgdGhleSBhcmUgbm93OiB3ZSB0cmllZCBETV9E
RVZJQ0VfQ1JFQVRFIGZvciB0aGlzIFdXSUQsCmFuZCBmYWlsZWQuIE90aGVyIHNlbWFudGljcyBh
cmUgY2VydGFpbmx5IHBvc3NpYmxlLCBidXQgbXVjaCBoYXJkZXIgdG8KZGVmaW5lIGNsZWFubHku
CgpJIGJlbGlldmUgdGhhdCBjYXRjaGVzIGEgbGFyZ2UgcG9ydGlvbiBvZiB0aGUgcmVhbC13b3Js
ZCBmYWlsdXJlcy4gQW5kCmluIG1hbnkgY2FzZXMsIHRoaXMgZmFpbHVyZSBtZWFucyB0aGF0IG9u
ZSBvciBtb3JlIGRldmljZXMgYXJlIGJ1c3kuCihPaCwgaXQgY291bGQgYWxzbyBtZWFuIHRoYXQg
d2UgdHJpZWQgdG8gc2V0ICdod2hhbmRsZXIgIjEgYWx1YSInIGZvciBhCmRldmljZSB0aGF0IGRv
ZXNuJ3Qgc3VwcG9ydCBBTFVBLCBidXQgSSBkaWdyZXNzIDstKQoKTWFydGluCgotLSAKRHIuIE1h
cnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcK
U1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBH
cmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs
