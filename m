Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA57289362
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626518; cv=none; b=fh4wjEavTDJOYNP9DAdDzWqXLPP3nm1UgbbZtPtkXfQsduqt6r7IlaO1i5w3P9mz0cCeQOk+aK9GE7Mj+AxXapNKPT9v6JRufvZj+sSUd4Mhi8yocvmG0rj9MH/B7BIdVE3La1T9vZmwpzJ/kYWsXnvWi9wlKPUymGnF1PEZffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626518; c=relaxed/simple;
	bh=riUohbe+nhSKSfWHET/Yt5mBIMTKqf2kkbHWdODQalU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ns+2Fa77F6W0X0ISPtujcUlNyX2RRbqARNZ7D1KENwhK70uNyMhNC8VMesNVGEHZerIsmn15w6JiaBt63DcoFJ2Kyxcgv/VKzaeO+OdJFMmBbflVEhpV3jiS5c7zpvCRsBctsyxxzQxbMN/MD4ScG3hq64wIy3TU/4pGLUWlmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YwydcJ81; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YwydcJ81"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d9189e9a06so28736875ab.2
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 07:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746626515; x=1747231315; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=md71yFj7QjYOD6CmfKKjAp0TbUSgcGH/TtN+850EMGU=;
        b=YwydcJ81/7SuEotddKqoGeLcipVFSCCR1PBPlDmrz9gsoWqy3fLjGQ34YoOL5JPG8r
         l14+o4iM1yRtPfhCyAbbV7WeYpU59P6liw5Ar/Ezojp+FanlLO7krxJpdxZWBjNsp5l7
         UqinZtjVPVULrADHkdmZNz1/lZXTw6Z8oNgQUpmcopQbhjIcxvyXFRJl3ZjOmBUCSP+5
         eYJ2Bsx5Gp5jSUbRsH53aWbppRHFWzL/ruBXFVyw9QnLdkfZMKo4/3Yljjn2Y4a6+gp1
         Nvc7Wml1RpaqRjHjA4IrGmt95cSM9GEuVXd1NEtObrRm3eeTR6PREf6ocF2K4fbhFi5L
         XGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746626515; x=1747231315;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=md71yFj7QjYOD6CmfKKjAp0TbUSgcGH/TtN+850EMGU=;
        b=dhz82Gk1Lj/hcRQCJQ1APB9/fNdnMqlz8xgin6Bghwe7S3FfgK9dN1p8Me7c+bUdws
         yRYwA/WyVyqur0GPavv2F3dV0KKIxBNDiqdhYedzQ9VopC9is07IBXSLPwlHnyqwZj1r
         Iqo9E+7OTbnjqOqbJkhNhrzZVHAm4KEm0y73ci0vf2PDfRYLsBWkf6YaCsNZqikwE1pV
         Pg4VhguhECebc5gGVgUl2fP/sPvKyG8B7lOhZtbENurfh/DUel9IOqStwpUtpsAdGni4
         wHtrmV4kXuhWlPQkq9Hl52SGKUMUU5ltEqtuo+lS4SsMX8TpwDiVZw7vcKk0SqZQBdSQ
         TtCw==
X-Forwarded-Encrypted: i=1; AJvYcCXlGGUdbhquDKebdZ8OzVkP3EpGxTREAa2EMfXCmmabT+tlTPiEl+2fqUU3+5PMA5Bw1vYwuVFXYw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2qdrIjz5ZDlLJGYlX7z14w+5R/dGWpRYv1MlGBDKXP5wqibuo
	zTX2z0OJyRnkSLoin5QTqmi7gUE60e+C//jydBeLFMD7HYNFPwkVMickZHF9xBs=
X-Gm-Gg: ASbGncsqd79Fzu6vRb5tnVRpR+/szKURzuPpFOBwYxyppgi9e+4iACi6qStYwUmHbnP
	ZAmzfUhD89OzOxhezqlFTmkPvQpO7Tszq2aO321cBNRTJA/pSmH6MtmJFg+uxWXFrbU0OqX/yCY
	JS5UtZAr/oVhhTRb/ZW0m9cpfNaHldO+oPgGSI+wj7KG6bUXdEzkINPcTVEogsn79UMC+GOfIOK
	DBBu/K6rTF4Fvx6/84bmpMt8fjZcc0PyDMYH1+rhBw1Dar7wv/K3mHmA8qFv6JHIRUtQDn3TS9V
	q/Bsu645+a0TXQbd0iFcvFRkFsLogamVAkOE
X-Google-Smtp-Source: AGHT+IEPXkcUdjuoTWJKGESqgsxo1A4ob6I1ttYfFC6JrLgpCILRh6jZ2+LBOAWlTXtq2pbhrFyjbA==
X-Received: by 2002:a05:6e02:1529:b0:3d4:36c3:7fe3 with SMTP id e9e14a558f8ab-3da738e562emr32326165ab.9.1746626515075;
        Wed, 07 May 2025 07:01:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f6dd89sm31362225ab.66.2025.05.07.07.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 07:01:54 -0700 (PDT)
Message-ID: <a789a0bd-3eaf-46de-9349-f19a3712a37c@kernel.dk>
Date: Wed, 7 May 2025 08:01:52 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] block: add a bdev_rw_virt helper
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-pm@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250507120451.4000627-1-hch@lst.de>
 <20250507120451.4000627-3-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250507120451.4000627-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 6:04 AM, Christoph Hellwig wrote:
> +/**
> + * bdev_rw_virt - synchronously read into / write from kernel mapping
> + * @bdev:	block device to access
> + * @sector:	sector to access
> + * @data:	data to read/write
> + * @len:	length in byte to read/write
> + * @op:		operation (e.g. REQ_OP_READ/REQ_OP_WRITE)
> + *
> + * Performs synchronous I/O to @bdev for @data/@len.  @data must be in
> + * the kernel direct mapping and not a vmalloc address.
> + */
> +int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
> +		size_t len, enum req_op op)

I applied the series, but did notice a lot of these - I know some parts
like to use the 2-tab approach, but I still very much like to line these
up. Just a style note for future patches, let's please have it remain
consistent and not drift towards that.

-- 
Jens Axboe
