Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D0CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652978365;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=46I975VlApLRWCsOldYShhD2XLIew+4ebZfCpHnbuR4=;
	b=MKmhNqm2fMuqbIkv6Bj1OqkNm6p/MoCpwiAWcD0MQZm8NrKRRsGsWQD8g3fYZsLjXbILli
	YdMJ6KSy4f0om2IVosKUZSyPwyHy/nP6r46YInRG7HuW7mVonKk5lholZRPYYZRvNKvQS+
	2jkAhrbt/kT9XtC1k2vYBopobZ4WdKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-zVWpawQvPcaMeVpEz5kzAQ-1; Thu, 19 May 2022 12:39:22 -0400
X-MC-Unique: zVWpawQvPcaMeVpEz5kzAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B9C685A5BA;
	Thu, 19 May 2022 16:39:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 14D332026D6A;
	Thu, 19 May 2022 16:39:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D5F561949759;
	Thu, 19 May 2022 16:39:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BC0C194975B
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 16:39:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0ACA4492CA2; Thu, 19 May 2022 16:39:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 06C24492C3B
 for <dm-devel@redhat.com>; Thu, 19 May 2022 16:39:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2D3085A5B5
 for <dm-devel@redhat.com>; Thu, 19 May 2022 16:39:17 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-L6WRrXVoNJGJyeG99Ir86Q-1; Thu, 19 May 2022 12:39:16 -0400
X-MC-Unique: L6WRrXVoNJGJyeG99Ir86Q-1
Received: by mail-qk1-f200.google.com with SMTP id
 a5-20020ae9e805000000b006a034b31384so4561340qkg.8
 for <dm-devel@redhat.com>; Thu, 19 May 2022 09:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=I53QjqK9knPSZgQrLxB+sWMD/vHWzk2y+pP08p6DGX8=;
 b=LoSin372nVW4H0qGfTJfggEyUGoicN1MOfjKgwBE+nIbviDb3rUsR+gpmBuH1jlv29
 OMRi5GblBIXheI5OokOo/xeNDCPyIInUVl5f0GH1oIgDJhlhB1SGUWST7H4vRFlnSxCm
 w1rhjhli9otKt/mIx+crwsk5dz4yJkdmdNPhwbVKJwowyJxwRhIFNI6lvTTckjEfbqPc
 Uf0KLKRBgzdnui/uFfRysqjrzLTed5iukkUERfdFnDpg8j5bVXsVIbqI8nNBDj/lbqfc
 GhbK3oZ3hm+6gUcmux3uw07jtzdh4fxj0cx8e4ZEnebKfhjZlDBh4Z2/FZBmEOxHVxnu
 GwCg==
X-Gm-Message-State: AOAM530icLIFBiQWm546nYy62xqzFze9fPvBV/+eMMe2g+wcLo/wHN04
 hAUt/ElSxfLdX116ok+1AR6/oRqbXSPiXuQNgBYuDC7LPW/3gAyOwycmWzyGe9GhcFDE0wrzfB0
 7z9YcPsUzoxAtAg==
X-Received: by 2002:a05:6214:23c8:b0:45f:b582:346e with SMTP id
 hr8-20020a05621423c800b0045fb582346emr4489053qvb.109.1652978356057; 
 Thu, 19 May 2022 09:39:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE4XvzRyyQ/iH98/VEW5SSAuQNUjP5i1KzJAXBbn/TV1kHaL1Umpu/2C6RLKySNENODzMMiQ==
X-Received: by 2002:a05:6214:23c8:b0:45f:b582:346e with SMTP id
 hr8-20020a05621423c800b0045fb582346emr4489026qvb.109.1652978355768; 
 Thu, 19 May 2022 09:39:15 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u124-20020ae9d882000000b0069fc13ce226sm1492716qkf.87.2022.05.19.09.39.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 19 May 2022 09:39:15 -0700 (PDT)
Date: Thu, 19 May 2022 12:39:14 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <YoZysmcnU6o2scFI@redhat.com>
References: <20220519004754.2174254-1-mka@chromium.org>
 <20220518174739.v5.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
