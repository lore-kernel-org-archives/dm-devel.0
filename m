Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBB1C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 08:31:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-MgMI9w8JO3aTWZ0PFgdxcQ-1; Mon, 31 Jan 2022 03:31:01 -0500
X-MC-Unique: MgMI9w8JO3aTWZ0PFgdxcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 374D7801B0B;
	Mon, 31 Jan 2022 08:30:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB70C60C36;
	Mon, 31 Jan 2022 08:30:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90BC94A7C9;
	Mon, 31 Jan 2022 08:30:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RLcMMM015355 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 16:38:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EACAD141DC5D; Thu, 27 Jan 2022 21:38:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7193141DC2C
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 21:38:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE99F3C021B1
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 21:38:21 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
	[209.85.167.43]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-482-E95QyBq8PUu28nhDxxzElQ-1; Thu, 27 Jan 2022 16:38:19 -0500
X-MC-Unique: E95QyBq8PUu28nhDxxzElQ-1
Received: by mail-lf1-f43.google.com with SMTP id x23so8022772lfc.0;
	Thu, 27 Jan 2022 13:38:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=z+U+izVFukrEKq10kL5qCCsiT3qJmeLAo+mnNrOVCPU=;
	b=2yKf8ADJeL0y7AgeezVoTpU8wtzroCDXMsf7I6HaeMhfmViVJTZhoboXwLDuXDF38H
	4w86t6fVJ1cEa4Re0dNe5dSSzPDDIe+ObjzCfDDn5nGRUPfJqojz4Keh6t+XT9UwwcJD
	oKwcNmf5FgNCq8SHfb4sXjgiNzkazEn0R19nbqEGrYilB4RlSZB1J1YRfebpWiohZNyp
	Lx5XQamlKNtXInNG2Y09fq+NThCnbRwGGkO3FOJkAKzs7KTv+MEGLigar9FYcge+FBWO
	iQya3n1XkyEUa78HhILjVLnPvH9Xgvx/qvf0yMBVW/nNH9DH9/5vTIdIrU9OqcnCdY6j
	qVXA==
X-Gm-Message-State: AOAM533/LI/mqOrVEVbZ9WWdVWidE8elToMBlG+FWwKifyOZ5RJeUvQC
	TJAUD8T36lJ6urYmNLKBM0TPr2GBMcsgZ7bu/3Y=
X-Google-Smtp-Source: ABdhPJxaVoQ4SfBVmSOjFCGrgluhZGplrFWaRNqk5pMVob8JHRQWRWEKNtxwMeMPmpBWjy5SR70YaIdo0zrC/X/8wRA=
X-Received: by 2002:ac2:58f7:: with SMTP id v23mr4043478lfo.390.1643319497799; 
	Thu, 27 Jan 2022 13:38:17 -0800 (PST)
MIME-Version: 1.0
References: <20220124091107.642561-1-hch@lst.de>
	<20220124091107.642561-3-hch@lst.de>
In-Reply-To: <20220124091107.642561-3-hch@lst.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 28 Jan 2022 06:38:05 +0900
Message-ID: <CAKFNMomoLqbbOwg5d6aBHCyGT5v+NF=N2Rm3QwYk8NDXsoJHtA@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 31 Jan 2022 03:30:51 -0500
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>,
	device-mapper development <dm-devel@redhat.com>,
	"Md . Haris Iqbal" <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 02/19] nilfs2: remove nilfs_alloc_seg_bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24, 2022 at 6:11 PM Christoph Hellwig <hch@lst.de> wrote:
>
> bio_alloc will never fail when it can sleep.  Remove the now simple
> nilfs_alloc_seg_bio helper and open code it in the only caller.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nilfs2/segbuf.c | 31 ++++---------------------------
>  1 file changed, 4 insertions(+), 27 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks!

Ryusuke Konishi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

