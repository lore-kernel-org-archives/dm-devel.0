Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33CDC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 14:46:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-BSy0pYR3MrqWCnyHS0WgIA-1; Thu, 19 May 2022 10:46:49 -0400
X-MC-Unique: BSy0pYR3MrqWCnyHS0WgIA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37042101AA42;
	Thu, 19 May 2022 14:46:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE9F5C27E8E;
	Thu, 19 May 2022 14:46:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 83789194705A;
	Thu, 19 May 2022 14:46:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87C651947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 14:46:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6984E1121319; Thu, 19 May 2022 14:46:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 649E71121314
 for <dm-devel@redhat.com>; Thu, 19 May 2022 14:46:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43B99383329E
 for <dm-devel@redhat.com>; Thu, 19 May 2022 14:46:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-d0QOGV0YNWS7AmBRZsbXcQ-1; Thu, 19 May 2022 10:46:39 -0400
X-MC-Unique: d0QOGV0YNWS7AmBRZsbXcQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 3700021B02;
 Thu, 19 May 2022 14:46:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C888C13456;
 Thu, 19 May 2022 14:46:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id SSUdL01YhmIOTwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 19 May 2022 14:46:37 +0000
Message-ID: <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Xose Vazquez Perez
 <xose.vazquez@gmail.com>
Date: Thu, 19 May 2022 16:46:37 +0200
In-Reply-To: <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Steve,

On Thu, 2022-05-19 at 13:18 +0000, Schremmer, Steven wrote:
> Martin W,
> 
> > Steve,
> > 
> > On Wed, 2022-05-18 at 20:24 +0000, Schremmer, Steven wrote:
> > > 
> > > Nak. NetApp E-Series only supports these settings in certain
> > > configurations, and we prefer to handle it via our installation
> > > documentation.
> > > 
> > 
> > I don't follow. What harm is done to Netapp if these settings are
> > included? People can still follow your documentation, the end
> > result
> > will be the same... no?
> > 
> > AFAICS, the only setting above that would only be supported in
> > certain
> > configurations is PRIO_ANA, without which GROUP_BY_PRIO doesn't
> > make
> > much sense. If the array is configured not to support ANA, this
> > configuration would lead to error messages and PRIO_UNDEF for all
> > paths, and thus "imply" multibus topology. Not beautiful, but also
> > no
> > big harm done, IMO.
> > 
> > If it's that you're concerned about, please provide the set of
> > defaults
> > you prefer for E-Series, or explictly state that you prefer to run
> > with
> > the generic NVMe defaults (const prio, failover policy).
> > 
> > In general, if vendor-recommended settings are strongly dependent
> > on
> > storage configuration, host-side software defaults must try to
> > match
> > the storage array's defaults. We shoud do this for E-Series, too.
> > If
> > ANA needs to be explicitly enabled on the array by the admin, we
> > shouldn't enable it by default; but otherwise, we should.
> > 
> > Martin
> 
> NVMe-attached E-Series is moving towards only using the native NVMe
> multipathing in the kernel rather than DM-MP with NVMe. At some point
> we will stop interoperability testing with NVMe DM-MP and not certify
> new
> solutions with it.
> 
> The set of defaults listed for NVMe E-Series are the correct ones,
> but I'm not sure
> they should be included if we aren't going to continue to test the
> interoperability
> of NVMe-attached E-Series and DM-MP.

Thanks for the explanation.

I believe everyone understands that the fact that the built-in hwtable
in multipath-tools contains sensible defaults for a given storage array
does *not* imply that this array has been tested or officially released
by Netapp (or any storage vendor). If you want, we can add a statement
of this kind (vendor-neutral) to our man page and/or README.

It's also understood that Netapp, like the kernel community, recommends
native multipathing for NVMe, and discourages use of device-mapper
multipath for NVMe devices. Native multipathing is the kernel default,
and must be explicitly disabled either at build time or on the kernel
command line before dm-multipath would even see the devices. IMO it can
be assumed that a user who employs such a setup knows what she's doing,
and is aware that the setup doesn't comply with common recommendations.

Netapp currently publishes configuration recommendations for multipath-
tools with E-Series and NVMe. Xose's patch simply changes the built-in
defaults to match these recommendations. We have been doing this for
years with the intention to improve the "out of the box" experience,
and it's a good thing.

If we didn't take this patch, we'd knowingly force suboptimal default
settings on (admittedly few) users. Who would benefit from that?

We want to ship multipath-tools with the most reasonable defaults that
we are aware of. Xose's continued efforts in this area have been
immensely useful for the community of dm-multipath users. I don't think
we should give this up. I'd like to encourage everyone to continue
submitting improvements for the hardware table.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

