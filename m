Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11AAC7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=eF0mXYeVRZt7k7pEhgn1Z1MiXVn+SF/tBy9QyXtogl8=;
	b=bi6xdaH9z58ElgCxFVbV6/olGT5tNfaKp0OBxfqo5f5PFq7lGwnIYshkvidjaLtI94rHeA
	9c9cMmudocnMxlc0dyeIk4Hspc02aKE2NOZLHHkkgoiYL4NU8o2c3EcZHpOaQA5gS9eMI3
	2prtMEtwTFXue41avpphGJTzHw4CLbg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-DOQHjxsMOgq8ifF_E6wtUw-1; Mon, 05 Jun 2023 02:04:09 -0400
X-MC-Unique: DOQHjxsMOgq8ifF_E6wtUw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA96A8027F5;
	Mon,  5 Jun 2023 06:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D59E2492B00;
	Mon,  5 Jun 2023 06:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B41A31946F17;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 586EF1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 03:05:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E90442026D6A; Mon,  5 Jun 2023 03:05:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E16F92026D49
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:05:14 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAE7F3C01C2A
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:05:14 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-3TiPAebRP0euWmTG-TQ9AA-1; Sun, 04 Jun 2023 23:05:11 -0400
X-MC-Unique: 3TiPAebRP0euWmTG-TQ9AA-1
Received: by mail-pg1-f176.google.com with SMTP id
 41be03b00d2f7-51452556acdso2394497a12.2; 
 Sun, 04 Jun 2023 20:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1685934309; x=1688526309;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=s+SNS/Ez4V5YrkVuSk178SGGNvobB71usHfX95QcJcA=;
 b=VVMsaF21C3cO6D7tiqZrbqmS/iJ1KQYzuduhTxCIhtIK5EVbx/3FwI0l7/zn6Ddkrm
 2wto5NYYhnkaXQnUwnPhXz4sV/jZ/kZg5AOJCZ9sN6zN38S/sAC/eFuq4Pp1bLh1ov8T
 5ZlIUDPkk2ChuvsKtm9+zydlpTyYDkQjnPcEn+E0ljaWFQbEADoO3z1ahVm75blw1Az0
 PjvlE8TF1kBfA74T7un9Op1NYgC2/7ozwwvWsSvtmF98zkbik+lAmv75FHCOu/k9Pno7
 OL9J9e7WU8FoaT+j1vUanEzsgrPvj9TfZuonML8Bh6RVE4IWVdHihwK5Sblm9XxAY0pb
 TkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685934309; x=1688526309;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=s+SNS/Ez4V5YrkVuSk178SGGNvobB71usHfX95QcJcA=;
 b=af8s/pIRzO1VnXcf8PiPQXDK3AmwVV03TwpgGwtCOfbcg/U7Wc1B0kUjQ43MBvEu0f
 2sFOQs9nM7EqUSV66HW7A6ta+2MXNaXMMYYmrb4XzeEbrKFjebMe6fRPZme/em18byVd
 FhZNh2nPn6xjo3tg8Ws6YDXZuh35Pmv46ahhCAiX/ePpE44ySn4LB8ByML4aNXN2DWNA
 AvaOvjBarJVulqDsu6aoYaURs5S1kfbHVbOlol8qgAkaLK4lPUh1ZkBoxBv27tmq+roR
 PSgV2TOWjTfBC2VvhtTRMawCR1t1K7QiHAhaAZqM68WuE2i6zBjhw2t2pY0y9vgJalwx
 iE0w==
X-Gm-Message-State: AC+VfDwjh9PF5jH+Pal0IZv0fKuBT80ZHRqk/ewAIcXT1VIstAgWiFao
 aJOA+6hf1VfWBfX27qHbQMFkVuugbjtKQw==
X-Google-Smtp-Source: ACHHUZ51HSuF7agss6dH0Air78er6+DFls6LF/iE9dOl0Rb5IaZm54LaOgUz1hLenDpw/WeylSIQPg==
X-Received: by 2002:a05:6a21:9988:b0:10b:8a27:bb59 with SMTP id
 ve8-20020a056a21998800b0010b8a27bb59mr3325496pzb.47.1685934309515; 
 Sun, 04 Jun 2023 20:05:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-4.three.co.id. [180.214.233.4])
 by smtp.gmail.com with ESMTPSA id
 s22-20020a170902989600b001b03b1bcf6bsm5271327plp.252.2023.06.04.20.05.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 20:05:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 820431061BF; Mon,  5 Jun 2023 10:05:06 +0700 (WIB)
Date: Mon, 5 Jun 2023 10:05:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH1Q4n-1bCJLr9r-@debian.me>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-3-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230604190604.4800-3-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH v3 2/4] Documents the meaning of "buffer" in
 dm-integrity.
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
Content-Type: multipart/mixed; boundary="===============4874856212566910235=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9


--===============4874856212566910235==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HgsTtJwVqSUW+qkf"
Content-Disposition: inline


--HgsTtJwVqSUW+qkf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 12:06:02PM -0700, Russell Harmon wrote:
> +Accesses to the on-disk metadata area containing checksums (aka tags) are
> +buffered using dm-bufio. When an access to any given metadata area
> +occurs, each unique metadata area gets its own buffer(s). The buffer size
> +is capped at the size of the metadata area, but may be smaller, thereby
> +requiring multiple buffers to represent the full metadata area. A smaller
> +buffer size will produce a smaller resulting read/write operation to the
> +metadata area for small reads/writes. The metadata is still read even in
> +a full write to the data covered by a single buffer.
> +

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HgsTtJwVqSUW+qkf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH1Q4gAKCRD2uYlJVVFO
o7tHAQCS4G9fVnWvbe+hdX9Gke3Gy+4g3X66+S82pYomEa7KewEA5AtHtuc7/ZYT
SlUoHPXalukvSbgIcnRyXU136buJ4QE=
=3XVp
-----END PGP SIGNATURE-----

--HgsTtJwVqSUW+qkf--


--===============4874856212566910235==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4874856212566910235==--

