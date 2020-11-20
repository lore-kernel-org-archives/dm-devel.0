Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E13DC5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:53:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B34B22240
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:53:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B34B22240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-8sWCiJWjOCuaGk0-4EW1Sw-1; Fri, 20 Nov 2020 07:53:34 -0500
X-MC-Unique: 8sWCiJWjOCuaGk0-4EW1Sw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6796B8101;
	Fri, 20 Nov 2020 12:53:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E880060C05;
	Fri, 20 Nov 2020 12:53:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E86EF180954D;
	Fri, 20 Nov 2020 12:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKCrN4S022161 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 07:53:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 158DB115588D; Fri, 20 Nov 2020 12:53:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E5DD115588E
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 12:53:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4491811E78
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 12:53:11 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1605876791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=zHeDFtCQBbMLNbTEu2gtphTY28+mE9eOwo6J5QsJgC4=;
	b=fWti9wPRY74VrKYH1aM53Cup/1hL67ePOvXiDTuMvsQNkAK6acRzPiCzIT8sqH48RD8F8s
	ROEubHFRWPcupv5Ffvhls09nQwmTygczSrtzlHzsZR20UAMglPSAlALBNPPkWpNMEsh5Gi
	1C91pMvRXS9QXIBQT/pg0Ex/gIchhWkqrMG698Kr/mWnglmGORnflQjq/YvQgn11jatqNw
	ImVk+T4HCfJWz3fieT4c5A5sl4BF+E1I7f9mKOMV1E4XmTpEwsJ1LYrDY4usxZVUQfjJ/z
	TeqfL9/iPa1a73lT79FyPU5NTwqyCxEEj3gDGdPhKlP6twuwikZeEBYpB1ZuZg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1605876791; a=rsa-sha256;
	cv=none;
	b=JE6RNEyWnHGdKM69BvFZonDSUVoF6XaeSzI/8gyd23B+hWbY59PM+RQDPe+6Z8ZCRLRqW3
	/7RSw1l5R7jxhwdE7i5r0HGjy8rNW7wLkhl5pkQZtPZ+2mP/LgDoReVsZc9ikBj+Qgz4Gv
	XJ6KZz7ZrLQX2VfrcHD3gdH8pH5meDyuXpeZ6QxYynAFPhJlmPZ+i90Z1ZHz2oyy/fygdn
	wkbY1mLg/yvZpgfHJVujnx3DIDMULLznd2yg6Wcfzd+wyoNM/XNnjHu9F0XnwYub/uqk+I
	4GkkCL6Eqw31PI96PjqkPijbdGfS6gEF+yBZpeUEVgePi+R03uprro/ys0e2SA==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-142-aUxrEUHtO0a0nMVUkWm24A-1; Fri, 20 Nov 2020 07:53:08 -0500
X-MC-Unique: aUxrEUHtO0a0nMVUkWm24A-1
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id ECF241C0BBF; Fri, 20 Nov 2020 13:46:57 +0100 (CET)
Date: Fri, 20 Nov 2020 13:46:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201120124657.GA31468@duo.ucw.cz>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
X-Mimecast-Spam-Score: -1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 0/8] IMA: support for measuring kernel
 integrity critical data
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
Content-Type: multipart/mixed; boundary="===============8020172410046532104=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============8020172410046532104==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-11-19 15:26:03, Tushar Sugandhi wrote:
> Kernel integrity critical data can be defined as the in-memory kernel
> data which if accidentally or maliciously altered, can compromise the
> integrity of the system.

Is that an useful definition?

> There are several kernel subsystems that contain integrity critical
> data - e.g. LSMs like SELinux, or AppArmor; or device-mapper targets
> like dm-crypt, dm-verity etc. Examples of critical data could be kernel
> in-memory r/o structures, hash of the memory structures, or data that
> represents a linux kernel subsystem state.
>=20
> This patch set defines a new IMA hook namely ima_measure_critical_data()
> to measure the critical data. Kernel subsystems can use this
> functionality, to take advantage of IMA's measuring and quoting=20
> abilities - thus ultimately enabling remote attestation for the
> subsystem specific information stored in the kernel memory.

How is it supposed to be useful?

I'm pretty sure there are critical data that are not measured by
proposed module... and that are written under normal circumstances.

Best regards,

=09=09=09=09=09=09=09=09=09Pavel

--=20
http://www.livejournal.com/~pavelmachek

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX7e6wQAKCRAw5/Bqldv6
8i6vAKC6FrLMFyZX0lHzJkX+8Mez8H3kogCeJ64mXaqCarNAouB4RShXr1Nthec=
=jlIk
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--


--===============8020172410046532104==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============8020172410046532104==--

