Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1ACC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 31 May 2022 08:43:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-z_K2KtRYND--HpTLWnp3bg-1; Tue, 31 May 2022 04:43:13 -0400
X-MC-Unique: z_K2KtRYND--HpTLWnp3bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 603C4833973;
	Tue, 31 May 2022 08:43:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D8B45F245;
	Tue, 31 May 2022 08:43:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E9648194705E;
	Tue, 31 May 2022 08:43:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6505194705C
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 08:43:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95AA12026D2D; Tue, 31 May 2022 08:43:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90A162026D07
 for <dm-devel@redhat.com>; Tue, 31 May 2022 08:43:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 758CE858EED
 for <dm-devel@redhat.com>; Tue, 31 May 2022 08:43:08 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-sqPPQYNTOWOhOshOfWz5vw-1; Tue, 31 May 2022 04:43:04 -0400
X-MC-Unique: sqPPQYNTOWOhOshOfWz5vw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 9749F21C0C;
 Tue, 31 May 2022 08:43:02 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C4ED13AA2;
 Tue, 31 May 2022 08:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 3tYLERbVlWJCeQAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 31 May 2022 08:43:02 +0000
Message-ID: <a008223fcb69037c76fabd3dd5b10e81aa93ba2e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Xose Vazquez Perez
 <xose.vazquez@gmail.com>
Date: Tue, 31 May 2022 10:43:01 +0200
In-Reply-To: <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
 <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
 Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Thu, 2022-05-26 at 20:10 +0000, Schremmer, Steven wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > Sent: Thursday, May 19, 2022 9:47 AM
> > Hi Steve,
> >=20
> > On Thu, 2022-05-19 at 13:18 +0000, Schremmer, Steven wrote:
> > > Martin W,
> > >=20
> > > > Steve,
> > > >=20
> > > > On Wed, 2022-05-18 at 20:24 +0000, Schremmer, Steven wrote:
> > > > >=20
> > > > > Nak. NetApp E-Series only supports these settings in certain
> > > > > configurations, and we prefer to handle it via our
> > > > > installation
> > > > > documentation.
> > > > >=20
> > > >=20
> > > > I don't follow. What harm is done to Netapp if these settings
> > > > are
> > > > included? People can still follow your documentation, the end
> > > > result
> > > > will be the same... no?
> > > >=20
> > > > AFAICS, the only setting above that would only be supported in
> > > > certain
> > > > configurations is PRIO_ANA, without which GROUP_BY_PRIO doesn't
> > > > make
> > > > much sense. If the array is configured not to support ANA, this
> > > > configuration would lead to error messages and PRIO_UNDEF for
> > > > all
> > > > paths, and thus "imply" multibus topology. Not beautiful, but
> > > > also
> > > > no
> > > > big harm done, IMO.
> > > >=20
> > > > If it's that you're concerned about, please provide the set of
> > > > defaults
> > > > you prefer for E-Series, or explictly state that you prefer to
> > > > run
> > > > with
> > > > the generic NVMe defaults (const prio, failover policy).
> > > >=20
> > > > In general, if vendor-recommended settings are strongly
> > > > dependent
> > > > on
> > > > storage configuration, host-side software defaults must try to
> > > > match
> > > > the storage array's defaults. We shoud do this for E-Series,
> > > > too.
> > > > If
> > > > ANA needs to be explicitly enabled on the array by the admin,
> > > > we
> > > > shouldn't enable it by default; but otherwise, we should.
> > > >=20
> > > > Martin
> > >=20
> > > NVMe-attached E-Series is moving towards only using the native
> > > NVMe
> > > multipathing in the kernel rather than DM-MP with NVMe. At some
> > > point
> > > we will stop interoperability testing with NVMe DM-MP and not
> > > certify
> > > new
> > > solutions with it.
> > >=20
> > > The set of defaults listed for NVMe E-Series are the correct
> > > ones,
> > > but I'm not sure
> > > they should be included if we aren't going to continue to test
> > > the
> > > interoperability
> > > of NVMe-attached E-Series and DM-MP.
> >=20
> > Thanks for the explanation.
> >=20
> > I believe everyone understands that the fact that the built-in
> > hwtable
> > in multipath-tools contains sensible defaults for a given storage
> > array
> > does *not* imply that this array has been tested or officially
> > released
> > by Netapp (or any storage vendor). If you want, we can add a
> > statement
> > of this kind (vendor-neutral) to our man page and/or README.
> >=20
> > It's also understood that Netapp, like the kernel community,
> > recommends
> > native multipathing for NVMe, and discourages use of device-mapper
> > multipath for NVMe devices. Native multipathing is the kernel
> > default,
> > and must be explicitly disabled either at build time or on the
> > kernel
> > command line before dm-multipath would even see the devices. IMO it
> > can
> > be assumed that a user who employs such a setup knows what she's
> > doing,
> > and is aware that the setup doesn't comply with common
> > recommendations.
> >=20
> > Netapp currently publishes configuration recommendations for
> > multipath-
> > tools with E-Series and NVMe. Xose's patch simply changes the
> > built-in
> > defaults to match these recommendations. We have been doing this
> > for
> > years with the intention to improve the "out of the box"
> > experience,
> > and it's a good thing.
> >=20
> > If we didn't take this patch, we'd knowingly force suboptimal
> > default
> > settings on (admittedly few) users. Who would benefit from that?
> >=20
> > We want to ship multipath-tools with the most reasonable defaults
> > that
> > we are aware of. Xose's continued efforts in this area have been
> > immensely useful for the community of dm-multipath users. I don't
> > think
> > we should give this up. I'd like to encourage everyone to continue
> > submitting improvements for the hardware table.
> >=20
> > Regards,
> > Martin
> >=20
>=20
> Martin,
>=20
> Sorry for being slow to respond to this. NetApp publishes settings
> for
> multipath-tools for NVMe-attach E-Series for specific distribution
> versions
> that we have qualified. Anyone using these settings outside of these
> versions would NOT be in a valid system configuration for NetApp
> support.=A0

Anyone using wrong or suboptimal settings on an unsupported
distribution would also NOT be a valid configuration for NetApp
support, right? But they'd be more likely to call support.

> Are
> reasonable defaults in the hardware table really useful if they cause
> a user
> to follow a path that leads them to an unsupported system
> configuration?

Do you have any evidence that such an hardware table entry would
"cause" users to follow this path? I have to say it sounds far-fetched
to me. People who buy NetApp storage should have evaluated the system
requirements and support restrictions beforehand. If they decide to use
an unsupported distribution nonetheless, they will have strong reasons,
and won't be deterred by wrong defaults in multipath-tools. Rather,
they'll look up the settings in your manuals and configure them
manually. If they call NetApp support, support engineers can still ask
them to reproduce their issue in a supported environment.

AFAIU, NetApp doesn't support using upstream multipath-tools at all.
Should we consequently just drop all settings for NetApp storage and
OEMs from the upstream code base? You're certainly aware that distros
like RHEL or SLES get their default settings through upstream, which is
a good thing. Without good upstream defaults, users of these distros
would need to enter the settings manually in multipath.conf rather than
having reasonable settings applied out of the box. That'd be a serious
deterioration of the user experience.

Regards
Martin

PS: Every Linux user understands that "it works" and "it's supported by
the hardware vendor" are two _very_ different things, simply because
there are so few vendors that support Linux at all. I don't think I
ever had a laptop running an officially supported OS.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

