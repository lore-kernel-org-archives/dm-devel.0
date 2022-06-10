Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3784CC43334
	for <dm-devel@archiver.kernel.org>; Fri, 10 Jun 2022 15:11:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-6qO79Bu0MXaLiMs6Jp-4lw-1; Fri, 10 Jun 2022 11:11:16 -0400
X-MC-Unique: 6qO79Bu0MXaLiMs6Jp-4lw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 026E63C01C0C;
	Fri, 10 Jun 2022 15:11:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 323D0492C3B;
	Fri, 10 Jun 2022 15:11:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ED81A194704C;
	Fri, 10 Jun 2022 15:11:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0A8719466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Jun 2022 15:11:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7E0C492C3B; Fri, 10 Jun 2022 15:11:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3EDC492CA3
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 15:11:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 948D9801E6B
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 15:11:09 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-dT6gRiXGNT-3P7PZToctxA-1; Fri, 10 Jun 2022 11:11:02 -0400
X-MC-Unique: dT6gRiXGNT-3P7PZToctxA-1
Received: by mail-qv1-f47.google.com with SMTP id q104so2594150qvq.8
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 08:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sKXGAog39LKZY4WYCXDbeAfVjBlfuLt1RyciOfygwXU=;
 b=gkPCZH8Nz8DkEnLykEp6S7slfr5GrK0ZhPqPF4XqfrURHfjhL/wXw7qDoY90Li+FVt
 VPfDmctydDHCcRkyD9Atk/W0wTPawL/XH0zSosodLQ4jilk03xOT+Mc2ceeDuDTdqGBZ
 JgAsnXbGOFSi1Fm57RJK6CAaSZw+GXKK3D3DW38fLMaSLUInCBtJ4egzkm/nc3rvALr/
 Vmi6xP/ZtaJad/dHL49ECqefbBBxWvnO7VJ8FnmXlgK5rtOzPgcnRbA9xKg6v9IbVTTk
 qL2gj90fnZjwIsovGLPslHN1sFCEBiFXv/Jvef78QIdWKnlweMPMijG04YssS2ZEBt7S
 honA==
X-Gm-Message-State: AOAM530ynTXDQMw06FAvkr1oHvCC9GIjCpv7vNgKPn+yHuC9HAA0oI/H
 NEBZ8fPRSblN8sY4/LNq0rLIz2U=
X-Google-Smtp-Source: ABdhPJzfpJR/RjQLHUu3kWRlKvxHxz6bsudZeV2/S/4eugGpDEdr3x2h4vOCWJiRMX7i6L/0LQCoNw==
X-Received: by 2002:a05:6214:2308:b0:435:3440:7d3c with SMTP id
 gc8-20020a056214230800b0043534407d3cmr33667442qvb.65.1654873861579; 
 Fri, 10 Jun 2022 08:11:01 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u20-20020a05620a0c5400b006a6a774d27bsm17078941qki.134.2022.06.10.08.11.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Jun 2022 08:11:01 -0700 (PDT)
Date: Fri, 10 Jun 2022 11:11:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <YqNfBMOR9SE2TuCm@redhat.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
MIME-Version: 1.0
In-Reply-To: <YqLTV+5Q72/jBeOG@kroah.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: keescook@chromium.org, sarthakkukreti@google.com, stable@vger.kernel.org,
 Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
 regressions@lists.linux.dev
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

On Fri, Jun 10 2022 at  1:15P -0400,
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > I believe this commit introduced a regression in dm verity on systems
> > where data device is an NVME one. Loading table fails with the
> > following diagnostics:
> > 
> > device-mapper: table: table load rejected: including non-request-stackable devices
> > 
> > The same kernel works with the same data drive on the SCSI interface.
> > NVME-backed dm verity works with just this commit reverted.
> > 
> > I believe the presence of the immutable partition is used as an indicator
> > of special case NVME configuration and if the data device's name starts
> > with "nvme" the code tries to switch the target type to
> > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > 
> > The special NVME optimization case was removed in
> > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > affected.
> > 
> 
> Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> immutable singleton target on NVMe") to those older kernels?  If so,
> have you tested this and verified that it worked?

Sorry for the unforeseen stable@ troubles here!

In general we'd be fine to apply commit 9c37de297f65 but to do it
properly would require also making sure commits that remove
"DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
unnecessary NVMe branching in favor of scsi_dh checks") are applied --
basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
be removed.

The commit header for 8d47e65948dd documents what
DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
"nvme" mode really never got used by any userspace that I'm aware of.

Sadly I currently don't have the time to do this backport for all N
stable kernels... :(

But if that backport gets out of control: A simpler, albeit stable@
unicorn, way to resolve this is to simply revert 9c37de297f65 and make
it so that DM-mpath and DM core just used bio-based if "nvme" is
requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:

@@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)

                        if (!strcasecmp(queue_mode_name, "bio"))
                                m->queue_mode = DM_TYPE_BIO_BASED;
			else if (!strcasecmp(queue_mode_name, "nvme"))
-                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
+                               m->queue_mode = DM_TYPE_BIO_BASED;
                        else if (!strcasecmp(queue_mode_name, "rq"))
                                m->queue_mode = DM_TYPE_REQUEST_BASED;
                        else if (!strcasecmp(queue_mode_name, "mq"))

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

