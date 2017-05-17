From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] libmultipath: print.c: make sure lines
 are 0-terminated
Date: Wed, 17 May 2017 16:07:42 +0200
Message-ID: <c506de64-440b-5655-fcdb-7e38cf176ec7@suse.de>
References: <20170517135439.25935-1-mwilck@suse.com>
	<20170517135439.25935-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517135439.25935-2-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

SGkgTWFydGluLAoKT24gMDUvMTcvMjAxNyAwMzo1NCBQTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+
IFVuZGVyIGNlcnRhaW4gY29uZGl0aW9ucywgdGhlIG91dHB1dCBvZiAibXVsdGlwYXRoIC1sbCIg
b3IKPiAibXVsdGlwYXRoZCBzaG93IHRvcG9sb2d5Iiwgb3IgdGhlIG11bHRpcGF0aGQgbG9ncywg
bWF5Cj4gY29udGFpbiBnYXJiYWdlIGNoYXJhY3RlcnMuIEZpeCB0aGF0IGJ5IG1ha2luZyBzdXJl
IHRoYXQKPiB0aGUgc3RyaW5ncyBhcmUgYWx3YXlzIHByb3Blcmx5IHplcm8tdGVybWluYXRlZC4K
PiAKPiBOb3RlIDE6IFRoZSB3YXkgdGhpcyBpcyBjb2RlZCwgdGhlIHByZXZpb3VzbHkgd3JpdHRl
bgo+IGNoYXJhY3RlciBpcyBvdmVyd3JpdHRlbiBieSB0aGUgbmV3bGluZS4gVGhhdCBiZWhhdmlv
ciBpcwo+IHVuY2hhbmdlZCBieSB0aGlzIHBhdGNoLiBJIGRpZG4ndCB3YW50IHRvIGZ1enogd2l0
aCB0aGUKPiBjYXJlZnVsbHkgY3JhZnRlZCBwcmludC5jIGNvZGUgbW9yZSB0aGFuIG5lY2Vzc2Fy
eSBhdAo+IHRoaXMgcG9pbnQuCj4gCj4gTm90ZSAyOiBUaGUgY29uZGl0aW9uIChjIDw9IGxpbmUg
KyBsZW4gLSAxKSBpcyBlcXVpdmFsZW50IHRvCj4gKFRBSUwgPj0gMCkuIEl0IHNob3VsZCBhbHdh
eXMgaG9sZCB0aGUgd2F5IEVORExJTkUgaXMgY2FsbGVkCj4gYWZ0ZXIgUFJJTlQgYW5kIFBBRCBp
biBwcmludC5jLCBhbmQgaXMgb25seSBhZGRlZCBhcyBhbgo+IGFkZGl0aW9uYWwgc2FmZWd1YXJk
LCBlLmcuIGFnYWluc3QgZnV0dXJlIGNvZGUgY2hhbmdlcy4KCl5eIE1pc3NpbmcgUy1vLWIKCgot
LSAKSm9oYW5uZXMgVGh1bXNoaXJuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgU3RvcmFnZQpqdGh1bXNoaXJuQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICs0OSA5MTEgNzQwNTMgNjg5ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwg
OTA0MDkgTsO8cm5iZXJnCkdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdy
YWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCktleSBmaW5nZXJwcmludCA9IEVD
MzggOUNBQiBDMkM0IEYyNUQgODYwMCBEMEQwIDAzOTMgOTY5RCAyRDc2IDA4NTAKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
