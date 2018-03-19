From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 3/3] multipathd: stop waiter in
 __setup_multipath
Date: Mon, 19 Mar 2018 14:08:25 +0100
Message-ID: <1521464905.3798.51.camel@suse.com>
References: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
	<1521235867-29476-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521235867-29476-4-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAzLTE2IGF0IDE2OjMxIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gX19zZXR1cF9tdWx0aXBhdGggY2FuIHJlbW92ZSBhIG11bHRpcGF0aCBkZXZpY2UgZnJv
bSBtdWx0aXBhdGhkLCBhbmQKPiBpdAo+IGNhbiBiZSBjYWxsZWQgYnkgZWl0aGVyIGJ5IHRoZSB3
YWl0ZXIgdGhyZWFkIG9yIGFub3RoZXIgdGhyZWFkLgo+IFByZXZpb3VzbHksIGl0IGRlYWx0IHdp
dGggdGhpcyBieSBuZXZlciBzdG9wcGluZyB0aGUgd2FpdGVyCj4gdGhyZWFkLiAgSXQKPiBzaW1w
bHkgcmVsaWVkIG9uIHRoZSB3YWl0ZXIgdGhyZWFkIHRvIG5vdGljZSBhbmQgc3RvcCBpdHNlbGYu
ICBOb3csCj4gd2hlbgo+IGNhbGxlZCBieSBhbm90aGVyIHRocmVhZCwgaXQgZXhwbGljaXRseSBz
dG9wcyB0aGUgd2FpdGVyIHRocmVhZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBNYXJ6
aW5za2kgPGJtYXJ6aW5zQHJlZGhhdC5jb20+CgpSZXZpZXdlZC1ieTogTWFydGluIFdpbGNrIDxt
d2lsY2tAcmVkaGF0LmNvbT4KCi0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4s
IFRlbC4gKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IElt
ZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7D
vHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
