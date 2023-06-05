Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6985BC7EE2E
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=4lpKbYGd3UA17AH9S3Jri5003AhagH4igMJ25f9ALsA=;
	b=jKBeGCSB/EPbxA5S219Z1chBDxeGVxXO5rqIo2RZzYjucTz/9q0pLToXWvGzet9m9OeEDj
	A08M11D5Nsb3nIrrys9fkqg2cMbAFHPH5dndiGpXLtQSdcf0K9kCddntZuSBN80ZigbfA4
	PZpeHDX9xtaJMKH9sE9zNEM0CDi1zIU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-NuJS4_qHN3KgLtABopJRyA-1; Mon, 05 Jun 2023 02:04:11 -0400
X-MC-Unique: NuJS4_qHN3KgLtABopJRyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13E11803C89;
	Mon,  5 Jun 2023 06:04:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 004C8140E956;
	Mon,  5 Jun 2023 06:04:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5388E1946F30;
	Mon,  5 Jun 2023 06:04:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4D0751946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 03:17:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0ECBEC154D9; Mon,  5 Jun 2023 03:17:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0648DC154D7
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:17:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFDF81C0518F
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:17:51 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-17GRFd4qMxWxpJY2wysAGw-1; Sun, 04 Jun 2023 23:17:48 -0400
X-MC-Unique: 17GRFd4qMxWxpJY2wysAGw-1
Received: by mail-pj1-f42.google.com with SMTP id
 98e67ed59e1d1-25692ff86cdso3535122a91.2; 
 Sun, 04 Jun 2023 20:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1685935067; x=1688527067;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=5aMetwcrs//TXCNHEA0pW9fSv0jcazh9bmNTsbqRNkU=;
 b=lpHsgHSMlSoJ4GG7X1qZnwf+gVuTPcLa5LQnmnpg8Jr7IbJBLL0ORi5Rz+9yjuS9jY
 Xifh/+tQgf8wHJGGL9Pc7vK3y1ToM3okUwkl+Vpetc07Hz9i8uy6Eir1DTT2AGnXMEKj
 /hb62XW54LcRu7TPmxJa4usOYfMP1/sWz47jVocMnJ6tHEXUNP+0paLrg0I4jDM++qLM
 0R65eVBsAPPcAnIhC//YAEfum9LV0/nP/KQ4YKvUio1q3nYrHGu33iox/RlRZa8/qX4r
 9VX2LLmwn5H4wERGKtdpE4Gh9j91eXt21meZWcIifTkJvw0+ChKY8qeGhX4U86ji3Cc+
 7EMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685935067; x=1688527067;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=5aMetwcrs//TXCNHEA0pW9fSv0jcazh9bmNTsbqRNkU=;
 b=ACkyAgKnvESb6rS595hNP6w/XmQUpaj8PVfIi72C8DP3ijqHJLEZH8Op7hkNJUYwng
 4aJc2nQFmCu8mtMLNaHyg8ryU6oX1/VXXODJbYyHilWiF1Kro8Xva5tdIWcmQXbppyy7
 b+D3XxJiNbM4fHGD9N6woslD/s01KBvuVZkkMevEVvLuLw1cc3imKuBwIodHUvu51JAQ
 BwnUbLiZ0b2IQJOTZLST0VdluA5gX0sPMOAkQSyP3QuzBoU0/2+YXdm6jgrb9Bz3jii5
 ZMlTbn2Dt4aqU7E+g7xCOADpxPtS3igZBCrKNWrNymMHDvA4bTO8B1zfB0uIQK6UIJ7j
 BIgg==
X-Gm-Message-State: AC+VfDw6UilEHagb+7CK63CIcQffoExqoDjYX+mWe3HRBfi1uHG2/uAm
 qSqKkePMY2mjMeC1WCE88xL8zpnz7wzJGg==
X-Google-Smtp-Source: ACHHUZ7iRL6grHx8Dac+vN6c6jM+ap+mvvqPm/e4O0p1JmbMreSBJw6lZiZoP3S5Wg0TScQrYPx2WA==
X-Received: by 2002:a17:90a:194:b0:259:43ec:1a6 with SMTP id
 20-20020a17090a019400b0025943ec01a6mr2387419pjc.17.1685935066633; 
 Sun, 04 Jun 2023 20:17:46 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-4.three.co.id. [180.214.233.4])
 by smtp.gmail.com with ESMTPSA id
 j11-20020a17090a318b00b0025393752cd5sm14740556pjb.1.2023.06.04.20.17.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 20:17:46 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 0A53F106291; Mon,  5 Jun 2023 10:17:42 +0700 (WIB)
Date: Mon, 5 Jun 2023 10:17:42 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH1T1hK1CzHhhNuo@debian.me>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-5-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230604190604.4800-5-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH v3 4/4] Document an example of how the
 tunables relate in dm-integrity.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Content-Type: multipart/mixed; boundary="===============3036850502735428774=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7


--===============3036850502735428774==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qoyQOOMAMXl/9xUL"
Content-Disposition: inline


--qoyQOOMAMXl/9xUL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 12:06:04PM -0700, Russell Harmon wrote:
> For example, on a device using the default interleave_sectors of 32768, a
> block_size of 512, and an internal_hash of crc32c with a tag size of 4
> bytes, it will take 128 KiB of tags to track a full data area, requiring
> 256 sectors of metadata per data area. With the default buffer_sectors of
> 128, that means there will be 2 buffers per metadata area, or 2 buffers
> per 16 MiB of data.

Again, the patch description duplicates diff content.

--=20
An old man doll... just what I always wanted! - Clara

--qoyQOOMAMXl/9xUL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH1T1gAKCRD2uYlJVVFO
o3iyAQDwoPhoPAvgul4DiPijeirtGcmdlL0kovm9Uu1PDS11XQD6A5b3RZrZNq5i
o/EK1clwCzBXe1Au9n0C5RC80JAp+wc=
=rRde
-----END PGP SIGNATURE-----

--qoyQOOMAMXl/9xUL--


--===============3036850502735428774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3036850502735428774==--

