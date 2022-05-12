Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBAC0C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652375964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/tUHZxa7VdcG+cKBPsnOIU0h/w3eWl/5MoxGH/eS8TQ=;
	b=Ee9Lzqc3thd1Gj1PM9+Ta1UNwhjaQj/79OwdimvcY0VkHaMb5uh94bI2JV/jg0btMUnS4a
	wHtkWAGrs39EHWMRrVPj1dAVov4A2ZYO9FaHK7iEb7STALo+j1lkX7AQ+G5NyTy+G8s5PO
	RoU+MWCO+PBjwWNWGrMegKDmrwHO7VQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-BCzRDYsZOdC6RJGUtQXayA-1; Thu, 12 May 2022 13:19:21 -0400
X-MC-Unique: BCzRDYsZOdC6RJGUtQXayA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CE8E86B8A2;
	Thu, 12 May 2022 17:19:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D9BC2026D6A;
	Thu, 12 May 2022 17:19:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54B331947058;
	Thu, 12 May 2022 17:19:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D77A2194704A
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 May 2022 17:19:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C69F0400DFBB; Thu, 12 May 2022 17:19:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C241B40CF8F4
 for <dm-devel@redhat.com>; Thu, 12 May 2022 17:19:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA1E7101AA42
 for <dm-devel@redhat.com>; Thu, 12 May 2022 17:19:16 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-Qy09aQ3fNEyQcJEdtMmovQ-1; Thu, 12 May 2022 13:19:15 -0400
X-MC-Unique: Qy09aQ3fNEyQcJEdtMmovQ-1
Received: by mail-qt1-f200.google.com with SMTP id
 u11-20020a05622a198b00b002f3be513f83so4341352qtc.4
 for <dm-devel@redhat.com>; Thu, 12 May 2022 10:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oEFXUtbClHFFmeWShgFw8vJilTye35f28JoIGyS8/V0=;
 b=mx3QoiMOHNiOWHopfLgy6anK70OybiMJFmILu7VStBoQ/03lLkInsX9vQCiLGCKevB
 Vf7F2vCaAbYrGdGSWHjg+l1c4agK+DU998sLywf34N9Hc17SJY2MrtNMbN+7NFnxFieK
 xaL8aG6aTlnAzrsnPwlEaF39GyT6IIO5satNMlTfMsMhcJcbIg/Fxpb1QvbhPbTi4xsb
 SytYljvnAvbnM6fhJ1pHkZDQDjVvYWbrmXaMTaH9kXrc/ozSzeZpy5maE+YG9PR/tk2X
 hKqhdW8eJgzoH4EtT/UmVImMe7wJ0pydil2q+pSaf58q9Hp4e6twn2SJZSoh4u20YsqU
 /IXQ==
X-Gm-Message-State: AOAM533KMSF/l+iaqp0BHcaGh+fi/RNmZUrV3jPaHMZmSsMtSTmlr79E
 ksfml10GgXyAp03RuxicIdMQv0bTp5JzYPMrewcnJAVZambCWDKEp8maxCX+jbRGJ7QAMMonQZ7
 Z2tHDDzVmJeKf3Q==
X-Received: by 2002:a05:620a:c43:b0:67d:f048:f5e9 with SMTP id
 u3-20020a05620a0c4300b0067df048f5e9mr707659qki.281.1652375954897; 
 Thu, 12 May 2022 10:19:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykQ0VJO8iqsfXZLVTIsX7tPq3/5ge1HQXrF4uHNL4asswoVlbtihDk13sRBvxtNiaNVD0epg==
X-Received: by 2002:a05:620a:c43:b0:67d:f048:f5e9 with SMTP id
 u3-20020a05620a0c4300b0067df048f5e9mr707646qki.281.1652375954576; 
 Thu, 12 May 2022 10:19:14 -0700 (PDT)
Received: from localhost ([66.187.232.66]) by smtp.gmail.com with ESMTPSA id
 j126-20020a375584000000b006a103949657sm27998qkb.38.2022.05.12.10.19.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 12 May 2022 10:19:13 -0700 (PDT)
