Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F135213F45F
	for <dm-devel@lists.linux.dev>; Tue,  6 Aug 2024 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722971551; cv=none; b=bisMr1ULVDQnjj1JxnZZlw6OLOKjcHFCCsd2uzf3kNQz7zNpJ6SxDjNUQMKnMD496BVJQQj7g0OOM2+6+G0cRLFdNgjVs9f0+XBiggyP5pbHOQGA+7iGM6Xd1Pth3nJ+/GOpEx4CWvPRvjostze6aYynm2UiD1Nvrpzm5Kd8yEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722971551; c=relaxed/simple;
	bh=ULwUyEyPebuFl5qnDeN8DY/QorxJjo5z10icVVrhioo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YcduB2HIg56empjm5XCZLIRH5Of5PsedcZH8Yb00DiSJqnRIw0i+gd+9ZLYaq0tML6ioJ1CagwhxOJfDaWp4KJTkv3MDl2Q+Tj+BGyYv/yJXgxyqignf97k93K3WO0OpcP9MNQNEVKnTHU8mLzvnWL8L9ncIdRHHLLaC67HAFW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DPBMSfvW; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DPBMSfvW"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a108354819so1359393a12.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Aug 2024 12:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722971544; x=1723576344; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=81Du6myh8JQw2GeaQg7AYSTpn68/UMSHcA817K24wBc=;
        b=DPBMSfvWEBEEsbN8otw9SFkVMoffQJ0HNXHdT0XxuzYmOrz8Sr5qme4yZKVpOk7vBS
         asR2Yl0UDj/UvLffJEAGhlJNq70ijM6uxE2KRnTOjfAWEmQspxTS9pwQZHMyyssjiUzA
         1PDW0SOBaWXAjBgqk8n0Ygwl4tjRPlJ2VB7wGbRuBdEIH+LtcTIBrhVw8+rGBsWk7LcY
         VZKOREU23f5oEp8rqDe7WY4uHFBkJkF+uGgwlQYqFkgoPin/13HJBa8+E42NtTtV4Vbh
         hRFKKSfOAupYKRlNH0C/6XL7Ee9G7GLAbHMDybw8YBKTnStcAehmuEq9AQu/9JLjDlAJ
         2oYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722971544; x=1723576344;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=81Du6myh8JQw2GeaQg7AYSTpn68/UMSHcA817K24wBc=;
        b=juIr0XPRJ4VxgIEBwL0LMhDX11uVi/c3+I7/xUOEpqoL/YPp/7YuroI8FiBMQ1H3q0
         cB1ThAGffTPmA+CCvCVaLlpXLQM/8AAawBh2asC05aFyZB5eonbv8RbYaSyKQ1zhC0xv
         slkjjRJnWWyqWqVe2ikTBFhtlTJGuiCek/O7h8kwdnFg//6+bisXTpS6g5Hkz5PFTMwK
         roRJ3Nw1kossLSo4nA6ln2iSKkLvVX/iYb0JKwMQO7CK8YQ0nGDVPVWRmG7BiKwTVFom
         USFENdt4Er1i1w1wH8wM9klvmK/1e080xSskrTiJeS3E0chMuPv6jlTw2S9KVk5my3W5
         GAyA==
X-Gm-Message-State: AOJu0YxTfPGQ6QEpqGAhi6LxQYTacBjpjG+0Lq/zzAWZ4hWu38Yi/Q5g
	7d6hmPlV0cTvS5T8U2yZXQcfDJvyvpbyWEqCX3tfyVGDcthEReQuk9gDLMmgNRiuMaxLrR+FQg0
	tXSs=
X-Google-Smtp-Source: AGHT+IF+vvywuGUE2xytZrTD/+70Chkb3W+MHoTSBPyFjiqL3zCDqiRxLzlA0847DHiw7PGqA1gMqQ==
X-Received: by 2002:a05:6402:270e:b0:5bb:8e10:176d with SMTP id 4fb4d7f45d1cf-5bb8e101872mr5736026a12.31.1722971543712;
        Tue, 06 Aug 2024 12:12:23 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b839c23417sm6196067a12.29.2024.08.06.12.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 12:12:23 -0700 (PDT)
Message-ID: <b2caea99035d97739460d8eb87231b16f57171ee.camel@suse.com>
Subject: Re: [PATCH] libmultipath: fix ontap prioritizer snprintf limits
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 06 Aug 2024 21:12:21 +0200
In-Reply-To: <20240802172650.3063016-1-bmarzins@redhat.com>
References: <20240802172650.3063016-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-08-02 at 13:26 -0400, Benjamin Marzinski wrote:
> The ontap prioritizer functions dump_cdb() and process_sg_error()
> both
> incorrectly set the snprintf() limits larger than the available
> space.
> Instead of multiplying the number of elements to print by the size of
> an
> element to calculate the limit, they multiplied the number of
> elements
> to print by the maximum number of elements that the buffer could
> hold.
>=20
> Fix this, and also make sure that the number of elements to print is
> less than or equal to the maximum number that the buffer can hold.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/prioritizers/ontap.c | 8 ++++----
> =C2=A01 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/prioritizers/ontap.c
> b/libmultipath/prioritizers/ontap.c
> index 117886ea..28e663ac 100644
> --- a/libmultipath/prioritizers/ontap.c
> +++ b/libmultipath/prioritizers/ontap.c
> @@ -39,8 +39,8 @@ static void dump_cdb(unsigned char *cdb, int size)
> =C2=A0	char * p =3D &buf[0];
> =C2=A0
> =C2=A0	condlog(0, "- SCSI CDB: ");
> -	for (i=3D0; i<size; i++) {
> -		p +=3D snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
> +	for (i =3D 0; i < size && i < 10; i++) {
> +		p +=3D snprintf(p, 5*(size-i), "0x%02x ", cdb[i]);
> =C2=A0	}

This seems incorrect, too. We should pass the remaining size of the
buffer, which is ((10 - i) * 5 + 1), unless I am mistaken. It's bogus
to use the "size" variable in the calculation of the remaining buffer
size. Plus, we should break the loop if i >=3D 10, and check the return
value of snprintf (if we don't, we might as well use sprintf in the
first place).

Actually, this code is horrible and we should rather use strbuf.
Strange that none of our many compilers found this, and even coverity
didn't.

> =C2=A0	condlog(0, "%s", buf);
> =C2=A0}
> @@ -56,8 +56,8 @@ static void process_sg_error(struct sg_io_hdr
> *io_hdr)
> =C2=A0		io_hdr->host_status, io_hdr->driver_status);
> =C2=A0	if (io_hdr->sb_len_wr > 0) {
> =C2=A0		condlog(0, "- SCSI sense data: ");
> -		for (i=3D0; i<io_hdr->sb_len_wr; i++) {
> -			p +=3D snprintf(p, 128*(io_hdr->sb_len_wr-i),
> "0x%02x ",
> +		for (i =3D 0; i < io_hdr->sb_len_wr && i < 128; i++) {
> +			p +=3D snprintf(p, 5*(io_hdr->sb_len_wr-i),
> "0x%02x ",
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_hdr->sbp[i]);
> =C2=A0		}

Same here, the remaining buffer size is (5 * (128 - i) + 1).

Martin

> =C2=A0		condlog(0, "%s", buf);

