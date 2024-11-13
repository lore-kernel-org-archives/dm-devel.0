Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E361FB89A
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 10:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731494404; cv=none; b=h/1sDbP5dYEEj6KsIYTsZRpIyLzo6h7I7urrs9OwwOEwRI5Bl9CUSRkPigwC7b1aA5Uv3T+SXbe0Y0ZcUIN8bVgWkOAV9znYvK9QkJrcv78lKyT6z5HZVHJ+LAolw33Gq4PmAyM746REJPr1L1oBnBQ3cfOjhF1jZ3VOEmFVjzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731494404; c=relaxed/simple;
	bh=CVBLgO9PCTR1EzxJ5XBaCJ7HXIlrxXyjwaYXCyT6JjA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=W0mhN2uMycLw6SVIYUrluZ9vDnErxMDckXuOYarlxpf1aJPPASpgVctL83cWmqsQQuTI2QeCCKXLE7+IC3NuIgwuCv2OQtdTecyTdq9m3LhWIFrFMdbnHziF3JURjIyxUal4lW/kCwFpgIU2Rpj9aNRilQLY1rl6BVJWDvsm5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lqnXe0r6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lqnXe0r6"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4315eeb2601so83820565e9.2
        for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 02:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731494401; x=1732099201; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s/Thv3s5fZYiC+uXrouI6KDRRkyx5pHxDuOMRZSWEns=;
        b=lqnXe0r6RCXBLIP+9sAUHZmFrvxt42H5UibZR5pAd1LHy7suJog6Ak/VKdKuzQoVpq
         JQ2QzokLbIC3iGsSr1C9+RsbdTfb/PVh8RPYIF0mKFC6rvyLgMZOKg1wydi6udiuc049
         HVhHJdJyVDxgKlEsaUL6W71CH4u6cWDBq/b0Cq+wzkNuZFCa06o+TFBkpdN9I+v80FBG
         DgSsrnG2YseReqcFYKyfNZuF71KBHhIsrvAl8dBQiPkh05sI1aMbG3b61j90HOYhWrfd
         llOu7oCIazevgF1iaj/Kpy8UfDFEc1y0Zrtd9eyvR1UIVKnXNNGBoTzth1p4AoP1Yli+
         FrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731494401; x=1732099201;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/Thv3s5fZYiC+uXrouI6KDRRkyx5pHxDuOMRZSWEns=;
        b=vZ4sCcVFQqilxhbjKOLfszrQtziryJYLTm8x2TdybyE0ZdV0LteIEW2w6TJ72/Ey93
         Dc3/KBB8zS2mnouxIZTpvOEPs58c4DGlb6QrZgH7yWAlLM3odGlC2TD6UVNsLQ86ev41
         iYzj/TY+aGHlOg1DtKF8yyP9zJT+Lx7pHYHnmbB2yCXIhkSk6fjnXmAZ8bqi+nZYwe4k
         oVs4DL9JxHLrfb9XcOClYq8p51c9mDDVSfXRfiV5kua+UaAGoLbeUsaROvGvQj2lpgFS
         6OXY4G+lMKPY/wpYmt59u6QCcgK0pTADfP2an3EtuNfYlQ8mgkSJL8GTOxQ8Kw+TusX0
         OeoA==
X-Gm-Message-State: AOJu0YxHDf3L2rGlClVVvBKH1YTUMT1upUYJmGj/CO+YZ6UCikwHZvPX
	Kr+8cB1EkxM9jnvafrpctNfHhLQDkv2rEyLRfm++4DlaH6GUu0JY
X-Google-Smtp-Source: AGHT+IFnil+UTWcCqyM9NjYstgzVsxFPy7IlsYJou1rBFeOgAM88fn5h5zIa7wuIyMJtqy1fKWia8Q==
X-Received: by 2002:a05:600c:4f10:b0:431:52a3:d9d5 with SMTP id 5b1f17b1804b1-432b74a07femr230288035e9.0.1731494401028;
        Wed, 13 Nov 2024 02:40:01 -0800 (PST)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d4788c2asm17787935e9.0.2024.11.13.02.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 02:40:00 -0800 (PST)
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Google-Original-From: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <caa63670-ec53-4700-945a-e282a8d09827@redhat.com>
Date: Wed, 13 Nov 2024 11:39:59 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Allow the use of escaped characters in
 str_field_delimit()
To: Mohammed Anees <pvmohammedanees2003@gmail.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241112175758.114080-1-pvmohammedanees2003@gmail.com>
Content-Language: en-US, cs
In-Reply-To: <20241112175758.114080-1-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 12. 11. 24 v 18:57 Mohammed Anees napsal(a):
> Escape characters were not handled before, which could lead to
> unwanted issues. Some device-mapper names may contain backslashes (`\`)
> as valid characters and should not be treated as escape characters. Only
> escape characters followed directly by the separator are considered
> valid and need to be processed. After handling, the escape characters
> are removed to ensure the final string is correctly parsed without
> unwanted escape sequences which were used only for escaping.
>
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
> ---
>   drivers/md/dm-init.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index b37bbe762500..dad9d523f7fb 100644
> --- a/drivers/md/dm-init.c
> +++ b/drivers/md/dm-init.c
> @@ -88,13 +88,33 @@ static void __init dm_setup_cleanup(struct list_head *devices)
>   static char __init *str_field_delimit(char **str, char separator)
>   {
>

There is libdevmapper  project  (ATM distirbuted through lvm2 project) which 
is handling the management of name & uuid with mangling - so they are properly 
visible on systems with udev.

IMHO this escape handling does not belong to kernel and is rather related to 
the actual user space running on top.


Regards


Zdenek

