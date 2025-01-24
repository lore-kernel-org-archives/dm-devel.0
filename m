Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B7CA64
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737746826; cv=none; b=Yjo7Sql5qk64CcQCF5nAkwcg07M9JX20rgqC+INcklXZ8dOklfNkJ0mGja0hQ5/BLSqZWmHkW1Q+2fM0iRXdbP9jKxpwsJFp6AteB27/ISP9m5O1NkC/X7IqAy+9Rz5U+XqkOxvZ+DD0p3av1CsLIdgdLMFEMluYT7yTlJHL2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737746826; c=relaxed/simple;
	bh=ouk+VtXsOzNrLzKArrxIqAeSCm5gV9RSeCUYRomq9PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lvknux+H5zFlVW16zgaWsDv5zTPm98nZZ1wFEz/MZQdnOw3m79lZesqgLhoKiK2qKXsS+zdf0gFh+6+Tgr2u1KqIiSq2hz/pdw0EEsa76xXEMyjAl3d65Eu9XPTOoMp/FZBu7QhK4TSkP3tiGy9Pm+eyzWi8+Hg8OkpQrO6xB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AXp4sz+W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AXp4sz+W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737746823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eIPJQ23e8DFuuMkN3wH0i6vyxyrsfQ4jcDFihcr92PI=;
	b=AXp4sz+Wn2bsYqKgEwCdv4IXcF3hq5gtiVpk2x0Yh+UQxCpqLDg0RFnSo+hmCkQke+d7Nz
	388hL40oUJy2MD8whjbEWh0DCjhHgVwPo2zahNPNn/Xo0UsKz+ynP/RWvSbUS8vJOVrtTW
	trV/EiQtcMiExpMXNzLJGR4Chbr+QvI=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-ZXOS-XmvNmK5_ZfZWd8PGQ-1; Fri, 24 Jan 2025 14:26:59 -0500
X-MC-Unique: ZXOS-XmvNmK5_ZfZWd8PGQ-1
X-Mimecast-MFC-AGG-ID: ZXOS-XmvNmK5_ZfZWd8PGQ
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e5839ae8c01so3516615276.1
        for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 11:26:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737746819; x=1738351619;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eIPJQ23e8DFuuMkN3wH0i6vyxyrsfQ4jcDFihcr92PI=;
        b=mK/eazZNQCqojcit0Yn+GDxa1Zj/W7SnUsaOFL8ugSv3XnAuQ44NkLwHw/lCaAeIGw
         vP/dBmdsvFt4rsCJADu2sRCUodQWERnuKE9CmDOuyJC1kr32tHhbAdbguHU2Jy5ly9da
         l1sqsg1p8fAEO8dcsBgywx5ctV/Xz5MzYZ9b/5iNlAu/9GygapFsOD8Cm8bKkQzoZMB4
         iiZRvQOIrsaSob3xDQrdDd7s2JsC1fMUd7zU/gDrxb7jyEoA+hZqhyVR8a1fmjYOH3a2
         Ye1hTZftZfuyAyFCrL7TfwIgUZ1C0nBHzWKlX+HT6wz+4LNW1GHb74eKgPaFrUmjXcTl
         9tVg==
X-Gm-Message-State: AOJu0Yz3FtqZzaoT39+m4cD5X+kf3aTfTe/6OWs6nxaUYSHZ9GeK0clx
	PSpklbxrJ8i8gQw32DQSliKvdHdwJ7gSJzqPb7BOKbGkJymphz0Nmng/a1tTjSDBTMR2sOiJa2l
	rzfEKg+EMv80t6IoK0DcYtELVVtHbafs3dqJcX7O6uGSt4kGdRarHwyr4hSL+ktuOWNE=
X-Gm-Gg: ASbGncvNwgyeU2lny84ATSxdORYa6n4KhmK43PsGsysYjb6oyWhqK87Zs/xauhJzfWt
	gxWCMqrI8xXQ1qDzxGWyez1k+m2pSBtcH2F3Gs74fmLD4aR5wR2ouLZjydUecuj/2fzdlwUo0LC
	R1CT9/lb0LAchaC73fpeGsTdM1PIQkqI5HfL/0PSGkHT2NLL6/f6eKkrtWeKfT3d0zcU5mVl81X
	Kr9CQTSd1/RaQorA8PlhXqTD6eRMsh9iI+w5f9ymKHV9golyiyUlNgVRHEUIxmSNXyUmCg=
X-Received: by 2002:a05:6902:e07:b0:e58:7ce:3421 with SMTP id 3f1490d57ef6-e58257a561fmr8160932276.4.1737746819202;
        Fri, 24 Jan 2025 11:26:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhBb4mvCwAab0DCMPihhsk1WXXc14zrGglxzkEJTvTvMsHmelEhmSy9f2OTZ/3unD/WmtWMw==
X-Received: by 2002:a05:6902:e07:b0:e58:7ce:3421 with SMTP id 3f1490d57ef6-e58257a561fmr8160916276.4.1737746818924;
        Fri, 24 Jan 2025 11:26:58 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e583b7697eesm458509276.21.2025.01.24.11.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 11:26:58 -0800 (PST)
Message-ID: <28698247-22d5-4e6e-b8c3-c4a55e330083@redhat.com>
Date: Fri, 24 Jan 2025 14:26:57 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm vdo: use a short static string for thread name
 prefix
To: Heinz Mauelshagen <heinzm@redhat.com>,
 John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev
References: <ba07663c444baf7dfe539f41f9cb088354af4106.1737584895.git.msakai@redhat.com>
 <3be87d52-2e0f-494e-8583-a80680b0a4ec@oracle.com>
 <CAM23Vxq0se2Znwzr1hXiuLzGuKxtj_ENbVLhwLnPtkK-CYibBg@mail.gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <CAM23Vxq0se2Znwzr1hXiuLzGuKxtj_ENbVLhwLnPtkK-CYibBg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1OTO_AW4rR7CGhaneRNtytAubo3a5Zwvp-dpvpdx4BQ_1737746819
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/24/25 8:56 AM, Heinz Mauelshagen wrote:
> Hi,
> 
> avoid needless format processing as in
> 
> +                "vdo%u", instance);
Indeed, I'll make this change.

> 
> 
> On Fri, Jan 24, 2025 at 2:34 PM John Garry <john.g.garry@oracle.com 
> <mailto:john.g.garry@oracle.com>> wrote:
> 
>     On 22/01/2025 22:30, Matthew Sakai wrote:
>      > Also remove MODULE_NAME and a BUG_ON check, both unneeded.
>      >
>      > This fixes a warning about string truncation in snprintf that
>      > will never happen in practice:
>      >
>      > drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
>      > drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may
>     be truncated writing up to 55 bytes into a region of size 16 [-
>     Werror=format-truncation=]
>      >      "%s%u", MODULE_NAME, instance);
>      >       ^~
>      > drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2
>     and 66 bytes into a destination of size 16
>      >    snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
>      >    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      >      "%s%u", MODULE_NAME, instance);
>      >      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      >
>      > Reported-by: John Garry<john.g.garry@oracle.com
>     <mailto:john.g.garry@oracle.com>>
>      > Signed-off-by: Matthew Sakai<msakai@redhat.com
>     <mailto:msakai@redhat.com>>
>      > ---
> 
>     Looks ok:
> 
>     Reviewed-by: John Garry <john.g.garry@oracle.com
>     <mailto:john.g.garry@oracle.com>>
> 
>     btw, maybe there is some #include which is not required since
>     MODULE_NAME is no longer referenced. I am not sure.
> 
>     Cheers
> 

