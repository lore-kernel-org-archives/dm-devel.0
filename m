Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB34C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652459548;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=USTbvRQfvY305jhwrWrc0mHkuTS5rncXHe57RTXKsqA=;
	b=Pc00YJfKzR5uaBOI9wgaj4OJIwKbCWbiz1gsFmSK0THAMj3eUV5aTjsaABmKH86cijtzRH
	K2yvjjsgd/BxewVr4ssC44+SuHUX3kajCl4Q7dpxVKc9mrazG33CCMn/pkKToOzbTwwNBs
	fpFEMaofsE/fdFwC41wzZ5J5HGpuu2U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-1i7pBkjzPZiVTaOammP02w-1; Fri, 13 May 2022 12:32:25 -0400
X-MC-Unique: 1i7pBkjzPZiVTaOammP02w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD2AC802A5B;
	Fri, 13 May 2022 16:32:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 993C5416362;
	Fri, 13 May 2022 16:32:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7141E193222E;
	Fri, 13 May 2022 16:32:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E728A194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 16:32:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D49B6111F3C1; Fri, 13 May 2022 16:32:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D08B41121314
 for <dm-devel@redhat.com>; Fri, 13 May 2022 16:32:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69DF5101AA44
 for <dm-devel@redhat.com>; Fri, 13 May 2022 16:32:18 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-iwOjbN68ND2lUK6QZZG2LQ-1; Fri, 13 May 2022 12:32:15 -0400
X-MC-Unique: iwOjbN68ND2lUK6QZZG2LQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 124-20020a370982000000b006a0a716249bso6722061qkj.10
 for <dm-devel@redhat.com>; Fri, 13 May 2022 09:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GSs3OCl6exYVzJF4y7HE/2Ri3Tlrrt1xSuKise5rQGY=;
 b=20EM3S98R9EOIlQrl05aov49O5wMppLghBIrW7Ula8iRCf0YqT8SDHX4k3/MU1DEyf
 zvEgIy4AEIhTZOjxddEUqoyjtSRIZpDamBwIHBzdTM6NlKFfA0n80k1/bJ9ks6JRA4tA
 /rEv8gknEH1gsWnOXoweyUp8wZ1VbAm+/o2V3ijmWWrSMYpYApM9LD52OcC3K5eZr4hW
 O2yR97j7JO/1i1HhDpERY95kXuifjHAqZ6nl9/67DFC+FidZ8sAGz1NdygMdgAztqwDb
 WQ0vIYe4w0k1VrgTMzPKNV2ca071N22+y2wiEH/1r4q6sY3Z04Jm/DAc3nZqDVY5p5Mr
 ARqQ==
X-Gm-Message-State: AOAM532g+7An9ooOsZCn94UQk47cuc6r89f9uSnn9Z08WfKczoichhU8
 +86AKhrTZSXwzBWJq4Isch9KfpWsRKWKQ3sf9nbyzt/6xDLaRtGoRXLDzA8ZGC/1OQ0/4yn6RuL
 US+WzUGTZcSUQ+Q==
X-Received: by 2002:a05:620a:4489:b0:6a0:4614:6a09 with SMTP id
 x9-20020a05620a448900b006a046146a09mr4316548qkp.119.1652459534386; 
 Fri, 13 May 2022 09:32:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2CJFnmXFrFgijRZd/k/36dAXYWd0jhmXMcC++5WOdxH1tNzkrAA9hqr4x1wuHK+74E8fe1w==
X-Received: by 2002:a05:620a:4489:b0:6a0:4614:6a09 with SMTP id
 x9-20020a05620a448900b006a046146a09mr4316511qkp.119.1652459533965; 
 Fri, 13 May 2022 09:32:13 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 g12-20020ac8468c000000b002f39b99f6a0sm1754436qto.58.2022.05.13.09.32.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 13 May 2022 09:32:13 -0700 (PDT)
