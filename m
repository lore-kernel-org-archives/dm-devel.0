Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E4AC7EE2A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 06:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686033913;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=cOVpSpQuEQB26k+kchgrAGPr5qbGVplWO54NafQXK+g=;
	b=VCk6oi8eYxxYccQKK/VqiDRSkGBPXP9/6qTeCyozhgInekRVHn+WcqqbE0+CjX+4toDe5V
	WuD6WU62GAJ/G4AOsDt/9xtgEJ/2VOknQxegNBjA7fcZNQGBll51tZTpnZM/ixML+Iq2cU
	iM3Y/TzYycb/+e3HBeGjRJnyWpSLT90=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-KxdUKgC2P4Wqib_y-vpszA-1; Tue, 06 Jun 2023 02:45:09 -0400
X-MC-Unique: KxdUKgC2P4Wqib_y-vpszA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC119101A53A;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D62EC492B00;
	Tue,  6 Jun 2023 06:45:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D881A1946A45;
	Tue,  6 Jun 2023 06:45:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 08DF41946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 02:18:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98BB749BB98; Tue,  6 Jun 2023 02:18:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91277403174
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:18:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70E7629A9CA6
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:18:41 +0000 (UTC)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-wgJoaQvSNVmQFj6B-tvgEg-1; Mon, 05 Jun 2023 22:18:37 -0400
X-MC-Unique: wgJoaQvSNVmQFj6B-tvgEg-1
Received: by mail-ot1-f44.google.com with SMTP id
 46e09a7af769-6af6f49e41cso5204165a34.2; 
 Mon, 05 Jun 2023 19:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1686017917; x=1688609917;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=Pq85JV2SdkTWT1UykTpgwMJ7kQGul6RVMXpZztrA70k=;
 b=ALScxAXZfrT9BPJUTkAeH2f8cYqLzBXaTf/a3oKF9zKW9UtGYAPWsWq8eBVk3xUIcY
 Jd8t90JZdVk7gmx/cmuNhxlPjygWg+xXmkv8RMuHFPs6YxxDjyLml22nFlNKFeu2M7Mz
 QIUVRxqQbXpo853W/qRz3cjtet+cBVRChokpyvp5RQ9OcKIrGuYjjbeyPst5nikt833V
 eDyJ3hzO5QfxTBTIawravz1KwvPUNY+DjNNcjFw2JipI1pIrbaU1576h6PrDZisrnDeG
 x0g5sc38MrMte482vHPlMGF/cChPPaSDrQEnpdxZS3dYNyv0u07Vi7EK59I+bNpVcRM2
 vFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686017917; x=1688609917;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Pq85JV2SdkTWT1UykTpgwMJ7kQGul6RVMXpZztrA70k=;
 b=HacP1Uz5Ntw0UoZGyE03KiWZzC/yQdEOs8/t04lnIW7SCOuqgvN1RNRkwvsmPDwiv+
 Xm5HIHT5UHxgUV4oV3uDubvH1rS3Ls7ziZcC5cU8GxDaHuqQgdsISH2Cs+Q5Eb8TnGz4
 42UnlGPnI63YXD1WpF7s2IzUXeOQJ9+J7G2qqftatfvZr/4d6wkleVMibtBxT7PrC5Ro
 NLT2Xaxh7svlFh/RD0fzH+4llj0/pVYwvyVIWSFLN65YIm7vtKNb+1uIKiBN/xpe9CKU
 j4XJX5WBmU187BqwLZxNE1emO55NIDHQW9UfwlIsVNc8Tmn4Z9MzQcCQmElFCo5qgEJx
 VlKw==
X-Gm-Message-State: AC+VfDx0MpoKyyMD+P+n3FbnNdZ0x4sxiA4lZZy78S5xy70O550b2/pt
 KNQrIcm4ruomHt4QTd0TY2dLPp5iEqI=
X-Google-Smtp-Source: ACHHUZ73hfAfBiMqB9tqWPbU/FwVETl7ryRQhqynyRWcQRUNX7uwhnkiuU+pE67e3wnEXA/xLD7HVg==
X-Received: by 2002:a05:6358:bb89:b0:129:cf4e:c0e1 with SMTP id
 df9-20020a056358bb8900b00129cf4ec0e1mr796577rwb.32.1686017916654; 
 Mon, 05 Jun 2023 19:18:36 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-36.three.co.id. [116.206.28.36])
 by smtp.gmail.com with ESMTPSA id
 q5-20020a17090a4f8500b002563e8a0225sm6890499pjh.48.2023.06.05.19.18.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Jun 2023 19:18:36 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 604CB1069FD; Tue,  6 Jun 2023 09:18:32 +0700 (WIB)
Date: Tue, 6 Jun 2023 09:18:32 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH6XeM4Uir4zQMn6@debian.me>
References: <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230605050853.6240-1-eatnumber1@gmail.com>
 <20230605050853.6240-3-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230605050853.6240-3-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 06 Jun 2023 06:45:04 +0000
Subject: Re: [dm-devel] [PATCH v4 2/4] Documentation: dm-integrity: Document
 the meaning of "buffer".
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
Content-Type: multipart/mixed; boundary="===============8100553598056294991=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9


--===============8100553598056294991==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8dT9jEFPjY4b25Xy"
Content-Disposition: inline


--8dT9jEFPjY4b25Xy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 10:08:51PM -0700, Russell Harmon wrote:
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

--8dT9jEFPjY4b25Xy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH6XeAAKCRD2uYlJVVFO
oxMmAQDQw+DyLg4djiSiS72ErEICH5CXhJavIm92BeL22KsbJgD9HON0Q4ehRfPA
uydfE7iQ8VprJ9S5xNAHQXGHgGoIMAU=
=Gs2+
-----END PGP SIGNATURE-----

--8dT9jEFPjY4b25Xy--


--===============8100553598056294991==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8100553598056294991==--

