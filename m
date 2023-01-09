Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D81DC54EBD
	for <dm-devel@archiver.kernel.org>; Mon,  9 Jan 2023 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673276532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dd24OIxxzzC+6beyIk6fGx+aDQpT3O20ug0sKiG9gXM=;
	b=K4StCHOKSj9ZrLB2O7BMHxFFYo/96ucyfYzeE23SDpgZM92AxwxdoOe+nuWF5TXxx+oTfu
	40/sPk7j3diQfWkoA5roEXYokNvG7XyogadcWeuoNpfhvVW1J7UMDGzgm1yqpSLLlJstjr
	jPiyXkz3QEqjeIV+g3CtfXQ2yrNm+YI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-iEA7FGQTNMaww97DBqjE_g-1; Mon, 09 Jan 2023 10:02:10 -0500
X-MC-Unique: iEA7FGQTNMaww97DBqjE_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E8BF3C10689;
	Mon,  9 Jan 2023 15:02:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 768CBC16027;
	Mon,  9 Jan 2023 15:02:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 591D91947BBB;
	Mon,  9 Jan 2023 15:02:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B26111946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Jan 2023 15:01:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84C1B140EBF6; Mon,  9 Jan 2023 15:01:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D1D8140EBF5
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 15:01:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CC46185A794
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 15:01:54 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-22-Sm7-sMCfOXSoEulgwsbzkA-1; Mon, 09 Jan 2023 10:01:46 -0500
X-MC-Unique: Sm7-sMCfOXSoEulgwsbzkA-1
Received: by mail-qt1-f198.google.com with SMTP id
 bb12-20020a05622a1b0c00b003a98dd528f0so3980327qtb.13
 for <dm-devel@redhat.com>; Mon, 09 Jan 2023 07:01:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=5BnqkcP/B7SGlD7ivTZ2uRzTlawgLKPgKJY+C2gEHLI=;
 b=KgtgVdIQ/nEG1OccNg8G6MLrZ6DJZBlmbc4qaoQabEzCLqT+nvaiwJcCZWUvkhOevn
 6wy4UQMF75K6DvqsoDucmp86yzv2Lx7+ubKSrZt8Rq9ed3x0/E3ZJXHWgCi/ZcMhrd/e
 SbdR/utGmlsxTLm2+SVUDIhsx31WRVlA0uvXSML1oRg3y376M0nFVtICsN5axWekLqJx
 Ri7a1AGfH9eXhAuLuMjLSnnwsHFuqL4CImETYwX8UDivaPCCVNHphPNO3jigzbN49QSm
 UKeVl4u5AehCZtSfUaUxmMEaJK98wWOmPRl0DdidR9g1CZo7ujh2lnBZ+rX7k2SzRbhm
 oEew==
X-Gm-Message-State: AFqh2kp2dJ8WzR+Oe3NmFkRBt2dF+a1wpzWbvlqcwaiRjyFlocZ4O3d6
 sEhhSYp/zIWDE+nsLAwkN1QWXsGqWez3YkIAbsG5eqBy6uAUowWW5pRYciq3fnV3PN/cvd6uA3v
 aqiKQaHLQlD7MH4w=
X-Received: by 2002:ac8:6b4c:0:b0:39c:da20:d47c with SMTP id
 x12-20020ac86b4c000000b0039cda20d47cmr84648926qts.17.1673276506393; 
 Mon, 09 Jan 2023 07:01:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvzZP+QWbMTML85dKaCimKI1eGsnIuLcS2Bp/8ib3jUiLno1dRkiK90vxVouiizF3DOW2wqRA==
X-Received: by 2002:ac8:6b4c:0:b0:39c:da20:d47c with SMTP id
 x12-20020ac86b4c000000b0039cda20d47cmr84648900qts.17.1673276506083; 
 Mon, 09 Jan 2023 07:01:46 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 bi1-20020a05620a318100b006fb0e638f12sm5457812qkb.4.2023.01.09.07.01.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Jan 2023 07:01:45 -0800 (PST)
Date: Mon, 9 Jan 2023 10:02:46 -0500
From: Brian Foster <bfoster@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <Y7wsluqX+eFqV1XB@bfoster>
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
 <20221229081252.452240-7-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20221229081252.452240-7-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 6/7] ext4: Add mount option for
 provisioning blocks during allocations
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 sarthakkukreti@google.com, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 29, 2022 at 12:12:51AM -0800, Sarthak Kukreti wrote:
> Add a mount option that sets the default provisioning mode for
> all files within the filesystem.
> 

