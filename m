From: Milan Broz <mbroz@redhat.com>
Subject: Re: logfs: kernel NULL dereference
Date: Thu, 15 Sep 2011 16:27:52 +0200
Message-ID: <4E720B68.80809@redhat.com>
References: <20110903125637.GG6092@smp.if.uj.edu.pl>
	<20110907141527.GM32018@logfs.org>
	<20110907210312.GA17634@smp.if.uj.edu.pl>
	<20110907220856.GR32018@logfs.org>
	<20110908161726.GA9104@smp.if.uj.edu.pl>
	<20110914182425.GD24351@logfs.org>
	<20110914183429.GE24351@logfs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110914183429.GE24351@logfs.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, Prasad Joshi <prasadjoshi124@gmail.com>, Witold Baryluk <baryluk@smp.if.uj.edu.pl>, Aniket Sane <aniketsane@gmail.com>
List-Id: dm-devel.ids

T24gMDkvMTQvMjAxMSAwODozNCBQTSwgSsO2cm4gRW5nZWwgd3JvdGU6Cj4gRm9yd2FyZGVkIHRv
IGRtLWRldmVsLiAgUHJvYmxlbSBpcyBhIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbgo+IGtj
cnlwdGRfaW9fcmVhZCwgd2hpY2ggaXMgdHJpZ2dlcmVkIHdoZW4gbW91bnRpbmcgbG9nZnMuICBJ
ZiBzb21lb25lCj4gd2l0aCBkZXZpY2UgbWFwcGVyIGtub3dsZWRnZSBjb3VsZCBoYXZlIGEgbG9v
aywgdGhhdCB3b3VsZCBiZSB1c2VmdWwuCj4gCj4gT24gV2VkLCAxNCBTZXB0ZW1iZXIgMjAxMSAy
MDoyNDoyNSArMDIwMCwgSsO2cm4gRW5nZWwgd3JvdGU6Cj4+Cj4+IE9rLCBJIGNhbiByZWxpYWJs
eSByZXByb2R1Y2UgdGhlIHByb2JsZW0gd2l0aCB0aGUgZm9sbG93aW5nLCBiYXNlZCBvbgo+PiB5
b3VyIGRlc2NyaXB0aW9uOgo+Pgo+PiB0cnVuY2F0ZSAtcyAwIGZvbwo+PiB0cnVuY2F0ZSAtcyAx
RyBmb28KPj4gbG9zZXR1cCAtdiAtZiBmb28KPj4gY3J5cHRzZXR1cCBsdWtzRm9ybWF0IC9kZXYv
bG9vcDAKPj4gY3J5cHRzZXR1cCBsdWtzT3BlbiAvZGV2L2xvb3AwIGZvbwo+PiBwdmNyZWF0ZSAv
ZGV2L21hcHBlci9mb28KPj4gdmdjcmVhdGUgb3VyX3ZvbHVtZSAvZGV2L21hcHBlci9mb28KPj4g
bHZjcmVhdGUgLUwgMTI4TSAtbiBsb2dmc3Rlc3Qgb3VyX3ZvbHVtZQo+PiB5ZXMgeWVzIHwgbWts
b2dmcyAvZGV2L21hcHBlci9vdXJfdm9sdW1lLWxvZ2ZzdGVzdAo+PiBtb3VudCAvZGV2L21hcHBl
ci9vdXJfdm9sdW1lLWxvZ2ZzdGVzdCAvbW50LwoKV2hpY2gga2VybmVsIHZlcnNpb24gYXJlIHlv
dSB1c2luZz8KCj4+IEl0IGlzIGEgYml0IGFubm95aW5nIHRoYXQgY3J5cHRzZXR1cCBjYW5ub3Qg
ZWFzaWx5IGJlIHNjcmlwdGVkLgoKSXQgY2FuIGJlIGVhc2lseSBzY3JpcHRlZC4gKEluIHF1aWV0
IG1vZGUgaXQgd2lsbCBub3QgYXNrIGZvciBZRVMgcmVzcG9uc2UsIGFkZCAtcSwKb3IganVzdCBk
byAiZWNobyAtbiAkUEFTU1dPUkQgfCBjcnlwdHNldHVwIGx1a3NGb3JtYXQgLi4uIikKCk1pbGFu
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
