Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F73C55ABD
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F29C220731
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F29C220731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-OM7-lxqPMAKhgANPycnUCg-1; Sun, 08 Nov 2020 12:04:56 -0500
X-MC-Unique: OM7-lxqPMAKhgANPycnUCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8411556BE6;
	Sun,  8 Nov 2020 17:04:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42A695577A;
	Sun,  8 Nov 2020 17:04:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A12BB180B658;
	Sun,  8 Nov 2020 17:04:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A62pHbV004660 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 21:51:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4D4DC2097D7A; Fri,  6 Nov 2020 02:51:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 484C62097D83
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 02:51:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC24A90E422
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 02:51:14 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-526-Xgrg_PkWMTOC25VMH5zyLg-1;
	Thu, 05 Nov 2020 21:51:12 -0500
X-MC-Unique: Xgrg_PkWMTOC25VMH5zyLg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UENreRr_1604631064
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UENreRr_1604631064) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 06 Nov 2020 10:51:05 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
	<f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
	<20201104150847.GB32761@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
Date: Fri, 6 Nov 2020 10:51:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201104150847.GB32761@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzQvMjAgMTE6MDggUE0sIE1pa2UgU25pdHplciB3cm90ZToKPj4gSSdtIGRvdWJ0ZWQg
aWYgdGhpcyBzaG91bGQgYmUgaW1wbGVtZW50ZWQgaW4gYmxvY2sgbGF5ZXIgbGlrZToKPj4KPj4g
YGBgCj4+Cj4+IHN0cnVjdCBiaW8gewo+Pgo+PiAgwqDCoMKgIC4uLgo+Pgo+PiAgwqDCoMKgIHN0
cnVjdCBsaXN0X2hlYWTCoCBjb29raWVzOwo+Pgo+PiB9Owo+Pgo+PiBgYGAKPj4KPj4gQWZ0ZXIg
YWxsIGl0J3Mgb25seSB1c2VkIGJ5IGJpby1iYXNlZCBxdWV1ZSwgb3IgbW9yZSBzcGVjaWZpY2Fs
bHkKPj4gb25seSBkbSBkZXZpY2UgY3VycmVudGx5Lgo+IEkgZG8gdGhpbmsgdGhpcyBsaW5lIG9m
IHdvcmsgcmVhbGx5IHNob3VsZCBiZSBoYW5kbGVkIGluIGJsb2NrIGNvcmUKPiBiZWNhdXNlIEkg
Y2Fubm90IHNlZSBhbnkgcmVhc29uIHdoeSBNRCBvciBiY2FjaGUgb3Igd2hhdGV2ZXIgYmlvLWJh
c2VkCj4gZGV2aWNlIHdvdWxkbid0IHdhbnQgdGhlIGFiaWxpdHkgdG8gYmV0dGVyIHN1cHBvcnQg
aW9fdXJpbmcgKHdpdGggSU8KPiBwb2xsKS4KPgo+PiBBbm90aGVyIGRlc2lnbiBJIGNhbiBjb21l
IHVwIHdpdGggaXMgdG8gbWFpbnRhaW4gYSBnbG9iYWwgZGF0YQo+PiBzdHJ1Y3R1cmUgZm9yIHRo
ZSB2ZXJ5IGJlZ2lubmluZwo+PiBvcmlnaW5hbCBiaW8uIEN1cnJlbnRseSB0aGUgYmxvY2tpbmcg
cG9pbnQgaXMgdGhhdCBub3cgb25lIG9yaWdpbmFsCj4+IGJpbyB0byB0aGUgZG0gZGV2aWNlIChA
YmlvIG9mIGRtX3N1Ym1pdCgpKSBjYW4gY29ycmVzcG9uZCB0byBtdWx0aXBsZQo+PiBkbV9pbyBh
bmQgdGh1cyB3ZSBoYXZlIG5vd2hlcmUgdG8gcGxhY2UgdGhlIEBjb29raWVzIGxpc3QuCj4gWWVz
LCBhbmQgdGhhdCB3aWxsIGFsd2F5cyBiZSB0aGUgY2FzZS4gIFdlIG5lZWQgdGhlIGRlc2lnbiB0
byBoYW5kbGUgYW4KPiBhcmJpdHJhcnkgc3ByYXdsIG9mIHNwbGl0dGluZyBmcm9tIGEgZ2l2ZW4g
YmlvLiAgVGhlIGdyYXBoIG9mIGJpb3MKPiByZXN1bHRpbmcgZnJvbSB0aGF0IGZhbi1vdXQgbmVl
ZHMgdG8gYmUgd2Fsa2VkIGF0IHZhcmlvdXMgbGV2ZWxzIC0tIGJlCj4gaXQgdGhlIHRvcC1sZXZl
bCBvcmlnaW5hbCBiaW8ncyBzdWJtaXRfYmlvKCkgcmV0dXJuZWQgY29va2llIG9yIHNvbWUKPiBp
bnRlcm1lZGlhdGUgcG9pbnQgaW4gdGhlIGNoYWluIG9mIGJpb3MuCj4KPiBUaGUgcHJvYmxlbSBp
cyB0aGUgbGlmZXRpbWUgb2YgdGhlIGRhdGEgc3RydWN0dXJlIGNyZWF0ZWQgZm9yIGEgZ2l2ZW4K
PiBzcGxpdCBiaW8gdmVyc3VzIGxheWVyaW5nIGJvdW5kYXJpZXMgKHRoYXQgY29tZSBmcm9tIGJs
b2NrIGNvcmUncwo+IHNpbXBsaXN0aWMgcmVjdXJzaW9uIHZpYSBiaW8gdXNpbmcgc3VibWl0X2Jp
bykuCj4KPj4gTm93IHdlIGhhdmUgdG8gbWFpbnRhaW4gb25lIGRhdGEgc3RydWN0dXJlIGZvciBl
dmVyeSBvcmlnaW5hbCBiaW8sCj4+IHNvbWV0aGluZyBsaWtlCj4+Cj4+IGBgYAo+Pgo+PiBzdHJ1
Y3QgZG1fcG9sbF9pbnN0YW5jZSB7Cj4+Cj4+ICDCoMKgwqAgLi4uCj4+Cj4+ICDCoMKgwqAgc3Ry
dWN0IGxpc3RfaGVhZCBjb29raWVzOwo+Pgo+PiB9Owo+Pgo+PiBgYGAKPiBJIGRvIHRoaW5rIHdl
IG5lZWQgYSBoeWJyaWQgd2hlcmUgYXQgdGhlIHBvaW50IG9mIHJlY3Vyc2lvbiB3ZSdyZSBhYmxl
Cj4gdG8gbWFrZSB0aGUgYXNzb2NpYXRlZCBkYXRhIHN0cnVjdHVyZSBhdmFpbGFibGUgYWNyb3Nz
IHRoZSByZWN1cnNpb24KPiBib3VuZGFyeSBzbyB0aGF0IG1vZGVsaW5nIHRoZSBhc3NvY2lhdGlv
biBpbiBhIGNoYWluIG9mIHNwbGl0IGJpb3MgaXMKPiBwb3NzaWJsZS4gKGUuZy4gc3RydWN0IGRt
X3BvbGxfZGF0YSBvciBkbV9wb2xsX2luc3RhbmNlIGFzIHlvdSBuYW1lZCBpdCwKPiBfYnV0XyB0
aGF0IHN0cnVjdCBkZWZpbml0aW9uIHdvdWxkIGxpdmUgaW4gYmxvY2sgY29yZSwgYnV0IHdvdWxk
IGJlIHBhcnQKPiBvZiBwZXItYmlvLWRhdGE7IHNvICdzdHJ1Y3QgYmxrX3BvbGxfZGF0YScgaXMg
bW9yZSBsb2dpY2FsIG5hbWUgd2hlbgo+IGVsZXZhdGVkIHRvIGJsb2NrIGNvcmUpLgo+Cj4gSXQg
X21pZ2h0XyBiZSB3b3J0aHdoaWxlIHRvIHNlZSBpZiBhIG5ldyBCSU9fIGZsYWcgY291bGQgYmUg
YWRkZWQgdG8KPiBhbGxvdyBhdWdtZW50aW5nIHRoZSBiaW9fc3BsaXQgKyBiaW9fY2hhaW4gcGF0
dGVybiB0byBhbHNvIHRyYWNrIHRoaXMKPiBhZGRpdGlvbmFsIGNhc2Ugb2YgY2FycnlpbmcgYWRk
aXRpb25hbCBkYXRhIHBlci1iaW8gd2hpbGUgY3JlYXRpbmcKPiBiaW8tY2hhaW5zLiAgSSBtYXkg
bm90IGJlIGNsZWFyIHlldCwgc2FpZCBkaWZmZXJlbnRseTogYXVnbWVudGluZwo+IGJpb19jaGFp
biB0byBub3Qgb25seSBjaGFpbiBiaW9zLCBidXQgdG8gX2Fsc29fIHRocmVhZC9jaGFpbiB0b2dl
dGhlcgo+IHBlci1iaW8tZGF0YSB0aGF0IGxpdmVzIHdpdGhpbiB0aG9zZSBjaGFpbmVkIGJpb3Mu
ICBTTyB5b3UgaGF2ZSB0aGUKPiBjaGFpbiBvZiBiaW9zIF9hbmRfIHRoZSBjaGFpbiBvZiBwb3Rl
bnRpYWxseSBvcGFxdWUgdm9pZCAqIHRoYXQgaGFwcGVucwo+IHRvIHBvaW50IHRvIGEgbGlzdCBo
ZWFkIGZvciBhIGxpc3Qgb2YgJ3N0cnVjdCBibGtfcG9sbF9kYXRhJy4KPgo+IERvZXMgdGhhdCBt
YWtlIHNlbnNlPwoKCkknbSBkb3VidGVkIGlmIGl0IHJlYWxseSBtYWtlcyBzZW5zZSB0byBtYWlu
dGFpbiBhICpjb21wbGV0ZSogYmlvIGNoYWluIAphY3Jvc3MgdGhlIHJlY3Vyc2l2ZQoKY2FsbCBi
b3VuZGFyeS4KCgpDb25zaWRlcmluZyB0aGUgZm9sbG93aW5nIGRldmljZSBzdGFjazoKCmBgYAoK
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgwqDCoMKgIMKgwqDCoCDCoCDCoMKgwqAgwqDCoMKgIMKg
wqDCoCBkbTAKCiDCoMKgwqAgwqDCoMKgIGRtMcKgwqDCoCDCoMKgwqAgwqDCoCDCoMKgwqAgwqDC
oMKgIGRtMsKgwqDCoCDCoMKgwqAgwqDCoCBkbTMKCm52bWUwwqAgbnZtZTHCoMKgwqDCoMKgwqDC
oMKgwqAgLi4uLsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLi4uLgoKYGBgCgoKV2UgaGF2
ZSB0aGUgZm9sbG93aW5nIGJpbyBncmFwaCAocGxlYXNlIGxldCBtZSBrbm93IGlmIGl0J3Mgd3Jv
bmcgb3IgdGhlIAppbWFnZSBjYW4ndCBkaXNwbGF5KQoKCkZvciBleGFtcGxlLCBmb3IgZG0xIHRo
ZXJlIGFyZSB0aHJlZSBiaW9zIGNvbnRhaW5pbmcgdmFsaWQgY29va2llIGluIHRoZSAKZW5kLCB0
aGF0IGlzCgpiaW8gOS8xMC8xMS4gV2Ugb25seSBuZWVkIHRvIGluc2VydCB0aGUgY29ycmVzcG9u
ZGluZyBibGtfcG9sbF9kYXRhIAooY29udGFpbmluZwoKcmVxdWVzdF9xdWV1ZSwgY29va2llLCBl
dGMpIG9mIHRoZXNlIHRocmVlIGJpb3MgaW50byB0aGUgdmVyeSBiZWdpbm5pbmcgCm9yaWdpbmFs
CgpiaW8gKHRoYXQgaXMgYmlvMCkuIE9mIGNvdXJzZSB3ZSBjYW4gdHJhY2sgYWxsIHRoZSBzdWIt
YmlvcyBkb3duIHRocm91Z2ggCnRoZSBkZXZpY2UKCnN0YWNrLCBsYXllciBieSBsYXllciwgZS5n
LiwKCi0gZ2V0IGJpbyAxLzIvMyBmcm9tIGJpbyAwCgotIGdldCBiaW8gNCBmcm9tIGJpbyAzCgot
IGZpbmFsbHkgZ2V0IGJpbyA5IGZyb20gYmlvIDQKCkJ1dCBJJ20gZG91YnRlZCBpZiBpdCdzIG92
ZXJraWxsIHRvIGp1c3QgaW1wbGVtZW50IHRoZSBpb3BvbGwuCgoKQW5vdGhlciBpc3N1ZSBzdGls
bCB1bmNsZWFyIGlzIHRoYXQsIGlmIHdlIHNob3VsZCBpbXBsZW1lbnQgdGhlIGlvcG9sbCAKaW4g
YSByZWN1cnNpdmUgd2F5LgoKSW4gYSByZWN1cnNpdmUgd2F5LCB0byBwb2xsIGRtIDAsIHdlIHNo
b3VsZCBwb2xsIGFsbCBpdHMgc3ViLWRldmljZXMsIAp0aGF0IGlzLCBiaW8gNC81LzcvOC4KCk9w
cG9zaXRlbHkgd2UgY2FuIGluc2VydCBvbmx5IHRoZSBib3R0b20gYmlvIChiaW8gOS8xMC8xMSB3
aGljaCBoYXZlIAp2YWxpZCBjb29raWUpIGF0Cgp0aGUgdmVyeSBiZWdpbm5pbmcgKGF0IHN1Ym1p
dF9iaW8oKSBwaGFzZSksIGFuZCB0byBwb2xsIGRtIDAsIHdlIG9ubHkgCm5lZWQgdG8gcG9sbCBi
aW8KCjkvMTAvMTEuCgoKVG8gaW1wbGVtZW50IHRoaXMgbm9uLXJlY3Vyc2l2ZSBkZXNpZ24sIHdl
IGNhbiBhZGQgYSBmaWVsZCBpbiBzdHJ1Y3QgYmlvCgpgYGAKCnN0cnVjdCBiaW8gewoKIMKgwqDC
oCAuLi4KCiDCoMKgwqAgc3RydWN0IGJpbyAqb3JpZzsKCn0KCmBgYAoKQG9yaWcgcG9pbnRzIHRv
IHRoZSBvcmlnaW5hbCBiaW8gaW5wdXR0ZWQgaW50byBzdWJtaXRfYmlvKCksIHRoYXQgaXMsIGJp
byAwLgoKCkBvcmlnIGZpZWxkIGlzIHRyYW5zbWl0dGVkIHRocm91Z2ggYmlvIHNwbGl0dGluZy4K
CmBgYAoKYmlvX3NwbGl0KCkKCiDCoMKgwqAgc3BsaXQtPm9yaWcgPSBiaW8tPm9yaWcgPyA6IGJp
bwoKCmRtLmM6IF9fY2xvbmVfYW5kX21hcF9kYXRhX2JpbwoKIMKgwqDCoCBjbG9uZS0+b3JpZyA9
IGJpby0+b3JpZyA/IDogYmlvCgpgYGAKCgpGaW5hbGx5IGJpbyA5LzEwLzExIGNhbiBiZSBpbnNl
cnRlZCBpbnRvIGJpbyAwLgoKYGBgCgpibGstbXEuYzogYmxrX21xX3N1Ym1pdF9iaW8KCiDCoMKg
wqAgaWYgKGJpby0+b3JpZykKCiDCoMKgwqAgwqDCoMKgIGluaXQgYmxrX3BvbGxfZGF0YSBhbmQg
aW5zZXJ0IGl0IGludG8gYmlvLT5vcmlnJ3MgQGNvb2tpZXMgbGlzdAoKYGBgCgo+Cj4+IFdlIGNh
biB0cmFuc2ZlciB0aGlzIGRtX3BvbGxfaW5zdGFuY2UgYmV0d2VlbiBzcGxpdCBiaW9zIGJ5Cj4+
IGJpby0+YmlfcHJpdmF0ZSwgbGlrZQo+Pgo+PiBgYGAKPj4KPj4gZG1fc3VibWl0X2JpbyguLi4p
IHsKPj4KPj4gIMKgwqDCoCBzdHJ1Y3QgZG1fcG9sbF9pbnN0YW5jZSAqaW5zOwo+Pgo+PiAgwqDC
oMKgIGlmIChiaW8tPmJpX3ByaXZhdGUpCj4+Cj4+ICDCoMKgwqAgwqDCoMKgIGlucyA9IGJpby0+
YmlfcHJpdmF0ZTsKPj4KPj4gIMKgwqDCoCBlbHNlIHsKPj4KPj4gIMKgwqDCoCDCoMKgwqAgaW5z
ID0gYWxsb2NfcG9sbF9pbnN0YW5jZSgpOwo+Pgo+PiAgwqDCoMKgIMKgwqDCoCBiaW8tPmJpX3By
aXZhdGUgPSBpbnM7Cj4+Cj4+ICDCoMKgwqAgfQo+Pgo+PiAgwqDCoMKgIC4uLgo+Pgo+PiB9Cj4+
Cj4+IGBgYAo+IFNhZGx5LCB3ZSBjYW5ub3QgKGFiKXVzZSBiaV9wcml2YXRlIGZvciB0aGlzIGdp
dmVuIGl0cyAoYWIpdXNlZCB2aWEgdGhlCj4gYmlvX2NoYWluKCkgaW50ZXJmYWNlLiAgSXQncyBh
bG1vc3QgbGlrZSB3ZSBuZWVkIHRvIGFkZCBhIG5ldyBwb2ludGVyIGluCj4gdGhlIGJpbyB0aGF0
IGlzbid0IGxlZnQgZm9yIGJsb2NrIGNvcmUgdG8gaGlqYWNrLgo+Cj4gVGhlcmUgaXMgdGhlIHdl
bGwtd29ybiBwYXR0ZXJuIG9mIHNhdmluZyBvZmYgdGhlIG9yaWdpbmFsIGJpX3ByaXZhdGUsCj4g
aG9va2luZyBhIG5ldyBlbmRpbyBtZXRob2QgYW5kIHRoZW4gd2hlbiB0aGF0IGVuZGlvIGlzIGNh
bGxlZCByZXN0b3JpbmcKPiBiaV9wcml2YXRlIGJ1dCB3ZSByZWFsbHkgd2FudCB0byBhdm9pZCBl
eGNlc3NpdmUgaW5kaXJlY3QgZnVuY3Rpb24gY2FsbHMKPiBmb3IgdGhpcyB1c2VjYXNlLiAgVGhl
IGVudGlyZSBwb2ludCBvZiBpbXBsZW1lbnRpbmcgYmxrX3BvbGwgc3VwcG9ydCBpcwo+IGZvciBw
ZXJmb3JtYW5jZSBhZnRlciBhbGwuCj4KPiBNaWtlCj4KPiAtLQo+IGRtLWRldmVsIG1haWxpbmcg
bGlzdAo+IGRtLWRldmVsQHJlZGhhdC5jb20KPiBodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwKCi0tIApUaGFua3MsCkplZmZsZQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVs

