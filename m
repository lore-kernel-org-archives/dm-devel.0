Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB26C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 15:30:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-1UdF3jAnNkuc_TJjiNXo_A-1; Wed, 15 Jun 2022 11:30:51 -0400
X-MC-Unique: 1UdF3jAnNkuc_TJjiNXo_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDF7A8115B0;
	Wed, 15 Jun 2022 15:30:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC11AC08F22;
	Wed, 15 Jun 2022 15:30:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F2891947040;
	Wed, 15 Jun 2022 15:30:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF4A119466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 15:29:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 913872166B29; Wed, 15 Jun 2022 15:29:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CC042166B26
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 15:29:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 710811C0F682
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 15:29:42 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-v9KZShYrOi-hzM3Re5nZ5g-1; Wed, 15 Jun 2022 11:29:38 -0400
X-MC-Unique: v9KZShYrOi-hzM3Re5nZ5g-1
Received: by mail-qv1-f42.google.com with SMTP id b8so3395950qvi.11
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 08:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oOUOcgst0LKLvdZ4y1qA+jD7xbPureSESBaUterAPeQ=;
 b=uJgiMn0coSRmXHPzbYbl4p0CBfw9hbU5mtNLHaiKKfs5vR+lKLP4qigBzRtWeWiYNs
 DYUGLtG+znkappOlEXFAMbZMYXNHwirr8TOSvR4JVZ+U6woBCnf0Z3wOrRTmOiFcc7rv
 2avt7bJMCaGNtREj27oEQl7RKj0NRX4q2SpiTkI4jQCJYjXKL36+8V5/5kCe6ZLa6m6O
 3R98cGks9d/wfo2zl/wHVykm3FPi5qROXG3aJc+nhoi+uAwYzJ4JJyFdqK7c4TEuE7Rs
 P7Gejjt7fdvNeBjwXjBI5G6HscgQLd0McTr7Y2LXd/rbfnzZQRfPR0FN+TiluGxtNGF4
 pg4Q==
X-Gm-Message-State: AJIora/T9fqJL+w2Z4kiJWB6+L8AIHmOU/i+wLYQlkLXb3140d/H3svT
 VvYEabU8e/S9yzzMAQUpfqqp67I=
X-Google-Smtp-Source: AGRyM1udyvePyABL3hVV3lkzQhfydZn0wmJrxJ9zo1e7WcUiTeQdcq2H4C9hLV+9rcwDXfakoleMEg==
X-Received: by 2002:a05:6214:5199:b0:464:58c0:3926 with SMTP id
 kl25-20020a056214519900b0046458c03926mr282092qvb.48.1655306977430; 
 Wed, 15 Jun 2022 08:29:37 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 bk12-20020a05620a1a0c00b006a70f581243sm12307395qkb.93.2022.06.15.08.29.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Jun 2022 08:29:36 -0700 (PDT)
Date: Wed, 15 Jun 2022 11:29:36 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <Yqn64AMwoIzQXwXM@redhat.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com> <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
MIME-Version: 1.0
In-Reply-To: <20220615143642.GA2386944@roeck-us.net>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE
 feature flag
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
Cc: keescook@chromium.org, sarthakkukreti@google.com,
 Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>,
 stable@vger.kernel.org, Oleksandr Tymoshenko <ovt@google.com>,
 dm-devel@redhat.com, regressions@lists.linux.dev
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

On Wed, Jun 15 2022 at 10:36P -0400,
Guenter Roeck <linux@roeck-us.net> wrote:

> On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> > On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > > On Fri, Jun 10 2022 at  1:15P -0400,
> > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > > I believe this commit introduced a regression in dm verity on systems
> > > > > where data device is an NVME one. Loading table fails with the
> > > > > following diagnostics:
> > > > > 
> > > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > > 
> > > > > The same kernel works with the same data drive on the SCSI interface.
> > > > > NVME-backed dm verity works with just this commit reverted.
> > > > > 
> > > > > I believe the presence of the immutable partition is used as an indicator
> > > > > of special case NVME configuration and if the data device's name starts
> > > > > with "nvme" the code tries to switch the target type to
> > > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > > 
> > > > > The special NVME optimization case was removed in
> > > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > > affected.
> > > > > 
> > > > 
> > > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > > have you tested this and verified that it worked?
> > > 
> > > Sorry for the unforeseen stable@ troubles here!
> > > 
> > > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > > properly would require also making sure commits that remove
> > > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > > be removed.
> > > 
> > > The commit header for 8d47e65948dd documents what
> > > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > > "nvme" mode really never got used by any userspace that I'm aware of.
> > > 
> > > Sadly I currently don't have the time to do this backport for all N
> > > stable kernels... :(
> > > 
> > > But if that backport gets out of control: A simpler, albeit stable@
> > > unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> 
> 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
> and trying to apply it results in conflicts which at least I can not
> resolve.
> 
> > > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > > 
> > > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > > 
> > >                         if (!strcasecmp(queue_mode_name, "bio"))
> > >                                 m->queue_mode = DM_TYPE_BIO_BASED;
> > > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> > >                         else if (!strcasecmp(queue_mode_name, "rq"))
> > >                                 m->queue_mode = DM_TYPE_REQUEST_BASED;
> > >                         else if (!strcasecmp(queue_mode_name, "mq"))
> > > 
> > > Mike
> > > 
> > 
> > Ok, please submit a working patch for the kernels that need it so that
> > we can review and apply it to solve this regression.
> > 
> 
> So, effectively, v5.4.y and older are broken right now for use cases
> with dm on NVME drives.
> 
> Given that the regression does affect older branches, and given that we
> have to revert this patch to avoid regressions in ChromeOS, would it be
> possible to revert it from v5.4.y and older until a fix is found ?

I obviously would prefer to not have this false-start.

I'll look at latest 5.4.y _now_ and see what can be done.

Should hopefully be pretty straight-forward.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

