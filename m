Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170237468
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RGdPqiSn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hADcKA1UWPiRdnCHspcKD95SqFEOwQ8DvDpSU3O8eEs=;
	b=RGdPqiSn1Q5KT056SP0zRUR6cuP/1sdqR5JzWbyQLnm3Xd6cMT9vO/maZE4Iu2OvyXW+Tr
	AE0qi2gL0F9AnswxyGIQM1xVwsDYWbyybUbnccD1iqpNFu01cUxVDPawS25hrm751zNTam
	/Tj3RV6K/xqo9NAQEb6YYYBllcAU0ag=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-bH60MVm5OSe_r8q-rSjcbQ-1; Mon,
 23 Oct 2023 23:52:46 -0400
X-MC-Unique: bH60MVm5OSe_r8q-rSjcbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DCB238143AE
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 268B58C0B
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EFCF81946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03E011946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E40418CEF; Tue, 24 Oct 2023 03:52:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DCF64503B
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:44 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B926A3C0F433
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:44 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-EQLRLkGtO_O2kqoouDEY7A-1; Mon, 23 Oct 2023 23:52:32 -0400
X-MC-Unique: EQLRLkGtO_O2kqoouDEY7A-1
Received: by mail-qv1-f48.google.com with SMTP id
 6a1803df08f44-66d03491a1eso23926386d6.2
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119552; x=1698724352;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=hADcKA1UWPiRdnCHspcKD95SqFEOwQ8DvDpSU3O8eEs=;
 b=ClqDW94myuKZro5Rhnuk/XFCbbZa8hYptx0EPmXZg7h2DJnPWsbpQ6Rzddg5/oT4Pn
 e2ZOSxVDjFv3mNY5aVLAfT7L3QzOXMXB/AchNsDnaWhJuakOro+VxcFN2wJwz207rLx4
 IzqRh5Ds5IEzjzF9r8e5MMdRZY0PG0datB0pwEYi3pcdbYZcuvtS20HrDbY5cOsMYiZn
 gZxh3ip0LadAfWzS9R5H07OuQ8959v+JuQr66AN+Sdo5tu0GPhebP9C4l+cZCnYBztw3
 1d1JiQAa+qws5i/6YSb8DDZ6Xyoc2UgVFeBg52+M3hf/SEBDcqH/eR4T05GPedjU2U83
 x/+w==
X-Gm-Message-State: AOJu0Yz1mukeQnXjro43s3/Az2bGUlKtg5dZgvrKv2XatmXeHI+c0xnY
 9NryRMdErzvd1Ch3Hcukb44u
X-Google-Smtp-Source: AGHT+IHQ4xi8G/il6wD4iHK2En8Uxy1HdELe4wcBegRDxlGyxxhycLWFO/wUSoQ+EGQvqRxRotIGzQ==
X-Received: by 2002:ad4:5aa6:0:b0:66d:2140:1f88 with SMTP id
 u6-20020ad45aa6000000b0066d21401f88mr2912148qvg.5.1698119552265; 
 Mon, 23 Oct 2023 20:52:32 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 l15-20020ad4452f000000b0066cf2423c79sm3357639qvu.139.2023.10.23.20.52.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:31 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:31 -0400
Message-ID: <1e9658bed9b583c9d6cf07c13253cf8f.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 13/19] dm verity: consume root hash digest and
 signature data via LSM hook
References: <1696457386-3010-14-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-14-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> dm-verity provides a strong guarantee of a block device's integrity. As
> a generic way to check the integrity of a block device, it provides
> those integrity guarantees to its higher layers, including the filesystem
> level.
> 
> An LSM that control access to a resource on the system based on the
> available integrity claims can use this transitive property of
> dm-verity, by querying the underlying block_device of a particular
> file.
> 
> The digest and signature information need to be stored in the block
> device to fulfill the next requirement of authorization via LSM policy.
> This will enable the LSM to perform revocation of devices that are still
> mounted, prohibiting execution of files that are no longer authorized
> by the LSM in question.
> 
> This patch added two security hook calls in dm-verity to save the
> dm-verity roothash and the roothash signature to the block device's
> LSM blobs.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + No Changes
> 
> v3:
>   + No changes
> 
> v4:
>   + No changes
> 
> v5:
>   + No changes
> 
> v6:
>   + Fix an improper cleanup that can result in
>     a leak
> 
> v7:
>   + Squash patch 08/12, 10/12 to [11/16]
>   + Use part0 for block_device, to retrieve the block_device, when
>     calling security_bdev_setsecurity
> 
> v8:
>   + Undo squash of 08/12, 10/12 - separating drivers/md/ from
>     security/ & block/
>   + Use common-audit function for dmverity_signature.
>   + Change implementation for storing the dm-verity digest to use the
>     newly introduced dm_verity_digest structure introduced in patch
>     14/20.
>   + Create new structure, dm_verity_digest, containing digest algorithm,
>     size, and digest itself to pass to the LSM layer. V7 was missing the
>     algorithm.
>   + Create an associated public header containing this new structure and
>     the key values for the LSM hook, specific to dm-verity.
>   + Additional information added to commit, discussing the layering of
>     the changes and how the information passed will be used.
> 
> v9:
>   + No changes
> 
> v10:
>   + No changes
> 
> v11:
>   + Add an optional field to save signature
>   + Move the security hook call to the new finalize hook
> ---
>  drivers/md/dm-verity-target.c | 71 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm-verity.h        |  6 +++
>  include/linux/dm-verity.h     | 19 ++++++++++
>  3 files changed, 96 insertions(+)
>  create mode 100644 include/linux/dm-verity.h

