Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F5C1D6AA
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 06:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040312; cv=none; b=N828jbHphjClMRhu2pDOzlULB36G+WMnG/ocxnG/k4dlJJkoxOCPhsagrk6t88SRYzlyu7wwwtxWGsAi4TZe5EZgZOC0imoYA0/nlhw4GuYtfOrR85puqPS5m2W9UqVOpA5A9rjAR6sKkA+iOIjPDDJWtTCQi3QAV3JQkgewe+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040312; c=relaxed/simple;
	bh=CoUgfvaStGsWej3hJDcJqjGMPB4tYC8LiYuom04jWD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XyzBa6jMq9Iq/fW9zjA/FV9G/N0IfW5h569zfI8IOsAv1CfUk9xAkY7+wTb0usDNxViKUr1qx91/yhsyItzduTemkasDZZ+t+tgmDrxbwl866q/6xQnduwCQQKZGmgRswEAZI2aIuI3SrY7IMbDf5TTmurm7iL+/R6p+22MIHAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYUjJ9fi; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYUjJ9fi"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cdbc4334edso2456554a12.3
        for <dm-devel@lists.linux.dev>; Mon, 01 Apr 2024 23:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040310; x=1712645110; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sm53Z3L17Zu+ow15vuobEJghvq7U3t4LFtEUPD1JM3w=;
        b=KYUjJ9filI2XWg/nnEbxVna8aVP/MwKjqskMLEck/ey95+uI7SnF217iyOLQoiNKYr
         QZo6UFCcYEemXw97x91OI7NznAW8eFHnITHSFYQIsvVGGnFH1DVyD9uDKvlasU4xRCp8
         M3ZMeYfy2NfxZ1tcvNEstyZPIXgyovFiwZpRq9x3HUcdLTxpquX8AyYRTzr13lQLxtpn
         VeYWvtU439It8jXuLPpprHENIKUVgZaxI1WirYrTZi31nDgnuGecUoEqg99DJ5Xo21rO
         ZhVvHGDnsS1oNZplKk8672XKLUqGyrdgyclt9hbjB84GLwp+5N5THI/U1qVSWUsRwOhu
         k1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040310; x=1712645110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sm53Z3L17Zu+ow15vuobEJghvq7U3t4LFtEUPD1JM3w=;
        b=uaERF6G6y2Sg340rQhTD/ATaSyx0GR4RMlCMUXDQLjcIeCusTZ6khIXx0n7lrH3Ju5
         PapUjyVya0XkuCPffzaiZY3dStnTwsXUFX1wjsXcynlduyT6r7TmlePauDLIyq+rhWcM
         BNjUypRKOf3RfJ/kXPWTBc1H024PUeKuaA3YuEOoAzQcvD7IvWqHv0Xzbwfu0stUJyxm
         UWTs/5fmZ0G4gMxTD5sXAIGv39DivF7m3SyS0rJkho2Gt7+2kAcDYDMsIvPcWwhumNi/
         EaLdnmmz7hnqnoeWbusk4eR2VyXGZhCecBCMG8iE14yBlWfKkFKbJXrmxaM7R/n/SnnH
         aDag==
X-Forwarded-Encrypted: i=1; AJvYcCVsJSV4KyQMIUh7adTBpvZuZC1s+GvmNK/UTXSbdXmItDYpP5yxReCAwEC1A8LyzTY5X7lTBhyqA3VZ8yQGn6mtM1aCr/eijwY=
X-Gm-Message-State: AOJu0YydSBpdKoLc8PECcF+axoHbG86Ryl62e/2znR4Hbs9a9dcnd6fw
	stuiaVEnMs1xypRcClR4SozMBXk0ZJ4pxEValjOYBvrzcA3jWEdy
X-Google-Smtp-Source: AGHT+IFF93BCBK3FIDpFKuTXhn9tbpLReSTK3uggz3k0H38wO0A6ivGxtP9jVEkKk5ulOQtfh0hUQg==
X-Received: by 2002:a17:90b:4c4c:b0:2a2:6d6e:1057 with SMTP id np12-20020a17090b4c4c00b002a26d6e1057mr24949pjb.7.1712040310359;
        Mon, 01 Apr 2024 23:45:10 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id l20-20020a17090a409400b0029b2e5bc1b9sm10925785pjg.23.2024.04.01.23.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:45:10 -0700 (PDT)
Message-ID: <3e159b10-170b-4c67-80ca-b833b712d91e@gmail.com>
Date: Mon, 1 Apr 2024 23:45:08 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/30] nvmet: zns: Do not reference the gendisk
 conv_zones_bitmap
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-21-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20240328004409.594888-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> The gendisk conventional zone bitmap is going away. So to check for the
> presence of conventional zones on a zoned target device, always use
> report zones.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


