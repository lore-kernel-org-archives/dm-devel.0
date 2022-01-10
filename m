Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFACC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 18:30:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-PmiZj59bNlm64gWMZhO0lQ-1; Mon, 10 Jan 2022 13:30:14 -0500
X-MC-Unique: PmiZj59bNlm64gWMZhO0lQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E224118B613D;
	Mon, 10 Jan 2022 18:30:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B73E7A410;
	Mon, 10 Jan 2022 18:30:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17F034BB7C;
	Mon, 10 Jan 2022 18:30:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20AIU48n031277 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 13:30:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AFF3F492D19; Mon, 10 Jan 2022 18:30:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB978492C3B
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 18:30:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B4641C05EA3
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 18:30:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-621-vtp6wMGjPzm6gl-Td4Hqqw-1; Mon, 10 Jan 2022 13:30:00 -0500
X-MC-Unique: vtp6wMGjPzm6gl-Td4Hqqw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C760C1F383;
	Mon, 10 Jan 2022 18:29:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82BAB13B26;
	Mon, 10 Jan 2022 18:29:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id c/VBHSZ73GG3XgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 10 Jan 2022 18:29:58 +0000
Message-ID: <c8c982bdcc0b55e4cfe94b1684103c8eb5a3f99e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Sergei Trofimovich <slyich@gmail.com>, dm-devel@redhat.com
Date: Mon, 10 Jan 2022 19:29:57 +0100
In-Reply-To: <20220109102908.4102332-1-slyich@gmail.com>
References: <20220109102908.4102332-1-slyich@gmail.com>
User-Agent: Evolution 3.42.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20AIU48n031277
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/4] multipath-tools: avoid using GZIP
	Makefile variable
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

On Sun, 2022-01-09 at 10:29 +0000, Sergei Trofimovich wrote:
> `gzip` supports (deprecated) `GZIP` environment variable. If it's
> already present Makefile would override it and pass it through
> causing
> thre breakage:
>=20
> =A0=A0=A0 $ dev>GZIP=3D-n make
> =A0=A0=A0 gzip -9 -c mpath_persistent_reserve_in.3 >
> mpath_persistent_reserve_in.3.gz
> =A0=A0=A0 gzip: -c: option not valid in GZIP environment variable
> =A0=A0=A0 Try `gzip --help' for more information.
>=20
> Fix build by renaming GZIP variable to GZIP_PROG to avoid collision.
>=20
> CC: Martin Wilck <mwilck@suse.com>
> CC: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Sergei Trofimovich <slyich@gmail.com>

For the series: Looks good, no breakage found, so

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

