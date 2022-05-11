Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14149C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 11 May 2022 20:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-sCwzEXEEODWmdBSG4dVRcw-1; Wed, 11 May 2022 16:55:44 -0400
X-MC-Unique: sCwzEXEEODWmdBSG4dVRcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50723811E80;
	Wed, 11 May 2022 20:55:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 781A9400E86A;
	Wed, 11 May 2022 20:55:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C631194707A;
	Wed, 11 May 2022 20:55:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0556E194975B
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 May 2022 20:55:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D64E0552AAA; Wed, 11 May 2022 20:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1E2E552AB2
 for <dm-devel@redhat.com>; Wed, 11 May 2022 20:55:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E161C00AC1
 for <dm-devel@redhat.com>; Wed, 11 May 2022 20:55:37 +0000 (UTC)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-ybb2b3jDM6eZfw4r8sslBQ-1; Wed, 11 May 2022 16:55:01 -0400
X-MC-Unique: ybb2b3jDM6eZfw4r8sslBQ-1
Received: by mail-pj1-f50.google.com with SMTP id
 cq17-20020a17090af99100b001dc0386cd8fso3093894pjb.5
 for <dm-devel@redhat.com>; Wed, 11 May 2022 13:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=E+tE8jOYitJVRGmHjUOL7gxMXV553nM3OymWffscmCw=;
 b=zgZydhdE1NWX9MF+ywybJ9SgJJQvn9kesy1Lp6EISn4qYaNgz4kkF234fucklefcMZ
 p8v5rnqISN2PerZq55kkoZIvcgcch5XPJXqevXsWITLcgAkaQLv+8JhiRqV4pwOzky25
 wgsyvWvrSA2FycncDD0dXPZcMw4HvIcPywUo5IhIGQzxX3yNVLSPNDoYRhLYEwZZZ28K
 7CzIF51227+mwEqi4BIFP8Cou9/Ff6P+5g40TkNUgLBr/u0bbkwLehofnG9Jc9t1AaCN
 Osgs3eIMsUcuv8Q2cL8DsgCvPP+5cFnt79D0ZfNikDvNPQmmmhxKSHIQt7KXav5+gqmW
 kM1Q==
X-Gm-Message-State: AOAM530wJsxnb4F31qIY1fnSVOgYme+qmUG4t16WfmlVFykD49xxSUPb
 Xo6mrXmUmxR66VZJ5HTQ7TGVBA==
X-Google-Smtp-Source: ABdhPJz1UXitekjbAHFYJrRunpwcE5/JCPpxSDxXqhs9z0YoBcIwPzSqhAxn+C5vDu35395T7aExgQ==
X-Received: by 2002:a17:90b:610:b0:1d9:4008:cfee with SMTP id
 gb16-20020a17090b061000b001d94008cfeemr7313092pjb.71.1652302499794; 
 Wed, 11 May 2022 13:54:59 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:c586:bf93:e960:73b4])
 by smtp.gmail.com with UTF8SMTPSA id
 y24-20020a63de58000000b003c14af50643sm277201pgi.91.2022.05.11.13.54.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 11 May 2022 13:54:59 -0700 (PDT)
Date: Wed, 11 May 2022 13:54:57 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Message-ID: <YnwioaRiVmYevo8i@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
MIME-Version: 1.0
In-Reply-To: <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3 1/3] dm: Add verity helpers for LoadPin
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
Cc: Douglas Anderson <dianders@chromium.org>,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Alasdar/Mike, I'd be interested in your take on adding these functions
to verity/DM, to get an idea whether this series has a path forward to
landing upstream.

Thanks

Matthias

On Wed, May 04, 2022 at 12:54:17PM -0700, Matthias Kaehlcke wrote:
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
> ---
> 
> Changes in v3:
> - none
> 
> Changes in v2:
> - none
> 
>  drivers/md/Makefile               |  6 +++
>  drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
>  drivers/md/dm-verity-target.c     | 33 +++++++++++++
>  drivers/md/dm-verity.h            |  4 ++
>  include/linux/dm-verity-loadpin.h | 27 +++++++++++
>  5 files changed, 150 insertions(+)
>  create mode 100644 drivers/md/dm-verity-loadpin.c
>  create mode 100644 include/linux/dm-verity-loadpin.h
> 
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 0454b0885b01..e12cd004d375 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -100,6 +100,12 @@ ifeq ($(CONFIG_IMA),y)
>  dm-mod-objs			+= dm-ima.o
>  endif
>  
> +ifeq ($(CONFIG_DM_VERITY),y)
> +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> +dm-mod-objs			+= dm-verity-loadpin.o
> +endif
> +endif
> +
>  ifeq ($(CONFIG_DM_VERITY_FEC),y)
>  dm-verity-objs			+= dm-verity-fec.o
>  endif
> diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> new file mode 100644
> index 000000000000..972ca93a2231
> --- /dev/null
> +++ b/drivers/md/dm-verity-loadpin.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/list.h>
> +#include <linux/kernel.h>
> +#include <linux/dm-verity-loadpin.h>
> +
> +#include "dm.h"
> +#include "dm-verity.h"
> +
> +static struct list_head *trusted_root_digests;
> +
> +/*
> + * Sets the root digests of verity devices which LoadPin considers as trusted.
> + *
> + * This function must only be called once.
> + */
> +void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
> +{
> +	if (!trusted_root_digests)
> +		trusted_root_digests = digests;
> +	else
> +		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
> +}
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
> +	list_for_each_entry(trd, trusted_root_digests, node) {
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
> + * Determines whether a mapped device is a verity device that is trusted
> + * by LoadPin.
> + */
> +bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> +{
> +	int srcu_idx;
> +	struct dm_table *table;
> +	unsigned int num_targets;
> +	bool trusted = false;
> +	int i;
> +
> +	if (!trusted_root_digests || list_empty(trusted_root_digests))
> +		return false;
> +
> +	table = dm_get_live_table(md, &srcu_idx);
> +	num_targets = dm_table_get_num_targets(table);
> +	for (i = 0; i < num_targets; i++) {
> +		struct dm_target *ti = dm_table_get_target(table, i);
> +
> +		if (is_trusted_verity_target(ti)) {
> +			trusted = true;
> +			break;
> +		}
> +	}
> +
> +	dm_put_live_table(md, srcu_idx);
> +
> +	return trusted;
> +}
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 80133aae0db3..6f07b849fcb2 100644
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
> @@ -1310,6 +1311,38 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
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
> +
>  static struct target_type verity_target = {
>  	.name		= "verity",
>  	.version	= {1, 8, 0},
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
> index 000000000000..12a86911d05a
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
> +struct mapped_device;
> +
> +struct trusted_root_digest {
> +	u8 *data;
> +	unsigned int len;
> +	struct list_head node;
> +};
> +
> +#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
> +void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests);
> +bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md);
> +#else
> +static inline void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests) {}
> +static inline bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> +{
> +	return false;
> +}
> +#endif
> +
> +#endif /* __LINUX_DM_LOADPIN_H */
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

