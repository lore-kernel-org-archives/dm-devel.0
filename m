Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B5B2BCE3
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040195; cv=none; b=ruMaTZ4TR9foYWXXlpTI/9ioOJ+t1H6hWoN3SGgjfn+c226hAu4kBZ2X+WEnFGCCnPns81bFFHVGmcZcT/2MZeR4kkxo0cf+khl9HPjFIFKVo3zP9B/YIzSqMIJN3jw2LSw3zv63AcFHL0TTZrSRG2enpJKEgOLTPsgpuWjvf5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040195; c=relaxed/simple;
	bh=AaQc2ub9VM0LXeNFqMO+DpfwjU7/Sm5uTdBo3sy2WlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C13HVzWfAIfBsHjdNtKGQLZs17S35j3URy9pvQCN19cr//7sk+zdS3E5JKbVd6s6Ha8gOIDMtHi4AYtrGJpNb6Ls63ahZM2bVbN5cUUiCUt8EVsEl7xLE44P6hHiYdB23joKNGOhUIVBm0EGrqPJhQSpXr6/yuM3LJCuBkx85x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hf81gorA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hf81gorA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1def89f0cfdso42999195ad.0
        for <dm-devel@lists.linux.dev>; Mon, 01 Apr 2024 23:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040193; x=1712644993; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5ZpDpHuvqRkPr674LQuVEJQ8beI/LgLV+GDkIcfhzig=;
        b=hf81gorA6l+T6O3ymMDrXO4KiCt/o3PpQRrlIFUeTufJP6/DqN8b6Lj96k9tnCqOUb
         eTbwckdQhVQj0jR+5tzYvMuFTrJyLx8gUxknVCKwcgxYY5b1BXAalmOnB7JBQRpAyeXv
         z2HXgmmh6LYGqOHAFk2xiV5TgnSSVcrHZQ1qQ0GtCutomnCZ8fzXPNP1W6wYgk8dPpAQ
         Jq86FTfMbo3+Yc6qeWe82r75QffhAMreBWikAhm3WZ95cZxFA04HO6gez0wK+lFUHTSx
         EPr0/NIvALP98uX0GoKP03hJA0RzuqKSfaMD/cljq1JraBFSNXkIUUrOWnWS3j1l1wA3
         rKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040193; x=1712644993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZpDpHuvqRkPr674LQuVEJQ8beI/LgLV+GDkIcfhzig=;
        b=u+jSESlWr9QvnzggoVa4KRefqN9ex5ceiznoxxK8fHB1+R6yibyDCyVx7dCUVbUH9F
         ofW6lAdyfmuFhZyqyRsrGMeXy0leJpHkURvYBacUyggrB/m4oH8HgdcQJbf89cDTJb/m
         Hp9iL8pDOuUS177DcQCR789du9OTgq0S70H3rP8CKi8f0Q9yIevLSjMaG7yG+5G0if85
         Tl6YkVmabqRlfVgRiNcrcpKf05MvB+yrerAZB5AtUNlU7Lffw5xkJ+0/t3nImqlvK/6E
         5xgJ/rH0wiOcm3VlkHXkxKfztGarKdDEUxYXjilv7jZGRQ33b33QATrH9U7UCvu1tH7k
         71Fw==
X-Forwarded-Encrypted: i=1; AJvYcCURYxw6zATTXC7TdPcXXIawE8oCV2Ka5kldXnVD6zEevvxlm0YKeHauOwr6L8wLWcTXe7sOWbuFm5zLFELsw28m1Y8mY7FEIqA=
X-Gm-Message-State: AOJu0Yy2mkWSL/JRKbsSnThx6bVvAqLNEiCf9A51i4e50Se5uMBuCrvY
	eAg7mPe3T/RQpNiK11d9g/g8ar+h8HSbzXhHGmwgX1qu6+pA5FMw
X-Google-Smtp-Source: AGHT+IEM/srVZSPtUycGFnEMMDCOvK5W9K0Azw0ckKfS6iodyT0ENHw+o3pbopHF/L9b6DtyRXWrOA==
X-Received: by 2002:a17:903:1c4:b0:1dc:b64:13cd with SMTP id e4-20020a17090301c400b001dc0b6413cdmr18643219plh.27.1712040193389;
        Mon, 01 Apr 2024 23:43:13 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902bd8b00b001e0c91d448fsm10141148pls.112.2024.04.01.23.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:43:13 -0700 (PDT)
Message-ID: <a4791bc1-f523-42fe-a00d-2cc92b35670c@gmail.com>
Date: Mon, 1 Apr 2024 23:43:11 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/30] null_blk: Do not request
 ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-18-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20240328004409.594888-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> With zone write plugging enabled at the block layer level, any zone
> device can only ever see at most a single write operation per zone.
> There is thus no need to request a block scheduler with strick per-zone
> sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
> feature. Removing this allows using a zoned null_blk device with any
> scheduler, including "none".
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


