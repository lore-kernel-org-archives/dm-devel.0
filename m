Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51323C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 14:37:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-gmMzOf9BMjGa3yAwPl34SA-1; Wed, 15 Jun 2022 10:37:47 -0400
X-MC-Unique: gmMzOf9BMjGa3yAwPl34SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 391E43C0F731;
	Wed, 15 Jun 2022 14:37:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1F7A2026D07;
	Wed, 15 Jun 2022 14:37:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 958161947040;
	Wed, 15 Jun 2022 14:37:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D4DE119466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 14:36:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BCB540C141F; Wed, 15 Jun 2022 14:36:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9781C4010E4D
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 14:36:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E8F8802D1C
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 14:36:48 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-fD8Iv0MdNCihS0os4_u1-Q-1; Wed, 15 Jun 2022 10:36:46 -0400
X-MC-Unique: fD8Iv0MdNCihS0os4_u1-Q-1
Received: by mail-pj1-f48.google.com with SMTP id
 g10-20020a17090a708a00b001ea8aadd42bso2277458pjk.0
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 07:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to;
 bh=vttPuOhvTXbiLEEhPovlRRfss5Fl6l3AC5Df+QtEYl0=;
 b=FvWSaWL8a4JmTBtxbONsHp97vYmdzASRzPj7NEDphnKm8510YLzwBzkcfehEccGxDy
 IYzuMSJKE7r/FUXE6JmUps5PZzwqFt9g6HEq+7d+04R2jrPHzF8m/0AKlbhB2u2SKhji
 YLfaMfTybfUn+QeuIFA2Y1IOHjjuCDfAngk/Y3LR498Z0ywa2IWdVMqq+nr3yiLXOEKr
 VSLqz49g/rrs5h6Hp8ih6Gfdxw0L9XZHd3d+0BdTNytbBAyldAq4j85kggtmAcg2hgAL
 QiNTsEBxG+KMI8fyBOgf9IGK/rMXkG3voix3+kz412z3rN1YtP6netxuh/ZEX+80lvXu
 6wIA==
X-Gm-Message-State: AJIora9lfqpotLSVWQVVUpdE9qFRyHYcSsXFxNEiaolhAD/cJ0G8TUCy
 w/7F/VEqke+J515LS4mBwek=
X-Google-Smtp-Source: AGRyM1vIm4gzXJ/NN8VDQYgmf13YxaBHhPpLOyInhdNWbwcC/B2THPrqwJu3gsxJg1yjhnlgnMkzVg==
X-Received: by 2002:a17:90b:2251:b0:1e6:76a8:44f3 with SMTP id
 hk17-20020a17090b225100b001e676a844f3mr10778425pjb.71.1655303805360; 
 Wed, 15 Jun 2022 07:36:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 q2-20020a170902f78200b00164ade949adsm9482353pln.79.2022.06.15.07.36.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Jun 2022 07:36:43 -0700 (PDT)
Date: Wed, 15 Jun 2022 07:36:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20220615143642.GA2386944@roeck-us.net>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com> <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
MIME-Version: 1.0
In-Reply-To: <Yqb/sT205Lrhl6Bv@kroah.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
 Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
 regressions@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > On Fri, Jun 10 2022 at  1:15P -0400,
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > I believe this commit introduced a regression in dm verity on systems
> > > > where data device is an NVME one. Loading table fails with the
> > > > following diagnostics:
> > > > 
> > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > 
> > > > The same kernel works with the same data drive on the SCSI interface.
> > > > NVME-backed dm verity works with just this commit reverted.
> > > > 
> > > > I believe the presence of the immutable partition is used as an indicator
> > > > of special case NVME configuration and if the data device's name starts
> > > > with "nvme" the code tries to switch the target type to
> > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > 
> > > > The special NVME optimization case was removed in
> > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > affected.
> > > > 
> > > 
> > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > have you tested this and verified that it worked?
> > 
> > Sorry for the unforeseen stable@ troubles here!
> > 
> > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > properly would require also making sure commits that remove
> > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > be removed.
> > 
> > The commit header for 8d47e65948dd documents what
> > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > "nvme" mode really never got used by any userspace that I'm aware of.
> > 
> > Sadly I currently don't have the time to do this backport for all N
> > stable kernels... :(
> > 
> > But if that backport gets out of control: A simpler, albeit stable@
> > unicorn, way to resolve this is to simply revert 9c37de297f65 and make

9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
and trying to apply it results in conflicts which at least I can not
resolve.

> > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > 
> > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > 
> >                         if (!strcasecmp(queue_mode_name, "bio"))
> >                                 m->queue_mode = DM_TYPE_BIO_BASED;
> > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> >                         else if (!strcasecmp(queue_mode_name, "rq"))
> >                                 m->queue_mode = DM_TYPE_REQUEST_BASED;
> >                         else if (!strcasecmp(queue_mode_name, "mq"))
> > 
> > Mike
> > 
> 
> Ok, please submit a working patch for the kernels that need it so that
> we can review and apply it to solve this regression.
> 

So, effectively, v5.4.y and older are broken right now for use cases
with dm on NVME drives.

Given that the regression does affect older branches, and given that we
have to revert this patch to avoid regressions in ChromeOS, would it be
possible to revert it from v5.4.y and older until a fix is found ?

Thanks,
Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

