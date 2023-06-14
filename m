Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FCFEB64DB
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686727276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3C6d97clOCP84NbNq5sR5e0pQVXQcaxtl7OZNQHuYgs=;
	b=Nrc2gU374/zXIwC5xsM30H68FYHC07rd6gCMgaASXpAz6cBVW1laovrIBGjqceuephqSHl
	lg55B4QZCcGO8zvFUNJCEKRDE9YlbYLtVIrEA0nTkyIfY0lPRXPKAtGFn3sHY294sww46f
	KgX0BeMmsUP8iXUtWqo8g3CQEofuqCE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-vIqF85W1MmaQ9Uc8Q_znuA-1; Wed, 14 Jun 2023 03:21:13 -0400
X-MC-Unique: vIqF85W1MmaQ9Uc8Q_znuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1991C185A78B;
	Wed, 14 Jun 2023 07:21:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1D151415102;
	Wed, 14 Jun 2023 07:21:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87DF819459F1;
	Wed, 14 Jun 2023 07:21:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DBDD194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:20:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45771492B06; Wed, 14 Jun 2023 07:20:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D662492C1B
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:20:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21C0B803DBE
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:20:55 +0000 (UTC)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-x5oRFv8cM1SHNXssIgwXQA-1; Wed, 14 Jun 2023 03:20:53 -0400
X-MC-Unique: x5oRFv8cM1SHNXssIgwXQA-1
Received: by mail-pg1-f197.google.com with SMTP id
 41be03b00d2f7-5340957a1f1so3075910a12.1
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 00:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686727252; x=1689319252;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=8Cv1JzRA0ITaFwqMsVLtSdeb5FcnnDYorlxptC0NsHg=;
 b=Yw0quIg17RVlb3XHDLYjbV7UD65UtgHznVy75wU3oWSiVj7zReTenc3pUNWHbzSGnu
 V0By962uh/czc/rezJnt0MgcqGSGIv2etySmjbSaJeGDA2Tma4BAeZdwTb3lCfP2vrj+
 CdYd/celJwNuJtCfoa/H68l3j4/TndifB2yah+givhD+7swXAY2O20hegnsMPcITydV2
 Dd//i65yMhBJpehcPnuaVqTjn/iutYZknaiHkZDQLy0hrGrD3pnbX9dhOx2lSviX2ce3
 rIkcQ4WtDKlDvVH2p5YRoS0rnIecdBwdlytUSOFCMNyjkuKgaoKNp89HIC5rt5NrRK3h
 DKHA==
X-Gm-Message-State: AC+VfDwqP2DqVs1OSyjijVeHP9k2Kglg/ziq4P6OSEx/PoRp01fsahk3
 1u8iNCDa75ExG5ftBRf6TglnDmn72bgdFVocph7reIS5AcoqNK7CKYEmzMvaBGoUcasn9m9S2gC
 utt25kuwFFTmZDIY=
X-Received: by 2002:a17:903:2347:b0:1b1:99c9:8ce1 with SMTP id
 c7-20020a170903234700b001b199c98ce1mr11789015plh.51.1686727252669; 
 Wed, 14 Jun 2023 00:20:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5GCfs2iEd+UlGYv0S1z3ZGoD/fIDkPq52+kCuyNgIKUbm8u8+z+d39yf6mgV5s26EGgf7Cfw==
X-Received: by 2002:a17:903:2347:b0:1b1:99c9:8ce1 with SMTP id
 c7-20020a170903234700b001b199c98ce1mr11789010plh.51.1686727252401; 
 Wed, 14 Jun 2023 00:20:52 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
 by smtp.gmail.com with ESMTPSA id
 w16-20020a170902a71000b001b061dcdb6bsm11447933plq.28.2023.06.14.00.20.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 14 Jun 2023 00:20:52 -0700 (PDT)
Message-ID: <79c170e2-35d9-5671-7b3d-377750c140bb@redhat.com>
Date: Wed, 14 Jun 2023 15:20:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-6-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-6-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH -next v2 5/6] md: wake up 'resync_wait' at
 last in md_reap_sync_thread()
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
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnpgZM6Cj4gRnJvbTogWXUgS3Vh
aSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Cj4gbWRfcmVhcF9zeW5jX3RocmVhZCgpIGlzIGp1c3Qg
cmVwbGFjZWQgd2l0aCB3YWl0X2V2ZW50KHJlc3luY193YWl0LCAuLi4pCj4gZnJvbSBhY3Rpb25f
c3RvcmUoKSwganVzdCBtYWtlIHN1cmUgYWN0aW9uX3N0b3JlKCkgd2lsbCBzdGlsbCB3YWl0IGZv
cgo+IGV2ZXJ5dGhpbmcgdG8gYmUgZG9uZSBpbiBtZF9yZWFwX3N5bmNfdGhyZWFkKCkuCj4KPiBT
aWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4gLS0tCj4gICBkcml2
ZXJzL21kL21kLmMgfCAyICstCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21k
L21kLmMKPiBpbmRleCA3OTEyZGUwZTRkMTIuLmY5MDIyNmU2ZGRmOCAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL21kL21kLmMKPiArKysgYi9kcml2ZXJzL21kL21kLmMKPiBAQCAtOTUzMSw3ICs5NTMx
LDYgQEAgdm9pZCBtZF9yZWFwX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gICAJ
aWYgKG1kZGV2X2lzX2NsdXN0ZXJlZChtZGRldikgJiYgaXNfcmVzaGFwZWQKPiAgIAkJCQkgICAg
ICAmJiAhdGVzdF9iaXQoTURfQ0xPU0lORywgJm1kZGV2LT5mbGFncykpCj4gICAJCW1kX2NsdXN0
ZXJfb3BzLT51cGRhdGVfc2l6ZShtZGRldiwgb2xkX2Rldl9zZWN0b3JzKTsKPiAtCXdha2VfdXAo
JnJlc3luY193YWl0KTsKPiAgIAkvKiBmbGFnIHJlY292ZXJ5IG5lZWRlZCBqdXN0IHRvIGRvdWJs
ZSBjaGVjayAqLwo+ICAgCXNldF9iaXQoTURfUkVDT1ZFUllfTkVFREVELCAmbWRkZXYtPnJlY292
ZXJ5KTsKPiAgIAlzeXNmc19ub3RpZnlfZGlyZW50X3NhZmUobWRkZXYtPnN5c2ZzX2NvbXBsZXRl
ZCk7Cj4gQEAgLTk1MzksNiArOTUzOCw3IEBAIHZvaWQgbWRfcmVhcF9zeW5jX3RocmVhZChzdHJ1
Y3QgbWRkZXYgKm1kZGV2KQo+ICAgCW1kX25ld19ldmVudCgpOwo+ICAgCWlmIChtZGRldi0+ZXZl
bnRfd29yay5mdW5jKQo+ICAgCQlxdWV1ZV93b3JrKG1kX21pc2Nfd3EsICZtZGRldi0+ZXZlbnRf
d29yayk7Cj4gKwl3YWtlX3VwKCZyZXN5bmNfd2FpdCk7Cj4gICB9Cj4gICBFWFBPUlRfU1lNQk9M
KG1kX3JlYXBfc3luY190aHJlYWQpOwo+ICAgCgoKUmV2aWV3ZC1ieTogWGlhbyBOaSA8eG5pQHJl
ZGhhdC5jb20+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

