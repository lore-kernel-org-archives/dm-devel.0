Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B3D12C819
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713372964; cv=none; b=qGjZJKavcbgQFhOkyNVfoOEzK3nsup2dNB4/g04RdgM635njODKw8HB5zBA60ki2BGIEXowOqM2+1Ahn+pdc2ro+qw01tnPe94uYlq8AGm/PzCpI6gXzkUuQtSDsuoXupjcUl3fLLGgWL3rbTZAISjKfde1wQ1i2dpd+w/DEWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713372964; c=relaxed/simple;
	bh=NVzcN5A1MDUCRNGN1j82k+y9l46oc2GyJO6/C/mgrHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHrrGaCcRUJbKGvzsM0uL84xXrvGqlYwjN63hADWEq8YVTUbz0cg1Yha95uknyykM7Bwivv5bxnTgoQt9fqkPnTwtB1lu3QO4k6xo6/6sQPtmixKCGNlrJFHfoA4JeKC3k0SdqrTFrpJn3dmuTuxk4vfow/in+ma6iNQUX9w8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=se1C95/I; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="se1C95/I"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7d9c78d7f98so12653339f.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713372961; x=1713977761; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xUAHB5bPJ+iDHtRK1ERMDUYx1czMuNi349CzQq6TWhk=;
        b=se1C95/I7C5nDVeYWBBEASuXaBDrPNGy2OUbiQReKC3/FWKlFnmdaJXFJZi1fvXG8H
         2JBhbMqrtIgTM1+rqBclXHK76yeaGlyHqJ5rBo0wRW36bqAaxCGf5+ZLb2DCEDyYa9L3
         xd4OE0In0z7Zdn5s6qA5cezwx4gKyVPjfFDEzzKmQows1avGPUHdzUEcG3mqxSLF4rgv
         pzoe2M6EWgoRsUSnbZJvpiDKkWPsgmOxxxT9G0MG3tT0pZQd1/G7U3Ztl3z+CgnoSLPj
         8KgfZC+ANp8MpGgBIfKbSrenj+/uoCo+gTTuqQvlS5hYqPmahgsL10MHGcHGSlsoDB1W
         x8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713372961; x=1713977761;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xUAHB5bPJ+iDHtRK1ERMDUYx1czMuNi349CzQq6TWhk=;
        b=vWwYeVioT7C+qsb3cJrz52aXPhvr2vzZny6L2sb639QjIvtCKsro7vLu9cDNnMfDS0
         W8qPi595yJOk7PueFMgBhUTwlxomqVD4XyQjmfKKS8LUPy1hfr+7J/7TTgtRXvSGxQ8F
         /rwemyZnT3/DxQCGlQrhgZm0djydewWnT7hYZTLdPQZ9fbIrO3FCggxPHWHz0qsVKFR7
         eOx30N3ZRXk2ZcndbZR8zwOIZpwAKROprL1Y31IzHl7zx8BiJQoUhHlBsKBZdm5vvQaO
         H+85Tgwz3oBDqmjldIpYVZjZ12OBys3BY51aWDi/SSPkWcDYfhiy5pIZmQXM1+r5FVRo
         kMsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRnYRGowTmoq6sbkf8nSLY4waEpc2EgKg6nicozq9UZaPYhoMwmE6RFlCjWeEIokh9BbeHmIqEcUe0OzJLq0xWc8nTqdHcHHw=
X-Gm-Message-State: AOJu0YyBhnS5MBUwpRS8y70AdKULPlvZQujSj7tY2E9YfleU9mSNmZra
	h7t3xoBdCvDtA63YF8DSS6eaNBeNBQ+CiJ4//GORwOX6xmRrzQG6xyVNnRjVz7M=
X-Google-Smtp-Source: AGHT+IEq1tXs6bVu+t+KS2pPXVs3KAV+KvjBYxSJrIs1bc6wfc93/z+DAVpdNKnzJU21HV/Z+81VKQ==
X-Received: by 2002:a5e:c907:0:b0:7d6:a792:3e32 with SMTP id z7-20020a5ec907000000b007d6a7923e32mr241839iol.1.1713372960935;
        Wed, 17 Apr 2024 09:56:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dq3-20020a0566021b8300b007d5ebc40f82sm4010155iob.31.2024.04.17.09.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 09:56:00 -0700 (PDT)
Message-ID: <e843abe1-0561-4ee7-a73e-4ffd407d523e@kernel.dk>
Date: Wed, 17 Apr 2024 10:55:59 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] dm-io: don't warn if flush takes too long time
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer
 <msnitzer@redhat.com>, Damien Le Moal <dlemoal@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>
Cc: Guangwu Zhang <guazhang@redhat.com>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65c83995-1db-87ff-17df-20c43c1b74d7@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <65c83995-1db-87ff-17df-20c43c1b74d7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/24 10:51 AM, Mikulas Patocka wrote:
> There was reported hang warning when using dm-integrity on the top of loop
> device on XFS on a rotational disk. The warning was triggered because
> flush on the loop device was too slow.
> 
> There's no easy way to reduce the latency, so I made a patch that shuts
> the warning up.
> 
> There's already a function blk_wait_io that avoids the hung task warning.
> This commit moves this function from block/blk.h to
> kernel/sched/completion.c, renames it to wait_for_completion_long_io
> (because it is not dependent on the block layer at all) and uses it in
> dm-io instead of wait_for_completion_io.

Looks good to me, though I'd probably split out that dm change as it's a
new addition where the other parts are strictly mechanical (moving the
helper to where it belongs, and using it where we already do it).

-- 
Jens Axboe

