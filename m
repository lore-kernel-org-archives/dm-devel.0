Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4E1C7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945050;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=fPugwJ869EGOeFTu6tHO0MWJAdY5PbASQFy+v+vAqOU=;
	b=ASyNzotiZRNYjQCAJGTXwj/Q9hq74RpEq68cIfuSjzHkD4iS6xD4gm/ca4raTS2k9vmrQL
	MMXXuapdmMcuSVY0yaRk6vxg5egry6Gqyo04iLh7RF6DzyKLiH9XZo66e+1+ulfH599y0t
	IRrA63xwcQb6wr1en0HArANc3J9UlOY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-a0Y5loVqNhaAtCqqyLM3zw-1; Mon, 05 Jun 2023 02:04:08 -0400
X-MC-Unique: a0Y5loVqNhaAtCqqyLM3zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2B3A803791;
	Mon,  5 Jun 2023 06:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63AD39E8D;
	Mon,  5 Jun 2023 06:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 47C2019466DF;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8503B1946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 12:46:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3799248205F; Sat,  3 Jun 2023 12:46:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 301DE401029
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 12:46:07 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11AE1185A78B
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 12:46:07 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-O6O-AV2iOMuQlrsTqzKThg-1; Sat, 03 Jun 2023 08:46:02 -0400
X-MC-Unique: O6O-AV2iOMuQlrsTqzKThg-1
Received: by mail-pl1-f182.google.com with SMTP id
 d9443c01a7336-1b05e96dabbso18151625ad.2; 
 Sat, 03 Jun 2023 05:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1685796361; x=1688388361;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=/kQXT/D1g1MKGoMUybziH35SAU5dVuYh1icWNGsyKOM=;
 b=V94QgyD2dKQCZnm6sD3W746WsFl5C8Aw/flUOd+cgc5uU0Dh4xHHH7zNAVzOb3pWqV
 Fc2tJdepsZL3Y53d6itz1klo05yf9lR6MCF6pmfAAOHwXP1AdBA5iqpzDvMbs9eoak1f
 ZuM4onhy3IxnTWHTxsa2Hzb5FaVUWhgw8+XadQOA5kYXn+cEbernuL+kTwQRzaeKnmOD
 71v+zin4u0N4bGQqxHITCXUKtGWbfbWzliBBbzmSDJzImT/vYF+0fvR1Uy0VGZ5o/TtI
 sPHVWsLOv9YwOMoxxfUeLZM/tdQmGNTSQOzqbMJeW/UWKir22PwjmBvX1FS19RNX3c+7
 J5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685796361; x=1688388361;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=/kQXT/D1g1MKGoMUybziH35SAU5dVuYh1icWNGsyKOM=;
 b=TmgQ82ktWv6yAm9du+rTu+gC4ajUzSfke923Is7vX6Q/Y9dyq9hT0krortaBp2fznm
 bfW+fmKg3Rlo2c/oMrR2IftG/4qdtwAGcTlFfGrTO/Lc4jGahCq9QT5dAmHh4C64IjQH
 oGrqe6znU6DSbqsBQF2/RJ+57ZN1nuM5RpAZ3EaJIihMb26OelmhNiLID7CunOIncIP4
 6eC9gGjjYWnPTyhMacpFBLWjaExl3A2ngwK+eDHTMiVdHeZH5eF59KtHSfYVF3lF2sZ0
 tMHTIJN2s3sT+zOgvnwWW185lA+FEdueTcrx0Ez4g4GTiCMMQOxRWlcm/4R+icQ9uAUw
 uiyA==
X-Gm-Message-State: AC+VfDxgaDaoUPBmQLJF7VPhpSC6Qhp6gWyZj073FpFOCEiiE8gx6xvU
 kMkPvPQ+ECkMcMTdxiHjpAX/cBE4UcquXA==
X-Google-Smtp-Source: ACHHUZ7ul+2AjGHwv8RU2B7FQ6sTqG1EpxJS5Sa4Q6Il2hpdcn5WhfTnme1v+Di5r/la48egqoyLfQ==
X-Received: by 2002:a17:902:ecc4:b0:1ad:8c8f:afb1 with SMTP id
 a4-20020a170902ecc400b001ad8c8fafb1mr1653007plh.39.1685796360756; 
 Sat, 03 Jun 2023 05:46:00 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-18.three.co.id. [180.214.233.18])
 by smtp.gmail.com with ESMTPSA id
 w12-20020a170902d3cc00b001ae6e270d8bsm3100571plb.131.2023.06.03.05.45.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 05:46:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 702F31069C9; Sat,  3 Jun 2023 19:45:56 +0700 (WIB)
Date: Sat, 3 Jun 2023 19:45:56 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>, mpatocka@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com
Message-ID: <ZHs2BHGBrJ-YGd-v@debian.me>
References: <20230530002032.15227-1-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230530002032.15227-1-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH] Improve the dm-integrity documentation.
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
Cc: Linux Documentation <linux-doc@vger.kernel.org>
Content-Type: multipart/mixed; boundary="===============8200849996881646521=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5


--===============8200849996881646521==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PWdwoCEpVKy8qUSn"
Content-Disposition: inline


--PWdwoCEpVKy8qUSn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 05:20:32PM -0700, Russell Harmon wrote:
> Documents the meaning of the "buffer", adds documentation of the current
> defaults, and provides an example of how the tunables relate to each
> other.

