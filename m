Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDACA6B
	for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518473; cv=none; b=iLrD8YcNq2JtO0gZDW9jYVdAd2736/d/lamg/DxqOXXgFR6PF1yV/xyunqBCgLr4+34NK46XYz96Em+vzK7cez6gbbVu3dpTtIbuuU7E1w7ugXTCGzfaiRXYEEOOKxRILJv0Bp874SSQ5URGqp5dbHVJmadQfDgHByGiqm7c9fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518473; c=relaxed/simple;
	bh=aUw4WJZmdSfNhxDFuiH2LCXSrIkyodmCvTqA3zgVJps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSnMtweLlFMvSA1a9+3bJDpB7fNlI6gOeqw7I5/Itf5eiUG74pJNxYMuQNsg4eI5tYvcq4v8npxp5K1TXoqF8o9lV96p3ji28kzdEiHn4559bmiMQyGy8ya/GzvSDcZHO+qxnYDnsGKT7mGL71dvaNnjH/lE4ccEmZmyHZ8nVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2+44pRm; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2+44pRm"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20c7ee8fe6bso42293805ad.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 06:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729518471; x=1730123271; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nD+KqOyffsNNyL4338nxmJl3FPWZED5MQGf79DLqDV4=;
        b=g2+44pRmi+E+h9GIejj2Na8YWCbvHk1Q4WyMdfRlqHzF+WBjnSOG/A3++RvLwS6x64
         ON1KN/19QtqNcYahSvmLK+BSl3FKRSS5l08g/Vfgi2oAASlQcvy/6Xm41sy3qgvdm6ak
         YcSgLZeWZc0eMGg6t4GmIH8gL32+kT4hKa2wMY41J5fvriN6qQVggEWZSWiWFmV4St2j
         6fzsimlQJyut6scHjJRwhcyBpV/2NgYH6fAb8wU3XWlAxf6/0bpnHjBDSHXniRAq0YDq
         hMaKPZxBDxhpOpk3JeFcnhdNgoSAtR1BryyYe6sqXaikqSq4o7czRX5BjTptP9E8Vc6m
         aDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729518471; x=1730123271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nD+KqOyffsNNyL4338nxmJl3FPWZED5MQGf79DLqDV4=;
        b=nGriNNttx9dgPI0i8+SsdzJ9t2AuAdd/5sXvDovlFXy/wuL3B5KChW6hzyz7Zq9Qsf
         3EVDSAWLWE8Ei4iU8bwKXvNCkrjtBKDTL6IggnHqUWrqftrOuT+MXsxvvzZEJPc4hDkg
         F/rPim1C8Fqxz299XYtus+fQv+Pk6b8igLwS/GdqGUF6LLVQwY0YJzkE6d1zVdR6woLd
         RE6+m8ptI5dsG0h0b32pIwGWtfDK8wTRAMHzgpVMa4JNkJ90RUvGDtKa492Tlx4tdjnS
         5g1b3Rf51EXcoxshPufgN0fGIfeQtwrsA2cgs4TyMJGguCM18OWkonwkm9Ao8dCfZaFU
         nUJA==
X-Forwarded-Encrypted: i=1; AJvYcCU3hd1hDBFT+W3Wz01u5C3QwhWTTiUadGUXaYvtgg6lxkF5Lzt+x+yXpEjyMxgrBU+u5yEZQVUyEw==@lists.linux.dev
X-Gm-Message-State: AOJu0YybGaRQxz/UcIW9SV5HXDaqXNVNiz/MVtV1AbdpVgsdk11C5Mu/
	waqs0izaioNa9oHKKzmm4fh+x2wFlxApQcC9oZDcHEqIfT+7gZAG
X-Google-Smtp-Source: AGHT+IGpQioQQSjVna+u0kcFMLLDGy8gnz92x4raQ8iP4uL9jWeq86xdAWB9VASoS23M74pBaQs88w==
X-Received: by 2002:a17:902:ec83:b0:20b:9f8c:e9de with SMTP id d9443c01a7336-20e5a7529f1mr179366035ad.13.1729518471094;
        Mon, 21 Oct 2024 06:47:51 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0bd2b8sm25853735ad.159.2024.10.21.06.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 06:47:50 -0700 (PDT)
Date: Mon, 21 Oct 2024 21:47:45 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <ZxZbgWc2IsztAOOx@visitorckw-System-Product-Name>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <ZxYf8VvQIZv9_Y1j@archie.me>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxYf8VvQIZv9_Y1j@archie.me>

On Mon, Oct 21, 2024 at 04:33:37PM +0700, Bagas Sanjaya wrote:
> On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> > Add non-inline versions of the min heap API functions in lib/min_heap.c
> > and updates all users outside of kernel/events/core.c to use these
> > non-inline versions. To mitigate the performance impact of indirect
> > function calls caused by the non-inline versions of the swap and
> > compare functions, a builtin swap has been introduced that swaps
> > elements based on their size. Additionally, it micro-optimizes the
> > efficiency of the min heap by pre-scaling the counter, following the
> > same approach as in lib/sort.c. Documentation for the min heap API has
> > also been added to the core-api section.
> 
> What tree (and commit) this series is based on?
> 
> Confused...
> 
This patchset is based on Linus' tree, commit 715ca9dd687f ("Merge tag
'io_uring-6.12-20241019' of git://git.kernel.dk/linux"). Since it
touches multiple subsystems, I'm not entirely sure which tree I should
base it on. Should it be linux-next, perhaps?

Regards,
Kuan-Wei

