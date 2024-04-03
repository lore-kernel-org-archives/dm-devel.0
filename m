Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603363FE37
	for <dm-devel@lists.linux.dev>; Wed,  3 Apr 2024 03:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116603; cv=none; b=tg9ncUjSiV/UrMA0xAZs1HB6jqPexxPE264P1IE42M9wAZk+IJlcLA3kL/lfFSzXH+66ILR4LrsXUdzIxm3MtidQaWST9fWWqmJXf119fcxjYnzJJWqY27niFRibFIYG5DqGK+cstB9N7QTsojqLPH6aVSkAne5CWqJ9bMa3/+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116603; c=relaxed/simple;
	bh=YYCPVBA3375GF5Ph5qAHEvIAw0hfx7yA1qo6ZRkPtrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=gWbmP6rzSpIsqKS+4xsUjB/18zi75zSlbiJHfLzfyk8uYMPjpmXokycYCjpNQ24Zb6RqEfQUma7Sr33tM8K13JEtfaQ4muS9jjRS30Up5JL+GhPipOntmLZJw71zekXH1/B5+ak8jrFnnbo2CM5vN1YQQ4Z+zZkMIPZvaqXRhdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cu418TOl; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cu418TOl"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cedfc32250so3726924a12.0
        for <dm-devel@lists.linux.dev>; Tue, 02 Apr 2024 20:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712116601; x=1712721401; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fugzhJcIxXGAO0ssTnR0bYZbKaxEwSQa+2J5+v83xpo=;
        b=Cu418TOlFbVfDDu2btrEnB0eCnRtbU8kbSNvsgRfd/ZL6NRtPiXhssvWAKq4RWfVjH
         A55vqhdQvl6J4gciNJ88W5E8DCPua8YiHG85BlWOe8OI+/15cVmIT4y41SvqLR8lA2qR
         bOjt2KndDNcdp9pvN/UdGxf5w7FEFZ8XNjkGwt3r1EkkpKsYS2tayd24aaZZSIyz4jqZ
         6jI5KEuHnAfCO52EAkPLtXbSQhBQogY01eeUkZ/H/NMaX2rjUwxQ9VZYWQRuJufxy74s
         /ybA8FqkasEAJU3UF7p9w+jTcXs+drJ44s0xGVO1Os/7ieOwoJorWt4c9xuJ2tmYl/HF
         OKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712116601; x=1712721401;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fugzhJcIxXGAO0ssTnR0bYZbKaxEwSQa+2J5+v83xpo=;
        b=sIxGXSzpo4Zy/OBAvF9tXAbpKb88l/n86TXepb5BeUHzrgiTHZmKHwToKw3pMEwY3A
         cLzl4ZkE+oOasxktt47TULGuKKwtNKuX18Cbqb0rr5F3xV404log6B3Od0Fm1KfUpRni
         wKBsfZPyzEfxygqhgJU1NcfJCK3RbLHQDnAdrS5pPHg/ChuXvc8ib20h3PTR3iGAL+1v
         VeYpW7kuARssgDEmMiD/BkKia7wJksm7czlEacWupR4PEiNYd1tMRGw3MERmrzPKYFf5
         rmD5TiAdu0jySzfHWsluyM4fj9FbgP2QyOTNRrWsuufYevovVex7M5cWg7YGamMTn6Ul
         VCsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzTyI3bWUZkOCs/vj9aB5dcJUDHyLgMvrPkmrKtVm55B2JggKsS/OxeMrznaRVzS0ZyuAOcc83UwM2znhxrceesGByNkkOrxM=
X-Gm-Message-State: AOJu0YyTR4rDhlxBKdU2CdWnR8MEETiu2QiQbcYk9iasnApfVC21drrr
	6aM6lV/FRYlhw5kLGvhjK0tCDlWfK0oePlBupxP7e/pd7ht6RcTy
X-Google-Smtp-Source: AGHT+IHfoJxdwg1KatKMqIm6Uh/xcA1bx9qJJajW01kM2Vir6+vvULrmKk55dbcD4GRCoM8/BWI30w==
X-Received: by 2002:a05:6a21:6d8e:b0:1a5:6c73:74b9 with SMTP id wl14-20020a056a216d8e00b001a56c7374b9mr14589743pzb.48.1712116601569;
        Tue, 02 Apr 2024 20:56:41 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:159f:e332:af97:bfba? ([2600:8802:3800:75a0:159f:e332:af97:bfba])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090adc0d00b002a29160df67sm531650pjv.27.2024.04.02.20.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 20:56:41 -0700 (PDT)
Message-ID: <7a3be43c-39d9-472a-9593-89a1c4e03004@gmail.com>
Date: Tue, 2 Apr 2024 20:56:40 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/28] null_blk: Introduce fua attribute
To: Damien Le Moal <dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-18-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20240402123907.512027-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Damien,

On 4/2/24 05:38, Damien Le Moal wrote:
>   
> +static bool g_fua = true;
> +module_param_named(fua, g_fua, bool, S_IRUGO);
> +MODULE_PARM_DESC(zoned, "Enable/disable FUA support when cache_size is used. Default: true");
> +

checkpatch is generating warning on this patch, please check :-

WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider 
using octal permissions '0444'.
#31: FILE: drivers/block/null_blk/main.c:229:
+module_param_named(fua, g_fua, bool, S_IRUGO);

Also, I noticed that for zone_append_max_sectors attribute patch
you are using 0444 but for fua you are using S_IRUGO, any specific
reason ?

-ck