What about splitting this patch into three-patch series, where each
patch do one improv?

Anyway, I'm reviewing the wording here.

> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/D=
ocumentation/admin-guide/device-mapper/dm-integrity.rst
> index 8db172efa272..634a780d7c51 100644
> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> @@ -25,7 +25,7 @@ mode it calculates and verifies the integrity tag inter=
nally. In this
>  mode, the dm-integrity target can be used to detect silent data
>  corruption on the disk or in the I/O path.
> =20
> -There's an alternate mode of operation where dm-integrity uses bitmap
> +There's an alternate mode of operation where dm-integrity uses a bitmap

OK.

>  instead of a journal. If a bit in the bitmap is 1, the corresponding
>  region's data and integrity tags are not synchronized - if the machine
>  crashes, the unsynchronized regions will be recalculated. The bitmap mode
> @@ -38,6 +38,15 @@ the device. But it will only format the device if the =
superblock contains
>  zeroes. If the superblock is neither valid nor zeroed, the dm-integrity
>  target can't be loaded.
> =20
> +Accesses to the on-disk metadata area containing checksums (aka tags) is
"Accesses to ... are ..."
> +buffered using dm-bufio. When an access to any given metadata area
> +occurs, each unique metadata area gets its own buffer(s). The buffer size
> +is capped at the size of the metadata area, but may be smaller, thereby
> +requiring multiple buffers to represent the full metadata area. A smaller
> +buffer size will produce a smaller resulting read/write operation to the
> +metadata area for small reads/writes. A full write to the data covered by
> +a single buffer does *not* skip the read of the metadata.
What about "The metadata is still read even in a full write to the data
covered by a single buffer."?

> +
>  To use the target for the first time:
> =20
>  1. overwrite the superblock with zeroes
> @@ -93,7 +102,7 @@ journal_sectors:number
>  	device. If the device is already formatted, the value from the
>  	superblock is used.
> =20
> -interleave_sectors:number
> +interleave_sectors:number (default 32768)
>  	The number of interleaved sectors. This values is rounded down to
>  	a power of two. If the device is already formatted, the value from
>  	the superblock is used.
> @@ -102,20 +111,16 @@ meta_device:device
>  	Don't interleave the data and metadata on the device. Use a
>  	separate device for metadata.
> =20
> -buffer_sectors:number
> -	The number of sectors in one buffer. The value is rounded down to
> -	a power of two.
> +buffer_sectors:number (default 128)
> +	The number of sectors in one metadata buffer. The value is rounded
> +	down to a power of two.
> =20
> -	The tag area is accessed using buffers, the buffer size is
> -	configurable. The large buffer size means that the I/O size will
> -	be larger, but there could be less I/Os issued.
> -
> -journal_watermark:number
> +journal_watermark:number (default 50)
>  	The journal watermark in percents. When the size of the journal
>  	exceeds this watermark, the thread that flushes the journal will
>  	be started.
> =20
> -commit_time:number
> +commit_time:number (default 10000)
>  	Commit time in milliseconds. When this time passes, the journal is
>  	written. The journal is also written immediately if the FLUSH
>  	request is received.
> @@ -163,11 +168,10 @@ journal_mac:algorithm(:key)	(the key is optional)
>  	the journal. Thus, modified sector number would be detected at
>  	this stage.
> =20
> -block_size:number
> -	The size of a data block in bytes.  The larger the block size the
> +block_size:number (default 512)
> +	The size of a data block in bytes. The larger the block size the
>  	less overhead there is for per-block integrity metadata.
> -	Supported values are 512, 1024, 2048 and 4096 bytes.  If not
> -	specified the default block size is 512 bytes.
> +	Supported values are 512, 1024, 2048 and 4096 bytes.
> =20
>  sectors_per_bit:number
>  	In the bitmap mode, this parameter specifies the number of
> @@ -209,6 +213,12 @@ table and swap the tables with suspend and resume). =
The other arguments
>  should not be changed when reloading the target because the layout of di=
sk
>  data depend on them and the reloaded target would be non-functional.
> =20
> +For example, on a device using the default interleave_sectors of 32768, a
> +block_size of 512, and an internal_hash of crc32c with a tag size of 4
> +bytes, it will take 128 KiB of tags to track a full data area, requiring
> +256 sectors of metadata per data area. With the default buffer_sectors of
> +128, that means there will be 2 buffers per metadata area, or 2 buffers
> +per 16 MiB of data.

OK.

> =20
>  Status line:
> =20
> @@ -285,8 +295,8 @@ The layout of the formatted block device:
>  * one or more runs of interleaved tags and data.
>      Each run contains:
> =20
> -	* tag area - it contains integrity tags. There is one tag for each
> -	  sector in the data area
> +	* tag area - it contains integrity tags. There is one tag for each sect=
or in
> +	  the data area. The size of this area is always 4KiB or greater.
Corresponding sector in the data area?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--PWdwoCEpVKy8qUSn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHs1/QAKCRD2uYlJVVFO
o3sUAQDW3rmkdctzCygsLFvbfkCpt5czPdlpXyjZs+t1soVdeQEAtLmhK+CY2aJk
cCjdkPt5kB6FLBq8BrGlzeva5BCGOAk=
=II0O
-----END PGP SIGNATURE-----

--PWdwoCEpVKy8qUSn--


--===============8200849996881646521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8200849996881646521==--

