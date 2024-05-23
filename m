Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687E3F9F5
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716487354; cv=none; b=pHBrMZ4DjEVQTPDKj1NuHo3zHk8BrqWb5plbuXdRnuVu7y3NeoF+brpKIxeP+j8bE6jQDi+cOGwmhe0icHqXpWC+iaq8zX4ZR8o5rDY3SSJ6K6DePN915jhGLh2fmRUhyltRyTbqxasGbG0CAMW08J567QD4Ey11a3eTwIaSAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716487354; c=relaxed/simple;
	bh=8u/HVbwKGKjv1d4NvsyoFcvc1mn5bKc3XWro9ywqZug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PAFegBqvJFvHkoM3Tu8xWxHlaNqh3vIipfNZKHGXZw9tZTauBXk/AEIjz7/IXw+OAg6cqCCrGnDuR9hFKTUdbrxXP1wB6bvhGMNwKt6abcNOxlst34eg5S8ecRc6hkkPh3XmiVTvPAICi/Ha5LkTj2wzXEhyqe1KrrDpZ++/kBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-794aa87af7cso2818585a.0
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 11:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716487351; x=1717092151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nW7/qXjjeCu7jMbcTNifvfQ6nV4FRka2a7rVFTLMdM=;
        b=vF9TSAeyDMGHODeM5HAqpV7NPeYqVZy4mhKhnYejf7BXGw7VJVcPaKyh0fEcKdv74N
         xPULWQPDdvyCcE8L77OUfj14hcMRFOGdc3z3Oz/BSvYTC44cPMTvdHLm8jen4fWMWZpn
         +suQXBjBsp9ADoMcVEnBxOAcXgL2j7NUCWc/1BdEa19UPgyrLjnuEDwLIOwn5qMoAwyd
         cai+NEHLb8T7WUfAyZbWq3E9uYyecIz8UzZMQfW7BcMFzo4Dpddh8ttVyZ3FEllZMqht
         N63MRR+t39TzHlafQjhv8W0IJ2YhoahA2+ozWFeqTQmGZXpShsmOQAGrbj4Qz/vAY8YY
         0lLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBz1gQX+WG1eOI5n/egep/AFECPd3wmPmTJslV5APbXTEZbbpaKBg2VJS2Yv0wa9Hqxgoq7P/9mKvA2MvoNTEbkFvrvmJamVk=
X-Gm-Message-State: AOJu0YyQrDvuyzQaDjA5wIJLbXv76dR41RioBxehPMA9R0xUuBgqWvVo
	tzLdJdhjZTFQnnIh0WwBMbRsjMOvvYUYQYD+/c7R3uP517paAs/EskxkTg0OynY=
X-Google-Smtp-Source: AGHT+IHsWlC/DlnDdzhRq0vc0RR21gS5wvf1ly0f4w3gZUrfWWz62i7ZyWmfQJf/fP7ehrSqDXo+UA==
X-Received: by 2002:a05:620a:cf8:b0:793:fdb:c9a with SMTP id af79cd13be357-794994115e3mr547613585a.6.1716487351141;
        Thu, 23 May 2024 11:02:31 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e2467c2ecsm132296991cf.72.2024.05.23.11.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 11:02:30 -0700 (PDT)
Date: Thu, 23 May 2024 14:02:29 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Yang Yang <yang.yang@vivo.com>, Alasdair Kergon <agk@redhat.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm: optimize flushes
Message-ID: <Zk-EtZE4C7bndEYn@kernel.org>
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com>
 <ZkTXzG1yrPmW64Z6@redhat.com>
 <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com>
 <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com>
 <Zk4Y6DMgK71UuoKd@kernel.org>
 <44afd6c8-d36a-4b9d-e77f-fca269a9897b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44afd6c8-d36a-4b9d-e77f-fca269a9897b@redhat.com>

On Thu, May 23, 2024 at 07:46:25PM +0200, Mikulas Patocka wrote:
> Hi
> 
> Here I'm resending the patch, with more comments and explanations added.
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Device mapper sends flush bios to all the targets and the targets send it
> to the underlying device. That may be inefficient, for example if a table
> contains 10 linear targets pointing to the same physical device, then
> device mapper would send 10 flush bios to that device - despite the fact
> that only one bio would be sufficient.
> 
> This commit optimizes the flush behavior. It introduces a per-target
> variable flush_bypasses_map - it is set when the target supports flush
> optimization - currently, the dm-linear and dm-stripe targets support it.
> When all the targets in a table have flush_bypasses_map,
> flush_bypasses_map on the table is set. __send_empty_flush tests if the
> table has flush_bypasses_map - and if it has, no flush bios are sent to
> the targets via the "map" method and the list dm_table->devices is
> iterated and the flush bios are sent to each member of the list.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Suggested-by: Yang Yang <yang.yang@vivo.com>

Nicely done, please feel free to stage for 6.11 (create a new
'dm-6.11' branch starting from 'dm-6.10' -- we'll need to rebase
dm-6.11 to 6.10-rc2 or so but at least we'll get this commit in the
pipeline, push to 'for-next').

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
