Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDCEC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 02:14:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6311222515
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 02:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6311222515
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200--5bmvrurONid7yeqw7rZ_Q-1; Mon, 04 Jan 2021 21:13:58 -0500
X-MC-Unique: -5bmvrurONid7yeqw7rZ_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D05B61800D41;
	Tue,  5 Jan 2021 02:13:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B1991001E73;
	Tue,  5 Jan 2021 02:13:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6A89180954D;
	Tue,  5 Jan 2021 02:13:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1052Dlgu030740 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 21:13:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 996F92166B2D; Tue,  5 Jan 2021 02:13:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94B972166B2A
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 02:13:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03321811E78
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 02:13:45 +0000 (UTC)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com
	[209.85.218.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-375-bmoWbjdYPbaRz97kyb5KUg-1; Mon, 04 Jan 2021 21:13:43 -0500
X-MC-Unique: bmoWbjdYPbaRz97kyb5KUg-1
Received: by mail-ej1-f41.google.com with SMTP id jx16so39300100ejb.10
	for <dm-devel@redhat.com>; Mon, 04 Jan 2021 18:13:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=qvV6FEczLH+8PfasNVXOCqdhthLBl7usYa45FALYpbY=;
	b=lPjuR0r3dgfU9TdPVnXqOR1qs9U6JLUJf3eKF21fa6tf9tHrMvsZbgXtxCXpbkOX4G
	vj8m3IK/jTSxTLymA9dTAZp2VWhI98HexIJxiYLbUer4pzBFEGtY1KBEaOHJrVJ2286P
	QOYW1fWrS6n8ljwPoupSMZ4FwypFtkmPLTjF9AssV9Cqw9HqAZqTHmYFwJP2srMWK3NB
	JXtx8/GfxuDuFz+ECW4znVDhMi6MFPL9D29uIM3agMoVPxkK5sy6vEHYW6LxjIWtFBAA
	8jncY4n0BLaAAaqqAHYrBqEA1hucxcEQZhlnCjLyV1awkgucg3YbXEmlPpXZ9Ey3RQ92
	pfqQ==
X-Gm-Message-State: AOAM531wwRNZQEr+QJjXelC3W41sjFgcQDaSJoS9fnkQj9lAjnyxVcPL
	ZUwDikZg81hyy52x41gsjgChHiNESIgIY7L9fRkM
X-Google-Smtp-Source: ABdhPJxgesvJvYIYjYXGI+ZNhOx8UyNLaM5OHTy3tIzCiNoBdqeOCTECBZdd3nkbSmgO657ZMh+Tl7Fz4T89S+WR1R0=
X-Received: by 2002:a17:907:4126:: with SMTP id
	mx6mr67633339ejb.91.1609812821733; 
	Mon, 04 Jan 2021 18:13:41 -0800 (PST)
MIME-Version: 1.0
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSao7DGtskbDMax8hN+PhQr8homFXUGjm+c7NtEUCtKhg@mail.gmail.com>
	<2dce2244-adbd-df2a-e890-271bbcc8f9f2@linux.microsoft.com>
In-Reply-To: <2dce2244-adbd-df2a-e890-271bbcc8f9f2@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 4 Jan 2021 21:13:30 -0500
Message-ID: <CAHC9VhQ8H+UCnLTJ4Mb=GHCdExGvVEB_+nbK+-keMVie-tnbnQ@mail.gmail.com>
To: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, snitzer@redhat.com,
	selinux@vger.kernel.org, Stephen Smalley <stephen.smalley.work@gmail.com>,
	James Morris <jmorris@namei.org>, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, tyhicks@linux.microsoft.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v9 8/8] selinux: include a consumer of the
 new IMA critical data hook
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 4, 2021 at 6:30 PM Lakshmi Ramasubramanian
<nramas@linux.microsoft.com> wrote:
> On 12/23/20 1:10 PM, Paul Moore wrote:
> Hi Paul,

Hello.

