Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CC52E541F
	for <dm-devel@lists.linux.dev>; Wed, 23 Jul 2025 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753283080; cv=none; b=aZlc0vh9PT/SEea0OYFzwCkwlHuE2Buy6okcOzKrrhWJa6nGSm11r22WMD6Olek5GA0sXPGrxG9RoflwT8+J2VMCqUeOqLtoXzHmBKRkR8RDGWM7GrOnbTz521HGUG0G2UjHMzu6zxly1yrFW9Zzos5Iu+pM8hSH5ZXF9nDF4go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753283080; c=relaxed/simple;
	bh=/H5GbxGJJZZzGKcvSsck5fe6+s0EM04EqEYZVrIk6kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0C4QZ9oFj4xwgCKmVtZV/CSpObQWfU0bc8u/18yc+kNLufsrtfmBhH+aAxKAgpO2Q0h7G9+/dRLiw2496n+EUMHdu5Vt3aHigPEP5SkVTGJ27I1i9qCJfjySvs2J68Dv+IK4pwu6lcgw1PEbvmk2FPv9qZBZSb9pT986xv+j9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AaaTJ4Yw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaaTJ4Yw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753283077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZjsPHcbjaw2inUuNB1CT+Uzxu3E3fm7t1NY+uni2n0=;
	b=AaaTJ4YwvQbmeesMY06p03CVIkWA0Y46brtgzFhCLiiMIqAahZQMzLUYF3CmltRtbHxIIG
	RG/zic2UVTxLWYf+c5sqNyJp5vgU9YnhBKJJ+NMFTbsNVq1WuqzSsiB7xwOdHocQTc+53V
	B5MwBPQeAuTNLOWQJk5GE3wj2ZrW6f4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-FODnf53hP-2r4iCVbQpUPg-1; Wed, 23 Jul 2025 11:04:35 -0400
X-MC-Unique: FODnf53hP-2r4iCVbQpUPg-1
X-Mimecast-MFC-AGG-ID: FODnf53hP-2r4iCVbQpUPg_1753283074
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4538f375e86so62565985e9.3
        for <dm-devel@lists.linux.dev>; Wed, 23 Jul 2025 08:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753283074; x=1753887874;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZjsPHcbjaw2inUuNB1CT+Uzxu3E3fm7t1NY+uni2n0=;
        b=H+jh+Wk8YikxZsvoblr79dpBdl2gQSVGrgbPkXUEyIKhCVJGHMTZMpIBS8zFbaGJWT
         kwG3GjGi+me9EJHdwnGasKzy4YsqUeuAnPW552tPKa2peFSjRKnLSOCtQdo27XSuX07B
         bIAwUyfZ1ntQZg67UF8FQJtN3guWb4udNz08q0AD7WIgt8K4SFgca0nBcelGmqhHTs3X
         6bifhdIbAaqkuU2yD9A82iPwmd82x76tRZG47/LOgIuSa2VKhzVHsMeyG/BcHC+0TV9Z
         xNrX0xagkTI+c1l7oECdVGfeVjzxEu6IjG0SS+zugMhJ7Jmsrb74RdACMrngBt3VgSlE
         9cyQ==
X-Gm-Message-State: AOJu0YxvRW6PjcTOcn8Oc6samYUd4KL5aGm4qYiVjXAIf3zbsvw48KsT
	4BbNUZcOlD0xJHPteS8/QI/+ogFnmOgrMFHqsM+LHSzdADjoNY9SUF6uDQnfrEGUx2NtmazC0vg
	PbyHqCI6ResCVMjoJF/aE7xG8gH0y0+5ZWpMtqHMVyh9w8ZQOvXKawLamoGDz
X-Gm-Gg: ASbGncvP7VoFbVI+PuMEB7n6Ntg+ugFUOj9EkxmMECROGVuanb82CEHi91/W4/UBfdL
	OJYpNdgfIHLzNw1IjDO4lWw+DbOlVBGaK75Mf/BIptIXlPwVib/Fv863gKjwmoNVbWgU/Yl8Yuf
	UVCglHCFz+5nV1xxRkX2JoXTbRevNPa04G9OuyGxf3lc07KmuKSACwTLIDHLD9xjdbElvgvKiAh
	XU7Nl30F1/ywwkfFxsYCUTxQd1fdYGrHLBPw7yQE+4CiiO6aatUOArGiu64eT+0CTVA8BTdh/BI
	8zA8LcZ7bOxYlvuPSE0yiphtj+m7GxP0tZmGDCE+
X-Received: by 2002:a5d:64cf:0:b0:3a4:d83a:eb4c with SMTP id ffacd0b85a97d-3b768f14c43mr2557744f8f.57.1753283074148;
        Wed, 23 Jul 2025 08:04:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5W+P1JBNzeAJIdVOXDC26/kxoJu1UeSFYyuV4WFPMonWWqRK2rOosK1TNXBkPXy0c4sWdGg==
X-Received: by 2002:a5d:64cf:0:b0:3a4:d83a:eb4c with SMTP id ffacd0b85a97d-3b768f14c43mr2557673f8f.57.1753283073316;
        Wed, 23 Jul 2025 08:04:33 -0700 (PDT)
Received: from [10.43.17.17] ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d74asm16393250f8f.63.2025.07.23.08.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 08:04:32 -0700 (PDT)
Message-ID: <863f390c-428d-47e4-8d29-5b056961d08b@redhat.com>
Date: Wed, 23 Jul 2025 17:04:32 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LVM testsuite failure with VDO
To: Matthew Sakai <msakai@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <11d4215f-06b4-84a2-29ab-a558c25c6331@redhat.com>
 <03f74406-2df3-407e-b440-c364c182ad78@redhat.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: RedHat
In-Reply-To: <03f74406-2df3-407e-b440-c364c182ad78@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sig3GcCxPDIbrqTP7Z6zkCXTxf-6oJSMfKNRVD1sDPg_1753283074
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 21. 07. 25 v 20:07 Matthew Sakai napsal(a):
> 
> On 7/21/25 5:29 AM, Mikulas Patocka wrote:
>> Hi
>>
>> When I install VDO tools version 8.3.1.1 on Debian Sid and I run the LVM
>> testsuite, I get failure in these tests:
>>
> 
> This has to be a userspace problem, right?
> The difference between versions 8.3.1.1 and 8.3.0.73 is very small, just an 
> update to the acceptable inputs to vdoformat:
> https://github.com/dm-vdo/vdo/commit/0ec7597b60e5e6c2c33dfea057ac38bf157acffb
> 


Hi

So the issue was buried within the vdo_reader code trying to parse VDO 
metadata and the use of 32b arch for user-space on 64bit kernel (as VDO kernel 
part is only supported on 64b kernels).

Fixed in upstream lvm with this commit:

https://gitlab.com/lvmteam/lvm2/-/commit/af42fa8553216f24120c23a855a53bd3cc85b61c

Regards

Zdenek

