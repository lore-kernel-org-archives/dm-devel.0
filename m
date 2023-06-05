Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5020FC7EE23
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685974525;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zgRgudOVGQIM6W2nqVQnEFKLeVYhoD+4aZwLCz3HxWY=;
	b=jJmEKNAGnegGBDctGg/odFXCL6yrSPSIPGH9MCew04I7ScOEr6HBF7G++1kVoQARTpv9Vw
	fhdGatoKzZ/bKN+rryiV7EFYIY8UF+TKGLD01Nu6b1AKeyAW9BC3Rxq2S9NjArBWU8X4eT
	L1HZd/IhexmZUvSe3815e/x5UAz3EE8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-BCET2fCYPm2wYh4GqcPtkA-1; Mon, 05 Jun 2023 10:15:21 -0400
X-MC-Unique: BCET2fCYPm2wYh4GqcPtkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 823C02814279;
	Mon,  5 Jun 2023 14:14:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C912140CFD47;
	Mon,  5 Jun 2023 14:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A777519465A2;
	Mon,  5 Jun 2023 14:14:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 540931946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 14:14:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3398C2166B29; Mon,  5 Jun 2023 14:14:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1057A2166B2A;
 Mon,  5 Jun 2023 14:14:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 355EEnhT019187;
 Mon, 5 Jun 2023 09:14:49 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 355EEmlC019186;
 Mon, 5 Jun 2023 09:14:48 -0500
Date: Mon, 5 Jun 2023 09:14:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230605141448.GQ24096@octiron.msp.redhat.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-6-git-send-email-bmarzins@redhat.com>
 <a84a184d9e7624a6377ecfcab4d9f7c01d06d975.camel@suse.com>
 <20230601181718.GO24096@octiron.msp.redhat.com>
 <f574d942e8d4994689f3ca688cb2ee9bbe2b16fc.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <f574d942e8d4994689f3ca688cb2ee9bbe2b16fc.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: add "detect_pgpolicy"
 config option
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 02, 2023 at 06:16:08PM +0200, Martin Wilck wrote:
> On Thu, 2023-06-01 at 13:17 -0500, Benjamin Marzinski wrote:
> > On Wed, May 31, 2023 at 03:44:58PM +0000, Martin Wilck wrote:
> > > On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> > > > This allows configuations to use "group_by_tpg" if alua is
> > > > autodetected
> > > > and another policy if it isn't, so they can work with
> > > > detect_prio.
> > >=20
> > > This is a bit confusing. We might have introduced this kind of
> > > autodetection without group_by_tpg; using group_by_prio for arrays
> > > with
> > > ALUA support would have made quite a bit of sense.
> >=20
> > I guess that all depends on what the autodetection is for.=A0 If the
> > goal
> > for ALUA autodetection is to make it possible to write configs that
> > support arrays which have an optional ALUA mode, then I don't think
> > this
> > is necessary.=A0 All those arrays should be configured with
> > group_by_prio,
> > regardless of whether or not they are in ALUA mode.
>=20
> Hm, but are they, really? Xose has changed some defaults from multibus
> to group_by_prio lately, but I am not sure if that covers all. If we
> set group_by_prio automatically without ALUA, we'd probably end up
> effectively with MULTIBUS always, as the prio would likely be constant.
> But some arrays would prefer FAILOVER, I suppose, perhaps even some of
> those with optional ALUA? I am not sure. But this is what really
> matters: whether the array should work in active-active or active-
> passive mode when there is no ALUA to detect it.

There are no builtin device configs that set path grouping policy to
FAILOVER. Out of all our builtin configs, the only SCSI one that doesn't
specifically set the path grouping policy is the IBM 3303 NVDISK and I
don't believe that one supports ALUA. I don't know of any vendor who
wants to have a builtin device config for their array, but can't write
an optimal one because they need a different pgpolicy depending on
whether ALUA is or isn't present. So all I was saying is that I don't
think having detect_pgplicy would enable us to add new builtin configs
for arrays that we couldn't handle correctly in all cases before.=20

I do agree that there are likely people who don't bother to edit
multipath.conf for their device, and multipath autodetects alua but
still uses FAILOVER, when it would be better for it to use
GROUP_BY_PRIO. That's why I think your proposal is a good one.
=20
> > But we've moved more towards adding autodetection to make multipath
> > work
> > correctly, even without a config for a specific array. In this case,
> > yes, if we autodetect ALUA, if would be nice if we could
> > automatically set group_by_prio.
> >=20
> > > What this patch really does is to make multipath-tools prefer
> > > group_by_tpg over group_by_prio if it finds that ALUA is
> > > supported.=A0
> > > Should this be a separate option, perhaps?
> > >=20
> > > =A0- detect_pgpolicy: use an ALUA-based pgpolicy if available
> > > =A0- detect_pgpolicy_prefer_tpg: prefer group_by_tpg over
> > > group_by_prio
> > > =A0=A0 for arrays supporting ALUA.
> > >=20
> > > This way users could benefit from ALUA autodetection without
> > > switching
> > > to the TPG algorithm automatically.
> >=20
> > Sure. Lets go with that. I'll respin this.
>=20
> Perhaps you can come up with a better name than
> "detect_pgpolicy_prefer_tpg" :-)
>=20
> To make sure we're on the same boat:
>=20
>  - detect_pgpolicy defaults to ON
>  - detect_pgpolicy_prefer_tpg defaults to OFF for now.
>=20
> Right?
>=20

Right.

> > > Or do we have good arguments that group_by_tpg is always "better"
> > > than
> > > group_by_prio if ALUA is supported? I guess it might be, but it
> > > still
> > > needs to prove its usefulness it practice.
> >=20
> > I would also rather it proved itself first. That's why I had it
> > disabled
> > by default. We can always switch the default later.
> >=20
> > > Also, if we add the auto-detection feature, I think it should
> > > default
> > > to ON, at least upstream.
> >=20
> > I don't know of any case where you would need FAILOVER, when you have
> > an
> > ALUA device.=A0 I can imagine someone wanting to be able to turn off
> > load-balancing, but I think it makes sense to enable this by default
> > upstream.
>=20
> I expect that active-passive arrays would use STANDBY state for the
> passive side, or at least NON-OPTIMIZED. This would effectively be a
> failover mode. Anyway, it'll be possible to deactivate the
> autodetection. That's kind of awkward for users, as we now from
> detect_checker etc., but it works, and fits the way we did this for
> other options.
>=20
> Regards
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

