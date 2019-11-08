From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] block: Simplify report zones execution
Date: Fri, 8 Nov 2019 08:12:25 +0100
Message-ID: <c496ebf7-9f1a-7777-b961-378f3155f3fe@suse.de>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191108015702.233102-4-damien.lemoal@wdc.com>
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

T24gMTEvOC8xOSAyOjU2IEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBBbGwga2VybmVsIHVz
ZXJzIG9mIGJsa2Rldl9yZXBvcnRfem9uZXMoKSBhcyB3ZWxsIGFzIGFwcGxpY2F0aW9ucyB1c2UK
PiB0aHJvdWdoIGlvY3RsKEJMS1pPTkVSRVBPUlQpIGV4cGVjdCB0byBwb3RlbnRpYWxseSBnZXQg
bGVzcyB6b25lCj4gZGVzY3JpcHRvcnMgdGhhbiByZXF1ZXN0ZWQuIEFzIHN1Y2gsIHRoZSB1c2Ug
b2YgdGhlIGludGVybmFsIHJlcG9ydAo+IHpvbmVzIGNvbW1hbmQgZXhlY3V0aW9uIGxvb3AgaW1w
bGVtZW50ZWQgYnkgYmxrX3JlcG9ydF96b25lcygpIGlzCj4gbm90IG5lY2Vzc2FyeSBhbmQgY2Fu
IGV2ZW4gYmUgaGFybWZ1bCB0byBwZXJmb3JtYW5jZSBieSBjYXVzaW5nIHRoZQo+IGV4ZWN1dGlv
biBvZiBpbmVmZmljaWVudCBzbWFsbCB6b25lcyByZXBvcnQgY29tbWFuZCB0byBzZXJ2aWNlIHRo
ZQo+IHJlbWluZGVyIG9mIGEgcmVxdWVzdGVkIHpvbmUgYXJyYXkuCj4gCj4gVGhpcyBwYXRjaCBy
ZW1vdmVzIGJsa19yZXBvcnRfem9uZXMoKSwgc2ltcGxpZnlpbmcgdGhlIGNvZGUuIEFsc28KPiBy
ZW1vdmUgYSBub3cgaW5jb3JyZWN0IGNvbW1lbnQgaW4gZG1fYmxrX3JlcG9ydF96b25lcygpLgo+
IAo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQHdkYy5jb20+
Cj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFJldmlld2Vk
LWJ5OiBKYXZpZXIgR29uemFsZXogPGphdmllckBqYXZpZ29uLmNvbT4KPiAtLS0KPiAgYmxvY2sv
YmxrLXpvbmVkLmMgfCAzNCArKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gIGRy
aXZlcnMvbWQvZG0uYyAgIHwgIDYgLS0tLS0tCj4gIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCAzNSBkZWxldGlvbnMoLSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8
aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkg
ICAgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2luZwpoYXJlQHN1c2UuZGUJCQkgICAgICAg
ICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJt
YW55IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMjQ3MTY1IChBRyBN
w7xuY2hlbiksIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1mMmZzLWRldmVsIG1haWxpbmcgbGlzdApM
aW51eC1mMmZzLWRldmVsQGxpc3RzLnNvdXJjZWZvcmdlLm5ldApodHRwczovL2xpc3RzLnNvdXJj
ZWZvcmdlLm5ldC9saXN0cy9saXN0aW5mby9saW51eC1mMmZzLWRldmVsCg==
