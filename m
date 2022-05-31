Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0B6C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 31 May 2022 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654016748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HXw9bCvyhLBwOJRAKjmMdTEEY1FM1kGZoc7XHsyXh4s=;
	b=JpEXexnAr9j6Ip2Um7VAFr2JpNS45T08jqhrEJ1W1YovXPAi8O7WJXKBdRqfb5hoF/NR1T
	zif17E3nlMLNKpJVhVHmJL4KuCDjo9nSZszz1J5rekJac5d/iAXvRpoils73GEGcymTqoy
	THO6Cn/8efIzwZ2dJxGnw77acjEyYlU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-101sy5TjMbGxKA8zP4vHbQ-1; Tue, 31 May 2022 13:05:45 -0400
X-MC-Unique: 101sy5TjMbGxKA8zP4vHbQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B916100BAA1;
	Tue, 31 May 2022 17:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0C72492C3B;
	Tue, 31 May 2022 17:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F6B21947062;
	Tue, 31 May 2022 17:05:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 54B721947065
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 17:05:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FCFF1410F36; Tue, 31 May 2022 17:05:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22C381410DDB;
 Tue, 31 May 2022 17:05:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 24VH5cZK032484;
 Tue, 31 May 2022 12:05:38 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 24VH5bEO032483;
 Tue, 31 May 2022 12:05:37 -0500
Date: Tue, 31 May 2022 12:05:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220531170537.GN5254@octiron.msp.redhat.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
 <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
 <a008223fcb69037c76fabd3dd5b10e81aa93ba2e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <a008223fcb69037c76fabd3dd5b10e81aa93ba2e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George, Martin" <Martin.George@netapp.com>,
 Hannes Reinecke <hare@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 "Schremmer, Steven" <Steve.Schremmer@netapp.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2022 at 10:43:01AM +0200, Martin Wilck wrote:
