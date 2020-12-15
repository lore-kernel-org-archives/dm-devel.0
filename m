Return-Path: <SRS0=VSmt=FT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF96C4361B
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 23:46:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A794B22C7D
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 23:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A794B22C7D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-plYdLWMZNiS8jfJaHVszKQ-1; Tue, 15 Dec 2020 18:46:20 -0500
X-MC-Unique: plYdLWMZNiS8jfJaHVszKQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04FB7107ACE6;
	Tue, 15 Dec 2020 23:46:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB0AE5C1C4;
	Tue, 15 Dec 2020 23:46:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3BD54180954D;
	Tue, 15 Dec 2020 23:46:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BFNk8dQ015277 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Dec 2020 18:46:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A9994A9F03; Tue, 15 Dec 2020 23:46:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3522AB5B8
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 23:46:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8062F8007D9
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 23:46:06 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1608075966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=t1/qxnzYKVKNAy/tOFal+TcrX4omMH6BzevqOyH0aNk=;
	b=RkgDj+Cm5FrYEVunNod+Mk79RL9cofZGLb47wY/kwmhEteUAtZtULDuUJYpPc1U5thD6KX
	rTOssSA3yC6wRhFccZsijxjkeD859q+1fxwYLodFD8WRf85gxQHrpJGBt3vxeQ0Qi4JJB+
	cRVcNUTWcCokXsW+FrLnSEXHXlFRbfWauWciw4TLTb9wKwub0oNuXr8ydSIZFRi2KIdiZn
	XJ1pdz8bnFMpR6tKTtOCpAcJeXHdpOw0AQmyCp9rgfkko5iaRZjOH1GiN3Xz5P03D1vekH
	XmEvur8UlsHc4K5VAh0sMDeqy3xWvKB4TXCswRFhdhqNbqxpZyS3SRGy/dkSkA==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1608075966; a=rsa-sha256;
	cv=none;
	b=sNxyNFXoQ0Hk6kp7Ym4ktewoW+lVvlLKyVYKyoPJfX8wDRYy6azQcmdmBD2nV7DXl14wkr
	E9cOpcq729QozEC4SsvzDxrUXQXDYiWLcd37y7BHBg6luyvk3OltHeRSHlLauKywkCUhEZ
	LLadkXvPIIvCtPk+pw3CuvAPbKk6kacsGbEmp00FOAoq3JAMgDf5cHxrNOmzYLU2RB3CJ0
	9P154d+OoHwwaoYfjA48WcFDMLm48QshBBuPg/VPQRsNQodey2iFQqMIIpHo9/Jsga7ZSn
	HX+mjnUGY/YJKgrybkn9R47ps44R/GFbwjlEsPsnDpw9HL+FWih2/0xm/QcGag==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-340-FkTnp9wzOVe6VbNbAX6naQ-1; Tue, 15 Dec 2020 18:46:03 -0500
X-MC-Unique: FkTnp9wzOVe6VbNbAX6naQ-1
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 8EAD91C0B78; Wed, 16 Dec 2020 00:45:59 +0100 (CET)
Date: Wed, 16 Dec 2020 00:45:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20201215234558.GA18281@amd>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
	<SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208122248.utv7pqthmmn6uwv6@mpHalley>
	<SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
X-Mimecast-Spam-Score: 0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
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
Content-Type: multipart/mixed; boundary="===============0866071274918900058=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

--===============0866071274918900058==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Good idea. Are you thinking of a sysfs entry to select the backend?
>=20
> Not sure on this one, initially I thought of a sysfs file, but then
> how would you do it. One "global" sysfs entry is probably a bad idea.
> Having one per block device to select native vs emulation maybe? And
> a good way to benchmark.
>=20
> The other idea would be a benchmark loop on boot like the raid library
> does.

Doing copy benchmarking would require writes on the media, right?

Kernel should not do such stuff without userspace requesting it...

Best regards,
=09=09=09=09=09=09=09=09Pavel
--=20
http://www.livejournal.com/~pavelmachek

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/ZSrYACgkQMOfwapXb+vK5rACeLJojhyDVgpGZfTaitdzO94sJ
RKoAn0eHTH191kYNNiXqgRZfCOo1aVIE
=wLdn
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--


--===============0866071274918900058==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0866071274918900058==--

