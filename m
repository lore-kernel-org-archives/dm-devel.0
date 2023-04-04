Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264A7C76188
	for <dm-devel@archiver.kernel.org>; Wed,  5 Apr 2023 06:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680676882;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=coyiuA+RjmMkKiABlwHZ7ZQaZr+Vczqt5BKCHEwKwSo=;
	b=RC7FPpeB8EjXA17JLvePBaWUvRqfE5MW0Gt9agrJwmy+dkpgef1neMsZ63zhAEgGGlBPPo
	YZ5NDM1UDWu+RVEZlyJ13C/tuP1+F30ZFV0UCCTB/hbG7BxZe1sj9Eh0G6zHU7vGaKy8vO
	5YFUq9LROuApZnu6zupdpmCDMjppJnY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-ttEF1NE3O62MhAIt-_gYzw-1; Wed, 05 Apr 2023 02:41:19 -0400
X-MC-Unique: ttEF1NE3O62MhAIt-_gYzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 521173C0F193;
	Wed,  5 Apr 2023 06:41:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 398FFC084B3;
	Wed,  5 Apr 2023 06:41:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 176521946597;
	Wed,  5 Apr 2023 06:41:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58F64194658C
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Apr 2023 08:26:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B5E71121318; Tue,  4 Apr 2023 08:26:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3378D1121315
 for <dm-devel@redhat.com>; Tue,  4 Apr 2023 08:26:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14E05811E7C
 for <dm-devel@redhat.com>; Tue,  4 Apr 2023 08:26:39 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-xvL82K2DOranFR-Tr5Fwvw-1; Tue, 04 Apr 2023 04:26:35 -0400
X-MC-Unique: xvL82K2DOranFR-Tr5Fwvw-1
Received: by mail-wr1-f51.google.com with SMTP id e18so31860242wra.9;
 Tue, 04 Apr 2023 01:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680596793;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=P+IA0sfS8Hko6hpK1HZztJ6kiawc/hgiN78OoxbJlkE=;
 b=UmR3DJMdS3kodNIerj+qT1TEyHqbY0l9USLOivkGdU6IKc5ykBMAEZbYN0GZRKIsoT
 gYrZWlq2f5HjLVLY1SE6sfRSUqCfQTAFK3inaL6tgueBYMqYhOcL3ffsZlYKgtB1CVsV
 dgqDhQjLqVAMRuWcU4OW/VL1Z6ndOcXbnz/zwQo8M1twOfcSz/F4guGTycbi9fb96tjn
 77WtRzzycgWXKS9yQjdebnzIi9fAXOQknWum3MmxXM1+7yG7OQvhxYGC9z3P94BBa4Mk
 tXnpDDM99vSQAyEXU9B7XgZ7aAzBJ0VDkN1vxXbxJli2Z7KPl/FZoEDXn492tjONqkJH
 Y01Q==
X-Gm-Message-State: AAQBX9dK1F2CrXJ1iDys7xvMKg/k6ETsKqmL2Ujd7lfLuBKnFtN9loBP
 iR6uTfB42lG2N9KDPkYR56M=
X-Google-Smtp-Source: AKy350YRAl3M0jE5+UynIwckjiW+CsHm28SGM1LHNiMQ7J8tXe8xmw1F2qmXD/R4sfgmgOX6wBeBhg==
X-Received: by 2002:adf:e0c3:0:b0:2cf:e747:b0d4 with SMTP id
 m3-20020adfe0c3000000b002cfe747b0d4mr940685wri.40.1680596793398; 
 Tue, 04 Apr 2023 01:26:33 -0700 (PDT)
Received: from [192.168.32.129] (aftr-82-135-86-174.dynamic.mnet-online.de.
 [82.135.86.174]) by smtp.gmail.com with ESMTPSA id
 t6-20020a7bc3c6000000b003ee1b2ab9a0sm14294575wmj.11.2023.04.04.01.26.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 04 Apr 2023 01:26:32 -0700 (PDT)
