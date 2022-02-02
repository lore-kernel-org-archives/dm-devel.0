Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C9BC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 14:50:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-UTzdTRf0NOKivzOOQTKCxA-1; Wed, 02 Feb 2022 09:50:46 -0500
X-MC-Unique: UTzdTRf0NOKivzOOQTKCxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA12886A8CA;
	Wed,  2 Feb 2022 14:50:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9827A1086487;
	Wed,  2 Feb 2022 14:50:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6D024BB7C;
	Wed,  2 Feb 2022 14:50:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212EobpA001880 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 09:50:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0740C33AE5; Wed,  2 Feb 2022 14:50:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC892C33AE3
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 14:50:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A247B3C02B67
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 14:50:37 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
	[209.85.214.179]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-495-OnLvItYxNdu9KLUS6gg7nQ-1; Wed, 02 Feb 2022 09:50:33 -0500
X-MC-Unique: OnLvItYxNdu9KLUS6gg7nQ-1
Received: by mail-pl1-f179.google.com with SMTP id j16so18496655plx.4
	for <dm-devel@redhat.com>; Wed, 02 Feb 2022 06:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=IAkJ25VWGHpvo748Ps3jmA0wCxSeGiRhv8GghNIjjCc=;
	b=Zg1saU0B/GGDYNjUHmdOs5+dsa/4O+csJBZEFxRUAzAJf5J0S7ACPoU9aaJM4Ke3ef
	DJwubERjjuoDBhCOHRi2i3K99It112nvN4Or3+MfOUTG/6fOq/ZTsNDXFbBq4PMN11AT
	xtXAe4P12hblJsaWDEa9MHe+trYKSLdG9/WiNR17ddHzbRyCaf+zsLxWLB//S1dAx6OO
	aXv/9XoedTSNc3N3Gy2ewTZVRSuK1maAsrAiGfRJPh9BuATnykw090KO6tAvAu+XOuEz
	UP9HhRvDqb4E0eBb2R0RmzXrC+X2NL+USDbX5YLi3b9lcZLKCvtuZGCrQ+GCSs209M/L
	gXOA==
X-Gm-Message-State: AOAM530CdwdqVTYIzpRTc3/Cc2Nnx0GfPHnD6KBex10N13jQwJXCREpj
	AdmmAAFpu0X4gV+pUd0Vt8hzSg==
X-Google-Smtp-Source: ABdhPJwSLudBNjLMeTvPHLIsOXD+1k6FRXpLWDFks6w4HVgPtg5F+Tt+QBkGoHPVlgrjEzbfwYXf1A==
X-Received: by 2002:a17:903:2305:: with SMTP id
	d5mr30165640plh.122.1643813432532; 
	Wed, 02 Feb 2022 06:50:32 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id
	u18sm27070556pfi.185.2022.02.02.06.50.31
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Feb 2022 06:50:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220124091107.642561-1-hch@lst.de>
References: <20220124091107.642561-1-hch@lst.de>
Message-Id: <164381343094.170143.694743005104706258.b4-ty@kernel.dk>
Date: Wed, 02 Feb 2022 07:50:30 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,  Philipp
	Reisner <philipp.reisner@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, Konstantin
	Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?Q?_Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Lars
	Ellenberg <lars.ellenberg@linbit.com>, linux-fsdevel@vger.kernel.org,
	xen-devel@lists.xenproject.org, Andrew
	Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] improve the bio allocation interface v2
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 24 Jan 2022 10:10:48 +0100, Christoph Hellwig wrote:
> this series is posted early because it has wide-ranging changes and could use some
> early ACKs before -rc1.
> 
> It changes the interface to the bio allocators to always pass a block_device and
> the operation, which is information needed for every bio submitted through
> bio_submit.  This means the fields can be directly initialized in bio_init instead
> of first being zeroed and thus should help to micro-optimize even better than the
> __bio_set_dev that Pavel proposed while also cleaning up code.
> 
> [...]

Applied, thanks!

[01/19] fs: remove mpage_alloc
        commit: d5f68a42da7a4516e7503c281a54a58727f07dc3
[02/19] nilfs2: remove nilfs_alloc_seg_bio
        commit: f0d911927b3c7cf5f9edb5941d0287144a602d0d
[03/19] nfs/blocklayout: remove bl_alloc_init_bio
        commit: 5d2ca2132f889bc2c90d6d07fc9fc129cfee8955
[04/19] ntfs3: remove ntfs_alloc_bio
        commit: 39146b6f66ba5c107d5c5758a17f290846165b4d
[05/19] dm: bio_alloc can't fail if it is allowed to sleep
        commit: 53db984e004c7116ce69e2f4a163664453336ae1
[06/19] dm-crypt: remove clone_init
        commit: 3f868c09ea8f40f800c4c644c072d91c9eee0d71
[07/19] dm-snap: use blkdev_issue_flush instead of open coding it
        commit: eba33b8ef1b90d8996eceb0569c06a4f784ef2b5
[08/19] dm-thin: use blkdev_issue_flush instead of open coding it
        commit: 28d7d128aad5cd2178b158900d58365d1fd3de94
[09/19] drbd: bio_alloc can't fail if it is allow to sleep
        commit: 4b1dc86d1857f1007865cab759f2285280692eee
[10/19] rnbd-srv: simplify bio mapping in process_rdma
        commit: 1fe0640ff94feae6d21417e2f4f2829b882274b1
[11/19] rnbd-srv: remove struct rnbd_dev_blk_io
        commit: d7b78de2b1552e3e7ce3a069f075cc2729aa5c34
[12/19] xen-blkback: bio_alloc can't fail if it is allow to sleep
        commit: 7d8d0c658d48705fca35238a8ff601b7c5cbc0de
[13/19] block: move blk_next_bio to bio.c
        commit: 3b005bf6acf009abd700e2c652c86e5c209cf63d
[14/19] block: pass a block_device and opf to blk_next_bio
        commit: 0a3140ea0fae377c9eaa031b7db1670ae422ed47
[15/19] block: pass a block_device and opf to bio_alloc_bioset
        commit: 609be1066731fea86436f5f91022f82e592ab456
[16/19] block: pass a block_device and opf to bio_alloc_kiocb
        commit: b77c88c2100ce6a5ec8126c13599b5a7f6663e32
[17/19] block: pass a block_device and opf to bio_alloc
        commit: 07888c665b405b1cd3577ddebfeb74f4717a84c4
[18/19] block: pass a block_device and opf to bio_init
        commit: 49add4966d79244013fce35f95c6833fae82b8b1
[19/19] block: pass a block_device and opf to bio_reset
        commit: a7c50c940477bae89fb2b4f51bd969a2d95d7512

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

