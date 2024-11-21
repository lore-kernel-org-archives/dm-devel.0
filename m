Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED2E189F37
	for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732208754; cv=none; b=CBqCs6tdZh1hVmLJYu91Nvc6dqAbsFFhy0T0JdhJiowQLbWStzOm+B2ijXsRBmCQqUsGSfNpWrts7vxEWPiHEPrjvIAJIVBWe6BWPbrSMO040Ju8p5L5LVXtCbGyc20ibzOYKwglOqE+LbVxFFVZTHtRKXuCgZJjlZsYfLrPh9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732208754; c=relaxed/simple;
	bh=g4fv93OIgExtp/+zIJu34GJnCQrSOu7LHjO7WFzQw8g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=szTu9LILCfJPDD2LtYoM+jXD1g5sHUvye3qmQdcdz00UPg/9llY8Ya3cC1W9NYsOtEEyuUsUX8BAkp1LOAk4mfl0NdpCIWR+Gr5PxN/h0zqHPw31vE9pOhHSJ3ZdSZQr5ADyNfrieFtdgnlDn5ihcgVh1VaadkhCkLjxEBalQxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SKw0G9I6; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SKw0G9I6"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3824709ee03so817096f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 09:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732208751; x=1732813551; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g4fv93OIgExtp/+zIJu34GJnCQrSOu7LHjO7WFzQw8g=;
        b=SKw0G9I6Z7ieylrw+XFoH0k0EMAbS5tk7BhJNCgM4tuG/Qgwz7EQXP/kHNXXhJ/g7l
         F5J/Hqav+T0dNEFY43nRVyJlQ5ObQ07xoa+o/DozQ7s5gLTwaBCM74uMtvUNJBeI3eER
         ZKOzh9A9lLM3uxeNK5AnNDgebwaZx1SfBm5L7qhk16968MTvA0zKSfeYUi2OHbvYFTuQ
         zdQJLZ5PVHA9RD8Q8IVg9IzuUSTx+JaCZ9lvINAdzsH6nmr1y+Ne6b5/pA4c1k5lyk7L
         ebPNmVaAHCs2Fc/GG/rcrTqmA9taG2jSEMjjizHpHBmqjRs82Qv5EynZKcaaNce4gilK
         z+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732208751; x=1732813551;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g4fv93OIgExtp/+zIJu34GJnCQrSOu7LHjO7WFzQw8g=;
        b=B+pYuNlTLUAXYVlgzPr0h8C0T9JE8wqpK2SWEqzwFHWVClmuKYbWXJ3HuG64kmladz
         GG0BtkFGrB0pLSSpJfP870ey0dEeClUuieCDUhtko35axC+8C2OG5A0XyLVpVNNqZK+3
         v4/KVZqp0h5iiJ1BAs2aQKmiF9A6AltsNkRLwB7wld1N+V1HuQDyUGyQeWIq2c2VQGJI
         zBaUGu1s2sdM3447NqhxJnfvJsG9DDfJjFen9+aQ7wz5sRPxyAw+42ARsfWz9T8y/Igv
         mLGQ9/tQZ7tPF/749xhxAql9YrjI5Y91gC0sYfCbVXM+UgrO0xVGwZK5aMzo9I+RZtXG
         1jBg==
X-Gm-Message-State: AOJu0YyWp89jQ4nfHU6ED47T6G0kD+RLQwiMnBp6xd/fNWQxyhAG0OkI
	CniWsaatTJMkiD25fowQw38xna+p6eC5HKfTfS928MoGSRjuCXLfPC3MmAQOAEY=
X-Gm-Gg: ASbGnctidZIzafiOdTSjmifXH2m4Z9ChyQHTRapsqsfTNhYynU1ckc9aX/H8ATbqN++
	zrU8DtkNC8911yl2aa2MQXMtT48sG9SHCuoSYK7rtL+BTHXgdroLYDPE/nG46CaaFXC8KB2u7n0
	Jj1cYC6HsCgQPWWqViiTefUqZ8HH5yK5jtgTIXVyBvQdBqJ9rngOUUsZHM0h0FVJIM64XB0o9DA
	yFhRASwsm/q+bD04L/oRJLmRlOvVyhSgLgEa1CT96P+7UIO+55ZFNnleBXbWL3Sdzrfx7njocal
	gtVu5fPfOAVz1YcHPPDhxsctcvhKjZPw+kW2hJ5rqY26oigJo5Z2YKfb0Z6n158gXAQ5F6K9iK8
	QnV5zNg==
X-Google-Smtp-Source: AGHT+IHR+PxrsP8DCGM80O3O58DCOtwG3Hg5iQKq5dUnGDFHHJXR1p3FfUXlHiT5H6Z57ShnsLxx1g==
X-Received: by 2002:a5d:47cc:0:b0:382:49f9:74bb with SMTP id ffacd0b85a97d-38254b00f2amr6557203f8f.35.1732208749614;
        Thu, 21 Nov 2024 09:05:49 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc4130sm34653f8f.65.2024.11.21.09.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 09:05:49 -0800 (PST)
Message-ID: <6f53bcf8b37d466e92609ab0a21672ff50914461.camel@suse.com>
Subject: Re: [PATCH] libmultipath: Fix MAPINFO_CHECK_UUID with partitions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 21 Nov 2024 18:05:48 +0100
In-Reply-To: <20241121001744.699362-1-bmarzins@redhat.com>
References: <20241121001744.699362-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-11-20 at 19:17 -0500, Benjamin Marzinski wrote:
> In libmp_mapinfo__(), if is_mpath_part_uuid() succeeded, instead of
> ending the 'if' statement, is_mpath_uuid() would be called because of
> the OR operator.=C2=A0 This would always fail if is_mpath_part_uuid()
> passed.
> This meant that libmp_mapinfo__() could never match partitions with
> MAPINFO_CHECK_UUID.
>=20
> Fix that by not calling is_mpath_uuid() if MAPINFO_PART_ONLY is set.
>=20
> Fixes: c1aa0285 ("libmultipath: make MAPINFO_CHECK_UUID work with
> partitions")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Ouch. Thanks!!
Reviewed-by: Martin Wilck <mwilck@suse.com>

