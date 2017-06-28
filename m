From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-raid: Do not call BUG() in
	__rdev_sectors()
Date: Wed, 28 Jun 2017 10:04:11 +0200
Message-ID: <17a2cd24-225e-a168-3160-d3b3e1cc7d45@suse.de>
References: <1498636503-22484-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498636503-22484-1-git-send-email-hare@suse.de>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

T24gMDYvMjgvMjAxNyAwOTo1NSBBTSwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+IF9fcmRldl9z
ZWN0b3JzKCkgbWlnaHQgYmUgY2FsbGVkIGZvciBhbiBpbnZhbGlkL25vbi1leGlzdGluZwo+IFJB
SUQgc2V0IGR1cmluZyByYWlkX2N0cigpLCB3aGljaCBpcyBwZXJmZWN0bHkgZmluZSBhbmQgbm8K
PiByZWFzb24gdG8gcGFuaWMuCj4gCj4gU2lnbmVkLW9mZi1ieTogSGFubmVzIFJlaW5lY2tlIDxo
YXJlQHN1c2UuY29tPgo+IC0tLQo+ICBkcml2ZXJzL21kL2RtLXJhaWQuYyAgICAgICAgICB8IDMg
KystCj4gIGRyaXZlcnMvc2NzaS9wbWNyYWlkLmMgICAgICAgIHwgMiArLQo+ICBkcml2ZXJzL3Nj
c2kvcWxhNHh4eC9xbDRfb3MuYyB8IDIgKy0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pCj4gCkduYWEuIFRob3NlIGJpdHMgc2hvdWxkbid0IGJlIGhl
cmUuCldpbGwgYmUgcmVzZW5kaW5nLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJl
aW5lY2tlCQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2luZwpoYXJlQHN1c2UuZGUJCQkg
ICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJTlVYIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBKLiBTbWl0aGFyZCwg
Si4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
