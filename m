Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26363C388F7
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8330C20857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8330C20857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-fCIg2UGSNP66c1F89BLT8g-1; Fri, 13 Nov 2020 03:02:25 -0500
X-MC-Unique: fCIg2UGSNP66c1F89BLT8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 812B1188C122;
	Fri, 13 Nov 2020 08:02:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BBAE1A3D7;
	Fri, 13 Nov 2020 08:02:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91E50996E;
	Fri, 13 Nov 2020 08:02:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AC7waqb003790 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 02:58:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B72B92156A49; Thu, 12 Nov 2020 07:58:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B29F02166BA3
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 07:58:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6096A856A5A
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 07:58:34 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-455-02cKxEvVNQyYjFHszufxPg-1;
	Thu, 12 Nov 2020 02:58:31 -0500
X-MC-Unique: 02cKxEvVNQyYjFHszufxPg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UF3B8El_1605167907
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UF3B8El_1605167907) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 12 Nov 2020 15:58:27 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: Mike Snitzer <snitzer@redhat.com>
References: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
	<20201111153824.GB22834@redhat.com>
	<533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
Message-ID: <8e958749-3954-a041-e6a9-ec13c328e9b6@linux.alibaba.com>
Date: Thu, 12 Nov 2020 15:58:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org, koct9i@gmail.com
Subject: Re: [dm-devel] dm: add support for DM_TARGET_NOWAIT for various
 targets
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzEyLzIwIDI6MDUgUE0sIEplZmZsZVh1IHdyb3RlOgo+Pgo+PiBkbS10YWJsZS5jOmRt
X3RhYmxlX3NldF9yZXN0cmljdGlvbnMoKSBoYXM6Cj4+Cj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYg
KGRtX3RhYmxlX3N1cHBvcnRzX25vd2FpdCh0KSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgYmxrX3F1ZXVlX2ZsYWdfc2V0KFFVRVVFX0ZMQUdfTk9XQUlULCBxKTsKPj4gwqDC
oMKgwqDCoMKgwqDCoCBlbHNlCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJs
a19xdWV1ZV9mbGFnX2NsZWFyKFFVRVVFX0ZMQUdfTk9XQUlULCBxKTsKPj4KPj4+IFRoaXMgcGF0
Y2ggYWRkcyBzdXBwb3J0IGZvciBETV9UQVJHRVRfTk9XQUlUIGZvciB0aG9zZSBkbSB0YXJnZXRz
LCB0aGUKPj4+IC5tYXAoKSBhbGdvcml0aG0gb2Ygd2hpY2gganVzdCBpbnZvbHZlcyBzZWN0b3Ig
cmVjYWxjdWxhdGlvbi4KPj4gU28geW91J3JlIGxvb2tpbmcgdG8gY29uc3RyYWluIHdoaWNoIHRh
cmdldHMgd2lsbCBwcm9wZXJseSBzdXBwb3J0Cj4+IFJFUV9OT1dBSVQsIGJhc2VkIG9uIHdoZXRo
ZXIgdGhleSBkbyBhIHNpbXBsZSByZW1hcHBpbmc/Cj4KPiBUbyBiZSBob25lc3QsIEknbSBhIGxp
dHRsZSBjb25mdXNlZCBhYm91dCB0aGUgc2VtYW50aWNzIG9mIFJFUV9OT1dBSVQuIAo+IEplbnMg
bWF5IGhhZCBldmVyCj4KPiBleHBsYWluZWQgaXQgaW4gYmxvY2sgb3IgaW9fdXJpbmcgbWFpbGlu
ZyBsaXN0LCBidXQgSSBjYW4ndCBmaW5kIHRoZSAKPiBzcGVjaWZpYyBtYWlsLgo+CkkgZmluZCBp
dCBoZXJlIApodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1ibG9jay9mMWE2YWU4OC0xNDM2
LWU5NDctMTEyNC00MWUxMGIzZWE5YmNAa2VybmVsLmRrLwoKClNvIGlmIHRoZSBJTyBpcyBvZmZs
b2FkZWQgdG8gd29ya3F1ZXVlIGFuZCB0aGUgY3VycmVudCBwcm9jZXNzIGNvbnRleHQgCndpbGwg
bm90IGdldCBibG9ja2VkLAoKdGhlbiBpcyB0aGlzIGRldmljZSBjYXBhYmxlIG9mIGhhbmRsaW5n
IFJFUV9OT1dBSVQgb3Igbm90PwoKLS0gClRoYW5rcywKSmVmZmxlCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

