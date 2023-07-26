Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFC6C00528
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 06:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690438949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6T+RHYayaV1CZa/9Bqc1yUijiofmK3unYVk0S5nUtQM=;
	b=T2vQk47nd0FqA1hmxNBH8NO8gI2TJMDmxz7T8xt7m1oxWP/vXhLbS1ZuTzVmnmFhbgoxHA
	lcMxokaYB/7g+Qm3eAp4YDBprvNZQTF+ORBJE3dJ3ZzD+7IbXWhaQY94NkDwT8G5ipNk0o
	d8vNVvB9m2YDYzOWDRioM/S1ErzRMIs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-7yROPv1iM7SN-IMixFPJSw-1; Thu, 27 Jul 2023 02:22:26 -0400
X-MC-Unique: 7yROPv1iM7SN-IMixFPJSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D09BF185A7BC;
	Thu, 27 Jul 2023 06:22:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8671E40C2063;
	Thu, 27 Jul 2023 06:22:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D45F7194E105;
	Thu, 27 Jul 2023 06:22:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 109CA1946A69
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 09:33:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E267A2166B25; Wed, 26 Jul 2023 09:33:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9EC52166B27
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 09:33:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDF2B3C13504
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 09:33:52 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-n3_ttl1hPOeKkojewvDtKQ-1; Wed, 26 Jul 2023 05:33:51 -0400
X-MC-Unique: n3_ttl1hPOeKkojewvDtKQ-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1b7dfb95761so8911905ad.1
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 02:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690364030; x=1690968830;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0oULOTnWb1HIc+jcDQkyDbPD+ewEuK6cRZsxNFZBJHs=;
 b=Drv/dK3af8w3hcDBvPu7k+GnjjOp+BNw6BBX2+sbLjB0OzrK2LfdsQQ2qlPQMM71ty
 VwxqhXO6YQZtKg1lr57N+SSs13Sep01ZaAhyd1PqNgHBA6htH4CAQHB9F9yKAzGItU7i
 E2XMO0F1MDc6UTi/iyWUP9TgsI+7+T/ugywnYVGSc2zuER13HBh7MjQuZ+jl2HBnNRCT
 XI7jgFHW969ijie16ho3t3YJdEe8XboN1PVJxKihUQo6/0XEkpov67c6z3mkptu4k7ET
 yfRSjagq826ruZO8yhGxa+SOFlfW75ZWS+fsEb7Nwkr8QkAq1UMJ5IYb9Lv4qyvMY5xr
 BvHw==
X-Gm-Message-State: ABy/qLb7h/UfbdtWuxD06Acn2odAfV6NpWIw3ofl/s+A8vHOUOKT80sM
 GPWZ9qI1hQr0wnE/VOsI30F2iw==
X-Google-Smtp-Source: APBJJlG8LKe8O0SB++JE7Hsj6dMankp6b2TdGG8KZmgQCX7ZvwrXNm6kysx08G1J6PXDjDRRJyafNA==
X-Received: by 2002:a17:903:32c9:b0:1b8:5827:8763 with SMTP id
 i9-20020a17090332c900b001b858278763mr2037984plr.4.1690364030014; 
 Wed, 26 Jul 2023 02:33:50 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 n5-20020a170902d2c500b001b89466a5f4sm12582766plc.105.2023.07.26.02.33.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 26 Jul 2023 02:33:49 -0700 (PDT)
Message-ID: <0f12022e-5dd2-fb1c-f018-05f8ff0303ae@bytedance.com>
Date: Wed, 26 Jul 2023 17:33:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Muchun Song <muchun.song@linux.dev>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-29-zhengqi.arch@bytedance.com>
 <4ee26da4-314e-0517-5d9a-31fb107368ef@linux.dev>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <4ee26da4-314e-0517-5d9a-31fb107368ef@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Thu, 27 Jul 2023 06:20:49 +0000
