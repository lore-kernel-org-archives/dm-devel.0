From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipathd: fix inverted signal blocking
 logic
Date: Tue, 06 Mar 2018 09:48:38 +0100
Message-ID: <1520326118.4131.9.camel@suse.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
	<20180302211807.11434-1-mwilck@suse.com>
	<1520026513.2855.30.camel@wdc.com>
	<1520028909.4169.87.camel@suse.com> <1520029421.2855.35.camel@wdc.com>
	<1520032608.4169.91.camel@suse.com> <1520033250.2855.47.camel@wdc.com>
	<1520037092.4169.103.camel@suse.com> <1520267239.2826.17.camel@wdc.com>
	<1520270885.7660.36.camel@suse.com>
	<20180306004610.GM14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306004610.GM14513@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gTW9uLCAyMDE4LTAzLTA1IGF0IDE4OjQ2IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gCj4gVGhpcyBpcyBwcmV0eSBjbG9zZSB0byB3aGF0IEkgaGFkIGluIG1pbmQuIFRoZSBv
bmx5IHRoaW5ncyBtaXNzaW5nLAo+IHRoYXQKPiBJIG5vdGljZWQgd2hlbiBJIHdhcyBsb29raW5n
IGF0IG11bHRpcGF0aGQncyBzaWduYWwgaGFuZGxpbmcsIGlzCj4gZGVhbGluZwo+IHdpdGggU0lH
VVNSMiBpbiBpb19lcnJfc3RhdC5jLCB3aGljaCBpdCBzb3VuZHMgbGlrZSB5b3UgaGF2ZSBhbHJl
YWR5Cj4gc3BvdHRlZCwgYW5kIGNoYW5naW5nIHRoZSBjYWxscyB0byBzZXRpdGltZXIgYW5kIHVz
bGVlcCBvdXRzaWRlIG9mCj4gdGhlCj4gdmVjcyBsb2NrIHRvIHVzZSBuYW5vc2xlZXAsIHNvIHRo
ZXkgZG9uJ3QgaW50ZXJhY3Qgd2l0aCBTSUdBTFJNLgo+IAo+IEknbGwgc2VuZCBhIHBhdGNoIGJh
c2VkIG9uIHlvdXJzLCB0byBmaXggdGhlc2UuCgpJJ20gY3VyaW91cyB0byBzZWUgd2hhdCB5b3Ug
Y29tZSB1cCB3aXRoLiBJJ3ZlIHNvbWV0aGluZyBvbiBteQp3b3JrYmVuY2ggd2hpY2ggc2VlbXMg
dG8gd29yayB3ZWxsIGJ1dCBuZWVkcyBzb21lIGNsZWFudXAuIFRoZSBpZGVhIGlzCnRvIGhhdmUg
YSBkZWRpY2F0ZWQgImFsYXJtIGRpc3BhdGNoZXIiIHRocmVhZCB0aGF0IGRlYWxzIHdpdGgga2Vy
bmVsCnRpbWVycyBleGNsdXNpdmVseSwgYW5kIGZvcndhcmRzIGV4cGlyeSBldmVudHMgdG8gdGhl
IHRocmVhZHMgdGhhdCBoYXZlCmFza2VkIGZvciBpdC4gVGhlIGRpc3BhdGNoZXIgbWFpbnRhaW5z
IGEgbGlzdCBvZiBhY3RpdmUgYWxhcm1zIGFuZCBzZXRzCmEga2VybmVsIHRpbWVyIHRvIHRoZSBl
eHBpcnkgdGltZSBvZiB0aGUgZmlyc3QgYWxhcm0gaW4gdGhlIGxpc3QuCgpDaGVlcnMsCk1hcnRp
bgoKLS0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkx
MSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFu
ZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
