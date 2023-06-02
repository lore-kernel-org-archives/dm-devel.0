Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0364C7EE24
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685722580;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=86jtEW7je2cU6bIEP6iucWlYxzTtHMLXCRzgjneMSIE=;
	b=TaVmW/Kzzs0XMOLzRpXaPqvcJwHEegyNBgv/Rcf1w0hHmAZvbCnaBvhvwsX5mPAx6sIBj5
	YDDVJlmd9U/GBAPkeSKodzwxaraQSn+0i8XmewkbXTBGQNRBlID0OfHmw9dqBhLFcg8kIx
	s1unfibtch7yekPaItnvNAHpG/HvmwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-DKYK1ps8Pzm52xP9R3RILQ-1; Fri, 02 Jun 2023 12:16:17 -0400
X-MC-Unique: DKYK1ps8Pzm52xP9R3RILQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF3A7101A55C;
	Fri,  2 Jun 2023 16:16:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D641492B00;
	Fri,  2 Jun 2023 16:16:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48C001946595;
	Fri,  2 Jun 2023 16:16:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CDE77194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 16:16:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD86140CFD46; Fri,  2 Jun 2023 16:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B67C340CFD45
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 16:16:12 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96EF81C05145
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 16:16:12 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-OOZV2PQNOWuwCco6GasZ_Q-1; Fri,
 02 Jun 2023 12:16:10 -0400
X-MC-Unique: OOZV2PQNOWuwCco6GasZ_Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 37BC31FDEE;
 Fri,  2 Jun 2023 16:16:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0508133E6;
 Fri,  2 Jun 2023 16:16:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id l0yXOMgVemRlBQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 02 Jun 2023 16:16:08 +0000
Message-ID: <f574d942e8d4994689f3ca688cb2ee9bbe2b16fc.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
 <xose.vazquez@gmail.com>
Date: Fri, 02 Jun 2023 18:16:08 +0200
In-Reply-To: <20230601181718.GO24096@octiron.msp.redhat.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-6-git-send-email-bmarzins@redhat.com>
 <a84a184d9e7624a6377ecfcab4d9f7c01d06d975.camel@suse.com>
 <20230601181718.GO24096@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-06-01 at 13:17 -0500, Benjamin Marzinski wrote:
> On Wed, May 31, 2023 at 03:44:58PM +0000, Martin Wilck wrote:
> > On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> > > This allows configuations to use "group_by_tpg" if alua is
> > > autodetected
> > > and another policy if it isn't, so they can work with
> > > detect_prio.
> >=20
> > This is a bit confusing. We might have introduced this kind of
> > autodetection without group_by_tpg; using group_by_prio for arrays
> > with
> > ALUA support would have made quite a bit of sense.
>=20
> I guess that all depends on what the autodetection is for.=A0 If the
> goal
> for ALUA autodetection is to make it possible to write configs that
> support arrays which have an optional ALUA mode, then I don't think
> this
> is necessary.=A0 All those arrays should be configured with
> group_by_prio,
> regardless of whether or not they are in ALUA mode.

Hm, but are they, really? Xose has changed some defaults from multibus
to group_by_prio lately, but I am not sure if that covers all. If we
set group_by_prio automatically without ALUA, we'd probably end up
effectively with MULTIBUS always, as the prio would likely be constant.
But some arrays would prefer FAILOVER, I suppose, perhaps even some of
those with optional ALUA? I am not sure. But this is what really
matters: whether the array should work in active-active or active-
passive mode when there is no ALUA to detect it.

> But we've moved more towards adding autodetection to make multipath
> work
> correctly, even without a config for a specific array. In this case,
> yes, if we autodetect ALUA, if would be nice if we could
> automatically set group_by_prio.
>=20
> > What this patch really does is to make multipath-tools prefer
> > group_by_tpg over group_by_prio if it finds that ALUA is
> > supported.=A0
> > Should this be a separate option, perhaps?
> >=20
> > =A0- detect_pgpolicy: use an ALUA-based pgpolicy if available
> > =A0- detect_pgpolicy_prefer_tpg: prefer group_by_tpg over
> > group_by_prio
> > =A0=A0 for arrays supporting ALUA.
> >=20
> > This way users could benefit from ALUA autodetection without
> > switching
> > to the TPG algorithm automatically.
>=20
> Sure. Lets go with that. I'll respin this.

Perhaps you can come up with a better name than
"detect_pgpolicy_prefer_tpg" :-)

To make sure we're on the same boat:

 - detect_pgpolicy defaults to ON
 - detect_pgpolicy_prefer_tpg defaults to OFF for now.

Right?

> > Or do we have good arguments that group_by_tpg is always "better"
> > than
> > group_by_prio if ALUA is supported? I guess it might be, but it
> > still
> > needs to prove its usefulness it practice.
>=20
> I would also rather it proved itself first. That's why I had it
> disabled
> by default. We can always switch the default later.
>=20
> > Also, if we add the auto-detection feature, I think it should
> > default
> > to ON, at least upstream.
>=20
> I don't know of any case where you would need FAILOVER, when you have
> an
> ALUA device.=A0 I can imagine someone wanting to be able to turn off
> load-balancing, but I think it makes sense to enable this by default
> upstream.

I expect that active-passive arrays would use STANDBY state for the
passive side, or at least NON-OPTIMIZED. This would effectively be a
failover mode. Anyway, it'll be possible to deactivate the
autodetection. That's kind of awkward for users, as we now from
detect_checker etc., but it works, and fits the way we did this for
other options.

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

