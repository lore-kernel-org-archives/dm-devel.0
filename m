From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 5/6] mpathpersist: fix registration rollback
	issue
Date: Wed, 10 Oct 2018 21:38:51 +0200
Message-ID: <25635f0dffb42200c4300f838c67e03600b40be3.camel@suse.com>
References: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
	<1539194473-6243-6-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539194473-6243-6-git-send-email-bmarzins@redhat.com>
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

T24gV2VkLCAyMDE4LTEwLTEwIGF0IDEzOjAxIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gV2hlbiBtcGF0aHBlcnNpc3QgdHJpZXMgdG8gcm9sbGJhY2sgdGhlIHJlZ2lzdHJhdGlv
biwgaXQgY29waWVzCj4gdGhlIFNBUksgdG8gdGhlIFJLLCBhbmQgY2xlYXJzIHRoZSBTQVJLLiBI
b3dldmVyLCBpdCByZXBlYXRlZCB0aGlzCj4gc3RlcAo+IGZvciBlYWNoIHRocmVhZC4gVGhpcyBt
ZWFucyB0aGF0IHRoZSBmaXJzdCByb2xsYmFjayB0aHJlYWQgY29ycmVjdGx5Cj4gaGFkIHRoZSBS
SyBzZXQgdG8gdGhlIFNBUksgdXNlZCBkdXJpbmcgcmVnaXN0cmF0aW9uLiBIb3dldmVyLCBpZiBt
b3JlCj4gdGhhbiBvbmUgcmVnaXN0cmF0aW9uIG5lZWRlZCB0byBiZSByb2xsZWQgYmFjaywgbGF0
ZXIgdGhyZWFkcyB3b3VsZAo+IGhhdmUKPiBib3RoIHRoZSBSSyBhbmQgU0FSSyBjbGVhcmVkLiBU
aGlzIGNvbW1pdCBmaXhlcyB0aGF0IGJ5IG9ubHkgY29weWluZwo+IGFuZAo+IGNsZWFyaW5nIHRo
ZSBTQVJLIG9uY2UuCj4gCj4gU2lnbmVkLW9mZi1ieTogQmVuamFtaW4gTWFyemluc2tpIDxibWFy
emluc0ByZWRoYXQuY29tPgoKUmV2aWV3ZWQtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2Uu
Y29tPgoKLS0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgw
KTkxMSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwg
SmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
