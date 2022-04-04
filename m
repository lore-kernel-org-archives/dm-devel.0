Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A69C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:42:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-R45xtYNhMIKuxBtouha2fA-1; Mon, 04 Apr 2022 02:42:49 -0400
X-MC-Unique: R45xtYNhMIKuxBtouha2fA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 605132800941;
	Mon,  4 Apr 2022 06:42:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34BCC21568AE;
	Mon,  4 Apr 2022 06:42:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EFEF319451EC;
	Mon,  4 Apr 2022 06:42:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 904B619452D2
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Apr 2022 06:42:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FCE9202E4A6; Mon,  4 Apr 2022 06:42:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AB78202E4A0
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 06:42:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8E9085A5BC
 for <dm-devel@redhat.com>; Mon,  4 Apr 2022 06:42:34 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-nUAl7EePNe6k0ptAC_33Ew-1; Mon, 04 Apr 2022 02:42:31 -0400
X-MC-Unique: nUAl7EePNe6k0ptAC_33Ew-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6702D1F380;
 Mon,  4 Apr 2022 06:42:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E61313B6A;
 Mon,  4 Apr 2022 06:42:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id s0VKCVWTSmJHVwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 04 Apr 2022 06:42:29 +0000
Message-ID: <b3ed857621d9c6b387c8e0de2516674f462b57ec.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 04 Apr 2022 08:42:28 +0200
In-Reply-To: <20220402034026.GU24684@octiron.msp.redhat.com>
References: <20220330221510.22578-1-mwilck@suse.com>
 <20220330221510.22578-7-mwilck@suse.com>
 <20220402034026.GU24684@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 06/14] multipathd: reconfigure: disallow
 changing uid_attrs
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
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-04-01 at 22:40 -0500, Benjamin Marzinski wrote:
> > On Thu, Mar 31, 2022 at 12:15:02AM +0200, mwilck@suse.com=A0wrote:
> > uevent merging by WWID relies on the uid_attrs config option. As we
> > drop struct config between calls to uevent_merge(), we must be sure
> > that the WWID is not changed in reconfigure().
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipath/multipath.conf.5 |=A0 2 ++
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 53 ++++++++++++++++++=
+++++++++++++---
> > ----
> > =A02 files changed, 46 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/multipath/multipath.conf.5
> > b/multipath/multipath.conf.5
> > index 605b46e..a9cd776 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -264,6 +264,8 @@ If this option is configured and matches the
> > device
> > =A0node name of a device, it overrides any other configured=A0 methods
> > for
> > =A0determining the WWID for this device.
> > =A0.PP
> > +This option cannot be changed during runtime with the multipathd
> > \fBreconfigure\fR command.
> > +.PP
> > =A0The default is: \fB<unset>\fR. To enable uevent merging, set it
> > e.g. to
> > =A0\(dqsd:ID_SERIAL dasd:ID_UID nvme:ID_WWN\(dq.
> > =A0.RE
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 13b1948..f514b32 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2835,11 +2835,52 @@ void rcu_free_config(struct rcu_head *head)
> > =A0=A0=A0=A0=A0=A0=A0=A0free_config(conf);
> > =A0}
> > =A0
> > +static bool reconfigure_check_uid_attrs(const struct _vector
> > *old_attrs,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const struct _vector
> > *new_attrs)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +=A0=A0=A0=A0=A0=A0=A0char *old;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(old_attrs) !=3D VECTOR_SIZE(new_a=
ttrs))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(old_attrs, old, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0char *new =3D VECTOR_SLOT=
(new_attrs, i);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(old, new))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn true;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return false;
> > +}
> > +
> > +static void reconfigure_check(struct config *old, struct config
> > *new)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int old_marginal_pathgroups;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0old_marginal_pathgroups =3D old->marginal_pathgro=
ups;
> > +=A0=A0=A0=A0=A0=A0=A0if ((old_marginal_pathgroups =3D=3D MARGINAL_PATH=
GROUP_FPIN) !=3D
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new->marginal_pathgroups =3D=3D MARGIN=
AL_PATHGROUP_FPIN))
> > {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "multipathd mu=
st be restarted to turn %s
> > fpin marginal paths",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
old_marginal_pathgroups =3D=3D
> > MARGINAL_PATHGROUP_FPIN)?
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=
off" : "on");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0new->marginal_pathgroups =
=3D old_marginal_pathgroups;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (reconfigure_check_uid_attrs(&old->uid_attrs, =
&new-
> > >uid_attrs)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct _vector v =3D new-=
>uid_attrs;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "multipathd mu=
st be restarted to change
> > uid_attrs, keeping old values");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0new->uid_attrs =3D old->u=
id_attrs;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_reset(&v);
>=20
> This leaks the strings that v points to, right?=A0=A0
> This also can happen in
> uid_attrs_handler(), I just noticed.

I was wondering about the same thing. But vector_reset() calls free()
on every slot. So no, I don't think anything is leaked here. The API
behaves admittedly in a surprising manner.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

