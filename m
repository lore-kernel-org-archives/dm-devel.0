Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1345BF8
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707155902; cv=none; b=aR2C17rVJrCQDbAOqUEc4CJiy8umjrUg7ykrE3FFvPxCro5wEkiF4KaXngyU3cQfdStPTSpuymizotXvJJ5uUg+V2oMpE0GwuULBEelh9KNF5za/+5QF/NkfTBwRCKwGTjDi06q8FIumrKSKXs3kBjoBjQtEZOnhsz1ht/HUEw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707155902; c=relaxed/simple;
	bh=61adf683+egZIlUvesZIKEgx/y0A6FF4d8WlS1zfnLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oWGiqEoAKAP5Odyb9f3/AWdrQjgAEuQMcT43r+9S/ktWFx1ybPcok/y8yLYEA3GTXJzDu5/L6/FNJsDlCzHEKtGaBziFdrL0sSF/1dsXm2Sw06D/3TegjNPZjr1fXKsg/2KVjfn+9W8k5QCmwHAiPRhFvvDYhgHLrSXWFHJOmnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so4575021a12.1
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 09:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707155900; x=1707760700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ki+Rj+qYbcWEhGvgnnP79yte6HVA5O9r/8RCQ3zF1nk=;
        b=qB+Y+eMRhNTMhsL+LA1Q7cCGdESaBmB+5IMYFh1lxEIW1swegLG8XdRQhhurVrK7Wg
         LbJi/2gFnqoXBOcDVdeCcm0ZDhCMLwmakKbc2P7TVGG7xlNDXxxc1JNRzy7NroKOG4Ch
         D5wIQqW0wLxjEjX8DvjdMEC7D8EE+24AmWWtgYlYegZqaozD/UIEFc+yvGKi9Pbhag6/
         VG4bjrW9dP1yqmORpULCQBxv4x4mvkjI5JD8gFHJCOZQ/zsglFb2Ha78k7H6+qipNGge
         uG1Ix8kr+5yPhyjwQfP5364l4zq7/yRLMFF4O4le+WP/+b5/e/yvmOc7QydSyWo8u4Dy
         VGpg==
X-Gm-Message-State: AOJu0YzPnRtrg/26MHoiU6U4e9orUeOZjVCmSJJsFuVb0LEKJ70ycR0C
	iuKuj9EsVwpHNzKkBko8kc79EnHWFOckyxmktfIijhCo5dKqz/fVK3bw5FGv
X-Google-Smtp-Source: AGHT+IE2b/L0OFWFa2x2gCjQpr6V51+zJkhoHnMeZ92ND+ZhxM9AVaVgMPnfNUK2MaukHgB+61yh2w==
X-Received: by 2002:a05:6a20:8f17:b0:19c:b3f9:2999 with SMTP id b23-20020a056a208f1700b0019cb3f92999mr304766pzk.27.1707155899796;
        Mon, 05 Feb 2024 09:58:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU+AY4tH1rpQfsr5lu8ncMRq1LR8J1sQi2thXF71oa5DtSH1yVjWzdmNA69o+KEg3QLXoCkjwepSOeLN9l+b5UGx5ORUjJVUxrIGr4i3kuf64tgYDjLflR4jZ4LgPiwxVOctIW3GJBeVH0FD51jaljraAR2RYy0cB3VCKSTfV8XBQ8IPpTsueDkZXG6nzal12oP8L7+F8z8UKT0jsRIBzdsoWbYVKIRETK+ZMNiShxypDVhRHyoNrrFkIcQYLcqhyqdQw==
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id y26-20020aa7855a000000b006dddd5cc47csm123846pfn.157.2024.02.05.09.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 09:58:19 -0800 (PST)
Message-ID: <6414d453-29c8-4ad4-911a-da3d5341e39a@acm.org>
Date: Mon, 5 Feb 2024 09:58:18 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/26] block: Implement zone append emulation
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-9-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 661ef61ca3b1..929c28796c41 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -42,6 +42,8 @@ struct blk_zone_wplug {
>   	unsigned int		flags;
>   	struct bio_list		bio_list;
>   	struct work_struct	bio_work;
> +	unsigned int		wp_offset;
> +	unsigned int		capacity;
>   };

This patch increases the size of struct blk_zone_wplug for all zoned storage
use cases, including the use cases where zone append is not used at all.
Shouldn't the size of this data structure depend on whether or not zone append
is in use?

Thanks,

Bart.

