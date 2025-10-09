Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A561E1EB9E3
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760023556; cv=none; b=TWvDcDNMZTJmgW9c6B3WqdL7b+3GkS+sKxPaaZJhyvzSSbLDV0GBTtnOYqwXCsS/xNdY5YZNCzIizq8VaDQnljjaSZprOHQqBLhI3KhUBQ+odQuMcdMFafH0OcLpPt9SMLLbY37gepzU8LEdSmGBW5T7GqraLwgomrwhR7158iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760023556; c=relaxed/simple;
	bh=f7ZvXJHYF1EgjlV0LVem439doGrMzL1zvIcCHU/uyNE=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:To:From:
	 In-Reply-To:Content-Type; b=CS+LRe9PzY1Zyid5bwZCo0cHgxdL0DKq/JMKYuJv65Jbr1iF2t4Kru7faJNZsTUEOhJqdq8KFjUY1PXDcaGHClEqZ9lQBvraiKvlNKTF12375ccPxDyld1UxhYwSVXppLmoGYsWkhmUG2ZWWOVY+ykgvN+d81jUFjUybfdomRvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZ0153VR; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZ0153VR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e33cec8edso874355e9.2
        for <dm-devel@lists.linux.dev>; Thu, 09 Oct 2025 08:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760023553; x=1760628353; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9lRNAJF+VqUvjvrrnN4j7/iSD5suUmhsQOZpHGWOtRY=;
        b=KZ0153VRTHxG9MdlyBp9YL/Oo/XyDWFTSqJO5aVFx2X1MZeDg4zSUeq2PIyYuE8dSb
         ZmbfryRmMvNGQ9IsWmwYlORS0YqEiPLdGNyB8eYqIP1JDGCf84WD1+e/Hz0ecvhoB9fz
         szj9peiwprnm2qPkJAPx/qqjvrgYBY+FnLm+wClmOvrZIAAqMQDJA9DvASue4GqRywom
         d18DRf2WEX1BxzBSkqBmNNY6zF6cxe48kNmDIHeinBrlfgXIIHpLjUHGCP6WJHnxTvG7
         wbFkme784Hr9ABAKz62GvqRYeMOTsESLiUVb87cMwv0CRw9V3dIEQ2dCjChfOBXksDQv
         gSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760023553; x=1760628353;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:cc:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9lRNAJF+VqUvjvrrnN4j7/iSD5suUmhsQOZpHGWOtRY=;
        b=n80QumafKakT5tsXhNYaFBd4d9XpBGAFbZRcGFS5YTyQXjwUqhxMle96N1ZZbwJdfQ
         HJXnzwHe21j/g00J8sOjlvU/9zRSICpmqAZo6XcGUEuuMMoX5uqNZFtIf+wgNV8YLxvU
         KYuvOWb0MBIoLB3pTVuC36fOCqk0278GHcvulWN4mSVGAp/AtrwYDNmAJc2OteH1DFRd
         3ASpMpP7vmBW816XYuVpjelUlGKcuTME1PlKZYAIJYrapO9oCXjy31dxan5qZq6PnZJa
         ZtXdFjxyksyHqSE1iGmFX57Ia3H3rnFi3tHStR2Ud2PInHSJTcd4ADiqtUg4TxNZDuo8
         iY7A==
X-Forwarded-Encrypted: i=1; AJvYcCVHpVtApVo18PG+xt96EMji8DDM6c1HJqs5u+lIR1QxHHC+tVTIxKAc0X+Ioh8cYF218qbO5o7RFw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxeI2617F6MYYpPI/pQeGwA4w0OP54aVt1IMTeJMouI+acKaxyP
	p0KU4Bj85CY7jPe8v+1zLdi33/cpB+YIw9ekAz59PcGLk5SIxfuONww=
