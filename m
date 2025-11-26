Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B42F83A3
	for <dm-devel@lists.linux.dev>; Wed, 26 Nov 2025 10:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764152081; cv=none; b=uBivQb6iesitRoMiynWMIuDh+TI01SBSbLQHeNWyfM/8oIOLzJET48O6c72p6LcZjRZ91c+VdO8hMLBqnnmE8wZpn3avHetK5NhTcLnuDixalUTHJLf8rk7K16uIWgyrqrzIE2zQvMmQt+AxiyNO/XW7Y1liuI3b7JnMdz8Fc2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764152081; c=relaxed/simple;
	bh=J+H9DXT5OBV9m6l8dZrD5CNRbbY6UAu1yGdzlonCIWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezUeAP7u8eFykomY4lZO7Ia6CF18UE4IB8+dLDe4aj8HVIlkgxglIisEq0urimoik0cMFtn4ZQNFuwAuPZfUCeOxELYREQshi5EFTeti+6jhfOg3pXoDs1iNsPXjgw/TCee7LyVwn/nrtI6HUr2YaV9x9i+crML0EAHQYbiUHO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8yUmAJX; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8yUmAJX"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34585428e33so6509058a91.3
        for <dm-devel@lists.linux.dev>; Wed, 26 Nov 2025 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764152079; x=1764756879; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wi+SDeiIoLJQ2kckUqTjOMqCDPLpLNM9S07CFUmnZ6s=;
        b=C8yUmAJXZNpIQBhnEM/Ah7YrQD22kacd3hMjyv45STOeqvkD8InXCtRPDZWllBCc8N
         gduLExLP/OFTEGDqGdwlt5Z+lhdoSu3is3P+qm+elx5Z1X3GM3apcO9Rvfw2J2JxKCPV
         APheGCvn3ZxuboFN1F+dnUkJqJL846L18YUfbihJ73Hcw1cyywfmZVQASCSrGnka8xVm
         bi82Qm/3RMeHN3+FRAbsID6Gt678yyNP5r28pVRXmM/Xf5A14j2PXWy8I1fZhxwaN97M
         k6YivBXisa1ONuIBShdKBqaczbJoMS5bis35zYScchq0gY5eVfHrdbCHcXMxSF7WfVO9
         dRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764152079; x=1764756879;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wi+SDeiIoLJQ2kckUqTjOMqCDPLpLNM9S07CFUmnZ6s=;
        b=B3zEPV8qyQPohOheWryVntmmYJtkocBYJnmb0kDADQAw16q+VjvwhFd7RlJmsHcc4I
         KnNm43lpOZepNTnzEqbQmmOgIBpsm+oO7UsjvitOO89fY31yjm5KdOLWX3iD/9yuuDa7
         U36uVpnpjgagGtt6vl6RhuyiwfSourZkYUyltlzrjcugWqnDK5hudUNUvJ989q2RBGcx
         NaeUjk/3DI+BiW7Pjso5TxOa/RnCYX77Dj+5eiHW0mivBIO38TWdYsdHgpkSF+/9DNXo
         z002vPwqz7RlPYfBNUqADHK0AN8A5OZFaTO5CpJDoA5Kb++O24hY97TVjYzmTIgtTEYe
         UZcg==
X-Gm-Message-State: AOJu0YythMSu2TWOyms4Af8QcBjPOOeaImZvxGkoOkFUH1l28iBNVGIz
	l3zd/xMxlMhLxv3dG6eKZ4aoKJWMnmwmY1g9y2RQc78lBOWEWPpSLmEc
