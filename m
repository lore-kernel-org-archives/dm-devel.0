From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 10/23] libmultipath: add
	vector_free_const()
Date: Tue, 6 Mar 2018 08:08:56 +0100
Message-ID: <16a3e3e0-22ce-ce73-3566-1d46dc3257e5@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-11-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-11-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IC4uLiB0byBkaXNw
b3NlIG9mIGNvbnN0YW50IHZlY3RvcnMgKGNvbnN0IHN0cnVjdCBfdmVjdG9yKikuCj4gCj4gU2ln
bmVkLW9mZi1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cj4gUmV2aWV3ZWQtYnk6
IEJlbmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4KPiAtLS0KPiAgbGlibXVs
dGlwYXRoL3ZlY3Rvci5oIHwgMSArCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+
IAo+IGRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvdmVjdG9yLmggYi9saWJtdWx0aXBhdGgvdmVj
dG9yLmgKPiBpbmRleCA1Y2ZkNGQwNjA0MTIuLjNmNmU1NzlhZTE5YSAxMDA2NDQKPiAtLS0gYS9s
aWJtdWx0aXBhdGgvdmVjdG9yLmgKPiArKysgYi9saWJtdWx0aXBhdGgvdmVjdG9yLmgKPiBAQCAt
NDYsNiArNDYsNyBAQCB0eXBlZGVmIHN0cnVjdCBfdmVjdG9yICp2ZWN0b3I7Cj4gIGV4dGVybiB2
ZWN0b3IgdmVjdG9yX2FsbG9jKHZvaWQpOwo+ICBleHRlcm4gdm9pZCAqdmVjdG9yX2FsbG9jX3Ns
b3QodmVjdG9yIHYpOwo+ICBleHRlcm4gdm9pZCB2ZWN0b3JfZnJlZSh2ZWN0b3Igdik7Cj4gKyNk
ZWZpbmUgdmVjdG9yX2ZyZWVfY29uc3QoeCkgdmVjdG9yX2ZyZWUoKHZlY3RvcikobG9uZykoeCkp
Cj4gIGV4dGVybiB2b2lkIGZyZWVfc3RydmVjKHZlY3RvciBzdHJ2ZWMpOwo+ICBleHRlcm4gdm9p
ZCB2ZWN0b3Jfc2V0X3Nsb3QodmVjdG9yIHYsIHZvaWQgKnZhbHVlKTsKPiAgZXh0ZXJuIHZvaWQg
dmVjdG9yX2RlbF9zbG90KHZlY3RvciB2LCBpbnQgc2xvdCk7Cj4gClJldmlld2VkLWJ5OiBIYW5u
ZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5u
ZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5k
ZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwgTWF4
ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNtaXRo
YXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwgRy4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5i
ZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