We need an ACK from Alasdair and/or Mike on this too.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 80673b66c194..db58b53649e3 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -13,6 +13,7 @@
>   * access behavior.
>   */
>  
> +#include "dm-core.h"
>  #include "dm-verity.h"
>  #include "dm-verity-fec.h"
>  #include "dm-verity-verify-sig.h"
> @@ -22,6 +23,9 @@
>  #include <linux/scatterlist.h>
>  #include <linux/string.h>
>  #include <linux/jump_label.h>
> +#include <linux/security.h>
> +#include <linux/dm-verity.h>
> +#include <crypto/hash_info.h>
>  
>  #define DM_MSG_PREFIX			"verity"
>  
> @@ -952,6 +956,17 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	blk_limits_io_min(limits, limits->logical_block_size);
>  }
>  
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +static void verity_free_sig(struct dm_verity *v)
> +{
> +	kfree(v->root_digest_sig);
> +}
> +#else
> +static inline void verity_free_sig(struct dm_verity *v)
> +{
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  static void verity_dtr(struct dm_target *ti)
>  {
>  	struct dm_verity *v = ti->private;
> @@ -966,6 +981,7 @@ static void verity_dtr(struct dm_target *ti)
>  	kfree(v->salt);
>  	kfree(v->root_digest);
>  	kfree(v->zero_digest);
> +	verity_free_sig(v);
>  
>  	if (v->tfm)
>  		crypto_free_ahash(v->tfm);
> @@ -1157,6 +1173,25 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
>  	return r;
>  }
>  
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +static int verity_init_sig(struct dm_verity *v, const void *sig,
> +			   size_t sig_size)
> +{
> +	v->sig_size = sig_size;
> +	v->root_digest_sig = kmalloc(v->sig_size, GFP_KERNEL);
> +	if (!v->root_digest)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +#else
> +static inline int verity_init_sig(struct dm_verity *v, const void *sig,
> +				  size_t sig_size)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  /*
>   * Target parameters:
>   *	<version>	The current format is version 1.
> @@ -1365,6 +1400,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		ti->error = "Root hash verification failed";
>  		goto bad;
>  	}
> +
> +	r = verity_init_sig(v, verify_args.sig, verify_args.sig_size);
> +	if (r < 0) {
> +		ti->error = "Cannot allocate root digest signature";
> +		goto bad;
> +	}
> +
>  	v->hash_per_block_bits =
>  		__fls((1 << v->hash_dev_block_bits) / v->digest_size);
>  
> @@ -1501,6 +1543,32 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
>  	return 0;
>  }
>  
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +static int verity_finalize(struct dm_target *ti)
> +{
> +	struct block_device *bdev;
> +	struct dm_verity_digest root_digest;
> +	struct dm_verity *v;
> +	int r;
> +
> +	v = ti->private;
> +	bdev = dm_table_get_md(ti->table)->disk->part0;
> +	root_digest.digest = v->root_digest;
> +	root_digest.digest_len = v->digest_size;
> +	root_digest.algo = v->alg_name;
> +
> +	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
> +				      sizeof(root_digest));
> +	if (r)
> +		return r;
> +
> +	return security_bdev_setsecurity(bdev,
> +					 DM_VERITY_SIGNATURE_SEC_NAME,
> +					 v->root_digest_sig,
> +					 v->sig_size);
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  static struct target_type verity_target = {
>  	.name		= "verity",
>  	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
> @@ -1513,6 +1581,9 @@ static struct target_type verity_target = {
>  	.prepare_ioctl	= verity_prepare_ioctl,
>  	.iterate_devices = verity_iterate_devices,
>  	.io_hints	= verity_io_hints,
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +	.finalize	= verity_finalize,
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
>  };
>  module_dm(verity);
>  
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 2f555b420367..a093d4a54615 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -42,6 +42,9 @@ struct dm_verity {
>  	u8 *root_digest;	/* digest of the root block */
>  	u8 *salt;		/* salt: its size is salt_size */
>  	u8 *zero_digest;	/* digest for a zero block */
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +	u8 *root_digest_sig;	/* digest signature of the root block */
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
>  	unsigned int salt_size;
>  	sector_t data_start;	/* data offset in 512-byte sectors */
>  	sector_t hash_start;	/* hash start in blocks */
> @@ -55,6 +58,9 @@ struct dm_verity {
>  	bool hash_failed:1;	/* set if hash of any block failed */
>  	bool use_tasklet:1;	/* try to verify in tasklet before work-queue */
>  	unsigned int digest_size;	/* digest size for the current hash algorithm */
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +	unsigned int sig_size;	/* digest signature size */
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
>  	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
>  	enum verity_mode mode;	/* mode for handling verification errors */
>  	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
> diff --git a/include/linux/dm-verity.h b/include/linux/dm-verity.h
> new file mode 100644
> index 000000000000..bb0413d55d72
> --- /dev/null
> +++ b/include/linux/dm-verity.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_DM_VERITY_H
> +#define _LINUX_DM_VERITY_H
> +
> +#include <linux/types.h>
> +#include <crypto/hash_info.h>
> +#include <linux/device-mapper.h>
> +
> +struct dm_verity_digest {
> +	const char *algo;
> +	const u8 *digest;
> +	size_t digest_len;
> +};
> +
> +#define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME	".verity-signature"
> +#define DM_VERITY_ROOTHASH_SEC_NAME  DM_NAME	".verity-roothash"
> +
> +#endif /* _LINUX_DM_VERITY_H */
> -- 
> 2.25.1

--
paul-moore.com

