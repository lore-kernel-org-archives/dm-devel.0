Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797BF128811
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713363614; cv=none; b=txk4Q1bPqDOlRNW+Fhai9+AWFdMdCtBPuGOeV2ECIXlJ1xk7xi76Ye3iqBnGtBEbMFz2KX4tAbz2CFoxiU2s2/NeZPNLZriTmLS8fe5TPbVE1Nf4hpDm9VOBJWtMAY2Tt6j4Fq17wL/TCQxHpavejZznOKoOmf/Hze5Nq9BcvdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713363614; c=relaxed/simple;
	bh=qV+sZe9J6QOdFH+HyvdCk29XqhUU/5ZAe3YBep7WUpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YWV2fYxNilnSyH/yNxDMBIMAwZZB6Ot2LAw9S/Lo6AhxEE3N79a3RLiwOczDOD0pSSc0yo9YN2T0IJdQ9leXmnjxPHDl7ABOXsknPcWybOESqYPKaDIScdFn/FfLjWQo4xwnboo/O7ihLCfNy3qEDyxa5AAoVe7ZuXOOLIaZ3YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RL0t9Qts; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RL0t9Qts"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d6b362115eso80479639f.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 07:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713363611; x=1713968411; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HmJ5eZJGxB1Hun1ep3UDJQ3ZjsSAsChxE6ejtia75oo=;
        b=RL0t9QtsbmPDVv4/u9f2WJiBJ/In5nAErN3PUdd4SFIfCwMcVYEsnFrkszpcDoOsPD
         60K++/pD+gMZ5QPaBdWEqEuAZqDAvSOzOKEZDHkapZA4itUo0aKCeK0BtNd4e6AL9osh
         iYrz36d8lfgfjoa5QCGgGUXOxXb4EkYwwYG0z/GyfItaC00fcI/gW3FFh/tV8qOz3inN
         sjAQoYLPqNL44u3kgPzJ3D2XwupZj/NxxvyytUuNCwEK36YOvxOwO+D8AFtYwJMePbnk
         MEzEFWIt9ognluJhDaxQzt5NfpiiYBj15Gh8vpe0fd11QbAoVMAvm/bd01oakv1riQrb
         PDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713363611; x=1713968411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HmJ5eZJGxB1Hun1ep3UDJQ3ZjsSAsChxE6ejtia75oo=;
        b=b6MUOaHUilGD5qqGT2QoDWJVp70VsTT79i4SrCeemf4sH/rBGn6PvKP7uhT9Mi+GYA
         UauJHBIGNfadVS9UroiKAf+o/HUZ7G3oqKtENiWsDFa+zckLWpl7DjLEk3dkixpgqIvC
         CYLmEtM+6Dr8GebrykyFgFq9Q53y6JnCgF4XGjCo1Q1oAys4TAimle7zgeGmOeHrtNP4
         zGPLI/ffj2oznFMMtmTgyS48ddOTanHYNBhf94YXXPj3j8YqVw4XkRxE/wlQBiRsMhvn
         bCRFZklyQcwYsvpUxqPLtAi4BuMpX/jDXzhhAMOkvnNc2wXTic0zCUGaKO2OJ0Idf9on
         pkfg==
X-Forwarded-Encrypted: i=1; AJvYcCXG443JpS+a4mKlzTv2HlRYoQrzu/4TSAAXmkK4pCD3p1xDuHTycIiqIQU4SrFuKaPtdWvOBO1p8kpTcllsv13YD7h3Ya8Togo=
X-Gm-Message-State: AOJu0YyBUiqRuDu4AP9TBCUwAXnOMllqaBltJAnhAMF3HOFgu+gQVR3f
	gCCI0L6UzNVv+fJnOxgLF8NAidaFRkwWXAL3yUP45rMcrAOHIupl1PYynN0I4G4=
X-Google-Smtp-Source: AGHT+IHtsCXR9G3n7aDlaLxkxPqb+SGPG4DBga0J3T70QmsEh45We5icSAo7F0CzW0bUzldcD1V8pw==
X-Received: by 2002:a5e:8d03:0:b0:7d9:4bfe:5ed1 with SMTP id m3-20020a5e8d03000000b007d94bfe5ed1mr10824580ioj.2.1713363611590;
        Wed, 17 Apr 2024 07:20:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dv2-20020a056638608200b00482f1e0662asm3245449jab.9.2024.04.17.07.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 07:20:11 -0700 (PDT)
Message-ID: <e86c972f-4acc-4b89-9872-b5f92606cfd9@kernel.dk>
Date: Wed, 17 Apr 2024 08:20:10 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dm-io: don't warn if flush takes too long time
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer
 <msnitzer@redhat.com>, Damien Le Moal <dlemoal@kernel.org>
Cc: Guangwu Zhang <guazhang@redhat.com>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org
References: <754d1973-31cb-d3ca-1f6f-2d35b96364db@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <754d1973-31cb-d3ca-1f6f-2d35b96364db@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/24 3:05 AM, Mikulas Patocka wrote:
> There was reported hang warning when using dm-integrity on the top of loop
> device on XFS on a rotational disk. The warning was triggered because
> flush on the loop device was too slow.
> 
> There's no easy way to reduce the latency, so I made a patch that shuts
> the warning up.
> 
> There's already a function blk_wait_io that avoids the hung task warning.
> This commit moves this function from block/blk.h to
> include/linux/completion.h, renames it to wait_for_completion_long_io
> (because it is not dependent on the block layer at all) and uses it in
> dm-io instead of wait_for_completion_io.

Change looks fine to me, but while at it, let's just move it into
blk-core.c and make it public, no need for this function to be a static
inline.

-- 
Jens Axboe

