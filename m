Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA058C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 15:19:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-3G8Csvu3OAmPy5vEPGOYrA-1; Wed, 18 May 2022 11:19:40 -0400
X-MC-Unique: 3G8Csvu3OAmPy5vEPGOYrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 930D0101AA4D;
	Wed, 18 May 2022 15:19:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7486340C1438;
	Wed, 18 May 2022 15:19:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 360A91947B90;
	Wed, 18 May 2022 15:19:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 628EC1947B8F
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 15:13:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 43B601410DD9; Wed, 18 May 2022 15:13:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F4B51410DD5
 for <dm-devel@redhat.com>; Wed, 18 May 2022 15:13:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 279C785A5A8
 for <dm-devel@redhat.com>; Wed, 18 May 2022 15:13:40 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-flcP-zsHPsyPZymFmkS_kg-1; Wed, 18 May 2022 11:13:38 -0400
X-MC-Unique: flcP-zsHPsyPZymFmkS_kg-1
Received: by mail-pf1-f180.google.com with SMTP id y199so2410051pfb.9
 for <dm-devel@redhat.com>; Wed, 18 May 2022 08:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=R6GKon/CB8AHTG2BVleTAVkCbJAIy+Ec31rGL7OpKrA=;
 b=kN2SgV+g0Tsl2V2KQvrz843TuNlOyc3GiUhb4IKRweUe3dVrnNLIdLTiBRnZo7XyqL
 +4XMnermsPvvkCIYmsaT5ZYmzzqLQlUdlicPqHnUk0yL5KNX6H8XucpVnJRID7M4M/Cx
 UMTm/gfNcCNe9VjtUKmVENSjEuO8uB8tZ66Wi4j7q+FUWse0bOmie1L6JSUkyTtxGUUH
 X/ZDN2ln88SNH6occz2Cfii+dajRCO55NXJ7cV9P2e18CPBEuIZhu/58Kpj0KO8msZA/
 tYKRZ8JBY7uEjwL0Ldov4pPjoUgssS+q9qALBH8Py/Zl9ZMfW8sh6xm2NnRU/3HAp+a5
 wGoA==
X-Gm-Message-State: AOAM531vR1TQUfF2Pd0hsicrMHsNj9xGp1JB6PEtmTBpIJpnpfW4h5kq
 /iuvRjkVO6fJJjLG73Oe8NJGDA==
X-Google-Smtp-Source: ABdhPJyFOeC90y1HStFFR+BKQhegBQbMZrwLsSMlHpm5O9PYUeML8M3eBG6IOYh/5ylSnQ2jWSXYFw==
X-Received: by 2002:a65:4bc5:0:b0:3da:ec0c:c5f2 with SMTP id
 p5-20020a654bc5000000b003daec0cc5f2mr23770774pgr.221.1652886817386; 
 Wed, 18 May 2022 08:13:37 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
 by smtp.gmail.com with UTF8SMTPSA id
 j128-20020a62c586000000b005182e39038csm1629435pfg.38.2022.05.18.08.13.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 18 May 2022 08:13:36 -0700 (PDT)
Date: Wed, 18 May 2022 08:13:35 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <YoUNH7MrfEb844ft@google.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
MIME-Version: 1.0
In-Reply-To: <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
 linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 James Morris <jmorris@namei.org>, Douglas Anderson <dianders@chromium.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Milan,

On Wed, May 18, 2022 at 09:57:43AM +0200, Milan Broz wrote:
> On 18/05/2022 01:34, Matthias Kaehlcke wrote:
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
> 
> ...
> 
> > +
> > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > +		return false;
> 
> Almost unrelated note, but as there are more and more situations
> that checks verity root digest, shouldn't we export this as read-only
> sysfs attribute for DM verity devices?
> 
> Attacker can always calculate (but not change) Merkle tree, so this
> is not something that need to be hidden.
> 
> It would allow userspace to easily enumerate trusted DM devices without
> calling kernel ioctls...

I guess that's an option if there are scenarios where it is useful. It
should probably be a separate patch, since it isn't directly related with
extending LoadPin support to trusted verity devices.

> > +
> > +	table = dm_get_live_table(md, &srcu_idx);
> > +
> > +	if (dm_table_get_num_targets(table) != 1)
> > +		goto out;
> > +
> > +	ti = dm_table_get_target(table, 0);
> > +
> > +	if (is_trusted_verity_target(ti))
> > +		trusted = true;
> 
> What happens is someone reloads verity table later with
> a different content (or even different target type)?
> Does LoadPin even care here?

LoadPin cares, but only when new kernel files are loaded. It will then check
against the new verity table, and only allow loading of the file if it comes
from a verity target with a trusted digest.

> >   static struct target_type verity_target = {
> >   	.name		= "verity",
> >   	.version	= {1, 8, 0},
> 
> Please increase the minor version, it is very useful to detect (in logs)
> that the target driver has compatible extensions.

I can do that, but would like to confirm that this is really needed/desired.
This patch adds kernel-internal APIs which aren't accessible to userspace,
that don't impact verity directly, so I'm not sure an increased minor version
would be useful.

> I guess this change does not affect userspace veristysetup
> (as it is used handled by different tooling), right?

Correct, from the verity side this is effectively a NOP, the new
kernel-internal APIs only provide information to LoadPin, but don't
change any verity specific behavior.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

