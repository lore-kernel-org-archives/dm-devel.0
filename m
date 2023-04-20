Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF7B0C77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gh8kd49t3WnGQSs04Koh2b9W4kH+T1GJb1UlGrIQe6g=;
	b=JqysOXhFYpKMIgDsypn01bYqm0hBbjZl+B417WOfJRF/Ak2S448BrgamvzY8Xbf8KH1Hnx
	i5hwWY5wzDmnTAEzkXtEFrwM8AwZ4LkaBwAi7Xxvrvn7EYtgWGQS7hRkwhVao2rEQEIWdc
	zwiF+PF0GPRbKFcqYuvDNsd36q8FHys=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-fW2PXCguOFCCABv61AhIHw-1; Thu, 20 Apr 2023 02:57:13 -0400
X-MC-Unique: fW2PXCguOFCCABv61AhIHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F3FD8996E0;
	Thu, 20 Apr 2023 06:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3943E1121318;
	Thu, 20 Apr 2023 06:57:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 290991946A49;
	Thu, 20 Apr 2023 06:57:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F114B19465B9
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 04:40:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 30BFC1121318; Thu, 20 Apr 2023 04:40:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29ADA1121315
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 04:40:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CA9A800B35
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 04:40:04 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-xqUV14_ANNObqNhpcVOI8g-1; Thu, 20 Apr 2023 00:39:59 -0400
X-MC-Unique: xqUV14_ANNObqNhpcVOI8g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 808F860C20;
 Thu, 20 Apr 2023 04:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F3BC433A0;
 Thu, 20 Apr 2023 04:39:57 +0000 (UTC)
Received: by mail-lj1-f174.google.com with SMTP id a10so1396375ljr.5;
 Wed, 19 Apr 2023 21:39:57 -0700 (PDT)
X-Gm-Message-State: AAQBX9c5q/Wl797ZuAePZ5hMxtHqHbRmBqoVNN1dTwvWKcw/R7zY4Y6T
 DKd7V1cKUtd8k3coRWJdKJ0Hcb9rOwMv4Z2qZVM=
X-Google-Smtp-Source: AKy350brjGRI86LwVWGkzPXSEalUdCI4Td6YNPTTcnNRSEuyUW/eSnxVnpWQ0bvhloD205Vvr5DEOhYwggyQMmUmPfI=
X-Received: by 2002:a2e:a313:0:b0:2a8:928d:2e2e with SMTP id
 l19-20020a2ea313000000b002a8928d2e2emr2679277lje.5.1681965595968; Wed, 19 Apr
 2023 21:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230419140929.5924-1-jth@kernel.org>
 <20230419140929.5924-18-jth@kernel.org>
In-Reply-To: <20230419140929.5924-18-jth@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 19 Apr 2023 21:39:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7n5Gb68+br0Cf47J5wu25FtTzfBs0cSihg49f2tSY8jA@mail.gmail.com>
Message-ID: <CAPhsuW7n5Gb68+br0Cf47J5wu25FtTzfBs0cSihg49f2tSY8jA@mail.gmail.com>
To: Johannes Thumshirn <jth@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: Re: [dm-devel] [PATCH v3 17/19] md: raid1: check if adding pages to
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, axboe@kernel.dk, linux-raid@vger.kernel.org,
 damien.lemoal@wdc.com, johannes.thumshirn@wdc.com,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBBcHIgMTksIDIwMjMgYXQgNzoxMeKAr0FNIEpvaGFubmVzIFRodW1zaGlybiA8anRo
QGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4gRnJvbTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5l
cy50aHVtc2hpcm5Ad2RjLmNvbT4KPgo+IENoZWNrIGlmIGFkZGluZyBwYWdlcyB0byByZXN5bmMg
YmlvIGZhaWxzIGFuZCBpZiBiYWlsIG91dC4KPgo+IEFzIHRoZSBjb21tZW50IGFib3ZlIHN1Z2dl
c3RzIHRoaXMgY2Fubm90IGhhcHBlbiwgV0FSTiBpZiBpdCBhY3R1YWxseQo+IGhhcHBlbnMuCj4K
PiBUaGlzIHdheSB3ZSBjYW4gbWFyayBiaW9fYWRkX3BhZ2VzIGFzIF9fbXVzdF9jaGVjay4KPgo+
IFNpZ25lZC1vZmYtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdk
Yy5jb20+Cj4gUmV2aWV3ZWQtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQG9wZW5z
b3VyY2Uud2RjLmNvbT4KCkFja2VkLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPgoKVGhh
bmtzIQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

