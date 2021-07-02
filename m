Return-Path: <SRS0=SQPv=L2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD629C11F68
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jul 2021 14:21:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D64B6142B
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jul 2021 14:21:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D64B6142B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240--NOg9Y6NNbauzAFfJMcoOw-1; Fri, 02 Jul 2021 10:21:25 -0400
X-MC-Unique: -NOg9Y6NNbauzAFfJMcoOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DD60100C661;
	Fri,  2 Jul 2021 14:21:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE35810023B0;
	Fri,  2 Jul 2021 14:21:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 256984EA2A;
	Fri,  2 Jul 2021 14:21:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 162ELBqp006090 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 2 Jul 2021 10:21:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5D99510FF37; Fri,  2 Jul 2021 14:21:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58ADE10728D
	for <dm-devel@redhat.com>; Fri,  2 Jul 2021 14:21:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F6F98037A4
	for <dm-devel@redhat.com>; Fri,  2 Jul 2021 14:21:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-89-JEVDTuZlN3-Fo53AN12R_A-1; Fri, 02 Jul 2021 10:21:04 -0400
X-MC-Unique: JEVDTuZlN3-Fo53AN12R_A-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32C2321BA8;
	Fri,  2 Jul 2021 14:21:02 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id BD73211C84;
	Fri,  2 Jul 2021 14:21:01 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id 1ymoLM0g32C4XgAALh3uQQ
	(envelope-from <mwilck@suse.com>); Fri, 02 Jul 2021 14:21:01 +0000
Message-ID: <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@lst.de>
Date: Fri, 02 Jul 2021 16:21:01 +0200
In-Reply-To: <20210701113442.GA10793@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
	<de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
	<20210701113442.GA10793@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 162ELBqp006090
X-loop: dm-devel@redhat.com
Cc: Assche <Bart.VanAssche@sandisk.com>, linux-scsi@vger.kernel.org,
	Wagner <dwagner@suse.de>, Mike Snitzer <snitzer@redhat.com>,
	emilne@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Daniel, "Martin K.
	Petersen" <martin.petersen@oracle.com>, nkoenig@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, Bart
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Do, 2021-07-01 at 13:34 +0200, Christoph Hellwig wrote:
> On Thu, Jul 01, 2021 at 12:35:53PM +0200, Martin Wilck wrote:
> > I respectfully disagree. Users of dm-multipath devices expect that
> > IO
> > succeeds as long as there's at least one healthy path. This is a
> > fundamental property of multipath devices. Whether IO is sent
> > "normally" or via SG_IO doesn't make a difference wrt this
> > expectation.
>=20
> If you have those (pretty reasonable) expections don't use SG_IO.
> That is what the regular read/write path is for.=A0 SG_IO gives you
> raw access to the SCSI logic unit, and you get to keep the pieces
> if anything goes wrong.

With this logic, if some paths are down, SG_IO commands on multipath
devices yield random results. On one path a command would fail, and on
another it would succeed. User space has no way to control or even see
what path is being used. That's a very fragile user space API, on the
fringe of being useless IMO.

If user space is interested in the error handling semantics you
describe, it can run SG_IO on individual SCSI devices any time. With
the change I am proposing, nothing is lost for user space. If user
space decides to do SG_IO on a multipath device, it has a different
expectation, which my patch set implements. IMO we should strive to
match the semantics for ioctls on natively multipathed NVMe namespaces.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