There's not much description here to explain what a user should expect
from this mode. Should the user expect -ENOSPC from the lower layers
once out of space? What about files that are provisioned by the fs and
then freed? Should the user/admin know to run fstrim or also enable an
online discard mechanism to ensure freed filesystem blocks are returned
to the free pool in the block/dm layer in order to avoid premature fs
-ENOSPC conditions?

Also, what about dealing with block level snapshots? There is some
discussion on previous patches wrt to expectations on how provision
might handle unsharing of cow'd blocks. If the fs only provisions on
initial allocation, then a subsequent snapshot means we run into the
same sort of ENOSPC problem on overwrites of already allocated blocks.
That also doesn't consider things like an internal log, which may have
been physically allocated (provisioned?) at mkfs time and yet is subject
to the same general problem.

So what is the higher level goal with this sort of mode? Is
provision-on-alloc sufficient to provide a practical benefit to users,
or should this perhaps consider other scenarios where a provision might
be warranted before submitting writes to a thinly provisioned device?

FWIW, it seems reasonable to me to introduce this without snapshot
support and work toward it later, but it should be made clear what is
being advertised in the meantime. Unless there's some nice way to
explicitly limit the scope of use, such as preventing snapshots or
something, the fs might want to consider this sort of feature
experimental until it is more fully functional.

Brian

> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  fs/ext4/ext4.h    | 1 +
>  fs/ext4/extents.c | 7 +++++++
>  fs/ext4/super.c   | 7 +++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 49832e90b62f..29cab2e2ea20 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1269,6 +1269,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT2_MB_OPTIMIZE_SCAN	0x00000080 /* Optimize group
>  						    * scanning in mballoc
>  						    */
> +#define EXT4_MOUNT2_PROVISION		0x00000100 /* Provision while allocating file blocks */
>  
>  #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
>  						~EXT4_MOUNT_##opt
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 2e64a9211792..a73f44264fe2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4441,6 +4441,13 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  	unsigned int credits;
>  	loff_t epos;
>  
> +	/*
> +	 * Attempt to provision file blocks if the mount is mounted with
> +	 * provision.
> +	 */
> +	if (test_opt2(inode->i_sb, PROVISION))
> +		flags |= EXT4_GET_BLOCKS_PROVISION;
> +
>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
>  	map.m_lblk = offset;
>  	map.m_len = len;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 260c1b3e3ef2..5bc376f6a6f0 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1591,6 +1591,7 @@ enum {
>  	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
>  	Opt_no_prefetch_block_bitmaps, Opt_mb_optimize_scan,
>  	Opt_errors, Opt_data, Opt_data_err, Opt_jqfmt, Opt_dax_type,
> +	Opt_provision, Opt_noprovision,
>  #ifdef CONFIG_EXT4_DEBUG
>  	Opt_fc_debug_max_replay, Opt_fc_debug_force
>  #endif
> @@ -1737,6 +1738,8 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
>  	fsparam_flag	("reservation",		Opt_removed),	/* mount option from ext2/3 */
>  	fsparam_flag	("noreservation",	Opt_removed),	/* mount option from ext2/3 */
>  	fsparam_u32	("journal",		Opt_removed),	/* mount option from ext2/3 */
> +	fsparam_flag	("provision",		Opt_provision),
> +	fsparam_flag	("noprovision",		Opt_noprovision),
>  	{}
>  };
>  
> @@ -1826,6 +1829,8 @@ static const struct mount_opts {
>  	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
>  	{Opt_no_prefetch_block_bitmaps, EXT4_MOUNT_NO_PREFETCH_BLOCK_BITMAPS,
>  	 MOPT_SET},
> +	{Opt_provision, EXT4_MOUNT2_PROVISION, MOPT_SET | MOPT_2},
> +	{Opt_noprovision, EXT4_MOUNT2_PROVISION, MOPT_CLEAR | MOPT_2},
>  #ifdef CONFIG_EXT4_DEBUG
>  	{Opt_fc_debug_force, EXT4_MOUNT2_JOURNAL_FAST_COMMIT,
>  	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
> @@ -2977,6 +2982,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
>  		SEQ_OPTS_PUTS("dax=never");
>  	} else if (test_opt2(sb, DAX_INODE)) {
>  		SEQ_OPTS_PUTS("dax=inode");
> +	} else if (test_opt2(sb, PROVISION)) {
> +		SEQ_OPTS_PUTS("provision");
>  	}
>  
>  	if (sbi->s_groups_count >= MB_DEFAULT_LINEAR_SCAN_THRESHOLD &&
> -- 
> 2.37.3
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

