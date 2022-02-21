Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7537AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 21:27:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-TX7LOf63NzygXDvqU7genQ-1; Mon, 21 Feb 2022 16:27:08 -0500
X-MC-Unique: TX7LOf63NzygXDvqU7genQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEFDC18460E5;
	Mon, 21 Feb 2022 21:27:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 821EDE710;
	Mon, 21 Feb 2022 21:27:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16F291809CAA;
	Mon, 21 Feb 2022 21:26:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21LLQvrs025232 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Feb 2022 16:26:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 66C0140D2969; Mon, 21 Feb 2022 21:26:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 629CA40D2962
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 21:26:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44E682A2AD4D
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 21:26:57 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-169-nXyERzqlO_Cj-82FTLhcUA-1; Mon, 21 Feb 2022 16:26:53 -0500
X-MC-Unique: nXyERzqlO_Cj-82FTLhcUA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 60A0D210E2;
	Mon, 21 Feb 2022 21:26:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2738113BA5;
	Mon, 21 Feb 2022 21:26:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id dNrMBpwDFGLBXAAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 21 Feb 2022 21:26:52 +0000
Message-ID: <845fe3924dd86b71fe214f6b2853d5960aa9aaf3.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Mon, 21 Feb 2022 22:26:51 +0100
In-Reply-To: <20220217195533.4251-2-mwilck@suse.com>
References: <20220217195533.4251-1-mwilck@suse.com>
	<20220217195533.4251-2-mwilck@suse.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21LLQvrs025232
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/4] libmultipath: enable linear ordering of
 bus/proto tuple
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

On Thu, 2022-02-17 at 20:55 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> We categorized protocols by bus/proto_id, while we only differentiate
> protocol IDs for SCSI. Allow transforming this into a linear sequence
> of bus/protocol IDs by having non-SCSI first, and follwing up with
> the different SCSI protocols.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> =A0libmultipath/structs.c | 10 ++++++++++
> =A0libmultipath/structs.h | 13 +++++++++++--
> =A02 files changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 17f4baf..5849bf1 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -753,3 +753,13 @@ out:
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> +
> +unsigned int bus_protocol_id(const struct path *pp) {
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || pp->bus < 0 || pp->bus > SYSFS_BUS_SCSI)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SYSFS_BUS_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0if (pp->bus !=3D SYSFS_BUS_SCSI)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return pp->bus;
> +=A0=A0=A0=A0=A0=A0=A0if (pp->sg_id.proto_id < 0 || pp->sg_id.proto_id

It turns out that ^^^^^^^^^^^^^^^^^^ this comparison causes
an error with clang 3.5, and possibly other compilers, because they
use an unsigned int type for sg_id.proto_id.

Because some compilers will use "int", instead of dropping the test,
I'll just add a cast to (int).

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

