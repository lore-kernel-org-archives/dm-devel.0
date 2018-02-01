From: Hannes Reinecke <hare@suse.de>
Subject: Re: Regression introduced with commit 2a0b4682e09d76
 ("dm: convert dm_dev_internal.count from atomic_t to refcount_t)
Date: Thu, 1 Feb 2018 18:54:46 +0100
Message-ID: <81cf1309-b3c5-1170-9a06-02e0288eb223@suse.de>
References: <ac8161a5-22b7-4e3a-ad19-a300f1a0ee74@email.android.com>
	<efb3fff2-f777-fe96-bfda-d67b39b578c2@suse.de>
	<20180201164002.GA30734@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180201164002.GA30734@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gMDIvMDEvMjAxOCAwNTo0MCBQTSwgTWlrZSBTbml0emVyIHdyb3RlOgo+IE9uIFRodSwgRmVi
IDAxIDIwMTggYXQgMTE6MTZhbSAtMDUwMCwKPiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5k
ZT4gd3JvdGU6Cj4gCj4+IE9uIDAyLzAxLzIwMTggMDQ6MDMgUE0sIE1pa2UgU25pdHplciB3cm90
ZToKPj4+IFByZXR0eSBzdXJlIHRoYXQgcmVncmVzc2lvbiB3YXMgYWxyZWFkeSBmaXhlZC4KPj4+
Cj4+PiBXaGljaCBjb2RlIGFyZSB5b3UgbG9va2luZyBhdD8KPj4+Cj4+IFRoaXMgaXMgYWN0dWFs
bHkgY29taW5nIGZyb20gbWtwIDQuMTYvc2NzaS1maXhlcyB0cmVlOyBtaWdodCBiZSB0aGF0Cj4+
IHlvdSd2ZSBmaXhlZCBpdCB1cCBpbiB0aGUgbWVhbnRpbWUuCj4gCj4gUGxlYXNlIHNlZToKPiBo
dHRwOi8vZ2l0Lmtlcm5lbC5vcmcvbGludXMvYWZjNTY3YTQ5NzdiMmQ3OThlMDUxNTNkZDEzMWEz
YzhkNDc1OGMwYwo+IApBaC4gVEhYLgoKTWF5YmUgSSBzaG91bGQgdGFsayB0byBta3AgdG8gdXBk
YXRlIHRoZSB0cmVlLgoKQW55d2F5LCB0aGFua3MgZm9yIHRoZSBwb2ludGVyLgoKQ2hlZXJzLAoK
SGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0
d29ya2luZwpoYXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApT
VVNFIExJTlVYIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1l
bmTDtnJmZmVyLCBKLiBTbWl0aGFyZCwgSi4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpI
UkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==