Date: Thu, 12 May 2022 13:19:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <Yn1BkO4t+CXR0nzk@redhat.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <YnwioaRiVmYevo8i@google.com>
MIME-Version: 1.0
In-Reply-To: <YnwioaRiVmYevo8i@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
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

On Wed, May 11 2022 at  4:54P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> Alasdar/Mike, I'd be interested in your take on adding these functions
> to verity/DM, to get an idea whether this series has a path forward to
> landing upstream.

I'll be reviewing your patchset now. Comments inlined below.

> On Wed, May 04, 2022 at 12:54:17PM -0700, Matthias Kaehlcke wrote:
> > LoadPin limits loading of kernel modules, firmware and certain
> > other files to a 'pinned' file system (typically a read-only
> > rootfs). To provide more flexibility LoadPin is being extended
> > to also allow loading these files from trusted dm-verity
> > devices. For that purpose LoadPin can be provided with a list
> > of verity root digests that it should consider as trusted.
> > 
> > Add a bunch of helpers to allow LoadPin to check whether a DM
> > device is a trusted verity device. The new functions broadly
> > fall in two categories: those that need access to verity
> > internals (like the root digest), and the 'glue' between
> > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > the glue functions.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > 
> > Changes in v3:
> > - none
> > 
> > Changes in v2:
> > - none
> > 
> >  drivers/md/Makefile               |  6 +++
> >  drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
> >  drivers/md/dm-verity-target.c     | 33 +++++++++++++
> >  drivers/md/dm-verity.h            |  4 ++
> >  include/linux/dm-verity-loadpin.h | 27 +++++++++++
> >  5 files changed, 150 insertions(+)
> >  create mode 100644 drivers/md/dm-verity-loadpin.c
> >  create mode 100644 include/linux/dm-verity-loadpin.h
> > 
> > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > index 0454b0885b01..e12cd004d375 100644
> > --- a/drivers/md/Makefile
> > +++ b/drivers/md/Makefile
> > @@ -100,6 +100,12 @@ ifeq ($(CONFIG_IMA),y)
> >  dm-mod-objs			+= dm-ima.o
> >  endif
> >  
> > +ifeq ($(CONFIG_DM_VERITY),y)
> > +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> > +dm-mod-objs			+= dm-verity-loadpin.o
> > +endif
> > +endif
> > +

Why are you extending dm-mod-objs?  Why not dm-verity-objs?

> >  ifeq ($(CONFIG_DM_VERITY_FEC),y)
> >  dm-verity-objs			+= dm-verity-fec.o
> >  endif
> > diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> > new file mode 100644
> > index 000000000000..972ca93a2231
> > --- /dev/null
> > +++ b/drivers/md/dm-verity-loadpin.c
> > @@ -0,0 +1,80 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <linux/list.h>
> > +#include <linux/kernel.h>
> > +#include <linux/dm-verity-loadpin.h>
> > +
> > +#include "dm.h"
> > +#include "dm-verity.h"
> > +
> > +static struct list_head *trusted_root_digests;
> > +
> > +/*
> > + * Sets the root digests of verity devices which LoadPin considers as trusted.
> > + *
> > + * This function must only be called once.
> > + */
> > +void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
> > +{
> > +	if (!trusted_root_digests)
> > +		trusted_root_digests = digests;
> > +	else
> > +		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
> > +}

Would prefer you set a DM_MSG_PREFIX and use DMWARN() instead.

You never explicitly initialize trusted_root_digests to NULL.

Also, I'll have to look at the caller(s), but without locking this
branching is racey.

