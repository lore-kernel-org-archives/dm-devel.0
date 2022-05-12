Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD054C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 18:14:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-luiW9TJcNPaXSrW9ynz_mQ-1; Thu, 12 May 2022 14:14:48 -0400
X-MC-Unique: luiW9TJcNPaXSrW9ynz_mQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AB9989C7E2;
	Thu, 12 May 2022 18:14:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE84243EA14;
	Thu, 12 May 2022 18:14:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 727A61947058;
	Thu, 12 May 2022 18:14:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ABE7D194704A
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 May 2022 18:14:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B2E543EA16; Thu, 12 May 2022 18:14:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 971E343EA14
 for <dm-devel@redhat.com>; Thu, 12 May 2022 18:14:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EF008219B2
 for <dm-devel@redhat.com>; Thu, 12 May 2022 18:14:44 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-RvMfxhpVNLm7_xft0Ua6Bw-1; Thu, 12 May 2022 14:14:42 -0400
X-MC-Unique: RvMfxhpVNLm7_xft0Ua6Bw-1
Received: by mail-pl1-f182.google.com with SMTP id c9so5700740plh.2
 for <dm-devel@redhat.com>; Thu, 12 May 2022 11:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cCpgnlokOHjQ6j/qE23MNlKmH4my80Kr9jmbJvKV6HA=;
 b=oehod/oXR2JU9Pk94uxpn59YdzCZScu0A+Er6FBVMF0XFmqHgz/j7yb2T24bU2v3mP
 7p1Rw7qS6KQH/Fg+VUhJ3psrG3I1eZ3/CsKwIo1noxAQKkzRYBqTYzbHp4/I+dFS4dSh
 0omcJN1a8uO//Ypd9yX91URfkqq/2OXaFVN/CsR0+v+E83C3gcGJH05KCNQs00kfT/h3
 BZCffDW1UEJ2mOVSYyu6IfEyTNcTZW6Ycwc1B1je8GSr46gmNqoAG8uoQfWIrwpsSg52
 dVcNomRyY6EeE7xo8AjI9pWBoO89U7yqi6wlRVFcrGwEtSnB9OoqfYAiM2MXiUcHHjjt
 NdOQ==
X-Gm-Message-State: AOAM5335wPu1C/hbLf+HmUiex66PjHbn+VJsiUFvcBV1ObPzhKA5D6hZ
 LKRJQ8U6pFY7mMbrPOeX8LxMqV+QkImd4g==
X-Google-Smtp-Source: ABdhPJypRHjtT0PbhvqQRFPkQZb/fkg7qH35ifjYftEZ78Yyu2okd3YzjQ1tU40i7giF8J8ikKLpqA==
X-Received: by 2002:a17:90b:4a4a:b0:1dc:4731:31a4 with SMTP id
 lb10-20020a17090b4a4a00b001dc473131a4mr791436pjb.19.1652379281590; 
 Thu, 12 May 2022 11:14:41 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:4060:29b:ac8a:c726])
 by smtp.gmail.com with UTF8SMTPSA id
 l66-20020a633e45000000b003c14af505f3sm46212pga.11.2022.05.12.11.14.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 12 May 2022 11:14:40 -0700 (PDT)
Date: Thu, 12 May 2022 11:14:39 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yn1Oj5aneik2hNZy@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <YnwioaRiVmYevo8i@google.com> <Yn1BkO4t+CXR0nzk@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yn1BkO4t+CXR0nzk@redhat.com>
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

On Thu, May 12, 2022 at 01:19:12PM -0400, Mike Snitzer wrote:
> On Wed, May 11 2022 at  4:54P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > Alasdar/Mike, I'd be interested in your take on adding these functions
> > to verity/DM, to get an idea whether this series has a path forward to
> > landing upstream.
> 
> I'll be reviewing your patchset now. Comments inlined below.

Thanks for the review!

