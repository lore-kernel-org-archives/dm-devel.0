Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B91C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652459381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YPA9pelVxgN26zksDXh/6IKYJijjgS9QOTDCpOSvMgM=;
	b=aMLN8VZLufS+5XEWMaZvkAI8cYCcuJZZPA426Phf0KFUqKVG76h7+aDVUJXiYIVhbuzXBL
	cHZvnbYgn+7f7Ic7z9dLelk7/MgB5sDB1b9JApCeLOMaAt568NjH/eTEEbx9IhM3DfAMDu
	f8eYJDXOiwz9zhlhfvjmcmjavXdI/xU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-jucZikXbMYGGfcwmEbdvvQ-1; Fri, 13 May 2022 12:29:39 -0400
X-MC-Unique: jucZikXbMYGGfcwmEbdvvQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EBC81C05AC9;
	Fri, 13 May 2022 16:29:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5025540D2820;
	Fri, 13 May 2022 16:29:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F27F3193222E;
	Fri, 13 May 2022 16:29:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50114194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 16:29:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1CFC81469387; Fri, 13 May 2022 16:29:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 190731469380
 for <dm-devel@redhat.com>; Fri, 13 May 2022 16:29:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 002AC801E80
 for <dm-devel@redhat.com>; Fri, 13 May 2022 16:29:32 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-FenJJu9WM0iJIqPIiIYcOw-1; Fri, 13 May 2022 12:29:31 -0400
X-MC-Unique: FenJJu9WM0iJIqPIiIYcOw-1
Received: by mail-qk1-f198.google.com with SMTP id
 q5-20020a05620a0d8500b004738c1b48beso6715489qkl.7
 for <dm-devel@redhat.com>; Fri, 13 May 2022 09:29:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wPAv5hHS+2+NL1LWGdNroHEvnnxHLkPkD7FQQ5EMMCs=;
 b=JoKm+LiM8Vl7ZBLXwrQ3XpWJHtJ+9iHXV7xRJKzLz07JpUtKdywIvABQYA7B3Undw5
 daPRgOKOW2RnKxjLcCHPoHXzpVlqzkEFVsrGK13qmCJJbGMkdrldh74S37GEOS1vjIfw
 JH09qqkIeNcMISP+pI5xxlc3h1WtGLReRWOmU3pB81+xwPAA/aYHWSCELCS/uF+PBlpj
 YXiHvARdZf4nzuayw2WqUwtinbVteDUyQmGF0kTK+470sxO5NGrVypf1B6Uf7gWOHRrC
 95Au9jr//SD6r3eJVWbo26qGFLzrlDH/mXdKjgpPBmYhW8xZ7leCMnCkXkRPpT4IT40/
 Tpqg==
X-Gm-Message-State: AOAM532WBvxi5a+UeGPFKzNZglZygvOgcN7jivOK/bdfPrdJkkKBvtfO
 2R9l2sRp/00pvggKH0rizAs13nxTzkGx9KumIHUxyWJUwzv3a1NTG0KgxvvZTqZCNTOiYsHIfst
 yWQb0jLJq5UbzCw==
X-Received: by 2002:a05:6214:2ae:b0:456:31d0:c934 with SMTP id
 m14-20020a05621402ae00b0045631d0c934mr5145346qvv.45.1652459371285; 
 Fri, 13 May 2022 09:29:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz51XOenaZG7oKBy9PprOx68Yse9jbiQoQlGc2RkO/uD1HBYQRnWq6eYh+w1GgNkbSjWQk3Hw==
X-Received: by 2002:a05:6214:2ae:b0:456:31d0:c934 with SMTP id
 m14-20020a05621402ae00b0045631d0c934mr5145333qvv.45.1652459371092; 
 Fri, 13 May 2022 09:29:31 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 z4-20020ac875c4000000b002f39b99f6adsm1676208qtq.71.2022.05.13.09.29.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 13 May 2022 09:29:30 -0700 (PDT)
Date: Fri, 13 May 2022 12:29:29 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <Yn6HaVbfBxmmWkvI@redhat.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <YnwioaRiVmYevo8i@google.com> <Yn1BkO4t+CXR0nzk@redhat.com>
 <Yn1xyVmPJGQz31lN@google.com>
MIME-Version: 1.0
In-Reply-To: <Yn1xyVmPJGQz31lN@google.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 12 2022 at  4:44P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> On Thu, May 12, 2022 at 01:19:12PM -0400, Mike Snitzer wrote:
> > On Wed, May 11 2022 at  4:54P -0400,
> > Matthias Kaehlcke <mka@chromium.org> wrote:
> > 
> > > Alasdar/Mike, I'd be interested in your take on adding these functions
> > > to verity/DM, to get an idea whether this series has a path forward to
> > > landing upstream.
> > 
> > I'll be reviewing your patchset now. Comments inlined below.
> > 
> > > On Wed, May 04, 2022 at 12:54:17PM -0700, Matthias Kaehlcke wrote:
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
> > > > ---
> > > > 
> > > > Changes in v3:
> > > > - none
> > > > 
> > > > Changes in v2:
> > > > - none
> > > > 
> > > >  drivers/md/Makefile               |  6 +++
> > > >  drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
> > > >  drivers/md/dm-verity-target.c     | 33 +++++++++++++
> > > >  drivers/md/dm-verity.h            |  4 ++
> > > >  include/linux/dm-verity-loadpin.h | 27 +++++++++++
> > > >  5 files changed, 150 insertions(+)
> > > >  create mode 100644 drivers/md/dm-verity-loadpin.c
> > > >  create mode 100644 include/linux/dm-verity-loadpin.h
> > > > 
> > > > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > > > index 0454b0885b01..e12cd004d375 100644
> > > > --- a/drivers/md/Makefile
> > > > +++ b/drivers/md/Makefile
> > > > @@ -100,6 +100,12 @@ ifeq ($(CONFIG_IMA),y)
> > > >  dm-mod-objs			+= dm-ima.o
> > > >  endif
> > > >  
> > > > +ifeq ($(CONFIG_DM_VERITY),y)
> > > > +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> > > > +dm-mod-objs			+= dm-verity-loadpin.o
> > > > +endif
> > > > +endif
> > > > +
> > 
> > Why are you extending dm-mod-objs?  Why not dm-verity-objs?
> 
> Sorry, I missed to address this comment in my earlier reply.
> 
> I don't recall why I chose dm-mod-objs initially, agreed that
> dm-verity-objs seems a better fit.

Yes, should be fixed even though the 3rd patch removes this change.

BTW, looking at the 2nd patch's loadpin_is_fs_trusted().  Seems to me
you'd do well to pass a 'struct block_device *' to a DM helper rather
than force security/loadpin/loadpin.c to mess around with DM device
refcounting, etc.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