X-Gm-Gg: ASbGnctpo1MJGZZ5uOSiduGr338SpkXKPCKnRvdYI1Zj0ouCe95K5VHKsHOLncSMM2R
	qbbyuZp+S3voSZIHlYeb6ytRI2QLjvywxUaC+cvh65wijyfvlrTvKM/Y8W2dG9rQqGrod/dU36t
	UgAyY22TwYR4FkGReZVFi8e3QaxVC3IxoE2ZrE5MLh+3otQVlPYyoV8ZHYuD5GoHFwM/qCrk2Kd
	pBjqDIorJTFQ09FQ0LF0328x3XDCh1uaNb9+AiuRPl7Rg8KFb+D7/m6DUmz2enFyYpAt+GiXzCx
	z9myhBvUoHa1c+EGrWPUuApLvF2Hh1r8G8lwZAF9mmsQZrU3L10zPTgL29V7QHbpM9bbKVIpiFQ
	sdNkDB0nKoxc3+cUWFVkONsU+8++F2hF56joXEhZc16TL5KN9KRjvIlNPOuZIE3o2JJIIWlK8z/
	GlPwA89nCAc4YpbANfi7p+sow=
X-Google-Smtp-Source: AGHT+IHeORvv3Xon7SdqNDjwMvEVAuCkwMOkRhMh1pLoMByghPPdVtI5kYufNxBzVMJtXRqNO4wbdQ==
X-Received: by 2002:a05:600c:4589:b0:45f:2d70:2af6 with SMTP id 5b1f17b1804b1-46fa9a8b2damr29323315e9.1.1760023552607;
        Thu, 09 Oct 2025 08:25:52 -0700 (PDT)
Received: from localhost (34.red-88-29-160.dynamicip.rima-tde.net. [88.29.160.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3e3520sm42050545e9.2.2025.10.09.08.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 08:25:52 -0700 (PDT)
Message-ID: <4229dd79-fab5-449c-8f00-46e71284207f@gmail.com>
Date: Thu, 9 Oct 2025 17:25:51 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: add new info to multipath.conf.5
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20250912182150.116717-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
To: Martin Wilck <mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20250912182150.116717-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/25 8:21 PM, Xose Vazquez Perez wrote:

This one is still pending...

> Document the static vendor tags for nvme, and dasd devices. And product tag for
> the latter.
> And fix NVMe example (s/NVMe/NVME)
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>   multipath/multipath.conf.5.in | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index f1158f7d..3c9ae097 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -6,7 +6,7 @@
>   .\" Update the date below if you make any significant change.
>   .\" ----------------------------------------------------------------------------
>   .
> -.TH MULTIPATH.CONF 5 2024-08-15 Linux
> +.TH MULTIPATH.CONF 5 2025-09-12 Linux
>   .
>   .
>   .\" ----------------------------------------------------------------------------
> @@ -1653,9 +1653,19 @@ The \fIdevice\fR subsection recognizes the following attributes:
>   .TP 17
>   .B vendor
>   (Mandatory) Regular expression to match the vendor name.
> +.RS
> +.TP
> +For DASD devices, it is the fixed label: \fBIBM\fR
> +.TP
> +For NVMe devices, it is the fixed label: \fBNVME\fR
> +.RE
>   .TP
>   .B product
>   (Mandatory) Regular expression to match the product name.
> +.RS
> +.TP
> +For DASD devices, it is the fixed label: \fBS/390 DASD ECKD\fR
> +.RE
>   .TP
>   .B revision
>   Regular expression to match the product revision. If not specified, any
> @@ -2030,7 +2040,7 @@ the foreign library name in square brackets, as in this example:
>   .P
>   .EX
>   # multipath -ll
> -uuid.fedcba98-3579-4567-8765-123456789abc [nvme]:nvme4n9 NVMe,Some NVMe controller,FFFFFFFF
> +uuid.fedcba98-3579-4567-8765-123456789abc [nvme]:nvme4n9 NVME,Some NVMe controller,FFFFFFFF
>   size=167772160 features='n/a' hwhandler='ANA' wp=rw
>   |-+- policy='n/a' prio=50 status=optimized
>   | `- 4:38:1    nvme4c38n1 0:0     n/a   optimized    live

