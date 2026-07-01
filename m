Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE66255F52
	for <dm-devel@lists.linux.dev>; Wed,  1 Jul 2026 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782931927; cv=pass; b=e6fXLmrYy5nOWu6UwVnVFf8TfnXTl1B4mcHqeytHeK6S3Fpe4HF3jkjhg5p7fG9she6FYwCai+VhfL2JcBnVa+rwOGZ1gXrKGooK5cMxl8ic3t6IA0ds7oG05JPAHiC92KhFxyhoUADbLBTm1nfITXsfX9C10PgKo83Ee+QaGSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782931927; c=relaxed/simple;
	bh=QDVIcdzCibnl5+6tpjDIp07OJM1iXiYZQqNhDeS5SU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=urXVi4aZlxBtm+7XrQ9u1uM20KGMSbTkHeBbz3PV8sP5ZWzmZ8k/z8mOUabQEVLF73rHOxYJlco6hDt7iRf7LUaJZL2fPJUAUTyjGJDlYATkjyF4Y5IHDIKEGqKQenQ3G4jLE6XqRQR8pHT4gxQsLVPYsujZBpfJ+qVPWXFE7ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qftjxe0G; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qftjxe0G"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c15a5b265so361451cf.0
        for <dm-devel@lists.linux.dev>; Wed, 01 Jul 2026 11:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782931925; cv=none;
        d=google.com; s=arc-20260327;
        b=IFHIlZHdfBI0F5aVz/YB3W7n230aTdew7ztSC09AOQU77kLTXVUO2MhBW678+AmuYk
         vXfYRfHLrLY9X1l9Q1wPbbFauJmcvJrcfuvXfQOLAAp7GekNymsCZ+dKXDbOR0gjhm5Y
         rU+Rp0F239+1wSFGbsw9Ji5U3GsFPwYF65QUFa5tEicV0sX9TNV2yeAEQG27Rs3yKTXk
         ce60UQbOACH5vWm/tWYOlJ2vbqpRH910svBmJiyfHiq9/FzQNqr4tW6p+RfulU4cUIfX
         1Lxr12HDsmhAHcPP3+RpzCmzC4mDCpEHuJ0EdhJKXHufz5U7n96z1gL9CmS2d2ul8IVB
         7oBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I3K8SlhVE2jTeHWzTKVFQEHQCyyP/5CSw32TajyqsN8=;
        fh=RCyNJFnwxTDKJlWwoLgUFOwRkQBngy+Nhah+qpgc2yU=;
        b=GiwU/dqIwP0oOPqmlgSjYm3ebxE0FhNt4wNZZvnTp9uUgiGv3KWEzPl1/ZIjUO0i5z
         wJhr1z98oyBEUefiCrhG7JEdEhy+vHzCkhWjm0h6Qqimq4cwyYvcEyM7y5sEygS0Dn5l
         QWB1wulXRjftZkgbkdeB5/9iCAQgFPhqZYsyvukCBzCXtfzoYLxbRezGc6f+wZ89mgx3
         w4UAp1P76SjKRROZPRJ80avO8VubTNpL6sNAg3JpwDQdINBUMhhWxdmxC4xmJr8FugbD
         u2Onvqq2VcJszhAKE7apsjTNl75zEOrIQjONe3ZzhhrCu/FQOBd4f87LlmpHB1JsjLhs
         QBpg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782931925; x=1783536725; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I3K8SlhVE2jTeHWzTKVFQEHQCyyP/5CSw32TajyqsN8=;
        b=Qftjxe0GbKR2ve03ijilNql+24dQ6u4ReYQ5J6qzsZifhqKGG2Qagfo2rXTKz12FV/
         P5TlViDNUi6iPyWWy23ggoij4tVrTmaewf4mbb5MTThs2btxQHIWhofP9lfu0SNMh4Jj
         vagEAGe+Vio2FAWeWsYH8fV6rFbQ0XMnyYUpfK/2myL7bDOjHgdIbg49s75SMWaWT/Hd
         Upe5n32w0CxzdU8IYGdQMfUDM4rSqAADm4WE82cNbrMgIaaoj3IImUOP80fnqY2Gd69V
         j1Oqljz254ZQiyzxLlzLhYxdjUCz0h0P0g/yalkP6XU5XtM5qro+oUcNyoldZMGmEPkL
         houg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782931925; x=1783536725;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I3K8SlhVE2jTeHWzTKVFQEHQCyyP/5CSw32TajyqsN8=;
        b=nGiupioyjGBeh152ankXD39BfiSmd+kMuuBP5Dym5xF/pPdTrE/AL3FKWogOLj5KMh
         j6/7hwwi1gRcdBzYIzD6ReYVwrGV0nkJCgjLaNNQUT/HznyAu+sJgjKIpgbVK+Zv5cTI
         2e+C2zIOVFMqydsAE+yMf+1tm5zX1QM1o+XF2e8l0uitFgbmLdmSrH1xNwv6FEklM64H
         4J9CXNmLbzYfupWK8arfNYbYDs5b+IR+iiiTFT/ycR/Yy4BYZmhc3i9sV9oX/7P9u1bV
         vDGlje2uouGjOuuNl1JMDSv1cngMkU1loKIeDKbiI0V982xZFY0xiEH3imtqAc3QCt/T
         RVag==