MIME-Version: 1.0
In-Reply-To: <20220518174739.v5.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v5 1/3] dm: Add verity helpers for LoadPin
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
Cc: linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 James Morris <jmorris@namei.org>, Douglas Anderson <dianders@chromium.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 18 2022 at  8:47P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> LoadPin limits loading of kernel modules, firmware and certain
> other files to a 'pinned' file system (typically a read-only
> rootfs). To provide more flexibility LoadPin is being extended
> to also allow loading these files from trusted dm-verity
> devices. For that purpose LoadPin can be provided with a list
> of verity root digests that it should consider as trusted.
> 
> Add a bunch of helpers to allow LoadPin to check whether a DM
> device is a trusted verity device. The new functions broadly
> fall in two categories: those that need access to verity
> internals (like the root digest), and the 'glue' between
> LoadPin and verity. The new file dm-verity-loadpin.c contains
> the glue functions.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>
> ---
> 
> Changes in v5:
> - changed dm_verity_loadpin_is_sb_trusted() to
>   dm_verity_loadpin_is_bdev_trusted()
> - bumped version number to 1.8.1
> - deleted bad semicolon in declaration of stub for
>   dm_verity_loadpin_is_bdev_trusted()
> - added 'Acked-by' tag from Kees
> 
> Changes in v4:
> - a trusted verity device must have a single target of
>   type 'verity'
> - share list of verity digests with loadpin, deleted
>   dm_verity_loadpin_set_trusted_root_digests()
> - dm_verity_loadpin_is_md_trusted() is now dm_verity_loadpin_is_sb_trusted(),
>   it receives a super_block instead of mapped_device. Updated kernel doc.
> - changed struct trusted_root_digest to have an unsized
>   u8 array instead of a pointer
> - extend 'dm-verity-objs' instead of 'dm-mod-objs'
> 
> Changes in v3:
> - none
> 
> Changes in v2:
> - none
> 
>  drivers/md/Makefile               |  6 +++
>  drivers/md/dm-verity-loadpin.c    | 74 +++++++++++++++++++++++++++++++
>  drivers/md/dm-verity-target.c     | 35 ++++++++++++++-
>  drivers/md/dm-verity.h            |  4 ++
>  include/linux/dm-verity-loadpin.h | 27 +++++++++++
>  5 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/dm-verity-loadpin.c
>  create mode 100644 include/linux/dm-verity-loadpin.h
> 
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 0454b0885b01..71771901c823 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -108,6 +108,12 @@ ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
>  dm-verity-objs			+= dm-verity-verify-sig.o
>  endif
>  
> +ifeq ($(CONFIG_DM_VERITY),y)
> +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> +dm-verity-objs			+= dm-verity-loadpin.o
> +endif
> +endif
> +
>  ifeq ($(CONFIG_DM_AUDIT),y)
>  dm-mod-objs			+= dm-audit.o
>  endif
> diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> new file mode 100644
> index 000000000000..49616ea93317
> --- /dev/null
> +++ b/drivers/md/dm-verity-loadpin.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/list.h>
> +#include <linux/kernel.h>
> +#include <linux/dm-verity-loadpin.h>
> +
> +#include "dm.h"
> +#include "dm-verity.h"
> +
> +#define DM_MSG_PREFIX	"verity-loadpin"
> +
> +LIST_HEAD(loadpin_trusted_verity_root_digests);
> +
> +static bool is_trusted_verity_target(struct dm_target *ti)
> +{
> +	u8 *root_digest;
> +	unsigned int digest_size;
> +	struct trusted_root_digest *trd;
> +	bool trusted = false;
> +
> +	if (!dm_is_verity_target(ti))
> +		return false;
> +
> +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> +		return false;
> +
> +	list_for_each_entry(trd, &loadpin_trusted_verity_root_digests, node) {
> +		if ((trd->len == digest_size) &&
> +		    !memcmp(trd->data, root_digest, digest_size)) {
> +			trusted = true;
> +			break;
> +		}
> +	}
> +
> +	kfree(root_digest);
> +
> +	return trusted;
> +}
> +
> +/*
> + * Determines whether the file system of a superblock is located on
> + * a verity device that is trusted by LoadPin.
> + */
> +bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
> +{
> +	struct mapped_device *md;
> +	struct dm_table *table;
> +	struct dm_target *ti;
> +	int srcu_idx;
> +	bool trusted = false;
> +
> +	if (list_empty(&loadpin_trusted_verity_root_digests))
> +		return false;
> +
> +	md = dm_get_md(bdev->bd_dev);
> +	if (!md)
> +		return false;
> +
> +	table = dm_get_live_table(md, &srcu_idx);
> +
> +	if (dm_table_get_num_targets(table) != 1)
> +		goto out;
> +
> +	ti = dm_table_get_target(table, 0);
> +
> +	if (is_trusted_verity_target(ti))
> +		trusted = true;
> +
> +out:
> +	dm_put_live_table(md, srcu_idx);
> +	dm_put(md);
> +
> +	return trusted;
> +}

