From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2] multipathd: release uxsocket and resource
 when cancel thread
Date: Mon, 15 Jan 2018 11:59:13 +0100
Message-ID: <1516013953.5699.28.camel@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342957B64@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342957B64@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

T24gTW9uLCAyMDE4LTAxLTE1IGF0IDA5OjI1ICswMDAwLCBXdWNob25neXVuIHdyb3RlOgo+IEhp
IE1hcnRpbiwgCj4gVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5ISAgQmVsb3cgaXMgdGhlIG5ldyBw
YXRjaCBhY2NvcmRpbmcgdG8geW91cgo+IGNvbW1lbnRzLCBwbGVhc2UgaGVscCB0byByZXZpZXcg
dGhpcyBwYXRjaCwgdGhhbmtzLgoKQWxtb3N0IHRoZXJlIDotKQoKKwo+ICsJcHRocmVhZF9tdXRl
eF9sb2NrKCZjbGllbnRfbG9jayk7Cj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY2xpZW50
X2xvb3AsIGNsaWVudF90bXAsICZjbGllbnRzLAo+IG5vZGUpIHsKPiArCQlsaXN0X2RlbF9pbml0
KCZjbGllbnRfbG9vcC0+bm9kZSk7Cj4gKwkJY2xvc2UoY2xpZW50X2xvb3AtPmZkKTsKPiArCQlj
bGllbnRfbG9vcC0+ZmQgPSAtMTsKPiArCQlGUkVFKGNsaWVudF9sb29wKTsKPiArCX0KPiArCXB0
aHJlYWRfbXV0ZXhfdW5sb2NrKCZjbGllbnRfbG9jayk7Cj4gCgpGb3IgdGhlIHNha2Ugb2YgZnV0
dXJlIGNvZGUgcmV3b3JrIGFuZCBhdm9pZGluZyBjb2RlIGR1cGxpY2F0aW9uLCBjb3VsZAp5b3Ug
cGxlYXNlIHB1dCB0aGUgY29udGVudCBpbiAgYSBmdW5jdGlvbiBjYWxsZWQgX19kZWFkX2NsaWVu
dCgpIChvcgpzaW1pbGFyKSwgcGxhY2UgdGhhdCBmdW5jdGlvbiByaWdodCBiZWZvcmUgZGVhZF9j
bGllbnQoKSwgY2hhbmdlCmRlYWRfY2xpZW50KCkgdG8gY2FsbCBpdCwgYW5kIHRoZW4gY2FsbCBp
dCBmcm9tIGhlcmUgYXMgd2VsbD8KClNvcnJ5LCBJIHNob3VsZCBoYXZlIHN1Z2dlc3RlZCB0aGF0
IGluIG15IGZpcnN0IHJldmlldyBhbHJlYWR5LgoKTWFydGluCgotLSAKRHIuIE1hcnRpbiBXaWxj
ayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51
eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9y
dG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs
