Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF0055D89C
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996209; cv=none; b=EObch1EbTf9GfhOPlEktObXrDvmfldOwhnKfEHV+hVHhUyT+C7745Zm5cHGJD1Rjjde+m+oEfRbusZnJAgXF/gY+F3azSRSqzLbnwqyJyf+Ed/FAogAPlJu6qo1BIxMfZrBn0TBgqwvuJ1HAtWMJGtyYdOd+iEkqoLDl/Rd3cec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996209; c=relaxed/simple;
	bh=inWFXH/4gvwDDJShSxb1UbDeXwomoSCtPfVrGbG9V30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ScijUS4pPvoiPIlzianb2mq31+7Cr7l5p/QouAqbYQnDhbnVV8VrS6DvBsZNaciDRrmWbkB3sLve8815I4i7SjOByWmIxPw5GgLa1lpluccpC4eVkxc3yAEwIVy4azMP8yda+FLoTL2a2b2I5QfjwjfjC/gyg+OV5mv30wb8m2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGpYu6F1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGpYu6F1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49e73611928so39972705e9.1
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 09:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791996207; x=1792601007; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MprqRVTku8rnnoqrNidogE79Hh/sbjcVtJHMk6QO0CA=;
        b=bGpYu6F1Ny041LvfciwG2TrSHmSy7PzgHJlLP0kN7CdEwcyrIAnUwCFtUd/MxTeTg5
         ZdGqkfbsLP03njjNvX95rZa99DljI1dvMDoC8hCLPyBBdiSVEIfa6XKWmwfxp/otdmL+
         yLIIlNLEu/MnyQaJ0B7SV6MDO+n2v1kYip7nmQYrYgyPoPoUJ7/yosXULdJ5m4QR6WoM
         EJhljjFXwMKE/UbmCrzornZr7apP7Vvbas64PA2UUWdkffKrkumir8FTH9Ox/i7EQHRA
         3gdRSwOFiROkKNvnoNvPkacgMpX/eHDs4fJFtYMeHRdltMYWHerAA3dp/9hitjzDc4HP
         PlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791996207; x=1792601007;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MprqRVTku8rnnoqrNidogE79Hh/sbjcVtJHMk6QO0CA=;
        b=JGRp+E9OoBb+N/UHqxGtoRmHudFwHdXuwCnwXMqqseTDv0kanwMSX9pvggk+1bnyMK
         WYfS30k1GVWEUcO04MP0I5ph15ZiG1Jg0XCpLDlN4yPSSdU3dX9+Jr6ybgTcuzWvITsW
         oXrg8ZMntdaZOzkK1YzWdr/9KOSpYauE9Z5heqHuzWWiIjMLSvOH9k5WQ+Ts3rhmoiAa
         EK85e3KU+9hBobOkAayD2X50n+COUDJ4/MjAo+3mtgqLXoqbbc5YSTmDoH5now1kjWDW
         P/sl0coXb7+52towQtMjUQKoXkHyU9CPydLO5+Ls1KgHRGx3qqeQPokGRM6FZnkBJFr5
         heeA==
X-Forwarded-Encrypted: i=1; AKwUvBxj77mtys8B7ks8J5ziQSIyxPnVIsN7x9pZlt++iv1q9UM0ULqx1eW/j9SYg/wzS8kZJ7nlT9ytrw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIi7vNsyOi3pZmJPHPUC0AMG3w0qTdpO9BGpoXYZtiNJu5lJbB6
	DvoYlaUZEYzfgnpywhRZNfH5dCGitECJ9m8z+wg4azlBowNyTjBr5ILl
X-Gm-Gg: AYBFou3596it02yKSmQfn0sYodnF1Z+KjvAmev8bu0+FkbZzZYNaDX420RUdqQN4D6/
	nVD3dQJCe2vV0Zc5pQmEWElk2K69TL0QHMcdKOAqITFEvNhlkCoAEEtuHYMZe0fAESlVjiXldJb
	HNcrLBSqBrfD8rn6CVRtKBJRojcH1aNtWcT5JoSwBM9kqZf70ZT4C0n4eQWHMTYS0ux+YOQ4dzi
	O26IUHV8H/3Y3pI+4eIvp07wvrlAmLjCS/K5NC805oa9RnBy7BNdsO6rYkOZJ/sApNfOaQRQFCg
	hgSbAXvnrlgwIzcIeUK/Vmgfvci9GNVJlGckQ+hEWZvOeja9NJ52paYXBDoR1KTEaf9tNwKa7lL
	Bkbs8LHwRKYbg2K5bQ2WfKapHoTRWhH436etnHYQudSqlBAf2yecgub6tvHJ0Hae4tzuj6O08BU
	MTeZ2b1Dq1uheB8bXZpGJ5ZWYEqkGYz8BIul6plCX0q/h11+wWXfejT607xS/rRMQ5W3/BuRQYK
	j3V9uIP7GqE31zdEB39fhCmb1ArHMoWV863k60Q6uD80XN/JE8poVJQPUWpNPit5D9osYzeoVFT
	8qE1eOYGAlNouXJI7S9PMXiEq7NvCTmni0RLVxJm1f75mhng
X-Received: by 2002:a05:600c:83cf:b0:4a1:ac66:604b with SMTP id 5b1f17b1804b1-4a1ac666a65mr120408565e9.1.1791996206748;
        Wed, 14 Oct 2026 09:43:26 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd640be0sm4751135e9.1.2026.10.14.09.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 09:43:24 -0700 (PDT)
Message-ID: <7d3c3cc3-5c7b-4d28-82d8-2cdb5e010c29@gmail.com>
Date: Wed, 14 Oct 2026 17:43:20 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 04/13] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791975048.git.asml.silence@gmail.com>
 <39b964cf7510f42755188563da63d3d5acaf2aa9.1791975048.git.asml.silence@gmail.com>
 <20261014131554.GA16467@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261014131554.GA16467@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/26 14:15, Christoph Hellwig wrote:
> On Wed, Oct 14, 2026 at 12:02:02PM +0100, Pavel Begunkov wrote:
...>>   	case REQ_OP_DISCARD:
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index e929f94b25c7..1b7f8cbbda8b 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3150,6 +3150,12 @@ void blk_mq_submit_bio(struct bio *bio)
>>   		goto queue_exit;
>>   	}
>>   
>> +	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
>> +		bdev_has_integrity_csum(bio->bi_bdev))) {
>> +		bio_endio_status(bio, BLK_STS_NOTSUPP);
> 
> Wrong indentation, conditions are never indented the same level as
> the following code block, even with the weirdest preferences.
> 
> /me note the patch from Anuj on the list actually got this right..

I had to split Anuj's patch in two, should've butchered it
while hand applying. I'll follow up on that unless Jens
already applied the change.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

-- 
Pavel Begunkov