This should have:
EXPORT_SYMBOL_GPL(dm_verity_loadpin_is_bdev_trusted);

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 80133aae0db3..d6a7903e91e6 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -19,6 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/reboot.h>
>  #include <linux/scatterlist.h>
> +#include <linux/string.h>
>  
>  #define DM_MSG_PREFIX			"verity"
>  
> @@ -1310,9 +1311,41 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	return r;
>  }
>  
> +/*
> + * Check whether a DM target is a verity target.
> + */
> +bool dm_is_verity_target(struct dm_target *ti)
> +{
> +	return ti->type->module == THIS_MODULE;
> +}
> +EXPORT_SYMBOL_GPL(dm_is_verity_target);

Why is this exported?

> +
> +/*
> + * Get the root digest of a verity target.
> + *
> + * Returns a copy of the root digest, the caller is responsible for
> + * freeing the memory of the digest.
> + */
> +int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned int *digest_size)
> +{
> +	struct dm_verity *v = ti->private;
> +
> +	if (!dm_is_verity_target(ti))
> +		return -EINVAL;
> +
> +	*root_digest = kmemdup(v->root_digest, v->digest_size, GFP_KERNEL);
> +	if (*root_digest == NULL)
> +		return -ENOMEM;
> +
> +	*digest_size = v->digest_size;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dm_verity_get_root_digest);

Why is this exported?

Both of these should be internal to dm-verity module.

Have you built a modular kernel to test?


>  static struct target_type verity_target = {
>  	.name		= "verity",
> -	.version	= {1, 8, 0},
> +	.version	= {1, 8, 1},
>  	.module		= THIS_MODULE,
>  	.ctr		= verity_ctr,
>  	.dtr		= verity_dtr,
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 4e769d13473a..c832cc3e3d24 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -129,4 +129,8 @@ extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
>  extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
>  				 sector_t block, u8 *digest, bool *is_zero);
>  
> +extern bool dm_is_verity_target(struct dm_target *ti);
> +extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
> +				     unsigned int *digest_size);
> +
>  #endif /* DM_VERITY_H */
> diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
> new file mode 100644
> index 000000000000..d37146dbb1a8
> --- /dev/null
> +++ b/include/linux/dm-verity-loadpin.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __LINUX_DM_VERITY_LOADPIN_H
> +#define __LINUX_DM_VERITY_LOADPIN_H
> +
> +#include <linux/list.h>
> +
> +struct block_device;
> +
> +extern struct list_head loadpin_trusted_verity_root_digests;

s/loadpin_trusted_verity_root_digests/dm_verity_loadpin_trusted_root_digests/ ?

> +
> +struct trusted_root_digest {
> +	struct list_head node;
> +	unsigned int len;
> +	u8 data[];
> +};

s/trusted_root_digest/dm_verity_loadpin_trusted_root_digest/ ?

Long names, but more consistent and informative.

> +#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
> +bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev);
> +#else
> +static inline bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
> +{
> +	return false;
> +}
> +#endif
> +
> +#endif /* __LINUX_DM_VERITY_LOADPIN_H */
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

