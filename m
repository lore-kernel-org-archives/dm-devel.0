Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A740276408
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 22:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405775; cv=none; b=bGS0lnS4VbgaC7qDpaj5S0ExTqVFjcktILYGICHgPNjBqWgZwBKantL/ylywhLtjWyj/YdPTuRX9c505+M99m7lkn5D66+kYizE7jEG8biBzEd0vUeYC/LJy7sIXM7z+uV3WfI+zShKBxk+NSpqbs9rJW4Y5MXSv8A6u2HBZlQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405775; c=relaxed/simple;
	bh=1Ay2rHYFemB44J5xEVkTil+N75NLcE4PSSkIx8V5G5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=leqYD654lpiaKugDGH0EBLt55r+lRIkTy0I/5a9mg9/yyPFOFKiFDpaEfmwkzQXWz+YF4Ou0jNm9bbbl+FKhDIbWuZZhmcVRH74UyGf29bfMxdtJooHDc1rX2ZGSfCZPoq8wlwYS+Ls/W80AfBaA4CE5fSLXQo6CdTMd2dJvGk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1def142ae7bso42924765ad.3
        for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 15:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711405773; x=1712010573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ay2rHYFemB44J5xEVkTil+N75NLcE4PSSkIx8V5G5I=;
        b=HXgTqSQYo+WrXAnG+kzXvbEeM+utqKsGCZQ2dej+wupIw7YpX0FfKcd4CPIVFf2xxv
         vwItx7Q77/7JW4SKCvi9NveabTki332pCPP21wfVaGmYOw4dcOGixfNele1UwNtXr0/H
         DCgvoRHbSq2CLQ28T5BeGnyHX4bsZr4HzErKXm6Pp3FLC55XS+644231VWIUzVgo2CeJ
         +t7XUrKcmya5q9flKBHLPjVKHYOC1yqkZ33ZcEU7VdY4V2i7xr8F1xknBFSysv3c5zZ5
         7VkyjgJ+/soKaMiUDG68VpYL+WgdOFSpLT/rhurArHAJ8LL+gYqpwgvhfHI1sF6OWltF
         3hzQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8DxBwdUjuV5+/ehFyDyCIBzOp42B9kWfcxnKXkp9ZjPhUFhZDvNiLhhI5we7FzUiORReqCT4IeDHdm9pXShmt/hqkdT01/Gc=
X-Gm-Message-State: AOJu0Yz2OJAZra8Nl1etnGrHPtjuuC8B6isG6XiCeUci6Fb5Hue/KN5S
	+2cg0mnJ4TfYGjVz1muiFs9wQXHhfJ+1fW7VRWSsz7SgQKirlxwa
X-Google-Smtp-Source: AGHT+IFk182OYI6LXsNe0+MNjqoaDZsE8bBJFlK6xMQloJ2JRx+dYFgULmW3i9PiYaDZOKxsC0Ecmw==
X-Received: by 2002:a17:902:e752:b0:1e0:b5d4:9f60 with SMTP id p18-20020a170902e75200b001e0b5d49f60mr5829559plf.28.1711405772921;
        Mon, 25 Mar 2024 15:29:32 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709027ec100b001e0d6cd042bsm936742plb.303.2024.03.25.15.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:29:32 -0700 (PDT)
Message-ID: <efd36ac0-daa7-437a-be55-a3379632739c@acm.org>
Date: Mon, 25 Mar 2024 15:29:30 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/28] block: Do not force select mq-deadline with
 CONFIG_BLK_DEV_ZONED
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-28-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> Now that zone block device write ordering control does not depend
> anymore on mq-deadline and zone write locking, there is no need to force
> select the mq-deadline scheduler when CONFIG_BLK_DEV_ZONED is enabled.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
