Return-Path: <SRS0=7Rox=LX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8559C11F67
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 19:25:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F1FD61DD4
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 19:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F1FD61DD4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-gHghtvcYPXG7VJissiKFRA-1; Tue, 29 Jun 2021 15:25:00 -0400
X-MC-Unique: gHghtvcYPXG7VJissiKFRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03C0991270;
	Tue, 29 Jun 2021 19:24:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A16F179E6;
	Tue, 29 Jun 2021 19:24:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F2CC1809C99;
	Tue, 29 Jun 2021 19:24:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15TJNSWE022064 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Jun 2021 15:23:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 80D88200E485; Tue, 29 Jun 2021 19:23:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B594200E4B5
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 19:23:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D698007D3
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 19:23:26 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-398-4CHBbp1LPTiWPXpwN17YOQ-1; Tue, 29 Jun 2021 15:23:21 -0400
X-MC-Unique: 4CHBbp1LPTiWPXpwN17YOQ-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 88B7C1FDAE;
	Tue, 29 Jun 2021 19:23:19 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 15DA111906;
	Tue, 29 Jun 2021 19:23:19 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id EG6yAydz22CzEAAALh3uQQ
	(envelope-from <mwilck@suse.com>); Tue, 29 Jun 2021 19:23:19 +0000
Message-ID: <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@lst.de>
Date: Tue, 29 Jun 2021 21:23:18 +0200
In-Reply-To: <20210629125909.GB14372@lst.de>
References: <20210628095210.26249-1-mwilck@suse.com>
	<20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
	<4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
	<20210629125909.GB14372@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15TJNSWE022064
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
	emilne@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Daniel Wagner <dwagner@suse.de>, Alasdair G Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Di, 2021-06-29 at 14:59 +0200, Christoph Hellwig wrote:
> On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
>=20
> > The sg_io-on-multipath code needs to answer the question "is this a
> > path or a target error?". Therefore it calls blk_path_error(),
> > which
> > requires obtaining a blk_status_t first. But that's not available
> > in
> > the sg_io code path. So how=A0should I deal with this situation?
>=20
> Not by exporting random crap from the SCSI code.

So, you'd prefer inlining scsi_result_to_blk_status()?

Thanks,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

