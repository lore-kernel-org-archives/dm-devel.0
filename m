Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7542F34
	for <dm-devel@lists.linux.dev>; Sun, 13 Oct 2024 23:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728862034; cv=none; b=l1HiYE7aKIC0BSftyoJSHAvzsnvQdmY+GDx3mwO/Lt15+gTYerKluW57hKr7OdsgMO2ipnndBQKKaZe/u+U5O+XiNgcbe6beBx1cpk5SYttohuDPB9O8TE2vDDnlPJiBDbuPO0L2Jt2cUo6AT/ShmSHO/m1hjRJStj7acxE3kbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728862034; c=relaxed/simple;
	bh=x1AeHO6z+Gq3K+5u3Vu6K8cR4pygOM5cB68LNibQ02Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5Eo+ojFYaMG6u0qCrD19S6g396FFIJJmobgMsQ8orehN9dmD7Iw0Uqp64Wa4V4odKNnTinW2WMpgVTcvEWWF3FIye6MenZXhh1ht5uEh11Ua8BeXGIwWb00zpOav5bBNgVTgF6DEkfi+CApKt8YRo0NSRGgK6QVwh5p/RCjjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CHcJRsHZ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHcJRsHZ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20c7ee8fe6bso25612675ad.2
        for <dm-devel@lists.linux.dev>; Sun, 13 Oct 2024 16:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728862032; x=1729466832; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2rSKa9+mEkifyzS0w5ryHoMsoCNMgNahi+iBN2veXQ=;
        b=CHcJRsHZrGPMa+upQNxB/TxnULu2Gam08Xv08KAbQZZFzCnuMNHnBqJzq+Gec0hL+Y
         niS6XqKLf5eshgdFa8DR2cVrqPYPuvj5tkuPphqGTQ8DbABwD7anKqFT7/9iJREfAmFW
         LPk9An9qZMlW/GtIEmyRhOsr+ZkqV/UGtiIbM6dGfuW5RcZB/MK2VjU++nj0i+oBfGRI
         ONCq40ChMvT54ZClELQJ19Y4O/Pqo97yh2qEHW2qpgYPbihnyXFpl9N7mnkg4LZtDk1v
         23WZmLM6xFPjnxrHFIYjwSMEZapDOMnYb3T5fkOG0IoFX+eDbhYtM4Jc3HvmlYnKPeg/
         z9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728862032; x=1729466832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2rSKa9+mEkifyzS0w5ryHoMsoCNMgNahi+iBN2veXQ=;
        b=GXGoT9jm37IPYIH1yU8NT9VENT68TYsBco7s25h73Pyx2rX84tRagyugTHf5ohIpZJ
         WMBvHxJgd78mpRKw+nSqz/PInKlvPh4LH/2RHfyxhdvhpKSeJlA7iOFKB4Sie5luB4kU
         OmeYHg44vkMBmayrH4IYpCkUllF3xzGhnuqLWR9DBxwGcr5X/JYxFrwet1FLV3T7I5J7
         5r3iSVRX0pstlK2d7+fP4JIASivIZOQtKWXN8bvLPAyeI8hOpOTxFDH1i387QR6hPaay
         2tazsCtT2rPiiXVCbb39/ZfitFub+SkC6RrAgylCPlBNq+E2LEYi8Qamalopy4EGOrWx
         AU6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCKSGQeRf5nliaS5CLHOAegLUHGuWp6pk6ZiwP6S5yrYH1dhBWIYU1bCW8LQMe5CMdU88zp9Y/Iw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyt0CcCTzaTo5r3PrBN9qTXC0rwcungi58BtPQOSSut29/h6gFN
	ZOaVeQxAr1dtRnd7fENXgiJ1jVSOflNah5RZQ/LR82rHv/fN50/1
X-Google-Smtp-Source: AGHT+IG9csZOuoI5wdgjpNu6THb+F7nhX6QQINmEa+/VhE4rnsfyxwCbx3kULQGZMbNsshtxsBWiGA==
X-Received: by 2002:a17:902:d4cb:b0:20c:e2ff:4a50 with SMTP id d9443c01a7336-20ce2ff4c5bmr44129945ad.9.1728862031943;
        Sun, 13 Oct 2024 16:27:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c312133sm55177455ad.197.2024.10.13.16.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 16:27:11 -0700 (PDT)
Date: Mon, 14 Oct 2024 07:27:06 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, corbet@lwn.net, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] Enhance min heap API with non-inline functions and
 optimizations
Message-ID: <ZwxXSje3n6lMTbjj@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>

On Sun, Oct 13, 2024 at 07:05:38PM -0400, Kent Overstreet wrote:
> On Mon, Oct 14, 2024 at 02:47:00AM GMT, Kuan-Wei Chiu wrote:
> > Add non-inline versions of the min heap API functions in lib/min_heap.c
> > and updates all users outside of kernel/events/core.c to use these
> > non-inline versions. Additionally, it micro-optimizes the efficiency of
> > the min heap by pre-scaling the counter, following the same approach as
> > in lib/sort.c. Documentation for the min heap API has also been added
> > to the core-api section.
> 
> Nice, has it been tested - do you need a CI account?
> 
> I'd like to start seeing links to CI results in patch postings (and I
> need to tweak the CI to add git fetch links, as well).
>
It would be nice to have a CI account to test my patches. Is there any
guide available on how to use it?

Regards,
Kuan-Wei

> Coly, there's ktest tests for bcache that need to be updated - if you
> wanted to take that on it'd be lovely to consolidate how our subsystems
> are getting tested; I can give you a CI account as well.
> 
> > 
> > Regards,
> > Kuan-Wei
> > 
> > Kuan-Wei Chiu (3):
> >   lib/min_heap: Introduce non-inline versions of min heap API functions
> >   lib min_heap: Optimize min heap by prescaling counters for better
> >     performance
> >   Documentation/core-api: Add min heap API introduction
> > 
> >  Documentation/core-api/index.rst    |   1 +
> >  Documentation/core-api/min_heap.rst | 291 ++++++++++++++++++++++++++++
> >  drivers/md/bcache/Kconfig           |   1 +
> >  drivers/md/dm-vdo/Kconfig           |   1 +
> >  fs/bcachefs/Kconfig                 |   1 +
> >  include/linux/min_heap.h            | 202 ++++++++++++-------
> >  kernel/events/core.c                |   6 +-
> >  lib/Kconfig                         |   3 +
> >  lib/Kconfig.debug                   |   1 +
> >  lib/Makefile                        |   1 +
> >  lib/min_heap.c                      |  70 +++++++
> >  11 files changed, 508 insertions(+), 70 deletions(-)
> >  create mode 100644 Documentation/core-api/min_heap.rst
> >  create mode 100644 lib/min_heap.c
> 
