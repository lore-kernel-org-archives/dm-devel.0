From: Martin Wilck <mwilck@suse.com>
Subject: Re: multipath-tools: add ANA support for NVMe device
Date: Tue, 13 Nov 2018 07:59:30 +0100
Message-ID: <194b0202a660044a75c3751abc3295707c8d29e4.camel@suse.com>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
	<2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
	<20181112215323.GA7983@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181112215323.GA7983@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, mwilck@suse.com
Cc: lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, chengjike.cheng@huawei.com, linux-nvme@lists.infradead.org, dm-devel@redhat.com, wangzhoumengjian@huawei.com, shenhong09@huawei.com, sschremm@netapp.com
List-Id: dm-devel.ids

T24gTW9uLCAyMDE4LTExLTEyIGF0IDE2OjUzIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4g
Cj4gSSAoYW5kIG90aGVycykgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8gYXQgbGVhc3QgdHJpcGxl
IGNoZWNrIHdpdGggdGhlCj4gTlZNZSBkZXZlbG9wZXJzIChub3cgY2MnZCkgdG8gc2VlIGlmIHdl
IGNvdWxkIGdldCBhZ3JlZW1lbnQgb24gdGhlCj4gbnZtZQo+IGRyaXZlciBwcm92aWRpbmcgdGhl
IEFOQSBzdGF0ZSB2aWEgc3lzZnMgKHdoZW4gbW9kcGFyYW0KPiBudm1lX2NvcmUubXVsdGlwYXRo
PU4gaXMgc2V0KSwgbGlrZSBIYW5uZXMgcHJvcG9zZWQgaGVyZToKPiBodHRwOi8vbGlzdHMuaW5m
cmFkZWFkLm9yZy9waXBlcm1haWwvbGludXgtbnZtZS8yMDE4LU5vdmVtYmVyLzAyMDc2NS5odG1s
Cj4gCj4gVGhlbiB0aGUgdXNlcnNwYWNlIG11bHRpcGF0aC10b29scyBBTkEgc3VwcG9ydCBjb3Vs
ZCBqdXN0IHJlYWQgc3lzZnMKPiByYXRoZXIgdGhhbiByZWludmVudCBoYXJ2ZXN0aW5nIHRoZSBB
TkEgc3RhdGUgdmlhIGlvY3RsLgoKSWYgc29tZSBrZXJuZWxzIGV4cG9zZSB0aGUgc3lzZnMgYXR0
cmlidXRlcyBhbmQgc29tZSBkb24ndCwgd2hhdCBhcmUgd2UKc3VwcG9zZWQgdG8gZG8/IEluIG9y
ZGVyIHRvIGJlIHBvcnRhYmxlLCBtdWx0aXBhdGgtdG9vbHMgKGFuZCBvdGhlcgp1c2VyIHNwYWNl
IHRvb2xzLCBmb3IgdGhhdCBtYXR0ZXIpIG5lZWQgdG8gc3VwcG9ydCBib3RoLCBhbmQgbWFpbnRh
aW4KbXVsdGlwbGUgY29kZSBwYXRocy4gSnVzdCBsaWtlIFNDU0kgOi0pCgpJJ2QgcmVhbGx5IGxp
a2UgdG8gc2VlIHRoaXMgYWJzdHJhY3RlZCBhd2F5IHdpdGggYSAibGlibnZtZSIgKHlvdSBuYW1l
Cml0KSwgd2hpY2ggdXNlciBzcGFjZSB0b29scyBjb3VsZCBzaW1wbHkgY2FsbCB3aXRob3V0IGhh
dmluZyB0byB3b3JyeQpob3cgaXQgYWN0dWFsbHkgdGFsa3MgdG8gdGhlIGtlcm5lbC4KCk1hcnRp
bgoKLS0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkx
MSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFu
ZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
