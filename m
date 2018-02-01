From: Hannes Reinecke <hare@suse.de>
Subject: Re: Regression introduced with commit 2a0b4682e09d76
 ("dm: convert dm_dev_internal.count from atomic_t to refcount_t)
Date: Thu, 1 Feb 2018 17:16:42 +0100
Message-ID: <efb3fff2-f777-fe96-bfda-d67b39b578c2@suse.de>
References: <ac8161a5-22b7-4e3a-ad19-a300f1a0ee74@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac8161a5-22b7-4e3a-ad19-a300f1a0ee74@email.android.com>
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

T24gMDIvMDEvMjAxOCAwNDowMyBQTSwgTWlrZSBTbml0emVyIHdyb3RlOgo+IFByZXR0eSBzdXJl
IHRoYXQgcmVncmVzc2lvbiB3YXMgYWxyZWFkeSBmaXhlZC4KPiAKPiBXaGljaCBjb2RlIGFyZSB5
b3UgbG9va2luZyBhdD8KPiAKVGhpcyBpcyBhY3R1YWxseSBjb21pbmcgZnJvbSBta3AgNC4xNi9z
Y3NpLWZpeGVzIHRyZWU7IG1pZ2h0IGJlIHRoYXQKeW91J3ZlIGZpeGVkIGl0IHVwIGluIHRoZSBt
ZWFudGltZS4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAgVGVh
bWxlYWQgU3RvcmFnZSAmIE5ldHdvcmtpbmcKaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBO
w7xybmJlcmcKR0Y6IEYuIEltZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEouIEd1aWxkLCBELiBV
cG1hbnl1LCBHLiBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
