Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7E5C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639529383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qsm6nw0QnzNYGCMvL2/ecuHuYDIlzv7DzkR6yerKJxw=;
	b=Mm6qUxkhgYG5XGtI8ZvL256vavoc2gzt8BRQpaKHDd84qMDPZhIZ8ovE3W0ZONchsUlMap
	ujQSr9KBUj1L0RmalKzpEvivpSwplrMf2C2Q0K9UGvuc22gPc90+3sXCuuHaJgLiGSDsWE
	C56QJSixibbWAT84vmwGCAqmFZoutjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-RDrxxMMyM7Cg37m7hM1TEg-1; Tue, 14 Dec 2021 19:49:39 -0500
X-MC-Unique: RDrxxMMyM7Cg37m7hM1TEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 690752F31;
	Wed, 15 Dec 2021 00:49:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 132E72E175;
	Wed, 15 Dec 2021 00:49:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B9731809CB9;
	Wed, 15 Dec 2021 00:49:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BF0nUde006843 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Dec 2021 19:49:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3E626E1F2; Wed, 15 Dec 2021 00:49:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF0436E1EB;
	Wed, 15 Dec 2021 00:49:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BF0nOCd005707; 
	Tue, 14 Dec 2021 18:49:24 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BF0nOfs005706;
	Tue, 14 Dec 2021 18:49:24 -0600
Date: Tue, 14 Dec 2021 18:49:23 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211215004923.GC19591@octiron.msp.redhat.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<e66c48b73da8481f7f2365aa90f8a90624972255.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e66c48b73da8481f7f2365aa90f8a90624972255.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 03, 2021 at 08:25:00AM +0000, Martin Wilck wrote:
> On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > +int
> > +sysfs_get_ro (struct path *pp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int ro;
> > +=A0=A0=A0=A0=A0=A0=A0char buff[3]; /* Either "0\n\0" or "1\n\0" */
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!pp->udev)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (sysfs_attr_get_value(pp->udev, "ro", buff, si=
zeof(buff))
> > <=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: Cannot re=
ad ro attribute in sysfs",
> > pp->dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%d\n", &ro) !=3D 1 || ro < 0 ||=
 ro > 1) {
>=20
> This is ok, but for self-evidently correct code in multipath-tools,
> it'd be better to read just 2 bytes and set buff[2] =3D '\0' explicitly.
> I haven't checked, but coverity might stumble on this.

Actually this is just the way sysfs_attr_get_value() works. You have to
provide a larger buffer than you will read (in this case, ro will only
ever have two bytes), otherwise it will think that it overflowed.
sysfs_attr_get_value() also does the NULL termination itself.

-Ben

> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: Cannot pa=
rse ro attribute", pp->dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return ro;
> > +}
> > +
>=20
> Does this function need to be in libmultipath? We could avoid extending
> the ABI  by adding it as a static function to multipathd. After all,
> it's just sysfs_attr_get_value() + sscanf().
>=20
>=20
> > =A0int sysfs_check_holders(char * check_devt, char * new_devt)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int major, new_minor, table_minor;
> > diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
> > index 72b39ab2..c948c467 100644
> > --- a/libmultipath/sysfs.h
> > +++ b/libmultipath/sysfs.h
> > @@ -13,6 +13,7 @@ ssize_t sysfs_attr_get_value(struct udev_device
> > *dev, const char *attr_name,
> > =A0ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char
> > *attr_name,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned char * value, size_t
> > value_len);
> > =A0int sysfs_get_size (struct path *pp, unsigned long long * size);
> > +int sysfs_get_ro(struct path *pp);
> > =A0int sysfs_check_holders(char * check_devt, char * new_devt);
> > =A0bool sysfs_is_multipathed(struct path *pp, bool set_wwid);
> > =A0#endif
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 08a8a592..a1665494 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp, struct
> > vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > =A0}
> > =A0
> > +static bool
> > +needs_ro_update(struct multipath *mpp, int ro)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> > +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);
>=20
> I'm still not convinced that we need this call, in particular as you
> have added a call to dm_get_info() in the uev_update_map() call, and it
> was called in the dmevent handler, too.
>=20
> In general, I think that multipath-tools could rely more on the kernel
> to send events for status changes than it currently does.=20
> This is particularly true for dm properties, where we have not only one
> event mechanism but two (uevent + dmevent).
>=20
> Regards
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

