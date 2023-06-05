Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDCBC7EE2C
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945054;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=g8/dn9SFh6Jsagyagqkp9ehsFoDGs4YZW+2Lw9wOqpM=;
	b=SVKYsz/WHpvI2EafiqYawohNK3cQcS1m+LHRLsQdZ+XC8M5F6qCX+xhefai7SD5vroz0Hx
	KI0CQR+NfiWRCFME/wB8wm+s6hUmlrsBAQZY/DKHfXhbRcBbyxVBBBZk7gtzCNIRuxKbEY
	Rg3XYdWf7TcRsmyVh9jSoMehFbP8dm0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-zn-dJKPQNcGbzZh7qatOyg-1; Mon, 05 Jun 2023 02:04:09 -0400
X-MC-Unique: zn-dJKPQNcGbzZh7qatOyg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F2971C07839;
	Mon,  5 Jun 2023 06:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09A71400F0C;
	Mon,  5 Jun 2023 06:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D35D1946F03;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 23D5A1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 03:03:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F41592026D6A; Mon,  5 Jun 2023 03:03:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA1E02026D49
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:03:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D396385A5B5
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:03:43 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-Cwzgf9HKM1K8iUggAMWqig-1; Sun, 04 Jun 2023 23:03:41 -0400
X-MC-Unique: Cwzgf9HKM1K8iUggAMWqig-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-652a6bf4e6aso1677528b3a.2; 
 Sun, 04 Jun 2023 20:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1685934220; x=1688526220;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=mWdcdMrnJAiS6RTXwcszHE76XJTG3Hdf8nB/jbpd3sE=;
 b=J386yKEwjWsTGr1SbV3Ja8Z805ivZdzva5NzDs7tBoQVI1oi0HhhrZtRZ+Vk/4Dz7L
 /EW4q8/Jed+WffG1iGFesxZLE/L61lChNGEAW6LXtSCP3NiMpa49BTb+2oE7X8asJRuo
 DCWZ3YXG4bnhyW5Mei2eocE+Xi1y/epfQTnTDj7qR5l0NnJgMfZi9DZIKxfuQ8bgqPto
 DkpiPT7h1tfx8TLdimAcZ1I9r4vgVAN/DBYraZk6kGguPoFNLV0J5iee18SSI9wXRuzY
 ato+7fTxg94KTnZhku3t8M1ORe71cUyJe/M8sd9h0OMdRA/qSpAaf9c1Q2k1R+5XFLQB
 oJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685934220; x=1688526220;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=mWdcdMrnJAiS6RTXwcszHE76XJTG3Hdf8nB/jbpd3sE=;
 b=aRfFEII7mAjS0EQOBmrpPBtKBW/XELvmPa8+6Llquqj+X/5v1VKPouVio7sOvisfOY
 6IUB835RUpFlx4J7tJQ4rTPOxbXQwWfCttAeSWLTK2DGigMFrWtdj6x/T8A5SYeWL08B
 2XQjzIK/oBzLqjutYE0qmBTQAwBYTgCYksIOhEUZoUXk9hARqIOZlPwLQmytuERbqVxf
 r4oO3aga4AXpdKdXmRHPTRGtIe+Fd2EiS3mzhITKOkNZ1VvBSbpLGSsgroP26hIxKk8G
 yJO2urEIGjT+O4plrfi2IxfNi416BmCj5ynVXXCbtcoiK6QmxZdLa5Dpb96TJPveH4qh
 6pqw==
X-Gm-Message-State: AC+VfDxVcjeGZ6Y1YQ8uxhaJ1tCSh40f/8dG9SiGg61BdlD5k8yEPGpi
 chkLwS9hqPOeGGQeji6W6dtOMk6btNSRyQ==
X-Google-Smtp-Source: ACHHUZ5dLXDuCWKOvSzBoUeuxSbRiWl1XIV1WVcIvw22mJXmktHBWwuzPd0rErU3hgWNKOnUXQDe0w==
X-Received: by 2002:a05:6a20:6a29:b0:10f:7abd:fe5e with SMTP id
 p41-20020a056a206a2900b0010f7abdfe5emr1706724pzk.40.1685934220141; 
 Sun, 04 Jun 2023 20:03:40 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-4.three.co.id. [180.214.233.4])
 by smtp.gmail.com with ESMTPSA id
 jh9-20020a170903328900b001ae6fe84244sm5305566plb.243.2023.06.04.20.03.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 20:03:39 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 662B41061BF; Mon,  5 Jun 2023 10:03:35 +0700 (WIB)
Date: Mon, 5 Jun 2023 10:03:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH1Qh90x9ncsBTik@debian.me>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-2-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230604190604.4800-2-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH v3 1/4] Fix minor grammatical error in
 dm-integrity.rst.
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
Content-Type: multipart/mixed; boundary="===============5122555930520107885=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9


--===============5122555930520107885==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Z3sn9xHmM8qUPI9d"
Content-Disposition: inline


--Z3sn9xHmM8qUPI9d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 12:06:01PM -0700, Russell Harmon wrote:
> "where dm-integrity uses bitmap" becomes "where dm-integrity uses a
> bitmap"

Do you refer to one bitmap or uncountable bitmaps?

I'm confused...

--=20
An old man doll... just what I always wanted! - Clara

--Z3sn9xHmM8qUPI9d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH1QfgAKCRD2uYlJVVFO
o/gpAP9RK9WaR4BvjyBdNTLm1Kzc1nL90zNY2tiFSqbcge/AYQEAgG9dzN/yqqoQ
Ij6oURSY8AgZdiio9UHtbtzcqObi/AI=
=JT5b
-----END PGP SIGNATURE-----

--Z3sn9xHmM8qUPI9d--


--===============5122555930520107885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5122555930520107885==--

