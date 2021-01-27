Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D7AC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 01:17:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D4C09205F4
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 01:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4C09205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611710241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ERtwRnqS18pQcUKBD1Hpeht5xpg8wKNBR0/K//3w7LU=;
	b=Ii43hNyXSKVNeVPcXRLQhweKKD7mJz3cAan9hFYay5mWWBKpiMtiakNiFcqF2N5TpOGtFa
	63fpwL8OgSK4hyJL2ZdAcHc53hCgHO+df1XmCmbG296mzJFnSCtFodrY4ooRzXveLamBpS
	Gh/uok4tCt2zK8/kFjiOe41mNpG9GPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-1xR_8SCJOcaHdjMlE7gDCA-1; Tue, 26 Jan 2021 20:17:19 -0500
X-MC-Unique: 1xR_8SCJOcaHdjMlE7gDCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78408801817;
	Wed, 27 Jan 2021 01:17:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0696960871;
	Wed, 27 Jan 2021 01:17:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DBCE14BB7B;
	Wed, 27 Jan 2021 01:17:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10R1GuZH005584 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 20:16:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 40BBE5D9D5; Wed, 27 Jan 2021 01:16:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C9495D9C6;
	Wed, 27 Jan 2021 01:16:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10R1Gp5W014461; 
	Tue, 26 Jan 2021 19:16:52 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10R1GpqX014460;
	Tue, 26 Jan 2021 19:16:51 -0600
Date: Tue, 26 Jan 2021 19:16:50 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210127011650.GH15006@octiron.msp.redhat.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-6-git-send-email-bmarzins@redhat.com>
	<2bda2d5b184bf72cbd63ccdcd7d63404c5414ce5.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <2bda2d5b184bf72cbd63ccdcd7d63404c5414ce5.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/6] multipathd: Fix multipathd stopping on
	shutdown
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18, 2020 at 11:31:25PM +0000, Martin Wilck wrote:
> On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> > According to man "systemd.special"
> >=20
> > "shutdown.target: ... Services that shall be terminated on system
> > shutdown shall add Conflicts=3D and Before=3D dependencies to this unit
> > for
> > their service unit, which is implicitly done when
> > DefaultDependencies=3Dyes is set (the default)."
> >=20
> > multipathd.service sets DefaultDependencies=3Dno and includes the
> > Conflits=3D dependency, but not the Before=3D one. This can cause
> > multipathd
> > to continue running past when it is supposed to during shutdown.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin, I noticed that this commit didn't make it into your queue
branch. I assume it's just an oversight. Right?

-Ben

>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

