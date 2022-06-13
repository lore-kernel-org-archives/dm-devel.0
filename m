Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A876C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Jun 2022 09:13:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-BJzpYWgVNQKUN05uy1RYkg-1; Mon, 13 Jun 2022 05:13:39 -0400
X-MC-Unique: BJzpYWgVNQKUN05uy1RYkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 786B71C01B20;
	Mon, 13 Jun 2022 09:13:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27C8C40CF8EB;
	Mon, 13 Jun 2022 09:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9BB411947060;
	Mon, 13 Jun 2022 09:13:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3AA4B194705B
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Jun 2022 09:13:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24A1F2166B29; Mon, 13 Jun 2022 09:13:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 205752166B26
 for <dm-devel@redhat.com>; Mon, 13 Jun 2022 09:13:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 044DC801E6B
 for <dm-devel@redhat.com>; Mon, 13 Jun 2022 09:13:32 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-PuUkrJbWMU24sxc1cpsX0Q-1; Mon, 13 Jun 2022 05:13:29 -0400
X-MC-Unique: PuUkrJbWMU24sxc1cpsX0Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3AD9F612FB;
 Mon, 13 Jun 2022 09:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47467C34114;
 Mon, 13 Jun 2022 09:13:28 +0000 (UTC)
Date: Mon, 13 Jun 2022 11:13:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <Yqb/sT205Lrhl6Bv@kroah.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com> <YqNfBMOR9SE2TuCm@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YqNfBMOR9SE2TuCm@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
Cc: keescook@chromium.org, sarthakkukreti@google.com, stable@vger.kernel.org,
 Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
 regressions@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> On Fri, Jun 10 2022 at  1:15P -0400,
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > I believe this commit introduced a regression in dm verity on systems
> > > where data device is an NVME one. Loading table fails with the
> > > following diagnostics:
> > > 
> > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > 
> > > The same kernel works with the same data drive on the SCSI interface.
> > > NVME-backed dm verity works with just this commit reverted.
> > > 
> > > I believe the presence of the immutable partition is used as an indicator
> > > of special case NVME configuration and if the data device's name starts
> > > with "nvme" the code tries to switch the target type to
> > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > 
> > > The special NVME optimization case was removed in
> > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > affected.
> > > 
> > 
> > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > immutable singleton target on NVMe") to those older kernels?  If so,
> > have you tested this and verified that it worked?
> 
> Sorry for the unforeseen stable@ troubles here!
> 
> In general we'd be fine to apply commit 9c37de297f65 but to do it
> properly would require also making sure commits that remove
> "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> be removed.
> 
> The commit header for 8d47e65948dd documents what
> DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> "nvme" mode really never got used by any userspace that I'm aware of.
> 
> Sadly I currently don't have the time to do this backport for all N
> stable kernels... :(
> 
> But if that backport gets out of control: A simpler, albeit stable@
> unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> it so that DM-mpath and DM core just used bio-based if "nvme" is
> requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> 
> @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> 
>                         if (!strcasecmp(queue_mode_name, "bio"))
>                                 m->queue_mode = DM_TYPE_BIO_BASED;
> 			else if (!strcasecmp(queue_mode_name, "nvme"))
> -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> +                               m->queue_mode = DM_TYPE_BIO_BASED;
>                         else if (!strcasecmp(queue_mode_name, "rq"))
>                                 m->queue_mode = DM_TYPE_REQUEST_BASED;
>                         else if (!strcasecmp(queue_mode_name, "mq"))
> 
> Mike
> 

Ok, please submit a working patch for the kernels that need it so that
we can review and apply it to solve this regression.

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

