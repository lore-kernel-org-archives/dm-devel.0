From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFCv2 01/10] dm-dedup: main data structures
Date: Wed, 26 Nov 2014 11:47:18 -0500
Message-ID: <20141126164717.GA30610@redhat.com>
References: <53ffb64d.c58d320a.14c8.1413@mx.google.com>
	<20140926152416.GA4464@redhat.com>
	<CAFTzLMP07qBzEBaaOuFQvi0W219YqLpz8epWdMLO36Sj8gBJoQ@mail.gmail.com>
	<CAFTzLMNJ7=zc-qTcLY_BLQPRD4hiJYUAvs_AHgTgxsfg3Bb49Q@mail.gmail.com>
	<20141017174251.GA25948@redhat.com>
	<20141126153834.GD30136@redhat.com>
	<A29EA256-362D-43EC-ABF5-FB10644E6DF1@fsl.cs.sunysb.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A29EA256-362D-43EC-ABF5-FB10644E6DF1@fsl.cs.sunysb.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: Vasily Tarasov <tarasov@vasily.name>, Joe Thornber <thornber@redhat.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Shilane Philip <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

T24gV2VkLCBOb3YgMjYgMjAxNCBhdCAxMTozNmFtIC0wNTAwLApFcmV6IFphZG9rIDxlemtAZnNs
LmNzLnN1bnlzYi5lZHU+IHdyb3RlOgoKPiBNaWtlLCBWaXZlaywKPiAKPiBUaGFuayB5b3UgZm9y
IHRoZSBlZmZvcnQgYW5kIGVzcGVjaWFsbHkgZm9yIGFkZGluZyBtb3JlIG1hbi1wb3dlciB0bwo+
IHRoaXMgcmV2aWV3LiAgV2Uga25vdyBob3cgYnVzeSB5b3UgZ3V5cyBhcmUgc28gaXTigJlzIHVu
ZGVyc3RhbmRhYmxlCj4gdGhhdCB0aGluZ3MgY2FuIHRha2UgYSB3aGlsZSB0byBnZXQgc3RhcnRl
ZC4gIEVpdGhlciB3YXksIEnigJl2ZQo+IGluc3RydWN0ZWQgbXkgc3R1ZGVudHMgdG8gZ2l2ZSB0
aGlzIHByb2plY3QgdGhlIGhpZ2hlc3QgcHJpb3JpdHksCj4gZXNwZWNpYWxseSBvbmNlIHdlIHJl
Y2VpdmUgY29tbWVudHMgZnJvbSB5b3UuCgpHcmVhdC4gIFNvIGFsb25nIHRob3NlIGxpbmVzIGhh
dmUgeW91IGd1eXMgd29ya2VkIG9uIHVzZXJzcGFjZSB0b29scwp0aGF0IGNhbiB2ZXJpZnkvcmVw
YWlyIHRoZSBvbmRpc2sgbWV0YWRhdGE/CgpUaGF0IHdpbGwgYmUgYSBwcmVyZXEgZm9yIHVwc3Ry
ZWFtIGluY2x1c2lvbiAoYXQgbGVhc3QgZm9yIGRtLWRlZHVwIHRvCmJlY29tZSBhbnl0aGluZyBi
dXQgImV4cGVyaW1lbnRhbCIpLgoKZG0tY2FjaGUgYW5kIGRtLXRoaW4gdGFyZ2V0cyBoYXZlIHRo
ZXNlIHR5cGVzIG9mIHRvb2xzCih0aGluX3tjaGVjayxyZXBhaXJ9LCBjYWNoZV97Y2hlY2sscmVw
YWlyfSwgZXRjKS4gIFVwc3RyZWFtIHJlcG8gaXMgaGVyZQoobWlzbmFtZWQsIGdldHMgcGFja2Fn
ZWQgaW50byBkZXZpY2UtbWFwcGVyLXBlcnNpc3RlbnQtZGF0YSBycG0gb24KRmVkb3JhLCBSSEVM
LCBDZW50T1MsIGV0Yyk6Cmh0dHBzOi8vZ2l0aHViLmNvbS9qdGhvcm5iZXIvdGhpbi1wcm92aXNp
b25pbmctdG9vbHMKCk1pa2UKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
