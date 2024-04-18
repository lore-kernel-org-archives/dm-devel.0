Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765B2165FDF
	for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452952; cv=none; b=h3uNeWAzUt0qccCf2TRrskTHebkakBQO2qOzw9KSXEzLMxrPDwT4r+fcQWzt0PM3uJ5/C7Y5SUW4EABjPE5vk4XmURpJ0Yim0AASo39s/tXxqLRzhPyjzQeEF4knEiGQdVZ9cT1c5NJe/pbhermtMJDg4W/owbwepSOtncdFByY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452952; c=relaxed/simple;
	bh=k+6r0GGg1vUggBFS1HFE+EGyXIm1V66bbTL8/78gpIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tWO2oHltiCCvYjADwAT8PqunQeYV1/NOE+buCWiPELR/ImPXRryICqLb5hNkY3JE4eF8dN5z/nZJwP7IlcqtR5O7e1GEYPnYwlml490LD4bXxJ3k/20tRJgd7nBEr2xkWfYDWbhzS/dbFJW6uhoqg0FvekccWeQVKc22a+js2TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H4UnNQ8v; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H4UnNQ8v"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5f0a485dab9so59157a12.1
        for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 08:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713452950; x=1714057750; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p9O3FV94jh7vQc95L9k9nvefdNDVfaT9ibGX8CYdkE0=;
        b=H4UnNQ8vpHrb00hFek7iHtPW/6x++jIEgfQPAcBd4cEYgUN30QgX6P2hfxuL/tAej9
         2CvQD86Mj4WUgxHacuStrpSCvvVfT6SxQ3w1g+5EeU9FCUWPhWNTGWv9pF+ous6TFydE
         Xq0Zhvxv9jVLwQAxtXqioF3nppPzZNzaBmriOxQB7f62PYmhlgEj+LkpdM5UAWd+dWwp
         4fbEOfCHQIMcA/6th2vicrCuB24SMn/cIg5sZsDpHUCYxvCwmeVx0K/Z9xwt0n0Tz+Li
         nW7gFz2N5Q/zaMbe9KJVss1xrMYnz1ZnCSE891DySPws5bHk5E4vxh0gaQquHvHZp7vO
         NkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713452950; x=1714057750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9O3FV94jh7vQc95L9k9nvefdNDVfaT9ibGX8CYdkE0=;
        b=NfTjbkxOWFZadJ7RiAW7hlFLet0t4ZJOKHO2PXghkurCfbN9BkI20nYYFXXaWWQ5aO
         HrDQF/ZsShKwFWwUr8OF1RL1Z4+upOCON/B4svzeT4zRE130h5lyvq4c0y/MidUoleT0
         Z/50p43mjnsm6vgC2EJq3Y5JKLM6lfknNvmoQifx8qIOULTEHEwmA2jqZvxSolEgbO7t
         61xDVb6DHxackO0PwPhvpLJMaYAEdHqBDQzSzfDVy6kaGWtK+JUji7yVbvo2H446DHqk
         ei3jVBC2aVWvJ4/qERRX2MGlEVt7yuFBgdXh2BDTgzvvUTKnTBaJNLFMg5zMwasqK9Na
         Locg==
X-Forwarded-Encrypted: i=1; AJvYcCUktY0pBJLZisgBxZ+6qNiulAOsFGY1PTg3AHGqc0coxj27daan0Agb30WG1pId7nl6V8MdCJ6lGK8MxeCcfoUb7dqR5F3JgTo=
X-Gm-Message-State: AOJu0YzXjYeDJbMj5kCqKVClufDG2PBZgcfF4Q1tmaRQOJqkfglNLFT5
	bPzERP1nVyCjC13vP/h0KnfnD9o3aKacNmDouf3PgAudCNtJvwDC3BE15K6eEiA=
X-Google-Smtp-Source: AGHT+IEpDI3SLb6DK8eESf91mbfRxTkqd15fvUPDNtPee/hawli5VCPVwcKmvtkaX2PmBdDDW5btOg==
X-Received: by 2002:a17:90a:7e0e:b0:2a3:be48:23f3 with SMTP id i14-20020a17090a7e0e00b002a3be4823f3mr2885933pjl.4.1713452949760;
        Thu, 18 Apr 2024 08:09:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090aa11600b002ab664e5e17sm1547775pjp.1.2024.04.18.08.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Apr 2024 08:09:09 -0700 (PDT)
Message-ID: <362c3c63-6fd9-401c-9281-e2e0c7efc14a@kernel.dk>
Date: Thu, 18 Apr 2024 09:09:07 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] completion: move blk_wait_io to
 kernel/sched/completion.c
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Mike Snitzer <msnitzer@redhat.com>,
 Damien Le Moal <dlemoal@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
 Guangwu Zhang <guazhang@redhat.com>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <31b118f3-bc8d-b18b-c4b9-e57d74a73f@redhat.com>
 <20240417175538.GP40213@noisy.programming.kicks-ass.net>
 <546473fd-ca4b-3c64-349d-cc739088b748@redhat.com>
 <ZiCoIHFLAzCva2lU@infradead.org>
 <5f3d434b-e05c-445f-bee5-2bb1f11a5946@kernel.dk>
 <ZiEyLvL6Pq_RB-Eh@infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZiEyLvL6Pq_RB-Eh@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/24 8:46 AM, Christoph Hellwig wrote:
> On Thu, Apr 18, 2024 at 08:30:14AM -0600, Jens Axboe wrote:
>> It certainly is a hack/work-around, but unless there are a lot more that
>> should be using something like this, I don't think adding extra core
>> complexity in terms of a special task state (or per-task flag, at least
>> that would be easier) is really warranted.
> 
> Basically any kernel thread doing on-demand work has the same problem.
> It just has an easier workaround hack, as the kernel threads can simply
> claim to do an interruptible sleep to not trigger the softlockup
> warnings.

A kernel thread can just use TASK_INTERRUPTIBLE, as it doesn't take
signals anyway. But yeah, I guess you could view that as a work-around
as well.

Outside of that, mostly only a block problem, where our sleep is always
uninterruptible. Unless there are similar hacks elsewhere in the kernel
that I'm not aware of?

-- 
Jens Axboe

