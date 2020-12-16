Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAD3C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:57:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0EEF623741
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EEF623741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608163039;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7D+dApb3xYez6dBKZ0TfER4HTvA760/PVLjmWweVkyA=;
	b=iph9jUBcsFeZebfuJ+KSFszqQTc8uHt2FRN8f3vC5t5ftsBm3wsduMoFQss9FuKg4IleCt
	Kobr0RJvF+oEBtgCL78EOKx7jN00d2iacCGeGWj6O851J5aj9uoS0IVGJSbbYpv6zei0W4
	6o+EaAP4LSLNZVqHqWR1qAoZvUdZ1sQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-vrTwb1UwM460Fsa0BVE6PA-1; Wed, 16 Dec 2020 18:57:17 -0500
X-MC-Unique: vrTwb1UwM460Fsa0BVE6PA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76725107ACE8;
	Wed, 16 Dec 2020 23:57:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3EAA1ACC7;
	Wed, 16 Dec 2020 23:57:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDE881809C9F;
	Wed, 16 Dec 2020 23:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGNuWEg022483 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 18:56:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 52FD360843; Wed, 16 Dec 2020 23:56:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B86F60CD2;
	Wed, 16 Dec 2020 23:56:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BGNuRgd027220; 
	Wed, 16 Dec 2020 17:56:27 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BGNuRr9027219;
	Wed, 16 Dec 2020 17:56:27 -0600
Date: Wed, 16 Dec 2020 17:56:26 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201216235626.GR3103@octiron.msp.redhat.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
	<1604472849-22422-6-git-send-email-bmarzins@redhat.com>
	<8eab5c37addfd83366defd5c463d175ead90b7ec.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <8eab5c37addfd83366defd5c463d175ead90b7ec.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"sschremm@netapp.com" <sschremm@netapp.com>,
	"ng-eseries-upstream-maintainers@netapp.com"
	<ng-eseries-upstream-maintainers@netapp.com>
Subject: Re: [dm-devel] [PATCH v2 5/6] libmultipath: limit reading 0xc9 vpd
	page
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16, 2020 at 09:18:01PM +0000, Martin Wilck wrote:
> On Wed, 2020-11-04 at 00:54 -0600, Benjamin Marzinski wrote:
> > Only rdac arrays support 0xC9 vpd page inquiries. All other arrays
> > will
> > return a failure. Only do the rdac inquiry when detecting array
> > capabilities if the array's path checker is explicitly set to rdac,
> > or
> > the path checker is not set, and the array reports that it supports
> > vpd
> > page 0xC9 in the Supported VPD Pages (0x00) vpd page.
> >=20
> > Multipath was doing the check if either the path checker was set to
> > rdac, or no path checker was set.  This means that for almost all
> > non-rdac arrays, multipath was issuing a bad inquiry. This was
> > annoying
> > users.
> >=20
> > Cc: Steve Schremmer <sschremm@netapp.com>
> > Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 25 +++++++++++++++++++++++++
> >  libmultipath/discovery.h |  1 +
> >  libmultipath/propsel.c   | 10 ++++++----
> >  3 files changed, 32 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 95ddbbbd..5669690d 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1346,6 +1346,31 @@ fetch_vpd_page(int fd, int pg, unsigned char
> > *buff)
> >  =09return buff_len;
> >  }
> > =20
> > +/* heavily based on sg_inq.c from sg3_utils */
> > +bool
> > +is_vpd_page_supported(int fd, int pg)
> > +{
> > +=09int i, len, buff_len;
> > +=09unsigned char buff[4096];
> > +
> > +=09buff_len =3D fetch_vpd_page(fd, 0x00, buff);
> > +=09if (buff_len < 0)
> > +=09=09return false;
> > +=09if (buff_len < 4) {
> > +=09=09condlog(3, "VPD page 00h too short");
> > +=09=09return false;
> > +=09}
> > +
> > +=09len =3D buff[3] + 4;
>=20
> SPC-4 says that the page length is a 16-bit value.
> You may also want to check buff[1] =3D=3D 0.

Makes sense. I'll check these.
=20
> > +=09if (len > buff_len)
> > +=09=09condlog(3, "vpd page 00h trucated, expected %d, have
> > %d",
> > +=09=09=09len, buff_len);
> > +=09for (i =3D 4; i < len; ++i)
> > +=09=09if (buff[i] =3D=3D pg)
> > +=09=09=09return true;
> > +=09return false;
> > +}
> > +
> >  int
> >  get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
> >  {
> > diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> > index 6444887d..d3193daf 100644
> > --- a/libmultipath/discovery.h
> > +++ b/libmultipath/discovery.h
> > @@ -56,6 +56,7 @@ int sysfs_get_asymmetric_access_state(struct path
> > *pp,
> >  =09=09=09=09      char *buff, int buflen);
> >  int get_uid(struct path * pp, int path_state, struct udev_device
> > *udev,
> >  =09    int allow_fallback);
> > +bool is_vpd_page_supported(int fd, int pg);
> > =20
> >  /*
> >   * discovery bitmask
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index fa4ac5d9..f771a830 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -496,13 +496,15 @@ check_rdac(struct path * pp)
> >  {
> >  =09int len;
> >  =09char buff[44];
> > -=09const char *checker_name;
> > +=09const char *checker_name =3D NULL;
> > =20
> >  =09if (pp->bus !=3D SYSFS_BUS_SCSI)
> >  =09=09return 0;
> > -=09/* Avoid ioctl if this is likely not an RDAC array */
> > -=09if (__do_set_from_hwe(checker_name, pp, checker_name) &&
> > -=09    strcmp(checker_name, RDAC))
> > +=09/* Avoid checking 0xc9 if this is likely not an RDAC array */
> > +=09if (!__do_set_from_hwe(checker_name, pp, checker_name) &&
> > +=09    !is_vpd_page_supported(pp->fd, 0xC9))
> > +=09=09return 0;
> > +=09if (checker_name && strcmp(checker_name, RDAC))
>=20
> Do we still need the name check after testing whether 0xc9 is
> supported? Well I guess it doesn't harm.

I understand that people could want to use the device section checker
configuration as the fallback. But giving priority to an explicit
checker configuration hasn't caused any problems here so far, so I think
we should continue to do so.=20

-Ben

> Regards
> Martin
>=20
> >  =09=09return 0;
> >  =09len =3D get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
> >  =09if (len <=3D 0)
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=C3=BCrnberg GF: Felix
> Imend=C3=B6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

