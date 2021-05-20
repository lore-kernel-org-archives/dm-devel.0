Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D48BC43460
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:53:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C06A8600CD
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C06A8600CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-QjDQDu3NN5edvWUMSWEOZg-1; Thu, 20 May 2021 01:53:20 -0400
X-MC-Unique: QjDQDu3NN5edvWUMSWEOZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30AB9107ACCD;
	Thu, 20 May 2021 05:53:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18174687DB;
	Thu, 20 May 2021 05:53:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFD161800FFC;
	Thu, 20 May 2021 05:53:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5rCue014933 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:53:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 838D12133488; Thu, 20 May 2021 05:53:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F6702133491
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:53:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF5B2800B26
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:53:08 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-415-98fBRDZ1MOGAahP3VhEXKw-1;
	Thu, 20 May 2021 01:53:06 -0400
X-MC-Unique: 98fBRDZ1MOGAahP3VhEXKw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id DF2DCAD71;
	Thu, 20 May 2021 05:53:04 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-5-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <bcb534a6-df16-3603-72f9-d1e2bfe31da4@suse.de>
Date: Thu, 20 May 2021 07:53:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-5-damien.lemoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5rCue014933
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 04/11] dm: Fix dm_accept_partial_bio()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBGaXggZG1fYWNjZXB0
X3BhcnRpYWxfYmlvKCkgdG8gYWN0dWFsbHkgY2hlY2sgdGhhdCB6b25lIG1hbmFnZW1lbnQKPiBj
b21tYW5kcyBhcmUgbm90IHBhc3NlZCBhcyBleHBsYWluZWQgaW4gdGhlIGZ1bmN0aW9uIGRvY3Vt
ZW50YXRpb24KPiBjb21tZW50LiBBbHNvLCBzaW5jZSBhIHpvbmUgYXBwZW5kIG9wZXJhdGlvbiBj
YW5ub3QgYmUgc3BsaXQsIGFkZAo+IFJFUV9PUF9aT05FX0FQUEVORCBhcyBhIGZvcmJpZGRlbiBj
b21tYW5kLgo+IAo+IFdoaXRlIGxpbmVzIGFyZSBhZGRlZCBhcm91bmQgdGhlIGdyb3VwIG9mIEJV
R19PTigpIGNhbGxzIHRvIG1ha2UgdGhlCj4gY29kZSBtb3JlIGxlZ2libGUuCj4gCj4gU2lnbmVk
LW9mZi1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4KPiBSZXZpZXdl
ZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4KPiAt
LS0KPiAgIGRyaXZlcnMvbWQvZG0uYyB8IDkgKysrKysrKy0tCj4gICAxIGZpbGUgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L21kL2RtLmMgYi9kcml2ZXJzL21kL2RtLmMKPiBpbmRleCBjYTJhZWRkOGVlN2QuLmE5MjExNTc1
YmZlZCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL2RtLmMKPiArKysgYi9kcml2ZXJzL21kL2Rt
LmMKPiBAQCAtMTIzNyw4ICsxMjM3LDkgQEAgc3RhdGljIGludCBkbV9kYXhfemVyb19wYWdlX3Jh
bmdlKHN0cnVjdCBkYXhfZGV2aWNlICpkYXhfZGV2LCBwZ29mZl90IHBnb2ZmLAo+ICAgCj4gICAv
Kgo+ICAgICogQSB0YXJnZXQgbWF5IGNhbGwgZG1fYWNjZXB0X3BhcnRpYWxfYmlvIG9ubHkgZnJv
bSB0aGUgbWFwIHJvdXRpbmUuICBJdCBpcwo+IC0gKiBhbGxvd2VkIGZvciBhbGwgYmlvIHR5cGVz
IGV4Y2VwdCBSRVFfUFJFRkxVU0gsIFJFUV9PUF9aT05FX1JFU0VULAo+IC0gKiBSRVFfT1BfWk9O
RV9PUEVOLCBSRVFfT1BfWk9ORV9DTE9TRSBhbmQgUkVRX09QX1pPTkVfRklOSVNILgo+ICsgKiBh
bGxvd2VkIGZvciBhbGwgYmlvIHR5cGVzIGV4Y2VwdCBSRVFfUFJFRkxVU0gsIHpvbmUgbWFuYWdl
bWVudCBvcGVyYXRpb25zCj4gKyAqIChSRVFfT1BfWk9ORV9SRVNFVCwgUkVRX09QX1pPTkVfT1BF
TiwgUkVRX09QX1pPTkVfQ0xPU0UgYW5kCj4gKyAqIFJFUV9PUF9aT05FX0ZJTklTSCkgYW5kIHpv
bmUgYXBwZW5kIHdyaXRlcy4KPiAgICAqCj4gICAgKiBkbV9hY2NlcHRfcGFydGlhbF9iaW8gaW5m
b3JtcyB0aGUgZG0gdGhhdCB0aGUgdGFyZ2V0IG9ubHkgd2FudHMgdG8gcHJvY2Vzcwo+ICAgICog
YWRkaXRpb25hbCBuX3NlY3RvcnMgc2VjdG9ycyBvZiB0aGUgYmlvIGFuZCB0aGUgcmVzdCBvZiB0
aGUgZGF0YSBzaG91bGQgYmUKPiBAQCAtMTI2OCw5ICsxMjY5LDEzIEBAIHZvaWQgZG1fYWNjZXB0
X3BhcnRpYWxfYmlvKHN0cnVjdCBiaW8gKmJpbywgdW5zaWduZWQgbl9zZWN0b3JzKQo+ICAgewo+
ICAgCXN0cnVjdCBkbV90YXJnZXRfaW8gKnRpbyA9IGNvbnRhaW5lcl9vZihiaW8sIHN0cnVjdCBk
bV90YXJnZXRfaW8sIGNsb25lKTsKPiAgIAl1bnNpZ25lZCBiaV9zaXplID0gYmlvLT5iaV9pdGVy
LmJpX3NpemUgPj4gU0VDVE9SX1NISUZUOwo+ICsKPiAgIAlCVUdfT04oYmlvLT5iaV9vcGYgJiBS
RVFfUFJFRkxVU0gpOwo+ICsJQlVHX09OKG9wX2lzX3pvbmVfbWdtdChiaW9fb3AoYmlvKSkpOwo+
ICsJQlVHX09OKGJpb19vcChiaW8pID09IFJFUV9PUF9aT05FX0FQUEVORCk7Cj4gICAJQlVHX09O
KGJpX3NpemUgPiAqdGlvLT5sZW5fcHRyKTsKPiAgIAlCVUdfT04obl9zZWN0b3JzID4gYmlfc2l6
ZSk7Cj4gKwo+ICAgCSp0aW8tPmxlbl9wdHIgLT0gYmlfc2l6ZSAtIG5fc2VjdG9yczsKPiAgIAli
aW8tPmJpX2l0ZXIuYmlfc2l6ZSA9IG5fc2VjdG9ycyA8PCBTRUNUT1JfU0hJRlQ7Cj4gICB9Cj4g
ClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhh
bm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFn
ZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5
IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4g
NSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bD
vGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=

