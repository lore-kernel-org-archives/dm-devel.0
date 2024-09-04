Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340321E0096
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466424; cv=none; b=Y5A3BGzt1UYALFdqivfy2pOfI7ERgR//B1mwHaYRZdfH09cYS+HXymzxCrRnB/GtIMdBw2bkJKuMn/YHokc+GsouwQny5XUbJpzU6QA5e9y3TLA+MJR4rd1ZApzwbvdbWmjxlbbHfw2wuNktS5iC2IHvamyW3GRgs7MgPSmfFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466424; c=relaxed/simple;
	bh=G3mwdqNEgxJHaFHrF5ReVclTR/g9GJRpgrDUa6Fw9Qs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pPLMYuhjjETfPr3woc9PwLAge37v60E5Ru2SG5OIYHvCEMYiGjSOdzaPptoHh9JTw9oHp6ACO9p25b4pz6LHF7TIdBDjWSngRarDIrTsnIj4s/R4/UvSif7tjCaxR72XxJi3N3IFxpoZlXSib9XpDQ1yPEsP08Qm6CwZLKKcLjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BVImRnwN; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BVImRnwN"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8682bb5e79so139522766b.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 09:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725466420; x=1726071220; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G3mwdqNEgxJHaFHrF5ReVclTR/g9GJRpgrDUa6Fw9Qs=;
        b=BVImRnwNzIYJGvZ9Qbvv/shrstSb17wBF0rCWREVnkGpU74IFEoL0l0H+sZIkrVx8d
         bbFWga0xleWBUDlYP//DzTYIC2ImgEQB9aQjIhwbJSI38uYghz6lZS/7it+O33Q8Jx7W
         BbT+n3KUmcnKpiT0A+QQO/abvqsBNiLt1l67H97GFLPYmUFlpisy8BZNVIzMzc+eT/K+
         WQYvqWA5qSGi1vOqIhXLs2r88tTJ8wC7KapejcNyQFDdKuX/7Cq0olEjo6U+vnE4nEX7
         Z2cBpHSo2FgeHo19z1Scg8K5iy4UjvN4ofzJ7xw7bhdd1rqxZd8rxjmd5VdTnWgPutdy
         Cthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725466420; x=1726071220;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G3mwdqNEgxJHaFHrF5ReVclTR/g9GJRpgrDUa6Fw9Qs=;
        b=dkMeIpuLrku/OuQi3YhAq/BNd2WlnqES04M28Mw1BqAppuVM3RGOsPGxaG0efvfe+p
         pYANnCneuDyb7R9WIycklTvIfeBhcuRHoObAc6ZoelufpyHugDdsQRZK+3X+R7B7oys3
         EJsT/sIa2Wtv5nZJDNS3HAAZNdg+Xkymcjshi2Jp1Uq8U9DU8Pq+Ifcw3ULGDSXccrLf
         v/MIb1gl4pWohFAYXwdt0+i0y10DD02xynxsf3VWivqh0SGTQ1/dmV5msP12Wf0CW7MT
         QebAap9sRsOUBxuwNAzdqwQZ/4YN3OxsJFkVUrJGT12Sf7geezvN/eYTg0mLYUOZUK1P
         vXiQ==
X-Gm-Message-State: AOJu0Yw7P2XD5AcNrhlIhwEvQaECWI0j2oVvsC+ETI8uYCiLn1tK2e0/
	DM8RzaHpKofsP1Dz4x7AFrXHn/mjQSljB5FpA3P+9SIEquxRaC3P/HB9ARlHUwT0aQwDJFfV/eG
	1
X-Google-Smtp-Source: AGHT+IEOJZ5RQFGsDPwEcZRKyRknBYGEU97iUjq8U1Owx0196Nkk0l7k3OBwhKCq+4kCPYCcmQunmA==
X-Received: by 2002:a17:907:7e9d:b0:a7a:b561:3575 with SMTP id a640c23a62f3a-a8a3f539ec2mr240539266b.56.1725466420095;
        Wed, 04 Sep 2024 09:13:40 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623c2fa2sm9175466b.183.2024.09.04.09.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:13:39 -0700 (PDT)
Message-ID: <03e5855b1bddd9a083693dbd8cf45c63050cdff7.camel@suse.com>
Subject: Re: [PATCH 02/15] libmultipath: add missing checker function
 prototypes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 18:13:39 +0200
In-Reply-To: <20240828221757.4060548-3-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