Subject: Re: [dm-devel] [PATCH v2 28/47] bcache: dynamically allocate the
 md-bcache shrinker
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzcvMjYgMTU6MzIsIE11Y2h1biBTb25nIHdyb3RlOgo+IAo+IAo+IE9uIDIwMjMv
Ny8yNCAxNzo0MywgUWkgWmhlbmcgd3JvdGU6Cj4+IEluIHByZXBhcmF0aW9uIGZvciBpbXBsZW1l
bnRpbmcgbG9ja2xlc3Mgc2xhYiBzaHJpbmssIHVzZSBuZXcgQVBJcyB0bwo+PiBkeW5hbWljYWxs
eSBhbGxvY2F0ZSB0aGUgbWQtYmNhY2hlIHNocmlua2VyLCBzbyB0aGF0IGl0IGNhbiBiZSBmcmVl
ZAo+PiBhc3luY2hyb25vdXNseSB1c2luZyBrZnJlZV9yY3UoKS4gVGhlbiBpdCBkb2Vzbid0IG5l
ZWQgdG8gd2FpdCBmb3IgUkNVCj4+IHJlYWQtc2lkZSBjcml0aWNhbCBzZWN0aW9uIHdoZW4gcmVs
ZWFzaW5nIHRoZSBzdHJ1Y3QgY2FjaGVfc2V0Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBRaSBaaGVu
ZyA8emhlbmdxaS5hcmNoQGJ5dGVkYW5jZS5jb20+Cj4+IC0tLQo+PiDCoCBkcml2ZXJzL21kL2Jj
YWNoZS9iY2FjaGUuaCB8wqAgMiArLQo+PiDCoCBkcml2ZXJzL21kL2JjYWNoZS9idHJlZS5jwqAg
fCAyNyArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0KPj4gwqAgZHJpdmVycy9tZC9iY2FjaGUv
c3lzZnMuY8KgIHzCoCAzICsrLQo+PiDCoCAzIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMo
KyksIDEzIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9iY2FjaGUv
YmNhY2hlLmggYi9kcml2ZXJzL21kL2JjYWNoZS9iY2FjaGUuaAo+PiBpbmRleCA1YTc5YmIzYzI3
MmYuLmM2MjJiYzUwZjgxYiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYmNhY2hl
LmgKPj4gKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvYmNhY2hlLmgKPj4gQEAgLTU0MSw3ICs1NDEs
NyBAQCBzdHJ1Y3QgY2FjaGVfc2V0IHsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgYmlvX3NldMKgwqDC
oMKgwqDCoMKgIGJpb19zcGxpdDsKPj4gwqDCoMKgwqDCoCAvKiBGb3IgdGhlIGJ0cmVlIGNhY2hl
ICovCj4+IC3CoMKgwqAgc3RydWN0IHNocmlua2VywqDCoMKgwqDCoMKgwqAgc2hyaW5rOwo+PiAr
wqDCoMKgIHN0cnVjdCBzaHJpbmtlcsKgwqDCoMKgwqDCoMKgICpzaHJpbms7Cj4+IMKgwqDCoMKg
wqAgLyogRm9yIHRoZSBidHJlZSBjYWNoZSBhbmQgYW55dGhpbmcgYWxsb2NhdGlvbiByZWxhdGVk
ICovCj4+IMKgwqDCoMKgwqAgc3RydWN0IG11dGV4wqDCoMKgwqDCoMKgwqAgYnVja2V0X2xvY2s7
Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9idHJlZS5jIGIvZHJpdmVycy9tZC9i
Y2FjaGUvYnRyZWUuYwo+PiBpbmRleCBmZDEyMWE2MWYxN2MuLmMxNzZjN2ZjNzdkOSAxMDA2NDQK
Pj4gLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYwo+PiArKysgYi9kcml2ZXJzL21kL2Jj
YWNoZS9idHJlZS5jCj4+IEBAIC02NjcsNyArNjY3LDcgQEAgc3RhdGljIGludCBtY2FfcmVhcChz
dHJ1Y3QgYnRyZWUgKmIsIHVuc2lnbmVkIGludCAKPj4gbWluX29yZGVyLCBib29sIGZsdXNoKQo+
PiDCoCBzdGF0aWMgdW5zaWduZWQgbG9uZyBiY2hfbWNhX3NjYW4oc3RydWN0IHNocmlua2VyICpz
aHJpbmssCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBz
aHJpbmtfY29udHJvbCAqc2MpCj4+IMKgIHsKPj4gLcKgwqDCoCBzdHJ1Y3QgY2FjaGVfc2V0ICpj
ID0gY29udGFpbmVyX29mKHNocmluaywgc3RydWN0IGNhY2hlX3NldCwgCj4+IHNocmluayk7Cj4+
ICvCoMKgwqAgc3RydWN0IGNhY2hlX3NldCAqYyA9IHNocmluay0+cHJpdmF0ZV9kYXRhOwo+PiDC
oMKgwqDCoMKgIHN0cnVjdCBidHJlZSAqYiwgKnQ7Cj4+IMKgwqDCoMKgwqAgdW5zaWduZWQgbG9u
ZyBpLCBuciA9IHNjLT5ucl90b19zY2FuOwo+PiDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZnJl
ZWQgPSAwOwo+PiBAQCAtNzM0LDcgKzczNCw3IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIGJjaF9t
Y2Ffc2NhbihzdHJ1Y3Qgc2hyaW5rZXIgCj4+ICpzaHJpbmssCj4+IMKgIHN0YXRpYyB1bnNpZ25l
ZCBsb25nIGJjaF9tY2FfY291bnQoc3RydWN0IHNocmlua2VyICpzaHJpbmssCj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHNocmlua19jb250cm9sICpz
YykKPj4gwqAgewo+PiAtwqDCoMKgIHN0cnVjdCBjYWNoZV9zZXQgKmMgPSBjb250YWluZXJfb2Yo
c2hyaW5rLCBzdHJ1Y3QgY2FjaGVfc2V0LCAKPj4gc2hyaW5rKTsKPj4gK8KgwqDCoCBzdHJ1Y3Qg
Y2FjaGVfc2V0ICpjID0gc2hyaW5rLT5wcml2YXRlX2RhdGE7Cj4+IMKgwqDCoMKgwqAgaWYgKGMt
PnNocmlua2VyX2Rpc2FibGVkKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+IEBA
IC03NTIsOCArNzUyLDggQEAgdm9pZCBiY2hfYnRyZWVfY2FjaGVfZnJlZShzdHJ1Y3QgY2FjaGVf
c2V0ICpjKQo+PiDCoMKgwqDCoMKgIGNsb3N1cmVfaW5pdF9zdGFjaygmY2wpOwo+PiAtwqDCoMKg
IGlmIChjLT5zaHJpbmsubGlzdC5uZXh0KQo+PiAtwqDCoMKgwqDCoMKgwqAgdW5yZWdpc3Rlcl9z
aHJpbmtlcigmYy0+c2hyaW5rKTsKPj4gK8KgwqDCoCBpZiAoYy0+c2hyaW5rKQo+PiArwqDCoMKg
wqDCoMKgwqAgc2hyaW5rZXJfdW5yZWdpc3RlcihjLT5zaHJpbmspOwo+PiDCoMKgwqDCoMKgIG11
dGV4X2xvY2soJmMtPmJ1Y2tldF9sb2NrKTsKPj4gQEAgLTgyOCwxNCArODI4LDE5IEBAIGludCBi
Y2hfYnRyZWVfY2FjaGVfYWxsb2Moc3RydWN0IGNhY2hlX3NldCAqYykKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgIGMtPnZlcmlmeV9kYXRhID0gTlVMTDsKPj4gwqAgI2VuZGlmCj4+IC3CoMKgwqAgYy0+
c2hyaW5rLmNvdW50X29iamVjdHMgPSBiY2hfbWNhX2NvdW50Owo+PiAtwqDCoMKgIGMtPnNocmlu
ay5zY2FuX29iamVjdHMgPSBiY2hfbWNhX3NjYW47Cj4+IC3CoMKgwqAgYy0+c2hyaW5rLnNlZWtz
ID0gNDsKPj4gLcKgwqDCoCBjLT5zaHJpbmsuYmF0Y2ggPSBjLT5idHJlZV9wYWdlcyAqIDI7Cj4+
ICvCoMKgwqAgYy0+c2hyaW5rID0gc2hyaW5rZXJfYWxsb2MoMCwgIm1kLWJjYWNoZTolcFUiLCBj
LT5zZXRfdXVpZCk7Cj4+ICvCoMKgwqAgaWYgKCFjLT5zaHJpbmspIHsKPj4gK8KgwqDCoMKgwqDC
oMKgIHByX3dhcm4oImJjYWNoZTogJXM6IGNvdWxkIG5vdCBhbGxvY2F0ZSBzaHJpbmtlclxuIiwg
X19mdW5jX18pOwo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9NRU07Cj4gCj4gU2VlbXMg
eW91IGhhdmUgY2hlYW5nZWQgdGhlIHNlbWFudGljIG9mIHRoaXMuIEluIHRoZSBwYXN0LAo+IGl0
IGlzIGJldHRlciB0byBoYXZlIGEgc2hyaW5rZXIsIGJ1dCBub3cgaXQgYmVjb21lcyBhIG1hbmRh
dG9yeS4KPiBSaWdodD8gSSBkb24ndCBrbm93IGlmIGl0IGlzIGFjY2VwdGFibGUuIEZyb20gbXkg
cG9pbnQgb2YgdmlldywKPiBqdXN0IGRvIHRoZSBjbGVhbnVwLCBkb24ndCBjaGFuZ2UgYW55IGJl
aGF2aW91ci4KCk9oLCBzaG91bGQgcmV0dXJuIDAgaGVyZSwgd2lsbCBkby4KCj4gCj4+ICvCoMKg
wqAgfQo+PiArCj4+ICvCoMKgwqAgYy0+c2hyaW5rLT5jb3VudF9vYmplY3RzID0gYmNoX21jYV9j
b3VudDsKPj4gK8KgwqDCoCBjLT5zaHJpbmstPnNjYW5fb2JqZWN0cyA9IGJjaF9tY2Ffc2NhbjsK
Pj4gK8KgwqDCoCBjLT5zaHJpbmstPnNlZWtzID0gNDsKPj4gK8KgwqDCoCBjLT5zaHJpbmstPmJh
dGNoID0gYy0+YnRyZWVfcGFnZXMgKiAyOwo+PiArwqDCoMKgIGMtPnNocmluay0+cHJpdmF0ZV9k
YXRhID0gYzsKPj4gLcKgwqDCoCBpZiAocmVnaXN0ZXJfc2hyaW5rZXIoJmMtPnNocmluaywgIm1k
LWJjYWNoZTolcFUiLCBjLT5zZXRfdXVpZCkpCj4+IC3CoMKgwqDCoMKgwqDCoCBwcl93YXJuKCJi
Y2FjaGU6ICVzOiBjb3VsZCBub3QgcmVnaXN0ZXIgc2hyaW5rZXJcbiIsCj4+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgX19mdW5jX18pOwo+PiArwqDCoMKgIHNocmlua2VyX3JlZ2lz
dGVyKGMtPnNocmluayk7Cj4+IMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+IMKgIH0KPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMgYi9kcml2ZXJzL21kL2JjYWNoZS9zeXNm
cy5jCj4+IGluZGV4IDBlMmMxODgwZjYwYi4uNDVkOGFmNzU1ZGU2IDEwMDY0NAo+PiAtLS0gYS9k
cml2ZXJzL21kL2JjYWNoZS9zeXNmcy5jCj4+ICsrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N5c2Zz
LmMKPj4gQEAgLTg2Niw3ICs4NjYsOCBAQCBTVE9SRShfX2JjaF9jYWNoZV9zZXQpCj4+IMKgwqDC
oMKgwqDCoMKgwqDCoCBzYy5nZnBfbWFzayA9IEdGUF9LRVJORUw7Cj4+IMKgwqDCoMKgwqDCoMKg
wqDCoCBzYy5ucl90b19zY2FuID0gc3RydG91bF9vcl9yZXR1cm4oYnVmKTsKPj4gLcKgwqDCoMKg
wqDCoMKgIGMtPnNocmluay5zY2FuX29iamVjdHMoJmMtPnNocmluaywgJnNjKTsKPj4gK8KgwqDC
oMKgwqDCoMKgIGlmIChjLT5zaHJpbmspCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGMtPnNo
cmluay0+c2Nhbl9vYmplY3RzKGMtPnNocmluaywgJnNjKTsKPj4gwqDCoMKgwqDCoCB9Cj4+IMKg
wqDCoMKgwqAgc3lzZnNfc3RydG91bF9jbGFtcChjb25nZXN0ZWRfcmVhZF90aHJlc2hvbGRfdXMs
Cj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

