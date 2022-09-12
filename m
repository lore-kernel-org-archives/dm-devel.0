Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB53ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 09:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662974872;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MiHCvP5V2Rwvg0Mko6JpXfWZTDOEdz860uAu8uk1dwU=;
	b=hzwdyq2FPiaM1A2ak184KwS98guPobPkWseN8tXZ0TIkbKY0/wApeBZzRpcYuEuuc558Py
	rmK7bEM7nsINXWi2Ri4sr+Ijd5jfty8UaQajRjKWJA38Z25h0BzRRDjKAAueZZNhN71c0+
	fuvVPCmZpTsVzWh9gfjZxrU+ORAJV6I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-kAdm_PHmN521g8umRIFhSQ-1; Mon, 12 Sep 2022 05:27:49 -0400
X-MC-Unique: kAdm_PHmN521g8umRIFhSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4725B1C0BC60;
	Mon, 12 Sep 2022 09:27:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C5951121315;
	Mon, 12 Sep 2022 09:27:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53AF01946A43;
	Mon, 12 Sep 2022 09:27:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0C1FA1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 09:27:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 907C4492B05; Mon, 12 Sep 2022 09:27:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C496492B04
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 09:27:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BF2029AA3AC
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 09:27:42 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-461-NAUN6k35MiyNNnc5C4IRfQ-1; Mon,
 12 Sep 2022 05:27:38 -0400
X-MC-Unique: NAUN6k35MiyNNnc5C4IRfQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 1DBDE1FE3E;
 Mon, 12 Sep 2022 09:27:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E61D4139C8;
 Mon, 12 Sep 2022 09:27:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id QLypNoj7HmNqRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 12 Sep 2022 09:27:36 +0000
