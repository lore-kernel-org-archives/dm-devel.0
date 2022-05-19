Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15289C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 09:30:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-kOL-BKS7OdWUTN2NARy7dQ-1; Thu, 19 May 2022 05:30:29 -0400
X-MC-Unique: kOL-BKS7OdWUTN2NARy7dQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BB8A3C1E32F;
	Thu, 19 May 2022 09:30:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46ADF1121314;
	Thu, 19 May 2022 09:30:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E103A194975B;
	Thu, 19 May 2022 09:30:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C2E61947B91
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 09:30:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 398452166B2F; Thu, 19 May 2022 09:30:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 34EEA2166B26
 for <dm-devel@redhat.com>; Thu, 19 May 2022 09:30:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 176DC381079B
 for <dm-devel@redhat.com>; Thu, 19 May 2022 09:30:25 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-bLfxWIzlOKq9toGhAXUQ-Q-1; Thu, 19 May 2022 05:30:23 -0400
X-MC-Unique: bLfxWIzlOKq9toGhAXUQ-Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id F359E1F7AB;
 Thu, 19 May 2022 09:30:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A398413AF8;
 Thu, 19 May 2022 09:30:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Em0kJi0OhmKVLgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 19 May 2022 09:30:21 +0000
Message-ID: <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Xose Vazquez Perez
 <xose.vazquez@gmail.com>
Date: Thu, 19 May 2022 11:30:20 +0200
In-Reply-To: <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Cc: ng-eseries-upstream-maintainers
 <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Steve,

On Wed, 2022-05-18 at 20:24 +0000, Schremmer, Steven wrote:
> > From: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> > =A0libmultipath/hwtable.c | 9 +++++++++
> > =A01 file changed, 9 insertions(+)
> >=20
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 814e727a..61a5aa16 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -845,6 +845,15 @@ static struct hwentry default_hw[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .pgpolicy=A0=A0=A0=A0=A0 =
=3D MULTIBUS,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .no_path_retry =3D NO_PAT=
H_RETRY_QUEUE,
> > =A0=A0=A0=A0=A0=A0=A0 },
> > +=A0=A0=A0=A0=A0=A0 {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* E-Series NVMe */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "NVME",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .product=A0=A0=A0=A0=A0=A0 =
=3D "NetApp E-Series",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .prio_name=A0=A0=A0=A0 =3D =
PRIO_ANA,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .pgfailback=A0=A0=A0 =3D -F=
AILBACK_IMMEDIATE,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .no_path_retry =3D 30,
> > +=A0=A0=A0=A0=A0=A0 },
> > =A0=A0=A0=A0=A0=A0=A0 /*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * NEC
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > --
> > 2.36.1
>=20
> Nak. NetApp E-Series only supports these settings in certain
> configurations, and we prefer to handle it via our installation
> documentation.
>=20

I don't follow. What harm is done to Netapp if these settings are
included? People can still follow your documentation, the end result
will be the same... no?

AFAICS, the only setting above that would only be supported in certain
configurations is PRIO_ANA, without which GROUP_BY_PRIO doesn't make
much sense. If the array is configured not to support ANA, this
configuration would lead to error messages and PRIO_UNDEF for all
paths, and thus "imply" multibus topology. Not beautiful, but also no
big harm done, IMO.=20

If it's that you're concerned about, please provide the set of defaults
you prefer for E-Series, or explictly state that you prefer to run with
the generic NVMe defaults (const prio, failover policy).

In general, if vendor-recommended settings are strongly dependent on
storage configuration, host-side software defaults must try to match
the storage array's defaults. We shoud do this for E-Series, too. If
ANA needs to be explicitly enabled on the array by the admin, we
shouldn't enable it by default; but otherwise, we should.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

