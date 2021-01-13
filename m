Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93898C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 17:10:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B29972339F
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 17:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B29972339F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610557829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MV6K81P5bjjETeHoQuJDq+1lAbWhbpYmoG5ihVRzDyo=;
	b=DDQPdUi0lnMiLuDCO4C0kS6Kix670ks4a7UM+wlsMhBKqCcdShXnX1gkYvaTQwyqv2vUpl
	/RWUabENUhFGDKKQtV3WRthEUzTdzV5w/PtF1Tg4VNi/brHmwRapuLjyNEzXX7MLkKH7sa
	Cmlq3tPmRS7Sx3zL0hK8gfWCKXA7aRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-cE4lC2CHP4WsAA4tMUU8-g-1; Wed, 13 Jan 2021 12:10:27 -0500
X-MC-Unique: cE4lC2CHP4WsAA4tMUU8-g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2008518C8C00;
	Wed, 13 Jan 2021 17:10:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B73719C47;
	Wed, 13 Jan 2021 17:10:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C8D71809C9F;
	Wed, 13 Jan 2021 17:10:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DH9mfg003396 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 12:09:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4EFF219934; Wed, 13 Jan 2021 17:09:48 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDAAE19C47;
	Wed, 13 Jan 2021 17:09:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10DH9gju013529; 
	Wed, 13 Jan 2021 11:09:42 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10DH9faP013528;
	Wed, 13 Jan 2021 11:09:41 -0600
Date: Wed, 13 Jan 2021 11:09:41 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210113170941.GY3103@octiron.msp.redhat.com>
References: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
	<d4899abd850929066473f4165940d431f20fa6e1.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d4899abd850929066473f4165940d431f20fa6e1.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] Multipath io_err_stat fixes
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2021 at 11:45:55AM +0000, Martin Wilck wrote:
> On Tue, 2021-01-12 at 17:52 -0600, Benjamin Marzinski wrote:
> > I found an ABBA deadlock in the io_err_stat marginal path code, and
> > in
> > the process of fixing it, noticed a potential crash on shutdown. This
> > patchset addresses both of the issues.
> >=20
> > Benjamin Marzinski (3):
> > =A0 libmultipath: make find_err_path_by_dev() static
> > =A0 multipathd: avoid io_err_stat crash during shutdown
> > =A0 multipathd: avoid io_err_stat ABBA deadlock
> >=20
> > =A0libmultipath/io_err_stat.c | 159 +++++++++++++++++------------------
> > --
> > =A01 file changed, 73 insertions(+), 86 deletions(-)
> >=20
>=20
> Thanks, the series looks good, I have only minor nits.
>=20
> I've made some remarks about the io_err_stat code in the review. While
> you're working at it, would you be willing to fix those issues too?

Sure. I'll send out a v2 patchset that addresses all your issues.

-Ben

>=20
> Cheers,
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

