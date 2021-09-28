Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4D3C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:25:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B0D1E6135E
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B0D1E6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-Q0ownYIAPRGGVxZ5_U16UA-1; Tue, 28 Sep 2021 15:25:22 -0400
X-MC-Unique: Q0ownYIAPRGGVxZ5_U16UA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 912071019983;
	Tue, 28 Sep 2021 19:25:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4768319C79;
	Tue, 28 Sep 2021 19:25:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36DFC4E58E;
	Tue, 28 Sep 2021 19:25:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18SJP5Ex003395 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 15:25:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5E08D1004042; Tue, 28 Sep 2021 19:25:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58A311110ADF
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 19:24:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39B16811E7A
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 19:24:59 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-462-iwU6f-DNO_OTWnKrP2CBYw-1; Tue, 28 Sep 2021 15:24:57 -0400
X-MC-Unique: iwU6f-DNO_OTWnKrP2CBYw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B52DD224C4;
	Tue, 28 Sep 2021 19:24:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A19113CFD;
	Tue, 28 Sep 2021 19:24:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id sL6PGwdsU2GFWQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 28 Sep 2021 19:24:55 +0000
Message-ID: <541776943b259a5469821ce066ed9b40786174e9.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Tue, 28 Sep 2021 21:24:54 +0200
In-Reply-To: <20210928165210.15565-1-xose.vazquez@gmail.com>
References: <20210928165210.15565-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.40.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18SJP5Ex003395
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: make IBM/2107900 (DS8000)
 config work with alua and multibus
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-09-28 at 18:52 +0200, Xose Vazquez Perez wrote:
> ALUA is supported since the beginning:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/device_handler/scsi_dh_alua.c?id=3D057ea7c9683c3d684128cced796f=
03c179ecf1c2#n683
>=20
> ... the DS8000 is an Asymmetric Logical Unit Access (ALUA) capable
> storage array,
> pag#160(144): https://www.redbooks.ibm.com/redbooks/pdfs/sg248887.pdf
>=20
> kernel log:
> https://marc.info/?l=3Dlinux-scsi&m=3D156407413807511&q=3Dmbox
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Thanks for the careful investigation!

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/hwtable.c | 3 ++-
> =A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 72f81c60..f115c4f9 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -656,7 +656,8 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "IBM",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "^2107900",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D NO_PAT=
H_RETRY_QUEUE,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D MULTIBUS,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D -F=
AILBACK_IMMEDIATE,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0// Storwize V5000 and V70=
00 lines / SAN Volume
> Controller (SVC) / Flex System V7000 /



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

