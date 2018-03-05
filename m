From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 5/6] libmultipath: Fix sgio_get_vpd()
Date: Mon, 05 Mar 2018 21:47:30 +0100
Message-ID: <1520282850.7660.49.camel@suse.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
	<20180301192935.14643-6-bart.vanassche@wdc.com>
	<1520268808.7660.23.camel@suse.com> <1520269758.7660.29.camel@suse.com>
	<1520277283.7660.46.camel@suse.com> <1520277522.2826.34.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520277522.2826.34.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gTW9uLCAyMDE4LTAzLTA1IGF0IDE5OjE4ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gT24gTW9uLCAyMDE4LTAzLTA1IGF0IDIwOjE0ICswMTAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6
Cj4gPiBVbmxlc3MgeW91IG9iamVjdCwgSSdsbCByZXBvc3QgeW91ciBzZXJpZXMgcmViYXNlZCBv
biBtaW5lLgo+IAo+IEhlbGxvIE1hcnRpbiwKPiAKPiBCZWZvcmUgeW91IHN0YXJ0IHdvcmtpbmcg
b24gdGhhdDogaGFzIHlvdXIgcGF0Y2ggc2VyaWVzIGFscmVhZHkgYmVlbgo+IHBvc3RlZAo+IG9u
IHRoZSBkbS1kZXZlbCBtYWlsaW5nIGxpc3Q/CgpZZXMuICJQQVRDSCB2MiAwMC8yMF0gVmFyaW91
cyBtdWx0aXBhdGgtdG9vbHMgZml4ZXMiIGZmLgpodHRwczovL3d3dy5yZWRoYXQuY29tL2FyY2hp
dmVzL2RtLWRldmVsLzIwMTgtSmFudWFyeS9tc2cwMDIxOS5odG1sCgpSZWdhcmRzLApNYXJ0aW4K
Ci0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEg
NzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUg
U21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