X-Gm-Message-State: AOJu0YzEGqottrqCBxrIxZSUHUInnEdpfcIySPKXmjmcpHGQP5vdaWhe
	s1DXP7+Edl/vKKaRMz/GzrC1BdL8LPh3HJIsdDiz24z7jLTtBEEdFXrq53MajrbD90jUkWt5fTm
	FByPA4eBjkpKjEE3RhBluLDUOwrRBAfThKOuJez+v
X-Gm-Gg: AfdE7cnm8B/e2RX5rlPExHisS5enMuhaGAzWxgw6lEWZRGURSXBOyh2EeIYACu2OW59
	LszLYNlLkgOdj3/OhgRD6G1on8vQpxZOolad7K7rGGYOYjd+pUnqOV62OxvVsiWlzHDU5ijitN2
	dDzJOc+mD/jOiRId3PsDo2TfklhrIqNwR82A2IHDHF8EDmCbUjEV0V0P7rpc3XvopoGaCjH8pNn
	6sB6vxoIhiTmq78jiAKQXZO1cSG9yqGRgPv7/16UM1F4WPE0YmtP10LPMNlBzWgLWErqA==
X-Received: by 2002:ac8:7d85:0:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-51c24a73e61mr8956581cf.7.1782931924913; Wed, 01 Jul 2026
 11:52:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <40e88304-8e8c-4bb9-12ac-e7a67b130af1@redhat.com>
In-Reply-To: <40e88304-8e8c-4bb9-12ac-e7a67b130af1@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 1 Jul 2026 11:51:28 -0700
X-Gm-Features: AVVi8CdL7EoaJm0Xg1XAyC2s9AIJZmnwPGU9yaX9ZSuMXso3SWkpm7oF_XHbxg0
Message-ID: <CABCJKue_H1T_v4Mar19JqsM3n7yogLLPPCT_idUXm=k21WnSmQ@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: fix buffer overflow in FEC calculation
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Wed, Jul 1, 2026 at 9:14=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> I used Claude to search for bugs in dm-verity and it found this. The bug
> is real, the buffer "lambda" in lib/reed_solomon/decode_rs.c can overflow=
.
> Claude proposed this fix. I'd like to ask you (as you wrote the dm-verity
> FEC code) to review this patch.
>
> It seems that we can also redice the size of fio->erasures to
> DM_VERITY_FEC_MAX_ROOTS entries.

I agree, this looks valid, and we should also reduce the size of the
array. In addition, it would be nice if decode_rs8 would return an
error when no_eras is too large instead of just quietly overflowing
the buffer.

> if (neras && *neras <=3D v->fec->roots)
>         fio->erasures[(*neras)++] =3D i;
>
> This allows *neras to reach roots + 1 (the post-increment pushes it past =
roots). This
> value is then passed as no_eras to decode_rs8(). Inside the RS decoder
> (lib/reed_solomon/decode_rs.c:113-121), the erasure locator polynomial lo=
op writes
> lambda[j] where j can reach nroots + 1 =E2=80=94 one element past the end=
 of lambda[] (which
> is sized nroots + 1, valid indices 0..nroots). The out-of-bounds write la=
nds on
> syn[0], corrupting the syndrome buffer.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Cc: stable@vger.kernel.org
> Fixes: a739ff3f543a ("dm verity: add support for forward error correction=
")

Looks correct to me.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
