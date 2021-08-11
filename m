Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1656DC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:16:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AC43B60FC3
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:16:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC43B60FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222--ayC3T3qMRqVtRAwxtbVBA-1; Wed, 11 Aug 2021 11:16:08 -0400
X-MC-Unique: -ayC3T3qMRqVtRAwxtbVBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D892A190A7A0;
	Wed, 11 Aug 2021 15:16:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 066C610016FB;
	Wed, 11 Aug 2021 15:16:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C813B4BB7C;
	Wed, 11 Aug 2021 15:16:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BFG1gK006119 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:16:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 24165207AC6B; Wed, 11 Aug 2021 15:16:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FF90207AC59
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:15:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C5AB100B8CC
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:15:58 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-476--SqaEwFEN0SDorgiTSZJfQ-1; Wed, 11 Aug 2021 11:15:56 -0400
X-MC-Unique: -SqaEwFEN0SDorgiTSZJfQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AB97722209;
	Wed, 11 Aug 2021 15:15:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 764CE13C17;
	Wed, 11 Aug 2021 15:15:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4TGeGqrpE2F1TgAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:15:54 +0000
Message-ID: <dfed5aadec9c3656c50620b0c0e405c7c4497fa4.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 11 Aug 2021 17:15:53 +0200
In-Reply-To: <20210728155420.GK3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-4-mwilck@suse.com>
	<20210728155420.GK3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BFG1gK006119
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/9] libmultipath: variable-size parameters
 in assemble_map()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mi, 2021-07-28 at 10:54 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 15, 2021 at 12:52:17PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Instead of using fixed PARAMS_SIZE-sized arrays for parameters, use
> > dynamically allocated memory.
> >=20
> > The library version needs to be bumped, because setup_map()
> > argument
> > list has changed.
> >=20
>=20
> Looks good. Only minor nits below.
>=20
> > -
> > =A0/*
> > =A0 * Transforms the path group vector into a proper device map
> > string
> > =A0 */
> > -int
> > -assemble_map (struct multipath * mp, char * params, int len)
> > +int assemble_map(struct multipath *mp, char **params)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0static const char no_path_retry[] =3D "queue_if_n=
o_path";
> > +=A0=A0=A0=A0=A0=A0=A0static const char retain_hwhandler[] =3D
> > "retain_attached_hw_handler";
> > =A0=A0=A0=A0=A0=A0=A0=A0int i, j;
> > =A0=A0=A0=A0=A0=A0=A0=A0int minio;
> > =A0=A0=A0=A0=A0=A0=A0=A0int nr_priority_groups, initial_pg_nr;
> > -=A0=A0=A0=A0=A0=A0=A0char * p;
> > -=A0=A0=A0=A0=A0=A0=A0const char *const end =3D params + len;
> > -=A0=A0=A0=A0=A0=A0=A0char no_path_retry[] =3D "queue_if_no_path";
> > -=A0=A0=A0=A0=A0=A0=A0char retain_hwhandler[] =3D "retain_attached_hw_h=
andler";
>=20
> Why not use STRBUF_ON_STACK() here?

Good catch. I probably wrote this before I wrote the macro.

>=20
> > +=A0=A0=A0=A0=A0=A0=A0struct strbuf __attribute__((cleanup(reset_strbuf=
))) buff =3D
> > STRBUF_INIT;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > =A0


> > @@ -1028,7 +1030,7 @@ int
> > =A0ev_add_path (struct path * pp, struct vectors * vecs, int
> > need_do_map)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > -=A0=A0=A0=A0=A0=A0=A0char params[PARAMS_SIZE] =3D {0};
> > +=A0=A0=A0=A0=A0=A0=A0char *params __attribute((cleanup(cleanup_charp))=
) =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0int retries =3D 3;
> > =A0=A0=A0=A0=A0=A0=A0=A0int start_waiter =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> > @@ -1104,7 +1106,9 @@ rescan:
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * push the map to the device-mapper
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
>=20
> Is there a reason to free params here, instead of just doing it
> before
> the "goto rescan"?

No strong reason. I thought it was more obvious this way, and perhaps
less prone to future error. I will change it.

Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

