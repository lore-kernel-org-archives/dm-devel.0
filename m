Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0461BD9C9
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 22:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313865; cv=none; b=JKBqio7+zC0Nzj6kGaBFwZRQ4BvdxAGExM8Z02dFGQju3szhSp5ppnH9EpnmA+J5555bX3KOjE6oIN7gayFmBdvNBUxZnXuTYPtiVJXZExrzjlqsc9gIYBlBXiUHabiYLVbJvj6uD+g7GisC727zdgLoyxRPrKoRWo/5Nym3eKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313865; c=relaxed/simple;
	bh=GvtJcYYuGfv/o5CkZZd/Bt51uhFwrCyu1MrCpm2ke9E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HbGZ/Y4g+SI/43bRoG4bt1SVQKJKjy1NgoVVRRKZfJ5Zh9PULXMHZDjsreLkVyvWUlUdpXXSusetCtPeDkVDbbYyYjPMwAU/wVbQq3KDGaFQ0Y7MX87MnxtvMyppEoT7Fs9y+unvjbQgCsUFm77HJ83XGEFAzftvXo+lk0luk1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WJzxkS3+; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WJzxkS3+"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4314c4cb752so22836865e9.2
        for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 14:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732313860; x=1732918660; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PWBjj/2LyDYhRGg+3CfX7oiegFKXamSobPLakqv81kM=;
        b=WJzxkS3++svB87R7QQaSapVIndTeG/1Wc28z1lBenGFEHU5UsX8vSITKyCNwjA3f7N
         6jgoIZ3MVMHRd7MyxyvMB2C+bGBb01QJ5VxF4Cft3WzJEQePleEPs7CJ6nbJKyxzmOTz
         C3TKAWgXuzfKfPYjWXtagplPq+adMlGBx/57DpheR/4zaYATuQ5/WIFjUk8HceH4bxBb
         k5feP10eXxMYSeFprKJxgeR4OtxlXpeqtk7+RHwxiUMmSBbz/uXBc0hULn7E1SlZ+me2
         26hQTws8OEHHLfZBK7KYwEVihXrYZMY8YZVeC9bca2hPglH/p6d3UweFDTb0YzFjInFE
         venw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732313860; x=1732918660;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PWBjj/2LyDYhRGg+3CfX7oiegFKXamSobPLakqv81kM=;
        b=bx6oN6fB65y6BKanbPkUkd9hxcjk2NwWUMi5wsuDSO0YycR/6NX3ZcnS6flNHbXv2Q
         ai7zbSP7Ww7Z1JbqaOJSDp2Gy9zXcEvJHs2Lx3/gezG2Wo52x5eY5zO5V0UcugEcUVfh
         C0dwdO55c2Prq3bkFY8KXtreLG5C99zzsmwZ+MeK5zULU6A3hUMImS5K2gmhKMpghXyR
         fY+1eZzUc3tHf24BtnhZMV3U0QRLEvRZ2voPz4wYeEC5flcxImsPHM6abvRC8KdcvHhQ
         SpVDjf3H6M6TNDL9lh4DWiJ+fvJ/pOZwPViJkmF2JD4mfy7h8gyWDS0VPDyxZJZWfuDX
         qjYA==
X-Gm-Message-State: AOJu0YyIgv3gsXD1kpP3QQri/OczgsM4NuW7m00k1PuyoBkDpgIZUXeM
	Mf50glSIR+YH6pOr/Z9ll+AByI+th45M41DKATWZQBpuNqntANELoJsAMgFnb1gD9xeCftjF+vQ
	N
X-Gm-Gg: ASbGncuvZy1GyM2ofLQhZO0cM+vL8jcGDaTYre+uWipADemL1poVc/e2/KHXKGLmkHG
	Qwb9dy4PuCpcIzCF7pPGjJdKMy5e7BK2R4oCoNbBy3eWUjtDL4lXpGMxwN3ON8K3EOfAK81nCp2
	2+O9Uo9feI5dNLiK9QoWU4I2mAcACI5C+ekXLz94boKk++RKGj7xhCUXlWVvTYoU86uMU518R/s
	9Nk+BtYgI3EVvvB1YXJr+xBRdAINIawuUKghM0SetdDCuyS4JKs3lwsjAjOK9FgcsNFTyuV+qe2
	vG2FGTRMFPxwXSvxpU9g/W+SW4TJzacegYjvQUHw5qHeCu55jgACX5lYIIQS7DRAq1ybc8Q1zP4
	/WGcOiA==
X-Google-Smtp-Source: AGHT+IFM7jxfaXj/5/hiAk5IC/FVm8ePKOhl68jAx8kujDiLiXzYAFLlWcbKx88VCNfzZRenHsU/Rw==
X-Received: by 2002:a05:600c:35cb:b0:431:5aea:969 with SMTP id 5b1f17b1804b1-433ce420a4cmr37222475e9.8.1732313860307;
        Fri, 22 Nov 2024 14:17:40 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b45bd701sm102754545e9.11.2024.11.22.14.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:17:40 -0800 (PST)
Message-ID: <8cd3990ad7782becd2579d36c527b2a495233eda.camel@suse.com>
Subject: Re: [PATCH v2 11/13] libmultipath: assume device is in use if
 dm_get_opencount fails
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 22 Nov 2024 23:17:38 +0100
In-Reply-To: <20241122211133.718861-12-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
	 <20241122211133.718861-12-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> If dm_get_opencount() fails, open_count will be negative, which means
> mpath_in_use() will never fail. However, dm_flush_map__() will
> eventually fail. There are multiple callers of dm_get_opencount()
> that
> run when trying to remove a device. All the others treat a failed
> call
> as if the device was in use, including one that will later be called
> directly on this device. So save ourselves the work, and exit early
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Side note: I realize that there are other callers of dm_get_opencount()
that take a negative return value for a "yes". That happens to be
correct for the respective callers, but it's quite unclean.

Your patch is fine though.

Martin

> ---
> =C2=A0libmultipath/devmapper.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 751b45d8..3667c51b 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -961,6 +961,11 @@ int mpath_in_use(const char *name)
> =C2=A0{
> =C2=A0	int open_count =3D dm_get_opencount(name);
> =C2=A0
> +	if (open_count < 0) {
> +		condlog(0, "%s: %s: failed to get open count,
> assuming in use",
> +			__func__, name);
> +		return 1;
> +	}
> =C2=A0	if (open_count) {
> =C2=A0		int part_count =3D 0;
> =C2=A0

