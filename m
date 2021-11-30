Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADBAC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 20:15:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-XVtENLF2N8KQ8nlqotQzZQ-1; Tue, 30 Nov 2021 15:15:37 -0500
X-MC-Unique: XVtENLF2N8KQ8nlqotQzZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7620D100CCC5;
	Tue, 30 Nov 2021 20:15:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C14F345D73;
	Tue, 30 Nov 2021 20:15:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CB0B1809C89;
	Tue, 30 Nov 2021 20:15:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUKEN4Y024129 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 15:14:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1DA1F2166B3F; Tue, 30 Nov 2021 20:14:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17D902166B26
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 20:14:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACD20811E76
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 20:14:17 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-452-ndQoJNeXP3GIBAdmWcTyDA-1; Tue, 30 Nov 2021 15:14:13 -0500
X-MC-Unique: ndQoJNeXP3GIBAdmWcTyDA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED1AA1FD58;
	Tue, 30 Nov 2021 20:14:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C11E513D71;
	Tue, 30 Nov 2021 20:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id mklHLROGpmGJUwAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 30 Nov 2021 20:14:11 +0000
Message-ID: <10c985a14d43729b36e76f8e4aeb617876ee8165.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Nov 2021 21:14:10 +0100
In-Reply-To: <20211130173051.GL19591@octiron.msp.redhat.com>
References: <20211118231338.22358-1-mwilck@suse.com>
	<20211118231338.22358-6-mwilck@suse.com>
	<20211130011759.GG19591@octiron.msp.redhat.com>
	<e56fcde94769fcdd44d0237b152407618be7f23e.camel@suse.com>
	<20211130173051.GL19591@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.1
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AUKEN4Y024129
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/21] libmultipath (coverity): improve input
 checking in parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-11-30 at 11:30 -0600, Benjamin Marzinski wrote:
>=20
> If you export scsi IDs from sg_inq, it will print them out until it
> hits an error, so I would prefer if we used the best designator we got
> before we hit the error, to match it.

That's what my code does (embarrassingly, I didn't realize that when I
wrote my previous reply).=A0

In shortened pseudo code:

=09int prio =3D -1;
=09int err =3D -ENODATA;

=09d =3D first_designator();
=09while (d <=3D in + in_len - 4) {
=09=09bool invalid =3D false;
=09=09int new_prio =3D -1;

                if (designator_is_invalid(d))
                     invalid =3D true;
                else if (lun_association(d))
                     new_prio =3D prio(d);

=09next_designator:
=09=09if (invalid) {
=09=09=09err =3D -EINVAL;
=09=09=09break;  /** see below **/
=09=09}
=09=09if (new_prio > prio) {
=09=09=09vpd =3D d;
=09=09=09prio =3D new_prio;
=09=09}
=09=09d =3D next_designator(d);
=09}

        /* if we did find a valid designator, prio will be > 0, and we
           will not error out */
=09if (prio <=3D 0)
=09=09return err;

        convert_designator_to_wwid(d);

If you think we should use a different strategy, please explain.
We *could* try to go on even after encountering broken designators,
assuming the length field is correct if it's within the given limits,
even if the rest is bogus. So baiscally instead of the break statement
above, we'd continue the loop.

Would you prefer that?

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