> > +
> > +static bool is_trusted_verity_target(struct dm_target *ti)
> > +{
> > +	u8 *root_digest;
> > +	unsigned int digest_size;
> > +	struct trusted_root_digest *trd;
> > +	bool trusted = false;
> > +
> > +	if (!dm_is_verity_target(ti))
> > +		return false;
> > +
> > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > +		return false;
> > +
> > +	list_for_each_entry(trd, trusted_root_digests, node) {
> > +		if ((trd->len == digest_size) &&
> > +		    !memcmp(trd->data, root_digest, digest_size)) {
> > +			trusted = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	kfree(root_digest);
> > +
> > +	return trusted;
> > +}
> > +
> > +/*
> > + * Determines whether a mapped device is a verity device that is trusted
> > + * by LoadPin.
> > + */
> > +bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> > +{
> > +	int srcu_idx;
> > +	struct dm_table *table;
> > +	unsigned int num_targets;
> > +	bool trusted = false;
> > +	int i;
> > +
> > +	if (!trusted_root_digests || list_empty(trusted_root_digests))
> > +		return false;

Again, where is the locking to protect trusted_root_digests?

> > +	table = dm_get_live_table(md, &srcu_idx);
> > +	num_targets = dm_table_get_num_targets(table);
> > +	for (i = 0; i < num_targets; i++) {
> > +		struct dm_target *ti = dm_table_get_target(table, i);
> > +
> > +		if (is_trusted_verity_target(ti)) {
> > +			trusted = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	dm_put_live_table(md, srcu_idx);
> > +
> > +	return trusted;
> > +}
> > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> > index 80133aae0db3..6f07b849fcb2 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/module.h>
> >  #include <linux/reboot.h>
> >  #include <linux/scatterlist.h>
> > +#include <linux/string.h>
> >  
> >  #define DM_MSG_PREFIX			"verity"
> >  
> > @@ -1310,6 +1311,38 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >  	return r;
> >  }
> >  
> > +/*
> > + * Check whether a DM target is a verity target.
> > + */
> > +bool dm_is_verity_target(struct dm_target *ti)
> > +{
> > +	return ti->type->module == THIS_MODULE;
> > +}
> > +EXPORT_SYMBOL_GPL(dm_is_verity_target);
> > +
> > +/*
> > + * Get the root digest of a verity target.
> > + *
> > + * Returns a copy of the root digest, the caller is responsible for
> > + * freeing the memory of the digest.
> > + */
> > +int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned int *digest_size)
> > +{
> > +	struct dm_verity *v = ti->private;
> > +
> > +	if (!dm_is_verity_target(ti))
> > +		return -EINVAL;
> > +
> > +	*root_digest = kmemdup(v->root_digest, v->digest_size, GFP_KERNEL);
> > +	if (*root_digest == NULL)
> > +		return -ENOMEM;
> > +
> > +	*digest_size = v->digest_size;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dm_verity_get_root_digest);
> > +
> >  static struct target_type verity_target = {
> >  	.name		= "verity",
> >  	.version	= {1, 8, 0},
> > diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> > index 4e769d13473a..c832cc3e3d24 100644
> > --- a/drivers/md/dm-verity.h
> > +++ b/drivers/md/dm-verity.h
> > @@ -129,4 +129,8 @@ extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
> >  extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
> >  				 sector_t block, u8 *digest, bool *is_zero);
> >  
> > +extern bool dm_is_verity_target(struct dm_target *ti);
> > +extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
> > +				     unsigned int *digest_size);
> > +
> >  #endif /* DM_VERITY_H */
> > diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
> > new file mode 100644
> > index 000000000000..12a86911d05a
> > --- /dev/null
> > +++ b/include/linux/dm-verity-loadpin.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef __LINUX_DM_VERITY_LOADPIN_H
> > +#define __LINUX_DM_VERITY_LOADPIN_H
> > +
> > +#include <linux/list.h>
> > +
> > +struct mapped_device;
> > +
> > +struct trusted_root_digest {
> > +	u8 *data;
> > +	unsigned int len;
> > +	struct list_head node;
> > +};
> > +
> > +#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
> > +void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests);
> > +bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md);
> > +#else
> > +static inline void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests) {}
> > +static inline bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> > +{
> > +	return false;
> > +}
> > +#endif
> > +
> > +#endif /* __LINUX_DM_LOADPIN_H */
> > -- 
> > 2.36.0.464.gb9c8b46e94-goog
> > 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

