Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1069C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 14:17:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 37998613E9
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 14:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37998613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620829056;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CrWy/SmNWopfaBJkSf4mliU4HlIIbGTSFzbYi4GEvfA=;
	b=L0/Y28tXo4qXroNmyNUdZ2vZ/nTago0ssJioMJ+y/2Vsvs1t024itlpS/TrRZnYEoORd4e
	4amNp0iaKL1x7+HW9kZ6r9CUGRCpePxpMsW7dBCgkVTw951+igA4upDY28zk3QVUMzFMhL
	8mTpFU+bA4B5jdLovzjA+ngte4guQq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-wTNSGVejPfCGQ62kqJ_tfw-1; Wed, 12 May 2021 10:17:34 -0400
X-MC-Unique: wTNSGVejPfCGQ62kqJ_tfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C718107ACE8;
	Wed, 12 May 2021 14:17:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAB2560657;
	Wed, 12 May 2021 14:17:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3C23E1800BB0;
	Wed, 12 May 2021 14:17:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CEHKft003813 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 10:17:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A67662B0B3; Wed, 12 May 2021 14:17:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C8036091A;
	Wed, 12 May 2021 14:17:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14CEHIJi028789; 
	Wed, 12 May 2021 09:17:19 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14CEHIhI028788;
	Wed, 12 May 2021 09:17:18 -0500
Date: Wed, 12 May 2021 09:17:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210512141717.GD25887@octiron.msp.redhat.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-2-git-send-email-bmarzins@redhat.com>
	<27a2802df2338186af82df84a027bc35f756ad00.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <27a2802df2338186af82df84a027bc35f756ad00.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/5] multipathd: don't fail to remove path
 once the map is removed
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, May 12, 2021 at 09:11:01AM +0000, Martin Wilck wrote:
> On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> > In ev_remove_path(), if update_mpp_paths() fails, we delete the
> > entire
> > map. However, since update_mpp_paths() happens before we call
> > set_path_removed(), pp->initialized isn't set to INIT_REMOVED, so
> > remove_map_and_stop_waiter() doesn't remove the path when in removes
> > the
> > map.=A0 But with the map removed, there's nothing to keep us from
> > removing
> > the path.
> >=20
> > Call set_path_removed() before update_mpp_paths() to avoid the odd
> > case
> > of ev_remove_path() removing the map but not the path.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/structs_vec.c |=A0 3 +--
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 13 ++++++++-----
> > =A02 files changed, 9 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index d242c06b..432c0c63 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -45,8 +45,7 @@ int update_mpp_paths(struct multipath *mpp, vector
> > pathvec)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Avoid adding removed paths to the
> > map again
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * when we reload it. Such paths may
> > exist if
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * domap fails in ev_remove_path().
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * when we reload it.
>=20
> I'd like to keep the remark about domap(). It's meant as a reminder for
> us and future developers how this situation is most likely to come to
> pass.

Sure. I just removed it, since we now call update_mpp_paths immediately
after calling set_path_removed(), so it seemed more obvious that we will
run into this situation than it did before, when it only happened if we
first failed in ev_remove_path(). I'm fine with putting it back.

>=20
> Other than that, ACK.
>=20
> Regards,
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

