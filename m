Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60DEEC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 16:53:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-kZ0D92JLMO2ysHXbVLrsHw-1; Fri, 13 May 2022 12:53:11 -0400
X-MC-Unique: kZ0D92JLMO2ysHXbVLrsHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57C45801E80;
	Fri, 13 May 2022 16:53:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 099D5C44CC7;
	Fri, 13 May 2022 16:53:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7AFB193222E;
	Fri, 13 May 2022 16:53:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E2A6F194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 16:53:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B31BA416362; Fri, 13 May 2022 16:53:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AEF66416364
 for <dm-devel@redhat.com>; Fri, 13 May 2022 16:53:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 968863C0D1A5
 for <dm-devel@redhat.com>; Fri, 13 May 2022 16:53:08 +0000 (UTC)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-WSiGf61iPeC-qA40PDMsZA-1; Fri, 13 May 2022 12:53:07 -0400
X-MC-Unique: WSiGf61iPeC-qA40PDMsZA-1
Received: by mail-pg1-f172.google.com with SMTP id g184so8039869pgc.1
 for <dm-devel@redhat.com>; Fri, 13 May 2022 09:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AUV1xEazjWXY63tfW7HNmR3TtmSUkdVdBcreZvOq/Dw=;
 b=NKIo8RbETubV36jnIe64bs8J9NKKpACCFHtfpv3RaRERf5cilegSpx6wkDtsD3oAhc
 X/sbi+aZcx2TPZTmUjc7kfVtJEMkqQc0BzbEI8XTVQPzir06CEUXDSLWZknpkd1ZQPKg
 ro2pDh7XPGXXAC3iCQTVIopgRItyyjcjEvNABYGxrUUio/e5Yb4jg/RSlUmktvnCEZ9i
 G5md6bMHjipuKpK6wly8ZCowiTVo8XI1t6N287tr8tPDavtGQkIf6o//Ngo5wlA1g7id
 kQuJMYy9+oTCw5bDjtjbknaUbXTqnMAZLhTj5t2daz5TeucSrA4rUeujhygdhD02uUoO
 yiLA==
X-Gm-Message-State: AOAM531IyTJomkAov2Aocp2CUZNrgQpn3DQDih2jcfgd68EOQ2eWDwpS
 gxKDDsRU4/afj6K0vnLMAmjljg==
X-Google-Smtp-Source: ABdhPJzNdBdAfqwQ5UdhSPodIDV1E0fccuYbI5UfXF8BRC6dSRC9hAykOcqhvA29DbkdaPcpIwrsyQ==
X-Received: by 2002:a63:5513:0:b0:3c3:7bfa:c3ea with SMTP id
 j19-20020a635513000000b003c37bfac3eamr4648709pgb.243.1652460786017; 
 Fri, 13 May 2022 09:53:06 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:bc87:9632:bcce:8e17])
 by smtp.gmail.com with UTF8SMTPSA id
 u14-20020a170902714e00b00160c970eeb7sm1861475plm.234.2022.05.13.09.53.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 May 2022 09:53:05 -0700 (PDT)
Date: Fri, 13 May 2022 09:53:04 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yn6M8J1lfBpH8rW0@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <YnwioaRiVmYevo8i@google.com> <Yn1BkO4t+CXR0nzk@redhat.com>
 <Yn1xyVmPJGQz31lN@google.com> <Yn6HaVbfBxmmWkvI@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yn6HaVbfBxmmWkvI@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 13, 2022 at 12:29:29PM -0400, Mike Snitzer wrote:
> On Thu, May 12 2022 at  4:44P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > On Thu, May 12, 2022 at 01:19:12PM -0400, Mike Snitzer wrote:
> > > On Wed, May 11 2022 at  4:54P -0400,
> > > Matthias Kaehlcke <mka@chromium.org> wrote:
> > > 
> > > > Alasdar/Mike, I'd be interested in your take on adding these functions
> > > > to verity/DM, to get an idea whether this series has a path forward to
> > > > landing upstream.
> > > 
> > > I'll be reviewing your patchset now. Comments inlined below.
> > > 
> > > > On Wed, May 04, 2022 at 12:54:17PM -0700, Matthias Kaehlcke wrote:
> > > > > LoadPin limits loading of kernel modules, firmware and certain
> > > > > other files to a 'pinned' file system (typically a read-only
> > > > > rootfs). To provide more flexibility LoadPin is being extended
> > > > > to also allow loading these files from trusted dm-verity
> > > > > devices. For that purpose LoadPin can be provided with a list
> > > > > of verity root digests that it should consider as trusted.
> > > > > 
> > > > > Add a bunch of helpers to allow LoadPin to check whether a DM
> > > > > device is a trusted verity device. The new functions broadly
> > > > > fall in two categories: those that need access to verity
> > > > > internals (like the root digest), and the 'glue' between
> > > > > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > > > > the glue functions.
> > > > > 
> > > > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > > > ---
> > > > > 
> > > > > Changes in v3:
> > > > > - none
> > > > > 
> > > > > Changes in v2:
> > > > > - none
> > > > > 
> > > > >  drivers/md/Makefile               |  6 +++
> > > > >  drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
> > > > >  drivers/md/dm-verity-target.c     | 33 +++++++++++++
> > > > >  drivers/md/dm-verity.h            |  4 ++
> > > > >  include/linux/dm-verity-loadpin.h | 27 +++++++++++
> > > > >  5 files changed, 150 insertions(+)
> > > > >  create mode 100644 drivers/md/dm-verity-loadpin.c
> > > > >  create mode 100644 include/linux/dm-verity-loadpin.h
> > > > > 
> > > > > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > > > > index 0454b0885b01..e12cd004d375 100644
> > > > > --- a/drivers/md/Makefile
> > > > > +++ b/drivers/md/Makefile
> > > > > @@ -100,6 +100,12 @@ ifeq ($(CONFIG_IMA),y)
> > > > >  dm-mod-objs			+= dm-ima.o
> > > > >  endif
> > > > >  
> > > > > +ifeq ($(CONFIG_DM_VERITY),y)
> > > > > +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> > > > > +dm-mod-objs			+= dm-verity-loadpin.o
> > > > > +endif
> > > > > +endif
> > > > > +
> > > 
> > > Why are you extending dm-mod-objs?  Why not dm-verity-objs?
> > 
> > Sorry, I missed to address this comment in my earlier reply.
> > 
> > I don't recall why I chose dm-mod-objs initially, agreed that
> > dm-verity-objs seems a better fit.
> 
> Yes, should be fixed even though the 3rd patch removes this change.

Sure

> BTW, looking at the 2nd patch's loadpin_is_fs_trusted().  Seems to me
> you'd do well to pass a 'struct block_device *' to a DM helper rather
> than force security/loadpin/loadpin.c to mess around with DM device
> refcounting, etc.

Sounds good to me. Thanks for the suggestion!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

