From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
Date: Fri, 8 Nov 2019 08:20:20 +0100
Message-ID: <80bfc0e8-860d-3c11-07f4-08b7dd7fada4@suse.de>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191108015702.233102-9-damien.lemoal@wdc.com>
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

T24gMTEvOC8xOSAyOjU3IEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBUaGVyZSBpcyBubyBu
ZWVkIHRvIGFyYml0cmFyaWx5IGxpbWl0IHRoZSBzaXplIG9mIGEgcmVwb3J0IHpvbmUgdG8gdGhl
Cj4gbnVtYmVyIG9mIHpvbmVzIGRlZmluZWQgYnkgU0RfWkJDX1JFUE9SVF9NQVhfWk9ORVMuIFJh
dGhlciwgc2ltcGx5Cj4gY2FsY3VsYXRlIHRoZSByZXBvcnQgYnVmZmVyIHNpemUgbmVlZGVkIGZv
ciB0aGUgcmVxdWVzdGVkIG51bWJlciBvZgo+IHpvbmVzIHdpdGhvdXQgZXhjZWVkaW5nIHRoZSBk
ZXZpY2UgdG90YWwgbnVtYmVyIG9mIHpvbmVzLiBUaGlzIGJ1ZmZlcgo+IHNpemUgbGltaXRhdGlv
biB0byB0aGUgaGFyZHdhcmUgbWF4aW11bSB0cmFuc2ZlciBzaXplIGFuZCBwYWdlIG1hcHBpbmcK
PiBjYXBhYmlsaXRpZXMgaXMga2VwdCB1bmNoYW5nZWQuIFN0YXJ0aW5nIHdpdGggdGhpcyBpbml0
aWFsIGJ1ZmZlciBzaXplLAo+IHRoZSBhbGxvY2F0aW9uIGlzIG9wdGltaXplZCBieSBpdGVyYXRp
bmcgb3ZlciBkZWNyZWFzaW5nIGJ1ZmZlciBzaXplCj4gdW50aWwgdGhlIGFsbG9jYXRpb24gc3Vj
Y2VlZHMuIFRoaXMgZW5zdXJlcyBmb3J3YXJkIHByb2dyZXNzIGZvciB6b25lCj4gcmVwb3J0cyBh
bmQgYXZvaWRzIGZhaWx1cmVzIG9mIHpvbmVzIHJldmFsaWRhdGlvbiB1bmRlciBtZW1vcnkgcHJl
c3N1cmUuCj4gCj4gV2hpbGUgYXQgaXQsIGFsc28gcmVwbGFjZSB0aGUgaGFyZCBjb2RlZCA1MTIg
QiBzZWN0b3Igc2l6ZSB3aXRoIHRoZQo+IFNFQ1RPUl9TSVpFIG1hY3JvLgo+IAo+IFNpZ25lZC1v
ZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQHdkYy5jb20+Cj4gLS0tCj4gIGRy
aXZlcnMvc2NzaS9zZF96YmMuYyB8IDIyICsrKysrKysrKysrLS0tLS0tLS0tLS0KPiAgMSBmaWxl
IGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1i
eTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRy
LiBIYW5uZXMgUmVpbmVja2UJCSAgICAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhh
cmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5i
ZXJnCkhSQiAyNDcxNjUgKEFHIE3DvG5jaGVuKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LWYyZnMt
ZGV2ZWwgbWFpbGluZyBsaXN0CkxpbnV4LWYyZnMtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0
Cmh0dHBzOi8vbGlzdHMuc291cmNlZm9yZ2UubmV0L2xpc3RzL2xpc3RpbmZvL2xpbnV4LWYyZnMt
ZGV2ZWwK
