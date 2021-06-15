Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3242C48BE8
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 10:54:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39DF961454
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 10:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39DF961454
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-RcfUT4mDMg6TpucLpfUy1g-1; Tue, 15 Jun 2021 06:54:55 -0400
X-MC-Unique: RcfUT4mDMg6TpucLpfUy1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0412100CA8A;
	Tue, 15 Jun 2021 10:54:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DB065D6DC;
	Tue, 15 Jun 2021 10:54:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BEB6146F82;
	Tue, 15 Jun 2021 10:54:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FAshJY022079 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 06:54:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 20C19AB3FF; Tue, 15 Jun 2021 10:54:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B266AEC93
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 10:54:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57AD380B926
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 10:54:40 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-418-aI-ktoJOOaaCeeqRg--Vpg-1; Tue, 15 Jun 2021 06:54:33 -0400
X-MC-Unique: aI-ktoJOOaaCeeqRg--Vpg-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E6E321916;
	Tue, 15 Jun 2021 10:54:32 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id A042C118DD;
	Tue, 15 Jun 2021 10:54:31 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id 1N34JOeGyGCBMAAALh3uQQ
	(envelope-from <mwilck@suse.com>); Tue, 15 Jun 2021 10:54:31 +0000
Message-ID: <44fc94278e0c4b15a611a6887c668f41c262e001.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 15 Jun 2021 12:54:31 +0200
In-Reply-To: <YMdyh62mR/lEifMR@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
	<YMdyh62mR/lEifMR@redhat.com>
User-Agent: Evolution 3.40.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15FAshJY022079
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, Christoph,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/2] dm: dm_blk_ioctl(): implement
 failover for SG_IO on dm-multipath
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mo, 2021-06-14 at 11:15 -0400, Mike Snitzer wrote:
>=20
> This work offers a proof-of-concept but it needs further refinement
> for sure.

Thanks for looking into it again. I need some more guidance from your
part in order to be able to resubmit the set in a form that you
consider ready for merging.

> The proposed open-coded SCSI code (in patch 2's drivers/md/dm-
> scsi_ioctl.c)=20
> is well beyond what I'm willing to take in DM.

I'm not sure what code you're referring to. Is it the processing of the
bytes of the SCSI result code? If yes, please note that I had changed
that to open-coded form in response to Bart's review of my v2
submission. If it's something else, please point it out to me.

To minimize the special-casing for this code path, Hannes suggested to
use a target-specific unprepare_ioctl() callback to to tell the generic
dm code whether a given ioctl could be retried.=A0The logic that I've put
into=A0dm-scsi_ioctl.c could then be moved into the unprepare_ioctl()
callback of dm-mpath.=A0dm_blk_ioctl() would need to check the callback's
return value and possibly retry the ioctl. Would hat appeal to you?

> =A0 If this type of
> functionality is still needed (for kvm's SCSI passthru snafu) then
> more work is needed to negotiate proper interfaces with the SCSI
> subsystem (added linux-scsi to cc, odd they weren't engaged on this).

Not cc'ing linux-scsi was my oversight, sorry about that.=A0

But I don't quite understand what interfaces you have in mind. SCSI
needs to expose the SG_IO interface to dm, which it does; I just needed
to export sg_io() to get access to the sg_io_hdr fields. The question
whether a given IO can be retried is decided on the dm (-mpath) layer,
based on blk_status_t; no additional interface on the SCSI side is
necessary for that.

> Does it make sense to extend the SCSI device handler interface to add
> the required enablement? (I think it'd have to if this line of work
> is
> to ultimately get upstream).

My current code uses the device handler indirectly for activating paths
during priority group switching, via the dm-mpath prepare_ioctl()
method and __pg_init_all_paths(). This is what I intended - to use
exactly the same logic for SG_IO which is used for regular read/write
IO on the block device.=A0What additional functionality for the device
handler do you have in mind?

Regards and thanks,
Martin

>=20
> Mike
>=20
> =A0=20
> > Changes v1->v2:
> >=20
> > =A0- applied modifications from Mike Snitzer
> > =A0- moved SG_IO dependent code to a separate file, no scsi includes
> > in
> > =A0=A0 dm.c any more
> > =A0- made the new code depend on a configuration option=20
> > =A0- separated out scsi changes, made scsi_result_to_blk_status()
> > =A0=A0 inline to avoid dependency of dm_mod from scsi_mod (Paolo
> > Bonzini)
> >=20
> > Martin Wilck (2):
> > =A0 scsi: export __scsi_result_to_blk_status() in scsi_ioctl.c
> > =A0 dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO on dm-
> > multipath
> >=20
> > =A0block/scsi_ioctl.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 52 ++++++++++++++-
> > =A0drivers/md/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 11 ++++
> > =A0drivers/md/Makefile=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 4 ++
> > =A0drivers/md/dm-core.h=A0=A0=A0=A0=A0=A0 |=A0=A0 5 ++
> > =A0drivers/md/dm-rq.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 11 ++++
> > =A0drivers/md/dm-scsi_ioctl.c | 127
> > +++++++++++++++++++++++++++++++++++++
> > =A0drivers/md/dm.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 20 +++++-
> > =A0drivers/scsi/scsi_lib.c=A0=A0=A0 |=A0 29 +--------
> > =A0include/linux/blkdev.h=A0=A0=A0=A0 |=A0=A0 3 +
> > =A09 files changed, 229 insertions(+), 33 deletions(-)
> > =A0create mode 100644 drivers/md/dm-scsi_ioctl.c
> >=20
> > --=20
> > 2.31.1
> >=20
>=20



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

