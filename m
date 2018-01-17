From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4] multipathd: release uxsocket and resource
 when cancel thread
Date: Wed, 17 Jan 2018 08:39:27 +0100
Message-ID: <1516174767.3303.4.camel@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342958024@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342958024@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

SGkgV3VjaG9uZ3l1biwKCmFub3RoZXIgdGhpbmcgb2NjdXJlZCB0byBtZToKCk9uIFdlZCwgMjAx
OC0wMS0xNyBhdCAwMjozMyArMDAwMCwgV3VjaG9uZ3l1biB3cm90ZToKPiAgCj4gIHZvaWQgdXhz
b2NrX2NsZWFudXAodm9pZCAqYXJnKQo+ICB7Cj4gKwlzdHJ1Y3QgY2xpZW50ICpjbGllbnRfbG9v
cDsKPiArCXN0cnVjdCBjbGllbnQgKmNsaWVudF90bXA7Cj4gKwlpbnQgdXhfc29jayA9IChpbnQp
YXJnOwo+ICsKPiArCXB0aHJlYWRfbXV0ZXhfbG9jaygmY2xpZW50X2xvY2spOwo+ICsJbGlzdF9m
b3JfZWFjaF9lbnRyeV9zYWZlKGNsaWVudF9sb29wLCBjbGllbnRfdG1wLCAmY2xpZW50cywKPiBu
b2RlKSB7Cj4gKwkJX2RlYWRfY2xpZW50KGNsaWVudF9sb29wKTsKPiArCX0KPiArCXB0aHJlYWRf
bXV0ZXhfdW5sb2NrKCZjbGllbnRfbG9jayk7Cj4gKwo+ICsJY2xvc2UodXhfc29jayk7Cj4gKwoK
V291bGQgaXQgbWFrZSBzZW5zZSB0byBtb3ZlIHRoZSBjbG9zZSh1eF9zb2NrKSBjYWxsIGZ1cnRo
ZXIgdXAKdG8gYXZvaWQgbmV3IGNsaWVudHMgdHJ5aW5nIHRvIGNvbm5lY3Q/CgpNYXJ0aW4KCi0t
IApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQw
NTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21p
dGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
