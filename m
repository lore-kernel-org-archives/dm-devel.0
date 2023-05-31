Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F028C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685548286;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bVYt2YHSAjMLZfA+IhQrcPP+BP6QaErham+i3yoILMY=;
	b=bLex+BKy0/osmnWNDEgvvQOlogAMcLwKnEnPOpqUJqPXCFevWHgFRPxAH5edCENDN6CcFS
	5hut4CVPBQG++tk2uXThU0FhhPJtXho1BCp6vyGzgCWfYj/OrJw9GjKRUvAdEgY8UJkKeW
	zV23zusdLCX1k2iRKEKy8ejHX7+FOXw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-6ofrHy32ONa2DTJcbhHQQw-1; Wed, 31 May 2023 11:51:25 -0400
X-MC-Unique: 6ofrHy32ONa2DTJcbhHQQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A365811E7C;
	Wed, 31 May 2023 15:51:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3707D40CFD45;
	Wed, 31 May 2023 15:51:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CD6619465BC;
	Wed, 31 May 2023 15:51:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6ACD21946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:50:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4692B112132D; Wed, 31 May 2023 15:50:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E7CE112132C
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:50:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23B2D80120A
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:50:22 +0000 (UTC)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-kZiTHELRN1KlIO7u3f2M0A-1; Wed, 31 May 2023 11:50:20 -0400
X-MC-Unique: kZiTHELRN1KlIO7u3f2M0A-1
Received: by mail-il1-f173.google.com with SMTP id
 e9e14a558f8ab-33110a36153so1282555ab.0
 for <dm-devel@redhat.com>; Wed, 31 May 2023 08:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685548219; x=1688140219;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Kr7AYf3i1eBygjzH5q6AjnbmzDMGTDydvzH6ggOcr8w=;
 b=kYkdMjlrQHRG5/TSuLfkchc2RznSGc8jQOpvbYRFaJ3fViE4NOYVfgpgQOUXFeWbue
 d7PR6W5FiRHObZGHLCuxFOfrprNZbLrCdGa6xLVVYev8UF+zpUaURv5mPfIR7Q7fkG4t
 /b1r0hMJxwKUSFEg4kHsDiEP4QU9IoIhjzWVojddRaSUE1Qsk99fcDzJlHk67snmGXHO
 QrQ3FLWpfK6ubfms/HWHUHtZ9CEnlG4RTJArUao7L7r2XIvBzgFR9lPUJK5SYr7lcHwU
 tCnJgAsNmOF0ThHgNM+kDd9eerOOywD5UGcZ6ouEMgJaQFERGjIng9X15U2PljUg74eH
 X/bQ==
X-Gm-Message-State: AC+VfDxRk7jNXd4EtP7yI1tFr6QrOVx3aDYxfWIALy+vna6otikW4QzM
 xzGPD48P4gnv3tWn0Edewkjz1w==
X-Google-Smtp-Source: ACHHUZ4Vc5K9goUssaOAlBejpFmpFM1M2MosneBhWp7jmoz34Mcc3cGA6Lj397yP4Jgger0rhBRBog==
X-Received: by 2002:a05:6e02:1061:b0:32b:51df:26a0 with SMTP id
 q1-20020a056e02106100b0032b51df26a0mr1411548ilj.2.1685548219545; 
 Wed, 31 May 2023 08:50:19 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 a4-20020a927f04000000b0033355fa5440sm3211579ild.37.2023.05.31.08.50.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 May 2023 08:50:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1685532726.git.johannes.thumshirn@wdc.com>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com>
Message-Id: <168554821814.183617.716542495633198655.b4-ty@kernel.dk>
Date: Wed, 31 May 2023 09:50:18 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v7 00/20] bio: check return values of
 bio_add_page
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 jfs-discussion@lists.sourceforge.net, Matthew Wilcox <willy@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 linux-fsdevel@vger.kernel.org, gouha7@uniontech.com,
 Christoph Hellwig <hch@lst.de>, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Wed, 31 May 2023 04:50:23 -0700, Johannes Thumshirn wrote:
> We have two functions for adding a page to a bio, __bio_add_page() which is
> used to add a single page to a freshly created bio and bio_add_page() which is
> used to add a page to an existing bio.
> 
> While __bio_add_page() is expected to succeed, bio_add_page() can fail.
> 
> This series converts the callers of bio_add_page() which can easily use
> __bio_add_page() to using it and checks the return of bio_add_page() for
> callers that don't work on a freshly created bio.
> 
> [...]

Applied, thanks!

[01/20] swap: use __bio_add_page to add page to bio
        commit: cb58bf91b138c1a8b18cca9503308789e26e3522
[02/20] drbd: use __bio_add_page to add page to bio
        commit: 8f11f79f193c935da617375ba5ea4e768a73a094
[03/20] dm: dm-zoned: use __bio_add_page for adding single metadata page
        commit: fc8ac3e539561aff1c0a255d701d9412d425373c
[04/20] fs: buffer: use __bio_add_page to add single page to bio
        commit: 741af75d4027b1229fc6e62f4e3c4378dfe04897
[05/20] md: use __bio_add_page to add single page
        commit: 3c383235c51dcd6198d37ac3ac06e2acad79f981
[06/20] md: raid5-log: use __bio_add_page to add single page
        commit: b0a2f17cad9d3fa564d67c543f5d19343401fefd
[07/20] md: raid5: use __bio_add_page to add single page to new bio
        commit: 6eea4ff8528d6a5b9f0eeb47992e48a8f44b5b8f
[08/20] jfs: logmgr: use __bio_add_page to add single page to bio
        commit: 2896db174ced7a800863223f9e74543b98271ba0
[09/20] gfs2: use __bio_add_page for adding single page to bio
        commit: effa7ddeeba782406c81b572791a142fbdaf6b05
[10/20] zonefs: use __bio_add_page for adding single page to bio
        commit: 0fa5b08cf6e17b0a64ffcc5894d8efe186691ab8
[11/20] zram: use __bio_add_page for adding single page to bio
        commit: 34848c910b911838e1e83e1370cb988b578c8860
[12/20] floppy: use __bio_add_page for adding single page to bio
        commit: 5225229b8fdfb3e65520c43547ecf9a737161c3f
[13/20] md: check for failure when adding pages in alloc_behind_master_bio
        commit: 6473bc325644b9c8473e6c92bfb520a68dce1e12
[14/20] md: raid1: use __bio_add_page for adding single page to bio
        commit: 2f9848178cfa4ac68a5b46e63e5163a09b8bd80f
[15/20] md: raid1: check if adding pages to resync bio fails
        commit: 33332be32fe91ff54ff326b3a1608973544e835a
[16/20] dm-crypt: use __bio_add_page to add single page to clone bio
        commit: 9be63ecfdd63f957b9ed25eaf85666d22a02d7a5
[17/20] block: mark bio_add_page as __must_check
        commit: 5b3e39c1cc8e1cf31a398830dd665eb15546b4f7
[18/20] block: add bio_add_folio_nofail
        commit: 42205551d1d43b1b42942fb7ef023cf954136cea
[19/20] fs: iomap: use bio_add_folio_nofail where possible
        commit: f31c58ab3ddaf64503d7988197602d7443d5be37
[20/20] block: mark bio_add_folio as __must_check
        commit: 9320744e4dbe10df6059b2b6531946c200a0ba3b

Best regards,
-- 
Jens Axboe



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

