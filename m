Return-Path: <SRS0=a4Wy=L5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9E5C11F73
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:48:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADE726144E
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADE726144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-mbqmK4XSNzK4qqgrN-77WQ-1; Mon, 05 Jul 2021 09:48:26 -0400
X-MC-Unique: mbqmK4XSNzK4qqgrN-77WQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C070B91271;
	Mon,  5 Jul 2021 13:48:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86FA11036D03;
	Mon,  5 Jul 2021 13:48:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EB9FA1809C99;
	Mon,  5 Jul 2021 13:48:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 165DmJwn021996 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 5 Jul 2021 09:48:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 61C25202B185; Mon,  5 Jul 2021 13:48:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CD91202B16F
	for <dm-devel@redhat.com>; Mon,  5 Jul 2021 13:48:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED93F185A7A4
	for <dm-devel@redhat.com>; Mon,  5 Jul 2021 13:48:15 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-508-UCtFQ2afN3WYKmogrUMhXQ-1; Mon, 05 Jul 2021 09:48:13 -0400
X-MC-Unique: UCtFQ2afN3WYKmogrUMhXQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 03AC41FE7C;
	Mon,  5 Jul 2021 13:48:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 830F313A61;
	Mon,  5 Jul 2021 13:48:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id Ah7JHZsN42D0AwAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 05 Jul 2021 13:48:11 +0000
Message-ID: <a088aa5c8459c001403bda9384b38213f8232fc6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Date: Mon, 05 Jul 2021 15:48:10 +0200
In-Reply-To: <5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
	<de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
	<20210701113442.GA10793@lst.de>
	<003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
	<e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
	<5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 165DmJwn021996
X-loop: dm-devel@redhat.com
Cc: Mike, Daniel Wagner <dwagner@suse.de>, Snitzer <snitzer@redhat.com>,
	emilne@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, nkoenig@redhat.com,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Alasdair G Kergon <agk@redhat.com>
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

On Mo, 2021-07-05 at 15:11 +0200, Hannes Reinecke wrote:
> On 7/5/21 3:02 PM, Paolo Bonzini wrote:
> > On 02/07/21 16:21, Martin Wilck wrote:
> > > > SG_IO gives you raw access to the SCSI logic unit, and you get
> > > > to
> > > > keep the pieces if anything goes wrong.
> > >=20
> > > That's a very fragile user space API, on the fringe of being
> > > useless
> > > IMO.
> >=20
> > Indeed.=A0 If SG_IO is for raw access to an ITL nexus, it shouldn't
> > be
> > supported at all by mpath devices.=A0 If on the other hand SG_IO is
> > for
> > raw access to a LUN, there is no reason for it to not support
> > failover.
> >=20
> Or we look at IO_URING_OP_URING_CMD, to send raw cdbs via io_uring.
> And delegate SG_IO to raw access to an ITL nexus.
> Doesn't help with existing issues, but should get a clean way
> forward.

I still have to understand how this would help with the retrying
semantics. Wouldn't we get the exact same problem if a path error
occurs?

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

