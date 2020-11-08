Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BBDC388F9
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:06:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AE2A206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AE2A206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-8NIa6BDrPWuHgnGjd2tIfg-1; Sun, 08 Nov 2020 12:05:31 -0500
X-MC-Unique: 8NIa6BDrPWuHgnGjd2tIfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAC64186DD2E;
	Sun,  8 Nov 2020 17:05:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F26B10074FD;
	Sun,  8 Nov 2020 17:05:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 77A0B92303;
	Sun,  8 Nov 2020 17:05:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A81A6Hf020990 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 7 Nov 2020 20:10:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4F4F4110FC0D; Sun,  8 Nov 2020 01:10:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ACBC110FC0C
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 01:10:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03B1F800296
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 01:10:04 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-200-AaIisBnXNUy2U97gUnzsUw-1;
	Sat, 07 Nov 2020 20:09:59 -0500
X-MC-Unique: AaIisBnXNUy2U97gUnzsUw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UEYXK2x_1604797793
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UEYXK2x_1604797793) by smtp.aliyun-inc.com(127.0.0.1);
	Sun, 08 Nov 2020 09:09:54 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
	<f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
	<20201104150847.GB32761@redhat.com>
	<2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
	<20201106174526.GA13292@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
Date: Sun, 8 Nov 2020 09:09:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201106174526.GA13292@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [RFC 0/3] Add support of iopoll for dm device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzcvMjAgMTo0NSBBTSwgTWlrZSBTbml0emVyIHdyb3RlOgo+IE9uIFRodSwgTm92IDA1
IDIwMjAgYXQgIDk6NTFwbSAtMDUwMCwKPiBKZWZmbGVYdSA8amVmZmxleHVAbGludXguYWxpYmFi
YS5jb20+IHdyb3RlOgo+Cj4+IE9uIDExLzQvMjAgMTE6MDggUE0sIE1pa2UgU25pdHplciB3cm90
ZToKPj4+PiBJJ20gZG91YnRlZCBpZiB0aGlzIHNob3VsZCBiZSBpbXBsZW1lbnRlZCBpbiBibG9j
ayBsYXllciBsaWtlOgo+Pj4+Cj4+Pj4gYGBgCj4+Pj4KPj4+PiBzdHJ1Y3QgYmlvIHsKPj4+Pgo+
Pj4+ICDCoMKgwqAgLi4uCj4+Pj4KPj4+PiAgwqDCoMKgIHN0cnVjdCBsaXN0X2hlYWTCoCBjb29r
aWVzOwo+Pj4+Cj4+Pj4gfTsKPj4+Pgo+Pj4+IGBgYAo+Pj4+Cj4+Pj4gQWZ0ZXIgYWxsIGl0J3Mg
b25seSB1c2VkIGJ5IGJpby1iYXNlZCBxdWV1ZSwgb3IgbW9yZSBzcGVjaWZpY2FsbHkKPj4+PiBv
bmx5IGRtIGRldmljZSBjdXJyZW50bHkuCj4+PiBJIGRvIHRoaW5rIHRoaXMgbGluZSBvZiB3b3Jr
IHJlYWxseSBzaG91bGQgYmUgaGFuZGxlZCBpbiBibG9jayBjb3JlCj4+PiBiZWNhdXNlIEkgY2Fu
bm90IHNlZSBhbnkgcmVhc29uIHdoeSBNRCBvciBiY2FjaGUgb3Igd2hhdGV2ZXIgYmlvLWJhc2Vk
Cj4+PiBkZXZpY2Ugd291bGRuJ3Qgd2FudCB0aGUgYWJpbGl0eSB0byBiZXR0ZXIgc3VwcG9ydCBp
b191cmluZyAod2l0aCBJTwo+Pj4gcG9sbCkuCj4+Pgo+Pj4+IEFub3RoZXIgZGVzaWduIEkgY2Fu
IGNvbWUgdXAgd2l0aCBpcyB0byBtYWludGFpbiBhIGdsb2JhbCBkYXRhCj4+Pj4gc3RydWN0dXJl
IGZvciB0aGUgdmVyeSBiZWdpbm5pbmcKPj4+PiBvcmlnaW5hbCBiaW8uIEN1cnJlbnRseSB0aGUg
YmxvY2tpbmcgcG9pbnQgaXMgdGhhdCBub3cgb25lIG9yaWdpbmFsCj4+Pj4gYmlvIHRvIHRoZSBk
bSBkZXZpY2UgKEBiaW8gb2YgZG1fc3VibWl0KCkpIGNhbiBjb3JyZXNwb25kIHRvIG11bHRpcGxl
Cj4+Pj4gZG1faW8gYW5kIHRodXMgd2UgaGF2ZSBub3doZXJlIHRvIHBsYWNlIHRoZSBAY29va2ll
cyBsaXN0Lgo+Pj4gWWVzLCBhbmQgdGhhdCB3aWxsIGFsd2F5cyBiZSB0aGUgY2FzZS4gIFdlIG5l
ZWQgdGhlIGRlc2lnbiB0byBoYW5kbGUgYW4KPj4+IGFyYml0cmFyeSBzcHJhd2wgb2Ygc3BsaXR0
aW5nIGZyb20gYSBnaXZlbiBiaW8uICBUaGUgZ3JhcGggb2YgYmlvcwo+Pj4gcmVzdWx0aW5nIGZy
b20gdGhhdCBmYW4tb3V0IG5lZWRzIHRvIGJlIHdhbGtlZCBhdCB2YXJpb3VzIGxldmVscyAtLSBi
ZQo+Pj4gaXQgdGhlIHRvcC1sZXZlbCBvcmlnaW5hbCBiaW8ncyBzdWJtaXRfYmlvKCkgcmV0dXJu
ZWQgY29va2llIG9yIHNvbWUKPj4+IGludGVybWVkaWF0ZSBwb2ludCBpbiB0aGUgY2hhaW4gb2Yg
Ymlvcy4KPj4+Cj4+PiBUaGUgcHJvYmxlbSBpcyB0aGUgbGlmZXRpbWUgb2YgdGhlIGRhdGEgc3Ry
dWN0dXJlIGNyZWF0ZWQgZm9yIGEgZ2l2ZW4KPj4+IHNwbGl0IGJpbyB2ZXJzdXMgbGF5ZXJpbmcg
Ym91bmRhcmllcyAodGhhdCBjb21lIGZyb20gYmxvY2sgY29yZSdzCj4+PiBzaW1wbGlzdGljIHJl
Y3Vyc2lvbiB2aWEgYmlvIHVzaW5nIHN1Ym1pdF9iaW8pLgo+Pj4KPj4+PiBOb3cgd2UgaGF2ZSB0
byBtYWludGFpbiBvbmUgZGF0YSBzdHJ1Y3R1cmUgZm9yIGV2ZXJ5IG9yaWdpbmFsIGJpbywKPj4+
PiBzb21ldGhpbmcgbGlrZQo+Pj4+Cj4+Pj4gYGBgCj4+Pj4KPj4+PiBzdHJ1Y3QgZG1fcG9sbF9p
bnN0YW5jZSB7Cj4+Pj4KPj4+PiAgwqDCoMKgIC4uLgo+Pj4+Cj4+Pj4gIMKgwqDCoCBzdHJ1Y3Qg
bGlzdF9oZWFkIGNvb2tpZXM7Cj4+Pj4KPj4+PiB9Owo+Pj4+Cj4+Pj4gYGBgCj4+PiBJIGRvIHRo
aW5rIHdlIG5lZWQgYSBoeWJyaWQgd2hlcmUgYXQgdGhlIHBvaW50IG9mIHJlY3Vyc2lvbiB3ZSdy
ZSBhYmxlCj4+PiB0byBtYWtlIHRoZSBhc3NvY2lhdGVkIGRhdGEgc3RydWN0dXJlIGF2YWlsYWJs
ZSBhY3Jvc3MgdGhlIHJlY3Vyc2lvbgo+Pj4gYm91bmRhcnkgc28gdGhhdCBtb2RlbGluZyB0aGUg
YXNzb2NpYXRpb24gaW4gYSBjaGFpbiBvZiBzcGxpdCBiaW9zIGlzCj4+PiBwb3NzaWJsZS4gKGUu
Zy4gc3RydWN0IGRtX3BvbGxfZGF0YSBvciBkbV9wb2xsX2luc3RhbmNlIGFzIHlvdSBuYW1lZCBp
dCwKPj4+IF9idXRfIHRoYXQgc3RydWN0IGRlZmluaXRpb24gd291bGQgbGl2ZSBpbiBibG9jayBj
b3JlLCBidXQgd291bGQgYmUgcGFydAo+Pj4gb2YgcGVyLWJpby1kYXRhOyBzbyAnc3RydWN0IGJs
a19wb2xsX2RhdGEnIGlzIG1vcmUgbG9naWNhbCBuYW1lIHdoZW4KPj4+IGVsZXZhdGVkIHRvIGJs
b2NrIGNvcmUpLgo+Pj4KPj4+IEl0IF9taWdodF8gYmUgd29ydGh3aGlsZSB0byBzZWUgaWYgYSBu
ZXcgQklPXyBmbGFnIGNvdWxkIGJlIGFkZGVkIHRvCj4+PiBhbGxvdyBhdWdtZW50aW5nIHRoZSBi
aW9fc3BsaXQgKyBiaW9fY2hhaW4gcGF0dGVybiB0byBhbHNvIHRyYWNrIHRoaXMKPj4+IGFkZGl0
aW9uYWwgY2FzZSBvZiBjYXJyeWluZyBhZGRpdGlvbmFsIGRhdGEgcGVyLWJpbyB3aGlsZSBjcmVh
dGluZwo+Pj4gYmlvLWNoYWlucy4gIEkgbWF5IG5vdCBiZSBjbGVhciB5ZXQsIHNhaWQgZGlmZmVy
ZW50bHk6IGF1Z21lbnRpbmcKPj4+IGJpb19jaGFpbiB0byBub3Qgb25seSBjaGFpbiBiaW9zLCBi
dXQgdG8gX2Fsc29fIHRocmVhZC9jaGFpbiB0b2dldGhlcgo+Pj4gcGVyLWJpby1kYXRhIHRoYXQg
bGl2ZXMgd2l0aGluIHRob3NlIGNoYWluZWQgYmlvcy4gIFNPIHlvdSBoYXZlIHRoZQo+Pj4gY2hh
aW4gb2YgYmlvcyBfYW5kXyB0aGUgY2hhaW4gb2YgcG90ZW50aWFsbHkgb3BhcXVlIHZvaWQgKiB0
aGF0IGhhcHBlbnMKPj4+IHRvIHBvaW50IHRvIGEgbGlzdCBoZWFkIGZvciBhIGxpc3Qgb2YgJ3N0
cnVjdCBibGtfcG9sbF9kYXRhJy4KPj4+Cj4+PiBEb2VzIHRoYXQgbWFrZSBzZW5zZT8KPj4KPj4g
SSdtIGRvdWJ0ZWQgaWYgaXQgcmVhbGx5IG1ha2VzIHNlbnNlIHRvIG1haW50YWluIGEgKmNvbXBs
ZXRlKiBiaW8KPj4gY2hhaW4gYWNyb3NzIHRoZSByZWN1cnNpdmUKPj4KPj4gY2FsbCBib3VuZGFy
eS4KPj4KPj4KPj4gQ29uc2lkZXJpbmcgdGhlIGZvbGxvd2luZyBkZXZpY2Ugc3RhY2s6Cj4+Cj4+
IGBgYAo+Pgo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgIMKgwqDC
oCDCoMKgwqAgwqDCoMKgIGRtMAo+Pgo+PiAgwqDCoMKgIMKgwqDCoCBkbTHCoMKgwqAgwqDCoMKg
IMKgwqAgwqDCoMKgIMKgwqDCoCBkbTLCoMKgwqAgwqDCoMKgIMKgwqAgZG0zCj4+Cj4+IG52bWUw
wqAgbnZtZTHCoMKgwqDCoMKgwqDCoMKgwqAgLi4uLsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgLi4uLgo+Pgo+PiBgYGAKPj4KPj4KPj4gV2UgaGF2ZSB0aGUgZm9sbG93aW5nIGJpbyBncmFw
aCAocGxlYXNlIGxldCBtZSBrbm93IGlmIGl0J3Mgd3Jvbmcgb3IKPj4gdGhlIGltYWdlIGNhbid0
IGRpc3BsYXkpCj4+Cj4+Cj4+IEZvciBleGFtcGxlLCBmb3IgZG0xIHRoZXJlIGFyZSB0aHJlZSBi
aW9zIGNvbnRhaW5pbmcgdmFsaWQgY29va2llIGluCj4+IHRoZSBlbmQsIHRoYXQgaXMKPj4KPj4g
YmlvIDkvMTAvMTEuIFdlIG9ubHkgbmVlZCB0byBpbnNlcnQgdGhlIGNvcnJlc3BvbmRpbmcgYmxr
X3BvbGxfZGF0YQo+PiAoY29udGFpbmluZwo+Pgo+PiByZXF1ZXN0X3F1ZXVlLCBjb29raWUsIGV0
Yykgb2YgdGhlc2UgdGhyZWUgYmlvcyBpbnRvIHRoZSB2ZXJ5Cj4+IGJlZ2lubmluZyBvcmlnaW5h
bAo+Pgo+PiBiaW8gKHRoYXQgaXMgYmlvMCkuIE9mIGNvdXJzZSB3ZSBjYW4gdHJhY2sgYWxsIHRo
ZSBzdWItYmlvcyBkb3duCj4+IHRocm91Z2ggdGhlIGRldmljZQo+Pgo+PiBzdGFjaywgbGF5ZXIg
YnkgbGF5ZXIsIGUuZy4sCj4+Cj4+IC0gZ2V0IGJpbyAxLzIvMyBmcm9tIGJpbyAwCj4+Cj4+IC0g
Z2V0IGJpbyA0IGZyb20gYmlvIDMKPj4KPj4gLSBmaW5hbGx5IGdldCBiaW8gOSBmcm9tIGJpbyA0
Cj4+Cj4+IEJ1dCBJJ20gZG91YnRlZCBpZiBpdCdzIG92ZXJraWxsIHRvIGp1c3QgaW1wbGVtZW50
IHRoZSBpb3BvbGwuCj4+Cj4+Cj4+IEFub3RoZXIgaXNzdWUgc3RpbGwgdW5jbGVhciBpcyB0aGF0
LCBpZiB3ZSBzaG91bGQgaW1wbGVtZW50IHRoZQo+PiBpb3BvbGwgaW4gYSByZWN1cnNpdmUgd2F5
Lgo+Pgo+PiBJbiBhIHJlY3Vyc2l2ZSB3YXksIHRvIHBvbGwgZG0gMCwgd2Ugc2hvdWxkIHBvbGwg
YWxsIGl0cwo+PiBzdWItZGV2aWNlcywgdGhhdCBpcywgYmlvIDQvNS83LzguCj4+Cj4+IE9wcG9z
aXRlbHkgd2UgY2FuIGluc2VydCBvbmx5IHRoZSBib3R0b20gYmlvIChiaW8gOS8xMC8xMSB3aGlj
aCBoYXZlCj4+IHZhbGlkIGNvb2tpZSkgYXQKPj4KPj4gdGhlIHZlcnkgYmVnaW5uaW5nIChhdCBz
dWJtaXRfYmlvKCkgcGhhc2UpLCBhbmQgdG8gcG9sbCBkbSAwLCB3ZQo+PiBvbmx5IG5lZWQgdG8g
cG9sbCBiaW8gOS8xMC8xMS4KPiBJIGZlZWwgd2UgbmVlZCB0aGUgYWJpbGl0eSB0byB3YWxrIHRo
ZSBlbnRpcmUgZ3JhcGggYW5kIGNhbGwgZG93biB0bwo+IG5leHQgbGV2ZWwuICBUaGUgbG93ZXN0
IGxldmVsIHdvdWxkIGJlIHdoYXQgeW91IGNhbGwgYSAidmFsaWQgY29va2llIgo+IHRoYXQgYmxr
LW1xIHJldHVybmVkLiAgQnV0IHRoZSBwcmVjZWRpbmcgY29va2llcyBuZWVkIHRvIGJlIG1hZGUg
dmFsaWQKPiBhbmQgdXNlZCB3aGVuIHdhbGtpbmcgdGhlIGdyYXBoIChmcm9tIGhpZ2hlc3QgdG8g
bG93ZXN0KSBhbmQgY2FsbGluZwo+IGRvd24gdG8gdGhlIHVuZGVybHlpbmcgbGF5ZXJzLgo+Cj4+
Cj4+IFRvIGltcGxlbWVudCB0aGlzIG5vbi1yZWN1cnNpdmUgZGVzaWduLCB3ZSBjYW4gYWRkIGEg
ZmllbGQgaW4gc3RydWN0IGJpbwo+Pgo+PiBgYGAKPj4KPj4gc3RydWN0IGJpbyB7Cj4+Cj4+ICDC
oMKgwqAgLi4uCj4+Cj4+ICDCoMKgwqAgc3RydWN0IGJpbyAqb3JpZzsKPj4KPj4gfQo+Pgo+PiBg
YGAKPj4KPj4gQG9yaWcgcG9pbnRzIHRvIHRoZSBvcmlnaW5hbCBiaW8gaW5wdXR0ZWQgaW50byBz
dWJtaXRfYmlvKCksIHRoYXQgaXMsIGJpbyAwLgo+Pgo+Pgo+PiBAb3JpZyBmaWVsZCBpcyB0cmFu
c21pdHRlZCB0aHJvdWdoIGJpbyBzcGxpdHRpbmcuCj4+Cj4+IGBgYAo+Pgo+PiBiaW9fc3BsaXQo
KQo+Pgo+PiAgwqDCoMKgIHNwbGl0LT5vcmlnID0gYmlvLT5vcmlnID8gOiBiaW8KPj4KPj4KPj4g
ZG0uYzogX19jbG9uZV9hbmRfbWFwX2RhdGFfYmlvCj4+Cj4+ICDCoMKgwqAgY2xvbmUtPm9yaWcg
PSBiaW8tPm9yaWcgPyA6IGJpbwo+Pgo+PiBgYGAKPj4KPj4KPj4gRmluYWxseSBiaW8gOS8xMC8x
MSBjYW4gYmUgaW5zZXJ0ZWQgaW50byBiaW8gMC4KPj4KPj4gYGBgCj4+Cj4+IGJsay1tcS5jOiBi
bGtfbXFfc3VibWl0X2Jpbwo+Pgo+PiAgwqDCoMKgIGlmIChiaW8tPm9yaWcpCj4+Cj4+ICDCoMKg
wqAgwqDCoMKgIGluaXQgYmxrX3BvbGxfZGF0YSBhbmQgaW5zZXJ0IGl0IGludG8gYmlvLT5vcmln
J3MgQGNvb2tpZXMgbGlzdAo+Pgo+PiBgYGAKPiBJZiB5b3UgZmVlbCB0aGF0IGlzIGRvYWJsZTog
Y2VydGFpbmx5IGdpdmUgaXQgYSBzaG90LgoKTWFrZSBzZW5zZS4KCj4gQnV0IGl0IGlzIG5vdCBj
bGVhciB0byBtZSBob3cgeW91IGludGVuZCB0byB0cmFuc2xhdGUgZnJvbSBjb29raWUgcGFzc2Vk
Cj4gaW4gdG8gLT5ibGtfcG9sbCBob29rIChyZXR1cm5lZCBmcm9tIHN1Ym1pdF9iaW8pIHRvIHRo
ZSBzYXZlZCBvZmYKPiBiaW8tPm9yaWcuCj4KPiBXaGF0IGlzIHlvdXIgY29va2llIHN0cmF0ZWd5
IGluIHRoaXMgbm9uLXJlY3Vyc2l2ZSBpbXBsZW1lbnRhdGlvbj8gIFdoYXQKPiB3aWxsIHlvdSBi
ZSByZXR1cm5pbmc/ICBXaGVyZSB3aWxsIHlvdSBiZSBzdG9yaW5nIGl0PwoKQWN0dWFsbHkgSSB0
aGluayBpdCdzIGEgY29tbW9uIGlzc3VlIHRvIGRlc2lnbiB0aGUgY29va2llIHJldHVybmVkIGJ5
IApzdWJtaXRfYmlvKCkgd2hlbmV2ZXIKCml0J3MgaW1wbGVtZW50ZWQgaW4gYSByZWN1cnNpdmUg
b3Igbm9uLXJlY3Vyc2l2ZSB3YXkuIEFmdGVyIGFsbCB5b3UgbmVlZCAKdG8gdHJhbnNsYXRlIHRo
ZQoKcmV0dXJuZWQgY29va2llIHRvIHRoZSBvcmlnaW5hbCBiaW8gZXZlbiBpZiBpdCdzIGltcGxl
bWVudGVkIGluIGEgCnJlY3Vyc2l2ZSB3YXkgYXMgeW91CgpkZXNjcmliZWQuIE9yIGhvdyBjb3Vs
ZCB5b3Ugd2FsayB0aHJvdWdoIHRoZSBiaW8gZ3JhcGggd2hlbiB0aGUgcmV0dXJuZWQgCmNvb2tp
ZSBpcwoKb25seSAndW5zaWduZWQgaW50JyB0eXBlPwoKCkhvdyBhYm91dCB0aGlzOgoKCmBgYAoK
dHlwZWRlZiB1aW50cHRyX3QgYmxrX3FjX3Q7CgpgYGAKCgpvciBzb21ldGhpbmcgbGlrZSB1bmlv
bgoKYGBgCgp0eXBlZGVmIHVuaW9uIHsKCiDCoMKgwqAgdW5zaWduZWQgaW50IGNvb2tpZTsKCiDC
oMKgwqAgc3RydWN0IGJpbyAqb3JpZzsgLy8gdGhlIG9yaWdpbmFsIGJpbyBvZiBzdWJtaXRfYmlv
KCkKCn0gYmxrX3FjX3Q7CgpgYGAKCgpXaGVuIHNlcnZpbmcgZm9yIGJsay1tcSwgdGhlIGludGVn
ZXIgcGFydCBvZiBibGtfcWNfdCBpcyB1c2VkIGFuZCBpdCAKc3RvcmVzIHRoZSB2YWxpZCBjb29r
aWUsCgp3aGlsZSBpdCBzdG9yZXMgYSBwb2ludGVyIHRvIHRoZSBvcmlnaW5hbCBiaW8gd2hlbiBz
ZXJ2aW5nIGJpby1iYXNlZCBkZXZpY2UuCgoKQnkgdGhlIHdheSwgd291bGQgeW91IG1pbmQgc2hh
cmluZyB5b3VyIHBsYW4gYW5kIHByb2dyZXNzIG9uIHRoaXMgd29yaywgCkkgbWVhbiwgc3VwcG9y
dGluZwoKaW9wb2xsIGZvciBkbSBkZXZpY2UuIFRvIGJlIGhvbmVzdCwgSSBkb24ndCB3YW50IHRv
IHJlLWludmVudCB0aGUgd2hlZWwgCmFzIHlvdSBoYXZlIHN0YXJ0ZWQgb24KCnRoaXMgd29yaywg
YnV0IEkgZG8gd2FudCB0byBwYXJ0aWNpcGF0ZSBpbiBzb21laG93LiBQbGVhc2UgbGV0IG1lIGtu
b3cgCmlmIHRoZXJlJ3Mgc29tZXRoaW5nCgpJIGNvdWxkIGRvIGhlcmUuCgoKLS0gClRoYW5rcywK
SmVmZmxlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

