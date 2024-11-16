Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53A218A95A
	for <dm-devel@lists.linux.dev>; Sat, 16 Nov 2024 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731786089; cv=none; b=pvAxyKU9wROeaa1HwYnFBTWoLGqgP6rKRdgVsashyHFVLILMVk/uNIb/q+MZImA43sbVW2m7kuBTFY/q3pI01i9UySiqgiaznMUyN/5iMzWvjVjSJlOmTIo7vuPy0xHuVzta4ebhj4LsAWf5/XwRbWi+Bzn/RO1lpbeQnkbXYTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731786089; c=relaxed/simple;
	bh=K/JaqyxF99RMKpFCuYLKKjCaOmlFn329uj0ElwR1CAA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:References:
	 In-Reply-To:Content-Type; b=BYEsXASLLEejF66RPWgzckqlAoeEy19MbcC6tOdkX8KSuzTaS4IQP5ghEmWhaV64jUkQ5b3EpsW5gJx5SfJsDo5p1XCZcIppELyI9KVmUPMZORFa1a8O0dMgH1vOLsLJ9b3bfj6lVakjLMm3Lxt4Ujb8kP/g/AlDdR6+1JoDOys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SRvlOxlb; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRvlOxlb"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38231f84dccso889482f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 16 Nov 2024 11:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731786085; x=1732390885; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xK0jbGe3bSschaJh/jOptzsOgt0J7UEx0y60qPmAMA4=;
        b=SRvlOxlbwMzkc2frcvNUM0j8cM7QeFFrfDR4hCzRXpB45ZvPAhiqwXVTkGNOHXaj4h
         LFh8sU56UEoebjsIlPZTcD/IuGAfLpnG8+XRFIyqJOviREKD6Nx+2biZ3c8KLRobE1rG
         ImhQ/W1FVkTqEQ2MdVYmHfwPU7uFmmUlyNipODf7RsHZDlIMbFfpapMOABV1ViP5YA6s
         qWi2SBq/Y4e0GEQlYWI7AahJNyh97hsCRQkhnXLn27kRgGDDq6c+uBIO3VeJyNR6Enr6
         SRNUuv7x66t8HXnY1QMQg+nJ63DKnjses2evxCCKKtiucVu8WqtJPdjSnaROZ3QsVYZz
         Ar+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731786085; x=1732390885;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xK0jbGe3bSschaJh/jOptzsOgt0J7UEx0y60qPmAMA4=;
        b=pn5CKz0kFDzHwxqL+7+GboRs9zbZJiutHEztDrhlUxtuIMp+o3AHCG9FbZL3LDwcn5
         dZJbd8yD+PCCdrd/wTOEET3Yp8KQnDHxMWeaQqNgMlyW3zsoArixfZdw9FWhZy8IfY74
         q71l2TwsXaDG4V8er84s9zICWDa3H/NSocX4+CxK+lo1cj+Dt4dex1oA+QhfY1ks3lIZ
         zlWhJzDgusNyNUJTwNOAQMv7V+YPCCWoyFUe+lgfdRkJTKmwm3t+HiqPTScnc+UMHyMA
         677SaqmMO9658w6rKCANJGuh1D6Y2lHQQbpI136I5riness3msju+KY4A2Lg7HnuIicx
         uLyw==
X-Forwarded-Encrypted: i=1; AJvYcCVeLIv6W6nNw2GaXLsKSt3AfYP1lOlIu5BSRN4YibCtggFHSmbZFFW+S+P95tEu8YwUbmcFoq2LxQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZSmB080W1cfjxIwWPZF9hnyhHoKbuw/fOfivj3N2wYqMC01Jm
	97sQZVJw7tvD1ei54fV7oaoPt9tq881PkVrnn41UlGZjIN/3txM4
X-Google-Smtp-Source: AGHT+IG6v4P3rnkNo7sQx4sv8flHren52Rgpim6fvRTuZ1+mdRKxbTkcGvZ49JfjRJdCZGSWqMCkTA==
X-Received: by 2002:a05:6000:789:b0:382:7b9:3215 with SMTP id ffacd0b85a97d-38225a420b9mr6054561f8f.31.1731786084979;
        Sat, 16 Nov 2024 11:41:24 -0800 (PST)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae15d95sm8122557f8f.85.2024.11.16.11.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 11:41:24 -0800 (PST)
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Google-Original-From: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <f98d06f5-ac06-4c8a-9f3e-40da4260de20@redhat.com>
Date: Sat, 16 Nov 2024 20:41:21 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Extending "thin_trim"
To: =?UTF-8?Q?Thomas_Br=C3=BCcker?= <public0x05bf@bluewin.ch>,
 dm-devel@lists.linux.dev
References: <d2d0c5ba9f9d28cdd435e0bbf951de5a.squirrel@main>
Content-Language: en-US, cs
In-Reply-To: <d2d0c5ba9f9d28cdd435e0bbf951de5a.squirrel@main>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 16. 11. 24 v 17:10 "Thomas Brücker" napsal(a):
> Hello developers and others,
>
> Intro:
> Lets consider a data device of an thin-provisioning combination. On it, some
> data blocks are allocated ('by the metadata'), others not. (By using a thin-
> provisioning combination, some data_blocks get allocated, then you write to
> them, their content is probably not zero, and later, such a data_block is
> disallocated.
> "thin_trim" discards such unallocated data_blocks on the data device.
>
> 'Extending':
> It would be fine, if "thin_trim" would have an option, that instead of
> releasing
> the blocks, "thin_trim" would write zeroes to these blocks.
> --> REASON:
> e.g.
> * if you backup a data device by copying it to another device e.g. by
> "dd", it
>    would save time, when unallocated blocks are not copied, but just 'jumped'
>    by seek (by specifying "conv=sparse" to dd) ("conv=sparse" does its job
>    only, if these unallocated blocks are zeroed).
>
> * I have an utility, that backups a data device clusterwise
>    (cluster != data_block) to a cloud. To save space on the cloud, clusters
>    which contain only zeroes, are not copied to the cloud. Here too, having
>    a data device where every unallocated data_block is zero, would be fine.
>
> Thank you for your generous device-mapper efforts.


Hi


I think you should pro probably examine this project: 
https://github.com/jthornber/blk-archive

IMHO zeroing would likely not be so good plan - i.e. imagine you have mostly 
empty 2TiB thinpool...

blk-archive solves this way more efficiently.


Regards


Zdenek