> >> diff --git a/security/selinux/measure.c b/security/selinux/measure.c
> >> new file mode 100644
> >> index 000000000000..b7e24358e11d
> >> --- /dev/null
> >> +++ b/security/selinux/measure.c
> >> @@ -0,0 +1,79 @@
> >> +// SPDX-License-Identifier: GPL-2.0-or-later
> >> +/*
> >> + * Measure SELinux state using IMA subsystem.
> >> + */
> >> +#include <linux/vmalloc.h>
> >> +#include <linux/ktime.h>
> >> +#include <linux/ima.h>
> >> +#include "security.h"
> >> +
> >> +/*
> >> + * This function creates a unique name by appending the timestamp to
> >> + * the given string. This string is passed as "event_name" to the IMA
> >> + * hook to measure the given SELinux data.
> >> + *
> >> + * The data provided by SELinux to the IMA subsystem for measuring may have
> >> + * already been measured (for instance the same state existed earlier).
> >> + * But for SELinux the current data represents a state change and hence
> >> + * needs to be measured again. To enable this, pass a unique "event_name"
> >> + * to the IMA hook so that IMA subsystem will always measure the given data.
> >> + *
> >> + * For example,
> >> + * At time T0 SELinux data to be measured is "foo". IMA measures it.
> >> + * At time T1 the data is changed to "bar". IMA measures it.
> >> + * At time T2 the data is changed to "foo" again. IMA will not measure it
> >> + * (since it was already measured) unless the event_name, for instance,
> >> + * is different in this call.
> >> + */
> >> +static char *selinux_event_name(const char *name_prefix)
> >> +{
> >> +       struct timespec64 cur_time;
> >> +
> >> +       ktime_get_real_ts64(&cur_time);
> >> +       return kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
> >> +                        cur_time.tv_sec, cur_time.tv_nsec);
> >> +}
> >
> > Why is this a separate function?  It's three lines long and only
> > called from selinux_measure_state().  Do you ever see the SELinux/IMA
> > code in this file expanding to the point where this function is nice
> > from a reuse standpoint?
>
> Earlier I had two measurements - one for SELinux configuration/state and
> another for SELinux policy. selinux_event_name() was used to generate
> event name for each of them.
>
> In this patch set I have included only one measurement - for SELinux
> policy. I plan to add "SELinux configuration/state" measurement in a
> separate patch - I can reuse selinux_event_name() in that patch.

I'm curious about this second measurement.  My apologies if you posted
it previously, this patchset has gone through several iterations and
simply can't recall all the different versions without digging through
the list archives.

Is there a reason why the second measurement isn't included in this
patch?  Or this patchset if it is too big to be a single patch?

> Also, I think the comment in the function header for
> selinux_event_name() is useful.
>
> I prefer to have a separate function, if that's fine by you.

Given just this patch I would prefer if you folded
selinux_event_name() into selinux_measure_state().  However, I agree
with you that the comments in the selinux_event_name() header block is
useful, I would suggest moving those into the body of
selinux_measure_state() directly above the calls to
ktime_get_real_ts64() and kasprintf().

> > Also, I assume you are not concerned about someone circumventing the
> > IMA measurements by manipulating the time?  In most systems I would
> > expect the time to be a protected entity, but with many systems
> > getting their time from remote systems I thought it was worth
> > mentioning.
>
> I am using time function to generate a unique name for the IMA
> measurement event, such as, "selinux-policy-hash-1609790281:860232824".
> This is to ensure that state changes in SELinux data are always measured.
>
> If you think time manipulation can be an issue, please let me know a
> better way to generate unique event names.

Yes, I understand that you are using the time value as a way of
ensuring you always have a different event name and hence a new
measurement.  However, I was wondering if you would be okay if the
time was adjusted such that an event name was duplicated and a
measurement missed?  Is that a problem for you?  It seems like it
might be an issue, but you and Mimi know IMA better than I do.

> >> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> >> index 9704c8a32303..dfa2e00894ae 100644
> >> --- a/security/selinux/ss/services.c
> >> +++ b/security/selinux/ss/services.c
> >> @@ -3875,8 +3876,33 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
> >>   }
> >>   #endif /* CONFIG_NETLABEL */
> >>
> >> +/**
> >> + * security_read_selinux_policy - read the policy.
> >> + * @policy: SELinux policy
> >> + * @data: binary policy data
> >> + * @len: length of data in bytes
> >> + *
> >> + */
> >> +static int security_read_selinux_policy(struct selinux_policy *policy,
> >> +                                       void *data, size_t *len)
> >
> > Let's just call this "security_read_policy()".
> There is another function in this file with the name security_read_policy().
>
> How about changing the above function name to "read_selinux_policy()"
> since this is a local/static function.

Ooops, sorry about that!  I'm not sure what I was thinking there :)

How about "__security_read_policy()"?

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

