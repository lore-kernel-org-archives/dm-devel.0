Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8863EC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 20:34:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-mpDAwCfwP2C8ziNrAjcpLA-1; Wed, 18 May 2022 16:34:37 -0400
X-MC-Unique: mpDAwCfwP2C8ziNrAjcpLA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA18B833963;
	Wed, 18 May 2022 20:34:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 766E8492C14;
	Wed, 18 May 2022 20:34:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 454D81947B8F;
	Wed, 18 May 2022 20:34:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 747361947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 20:34:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39B832166B1A; Wed, 18 May 2022 20:34:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D2B12166B2F
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:34:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09783801210
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:34:27 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-SJZahJHdMaidqsrBnqPIfA-1; Wed, 18 May 2022 16:34:25 -0400
X-MC-Unique: SJZahJHdMaidqsrBnqPIfA-1
Received: by mail-pj1-f46.google.com with SMTP id
 v5-20020a17090a7c0500b001df84fa82f8so3182045pjf.5
 for <dm-devel@redhat.com>; Wed, 18 May 2022 13:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=66dr9Y4+nGAythBm/U+gBptPm1LvULEFY+Acr0MuJSw=;
 b=Ba9lwK/X4JYakyT19LWR7NMNniUlY68rGvRQ3OmfWsrrgllrOicTydPn7W+nccOKT1
 Vp+faxRnMCgUGlLOnVwgsOBY1+P8mYxpaOfjCpIXaZduGi1yVP1FldmskZcH6AGMIPi8
 iPCD5bq06f3uu1ScVeI/5W+8kzHDjf1u+RRuoXKa3A6cUvUs0ZxWx7YRtVcBhNmYu/at
 a4t+wpCY1/JSJRC7qZZfHAuHooDOfJtbKvRZAnh8jhvdFPYGh5K6Z6oFExHb4RwyGaWq
 6GpCUEloE3H9aDhoLcMtun5ArAs6Nh46hMrqkOTMGVQZnFf0FnOnoWso0ZaNICQPYngq
 cx2Q==
X-Gm-Message-State: AOAM533vWkjqZcT9xQl3rEbOIPttdi7NJnuHVECdoHlksTaGvoqJ5qjT
 LkbxfgT6ObzlgtqNfWDfsijBpQ==
X-Google-Smtp-Source: ABdhPJwCOuHJM7T0rMcLBaHOW9wPJYWpAE1ug6I4fbANLq4cLIwuxoLqQF+SDIvDnlzyTgKdZun+3Q==
X-Received: by 2002:a17:903:228e:b0:161:8632:2725 with SMTP id
 b14-20020a170903228e00b0016186322725mr1358741plh.126.1652906064039; 
 Wed, 18 May 2022 13:34:24 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
 by smtp.gmail.com with UTF8SMTPSA id
 m1-20020a17090a858100b001d792761e2esm4020445pjn.47.2022.05.18.13.34.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 18 May 2022 13:34:23 -0700 (PDT)
Date: Wed, 18 May 2022 13:34:21 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <YoVYTf7oI4FNVHAJ@google.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
 <YoUNH7MrfEb844ft@google.com> <YoVRIHfXPa7+e1Zh@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YoVRIHfXPa7+e1Zh@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 18, 2022 at 04:03:44PM -0400, Mike Snitzer wrote:
> On Wed, May 18 2022 at 11:13P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > Hi Milan,
> > 
> > On Wed, May 18, 2022 at 09:57:43AM +0200, Milan Broz wrote:
> > > On 18/05/2022 01:34, Matthias Kaehlcke wrote:
> > > > LoadPin limits loading of kernel modules, firmware and certain
> > > > other files to a 'pinned' file system (typically a read-only
> > > > rootfs). To provide more flexibility LoadPin is being extended
> > > > to also allow loading these files from trusted dm-verity
> > > > devices. For that purpose LoadPin can be provided with a list
> > > > of verity root digests that it should consider as trusted.
> > > > 
> > > > Add a bunch of helpers to allow LoadPin to check whether a DM
> > > > device is a trusted verity device. The new functions broadly
> > > > fall in two categories: those that need access to verity
> > > > internals (like the root digest), and the 'glue' between
> > > > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > > > the glue functions.
> > > > 
> > > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > 
> > > ...
> > > 
> > > > +
> > > > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > > > +		return false;
> > > 
> > > Almost unrelated note, but as there are more and more situations
> > > that checks verity root digest, shouldn't we export this as read-only
> > > sysfs attribute for DM verity devices?
> > > 
> > > Attacker can always calculate (but not change) Merkle tree, so this
> > > is not something that need to be hidden.
> > > 
> > > It would allow userspace to easily enumerate trusted DM devices without
> > > calling kernel ioctls...
> > 
> > I guess that's an option if there are scenarios where it is useful. It
> > should probably be a separate patch, since it isn't directly related with
> > extending LoadPin support to trusted verity devices.
> > 
> > > > +
> > > > +	table = dm_get_live_table(md, &srcu_idx);
> > > > +
> > > > +	if (dm_table_get_num_targets(table) != 1)
> > > > +		goto out;
> > > > +
> > > > +	ti = dm_table_get_target(table, 0);
> > > > +
> > > > +	if (is_trusted_verity_target(ti))
> > > > +		trusted = true;
> > > 
> > > What happens is someone reloads verity table later with
> > > a different content (or even different target type)?
> > > Does LoadPin even care here?
> > 
> > LoadPin cares, but only when new kernel files are loaded. It will then check
> > against the new verity table, and only allow loading of the file if it comes
> > from a verity target with a trusted digest.
> > 
> > > >   static struct target_type verity_target = {
> > > >   	.name		= "verity",
> > > >   	.version	= {1, 8, 0},
> > > 
> > > Please increase the minor version, it is very useful to detect (in logs)
> > > that the target driver has compatible extensions.
> > 
> > I can do that, but would like to confirm that this is really needed/desired.
> > This patch adds kernel-internal APIs which aren't accessible to userspace,
> > that don't impact verity directly, so I'm not sure an increased minor version
> > would be useful.
> 
> Bumping to 1.8.1 is useful to indicate new changes that offer expanded
> use of the verity target (even if by LoadPin).

Ok, I'll bump the version, thanks for the confirmation.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

