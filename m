Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80661C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 20:45:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-D3YcC1yLMQqPTxReO14BVg-1; Thu, 12 May 2022 16:45:34 -0400
X-MC-Unique: D3YcC1yLMQqPTxReO14BVg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A0BC1066543;
	Thu, 12 May 2022 20:45:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 502CA454A70;
	Thu, 12 May 2022 20:45:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D3561947058;
	Thu, 12 May 2022 20:45:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69F89194704A
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 May 2022 20:45:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 06489200C0F4; Thu, 12 May 2022 20:45:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3E502024CB9
 for <dm-devel@redhat.com>; Thu, 12 May 2022 20:45:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56A80811E75
 for <dm-devel@redhat.com>; Thu, 12 May 2022 20:45:02 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-U0C8lXr-O_W1qBVr27Kbmw-1; Thu, 12 May 2022 16:45:00 -0400
X-MC-Unique: U0C8lXr-O_W1qBVr27Kbmw-1
Received: by mail-pj1-f52.google.com with SMTP id fv2so6260074pjb.4
 for <dm-devel@redhat.com>; Thu, 12 May 2022 13:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mfDd2mUqrFJnPjYIAGb7iTHqp7/V/kqIzmO4Ik5ICtE=;
 b=DCMQ3lA8GBskQPooG1GTRHj6Wp+aUrU4J7VPEESFpwBagagP6mUqmsmTiSBGcDDr8o
 jKbmVurwhqfEMLcV6kuGpTEig2UIeaVoKsTBS7JtqApRtY1gn5WycT/y0AxpmWlh+uPk
 kYHGQcmQdloG3VdmPgUd5xiIFwS+8evvyU6do+sQE79TUjNeOlHAUqDq/AOwKOtEvMTr
 4USygTZZmrsVjTGKLmjIg588ykxahWVPUpImPjDxDESKoP7kL8apZIRzrEYBMgtfSXJT
 ljjiT0D/kSDgB4gN6YDC9P9Oq793YNAmoD4ZrO2JONhVOtOz6FB58guTySfosE14so/c
 bGjQ==
X-Gm-Message-State: AOAM531C2NwJmSONW/IGTNUdr7XG18mi9BWdhF8Yh9kCSF/ZcuFdkUz5
 1z4AM2bN5fILeuioS07qrhs+5A==
X-Google-Smtp-Source: ABdhPJweC1XGidiP3A3Cg1L4P+c7vLixuIQHOEhEEVMPX3OSorgSxCxtYRx8oqG/gfH5ctvhV02/CQ==
X-Received: by 2002:a17:902:ed52:b0:15e:c71f:72c8 with SMTP id
 y18-20020a170902ed5200b0015ec71f72c8mr1599550plb.38.1652388299601; 
 Thu, 12 May 2022 13:44:59 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:4060:29b:ac8a:c726])
 by smtp.gmail.com with UTF8SMTPSA id
 i9-20020aa79089000000b0050dc76281e4sm223297pfa.190.2022.05.12.13.44.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 12 May 2022 13:44:59 -0700 (PDT)
Date: Thu, 12 May 2022 13:44:57 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yn1xyVmPJGQz31lN@google.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On Thu, May 12, 2022 at 01:19:12PM -0400, Mike Snitzer wrote:
> On Wed, May 11 2022 at  4:54P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > Alasdar/Mike, I'd be interested in your take on adding these functions
> > to verity/DM, to get an idea whether this series has a path forward to
> > landing upstream.
> 
> I'll be reviewing your patchset now. Comments inlined below.
> 
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

Sorry, I missed to address this comment in my earlier reply.

I don't recall why I chose dm-mod-objs initially, agreed that
dm-verity-objs seems a better fit.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

