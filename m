Return-Path: <SRS0=NHnu=EJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C454CC388F2
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 05:10:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 15DCB22277
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 05:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bkP8EqZn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15DCB22277
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604380217;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eru2d8SuPRXTh//Sy/OveWrqBrSW1SBIyQdDV/UjXUg=;
	b=bkP8EqZnjy0g1jeIHkWzBIFdx5dxtrdxKeWaM9P8PacsFhzrpJAa3lMHknAn7Yj1ZjGB78
	oXSJy58Q155qjuU74qtsWJMk5GW28mPd2t9cOqU0HRhjccd/To+8/JFQCyUi9+kGWWsXOH
	sZ9EMfMdCjIbXK8Hr33oWTBybODdYvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-HQ2mApjgN6yHcKsXQ0hlnw-1; Tue, 03 Nov 2020 00:10:13 -0500
X-MC-Unique: HQ2mApjgN6yHcKsXQ0hlnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0DD8107465C;
	Tue,  3 Nov 2020 05:10:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA1485DA6B;
	Tue,  3 Nov 2020 05:10:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A18A9180B657;
	Tue,  3 Nov 2020 05:10:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A35A0vF026827 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 00:10:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3AA8E5B4DF; Tue,  3 Nov 2020 05:10:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56F625B4D7;
	Tue,  3 Nov 2020 05:09:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A359sg8014301; 
	Mon, 2 Nov 2020 23:09:55 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A359sFT014300;
	Mon, 2 Nov 2020 23:09:54 -0600
Date: Mon, 2 Nov 2020 23:09:54 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201103050954.GZ3384@octiron.msp.redhat.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-5-git-send-email-bmarzins@redhat.com>
	<acd021d7918335d91fac742da1f7e604ed3e2ee6.camel@suse.com>
	<20201103011105.GX3384@octiron.msp.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201103011105.GX3384@octiron.msp.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: "ng-eseries-upstream-maintainers@netapp.com"
	<ng-eseries-upstream-maintainers@netapp.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"sschremm@netapp.com" <sschremm@netapp.com>
Subject: Re: [dm-devel] [PATCH 4/5] libmultipath: only read 0xc9 vpd page
 for devices with rdac checker
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2020 at 07:11:06PM -0600, Benjamin Marzinski wrote:
> On Fri, Oct 30, 2020 at 09:12:46PM +0000, Martin Wilck wrote:
> > On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > > Only rdac arrays support 0xC9 vpd page inquiries. All other arrays
> > > will
> > > return a failure. Since all rdac arrays in the the built-in device
> > > configuration explicitly set the RDAC path checker, and almost all
> > > other
> > > scsi arrays do not set a path checker, it makes sense to only do the
> > > rdac inquiry when detecting array capabilities if the array's path
> > > checker is explicitly set to rdac.
> > >=20
> > > Multipath was doing the check if either the path checker was set to
> > > rdac, or no path checker was set.  This means that for almost all
> > > non-rdac arrays, multipath was issuing a bad inquiry. This was
> > > annoying
> > > users.
> >=20
> > This is sort of funny. We created the entire check_rdac() feature in
> > order to autodetect RDAC arrays. If we limit the autodetection to those
> > arrays that have "rdac" set already, why would we do this at all? We
> > could simply go with the hwtable / config file settings, as we used to
> > before check_rdac() was created. All we'd need to do is use "alua" prio
> > for arrays with "rdac" checker. What am I missing here?
> >=20
> > I thought that this autodetection was intended because there are many
> > Netapp OEMs which we may not all have included in the hwtable (thus
> > having no path_checker set). For those, we'd choose the wrong settings
> > by default with this patch, only to avoid some error messages about
> > unsupported VPDs. I'm not convinced that that's a good idea.
> >=20
> > Suggestion: we could try to retrieve VPD 0 (supported VPDs) before
> > checking VPD 0xc9. That would avoid the errors on non-Netapp hardware,
> > while still allowing us to autodetect RDAC systems that are missing in
> > the hwtable.
>=20
> When this idea was brought up in discussions about how to solve this,
> there was a worry that older rdac devices might not not support vpd page
> 0 correctly. I'm not sure how valid that worry is.

Of course, that doesn't mean it wouldn't be useful to always do the
check on vpd page c9 for devices that do indicate support in vpd 0. So,
yes I agree that makes sense so unless Netapp has any objections, I can
change the patch to also check c9 if vpd page 0 says it's supported.

-Ben

>=20
> -Ben
>=20
> >=20
> > Regards
> > Martin
> >=20
> > >=20
> > > Cc: Steve Schremmer <sschremm@netapp.com>
> > > Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  libmultipath/propsel.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > > index fa4ac5d9..90a77d77 100644
> > > --- a/libmultipath/propsel.c
> > > +++ b/libmultipath/propsel.c
> > > @@ -501,7 +501,7 @@ check_rdac(struct path * pp)
> > >  =09if (pp->bus !=3D SYSFS_BUS_SCSI)
> > >  =09=09return 0;
> > >  =09/* Avoid ioctl if this is likely not an RDAC array */
> > > -=09if (__do_set_from_hwe(checker_name, pp, checker_name) &&
> > > +=09if (!__do_set_from_hwe(checker_name, pp, checker_name) ||
> > >  =09    strcmp(checker_name, RDAC))
> > >  =09=09return 0;
> > >  =09len =3D get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
> >=20
> > --=20
> > Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> > SUSE  Software Solutions Germany GmbH
> > HRB 36809, AG N=FCrnberg GF: Felix
> > Imend=F6rffer
> >=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