Date: Fri, 13 May 2022 12:32:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <Yn6IDNgG+/ySOdmy@redhat.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
In-Reply-To: <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v3 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 04 2022 at  3:54P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
> devices.
> 
> This change adds the concept of trusted verity devices to LoadPin. LoadPin
> maintains a list of root digests of verity devices it considers trusted.
> Userspace can populate this list through an ioctl on the new LoadPin
> securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
> a file with verity digests as parameter. Verity reads the digests from
> this file after confirming that the file is located on the pinned root.
> The list of trusted digests can only be set up once, which is typically
> done at boot time.
> 
> When a kernel file is read LoadPin first checks (as usual) whether the file
> is located on the pinned root, if so the file can be loaded. Otherwise, if
> the verity extension is enabled, LoadPin determines whether the file is
> located on a verity backed device and whether the root digest of that
> device is in the list of trusted digests. The file can be loaded if the
> verity device has a trusted root digest.
> 
> Background:
> 
> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity to verify
> the integrity of the DLC content.
> 
> [1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
> [2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
> Changes in v3:
> - added securityfs for LoadPin (currently only populated when
>   CONFIG_SECURITY_LOADPIN_VERITY=y)
> - added uapi include for LoadPin
> - changed the interface for setting up the list of trusted
>   digests from sysctl to ioctl on securityfs entry
> - added stub for loadpin_is_fs_trusted() to be used
>   CONFIG_SECURITY_LOADPIN_VERITY is not select
> - depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
> - updated Kconfig help
> - minor changes in read_trusted_verity_root_digests()
> - updated commit message
> 
> Changes in v2:
> - userspace now passes the path of the file with the verity digests
>   via systcl, instead of the digests themselves
> - renamed sysctl file to 'trusted_verity_root_digests_path'
> - have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
> - updated Kconfig doc
> - updated commit message
> 
>  include/uapi/linux/loadpin.h |  19 ++++
>  security/loadpin/Kconfig     |  16 +++
>  security/loadpin/loadpin.c   | 184 ++++++++++++++++++++++++++++++++++-
>  3 files changed, 218 insertions(+), 1 deletion(-)
>  create mode 100644 include/uapi/linux/loadpin.h

I would certainly need some Reviewed-by:s from security and/or loadpin
experts if I were to pick this patch up.

Did you see the issues the kernel test robot emailed about?

You'd do well to fix those issues up when submitting another revision
of this patchset.

Mike


> 
> diff --git a/include/uapi/linux/loadpin.h b/include/uapi/linux/loadpin.h
> new file mode 100644
> index 000000000000..d303a582209b
> --- /dev/null
> +++ b/include/uapi/linux/loadpin.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (c) 2022, Google LLC
> + */
> +
> +#ifndef _UAPI_LINUX_LOOP_LOADPIN_H
> +#define _UAPI_LINUX_LOOP_LOADPIN_H
> +
> +#define LOADPIN_IOC_MAGIC	'L'
> +
> +/**
> + * LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS - Set up the root digests of verity devices
> + *                                          that loadpin should trust.
> + *
> + * Takes a file descriptor from which to read the root digests of trusted verity devices.
> + */
> +#define LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS _IOW(LOADPIN_IOC_MAGIC, 0x00, unsigned int)
> +
> +#endif /* _UAPI_LINUX_LOOP_LOADPIN_H */
> diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
> index 91be65dec2ab..e319ca8e3f3d 100644
> --- a/security/loadpin/Kconfig
> +++ b/security/loadpin/Kconfig
> @@ -18,3 +18,19 @@ config SECURITY_LOADPIN_ENFORCE
>  	  If selected, LoadPin will enforce pinning at boot. If not
>  	  selected, it can be enabled at boot with the kernel parameter
>  	  "loadpin.enforce=1".
> +
> +config SECURITY_LOADPIN_VERITY
> +	bool "Allow reading files from certain other filesystems that use dm-verity"
> +	depends on DM_VERITY=y && SECURITYFS
> +	help
> +	  If selected LoadPin can allow reading files from filesystems
> +	  that use dm-verity. LoadPin maintains a list of verity root
> +	  digests it considers trusted. A verity backed filesystem is
> +	  considered trusted if its root digest is found in the list
> +	  of trusted digests.
> +
> +	  The list of trusted verity can be populated through an ioctl
> +	  on the LoadPin securityfs entry 'dm-verity'. The ioctl
> +	  expects a file descriptor of a file with verity digests as
> +	  parameter. The file must be located on the pinned root and
> +	  contain a comma separated list of digests.
> diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
> index b12f7d986b1e..c29ce562a366 100644
> --- a/security/loadpin/loadpin.c
> +++ b/security/loadpin/loadpin.c
> @@ -18,6 +18,9 @@
>  #include <linux/path.h>
>  #include <linux/sched.h>	/* current */
>  #include <linux/string_helpers.h>
> +#include <linux/device-mapper.h>
> +#include <linux/dm-verity-loadpin.h>
> +#include <uapi/linux/loadpin.h>
>  
>  static void report_load(const char *origin, struct file *file, char *operation)
>  {
> @@ -43,6 +46,9 @@ static char *exclude_read_files[READING_MAX_ID];
>  static int ignore_read_file_id[READING_MAX_ID] __ro_after_init;
>  static struct super_block *pinned_root;
>  static DEFINE_SPINLOCK(pinned_root_spinlock);
> +#ifdef CONFIG_SECURITY_LOADPIN_VERITY
> +static LIST_HEAD(trusted_verity_root_digests);
> +#endif
>  
>  #ifdef CONFIG_SYSCTL
>  
> @@ -118,6 +124,24 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
>  	}
>  }
>  
> +#ifdef CONFIG_SECURITY_LOADPIN_VERITY
> +static bool loadpin_is_fs_trusted(struct super_block *sb)
> +{
> +	struct mapped_device *md = dm_get_md(sb->s_bdev->bd_dev);
> +	bool trusted;
> +
> +	if (!md)
> +		return false;
> +
> +	trusted = dm_verity_loadpin_is_md_trusted(md);
> +	dm_put(md);
> +
> +	return trusted;
> +}
> +#else
> +static inline bool loadpin_is_fs_trusted(struct super_block *sb) { return false; };
> +#endif
> +
>  static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
>  			     bool contents)
>  {
> @@ -174,7 +198,8 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
>  		spin_unlock(&pinned_root_spinlock);
>  	}
>  
> -	if (IS_ERR_OR_NULL(pinned_root) || load_root != pinned_root) {
> +	if (IS_ERR_OR_NULL(pinned_root) ||
> +	    ((load_root != pinned_root) && !loadpin_is_fs_trusted(load_root))) {
>  		if (unlikely(!enforce)) {
>  			report_load(origin, file, "pinning-ignored");
>  			return 0;
> @@ -240,6 +265,7 @@ static int __init loadpin_init(void)
>  		enforce ? "" : "not ");
>  	parse_exclude();
>  	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
> +
>  	return 0;
>  }
>  
> @@ -248,6 +274,162 @@ DEFINE_LSM(loadpin) = {
>  	.init = loadpin_init,
>  };
>  
> +#ifdef CONFIG_SECURITY_LOADPIN_VERITY
> +
> +enum loadpin_securityfs_interface_index {
> +	LOADPIN_DM_VERITY,
> +};
> +
> +static int read_trusted_verity_root_digests(unsigned int fd)
> +{
> +	struct fd f;
> +	void *data;
> +	int rc;
> +	char *p, *d;
> +
> +	/* The list of trusted root digests can only be set up once */
> +	if (!list_empty(&trusted_verity_root_digests))
> +		return -EPERM;
> +
> +	f = fdget(fd);
> +	if (!f.file)
> +		return -EINVAL;
> +
> +	data = kzalloc(SZ_4K, GFP_KERNEL);
> +	if (!data) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
> +
> +	rc = kernel_read_file(f.file, 0, &data, SZ_4K - 1, NULL, READING_POLICY);
> +	if (rc < 0)
> +		goto err;
> +
> +	((char *)data)[rc] = '\0';
> +
> +	p = strim(data);
> +	while ((d = strsep(&p, ",")) != NULL) {
> +		int len = strlen(d);
> +		struct trusted_root_digest *trd;
> +
> +		if (len % 2) {
> +			rc = -EPROTO;
> +			goto err;
> +		}
> +
> +		len /= 2;
> +
> +		trd = kzalloc(sizeof(*trd), GFP_KERNEL);
> +		if (!trd) {
> +			rc = -ENOMEM;
> +			goto err;
> +		}
> +
> +		trd->data = kzalloc(len, GFP_KERNEL);
> +		if (!trd->data) {
> +			kfree(trd);
> +			rc = -ENOMEM;
> +			goto err;
> +		}
> +
> +		if (hex2bin(trd->data, d, len)) {
> +			kfree(trd);
> +			kfree(trd->data);
> +			rc = -EPROTO;
> +			goto err;
> +		}
> +
> +		trd->len = len;
> +
> +		list_add_tail(&trd->node, &trusted_verity_root_digests);
> +	}
> +
> +	kfree(data);
> +	fdput(f);
> +
> +	if (!list_empty(&trusted_verity_root_digests))
> +		dm_verity_loadpin_set_trusted_root_digests(&trusted_verity_root_digests);
> +
> +	return 0;
> +
> +err:
> +	kfree(data);
> +
> +	{
> +		struct trusted_root_digest *trd, *tmp;
> +
> +		list_for_each_entry_safe(trd, tmp, &trusted_verity_root_digests, node) {
> +			kfree(trd->data);
> +			list_del(&trd->node);
> +			kfree(trd);
> +		}
> +	}
> +
> +	fdput(f);
> +
> +	return rc;
> +}
> +
> +/******************************** securityfs ********************************/
> +
> +static long dm_verity_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	void __user *uarg = (void __user *)arg;
> +	unsigned int fd;
> +	int rc;
> +
> +	switch (cmd) {
> +	case LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS:
> +		rc = copy_from_user(&fd, uarg, sizeof(fd));
> +		if (rc)
> +			return rc;
> +
> +		return read_trusted_verity_root_digests(fd);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct file_operations loadpin_dm_verity_ops = {
> +	.unlocked_ioctl = dm_verity_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
> +};
> +
> +/**
> + * init_loadpin_securityfs - create the securityfs directory for LoadPin
> + *
> + * We can not put this method normally under the loadpin_init() code path since
> + * the security subsystem gets initialized before the vfs caches.
> + *
> + * Returns 0 if the securityfs directory creation was successful.
> + */
> +static int __init init_loadpin_securityfs(void)
> +{
> +	struct dentry *loadpin_dir, *dentry;
> +
> +	loadpin_dir = securityfs_create_dir("loadpin", NULL);
> +	if (IS_ERR(loadpin_dir)) {
> +		pr_err("LoadPin: could not create securityfs dir: %d\n",
> +		       PTR_ERR(loadpin_dir));
> +		return PTR_ERR(loadpin_dir);
> +	}
> +
> +	dentry = securityfs_create_file("dm-verity", 0600, loadpin_dir,
> +					(void *)LOADPIN_DM_VERITY, &loadpin_dm_verity_ops);
> +	if (IS_ERR(dentry)) {
> +		pr_err("LoadPin: could not create securityfs entry 'dm-verity': %d\n",
> +		       PTR_ERR(dentry));
> +		return PTR_ERR(dentry);
> +	}
> +
> +	return 0;
> +}
> +
> +fs_initcall(init_loadpin_securityfs);
> +
> +#endif /* CONFIG_SECURITY_LOADPIN_VERITY */
> +
>  /* Should not be mutable after boot, so not listed in sysfs (perm == 0). */
>  module_param(enforce, int, 0);
>  MODULE_PARM_DESC(enforce, "Enforce module/firmware pinning");
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

