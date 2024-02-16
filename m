Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A8817BB9
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 22:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708123429; cv=none; b=OIVpOnGtnxOBPjD3zuVgPxbsSA9E+06MarVk/ZyKeqeQXfSwTtYXrRsG6Zxgv4QlPBn9DWKhwFAP5qe1lDIMD4nLfRLbZSRsjWxZvuap9vViJXjZhM42bn9/uCgb4kVixX42QSxDj/MQ24tdO9wnLqaSr9y/feMnTu9XE7jrza4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708123429; c=relaxed/simple;
	bh=oUZiKefv9Qmx3t7BCL3NHtpyK3+Zxh1Yy9eaDs6++ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGD8n7zMBZWXOQHlNA5kVU8ihC6TlqLg/ztRIA273J7S6gZT7K0mjz3wcY3xLXy5ffgBkwqKwP/teYv8xOxZn/y+Cs3csz0bJTXelh3DvB4KLc99BHkBxWsIvbH8LzsV5zuBXYmJ45agEAG8QTM3ex9DcEEQrm6M4hY7jjWDS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kLSqklZx; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kLSqklZx"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-36501c9a781so110865ab.0
        for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 14:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708123426; x=1708728226; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jbLNO9CBjXaULrlNAyQEwwX7KLlQnYYw7p8b8Qb2UuM=;
        b=kLSqklZxIqjV70G9jTUCedf9fPo66AQDZVgeYFtKvwxJzhD5zxKMb6Dh4G6y/XEjfa
         aldedmqQKlqiWzvsry6xr/5cFFu5YzVU4fKPJCOYHqbghOlEKay5VwT2uqoecvE37ZqK
         5/JsySRte4ySzZOoXp6DCMViVt86ia+mo+BxR/hDhCPx5vzJ/5ry6ya/37JwZKKXjfzp
         /nKB2fB6Dv7lgbPJzjN4RkAjwxL4GaNc4+TBIJvPbwWU5Lul92L3aTM5fW0NQVhnmTiN
         9QgY+zkmA76XxwxB4pZku38Mb7nDWE7yg4ZWztm4TPtZO8owA9Be02FSg2su5pcJDYtD
         MB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708123426; x=1708728226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jbLNO9CBjXaULrlNAyQEwwX7KLlQnYYw7p8b8Qb2UuM=;
        b=tYS3x/URwHa08VEZpQnfy88/r7nO7aIKOQg2DswOIwdiUzNAaZfdu5/EGjsnzbe81f
         zDZDXnLez5Udz9zi/p2vg1VpYVmSVwHvwE7hi3X7BAPNmCbqDIwSEVeTVOxXS1nNN5hN
         eS/J7a4VuPraDp/ZFEgJS5umu9FbBDQ8EpbPUSbGCHqboisKlFRxYAMmhQTYqRgK3qj8
         DpKrZ+XqePi6mUyZAlC8dnYbh8S0D/iU4w0MYFOUc4hAxDJDuIW09QcARwJQmGrH7B9u
         sbZEmOB11/hzuEaiGx69ss1MmYi0NbquI1sD//dWQLkd8JPuI/g8ZXiB9/NN0JC4tlps
         fngg==
X-Forwarded-Encrypted: i=1; AJvYcCVhWJA6Ebkk5eJDZMMX81qCnef0Un73NHPPJJjx10oK5dV7rDvxWdkls3ZhPXMSpqy+N9ciWUxYcoMdwXbfPSxfaQJs+dEwcsA=
X-Gm-Message-State: AOJu0YzcHn5B5i1ViJ03sDRK+lak33ZajcFyCWRg2Vl3n7ROQKjcqHbE
	N9MHoSlX6U6mMTYPwIpPVzFuL8F/XZFksXOGUIbgJ4+VGknhKW2En3Scr2fiHVg=
X-Google-Smtp-Source: AGHT+IEr8Vs109zOL/1EN7dKlgnJKX2hTYW+h1T8GE6hzjBs2twGeAkrSnTPob171cKfWKsldJBPuA==
X-Received: by 2002:a5e:970a:0:b0:7c4:9ed9:8e7c with SMTP id w10-20020a5e970a000000b007c49ed98e7cmr3555583ioj.0.1708123426071;
        Fri, 16 Feb 2024 14:43:46 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c19-20020a6b4e13000000b007c47e7e549bsm181736iob.27.2024.02.16.14.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 14:43:45 -0800 (PST)
Message-ID: <e993344c-e9da-4263-8a03-075ddcaebdb8@kernel.dk>
Date: Fri, 16 Feb 2024 15:43:44 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.8 20240216
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>,
 Xiao Ni <xni@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <2D753D1A-F9A6-4196-88A3-91C7596C17DD@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2D753D1A-F9A6-4196-88A3-91C7596C17DD@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/24 1:13 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.8 on top of your 
> block-6.8 branch. The major changes in this set are:
> 
> 1. Fix issues reported for dm-raid [1], by Yu Kuai. Please note that 
>    this PR only contains the first half of the set [2]. We still need 
>    more fixes in dm and md code (the rest of the set, or alternative
>    fixes).
> 2. Fix active_io leak, by Yu Kuai. The fix was posted in the same set 
>    [2]. But it actually fixes a separate issue [3].  
> 
> I still hope to ship another fix for 6.8, which is discussed in [4], and 
> fixes bugzilla report [5]. For this fix, I would like to get review/ack
> from Yu Kuai and Li Nan. We will get this one queued ASAP. 

Pulled, thanks!

-- 
Jens Axboe

