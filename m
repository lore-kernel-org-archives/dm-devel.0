Return-Path: <SRS0=RkM6=LB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D71C47082
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 13:38:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B9AA661185
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 13:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9AA661185
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-kx7FIVZuNDOGBxURwVr9oQ-1; Mon, 07 Jun 2021 09:38:35 -0400
X-MC-Unique: kx7FIVZuNDOGBxURwVr9oQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA6B581840D;
	Mon,  7 Jun 2021 13:38:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1C745D9C0;
	Mon,  7 Jun 2021 13:38:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 847821800BB8;
	Mon,  7 Jun 2021 13:38:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 157DboLb001346 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Jun 2021 09:37:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 61D0621602B1; Mon,  7 Jun 2021 13:37:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CCCA21602B5
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 13:37:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82C2685828E
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 13:37:47 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-wCceMjrgMbeuBHJ34aBbnQ-1; Mon, 07 Jun 2021 09:37:43 -0400
X-MC-Unique: wCceMjrgMbeuBHJ34aBbnQ-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D573421A9C;
	Mon,  7 Jun 2021 13:37:41 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id A18EB118DD;
	Mon,  7 Jun 2021 13:37:41 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id Cir4JSUhvmC8KAAALh3uQQ
	(envelope-from <mwilck@suse.com>); Mon, 07 Jun 2021 13:37:41 +0000
Message-ID: <92f37b0d2132cd38f81fff38e24ff05beb1f6024.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 07 Jun 2021 15:37:41 +0200
In-Reply-To: <20210604230145.9887-1-xose.vazquez@gmail.com>
References: <20210604230145.9887-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.40.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 157DboLb001346
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] multipath-tools: add info about HPE
 Alletra 6000 and 9000
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sa, 2021-06-05 at 01:01 +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0README.alua=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 2 +-
> =A0libmultipath/hwtable.c | 4 ++--
> =A02 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/README.alua b/README.alua
> index b15eb487..5d2b1c64 100644
> --- a/README.alua
> +++ b/README.alua
> @@ -6,7 +6,7 @@ To enable ALUA, the following options should be
> changed:
> =A0- EMC CLARiiON/VNX:
> =A0=A0=A0 "Failover Mode" should be changed to "4" or "Active-Active
> mode(ALUA)-failover mode 4"
> =A0
> -- HPE 3PAR:
> +- HPE 3PAR, Primera, and Alletra 9000:
> =A0=A0=A0 "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun,
> SESLun, ALUA)".
> =A0
> =A0- Promise VTrak/Vess:
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 58fa7387..e884d8c7 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -107,7 +107,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0 * HPE
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* 3PAR / Primera */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* 3PAR / Primera / Alletra=
 9000 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "3PARdata",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "VV",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> @@ -225,7 +225,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =
=3D PRIO_ALUA,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Nimble Storage */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Nimble Storage / HPE All=
etra 6000 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "Nimble",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "Server",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.hwhandler=A0=A0=A0=A0 =
=3D "1 alua",



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

