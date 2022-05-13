Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B24B8C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 17:01:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-wy9yQ7cTMoWy29RxTttoTQ-1; Fri, 13 May 2022 13:01:55 -0400
X-MC-Unique: wy9yQ7cTMoWy29RxTttoTQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0C54185A7A4;
	Fri, 13 May 2022 17:01:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE86416157;
	Fri, 13 May 2022 17:01:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CA28193222E;
	Fri, 13 May 2022 17:01:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4ED68194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 17:01:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DD86438BF1; Fri, 13 May 2022 17:01:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29BCA438BEF
 for <dm-devel@redhat.com>; Fri, 13 May 2022 17:01:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA9D385A5BC
 for <dm-devel@redhat.com>; Fri, 13 May 2022 17:01:51 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-8st2RJKFPquPGY1AGGIw5A-1; Fri, 13 May 2022 13:01:49 -0400
X-MC-Unique: 8st2RJKFPquPGY1AGGIw5A-1
Received: by mail-pj1-f54.google.com with SMTP id
 l7-20020a17090aaa8700b001dd1a5b9965so8321139pjq.2
 for <dm-devel@redhat.com>; Fri, 13 May 2022 10:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=iDSh0Mq4giBjDXuEjDs1oB99KRT+jEM69GY64GlYuqo=;
 b=jP0Mh36MgCI0ougl78C5hGD+HaprP9HAQ3BaE7DPMuGjMx1BKUWKHi6YDm6qw9lKY0
 601leE4VW6tSV/nJVJm93a4aKqAa7kytJDYt8YCYrr6r3egsBXAwow9pQsgIOSRx9W0h
 OmI5zYdn/+yfP6q/5ElWOnS1R+IWNOTIcBiPL8O70hpCnVEjbNfAzLLWCGafvUkN/P5P
 17UD/4RIkdzvB56/7TMCeSOoaFtHAdnoCcGZEu4O+kv4v32rPQRcHeAShmGibA/tARLx
 D+HMfNPUNh7J5go6B7ND9xwpLinN7ZCkQEbWezIKzDqvrPZJdOHEvWUJ2GHM2DGfI5A3
 3EIg==
X-Gm-Message-State: AOAM531rTyeu1YuE32/nxiWXX9g+xDmie7FWFrT9sc3WzDd7k2N/HK5L
 t+rECj4CJ/NUrBdpR/2riwmb8g==
X-Google-Smtp-Source: ABdhPJySKhTT2GaHdsFJBuSCXtc60COGMFiU4k8QMHhLeOxfWg0Nq/feCbdPXnhRoBekWzLFUIO6Jg==
X-Received: by 2002:a17:902:7144:b0:15f:3d88:d79 with SMTP id
 u4-20020a170902714400b0015f3d880d79mr5489644plm.86.1652461308538; 
 Fri, 13 May 2022 10:01:48 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:bc87:9632:bcce:8e17])
 by smtp.gmail.com with UTF8SMTPSA id
 v1-20020a056a00148100b0050dc76281b5sm2133826pfu.143.2022.05.13.10.01.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 May 2022 10:01:48 -0700 (PDT)
Date: Fri, 13 May 2022 10:01:46 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yn6O+l0fJMJO8Oh2@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <Yn6IDNgG+/ySOdmy@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yn6IDNgG+/ySOdmy@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

