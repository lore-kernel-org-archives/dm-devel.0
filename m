Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C822ACCA483
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:38:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-YJoEdJA_OPWzBseYUHMrBg-1; Tue, 28 Jun 2022 02:38:06 -0400
X-MC-Unique: YJoEdJA_OPWzBseYUHMrBg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76131805B8A;
	Tue, 28 Jun 2022 06:38:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CC3B492CA4;
	Tue, 28 Jun 2022 06:38:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C56CE194704D;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBBB51947040
 for <dm-devel@listman.corp.redhat.com>; Sun, 26 Jun 2022 20:15:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7AC75492CA5; Sun, 26 Jun 2022 20:15:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76968492CA3
 for <dm-devel@redhat.com>; Sun, 26 Jun 2022 20:15:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EBF63C1015A
 for <dm-devel@redhat.com>; Sun, 26 Jun 2022 20:15:03 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-PAHfh8npPTC_4HfKCZy7Rw-1; Sun, 26 Jun 2022 16:15:01 -0400
X-MC-Unique: PAHfh8npPTC_4HfKCZy7Rw-1
Received: by mail-qv1-f47.google.com with SMTP id y14so12175777qvs.10;
 Sun, 26 Jun 2022 13:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SC11fPbmGhwe/HFGa6xIWCfkHncSeLbd/U+Eo/PJLJ0=;
 b=knf6m2OD+8r2X/Y+ytny9O0xNnVHEEhbP8TlBlVdO0KUO5zc7V8vCY8TYEptYA3Eax
 3YXcGGrk9mOvYSD8Ts368UUgWwNv/NrO8ylVn/1ApPd3vQ/vM71ZBR9G3MqCCTPQfSMR
 q/JvfhzyILCj97y5KYpWG9CAdBakb9iMd/e/NXtgPYFC8eF6GPWs9g3//BUFVn4qiMFR
 iN+NrmP4Q0mW23NeCfSwNvBNIX6EqgAQqUp4Smdf7ZwbXrFrTAcP0kX90ngrHeRfqAIl
 EvzjI12g3YaQvsBXE1B0qmNwVaXNN2x9XzsSkQw+OAh8Qf6NtnGjoHakzbroD5OP7qyV
 ayHg==
X-Gm-Message-State: AJIora+y21ctPiz3X54CMrts93V+oB8rtN5U6aNbqfec3z5qbixplfm+
 y3qUEk5IVT4R+IhO4c+3xPwAMsPjxI38OAg=
X-Google-Smtp-Source: AGRyM1syJ1I0Gigy4oxMoBw1RXUSvYhgAG9+m4iR0XvFRzxhbc1EDxQC2xSD+V/WLQtZJI22NPGrIg==
X-Received: by 2002:a0c:a98a:0:b0:470:5200:8c61 with SMTP id
 a10-20020a0ca98a000000b0047052008c61mr6480960qvb.122.1656274499872; 
 Sun, 26 Jun 2022 13:14:59 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 g84-20020a379d57000000b0069c72b41b59sm7060197qke.2.2022.06.26.13.14.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 26 Jun 2022 13:14:59 -0700 (PDT)
Date: Sun, 26 Jun 2022 16:14:58 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220624141255.2461148-2-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Tue, 28 Jun 2022 06:38:00 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 24, 2022 at 10:12:52PM +0800, Ming Lei wrote:
> Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removes
> the similar API because the following reasons:
> 
>     ```
>     It is pointed that bio_rewind_iter() is one very bad API[1]:
> 
>     1) bio size may not be restored after rewinding
> 
>     2) it causes some bogus change, such as 5151842b9d8732 (block: reset
>     bi_iter.bi_done after splitting bio)
> 
>     3) rewinding really makes things complicated wrt. bio splitting
> 
>     4) unnecessary updating of .bi_done in fast path
> 
>     [1] https://marc.info/?t=153549924200005&r=1&w=2
> 
>     So this patch takes Kent's suggestion to restore one bio into its original
>     state via saving bio iterator(struct bvec_iter) in bio_integrity_prep(),
>     given now bio_rewind_iter() is only used by bio integrity code.
>     ```
> 
> However, it isn't easy to restore bio by saving 32 bytes bio->bi_iter, and saving
> it only can't restore crypto and integrity info.
> 
> Add bio_rewind() back for some use cases which may not be same with
> previous generic case:
> 
> 1) most of bio has fixed end sector since bio split is done from front of the bio,
> if driver just records how many sectors between current bio's start sector and
> the bio's end sector, the original position can be restored
> 
> 2) if one bio's end sector won't change, usually bio_trim() isn't called, user can
> restore original position by storing sectors from current ->bi_iter.bi_sector to
> bio's end sector; together by saving bio size, 8 bytes can restore to
> original bio.
> 
> 3) dm's requeue use case: when BLK_STS_DM_REQUEUE happens, dm core needs to
> restore to the original bio which represents current dm io to be requeued.
> By storing sectors to the bio's end sector and dm io's size,
> bio_rewind() can restore such original bio, then dm core code needn't to
> allocate one bio beforehand just for handling BLK_STS_DM_REQUEUE which
> is actually one unusual event.
> 
> 4) Not like original rewind API, this one needn't to add .bi_done, and no any
> effect on fast path

It seems like perhaps the real issue here is that we need a real bio_iter,
separate from bvec_iter, that also encapsulates iterating over integrity &
fscrypt. 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