Message-ID: <bbc98aa3-24f0-8ee6-9d74-483564a14f0f@kernel.org>
Date: Tue, 4 Apr 2023 10:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Song Liu <song@kernel.org>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <8b8a3bb2db8c5183ef36c1810f2ac776ac526327.1680172791.git.johannes.thumshirn@wdc.com>
 <CAPhsuW7a+mpn+VprfA2mC5Fc+M9BFq8i6d-y+-o5G1u5dOsk2Q@mail.gmail.com>
From: Johannes Thumshirn <jth@kernel.org>
In-Reply-To: <CAPhsuW7a+mpn+VprfA2mC5Fc+M9BFq8i6d-y+-o5G1u5dOsk2Q@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 05 Apr 2023 06:41:14 +0000
Subject: Re: [dm-devel] [PATCH v2 17/19] md: raid1: check if adding pages to
 resync bio fails
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Dave Kleikamp <shaggy@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMzEvMDMvMjAyMyAyMDoxMywgU29uZyBMaXUgd3JvdGU6Cj4gT24gVGh1LCBNYXIgMzAsIDIw
MjMgYXQgMzo0NOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo+IDxqb2hhbm5lcy50aHVtc2hpcm5A
d2RjLmNvbT4gd3JvdGU6Cj4+Cj4+IENoZWNrIGlmIGFkZGluZyBwYWdlcyB0byByZXN5bmMgYmlv
IGZhaWxzIGFuZCBpZiBiYWlsIG91dC4KPj4KPj4gQXMgdGhlIGNvbW1lbnQgYWJvdmUgc3VnZ2Vz
dHMgdGhpcyBjYW5ub3QgaGFwcGVuLCBXQVJOIGlmIGl0IGFjdHVhbGx5Cj4+IGhhcHBlbnMuCj4+
Cj4+IFRoaXMgd2F5IHdlIGNhbiBtYXJrIGJpb19hZGRfcGFnZXMgYXMgX19tdXN0X2NoZWNrLgo+
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGly
bkB3ZGMuY29tPgo+PiBSZXZpZXdlZC1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxA
b3BlbnNvdXJjZS53ZGMuY29tPgo+PiAtLS0KPj4gICBkcml2ZXJzL21kL3JhaWQxLTEwLmMgfCAg
NyArKysrKystCj4+ICAgZHJpdmVycy9tZC9yYWlkMTAuYyAgIHwgMTIgKysrKysrKysrKy0tCj4+
ICAgMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+Pgo+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS0xMC5jIGIvZHJpdmVycy9tZC9yYWlkMS0x
MC5jCj4+IGluZGV4IGU2MWY2Y2FkNGUwOC4uYzIxYjZjMTY4NzUxIDEwMDY0NAo+PiAtLS0gYS9k
cml2ZXJzL21kL3JhaWQxLTEwLmMKPj4gKysrIGIvZHJpdmVycy9tZC9yYWlkMS0xMC5jCj4+IEBA
IC0xMDUsNyArMTA1LDEyIEBAIHN0YXRpYyB2b2lkIG1kX2Jpb19yZXNldF9yZXN5bmNfcGFnZXMo
c3RydWN0IGJpbyAqYmlvLCBzdHJ1Y3QgcmVzeW5jX3BhZ2VzICpycCwKPj4gICAgICAgICAgICAg
ICAgICAgKiB3b24ndCBmYWlsIGJlY2F1c2UgdGhlIHZlYyB0YWJsZSBpcyBiaWcKPj4gICAgICAg
ICAgICAgICAgICAgKiBlbm91Z2ggdG8gaG9sZCBhbGwgdGhlc2UgcGFnZXMKPj4gICAgICAgICAg
ICAgICAgICAgKi8KPiAKPiBXZSBrbm93IHRoZXNlIHdvbid0IGZhaWwuIFNoYWxsIHdlIGp1c3Qg
dXNlIF9fYmlvX2FkZF9wYWdlPwoKV2UgY291bGQgeWVzLCBidXQgSSBraW5kIG9mIGxpa2UgdGhl
IGFzc2VydCgpIHN0eWxlIHdhcm5pbmcuCkJ1dCBvZiBjYXVzZSB1bHRpbWF0ZWx5IHlvdXIgY2Fs
bC4KCkJ5dGUsCglKb2hhbm5lcwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