X-Gm-Gg: ASbGnct4XIEfwJFtZIAZym2EXv8nBawAKQAvJqMwaX4O4YL+6KfbWSaRqPFrF8jGdRx
	1YB8exwZ3WieogR5Lq5wUFDVkmxP8sDJYh0ouP1fSUGkyWwWU6sYZnJ5rRapEZ7SxwQ5yTmxVSV
	hH9v8XanQA/braOuNgHi0G0Gfq1/RvgpI9TCv3w0klF2m3hPoon5jABgjIGavgj8LCMua6noe3R
	u0buwFsiiDcarIzNhd5V0WGFnfiikPVCNkaGWva8PKQnaBkOQDID9y6iUvT1MPUU391UTL9bXeR
	cP5gGQiq/B1zkbRnX+3twYO1z0Op3/YYrfgdCkcrxWSPPEt8iFTNQX3aIMFz1Zz5PTVorn1NrN7
	cUOT0xtjKB2cov6WAbSRuix4gvI6rJ2ZGZwg3KQY+6bqn2dY8nYaKixMgKP1lwFDkkhv5Vehkh4
	nOafFp4On+/M4gaTPZVJ36jGAMiUAlUQ==
X-Google-Smtp-Source: AGHT+IFQEabv4PNtolwpa8n5AuKpK1H58aTBlKZdu0dHQlwrZWrJMaYnh5FBOmSumqqz/nyBBS5z/A==
X-Received: by 2002:a17:90b:1c91:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-34733f3e84fmr16715848a91.34.1764152078789;
        Wed, 26 Nov 2025 02:14:38 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0b63dbcsm20905512b3a.50.2025.11.26.02.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 02:14:38 -0800 (PST)
Message-ID: <e40cb47c-9f92-4982-bf3f-45ec9f2a1681@gmail.com>
Date: Wed, 26 Nov 2025 18:14:32 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH V3 4/6] nvmet: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 bpf@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-5-ckulkarnilinux@gmail.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <20251124234806.75216-5-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/25/25 07:48, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making the error checking
> in nvmet_bdev_discard_range() dead code.
> 
> Kill the function nvmet_bdev_discard_range() and call
> __blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
> since no error handling is needed anymore for __blkdev_issue_discard()
> call.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> ---
>   drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
>   1 file changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
> index 8d246b8ca604..ca7731048940 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -362,29 +362,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
>   	return 0;
>   }
>   
> -static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
> -		struct nvme_dsm_range *range, struct bio **bio)
> -{
> -	struct nvmet_ns *ns = req->ns;
> -	int ret;
> -
> -	ret = __blkdev_issue_discard(ns->bdev,
> -			nvmet_lba_to_sect(ns, range->slba),
> -			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
> -			GFP_KERNEL, bio);
> -	if (ret && ret != -EOPNOTSUPP) {
> -		req->error_slba = le64_to_cpu(range->slba);
> -		return errno_to_nvme_status(req, ret);
> -	}
> -	return NVME_SC_SUCCESS;
> -}
> -
>   static void nvmet_bdev_execute_discard(struct nvmet_req *req)
>   {
> +	struct nvmet_ns *ns = req->ns;
>   	struct nvme_dsm_range range;
>   	struct bio *bio = NULL;
> +	sector_t nr_sects;
>   	int i;
> -	u16 status;
> +	u16 status = NVME_SC_SUCCESS;
>   
>   	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
>   		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
> @@ -392,9 +377,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
>   		if (status)
>   			break;
>   
> -		status = nvmet_bdev_discard_range(req, &range, &bio);
> -		if (status)
> -			break;
> +		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
> +		__blkdev_issue_discard(ns->bdev,
> +				nvmet_lba_to_sect(ns, range.slba), nr_sects,
> +				GFP_KERNEL, &bio);

We also need to check for memory allocation errors in
__blkdev_issue_discard(). However, this cannot be done by simply
checking if bio is NULL. Similar to the issue with xfs_discard_extents,
once __blkdev_issue_discard()->blk_alloc_discard_bio() succeeds once,
any subsequent memory allocation failures cannot be detected by checking
if bio is NULL.

Yongpeng,

>   	}
>   
>   	if (bio) {

