From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
Date: Mon, 11 Nov 2019 07:56:12 +0100
Message-ID: <e5d0a5c6-0a6e-fea9-0d19-42b42bb63499@suse.de>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
 <20191111023930.638129-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191111023930.638129-9-damien.lemoal@wdc.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

T24gMTEvMTEvMTkgMzozOSBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gVGhlcmUgaXMgbm8g
bmVlZCB0byBhcmJpdHJhcmlseSBsaW1pdCB0aGUgc2l6ZSBvZiBhIHJlcG9ydCB6b25lIHRvIHRo
ZQo+IG51bWJlciBvZiB6b25lcyBkZWZpbmVkIGJ5IFNEX1pCQ19SRVBPUlRfTUFYX1pPTkVTLiBS
YXRoZXIsIHNpbXBseQo+IGNhbGN1bGF0ZSB0aGUgcmVwb3J0IGJ1ZmZlciBzaXplIG5lZWRlZCBm
b3IgdGhlIHJlcXVlc3RlZCBudW1iZXIgb2YKPiB6b25lcyB3aXRob3V0IGV4Y2VlZGluZyB0aGUg
ZGV2aWNlIHRvdGFsIG51bWJlciBvZiB6b25lcy4gVGhpcyBidWZmZXIKPiBzaXplIGxpbWl0YXRp
b24gdG8gdGhlIGhhcmR3YXJlIG1heGltdW0gdHJhbnNmZXIgc2l6ZSBhbmQgcGFnZSBtYXBwaW5n
Cj4gY2FwYWJpbGl0aWVzIGlzIGtlcHQgdW5jaGFuZ2VkLiBTdGFydGluZyB3aXRoIHRoaXMgaW5p
dGlhbCBidWZmZXIgc2l6ZSwKPiB0aGUgYWxsb2NhdGlvbiBpcyBvcHRpbWl6ZWQgYnkgaXRlcmF0
aW5nIG92ZXIgZGVjcmVhc2luZyBidWZmZXIgc2l6ZQo+IHVudGlsIHRoZSBhbGxvY2F0aW9uIHN1
Y2NlZWRzIChlYWNoIGl0ZXJhdGlvbiBpcyBhbGxvd2VkIHRvIGZhaWwgZmFzdAo+IHVzaW5nIHRo
ZSBfX0dGUF9OT1JFVFJZIGZsYWcpLiBUaGlzIGVuc3VyZXMgZm9yd2FyZCBwcm9ncmVzcyBmb3Ig
em9uZQo+IHJlcG9ydHMgYW5kIGF2b2lkcyBmYWlsdXJlcyBvZiB6b25lcyByZXZhbGlkYXRpb24g
dW5kZXIgbWVtb3J5IHByZXNzdXJlLgo+IAo+IFdoaWxlIGF0IGl0LCBhbHNvIHJlcGxhY2UgdGhl
IGhhcmQgY29kZWQgNTEyIEIgc2VjdG9yIHNpemUgd2l0aCB0aGUKPiBTRUNUT1JfU0laRSBtYWNy
by4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMu
Y29tPgo+IC0tLQo+ICBkcml2ZXJzL3Njc2kvc2RfemJjLmMgfCAyNCArKysrKysrKysrKysrLS0t
LS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9u
cygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVl
cnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgIFRlYW1sZWFkIFN0b3Jh
Z2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEg
NzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0
ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAyNDcxNjUgKEFHIE3DvG5jaGVuKSwgR0Y6IEZlbGl4
IEltZW5kw7ZyZmZlcgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LWYyZnMtZGV2ZWwgbWFpbGluZyBsaXN0CkxpbnV4LWYyZnMtZGV2ZWxAbGlz
dHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8vbGlzdHMuc291cmNlZm9yZ2UubmV0L2xpc3RzL2xp
c3RpbmZvL2xpbnV4LWYyZnMtZGV2ZWwK
