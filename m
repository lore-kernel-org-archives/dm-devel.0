From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Setting up LVM cache causes crash
Date: Thu, 30 Oct 2014 18:45:36 -0400
Message-ID: <20141030224536.GC654@redhat.com>
References: <CACjhXxfZak7n=zBvfPX3FtpZeBM88eBm8RnweguOZjpwdoG0ew@mail.gmail.com>
	<590C03FA-0051-4DCF-B568-C0A47B16AA49@redhat.com>
	<CACjhXxdyw1Sx4iMKT7dMUFTRwd--zLpt8BK8iyedCj_bPiTCWg@mail.gmail.com>
	<99ACAC11-1051-4C96-A81F-E4B0845D3145@redhat.com>
	<CACjhXxcvqtBJ2h2efNRDu2FbhQ=v+S_X3NtBOzUb2rXo2L+9og@mail.gmail.com>
	<CF6395F0-64FC-4E39-BDD7-68A98AB6FEC2@redhat.com>
	<CACjhXxdVFNT=tkaeoRv=6dijeh6sov6jrXUm35XVnk4b48odzg@mail.gmail.com>
	<CACjhXxe+f4CFik7c_HLkZ_U5XyT+P3gWiknzrNWOW6tbyu20XA@mail.gmail.com>
	<45156BF3-4E7B-4F7B-82A5-187FC5970D4D@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <45156BF3-4E7B-4F7B-82A5-187FC5970D4D@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, data <data@cogolabs.com>, Elvin Cako <ecako@cogolabs.com>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

T24gVGh1LCBPY3QgMzAgMjAxNCBhdCAxMjo0MXBtIC0wNDAwLApCcmFzc293IEpvbmF0aGFuIDxq
YnJhc3Nvd0ByZWRoYXQuY29tPiB3cm90ZToKCj4gRWx2aW4sCj4gCj4gT25lIG9mIHRoZSBidWdz
IEkgcmVmZXJlbmNlZCBlYXJsaWVyIGhhcyBiZWVuIGZpeGVkIHVwc3RyZWFtLiAgWW91IG1heSBu
ZWVkIHRvIGdyYWIgdGhlIGxhdGVzdCB1cHN0cmVhbSBMVk0gYW5kIGtlcm5lbCBzb3VyY2VzLiAg
SWYgeW91IGFyZSB3YWl0aW5nIHRvIHNlZSB0aGlzIGZpeGVkIGluIGEgZGlzdHJpYnV0aW9uLCB0
aGUgZWFybGllc3QgaXMgbGlrZWx5IHRvIGJlIHJoZWw3LjEgKGZvbGxvd2VkIGJ5IHJoZWw2Ljcp
Lgo+IAo+IElmIHlvdSBjb250aW51ZSB0byBoYXZlIGlzc3VlcyBsaWtlIHRoaXMsIHBsZWFzZSBj
b250YWN0IHRoZSBkbS1kZXZlbCBtYWlsaW5nIGxpc3QgKEND4oCZZWQgb24gdGhpcyBtYWlsKS4K
CldlIGFjdHVhbGx5IHdvdWxkIHJhdGhlciBhIFJIRUwgYnVnIGdldCBhIHByb3BlciByZWRoYXQg
YnVnemlsbGEsIGJ1dAp5ZXMsIHRoaXMgaXNzdWUgdGhhdCBFbHZpbiByZXBvcnRlZCBhZ2FpbnN0
IFJIRUw3IGFwcGVhcnMgaWRlbnRpY2FsIHRvCnRoaXMgQlo6IGh0dHBzOi8vYnVnemlsbGEucmVk
aGF0LmNvbS8xMDgwODk0CgpJIGhhdmUgbm8gaW5pdGlhbCByZWFzb24gdG8gYmVsaWV2ZSB0aGlz
IGlzc3VlIGlzIFJIRUwtb25seSAobWVhbmluZyBpdApsaWtlbHkgZXhpc3RzIHVwc3RyZWFtIHRv
bykuIEkndmUgZ29uZSBhaGVhZCBhbmQgbWFkZSB0aGUgYnVnIHB1YmxpYyBub3cuCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
