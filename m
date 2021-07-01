Return-Path: <SRS0=hnI9=LZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67168C11F64
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 10:41:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0025961476
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 10:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0025961476
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-gXHUSGpvOq6txaRcy-gd7g-1; Thu, 01 Jul 2021 06:41:12 -0400
X-MC-Unique: gXHUSGpvOq6txaRcy-gd7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B06698042F3;
	Thu,  1 Jul 2021 10:41:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D17E604CD;
	Thu,  1 Jul 2021 10:41:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2ADD1809C99;
	Thu,  1 Jul 2021 10:41:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 161Aa3qr015418 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Jul 2021 06:36:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7ECC720D69B3; Thu,  1 Jul 2021 10:36:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A51320D69B2
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 10:36:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A021E108C20C
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 10:36:00 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-280-3Mf5EiFmMg-QfXh-U7xg_g-1; Thu, 01 Jul 2021 06:35:56 -0400
X-MC-Unique: 3Mf5EiFmMg-QfXh-U7xg_g-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 351C01FFA0;
	Thu,  1 Jul 2021 10:35:54 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id BA31211CC0;
	Thu,  1 Jul 2021 10:35:53 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id THvwK4ma3WCtXQAALh3uQQ
	(envelope-from <mwilck@suse.com>); Thu, 01 Jul 2021 10:35:53 +0000
Message-ID: <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@lst.de>
Date: Thu, 01 Jul 2021 12:35:53 +0200
In-Reply-To: <20210701075629.GA25768@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
User-Agent: Evolution 3.40.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 161Aa3qr015418
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
	emilne@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Daniel Wagner <dwagner@suse.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Do, 2021-07-01 at 09:56 +0200, Christoph Hellwig wrote:
> On Mon, Jun 28, 2021 at 05:15:58PM +0200, mwilck@suse.com=A0wrote:
> > The qemu "pr-helper" was specifically invented for it. I
> > believe that this is the most important real-world scenario for
> > sending
> > SG_IO ioctls to device-mapper devices.
>=20
> pr-helper obviously does not SG_IO on dm-multipath as that simply
> does
> not work.
>=20
> More importantly - if you want to use persistent reservations use the
> kernel ioctls for that.=A0 These work on SCSI, NVMe and device mapper
> without any extra magic.

This set is not about persistent reservations. Sorry if my mentioning
pr-helper made this impression. It was only meant to emphasize the fact
that qemu SCSI passthrough using SG_IO is an important use case.

> Failing over SG_IO does not make sense.=A0 It is an interface
> specically
> designed to leave all error handling to the userspace program using
> it,
> and we should not change that for one specific error case.=A0 If you
> want the kernel to handle errors for you, use the proper interfaces.
> In this case this is the persistent reservation ioctls.=A0 If they miss
> some features that qemu needs we should add those.

I respectfully disagree. Users of dm-multipath devices expect that IO
succeeds as long as there's at least one healthy path. This is a
fundamental property of multipath devices. Whether IO is sent
"normally" or via SG_IO doesn't make a difference wrt this expectation.

The fact that qemu implements SCSI passthrough this way shows that this
is not just a na=EFve user expectation, but is shared by experienced
developers as well. AFAICS, we can't simply move the path error
detection and retry logic into user space qemu, because user space
doesn't have information about the status of the multipath map; not to
mention that doing this would be highly inefficient.

I agree that in principle, SG_IO error handling should be left to user
space. But in this specific case, it makes sense to handle just the
"path error vs. target error" distinction in the kernel. All else is of
course still handled by user space.

Regards,
Martin





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