> > On Wed, May 04, 2022 at 12:54:17PM -0700, Matthias Kaehlcke wrote:
> > > LoadPin limits loading of kernel modules, firmware and certain
> > > other files to a 'pinned' file system (typically a read-only
> > > rootfs). To provide more flexibility LoadPin is being extended
> > > to also allow loading these files from trusted dm-verity
> > > devices. For that purpose LoadPin can be provided with a list
> > > of verity root digests that it should consider as trusted.
> > > 
> > > Add a bunch of helpers to allow LoadPin to check whether a DM
> > > device is a trusted verity device. The new functions broadly
> > > fall in two categories: those that need access to verity
> > > internals (like the root digest), and the 'glue' between
> > > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > > the glue functions.
> > > 
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > > 
> > > Changes in v3:
> > > - none
> > > 
> > > Changes in v2:
> > > - none
> > > 
> > >  drivers/md/Makefile               |  6 +++
> > >  drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
> > >  drivers/md/dm-verity-target.c     | 33 +++++++++++++
> > >  drivers/md/dm-verity.h            |  4 ++
> > >  include/linux/dm-verity-loadpin.h | 27 +++++++++++
> > >  5 files changed, 150 insertions(+)
> > >  create mode 100644 drivers/md/dm-verity-loadpin.c
> > >  create mode 100644 include/linux/dm-verity-loadpin.h
> > > 
> > > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > > index 0454b0885b01..e12cd004d375 100644
> > > --- a/drivers/md/Makefile
> > > +++ b/drivers/md/Makefile
> > > @@ -100,6 +100,12 @@ ifeq ($(CONFIG_IMA),y)
> > >  dm-mod-objs			+= dm-ima.o
> > >  endif
> > >  
> > > +ifeq ($(CONFIG_DM_VERITY),y)
> > > +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> > > +dm-mod-objs			+= dm-verity-loadpin.o
> > > +endif
> > > +endif
> > > +
> 
> Why are you extending dm-mod-objs?  Why not dm-verity-objs?
> 
> > >  ifeq ($(CONFIG_DM_VERITY_FEC),y)
> > >  dm-verity-objs			+= dm-verity-fec.o
> > >  endif
> > > diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> > > new file mode 100644
> > > index 000000000000..972ca93a2231
> > > --- /dev/null
> > > +++ b/drivers/md/dm-verity-loadpin.c
> > > @@ -0,0 +1,80 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +#include <linux/list.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/dm-verity-loadpin.h>
> > > +
> > > +#include "dm.h"
> > > +#include "dm-verity.h"
> > > +
> > > +static struct list_head *trusted_root_digests;
> > > +
> > > +/*
> > > + * Sets the root digests of verity devices which LoadPin considers as trusted.
> > > + *
> > > + * This function must only be called once.
> > > + */
> > > +void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
> > > +{
> > > +	if (!trusted_root_digests)
> > > +		trusted_root_digests = digests;
> > > +	else
> > > +		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
> > > +}
> 
> Would prefer you set a DM_MSG_PREFIX and use DMWARN() instead.

Sure, I'll change it to DMWARN().

> You never explicitly initialize trusted_root_digests to NULL.

That's what I had initially, however checkpatch didn't like it:

ERROR: do not initialise statics to NULL
#70: FILE: drivers/md/dm-verity-loadpin.c:10:
+static struct list_head *trusted_root_digests = NULL;

So I removed it.

> Also, I'll have to look at the caller(s), but without locking this
> branching is racey.

The list of trusted root digests can only be set once and is never
cleared. So if it is not set there is nothing to do, and if it is
set the list is immutable. We are trusting the caller to adhere to
that 'contract' and partially enforce it in dm_verity_loadpin_set_trusted_root_digests()
With that do you still think locking is needed?

> > > +
> > > +static bool is_trusted_verity_target(struct dm_target *ti)
> > > +{
> > > +	u8 *root_digest;
> > > +	unsigned int digest_size;
> > > +	struct trusted_root_digest *trd;
> > > +	bool trusted = false;
> > > +
> > > +	if (!dm_is_verity_target(ti))
> > > +		return false;
> > > +
> > > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > > +		return false;
> > > +
> > > +	list_for_each_entry(trd, trusted_root_digests, node) {
> > > +		if ((trd->len == digest_size) &&
> > > +		    !memcmp(trd->data, root_digest, digest_size)) {
> > > +			trusted = true;
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	kfree(root_digest);
> > > +
> > > +	return trusted;
> > > +}
> > > +
> > > +/*
> > > + * Determines whether a mapped device is a verity device that is trusted
> > > + * by LoadPin.
> > > + */
> > > +bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> > > +{
> > > +	int srcu_idx;
> > > +	struct dm_table *table;
> > > +	unsigned int num_targets;
> > > +	bool trusted = false;
> > > +	int i;
> > > +
> > > +	if (!trusted_root_digests || list_empty(trusted_root_digests))
> > > +		return false;
> 
> Again, where is the locking to protect trusted_root_digests?

See above

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

