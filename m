Return-Path: <SRS0=m4z6=PO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD10C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 26 Oct 2021 14:32:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91D5E60E08
	for <dm-devel@archiver.kernel.org>; Tue, 26 Oct 2021 14:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 91D5E60E08
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-S9EYxNakP8CAcwJaktEAwQ-1; Tue, 26 Oct 2021 10:32:29 -0400
X-MC-Unique: S9EYxNakP8CAcwJaktEAwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF4F2100C63C;
	Tue, 26 Oct 2021 14:30:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50B2D19D9D;
	Tue, 26 Oct 2021 14:30:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7FBB44A704;
	Tue, 26 Oct 2021 14:30:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19QEPFfI030674 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Oct 2021 10:25:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B06AB2166B25; Tue, 26 Oct 2021 14:25:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A924B2166B26
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 14:25:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7647C185A79C
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 14:25:11 +0000 (UTC)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
	[209.85.208.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-353-njOk7y7sOJ-sKD2TVwppEw-1; Tue, 26 Oct 2021 10:25:09 -0400
X-MC-Unique: njOk7y7sOJ-sKD2TVwppEw-1
Received: by mail-ed1-f52.google.com with SMTP id w15so14342287edc.9
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 07:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=lTfpCF5s/ni+O/MZxt+c+qhmcQc/RHz3dQFkcuVsHy4=;
	b=OO8sBAd+tcYwYkCtcrXQ651p9EKKGb2O9GSJHpd9+ZatFZAWl0LOyHvZB7D7Ix7L/y
	kwOqyj99IKB5qIRjUoP3YujCIpAZvbJrDN5Q3h4k9m1QoQEEDDIzdpD6SH2zea2x37qH
	bX0hXGJEApXuMu0iFGJWDYN4d1FqR1Q+jMbBSQDKO0Rj7NyE2HLdIwkQblB0JQM+JlWc
	1Suwy23p92Imgse9MhkGzyBQYh5vmB2ZY9Wyb0swxJdOSvO/eRa2JKc9iVb5/tlEQ6X2
	gM6V7c7zohfwbRRGjQyTSATiljLGcPwup8mOir5FzeLvVfKJTIR6hwH6SZHE/SsMuV1T
	Lt9A==
X-Gm-Message-State: AOAM533SznEXRo9YCvgsIHIeMWucWDPcR1T1HRZQBtu3QRZib7n/TtE2
	ube3TtlquG1q1jg5+hXJd0S0+aYx9f6CmMEN3k38
X-Google-Smtp-Source: ABdhPJzCgPp4/VMfnx4GxEC8VPbydkcnpoTs0MTTTig888FSIMsSxLgFT5AUqLvinrh7AvG884FgkNA+LTLsGhURmTI=
X-Received: by 2002:a05:6402:35d6:: with SMTP id
	z22mr27070530edc.93.1635258183369; 
	Tue, 26 Oct 2021 07:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <163469252421.3058604.4246950335082826987.stgit@olly>
	<CAHC9VhRg=2yPdVMcCmP9=++jHtHWP7t3S9dhKj9QFjpFyKvCjw@mail.gmail.com>
In-Reply-To: <CAHC9VhRg=2yPdVMcCmP9=++jHtHWP7t3S9dhKj9QFjpFyKvCjw@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 26 Oct 2021 10:22:52 -0400
Message-ID: <CAHC9VhRFwSL99a3DNr5-6vKgD4w1YCvoVXZr9X=oAhhA6Zb5FQ@mail.gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, linux-audit@redhat.com
Subject: Re: [dm-devel] [PATCH] audit: correct the AUDIT_DM_CTRL and
	AUDIT_DM_EVENT numbering
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 19, 2021 at 9:17 PM Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Oct 19, 2021 at 9:15 PM Paul Moore <paul@paul-moore.com> wrote:
> >
> > Due to conflict with the audit and SELinux trees the device mapper
> > audit record types need to be renumbered before landing in Linus'
> > tree.
> >
> > Link: https://lore.kernel.org/lkml/CAHC9VhTLmzDQPqsj+vyBNua1X13UK_tTcixKZ7WWYEqMXVOXdQ@mail.gmail.com/
> > Fixes: c1d7fa96e74b ("dm: introduce audit event module for device mapper")
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > ---
> >  include/uapi/linux/audit.h |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Alasdair or Mike, please merge this into the device-mapper tree before
> you send it to Linus during the upcoming merge window.

Please merge this fix into the device-mapper tree to fix a patch in
the for-next branch, otherwise there is a chance for breakage due to
potentially botched merges during the upcoming merge window.

> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 6650ab6def2a..809e4c2041b3 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -118,8 +118,8 @@
> >  #define AUDIT_TIME_ADJNTPVAL   1333    /* NTP value adjustment */
> >  #define AUDIT_BPF              1334    /* BPF subsystem */
> >  #define AUDIT_EVENT_LISTENER   1335    /* Task joined multicast read socket */
> > -#define AUDIT_DM_CTRL          1336    /* Device Mapper target control */
> > -#define AUDIT_DM_EVENT         1337    /* Device Mapper events */
> > +#define AUDIT_DM_CTRL          1338    /* Device Mapper target control */
> > +#define AUDIT_DM_EVENT         1339    /* Device Mapper events */
> >
> >  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant */
> >  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

