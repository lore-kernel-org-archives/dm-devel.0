Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8B2C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:32:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 475EC22D58
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 475EC22D58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611675168;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RWVQ7NFCtNGADDfB7KVSVM3CLGIsw5POpfnKuOpSFPk=;
	b=TMebzL+owbGlSQRuuhuOduAXSKWtLPdlWM1B/N1MjQdMsmuexKnoQ130wJKOq709pU9lQ2
	gGGSORAXm1H4IM2P23ZdtD9zdJVxal5VJ7RUkyk1Gsy79R16gOucLd01nbeM4VYCSpnSjg
	PqJkVnVWg6kieiXtd5B34dcNrS251Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-Ty3VGjUyOZmta0jtblGbTQ-1; Tue, 26 Jan 2021 10:32:44 -0500
X-MC-Unique: Ty3VGjUyOZmta0jtblGbTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 031411083EB1;
	Tue, 26 Jan 2021 15:32:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D54FE5D9C2;
	Tue, 26 Jan 2021 15:32:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91A4B180954D;
	Tue, 26 Jan 2021 15:32:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QFWcC4016579 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 10:32:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F9F760938; Tue, 26 Jan 2021 15:32:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 123796B8DD;
	Tue, 26 Jan 2021 15:32:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10QFWXbh011537; 
	Tue, 26 Jan 2021 09:32:33 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10QFWXbf011536;
	Tue, 26 Jan 2021 09:32:33 -0600
Date: Tue, 26 Jan 2021 09:32:33 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210126153232.GG15006@octiron.msp.redhat.com>
References: <1611639064-8187-1-git-send-email-bmarzins@redhat.com>
	<17aedb32b8cf8229441d3a48b72b56ef6f6ebc12.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <17aedb32b8cf8229441d3a48b72b56ef6f6ebc12.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmpathpersist: fix thread safety of
	default functions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26, 2021 at 10:04:28AM +0000, Martin Wilck wrote:
> On Mon, 2021-01-25 at 23:31 -0600, Benjamin Marzinski wrote:
> > commit a839e39e ("libmpathpersist: factor out initialization and
> > teardown") made mpath_presistent_reserve_{in,out} use share variables
> > for curmp and pathvec.=A0 There are users of this library that call
> > these
> > functions in a multi-threaded process, and this change causes their
> > application to crash. config and udev are also shared variables, but
> > libmpathpersist doesn't write to the config in
> > mpath_presistent_reserve_{in,out}, and looking into the libudev code,
> > I
> > don't see any place where libmpathpersist uses the udev object in a
> > way
> > that isn't thread-safe.
> >=20
> > This patch makes mpath_presistent_reserve_{in,out} go back to using
> > local variables for curmp and pathvec, so that multiple threads won't
> > be operating on these variables at the same time.
> >=20
> > Fixes: a839e39e ("libmpathpersist: factor out initialization and
> > teardown")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> It turns out our CI has caught an actual bug for the first time :-)
>=20
> https://github.com/openSUSE/multipath-tools/runs/1768201417?check_suite_f=
ocus=3Dtrue#step:8:719
>=20
> No need to resubmit, I'll just quickly amend this.


Oops and thanks.

-Ben

>=20
> Regards
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

