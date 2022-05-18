Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BEBC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 20:04:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-H9hJNCuDNdq1Z7Hw7BgB4Q-1; Wed, 18 May 2022 16:04:42 -0400
X-MC-Unique: H9hJNCuDNdq1Z7Hw7BgB4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA7AC1C3E9BA;
	Wed, 18 May 2022 20:04:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12366200BA83;
	Wed, 18 May 2022 20:04:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB61E1947B8F;
	Wed, 18 May 2022 20:04:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E80AF1947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 20:04:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3E2940D2836; Wed, 18 May 2022 20:04:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B637403D163
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:04:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FD961C05ABD
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:04:01 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-5Z2mu4nfP4qgWcbxR_qp6Q-1; Wed, 18 May 2022 16:03:51 -0400
X-MC-Unique: 5Z2mu4nfP4qgWcbxR_qp6Q-1
Received: by mail-qk1-f170.google.com with SMTP id z126so2362988qkb.2
 for <dm-devel@redhat.com>; Wed, 18 May 2022 13:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7Qpd/J7A8SCSKU6yZw0hxy+iztL0Wu+jzDVTa+YGvyo=;
 b=GJmQ7dFzh+g33RMGEujf8Kc8iC1RwMlUbiUZ8R7WSRp5azyXvV2MmTEeOW1Ex4r7cb
 l3YUGXBx/Q0PbtnF+MJltYL/zz8QlHagNhYNQ61qg3GQaZvwKYFp9sscab2ZURmrXQga
 ac5sRaZ73h7mXBWDOwb7171x0iSxBB9SQY2RVfX0fGEnQqeD354eG+bi7wGTL85TfR3e
 y/rxFu7quYxbz3n5NGoUzJ14BQbU+QRbHRI6JrzSFwcTvqeuFq2i4/nzepwqnraDbNY8
 P10bSWIqrnwQUobuwpssA+tmFvB+1z1lOuic9GMtlUQNg2Cgbp4pz9fdSlTsAgVTBJvk
 /2CQ==
X-Gm-Message-State: AOAM533oPBuQyto/NL0FnpitJhIaXiV6gEdLkr5g9bjYebjDKK6uU5s9
 L2TsCiSKSnR1rRFTBKn/B1gDegQEreYAXYLW5g==
X-Google-Smtp-Source: ABdhPJwEU5F9uKrOZEN4PLvxlHlsC7JKL94tfNkKx/c8tpQgbDVfOXmn74Adm6rOuDC33973uwbA2A==
X-Received: by 2002:a05:620a:4612:b0:6a0:125b:56be with SMTP id
 br18-20020a05620a461200b006a0125b56bemr821947qkb.369.1652904225547; 
 Wed, 18 May 2022 13:03:45 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w140-20020a376292000000b006a10aa7908dsm108133qkb.38.2022.05.18.13.03.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 13:03:45 -0700 (PDT)
Date: Wed, 18 May 2022 16:03:44 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <YoVRIHfXPa7+e1Zh@redhat.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
 <YoUNH7MrfEb844ft@google.com>
MIME-Version: 1.0
In-Reply-To: <YoUNH7MrfEb844ft@google.com>
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
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 Douglas Anderson <dianders@chromium.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
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

On Wed, May 18 2022 at 11:13P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> Hi Milan,
> 
> On Wed, May 18, 2022 at 09:57:43AM +0200, Milan Broz wrote:
> > On 18/05/2022 01:34, Matthias Kaehlcke wrote:
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
> > 
> > ...
> > 
> > > +
> > > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > > +		return false;
> > 
> > Almost unrelated note, but as there are more and more situations
> > that checks verity root digest, shouldn't we export this as read-only
> > sysfs attribute for DM verity devices?
> > 
> > Attacker can always calculate (but not change) Merkle tree, so this
> > is not something that need to be hidden.
> > 
> > It would allow userspace to easily enumerate trusted DM devices without
> > calling kernel ioctls...
> 
> I guess that's an option if there are scenarios where it is useful. It
> should probably be a separate patch, since it isn't directly related with
> extending LoadPin support to trusted verity devices.
> 
> > > +
> > > +	table = dm_get_live_table(md, &srcu_idx);
> > > +
> > > +	if (dm_table_get_num_targets(table) != 1)
> > > +		goto out;
> > > +
> > > +	ti = dm_table_get_target(table, 0);
> > > +
> > > +	if (is_trusted_verity_target(ti))
> > > +		trusted = true;
> > 
> > What happens is someone reloads verity table later with
> > a different content (or even different target type)?
> > Does LoadPin even care here?
> 
> LoadPin cares, but only when new kernel files are loaded. It will then check
> against the new verity table, and only allow loading of the file if it comes
> from a verity target with a trusted digest.
> 
> > >   static struct target_type verity_target = {
> > >   	.name		= "verity",
> > >   	.version	= {1, 8, 0},
> > 
> > Please increase the minor version, it is very useful to detect (in logs)
> > that the target driver has compatible extensions.
> 
> I can do that, but would like to confirm that this is really needed/desired.
> This patch adds kernel-internal APIs which aren't accessible to userspace,
> that don't impact verity directly, so I'm not sure an increased minor version
> would be useful.

Bumping to 1.8.1 is useful to indicate new changes that offer expanded
use of the verity target (even if by LoadPin).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

