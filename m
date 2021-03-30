Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0494C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 16:59:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F4C1619CD
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 16:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F4C1619CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617123569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RUj24Vullv2QdmFQhD76xEzIG5ySm7XyrwFnJ24nxMs=;
	b=Ieay1Y0d6/vaRTT1xlUBnolUsj0e9ISKx1z8jIoJa7qrF3EDCBYq9NHKLC7y2mZvghAG+z
	L57qg8WLNl9jGZWiyyO/VqOAsgyGCb0qYr1F90RRNcRHxM8DC1Je3NiSV8MINijLpKx+SR
	E0cXxfKJPf5FtUaclm6sblQq7uwP5nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-NVQXh_oyOciM7lu8jwprIQ-1; Tue, 30 Mar 2021 12:59:27 -0400
X-MC-Unique: NVQXh_oyOciM7lu8jwprIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D22D2107ACCA;
	Tue, 30 Mar 2021 16:59:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D61835C1D1;
	Tue, 30 Mar 2021 16:59:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 806D94A7C9;
	Tue, 30 Mar 2021 16:59:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12UGxG67012233 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 12:59:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AE89D19718; Tue, 30 Mar 2021 16:59:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33F5319D80;
	Tue, 30 Mar 2021 16:59:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12UGx5mY010972; 
	Tue, 30 Mar 2021 11:59:10 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12UGx5At010971;
	Tue, 30 Mar 2021 11:59:05 -0500
Date: Tue, 30 Mar 2021 11:59:04 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210330165904.GS15006@octiron.msp.redhat.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-5-mwilck@suse.com>
	<20210330042510.GN15006@octiron.msp.redhat.com>
	<c493ded4f0405cbba9114497e09a6872f5b36a40.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <c493ded4f0405cbba9114497e09a6872f5b36a40.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH 4/7] libdmmp: allow building without perl
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 10:00:02AM +0200, Martin Wilck wrote:
> On Mon, 2021-03-29 at 23:25 -0500, Benjamin Marzinski wrote:
> > On Fri, Mar 26, 2021 at 10:29:41PM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > Add the kernel-doc generated manpages of libdmmp to git, and
> > > change the libdmmp Makefile to regenerate them (only) when
> > > necessary.
> > >=20
> > > This allows us to drop perl as a build-time requirement.
> >=20
> > Git complains about a bunch of trailing whitespace issues here, but
> > this
> > is a great idea.
>=20
> The files are generated by kernel-doc. So unless we want to work
> on the whitespace treatment of kernel-doc (I wouldn't), we have to live
> with git's complaints in this area.

Yeah. I figured that fixing this wouldn't be easy, that's why I ACK'ed
the whole set.

-Ben

>=20
> Thanks,
> Martin
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

