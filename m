Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB1D38DD3
	for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729946677; cv=none; b=NfNy3YCzYT/jVfJpofOPJQQ6ov60lS5u08UToag6+qXlPh6Kw0ugpCAugr+ihpvJ4SMcmUMJAUJT3VHa1oXHBP5C5MvAj/BDbb/No6uyl/r5aXfF6Y0jqJMCBprDPOETsOQ6clNU6NbLbRb4uTvA6Amx7XgA9Azu8v7QECs3yXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729946677; c=relaxed/simple;
	bh=hlYMxGuvPb703Lut6KKMmkeksJOnNiX3d4CG1prtUWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVqpUqVJQSRoz9Oe/eMeYJ6YrYyXflyrg4LHQuCd9BKwC4Gijs4HdNXjcwr9TZeueaPS/oGUd7zpz0Qx5m8y7aNeNvI52nJ/9rDgCTmnD42COJObU2GyfuCnIFU+1MdeebWl5NxpBDJxXRxkyHFbgGQMSVKRRXkWdGMyBsTEY38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mnnrCnKQ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnnrCnKQ"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e3fca72a41so2300856a91.1
        for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 05:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729946674; x=1730551474; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hlYMxGuvPb703Lut6KKMmkeksJOnNiX3d4CG1prtUWA=;
        b=mnnrCnKQLGo8Y5jF7NK3ebz76nuRiU4aiqqSgKWuTsdOfYqe+qlfnWG9mjtvoF4qc2
         2kTIquFo1CqbspxL2r/k9RIrf9+aFsqJE1GNTBvXACMOICFbGdeLCFyw5wOqci1v8jLg
         scHUVD3cL+JSLkZHAkI/2twaaczd/9cJCS9oUzCllqTdMgl4lkhO+JtAFLfM7Fl3Qc7j
         JZnOsWebpQLjkE0uSTs1W4Qw+vVKLCwBedVUdlLY1zcniKZ5xRr+UtW2KnorPRuz5/aY
         mZ+6sfHWNaQjzh1fdo0hnxc+VCcq8ok35RTGxcUbKMWGXR9fFgvRqQxg353lrxcbliy2
         AXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729946674; x=1730551474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hlYMxGuvPb703Lut6KKMmkeksJOnNiX3d4CG1prtUWA=;
        b=wT2kH36qOfauO6vdAJM9BuNRT9CIADaqWStDTbWKiHk5eHWCBlfc/sYFNXpaGdFo+M
         ZpbZZxqAmt3Dd28l5TLiyhglsWWv56q4EfTpUZ4OSUqpHiNxcg667sqSTr7QF4FyLh0g
         Zmwl8OWV4T/GAFFj7I9eDZ63Yyk11lhGxQDZwI2/5kO+QlWHpZVz5s9wkj3NzlPzf2Jv
         01axl45cMpyeXtgiTPD+KGSpTqvJpWc3imL0dHH3Wc/yJqsuimFSwgPQ4wrEv9yLfQPa
         LVjBZwuvzWphpZwEhd1cfYUcLJYq2gSxVsG6mMvFvAVke6CzTuIeXMewTKO3dj8qms2l
         1TuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZtT4Y0T4Dwa3Uoznyzn8nyUBeeJvYqbtmSRis/Bir9b5rFH7ohVc/DLg2txriaDAqjuo0TA6NNA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx84fb6AnELnT+FODH2Moza4/QujWMsJ6txOCmu/vGfJG9FAY0Y
	g591uhAPWBEVBMxPwv0KIy9kjZJakt6woao3l8OimnDLojemg8WR
X-Google-Smtp-Source: AGHT+IG5ZhDGETx6o3Y/ScrrP5AVxts1TmCd+x6OU8AF59dnaIuGpNAB6tw4k+6hqYITHYo+ZCSzTA==
X-Received: by 2002:a17:90b:1c07:b0:2e7:89df:858c with SMTP id 98e67ed59e1d1-2e8f0f52f70mr2797590a91.6.1729946674353;
        Sat, 26 Oct 2024 05:44:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e5a4ec4sm5396093a91.54.2024.10.26.05.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 05:44:33 -0700 (PDT)
Date: Sat, 26 Oct 2024 20:44:28 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: kent.overstreet@linux.dev
Cc: mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org, colyli@suse.de, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <ZxzkLJmhn3a/1ALQ@visitorckw-System-Product-Name>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>

On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> Add non-inline versions of the min heap API functions in lib/min_heap.c
> and updates all users outside of kernel/events/core.c to use these
> non-inline versions. To mitigate the performance impact of indirect
> function calls caused by the non-inline versions of the swap and
> compare functions, a builtin swap has been introduced that swaps
> elements based on their size. Additionally, it micro-optimizes the
> efficiency of the min heap by pre-scaling the counter, following the
> same approach as in lib/sort.c. Documentation for the min heap API has
> also been added to the core-api section.
>
Hi Kent,

FWIW, here are the bcachefs CI test results for this patch series:
https://evilpiepirate.org/~testdashboard/ci?user=visitorckw&branch=min-heap-update

Regards,
Kuan-Wei
