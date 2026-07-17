Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6913FE35C
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784294843; cv=none; b=q+HzA3xA/QtZX6/9/WZN2gcabCeHtsq48D1Un5snhJshCZty/kYEfc7k0QtmTDoIi5Vu/I/n00GT4vucA1BZSPdf8R0BJTwol+SliuUmn6nqR9oi401MUmddw39ZLE+1q9zqu8XMNb6s86zJyi6oX1K4z+RipZDzfUmWtNB6XsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784294843; c=relaxed/simple;
	bh=kQYQL3OxeFfFG4BnThogm/1RRWruuf9sOjMV5nDo/vQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UfUyOUNGTddkDOvDPTvxPqHdLLnHP5LUdIfB97Z1WuqQ7NEcmcBgdKteLcz12kczaEa6dMrcmlC76bZCjj5aeBzynzFlG4UVZo7wf1OHXLjLlFRv49Ac3t9FD/Fu1iK9t2Fo5XyCDC1esqoytbMs0wekhJaNEi2otBgE+4tA468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDHPsJ75; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDHPsJ75"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4925a778491so2951595e9.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 06:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784294840; x=1784899640; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b1yKGpPgMB9NCx1IuZchwKVGK9ZwcozYfjEM+nK9wVU=;
        b=NDHPsJ75FNR4I0SAbSY0D9clbkKhF1yLqEKmrWD8G+W4+wWMGuXmuGyQC9aVrU2CiX
         HRj9bi0s73ISCGnolxUAMrV4FVUmMOgGtG5cELqL4OaQHwA2tvFFguyZzbKbc58TIXKh
         ucBiv2w5r+NQqCedEPvEmt1MpxEx+cGVqwie7WK7qneMq+ATuIQU/zW9YFDrBu6ZfRRV
         EmsPuBgrvpXkEb8JmPd32qSXPi3RrX3pec3Rb3VpgnS6zHYml7s0d+NZ7bxWhbQ991uW
         yHF0sqHtOb0o+8fpvXOnmmrWFzr1oLrjSfhQnjNKN3rB9bs9aD5iO2CaE4hjwD6uy61d
         93zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784294840; x=1784899640;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b1yKGpPgMB9NCx1IuZchwKVGK9ZwcozYfjEM+nK9wVU=;
        b=IUJppGuqhIGRJ9gOpf+NhIRdNGsWmEob/9E2F/nqkiwDnJ1vDOthzM7lyG5y3Q3KHR
         Eqpgnw11aB1reklUfmvh55dRLwuU3S0PV/VMPKpukTSChuoShBxBl9eA4GHmVLmkjnRI
         zGmPFMqkxzEalFIqyarpCwZkaVT9mS3AHEMCwL6QY/Tw9/wkCZZGNZ0BTmq2b+NMk711
         d/ruxasMG30g3CleAEY5BZb/qQdAghGuYeetEME09KG650DLFWdE9wQwzzpB+vh84EqD
         1oajak5m77tF4witXIb2fmXu9NzExoOpuwOZPHz+eBkloyXjePfqoEJRvS8vUE6SVRWq
         vE2g==
X-Gm-Message-State: AOJu0YzhPqRemw9nt2dHo+rcTHtsFB8SwT/ZzjJszpthpWEFggx9K6UF
	r78iShn57hwe0w6NKJELW6NSf8FngNpoOmgVYzmEp0YWm7I6/jYPCws=
X-Gm-Gg: AfdE7cnr2xP5xn+p8NbWlUEAYObBA4SKq52VWE4yx1RnMbUTmZrOpO2ILVkI6VaUmx5
	4Zf4ZU7BIjqzBPkX4a4ZUf1edSlXeT/mXQe1WPdPsRvH4Zxx/8AH05i73KjEDG+lqvYYzf/w5oc
	1hxNWbi+dD7AR/sfFXrRmYxoWcwRc9aAf0OvbGVKAxYKJzGgr3tsMZrHuZM0/A59PVafje6jtOm
	M3KlB58aTHtBxAkbSw8ZR2kB2F6XrY6yBYyBdDmAnjse4hAaQWg/DmudbSGmeGg9y177NV5ja43
	qWmOzUnA/zh5lt3IjMYMtaZIGRz07jrNb4QbY5aLtJyYYWFR3wXO0fIcVFcJ175nw1qf7RFsJJr
	9998jgNYgUQsEsnWK8GWzmo0qHCs+CeKte37itxbmgCHWLHmIjS8q1ADJaWgx1qrI8H3HWvqZQF
	MWAuUNHRkOTq7dC/vqEiLGM43+5UhEUqiQWLNwmQnVWeoh+Sg=
X-Received: by 2002:a05:600c:548f:b0:492:7082:92e9 with SMTP id 5b1f17b1804b1-4954a8e3851mr18157135e9.0.1784294840156;
        Fri, 17 Jul 2026 06:27:20 -0700 (PDT)
Received: from localhost (3.red-80-39-57.staticip.rima-tde.net. [80.39.57.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ee0086sm4281635f8f.30.2026.07.17.06.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 06:27:19 -0700 (PDT)
Message-ID: <0467af29-1ada-4d20-a5b8-acba5c166e33@gmail.com>
Date: Fri, 17 Jul 2026 15:27:18 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] multipath: clean up find_multipaths documentation
To: Martin Wilck <Martin.Wilck@suse.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20250307001034.3141833-1-bmarzins@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20250307001034.3141833-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 1:10 AM, Benjamin Marzinski wrote:

> The preferred term is "on" instead of "yes".
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   multipath/multipath.conf.5.in | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index 0c1eff40..bdb6b605 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -1214,7 +1214,7 @@ Both multipathd and multipath treat every non-blacklisted device as multipath
>   device path.
>   .TP
>   .I smart
> -This differs from \fIfind_multipaths yes\fR only in
> +This differs from \fIfind_multipaths on\fR only in
>   the way it treats new devices for which only one path has been
>   detected yet. When such a device is first encountered in udev rules, it is
>   treated as a multipath device. multipathd waits whether additional paths with

Could we please backport this patch to the stable-0.10.y and stable-0.11.y branches?

Thanks.
