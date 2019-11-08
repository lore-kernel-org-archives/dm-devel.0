From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/9] null_blk: clean up the block device
 operations
Date: Fri, 8 Nov 2019 08:17:47 +0100
Message-ID: <f34d71a6-0181-8901-b1c6-e85fde9e1235@suse.de>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191108015702.233102-6-damien.lemoal@wdc.com>
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
cGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiAKPiBSZW1vdmUgdGhlIHBvaW50bGVzcyBzdHViIG9w
ZW4gYW5kIHJlbGVhc2UgbWV0aG9kcywgZ2l2ZSB0aGUgb3BlcmF0aW9ucwo+IHZlY3RvciBhIHNs
aWdodGx5IGxlc3MgY29uZnVzaW5nIG5hbWUsIGFuZCB1c2Ugbm9ybWFsIGFsaWdubWVudCBmb3Ig
dGhlCj4gYXNzaWdubWVudCBvcGVyYXRvcnMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3Bo
IEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gU2lnbmVkLW9mZi1ieTogRGFtaWVuIExlIE1vYWwgPGRh
bWllbi5sZW1vYWxAd2RjLmNvbT4KPiAtLS0KPiAgZHJpdmVycy9ibG9jay9udWxsX2Jsa19tYWlu
LmMgfCAxOSArKysrLS0tLS0tLS0tLS0tLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDE1IGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxo
YXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAg
ICAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAg
ICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1h
bnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAyNDcxNjUgKEFHIE3D
vG5jaGVuKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LWYyZnMtZGV2ZWwgbWFpbGluZyBsaXN0Ckxp
bnV4LWYyZnMtZGV2ZWxAbGlzdHMuc291cmNlZm9yZ2UubmV0Cmh0dHBzOi8vbGlzdHMuc291cmNl
Zm9yZ2UubmV0L2xpc3RzL2xpc3RpbmZvL2xpbnV4LWYyZnMtZGV2ZWwK
