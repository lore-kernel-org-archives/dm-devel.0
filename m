Return-Path: <SRS0=Z7ED=LY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0647EC11F65
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 17:11:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8EBA161166
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 17:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EBA161166
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-MLB107FTPsa634mf-MpLeA-1; Wed, 30 Jun 2021 13:11:21 -0400
X-MC-Unique: MLB107FTPsa634mf-MpLeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81A078BAC23;
	Wed, 30 Jun 2021 17:10:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B625470F5A;
	Wed, 30 Jun 2021 17:10:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C334B4EA37;
	Wed, 30 Jun 2021 17:10:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15UGsLun028374 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Jun 2021 12:54:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DB2C31009144; Wed, 30 Jun 2021 16:54:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D73F91009128
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 16:54:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D685805F11
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 16:54:19 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-328-LbkEiIkENCOMkOOMY6crjw-1; Wed, 30 Jun 2021 12:54:14 -0400
X-MC-Unique: LbkEiIkENCOMkOOMY6crjw-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 80A451FEBD;
	Wed, 30 Jun 2021 16:54:12 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 134FA118DD;
	Wed, 30 Jun 2021 16:54:12 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id nTDiArSh3GA0cgAALh3uQQ
	(envelope-from <mwilck@suse.com>); Wed, 30 Jun 2021 16:54:12 +0000
Message-ID: <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@gmail.com>, Bart Van Assche
	<bart.vanassche@sandisk.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
Date: Wed, 30 Jun 2021 18:54:11 +0200
In-Reply-To: <YNyVafnX09cOIZPe@redhat.com>
References: <20210628095210.26249-1-mwilck@suse.com>
	<20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
	<4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
	<20210629125909.GB14372@lst.de>
	<2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
	<20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
	<1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
	<YNyVafnX09cOIZPe@redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15UGsLun028374
X-loop: dm-devel@redhat.com
Cc: Benjamin, linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	emilne@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, nkoenig@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
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

On Mi, 2021-06-30 at 12:01 -0400, Mike Snitzer wrote:
> On Wed, Jun 30 2021 at=A0 4:12P -0400,
> Martin Wilck <mwilck@suse.com> wrote:
> >=20
> > Thanks for your suggestion. I'd be lucky if this was true. But the
> > most
> > important users of scsi_result_to_blk_status() are in scsi_lib.c
> > (scsi_io_completion_action(), scsi_io_completion_nz_result()).
> >=20
> > If I move scsi_result_to_blk_status() to vmlinux without exporting
> > it,
> > it won't be available in the SCSI core any more, at least not with
> > CONFIG_SCSI=3Dm.
>=20
> For what you're trying to accomplish with this patchset, you only
> need
> sg_io_to_blk_status() exported.
>=20
> So check with Martin and/or Bart on the best way to give
> sg_io_to_blk_status() access to the equivalent of your
> __scsi_result_to_blk_status() without exporting it.
>=20
> I'd start by just folding patches 1 and 2, fixing up the logic Dan
> Carpenter pointed ouit, and only exporting sg_io_to_blk_status().

Thank you! FTR, the issue Dan Carpenter reported was already fixed in
v5 of this patch set.

@Martin, @Bart, do you have a suggestion for me?

Thanks,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

