Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6EAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 21 Dec 2021 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640077892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6NoPEklZM1P6VAdBFqR+3gjwNI0cFxavWE3rNQB7iFc=;
	b=XKwYZ0Mcijv6PK52nzgOEnQveWoi6av1rqD+MRWDKTbR++8CzKL57lwVAxCYW67qH1vGsY
	ffiiasBEIepLrooxVHWnnkOHltfeJHqS5X1Xw5qBzcOA/kAu/SDzEgb49X/9p2yUiuktjp
	cw7FTbzpPYC0nfSlZcxQJOAR18Al5Y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-zhlZNnbZOQmNBJHiu_mhIA-1; Tue, 21 Dec 2021 04:11:26 -0500
X-MC-Unique: zhlZNnbZOQmNBJHiu_mhIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C01E1006AA7;
	Tue, 21 Dec 2021 09:11:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B12260C25;
	Tue, 21 Dec 2021 09:11:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72BC21809CB8;
	Tue, 21 Dec 2021 09:11:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BKL8Mgl031321 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 20 Dec 2021 16:08:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 38705794A3; Mon, 20 Dec 2021 21:08:22 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.2.14.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4D7879455;
	Mon, 20 Dec 2021 21:07:36 +0000 (UTC)
Date: Mon, 20 Dec 2021 16:07:34 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20211220210734.GW1550715@madcap2.tricolour.ca>
References: <163469252421.3058604.4246950335082826987.stgit@olly>
	<CAHC9VhRg=2yPdVMcCmP9=++jHtHWP7t3S9dhKj9QFjpFyKvCjw@mail.gmail.com>
	<CAHC9VhRFwSL99a3DNr5-6vKgD4w1YCvoVXZr9X=oAhhA6Zb5FQ@mail.gmail.com>
	<YXm9Td5kTuMChvH3@redhat.com>
	<CAHC9VhS2HJkWhtp-hNo=18BjSTXy22Lj5LEK2yFEQmC8TpkStw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhS2HJkWhtp-hNo=18BjSTXy22Lj5LEK2yFEQmC8TpkStw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 21 Dec 2021 04:11:06 -0500
Cc: dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021-10-27 17:21, Paul Moore wrote:
> On Wed, Oct 27, 2021 at 4:57 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > On Tue, Oct 26 2021 at 10:22P -0400,
> > Paul Moore <paul@paul-moore.com> wrote:
> >
> > > On Tue, Oct 19, 2021 at 9:17 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Tue, Oct 19, 2021 at 9:15 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > >
> > > > > Due to conflict with the audit and SELinux trees the device mapper
> > > > > audit record types need to be renumbered before landing in Linus'
> > > > > tree.
> > > > >
> > > > > Link: https://lore.kernel.org/lkml/CAHC9VhTLmzDQPqsj+vyBNua1X13UK_tTcixKZ7WWYEqMXVOXdQ@mail.gmail.com/
> > > > > Fixes: c1d7fa96e74b ("dm: introduce audit event module for device mapper")
> > > > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > > > ---
> > > > >  include/uapi/linux/audit.h |    4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > Alasdair or Mike, please merge this into the device-mapper tree before
> > > > you send it to Linus during the upcoming merge window.
> > >
> > > Please merge this fix into the device-mapper tree to fix a patch in
> > > the for-next branch, otherwise there is a chance for breakage due to
> > > potentially botched merges during the upcoming merge window.
> >
> > I fixed it up.. via rebase, so we should be all set.
> 
> Great, thanks Mike.

The code got updated, which is the important part, but the description
didn't.  :-/

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

