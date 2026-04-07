Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC4238C403
	for <dm-devel@lists.linux.dev>; Tue,  7 Apr 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775553279; cv=none; b=TTAG6ERmBv9SYbO0E8L7HVXB5Eqolz+dvBBRvmL5DE5OzxH4HgfVlqvRAO1SPQYR4yVIT50ldskEspPfHNcQI/utD37r89nC09X99EuwxQUnXetqsfoss+e/sXGQXtsz69lG0I47VNhHh8hL6qTPGh1pb+4xIaUcC1iaVRDkB6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775553279; c=relaxed/simple;
	bh=XRKzOTTPtthykffT6TaXmYoEF0uWiBIKTqgrnL8Z4OA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/Gy67O6oRWQ6HpfMOfWHT2FnwqEwLIs3RAy8SgYNh0vs5ALihGerVfqQYfCT9LA0cLYt/sC17kc/DZOJaXhhQ9lbVmp0646/4KhlRzRoDf8GW3A3gYzvGHCfJQQlvv5QFyQ8DVVKz0iEaBiI0Zk+rMkw7iNunHyWj0fHUfU/iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YH5oPkdG; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YH5oPkdG"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4889d0a9df0so4141275e9.3
        for <dm-devel@lists.linux.dev>; Tue, 07 Apr 2026 02:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775553276; x=1776158076; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTvIH6uLotmUWUsr9n13ksPHG8gW+8ntYQwTvFnEU3U=;
        b=YH5oPkdG+RkJmrH9HWUvnadZHd5U4DnNTtwpC83FLriEJiHvOWCTs0FysRGt1DOITJ
         WR+frT3XbuWmcwxNouHe9QXVY7C8Fx13o2Lm/f7hXdc2TPmYZtx1UWNlJhCuvtWF1z1n
         HajfTgJsaKlX9lBtdoZW2OPZmInFQHDUOmwb6uwrBcuHt/HcI4/w4loqxFx1R2/6prXF
         haStlsyOxTNhMAnhL5X78Q/PA//ZmkjmffUGxS/jn/36/yBUWbQMpop+xcRayCAgXA1Y
         U0iNco2PFspcjntWPzcO9eOYXSKCIG+Mwzzj/JWItnBjFC1RT/JSi9enIv1e4zsm637n
         Zk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775553276; x=1776158076;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTvIH6uLotmUWUsr9n13ksPHG8gW+8ntYQwTvFnEU3U=;
        b=UPJkWyMRkmUOYpeOrrchZiN+8WD05+EwOhWen13IBLt4KoZaMQ+FfyghA2T/aFSI9s
         51frA1iaJMfjSzpjRrqw63iexto7g3XWuF1/jy673OA8a6WTHyDDR/l/T1ongrjb4uZ/
         mfW7KPxc4GDSzwICseVluh62p1OB+lc9V1Us9/QtQ/8O5Kz5I0jNFbDBTiYpyM97alPL
         L/hIOLdvtUq9g3W/HYGJVcUQ4b+sKPtwr58B5iPcSzgLcmpyrv4QK5a4WiGyGr1Otijo
         xjhhr8s3pTiQORN8Q58EnCFc+2ooivPCFy0gGpnfv8dSU0HgvhDf7o9aGUnxnzoDPteC
         WtOA==
X-Gm-Message-State: AOJu0YwA/DHpZ4dknfDWfaKVT4AC3BBUlWTmvZa8Al/EnbooI8rAVtoI
	W9P7bDA5ZaXr2VsGq2laQYOb/OGuREIOaGQUnVES71khsKVqty8Q0u0=
X-Gm-Gg: AeBDievbnCKyvMJKXfQcSvZGqRKY6en2sQ7sxcvy5tF69mrJ9JhjPPnjXQr5z7hj5u3
	P0nS6jNkShm3G1yZaM+P2OQk30noy+cKafvTjLC2/nl4j69sMS71lriqjYb/KBSY7Q0knhjcgil
	7IuHzkBU5zFPHrX7jYi/Tovd0Pc9+jF9H2OMJibGhCB+F/jITD+mree+vBUBGYqBYGLh96VjC3o
	MjXQkR0gEJrfw5NqAEGro6axQ7RKBGRoXXHypeK1YQ3QHvmpr+LNJhEl0l3K/yOBAuuMcUi/OCH
	CGEa0GdDvRdsGGMvDaAFTgkYFVoJDDvREcqXoG5tH2wSeZWVu4uoUPJ5hd99a/pygZeavP1FMgR
	9GE6PB7Tg79ZpVQVK7ZkLcclDKFEkBs8hGNCPR/chd7eb0y7lDkM4K3J9dvLi7ur8x7LJIz7p9+
	JKfC1crs050JcRxIBlag0RkOYK5nP5DR1kiUaxxcTdAHEYaePL3zCVXMBYAkyuHQPQFDw=
X-Received: by 2002:a05:600c:468b:b0:488:ae6c:42cd with SMTP id 5b1f17b1804b1-488ae6c4423mr61817075e9.0.1775553275768;
        Tue, 07 Apr 2026 02:14:35 -0700 (PDT)
Received: from localhost (119.red-80-39-162.dynamicip.rima-tde.net. [80.39.162.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4888a706062sm473140645e9.9.2026.04.07.02.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 02:14:35 -0700 (PDT)
Message-ID: <36483a48-bf89-42da-be3d-303f3560d2d7@gmail.com>
Date: Tue, 7 Apr 2026 11:14:34 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] libmultipath: Handle SCSI-2 style vpd page 0x83
 descriptors
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
 Martin Wilck <Martin.Wilck@suse.com>
References: <20260327034136.1157685-1-bmarzins@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260327034136.1157685-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/26 4:41 AM, Benjamin Marzinski wrote:

> Some older SCSI devices return a SCSI-2 style vpd page 0x83, instead of
> a SPC-2/3 format one. The SCSI-2 page 83 format returns an IEEE WWN in
> binary encoded hexi-decimal in the 16 bytes following the initial
> 4-byte page 83 reply header.
> 
> Check the 7th byte of the vpd page 83 buffer to determine whether this
> is a SCSI-2 or SPC-2/3 confomant one. Byte 7 is the 3rd byte of first
> Identification descriptor in a SPC-2/3 confromant vpd page 83. This is a
> reserved field, and is guaranteed to be 0. If it is not zero, then it is
> likely the 3rd byte of a SCSI-2 Identifier (The first 3 bytes of the ID
> are the Organizationally Unique Identifier). Both the sg_inq and scsi_id
> commands handle vpd page 83 this way. To make sure that the WWID which
> multipath reads directly from the device matches, it should handle this
> format as well.
Out of curiosity. Did you run into a specific old device that triggered this,
or was this found by code inspection ?
