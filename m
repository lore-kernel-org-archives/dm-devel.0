Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78785C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 20:12:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E112E617ED
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 20:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E112E617ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617048740;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AJy0YnHsb+YLAouEkLkTbLMkLfwTTODJWVmWz1+we6k=;
	b=MEM5v+OcHgyK/PMAmiTB4jo3gbonDNB5FQY2HThKHHsgoz6SH09GX2ZiafDT+nHESiMPqn
	7xhLgJUd3uOO6EvoP2P2tKnH1aR3/bWz5zw68LixFQWMLwIHXLQBYNBkt4kHNjVOCA27qL
	pmlLlK/YW5s7M8b9Y0/C1gWnI84NIYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-DLnHLaY2ML-K8pRw7AzA5Q-1; Mon, 29 Mar 2021 16:12:18 -0400
X-MC-Unique: DLnHLaY2ML-K8pRw7AzA5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41BCB80063;
	Mon, 29 Mar 2021 20:12:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DDDC5D768;
	Mon, 29 Mar 2021 20:12:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DCD11809C83;
	Mon, 29 Mar 2021 20:12:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12TK9oKn015219 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 16:09:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5BF2590A01; Mon, 29 Mar 2021 20:09:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 702FC50455;
	Mon, 29 Mar 2021 20:09:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12TK9jdF004107; 
	Mon, 29 Mar 2021 15:09:46 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12TK9jwc004106;
	Mon, 29 Mar 2021 15:09:45 -0500
Date: Mon, 29 Mar 2021 15:09:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210329200945.GL15006@octiron.msp.redhat.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-3-git-send-email-bmarzins@redhat.com>
	<1088f960e04492a26530385040b2485b3691c94e.camel@suse.com>
	<20210327021853.GI15006@octiron.msp.redhat.com>
	<31162621ac38601976bfa51db92989471fd4c23e.camel@suse.com>
	<20210329182033.GJ15006@octiron.msp.redhat.com>
	<facc763d175793d4d21822f8880522574364680a.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <facc763d175793d4d21822f8880522574364680a.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH 2/4] libmultipath: fix priorities in
	parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2021 at 07:08:14PM +0000, Martin Wilck wrote:
> On Mon, 2021-03-29 at 13:20 -0500, Benjamin Marzinski wrote:
> > >=20
> > > multipathd could figure out the system configuration from the (non)
> > > availability of certain properties, and use an appropriate fallback
> > > logic for either case.
> >=20
> > That seems like reasonable first step, although one that won't help
> > SID,
> > since it can't rely on getting the wwid from udev.=A0
>=20
> Can you conceive of a different approach that would be better for SID?
> I'd like to hear about it.

I assume that we will continue to have a fallback function to get the
wwid, that will get the proper wwid. As long as you are O.k. with
multipath autodetecting if SID is running, it can just continue to use
the fallback method, so this should be fine.

> >  This actually brings
> > up a different point I have. Is your main objection to adding more
> > config options that it is complicating the code, or confusing the
> > users?
>=20
> Both, with emphasis on the latter. I'm quite positive that we have too
> many options already. That doesn't mean I would generally oppose new
> options if they make sense. We should rather try to get rid of some new
> ones that nobody uses any more.
>=20
> > Because multipath wouldn't need to add any configuration options to
> > be
> > easily usable with SID (the current workaround, setting uid_attribute
> > to
> > "", is pretty non-obvious to users) if it could just check if sid was
> > running, and key off that.=A0 However this adds even more code
> > complexity
> > than simply checking a config option. I don't know how you would feel
> > about accepting a patch that does this, when SID is production ready.
>=20
> I could live well with this autodetection. I think it would be better
> than doing the same thing with a configuration options.
>=20
> Regards,
> Martin
>=20
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

