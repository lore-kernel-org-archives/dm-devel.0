Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D1FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 19:52:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-TT0vmGi-MVGChzmvwDTU5w-1; Wed, 18 May 2022 15:52:32 -0400
X-MC-Unique: TT0vmGi-MVGChzmvwDTU5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5131C833961;
	Wed, 18 May 2022 19:52:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F1DCB1400B18;
	Wed, 18 May 2022 19:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA7D41947B8F;
	Wed, 18 May 2022 19:52:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B22221947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 19:52:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4AA8240D282A; Wed, 18 May 2022 19:52:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44FBE40D2829
 for <dm-devel@redhat.com>; Wed, 18 May 2022 19:52:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23E0C3C16186
 for <dm-devel@redhat.com>; Wed, 18 May 2022 19:52:25 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-ANtgRkzFN024pqFKElfbtQ-1; Wed, 18 May 2022 15:52:23 -0400
X-MC-Unique: ANtgRkzFN024pqFKElfbtQ-1
Received: by mail-qk1-f179.google.com with SMTP id v11so2327278qkf.1
 for <dm-devel@redhat.com>; Wed, 18 May 2022 12:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5q8BLVP39pZEp8vGRlvu+IzyMqb+h/dIvWxZHWF016Q=;
 b=Fozhx8XI5n3MpDrSKmlIFnCw+Yfn0JVBxXB9oMJjncGq6mwXwqJh6i1TfMo++lMa0R
 aZ8XpM31XAMcDG51MQftM0cpNE8IyK90woN1BE8TDxMxDMG/b23b0BFc9qH4ktBO6iWY
 09TXp11tzEJiPg/fqpJSdgokLiPDb7d8bm1I5dB0QuNfTTKM50cilcB9qIqwcGtBjxuH
 upnJEfXGBhlrCxBwE+NAoaidM3kbcuL08CsPF8Ls7GGjg4fMCwSRysZ4ldkcm0x1mtZS
 7okYO6lrqjar9IUNysS1x7AyWdaxd7B4eek+/+bRtitZSCHmZIveKug13NvbZYe8uwcL
 nscg==
X-Gm-Message-State: AOAM532iHuJftXC5ZPt/I5yDYEgl7OZnQQFkh7ZMauoKcOj71wWOftpa
 LEKSBBZ59trH74Esji+0FgmNKgA=
X-Google-Smtp-Source: ABdhPJz+loleNUpSkL24UZnw62lRUrWDSpvJvcEqGe/agg83EaEuWmL7sM3wULnBU3C166gM6OZGPg==
X-Received: by 2002:a05:620a:414b:b0:6a0:5c30:66fb with SMTP id
 k11-20020a05620a414b00b006a05c3066fbmr826967qko.53.1652903543069; 
 Wed, 18 May 2022 12:52:23 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 v14-20020a05622a188e00b002f8f406338fsm87014qtc.42.2022.05.18.12.52.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 12:52:22 -0700 (PDT)
Date: Wed, 18 May 2022 15:52:21 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <YoVOdYHJd/LbYIaE@redhat.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
MIME-Version: 1.0
In-Reply-To: <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 1/3] dm: Add verity helpers for LoadPin
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
 linux-kernel@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 17 2022 at  7:34P -0400,
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
> ---
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
>  drivers/md/dm-verity-target.c     | 33 ++++++++++++++
>  drivers/md/dm-verity.h            |  4 ++
>  include/linux/dm-verity-loadpin.h | 27 +++++++++++
>  5 files changed, 144 insertions(+)
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
> index 000000000000..3226fbe4a1fe
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
> +bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb)
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
> +	md = dm_get_md(sb->s_bdev->bd_dev);
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

Not seeing why passing a super_block a block layer interface was
chosen.

Please pass the super_block's block_device and rename to
dm_verity_loadpin_is_bdev_trusted()

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

