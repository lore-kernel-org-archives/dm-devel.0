Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C5F3C83F01
	for <dm-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693421078;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q5hrSPGBs7DBVOKblhvyBxJ/OiPP/1OEe08Vit/io+0=;
	b=QQ/iwxtpEaO2olo8JT/2G7Nj0i9ytgPZnNVVeF0WNmyMgDKe9mPOxF/HS71wOfhAM46PoN
	lkXw0vpKJoEvXYtBxEuI5ij6P61AsBZduO/5cuRvSZGVo6tor7IcPsiREUPALsJcAs5vM1
	ea6Tl0zQ5loO1F8dX5/+RQFnEF80k+U=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-ZQMlQRImNgyeMNOd1nR4Bg-1; Wed, 30 Aug 2023 14:44:34 -0400
X-MC-Unique: ZQMlQRImNgyeMNOd1nR4Bg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F05D1C06929;
	Wed, 30 Aug 2023 18:44:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C581E2026D35;
	Wed, 30 Aug 2023 18:44:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8555C1946A43;
	Wed, 30 Aug 2023 18:44:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E38C31946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Aug 2023 18:44:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D363112131B; Wed, 30 Aug 2023 18:44:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82E821121315;
 Wed, 30 Aug 2023 18:44:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 37UIiH4I022764;
 Wed, 30 Aug 2023 13:44:17 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 37UIiHEG022763;
 Wed, 30 Aug 2023 13:44:17 -0500
Date: Wed, 30 Aug 2023 13:44:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230830184416.GI7412@octiron.msp.redhat.com>
References: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
 <5d4d7dea45c20d758a35756f2d3cc1e4f7a0db26.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <5d4d7dea45c20d758a35756f2d3cc1e4f7a0db26.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH 0/4] Make prio timeouts work like checkers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29, 2023 at 08:34:39PM +0000, Martin Wilck wrote:
> On Fri, 2023-07-28 at 14:05 -0500, Benjamin Marzinski wrote:
> > This patchset changes how prioritizers set their timeouts, to make
> > them
> > match how the checker functions work, and also cleans up some minor
> > timeout issues. I did this to make out timeouts consistent, but if
> > someone has a good reason to object to that, I don't feel
> > strongly that it's necessary, and I can resend just the bugfixes.
> >=20
>=20
> I don't object the idea, quite the contrary. But I would prefer a
> different solution.
>=20
> IMO we should treat the "io_timeout" as a path property, and add a
> field  in "struct path" for it. It would be initialized from=A0
> conf->checker_timeout, or if that's unset, from sysfs, and finally,
> DEF_TIMEOUT. By reading the sysfs value, we'd be able to accomodate
> different properties for different devices, but we'd not re-read this
> value repeatedly like we're doing now. IMO that would be more
> consistent with what we do for other device properties.
>=20
> We currently pass the timeout value down the call stack all the way
> from pathinfo() like this (for alua):
>=20
> pathinfo()
>   get_prio()
>      prio_getprio()
>        p->getprio()
>          get_alua_info()
>             get_target_port_group()
>                do_inquiry() (*)
>                  do_inquiry_sg()
>             get_asymmetric_access_state()
>                do_rtpg() (*)
>               =20
> With the exception of the functions marked by (*), all these functions
> obtain a "struct path" argument, too. IIUC, the main reason we're doing
> this is to avoid stalled getprio() calls for paths that are down
> (bb935d4 ("libmultipath: change failed path prio timeout")).
>=20
> IMO it would make more sense to remove the "timeout" arguments from
> these functions, and just determine the timeout where it's needed. I
> don't think that's a layering violation; functions that receive a
> "struct path" can also handle PATH_DOWN. Thus we could write
>=20
> int get_prio_timeout_ms(const struct path *pp)=20
> {
>       if (pp->state =3D=3D PATH_DOWN)
>             return 10;
>       else
>             return pp->io_timeout * 1000;
> }
>=20
> and use this function as far down the stack as we can.
>=20
> Furthermore, to improve code readability and avoid issues like in 3/4
> and 4, I think we should call all variables and fields that take
> millisecond values "timeout_ms".
>=20
> Thoughts?

Sure. I can rework this.

-Ben

>=20
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

