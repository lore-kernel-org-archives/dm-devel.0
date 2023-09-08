Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736BDCCFA0A
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 12:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694174524;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Vz+A7ziNYlIRO/5uJk+bXy9Y4Gsf59+98mDzOyxOO7k=;
	b=jQ45YIWHfRG7LGd4venRBlsC3io7a/t/ye3exJG2XaG815P5P1e9XK/aGK0SAiePl0SU1O
	qBS6AUhgBvgXa9r+7sNcFvO6r7GGpNCkoFAGZBx+vCUUm38ekARaj/h3aAdQg8Tj9g+GWU
	oocrlJQP87TNL42AZ9//8xOBaGIjsDo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-H4kq0-JPOGuczijcfYZswg-1; Fri, 08 Sep 2023 08:01:59 -0400
X-MC-Unique: H4kq0-JPOGuczijcfYZswg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1870F29AA2C0;
	Fri,  8 Sep 2023 12:01:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 012FD40ED414;
	Fri,  8 Sep 2023 12:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD797194658F;
	Fri,  8 Sep 2023 12:01:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 120BE194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 12:01:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC9FF2026D76; Fri,  8 Sep 2023 12:01:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C56BF2026D2B
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:01:54 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A593F8007CE
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:01:54 +0000 (UTC)
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-U_7OY6anO0q2OU6TI51G7w-1; Fri,
 08 Sep 2023 08:01:47 -0400
X-MC-Unique: U_7OY6anO0q2OU6TI51G7w-1
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
 id 320DB1C001B; Fri,  8 Sep 2023 14:01:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
 t=1694174498;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oCWFkyKfwI9bEpl9fadTSanqQe9wzQPVFsXP12g7JnM=;
 b=Qfg9H76WGa29+pU/g8IBJVLEVWOIBciqJEMQ4/L91p1PVHpZPe95oPKMial89SeH0bix2s
 ovhHBCdHG6DxgiiMwwX7cqh8xibXAdECnt6XZ7K79sTwLPkmJrdBD8Y/nqLZbTUvRlTaZ+
 4Y7zVaw6e/ZgQfCCq1q6uZzyBdtmu50=
Date: Fri, 8 Sep 2023 14:01:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kara <jack@suse.cz>
Message-ID: <ZPsNIXDpcCp/K8L3@duo.ucw.cz>
References: <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
 <20230908073244.wyriwwxahd3im2rw@quack3>
MIME-Version: 1.0
In-Reply-To: <20230908073244.wyriwwxahd3im2rw@quack3>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] fix writing to the filesystem after unmount
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
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: multipart/mixed; boundary="===============7855944562425694952=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2


--===============7855944562425694952==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FKbQv0RtqEq20ooY"
Content-Disposition: inline


--FKbQv0RtqEq20ooY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> What I wanted to suggest is that we should provide means how to make sure
> block device is not being modified and educate admins and tool authors
> about them. Because just doing "umount /dev/sda1" and thinking this means
> that /dev/sda1 is unused now simply is not enough in today's world for
> multiple reasons and we cannot solve it just in the kernel.

It better be enough. And I'm pretty sure it is true in single-user
mode, or for usb sticks, or...

Simply fix the kernel. No need to re-educate anyone.


									Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--FKbQv0RtqEq20ooY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZPsNIQAKCRAw5/Bqldv6
8nSbAJ97C5cuxAFnBMsLL5cWuCCaxsb01ACgnODxymf5SRxpW8FqNDq6z0S+F9o=
=zx5U
-----END PGP SIGNATURE-----

--FKbQv0RtqEq20ooY--


--===============7855944562425694952==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7855944562425694952==--

