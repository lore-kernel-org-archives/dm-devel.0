Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48674CCA47C
	for <dm-devel@archiver.kernel.org>; Mon, 20 Jun 2022 11:52:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-W4yq5gm7NpCxre2HEVGNKg-1; Mon, 20 Jun 2022 07:52:12 -0400
X-MC-Unique: W4yq5gm7NpCxre2HEVGNKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CD5E3C11E6C;
	Mon, 20 Jun 2022 11:52:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E84E40CFD0A;
	Mon, 20 Jun 2022 11:52:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E4146194706D;
	Mon, 20 Jun 2022 11:52:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 933A61947069
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Jun 2022 11:52:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7E632141510C; Mon, 20 Jun 2022 11:52:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79DB01415109
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 11:52:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6225C811E7A
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 11:52:06 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-x84vHnkZNn-1JUeEV6njuQ-1; Mon, 20 Jun 2022 07:51:57 -0400
X-MC-Unique: x84vHnkZNn-1JUeEV6njuQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9BD35B810A2;
 Mon, 20 Jun 2022 11:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04141C3411B;
 Mon, 20 Jun 2022 11:44:51 +0000 (UTC)
Date: Mon, 20 Jun 2022 13:44:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YrBdsTDrreF3H82o@kroah.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com> <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
 <Yqo63CvFpTDFnH3x@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yqo63CvFpTDFnH3x@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
 Guenter Roeck <linux@roeck-us.net>, regressions@lists.linux.dev
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

On Wed, Jun 15, 2022 at 04:02:36PM -0400, Mike Snitzer wrote:
> On Wed, Jun 15 2022 at  1:50P -0400,
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > On 6/15/22 08:29, Mike Snitzer wrote:
> > > On Wed, Jun 15 2022 at 10:36P -0400,
> > > Guenter Roeck <linux@roeck-us.net> wrote:
> > > 
> > > > On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> > > > > On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > > > > > On Fri, Jun 10 2022 at  1:15P -0400,
> > > > > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > > 
> > > > > > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > > > > > I believe this commit introduced a regression in dm verity on systems
> > > > > > > > where data device is an NVME one. Loading table fails with the
> > > > > > > > following diagnostics:
> > > > > > > > 
> > > > > > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > > > > > 
> > > > > > > > The same kernel works with the same data drive on the SCSI interface.
> > > > > > > > NVME-backed dm verity works with just this commit reverted.
> > > > > > > > 
> > > > > > > > I believe the presence of the immutable partition is used as an indicator
> > > > > > > > of special case NVME configuration and if the data device's name starts
> > > > > > > > with "nvme" the code tries to switch the target type to
> > > > > > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > > > > > 
> > > > > > > > The special NVME optimization case was removed in
> > > > > > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > > > > > affected.
> > > > > > > > 
> > > > > > > 
> > > > > > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > > > > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > > > > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > > > > > have you tested this and verified that it worked?
> > > > > > 
> > > > > > Sorry for the unforeseen stable@ troubles here!
> > > > > > 
> > > > > > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > > > > > properly would require also making sure commits that remove
> > > > > > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > > > > > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > > > > > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > > > > > be removed.
> > > > > > 
> > > > > > The commit header for 8d47e65948dd documents what
> > > > > > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > > > > > "nvme" mode really never got used by any userspace that I'm aware of.
> > > > > > 
> > > > > > Sadly I currently don't have the time to do this backport for all N
> > > > > > stable kernels... :(
> > > > > > 
> > > > > > But if that backport gets out of control: A simpler, albeit stable@
> > > > > > unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> > > > 
> > > > 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
> > > > and trying to apply it results in conflicts which at least I can not
> > > > resolve.
> > > > 
> > > > > > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > > > > > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > > > > > 
> > > > > > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > > > > > 
> > > > > >                          if (!strcasecmp(queue_mode_name, "bio"))
> > > > > >                                  m->queue_mode = DM_TYPE_BIO_BASED;
> > > > > > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > > > > > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > > > > > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> > > > > >                          else if (!strcasecmp(queue_mode_name, "rq"))
> > > > > >                                  m->queue_mode = DM_TYPE_REQUEST_BASED;
> > > > > >                          else if (!strcasecmp(queue_mode_name, "mq"))
> > > > > > 
> > > > > > Mike
> > > > > > 
> > > > > 
> > > > > Ok, please submit a working patch for the kernels that need it so that
> > > > > we can review and apply it to solve this regression.
> > > > > 
> > > > 
> > > > So, effectively, v5.4.y and older are broken right now for use cases
> > > > with dm on NVME drives.
> > > > 
> > > > Given that the regression does affect older branches, and given that we
> > > > have to revert this patch to avoid regressions in ChromeOS, would it be
> > > > possible to revert it from v5.4.y and older until a fix is found ?
> > > 
> > > I obviously would prefer to not have this false-start.
> > > 
> > The false start has already happened since we had to revert the patch
> > from chromeos-5.4 and older branches.
> 
> OK, well this is pretty easy to fix in general.  If there are slight
> differences across older trees they are easily resolved.  Fact that
> stable@ couldn't cope with backporting 9c37de297f65 is.. what it is.
> 
> But this will fix the issue on 5.4.y:
> 
> From: Mike Snitzer <snitzer@kernel.org>
> Date: Wed, 15 Jun 2022 14:07:09 -0400
> Subject: [5.4.y PATCH] dm: remove special-casing of bio-based immutable singleton target on NVMe
> 
> Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.
> 
> There is no benefit to DM special-casing NVMe. Remove all code used to
> establish DM_TYPE_NVME_BIO_BASED.
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-table.c         | 32 ++----------------
>  drivers/md/dm.c               | 64 +++--------------------------------
>  include/linux/device-mapper.h |  1 -
>  3 files changed, 7 insertions(+), 90 deletions(-)

Can someone resend this in the proper format (and fixed up), with
Guenter's tested-by so that I can queue it up?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