On Fri, May 13, 2022 at 12:32:12PM -0400, Mike Snitzer wrote:
> On Wed, May 04 2022 at  3:54P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
> > devices.
> > 
> > This change adds the concept of trusted verity devices to LoadPin. LoadPin
> > maintains a list of root digests of verity devices it considers trusted.
> > Userspace can populate this list through an ioctl on the new LoadPin
> > securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
> > a file with verity digests as parameter. Verity reads the digests from
> > this file after confirming that the file is located on the pinned root.
> > The list of trusted digests can only be set up once, which is typically
> > done at boot time.
> > 
> > When a kernel file is read LoadPin first checks (as usual) whether the file
> > is located on the pinned root, if so the file can be loaded. Otherwise, if
> > the verity extension is enabled, LoadPin determines whether the file is
> > located on a verity backed device and whether the root digest of that
> > device is in the list of trusted digests. The file can be loaded if the
> > verity device has a trusted root digest.
> > 
> > Background:
> > 
> > As of now LoadPin restricts loading of kernel files to a single pinned
> > filesystem, typically the rootfs. This works for many systems, however it
> > can result in a bloated rootfs (and OTA updates) on platforms where
> > multiple boards with different hardware configurations use the same rootfs
> > image. Especially when 'optional' files are large it may be preferable to
> > download/install them only when they are actually needed by a given board.
> > Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
> > at runtime. As an example a DLC package could contain firmware for a
> > peripheral that is not present on all boards. DLCs use dm-verity to verify
> > the integrity of the DLC content.
> > 
> > [1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
> > [2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > 
> > Changes in v3:
> > - added securityfs for LoadPin (currently only populated when
> >   CONFIG_SECURITY_LOADPIN_VERITY=y)
> > - added uapi include for LoadPin
> > - changed the interface for setting up the list of trusted
> >   digests from sysctl to ioctl on securityfs entry
> > - added stub for loadpin_is_fs_trusted() to be used
> >   CONFIG_SECURITY_LOADPIN_VERITY is not select
> > - depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
> > - updated Kconfig help
> > - minor changes in read_trusted_verity_root_digests()
> > - updated commit message
> > 
> > Changes in v2:
> > - userspace now passes the path of the file with the verity digests
> >   via systcl, instead of the digests themselves
> > - renamed sysctl file to 'trusted_verity_root_digests_path'
> > - have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
> > - updated Kconfig doc
> > - updated commit message
> > 
> >  include/uapi/linux/loadpin.h |  19 ++++
> >  security/loadpin/Kconfig     |  16 +++
> >  security/loadpin/loadpin.c   | 184 ++++++++++++++++++++++++++++++++++-
> >  3 files changed, 218 insertions(+), 1 deletion(-)
> >  create mode 100644 include/uapi/linux/loadpin.h
> 
> I would certainly need some Reviewed-by:s from security and/or loadpin
> experts if I were to pick this patch up.

Yes, I think Kees (LoadPin maintainer) is generally on board with the idea,
but a more in depth review is still pending.

I'll send out a new revision which addresses the current outstanding
comments soon.

> Did you see the issues the kernel test robot emailed about?
> 
> You'd do well to fix those issues up when submitting another revision
> of this patchset.

Yes, I plan to address those in the next revision. Thanks for the reminder!

> > 
> > diff --git a/include/uapi/linux/loadpin.h b/include/uapi/linux/loadpin.h
> > new file mode 100644
> > index 000000000000..d303a582209b
> > --- /dev/null
> > +++ b/include/uapi/linux/loadpin.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + * Copyright (c) 2022, Google LLC
> > + */
> > +
> > +#ifndef _UAPI_LINUX_LOOP_LOADPIN_H
> > +#define _UAPI_LINUX_LOOP_LOADPIN_H
> > +
> > +#define LOADPIN_IOC_MAGIC	'L'
> > +
> > +/**
> > + * LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS - Set up the root digests of verity devices
> > + *                                          that loadpin should trust.
> > + *
> > + * Takes a file descriptor from which to read the root digests of trusted verity devices.
> > + */
> > +#define LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS _IOW(LOADPIN_IOC_MAGIC, 0x00, unsigned int)
> > +
> > +#endif /* _UAPI_LINUX_LOOP_LOADPIN_H */
> > diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
> > index 91be65dec2ab..e319ca8e3f3d 100644
> > --- a/security/loadpin/Kconfig
> > +++ b/security/loadpin/Kconfig
> > @@ -18,3 +18,19 @@ config SECURITY_LOADPIN_ENFORCE
> >  	  If selected, LoadPin will enforce pinning at boot. If not
> >  	  selected, it can be enabled at boot with the kernel parameter
> >  	  "loadpin.enforce=1".
> > +
> > +config SECURITY_LOADPIN_VERITY
> > +	bool "Allow reading files from certain other filesystems that use dm-verity"
> > +	depends on DM_VERITY=y && SECURITYFS
> > +	help
> > +	  If selected LoadPin can allow reading files from filesystems
> > +	  that use dm-verity. LoadPin maintains a list of verity root
> > +	  digests it considers trusted. A verity backed filesystem is
> > +	  considered trusted if its root digest is found in the list
> > +	  of trusted digests.
> > +
> > +	  The list of trusted verity can be populated through an ioctl
> > +	  on the LoadPin securityfs entry 'dm-verity'. The ioctl
> > +	  expects a file descriptor of a file with verity digests as
> > +	  parameter. The file must be located on the pinned root and
> > +	  contain a comma separated list of digests.
> > diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
> > index b12f7d986b1e..c29ce562a366 100644
> > --- a/security/loadpin/loadpin.c
> > +++ b/security/loadpin/loadpin.c
> > @@ -18,6 +18,9 @@
> >  #include <linux/path.h>
> >  #include <linux/sched.h>	/* current */
> >  #include <linux/string_helpers.h>
> > +#include <linux/device-mapper.h>
> > +#include <linux/dm-verity-loadpin.h>
> > +#include <uapi/linux/loadpin.h>
> >  
> >  static void report_load(const char *origin, struct file *file, char *operation)
> >  {
> > @@ -43,6 +46,9 @@ static char *exclude_read_files[READING_MAX_ID];
> >  static int ignore_read_file_id[READING_MAX_ID] __ro_after_init;
> >  static struct super_block *pinned_root;
> >  static DEFINE_SPINLOCK(pinned_root_spinlock);
> > +#ifdef CONFIG_SECURITY_LOADPIN_VERITY
> > +static LIST_HEAD(trusted_verity_root_digests);
> > +#endif
> >  
> >  #ifdef CONFIG_SYSCTL
> >  
> > @@ -118,6 +124,24 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_SECURITY_LOADPIN_VERITY
> > +static bool loadpin_is_fs_trusted(struct super_block *sb)
> > +{
> > +	struct mapped_device *md = dm_get_md(sb->s_bdev->bd_dev);
> > +	bool trusted;
> > +
> > +	if (!md)
> > +		return false;
> > +
> > +	trusted = dm_verity_loadpin_is_md_trusted(md);
> > +	dm_put(md);
> > +
> > +	return trusted;
> > +}
> > +#else
> > +static inline bool loadpin_is_fs_trusted(struct super_block *sb) { return false; };
> > +#endif
> > +
> >  static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
> >  			     bool contents)
> >  {
> > @@ -174,7 +198,8 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
> >  		spin_unlock(&pinned_root_spinlock);
> >  	}
> >  
> > -	if (IS_ERR_OR_NULL(pinned_root) || load_root != pinned_root) {
> > +	if (IS_ERR_OR_NULL(pinned_root) ||
> > +	    ((load_root != pinned_root) && !loadpin_is_fs_trusted(load_root))) {
> >  		if (unlikely(!enforce)) {
> >  			report_load(origin, file, "pinning-ignored");
> >  			return 0;
> > @@ -240,6 +265,7 @@ static int __init loadpin_init(void)
> >  		enforce ? "" : "not ");
> >  	parse_exclude();
> >  	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
> > +
> >  	return 0;
> >  }
> >  
> > @@ -248,6 +274,162 @@ DEFINE_LSM(loadpin) = {
> >  	.init = loadpin_init,
> >  };
> >  
> > +#ifdef CONFIG_SECURITY_LOADPIN_VERITY
> > +
> > +enum loadpin_securityfs_interface_index {
> > +	LOADPIN_DM_VERITY,
> > +};
> > +
> > +static int read_trusted_verity_root_digests(unsigned int fd)
> > +{
> > +	struct fd f;
> > +	void *data;
> > +	int rc;
> > +	char *p, *d;
> > +
> > +	/* The list of trusted root digests can only be set up once */
> > +	if (!list_empty(&trusted_verity_root_digests))
> > +		return -EPERM;
> > +
> > +	f = fdget(fd);
> > +	if (!f.file)
> > +		return -EINVAL;
> > +
> > +	data = kzalloc(SZ_4K, GFP_KERNEL);
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	rc = kernel_read_file(f.file, 0, &data, SZ_4K - 1, NULL, READING_POLICY);
> > +	if (rc < 0)
> > +		goto err;
> > +
> > +	((char *)data)[rc] = '\0';
> > +
> > +	p = strim(data);
> > +	while ((d = strsep(&p, ",")) != NULL) {
> > +		int len = strlen(d);
> > +		struct trusted_root_digest *trd;
> > +
> > +		if (len % 2) {
> > +			rc = -EPROTO;
> > +			goto err;
> > +		}
> > +
> > +		len /= 2;
> > +
> > +		trd = kzalloc(sizeof(*trd), GFP_KERNEL);
> > +		if (!trd) {
> > +			rc = -ENOMEM;
> > +			goto err;
> > +		}
> > +
> > +		trd->data = kzalloc(len, GFP_KERNEL);
> > +		if (!trd->data) {
> > +			kfree(trd);
> > +			rc = -ENOMEM;
> > +			goto err;
> > +		}
> > +
> > +		if (hex2bin(trd->data, d, len)) {
> > +			kfree(trd);
> > +			kfree(trd->data);
> > +			rc = -EPROTO;
> > +			goto err;
> > +		}
> > +
> > +		trd->len = len;
> > +
> > +		list_add_tail(&trd->node, &trusted_verity_root_digests);
> > +	}
> > +
> > +	kfree(data);
> > +	fdput(f);
> > +
> > +	if (!list_empty(&trusted_verity_root_digests))
> > +		dm_verity_loadpin_set_trusted_root_digests(&trusted_verity_root_digests);
> > +
> > +	return 0;
> > +
> > +err:
> > +	kfree(data);
> > +
> > +	{
> > +		struct trusted_root_digest *trd, *tmp;
> > +
> > +		list_for_each_entry_safe(trd, tmp, &trusted_verity_root_digests, node) {
> > +			kfree(trd->data);
> > +			list_del(&trd->node);
> > +			kfree(trd);
> > +		}
> > +	}
> > +
> > +	fdput(f);
> > +
> > +	return rc;
> > +}
> > +
> > +/******************************** securityfs ********************************/
> > +
> > +static long dm_verity_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > +{
> > +	void __user *uarg = (void __user *)arg;
> > +	unsigned int fd;
> > +	int rc;
> > +
> > +	switch (cmd) {
> > +	case LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS:
> > +		rc = copy_from_user(&fd, uarg, sizeof(fd));
> > +		if (rc)
> > +			return rc;
> > +
> > +		return read_trusted_verity_root_digests(fd);
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static const struct file_operations loadpin_dm_verity_ops = {
> > +	.unlocked_ioctl = dm_verity_ioctl,
> > +	.compat_ioctl = compat_ptr_ioctl,
> > +};
> > +
> > +/**
> > + * init_loadpin_securityfs - create the securityfs directory for LoadPin
> > + *
> > + * We can not put this method normally under the loadpin_init() code path since
> > + * the security subsystem gets initialized before the vfs caches.
> > + *
> > + * Returns 0 if the securityfs directory creation was successful.
> > + */
> > +static int __init init_loadpin_securityfs(void)
> > +{
> > +	struct dentry *loadpin_dir, *dentry;
> > +
> > +	loadpin_dir = securityfs_create_dir("loadpin", NULL);
> > +	if (IS_ERR(loadpin_dir)) {
> > +		pr_err("LoadPin: could not create securityfs dir: %d\n",
> > +		       PTR_ERR(loadpin_dir));
> > +		return PTR_ERR(loadpin_dir);
> > +	}
> > +
> > +	dentry = securityfs_create_file("dm-verity", 0600, loadpin_dir,
> > +					(void *)LOADPIN_DM_VERITY, &loadpin_dm_verity_ops);
> > +	if (IS_ERR(dentry)) {
> > +		pr_err("LoadPin: could not create securityfs entry 'dm-verity': %d\n",
> > +		       PTR_ERR(dentry));
> > +		return PTR_ERR(dentry);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +fs_initcall(init_loadpin_securityfs);
> > +
> > +#endif /* CONFIG_SECURITY_LOADPIN_VERITY */
> > +
> >  /* Should not be mutable after boot, so not listed in sysfs (perm == 0). */
> >  module_param(enforce, int, 0);
> >  MODULE_PARM_DESC(enforce, "Enforce module/firmware pinning");
> > -- 
> > 2.36.0.464.gb9c8b46e94-goog
> > 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

