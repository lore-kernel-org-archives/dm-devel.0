From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] null_blk: clean up report zones
Date: Fri, 8 Nov 2019 08:18:14 +0100
Message-ID: <176bf3c7-dde3-42b0-2f82-21489d0213f5@suse.de>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191108015702.233102-7-damien.lemoal@wdc.com>
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

T24gMTEvOC8xOSAyOjU2IEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBGcm9tOiBDaHJpc3Rv
cGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiAKPiBNYWtlIHRoZSBpbnN0YW5jZSBuYW1lIG1hdGNo
IHRoZSBtZXRob2QgbmFtZSBhbmQgZGVmaW5lIHRoZSBuYW1lIHRvIE5VTEwKPiBpbnN0ZWFkIG9m
IHByb3ZpZGluZyBhbiBpbmxpbmUgc3R1Yiwgd2hpY2ggaXMgcmF0aGVyIHBvaW50bGVzcyBmb3Ig
YQo+IG1ldGhvZCBjYWxsLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPgo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2Fs
QHdkYy5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvYmxvY2svbnVsbF9ibGsuaCAgICAgICB8IDExICsr
Ky0tLS0tLS0tCj4gIGRyaXZlcnMvYmxvY2svbnVsbF9ibGtfbWFpbi5jICB8ICAyICstCj4gIGRy
aXZlcnMvYmxvY2svbnVsbF9ibGtfem9uZWQuYyB8ICA0ICsrLS0KPiAgMyBmaWxlcyBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVz
IFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMg
UmVpbmVja2UJCSAgICAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5k
ZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29s
dXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAy
NDcxNjUgKEFHIE3DvG5jaGVuKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LWYyZnMtZGV2ZWwgbWFp
bGluZyBsaXN0CkxpbnV4LWYyZnMtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8v
bGlzdHMuc291cmNlZm9yZ2UubmV0L2xpc3RzL2xpc3RpbmZvL2xpbnV4LWYyZnMtZGV2ZWwK
