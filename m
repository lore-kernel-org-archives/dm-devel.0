From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/12] multipath: fix hwhandler check in
	select_action
Date: Thu, 07 Dec 2017 23:09:39 +0100
Message-ID: <1512684579.22250.4.camel@suse.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
	<1512672546-12785-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-4-git-send-email-bmarzins@redhat.com>
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

T24gVGh1LCAyMDE3LTEyLTA3IGF0IDEyOjQ4IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gSWYgdGhlIGV4aXN0aW5nIG11bHRpcGF0aCB0YWJsZSBkb2VzIG5vdCBoYXZlIGEgaGFy
ZHdhcmUgaGFuZGxlciBzZXQsCj4gdGhlbiBldmVuIGlmIHJldGFpbl9od2hhbmRsZXIgaXMgZW5h
YmxlZCBvbiB0aGUgbmV3IHRhYmxlLCBpdCBtYXkKPiBzdGlsbAo+IGJlIHBvc3NpYmxlIHRvIHNl
dCB0aGUgaGFyZHdhcmUgaGFuZGxlciBvbiByZWxvYWQuIFNvLCBhZGRpbmcgYQo+IGhhcmR3YXJl
IGhhbmRsZXIgdG8gdGhlIHRhYmxlIHNob3VsZCB0cmlnZ2VyIGEgcmVsb2FkIGluIHRoaXMgY2Fz
ZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBNYXJ6aW5za2kgPGJtYXJ6aW5zQHJlZGhh
dC5jb20+ClJldmlld2VkLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KCi0tIApE
ci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMg
MjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhh
cmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
