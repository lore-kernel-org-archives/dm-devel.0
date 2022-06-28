Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E1AC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 07:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656487868;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MdlPvUYCss/1YYHNLCe45DIzP7CY0+B57kaQ8yBgteA=;
	b=CeFx61zAD7+HSsYKGVhD7evHpu1RtpvUZMwssNfMvCXAbOguwex7frFKTQVryXnLZNvn13
	bxe2pzTqnnAfdml4DpRMUUnB5XM/wBq2w+7wURTYQFlKBr6UeYAM1NTsWuJ/Fhp//V81Ua
	ElLPErQyqkvkDFzr1PkqUdpIFLzUTqw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-Giz7yqGmOuashF1CHr4w2w-1; Wed, 29 Jun 2022 03:31:05 -0400
X-MC-Unique: Giz7yqGmOuashF1CHr4w2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EC61801E6B;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF7B2112131B;
	Wed, 29 Jun 2022 07:31:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E4C721947070;
	Wed, 29 Jun 2022 07:31:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 322F619466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 18:32:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21DE8C15D42; Tue, 28 Jun 2022 18:32:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D2DCC23DBF
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:32:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04E7A29AA3AE
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:32:54 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-Iw1YZCkMNjSDq1PqIqM5OA-1; Tue, 28 Jun 2022 14:32:50 -0400
X-MC-Unique: Iw1YZCkMNjSDq1PqIqM5OA-1
Received: by mail-qv1-f53.google.com with SMTP id p31so21328919qvp.5;
 Tue, 28 Jun 2022 11:32:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9MO8TEEfnuBc61++YqvTNJiEplsc1bJUer/EJhWfW8g=;
 b=apBg6p6VjBv8u6YXWiOIkc7pC9QncHKu3R2Us1vHl1tCJ5kMPXtAoYXIuv5wO6/Ovu
 eJhnvkEFYMv1RIGpRkB8OVHltRhMz6z2H2pcXx316S0AHgcx4jkgNUP3lftyU2/et2Kp
 f4vFuA4nFlQz+vM0YkZCPI4dukzAaBa39S7PL+39xtlrHdpwTF25m8H+BqbiPILlHPU5
 8TC0SP4xK2OaNZISVgGwTg/M6nICpMYRuq5w8BDlEDh9vTgjlvVNCQPFj1C+NEzkyU72
 X3swtiTaeHGWEEnS493gosIp1XrJ+rW7fvrH4FBCHE1cqg1UL5UdS3inshLklC+DTudN
 cYdQ==
X-Gm-Message-State: AJIora8A4ZkMp6aOQFvGnCfUnmRi9sEfsLxor6A96IuZjjGJzwXvfyIJ
 y5e4WTaUFX81c6Vsel8W+g==
X-Google-Smtp-Source: AGRyM1t+qH5DVCkRhwfo5JxkCaB05+/Bj3qGcHKm7szHoMoFaCceNDjKXbyX8wBcoxiezW63J8SFvw==
X-Received: by 2002:a05:622a:14c8:b0:306:724c:811c with SMTP id
 u8-20020a05622a14c800b00306724c811cmr14597597qtx.394.1656441169418; 
 Tue, 28 Jun 2022 11:32:49 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 h21-20020ac87155000000b0031903373904sm6453598qtp.43.2022.06.28.11.32.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 11:32:48 -0700 (PDT)
Date: Tue, 28 Jun 2022 14:32:47 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 29 Jun 2022 07:31:01 +0000
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
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28, 2022 at 12:13:06PM -0600, Jens Axboe wrote:
> It's much less about using whatever amount of memory for inflight IO,
> and much more about not bloating fast path structures (of which the bio
> is certainly one). All of this gunk has to be initialized for each IO,
> and that's the real issue.
> 
> Just look at the recent work for iov_iter and why ITER_UBUF makes sense
> to do.
> 
> This is not a commentary on this patchset, just a general observation.
> Sizes of hot data structures DO matter, and quite a bit so.

Younger me would have definitely been in agreement; initializing these structs
definitely tends to show up in profiles.

These days I'm somewhat less inclined towards that view - profiles naturally
highlight where your cache misses are happening, and initializing a freshly
allocated data structure is always going to be a cache miss. But the difference
between touching 3 and 6 contiguous cachelines is practically nil...  assuming
we aren't doing anything stupid like using memset (despite what Linus wants from
the CPU vendors, rep stos _still_ sucks) and perhaps inserting prefetches where
appropriate.

And I see work going by that makes me really wonder if it was justified - in
particular I _really_ want to know if Christoph's bio initialization change was
justified by actual benchmarks and what those numbers were, vs. looking at
profiles. Wasn't anything in the commit log...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