> Hi Steve,
>=20
> On Thu, 2022-05-26 at 20:10 +0000, Schremmer, Steven wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > > Sent: Thursday, May 19, 2022 9:47 AM
> > > Hi Steve,
> > >=20
> > > On Thu, 2022-05-19 at 13:18 +0000, Schremmer, Steven wrote:
> > > > Martin W,
> > > >=20
> > > > > Steve,
> > > > >=20
> > > > > On Wed, 2022-05-18 at 20:24 +0000, Schremmer, Steven wrote:
> > > > > >=20
> > > > > > Nak. NetApp E-Series only supports these settings in certain
> > > > > > configurations, and we prefer to handle it via our
> > > > > > installation
> > > > > > documentation.
> > > > > >=20
> > > > >=20
> > > > > I don't follow. What harm is done to Netapp if these settings
> > > > > are
> > > > > included? People can still follow your documentation, the end
> > > > > result
> > > > > will be the same... no?
> > > > >=20
> > > > > AFAICS, the only setting above that would only be supported in
> > > > > certain
> > > > > configurations is PRIO_ANA, without which GROUP_BY_PRIO doesn't
> > > > > make
> > > > > much sense. If the array is configured not to support ANA, this
> > > > > configuration would lead to error messages and PRIO_UNDEF for
> > > > > all
> > > > > paths, and thus "imply" multibus topology. Not beautiful, but
> > > > > also
> > > > > no
> > > > > big harm done, IMO.
> > > > >=20
> > > > > If it's that you're concerned about, please provide the set of
> > > > > defaults
> > > > > you prefer for E-Series, or explictly state that you prefer to
> > > > > run
> > > > > with
> > > > > the generic NVMe defaults (const prio, failover policy).
> > > > >=20
> > > > > In general, if vendor-recommended settings are strongly
> > > > > dependent
> > > > > on
> > > > > storage configuration, host-side software defaults must try to
> > > > > match
> > > > > the storage array's defaults. We shoud do this for E-Series,
> > > > > too.
> > > > > If
> > > > > ANA needs to be explicitly enabled on the array by the admin,
> > > > > we
> > > > > shouldn't enable it by default; but otherwise, we should.
> > > > >=20
> > > > > Martin
> > > >=20
> > > > NVMe-attached E-Series is moving towards only using the native
> > > > NVMe
> > > > multipathing in the kernel rather than DM-MP with NVMe. At some
> > > > point
> > > > we will stop interoperability testing with NVMe DM-MP and not
> > > > certify
> > > > new
> > > > solutions with it.
> > > >=20
> > > > The set of defaults listed for NVMe E-Series are the correct
> > > > ones,
> > > > but I'm not sure
> > > > they should be included if we aren't going to continue to test
> > > > the
> > > > interoperability
> > > > of NVMe-attached E-Series and DM-MP.
> > >=20
> > > Thanks for the explanation.
> > >=20
> > > I believe everyone understands that the fact that the built-in
> > > hwtable
> > > in multipath-tools contains sensible defaults for a given storage
> > > array
> > > does *not* imply that this array has been tested or officially
> > > released
> > > by Netapp (or any storage vendor). If you want, we can add a
> > > statement
> > > of this kind (vendor-neutral) to our man page and/or README.
> > >=20
> > > It's also understood that Netapp, like the kernel community,
> > > recommends
> > > native multipathing for NVMe, and discourages use of device-mapper
> > > multipath for NVMe devices. Native multipathing is the kernel
> > > default,
> > > and must be explicitly disabled either at build time or on the
> > > kernel
> > > command line before dm-multipath would even see the devices. IMO it
> > > can
> > > be assumed that a user who employs such a setup knows what she's
> > > doing,
> > > and is aware that the setup doesn't comply with common
> > > recommendations.
> > >=20
> > > Netapp currently publishes configuration recommendations for
> > > multipath-
> > > tools with E-Series and NVMe. Xose's patch simply changes the
> > > built-in
> > > defaults to match these recommendations. We have been doing this
> > > for
> > > years with the intention to improve the "out of the box"
> > > experience,
> > > and it's a good thing.
> > >=20
> > > If we didn't take this patch, we'd knowingly force suboptimal
> > > default
> > > settings on (admittedly few) users. Who would benefit from that?
> > >=20
> > > We want to ship multipath-tools with the most reasonable defaults
> > > that
> > > we are aware of. Xose's continued efforts in this area have been
> > > immensely useful for the community of dm-multipath users. I don't
> > > think
> > > we should give this up. I'd like to encourage everyone to continue
> > > submitting improvements for the hardware table.
> > >=20
> > > Regards,
> > > Martin
> > >=20
> >=20
> > Martin,
> >=20
> > Sorry for being slow to respond to this. NetApp publishes settings
> > for
> > multipath-tools for NVMe-attach E-Series for specific distribution
> > versions
> > that we have qualified. Anyone using these settings outside of these
> > versions would NOT be in a valid system configuration for NetApp
> > support.=A0
>=20
> Anyone using wrong or suboptimal settings on an unsupported
> distribution would also NOT be a valid configuration for NetApp
> support, right? But they'd be more likely to call support.
>=20
> > Are
> > reasonable defaults in the hardware table really useful if they cause
> > a user
> > to follow a path that leads them to an unsupported system
> > configuration?
>=20
> Do you have any evidence that such an hardware table entry would
> "cause" users to follow this path? I have to say it sounds far-fetched
> to me. People who buy NetApp storage should have evaluated the system
> requirements and support restrictions beforehand. If they decide to use
> an unsupported distribution nonetheless, they will have strong reasons,
> and won't be deterred by wrong defaults in multipath-tools. Rather,
> they'll look up the settings in your manuals and configure them
> manually. If they call NetApp support, support engineers can still ask
> them to reproduce their issue in a supported environment.
>=20
> AFAIU, NetApp doesn't support using upstream multipath-tools at all.
> Should we consequently just drop all settings for NetApp storage and
> OEMs from the upstream code base? You're certainly aware that distros
> like RHEL or SLES get their default settings through upstream, which is
> a good thing. Without good upstream defaults, users of these distros
> would need to enter the settings manually in multipath.conf rather than
> having reasonable settings applied out of the box. That'd be a serious
> deterioration of the user experience.

With RHEL-9 and going forward, RHEL is recommending and defaulting to
using native multipathing for NVMe devices over dm-multipathing. That
means that people who use dm-multipath for these devices will already
actively be making the decision to not use the recommended settings.

We don't make any claims that the multipath.conf defaults have any
official support. We have always included default configs that have no
official blessing from their vendors. The goal is to give the average
user a good starting point for configuring their system.  If you do have
an official recommened dm-multipath configuration, we will certainly use
that. But if there simply isn't any recommended config because you don't
recommend that people use dm-multipath, then I don't see the harm in
providing "reasonable defaults" (as the multipath.conf man page calls
them) to the users that make the choice to use dm-multipath for NVMe
devices.

- Ben

> Regards
> Martin
>=20
> PS: Every Linux user understands that "it works" and "it's supported by
> the hardware vendor" are two _very_ different things, simply because
> there are so few vendors that support Linux at all. I don't think I
> ever had a laptop running an officially supported OS.
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

