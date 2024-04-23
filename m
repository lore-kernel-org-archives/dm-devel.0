Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC5D58AA1
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 09:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713864932; cv=none; b=T7s+DY1OhOeulaD9KTRbWTqxuhf4IYflj70FAyjQKmrZDMuDfzV7YkhRqKp+JnCUDiICFhcXaOSxuHm4xnHd0JM5hFxhf7SzKhHUjrz7rtNyqTaxWZRbO06/GhOaA6JpXvagCvWwOJyltxe+J9Lnw/gGBhhTey9zGyd1QHQN7NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713864932; c=relaxed/simple;
	bh=lmZDN1auKETKyKSuC5BzhmI7ealw0CEjcswaHx2FnzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=el5jssRY2r/vv7fdYaPhQnEgA3LlBZsZ1ZNzW59iI0ymdkRhEQyzJ4IsdULQXOGj549E0L6odZYOR2ZsZAPbHHotIyjR2fQ0fn0m+adXwPsOADSUOp6/Shhet43AaFCPn8cD+vasr8jw4xlfR/fWYMI6jzf7m4kWlzXbqaSJ41g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BT0woiPN; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BT0woiPN"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ae3afb81d8so332709a91.0
        for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 02:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713864930; x=1714469730; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oPmiyJcchVI8HLZhgn5CHh5M2cAjQnCFOUQBbNrRH7o=;
        b=BT0woiPNFuy2xDD74HsIjkmawaXNz5c7trIiesMAAVr3Isfgd6T6F0LFs7e+Gc8JSk
         p+4PNOfBt5KFBORiQJ06HQAFBg/g45mO6nHCL43LJ56aw5FylImgimJvWbNNc3xiBcJB
         KF7pQl7GA25rxVjlXz5v98kemlgmMba0w1TpUAm+WfkqxKmCerwkRe7jXNRYq19gibE6
         TCYFL6LVfWRV1yssYsTdu4NZPbROXbjKV7hZXV+3BFPfM/t+Tdr1jRwYJaV5LWrNKh/h
         8nc0mjlLjbNlZXxuLU2WI+aWpmyWGVnXLEcYJ7Jeeb/fLTog9EygVTywPJeqZ5ZLYhcc
         iuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713864930; x=1714469730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPmiyJcchVI8HLZhgn5CHh5M2cAjQnCFOUQBbNrRH7o=;
        b=KFBmfv2UOuH9cWyfEv7a4b/2mR0jzS8Pod8n2jhCP0RD5nCabzNQVRIupDkKaMbpFb
         YB5+LKzpd+edVMXyPkj0ssb3JzEI+V8EYSrrdpPT++ooP5hehnHIPhjZY56L+qKauwnK
         743/BkGn6vmRlaAoTZ54PYObSpuMBzK/GBR+olF2592xPuqkXe8f11CA8rNsZxIZ2yyK
         +bsCSG6VE0oZWNYQnNlfDdyLOWznI98c7iOLlLWH1oBFQ8XRhulMa+t3MMtywJsSGTXl
         BIg/2z4TOHVkxM2R4egrxPYLSN0rA1lqtLQjMytD3zCxcYrQcw51zlfn7qSHQzJMm/Qz
         b6jA==
X-Forwarded-Encrypted: i=1; AJvYcCWv8y8wi3P0yb2pcPubHwTeneP81dCjkElaGTGX1LW/st32siNkCWAxbb5XWlYLVwvfOZ+9JQYl7na3VREoBSA1zzROev9uKgs=
X-Gm-Message-State: AOJu0Yw9+aoj8hlTdH9nhFKlyFl9tCX0+tFk1ArG7ZSpLNQLxTJKchTB
	GCYJmtuVaJ79f0q2J+Zv5X4ok7mqjbzFACz5EzfDwZbykOUR0scu
X-Google-Smtp-Source: AGHT+IFareQ3oNnnfoiJvzFkOIOjDeBgcWDV4pURl0CaslgJ7AnZPPu6SxQPxRszdJm0n18LAg9KWw==
X-Received: by 2002:aa7:838f:0:b0:6f0:6d93:2089 with SMTP id u15-20020aa7838f000000b006f06d932089mr15098329pfm.1.1713864930443;
        Tue, 23 Apr 2024 02:35:30 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id fq5-20020a056a0060c500b006ed2709ada6sm9204624pfb.65.2024.04.23.02.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 02:35:28 -0700 (PDT)
Date: Tue, 23 Apr 2024 17:35:21 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 00/17] treewide: Refactor heap related implementation
Message-ID: <ZieA2aabHr7vF2a4@visitorckw-System-Product-Name>
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <asgiyolfhg2sfwarkrexbcx3y6mborcxklnncz4cn2g6ffubku@vhoumzvwdpzp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asgiyolfhg2sfwarkrexbcx3y6mborcxklnncz4cn2g6ffubku@vhoumzvwdpzp>

On Mon, Apr 22, 2024 at 04:20:28PM -0400, Kent Overstreet wrote:
> On Sun, Apr 07, 2024 at 12:47:10AM +0800, Kuan-Wei Chiu wrote:
> > This patch series focuses on several adjustments related to heap
> > implementation. Firstly, a type-safe interface has been added to the
> > min_heap, along with the introduction of several new functions to
> > enhance its functionality. Additionally, the heap implementation for
> > bcache and bcachefs has been replaced with the generic min_heap
> > implementation from include/linux. Furthermore, several typos have been
> > corrected.
> > 
> > Previous discussion with Kent Overstreet:
> > https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
> > 
> > Regards,
> > Kuan-Wei
> 
> We need to get this into -next, where are you at with v4?

Apologies for the delay; I've just returned from a long trip to Seattle
where I attended the Open Source Summit. After reviewing the bcachefs
CI testing results for v3, it appears that my patch has caused some
Kernel panic and soft lockup issues in bcachefs. However, I haven't
been able to reproduce these problems in my qemu testing environment,
so I'm unsure where I went wrong to cause these errors.

Regards,
Kuan-Wei

