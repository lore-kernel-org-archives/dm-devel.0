From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/4] libmultipath: add_feature: skip
	pointless NULL check
Date: Tue, 29 Aug 2017 09:21:57 +0200
Message-ID: <1503991317.4528.0.camel@suse.com>
References: <20170828220536.13208-1-mwilck@suse.com>
	<20170828220536.13208-2-mwilck@suse.com>
	<59b6a581-78e2-1020-a85e-bb7a151b8986@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <59b6a581-78e2-1020-a85e-bb7a151b8986@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gVHVlLCAyMDE3LTA4LTI5IGF0IDA4OjM3ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
Cj4gT24gMDgvMjkvMjAxNyAxMjowNSBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+ID4gVGhlIGNh
c2UgZiA9PSBOVUxMIGlzIGFscmVhZHkgaGFuZGxlZCBieSB0aGUgY29kZSBmcm9tCj4gPiBiMWVj
ZGQ0NmI2ZWMgInNlZ21lbnQgZmF1bHR5IG9jY3VyZWQgaW4gYWRkX2ZlYXR1cmUoKSIgYWJvdmUu
Cj4gPiAKPiA+IAo+IEF0IG9uZSBwb2ludCB3ZSBzaG91bGQgaGF2ZSBhIHRlc3QgY2FzZSBmb3Ig
YWRkaW5nL3JlbW92aW5nCj4gZmVhdHVyZXMuLi4KCkknbSBhY3R1YWxseSB3b3JraW5nIG9uIGl0
LgoKTWFydGluCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiAr
NDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJm
ZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJn
KQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
