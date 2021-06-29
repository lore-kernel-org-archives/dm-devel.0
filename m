Return-Path: <SRS0=7Rox=LX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A35C11F66
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 12:59:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 35C2A61DBF
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 12:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35C2A61DBF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-7SbLUugIMgexT3I-u9A7dw-1; Tue, 29 Jun 2021 08:59:38 -0400
X-MC-Unique: 7SbLUugIMgexT3I-u9A7dw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A642804141;
	Tue, 29 Jun 2021 12:59:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B56D210016F8;
	Tue, 29 Jun 2021 12:59:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCB031809C97;
	Tue, 29 Jun 2021 12:59:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15TCxJqF012694 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Jun 2021 08:59:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A85E0200BFCB; Tue, 29 Jun 2021 12:59:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3E1C200BFC6
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 12:59:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 511EE802700
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 12:59:17 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-341-ECf6t-VuMBOwWj8fVjLRFQ-1;
	Tue, 29 Jun 2021 08:59:14 -0400
X-MC-Unique: ECf6t-VuMBOwWj8fVjLRFQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E8FA67373; Tue, 29 Jun 2021 14:59:10 +0200 (CEST)
Date: Tue, 29 Jun 2021 14:59:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210629125909.GB14372@lst.de>
References: <20210628095210.26249-1-mwilck@suse.com>
	<20210628095210.26249-2-mwilck@suse.com>
	<20210628095341.GA4105@lst.de>
	<4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15TCxJqF012694
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
	Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> Hello Christoph,
>=20
> On Mo, 2021-06-28 at 11:53 +0200, Christoph Hellwig wrote:
> > On Mon, Jun 28, 2021 at 11:52:08AM +0200, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > This makes it possible to use scsi_result_to_blk_status() from
> > > code that shouldn't depend on scsi_mod (e.g. device mapper).
> >=20
> > This really has no business being used outside of low-level SCSI
> > code.
>=20
> And this is where my patch set uses it. Can you recommend a better
> way how to access this algorithm, without making dm_mod.ko or dm-
> mpath.ko depend on scsi_mod.ko, and without open-coding it
> independently in a different code path?

> The sg_io-on-multipath code needs to answer the question "is this a
> path or a target error?". Therefore it calls blk_path_error(), which
> requires obtaining a blk_status_t first. But that's not available in
> the sg_io code path. So how=A0should I deal with this situation?

Not by exporting random crap from the SCSI code.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

