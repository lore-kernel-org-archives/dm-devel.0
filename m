From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V3] multipathd: release uxsocket and resource
 when cancel thread
Date: Tue, 16 Jan 2018 14:19:20 +0100
Message-ID: <1516108760.23203.3.camel@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342957D1C@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342957D1C@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE4LTAxLTE2IGF0IDExOjQ4ICswMDAwLCBXdWNob25neXVuIHdyb3RlOgo+IEhp
IE1hcnRpbiwKPiBTb3JyeSB0byBmb3JnZXQgdGhhdCwgYWN0dWFsbHkgSSBmb3VuZCB0aGF0IGRl
YWRfY2xpZW50KCkgd2lsbCBub3QgYmUKPiBpbnRlcnJ1cHQgYnkgdGhyZWFkIGNhbmNsZSwgYmVj
YXVzZSBhZnRlciBhbGwgZGVhZF9jbGllbnQoKSBjYWxsaW5nCj4gcG9pbnQgYmUgZG9uZSB0aGVu
IGhhbmRsZV9zaWduYWxzKCkgaGF2ZSBjaGFuY2UgdG8gYmUgY2FsbGVkIGJ5Cj4gdXhzb2NrX2xp
c3RlbigpIHdoaWNoIHdpbGwgY2FsbCBleGl0X2RhZW1vbigpIGFuZCBzZW5kIAo+IGNhbmNlbCB0
aHJlYWRzIHNpZ25hbCB0byBhbGwgY2hpbGQgcHJvY2VzcyBpbmNsdWRlIHV4bHNuci4KCkZhaXIg
ZW5vdWdoLgoKPiBCdXQgeW91ciBjb21tZW50cyBpcyBnb29kIGNhbiBtYWtlIGNvZGUgbW9yZSBz
YWZlci4gQmVsb3cgaXMgdGhlIG5ldwo+IHBhdGNoLCBwbGVhc2UgaGF2ZSBhIGxvb2ssIHRoYW5r
cy4KCkkgdGhpbmsgaXQncyByZWFsbHkgc2FmZXIgd2hpcyB3YXksIHNob3VsZCBhbnlvbmUgc2Vl
IHRoZSBuZWVkIHRvCmNhbmNlbCB0aGUgbGlzdGVuZXIgdGhyZWFkIGZyb20gYW5vdGhlciBwb2lu
dCBpbiB0aGUgY29kZS4KClRoZSBwYXRjaCBpcyBsb29rcyBnb29kIG5vdy4KClJldmlld2VkLWJ5
OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KCi0tIApEci4gTWFydGluIFdpbGNrIDxt
d2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdt
YkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24K
SFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=