Message-ID: <5a925c905629551ac6188adf9ad6b395aaf54cb4.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 12 Sep 2022 11:27:36 +0200
In-Reply-To: <20220911223617.141304-1-xose.vazquez@gmail.com>
References: <20220911223617.141304-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.44.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] multipath-tools: update hwtable
 text/info/comments
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-09-12 at 00:36 +0200, Xose Vazquez Perez wrote:
> delete attributes from template, outdated and incompleted.
> delete trivial/redundant comments.
> add HPE Alletra 5000 info.
> remove empty lines in comments.
> compact some info.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =A0libmultipath/hwtable.c | 66 +++++++---------------------------------
> --
> =A01 file changed, 10 insertions(+), 56 deletions(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 2085aba5..d2c92d43 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -33,59 +33,26 @@
> =A0=A0=A0=A0=A0=A0=A0=A0 * Copy this TEMPLATE to add new hardware.
> =A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * Keep only mandatory(.vendor and .product) and =
modified
> attributes.
> -=A0=A0=A0=A0=A0=A0=A0 * Attributes with default values must be removed.
> +=A0=A0=A0=A0=A0=A0=A0 * Attributes with default values must be omitted.
> =A0=A0=A0=A0=A0=A0=A0=A0 * .vendor, .product, .revision and .bl_product a=
re POSIX
> Extended regex.
> =A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * COMPANY_NAME
> -=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: NAME <email>
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Product Name */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "VENDOR",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "PRODUCT",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.revision=A0=A0=A0=A0=A0 =
=3D "REVISION",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.bl_product=A0=A0=A0 =3D "B=
L_PRODUCT",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D FAILOVER,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.uid_attribute =3D "ID_SERI=
AL",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.selector=A0=A0=A0=A0=A0 =
=3D "service-time 0",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.checker_name=A0 =3D TUR,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.alias_prefix=A0 =3D "mpath=
",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.features=A0=A0=A0=A0=A0 =
=3D "0",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.hwhandler=A0=A0=A0=A0 =3D =
"0",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =3D =
PRIO_CONST,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_args=A0=A0=A0=A0 =3D =
"",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D -F=
AILBACK_MANUAL,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.rr_weight=A0=A0=A0=A0 =3D =
RR_WEIGHT_NONE,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D NO_PATH_=
RETRY_UNDEF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.minio=A0=A0=A0=A0=A0=A0=A0=
=A0 =3D 1000,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.minio_rq=A0=A0=A0=A0=A0 =
=3D 1,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.flush_on_last_del =3D FLUS=
H_DISABLED,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.user_friendly_names =3D US=
ER_FRIENDLY_NAMES_OFF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.fast_io_fail=A0 =3D 5,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.dev_loss=A0=A0=A0=A0=A0 =
=3D 600,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.retain_hwhandler =3D RETAI=
N_HWHANDLER_ON,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_prio=A0=A0 =3D DETE=
CT_PRIO_ON,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_checker =3D DETECT_=
CHECKER_ON,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.deferred_remove =3D DEFERR=
ED_REMOVE_OFF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_watch_checks =3D DEL=
AY_CHECKS_OFF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_wait_checks =3D DELA=
Y_CHECKS_OFF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.skip_kpartx=A0=A0 =3D SKIP=
_KPARTX_OFF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.max_sectors_kb =3D MAX_SEC=
TORS_KB_UNDEF,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.ghost_delay=A0=A0 =3D GHOS=
T_DELAY_OFF,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0...

I'd like to keep the template with the current defaults. That makes it
easier for contributors to figure out whether given settings are the
same as the default. We should double check that this list is still
correct though.

> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0#endif
> =A0
> =A0static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Generic NVMe devices
> -=A0=A0=A0=A0=A0=A0=A0 *
> -=A0=A0=A0=A0=A0=A0=A0 * Due to the parsing logic in find_hwe(), generic =
entries
> -=A0=A0=A0=A0=A0=A0=A0 * have to be put on top of this list, and more spe=
cific ones
> -=A0=A0=A0=A0=A0=A0=A0 * below.

Nack, this comment must be kept. Not sure about you but I, even though
I wrote the logic partly myself, need to think twice about the ordering
sometimes.


> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Generic NVMe */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* NVMe */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "NVM[eE]",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D ".*",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.uid_attribute =3D DEFAUL=
T_NVME_UID_ATTRIBUTE,
> @@ -95,7 +62,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Apple
> -=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Shyam Sundar <g.shyamsundar@yahoo.=
co.in>
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> @@ -232,7 +198,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =
=3D PRIO_ALUA,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Nimble Storage / HPE All=
etra 6000 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Nimble Storage / HPE All=
etra 5000/6000 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "Nimble",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "Server",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.hwhandler=A0=A0=A0=A0 =
=3D "1 alua",
> @@ -311,7 +277,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Nexenta COMSTAR
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Yacine Khe=
ddache <yacine@alyseo.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "NEXENTA",
> @@ -367,7 +332,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D MULTIBUS,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* SC Series, formerly Comp=
ellent */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* SC Series (formerly Comp=
ellent) */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "COMPELNT",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "Compellent Vol",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> @@ -471,7 +436,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Hitachi Vantara
> -=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Matthias Rudolph
> <Matthias.Rudolph@hitachivantara.com>
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> @@ -672,7 +636,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D =
-FAILBACK_IMMEDIATE,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0// Storwize V5000 and V7000=
 lines / SAN Volume
> Controller (SVC) / Flex System V7000 /
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0// Storwize V5000/V7000 lin=
es / SAN Volume Controller
> (SVC) / Flex System V7000
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0// FlashSystem
> V840/V9000/5000/5100/5200/7200/7300/9100/9200/9200R/9500
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "IBM",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "^2145",
> @@ -757,7 +721,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * IBM Power Virtual SCSI=
 Devices
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *

Please refrain from making such whitepace changes. I actually liked the
empty line.

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Brian King=
 <brking@linux.vnet.ibm.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> @@ -789,7 +752,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * DE Series
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: NetApp RDA=
C team
> <ng-eseries-upstream-maintainers@netapp.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "LENOVO",
> @@ -809,7 +771,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * ONTAP family
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Martin Geo=
rge <marting@netapp.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "NETAPP",
> @@ -826,7 +787,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * SANtricity(RDAC) famil=
y
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: NetApp RDA=
C team
> <ng-eseries-upstream-maintainers@netapp.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "(NETAPP|LSI|ENGENIO)",
> @@ -843,7 +803,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * SolidFir family
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: PJ Waskiew=
icz
> <pj.waskiewicz@netapp.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "SolidFir",
> @@ -874,7 +833,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Pillar Data / Oracle F=
S
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Srinivasan=
 Ramani
> <srinivas.ramani@oracle.com>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> @@ -1015,7 +973,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Pivot3
> -=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Bart Brooks <bartb@pivot3.com>
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> @@ -1049,12 +1006,12 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =
=3D PRIO_ALUA,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> -=A0=A0=A0=A0=A0=A0=A0 * Linux-IO Target
> +=A0=A0=A0=A0=A0=A0=A0 * Linux
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Linux-IO Target */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* IO Target */

No, "Linux-IO Target" is the correct name. I'd actually use
"Linux-IO Target (LIO)" here, because "LIO" is what this is most
commonly known as.

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "(LIO-ORG|SUSE)",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=A0 =
=3D ".",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=A0 =
=3D ".*",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.hwhandler=A0=A0=A0=A0 =
=3D "1 alua",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D =
-FAILBACK_IMMEDIATE,
> @@ -1107,8 +1064,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* OceanStor V3-V6 */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0// This config works with m=
ultibus and ALUA
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0// ALUA is required by Hype=
rMetro
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "HUAWEI",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "XSG1",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> @@ -1133,7 +1088,6 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Infinidat
> -=A0=A0=A0=A0=A0=A0=A0 *
> =A0=A0=A0=A0=A0=A0=A0=A0 * Maintainer: Arnon Yaari <arnony@infinidat.com>
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> @@ -1202,7 +1156,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D 30,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* 3000 / 6000 Series - ALU=
A mode */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* 3000 / 6000 Series (ALUA=
 mode) */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "VIOLIN",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "SAN ARRAY ALUA",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.hwhandler=A0=A0=A0=A0 =
=3D "1 alua",

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

