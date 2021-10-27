Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BC4C43217
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 21:22:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A92B60231
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 21:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A92B60231
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-zT3qEbb9NjeZgv4smvu-6A-1; Wed, 27 Oct 2021 17:22:11 -0400
X-MC-Unique: zT3qEbb9NjeZgv4smvu-6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93F18107B27B;
	Wed, 27 Oct 2021 21:21:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 438B35C1B4;
	Wed, 27 Oct 2021 21:21:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A8B4C4E58F;
	Wed, 27 Oct 2021 21:21:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19RLLvQL007021 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 17:21:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E5D0E2166B2D; Wed, 27 Oct 2021 21:21:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E04FE2166B25
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 21:21:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0C8A8032F3
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 21:21:53 +0000 (UTC)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
	[209.85.208.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-422-orJvJmFTOXmBp6xUCXjQmw-1; Wed, 27 Oct 2021 17:21:52 -0400
X-MC-Unique: orJvJmFTOXmBp6xUCXjQmw-1
Received: by mail-ed1-f50.google.com with SMTP id z20so16140245edc.13
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 14:21:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=apQAwOGZAt/GwmZyPj3Eh+TVBlz87gtsrZRi77hW+n0=;
	b=hFXKCHYn/xthO3B4RXrH+BkqQlX39Ay2eqUSh7tThR3UUwRS2zv0/rtHb8/f9CEFLn
	JQoMY1S+mcduDTvIqT7g6L+3RC0znfD5JdzfLzEKjXt4i9WOS2MeigmCusHcha3LDLeR
	SGMqRT/eSxn174GpHMSysxca7wyN7j0lyAQXaLuyvDViPjY4FdOodFPDy3GMAv9mRqkf
	58RvVBMjmWQ0EC5O+Bh5b4gKlRM+V3Mfg6HVaLD2eoJFXfml5PBJSLap23Ot6UoGCY07
	qB/bad+JI9ENqWVXJemBTBMWQRKzxhHIEnTcPAX9i9icBFfd6ozI6TmX3AFw8CR3xtGa
	8yeQ==
X-Gm-Message-State: AOAM530lQm4GqQfTrZC3YMTT/VB12RnYug41LDUIyFlSA+84SjwJu9VD
	xUh3i0hqvev3JekzQ7q4WsphG0RPLe+xMGf8I/UO
X-Google-Smtp-Source: ABdhPJxhCzQu06AWRcLmxGV47hp1/91vwp1vAn8fh8jl0oK5r+dDz2ZpdmFCzpZv3hbQqXwWtPcFlzLrXpnYd7oXyu0=
X-Received: by 2002:a17:906:6592:: with SMTP id
	x18mr27144ejn.307.1635369710949; 
	Wed, 27 Oct 2021 14:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <163469252421.3058604.4246950335082826987.stgit@olly>
	<CAHC9VhRg=2yPdVMcCmP9=++jHtHWP7t3S9dhKj9QFjpFyKvCjw@mail.gmail.com>
	<CAHC9VhRFwSL99a3DNr5-6vKgD4w1YCvoVXZr9X=oAhhA6Zb5FQ@mail.gmail.com>
	<YXm9Td5kTuMChvH3@redhat.com>
In-Reply-To: <YXm9Td5kTuMChvH3@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 27 Oct 2021 17:21:40 -0400
Message-ID: <CAHC9VhS2HJkWhtp-hNo=18BjSTXy22Lj5LEK2yFEQmC8TpkStw@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] audit: correct the AUDIT_DM_CTRL and AUDIT_DM_EVENT
	numbering
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 27, 2021 at 4:57 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Tue, Oct 26 2021 at 10:22P -0400,
> Paul Moore <paul@paul-moore.com> wrote:
>
> > On Tue, Oct 19, 2021 at 9:17 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Tue, Oct 19, 2021 at 9:15 PM Paul Moore <paul@paul-moore.com> wrote:
> > > >
> > > > Due to conflict with the audit and SELinux trees the device mapper
> > > > audit record types need to be renumbered before landing in Linus'
> > > > tree.
> > > >
> > > > Link: https://lore.kernel.org/lkml/CAHC9VhTLmzDQPqsj+vyBNua1X13UK_tTcixKZ7WWYEqMXVOXdQ@mail.gmail.com/
> > > > Fixes: c1d7fa96e74b ("dm: introduce audit event module for device mapper")
> > > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > > ---
> > > >  include/uapi/linux/audit.h |    4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > Alasdair or Mike, please merge this into the device-mapper tree before
> > > you send it to Linus during the upcoming merge window.
> >
> > Please merge this fix into the device-mapper tree to fix a patch in
> > the for-next branch, otherwise there is a chance for breakage due to
> > potentially botched merges during the upcoming merge window.
>
> I fixed it up.. via rebase, so we should be all set.

Great, thanks Mike.

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

