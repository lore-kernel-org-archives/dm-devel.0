Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0D7C7619A
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 20:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679344706;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FGdoDbs+HW1ZkqmwISPKP2YI1qxIWsY9GDcXBS1BdnA=;
	b=KOGs2et1QbS9Zr134txGzR/sDKeASSPYTqx/1cJ7jLzXMcvazhNAQzTKGpgXvjAV7uY+F7
	rbqpz9P163Dh3IWPuJk1VFUE1GhauQk8jD+SxENIooYIArnwR7Jm3i5akIIbvArtOw/Plj
	z//rTsCNynafjcusOg0t2708D/iIQoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-6mTU_wKyMZujXPOCrNuUfA-1; Mon, 20 Mar 2023 16:38:22 -0400
X-MC-Unique: 6mTU_wKyMZujXPOCrNuUfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48DEA85C069;
	Mon, 20 Mar 2023 20:38:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CACFA40C20FA;
	Mon, 20 Mar 2023 20:38:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B6AB19465A2;
	Mon, 20 Mar 2023 20:38:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 530E319465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 20:37:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92B5E40C6E68; Mon, 20 Mar 2023 20:37:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7374340C6E67;
 Mon, 20 Mar 2023 20:37:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 32KKbr4q021650;
 Mon, 20 Mar 2023 15:37:53 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 32KKbqlY021649;
 Mon, 20 Mar 2023 15:37:52 -0500
Date: Mon, 20 Mar 2023 15:37:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230320203752.GI19878@octiron.msp.redhat.com>
References: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
 <5be1cfaef0f67e4992169b92a9c44cdcb623affc.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <5be1cfaef0f67e4992169b92a9c44cdcb623affc.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] libmultipath: limit paths that can get wwid
 from environment
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 02:53:20PM +0000, Martin Wilck wrote:
> On Thu, 2023-02-09 at 11:28 -0600, Benjamin Marzinski wrote:
> > Currently, whenever getting the uid_attribute from the udev database
> > fails, multipath will try to get it from the environment variables.
> > This
> > normally isn't a problem, since either multipath -u is getting called
> > from a uevent and the environment will have the correct value in that
> > variable, or something else is being run and that variable won't be
> > set.
> > However, when find_multipaths is configured to "smart", this causes
> > problems. For maybe devices, multipath needs to get the WWIDs of all
> > the
> > other block devices, to see if they match the maybe device wwid.=A0 If
> > one
> > of those devices doesn't have uid_attribute set in its udev database,
> > multipath will fall back to checking the environment for it, and it
> > will
> > find that variable set to the WWID of the maybe device that this
> > uevent
> > is for.=A0 This means that all devices with no WWID will end up
> > appearing
> > to have the same WWID as the maybe device, causing multipath to
> > incorrectly claim it.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> I have to say I don't quite understand why we read from the environment
> at all if the libudev call fails. This was coded before I joined the
> project, so perhaps you can clarify it. Why do we expect the
> environment to provide the correct value if libudev cannot?

I'm pretty sure that the udev database for a device isn't set up yet
when we are in the middle of processing the ADD event for it. When udev
calls "multipath -u" on the add event, we can't look up the value in the
database because the database entry for the device doesn't exist yet. We
have to use the value it passed in via the enviroment.
=20
> If we need to keep this fallback, I wonder if we need another field in
> "struct path" for it. For example, we could read MAJOR and MINOR from
> the environment and use uid_attribute only if the result matches the
> path's devt.

This is basically what my patch does.  It sets the can_use_env_uid flag
only on the device that the uevent is for, so the only device that can
get its WWID from the environment is the device whose uevent we are
processing. The other paths we find in path_discovery() must be
intialized, which means that they will have a udev database entry, and
we can find their WWID there.

-Ben

> Regards
> Martin
>=20
>=20
>=20
>=20
>=20
>=20
> > ---
> > =A0libmultipath/discovery.c | 2 +-
> > =A0libmultipath/structs.h=A0=A0 | 1 +
> > =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 2 ++
> > =A03 files changed, 4 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 67ac0e6d..3a5ba173 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -2093,7 +2093,7 @@ get_udev_uid(struct path * pp, const char
> > *uid_attribute, struct udev_device *ud
> > =A0=A0=A0=A0=A0=A0=A0=A0const char *value;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0value =3D udev_device_get_property_value(udev, =
uid_attribute);
> > -=A0=A0=A0=A0=A0=A0=A0if (!value || strlen(value) =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0if ((!value || strlen(value) =3D=3D 0) && pp->can=
_use_env_uid)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0value =3D getenv(uid_at=
tribute);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (value && strlen(value)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0len =3D strlcpy(pp->wwi=
d, value, WWID_SIZE);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index e2294323..a1208751 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -368,6 +368,7 @@ struct path {
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int dev_loss;
> > =A0=A0=A0=A0=A0=A0=A0=A0int eh_deadline;
> > =A0=A0=A0=A0=A0=A0=A0=A0bool is_checked;
> > +=A0=A0=A0=A0=A0=A0=A0bool can_use_env_uid;
> > =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> > =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> > diff --git a/multipath/main.c b/multipath/main.c
> > index b9f360b4..90f940f1 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -607,6 +607,8 @@ check_path_valid(const char *name, struct config
> > *conf, bool is_uevent)
> > =A0=A0=A0=A0=A0=A0=A0=A0pp =3D alloc_path();
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!pp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return RTVL_FAIL;
> > +=A0=A0=A0=A0=A0=A0=A0if (is_uevent)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->can_use_env_uid =3D t=
rue;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0r =3D is_path_valid(name, conf, pp, is_uevent);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (r <=3D PATH_IS_ERROR || r >=3D PATH_MAX_VAL=
ID_RESULT)
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

