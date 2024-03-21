Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314C381AA
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 07:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711005220; cv=none; b=uZVUC1QHqH+KkbUJdoBHH8gqAHJhATe0cOVnJZvWPXSVb0046ZnIyYGD2o3aLKJYM/4zQBpvTD/KJ+hQMXPBuMW+1ll9lYDeJscipnJYI3vhEqUerpOs+ie5IkvTYHf3yV5OUQAsawMJp8KPjn/pT6hafiR/DNWWTB6uOcJu3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711005220; c=relaxed/simple;
	bh=44fOfPf5fU3d/qtrVfcQjK72mdFuP0xwwcj4hJus11M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+E1IBbEs1OCNKTENDYk6OZUrNspi0kso6Hdr+myakSEWFnTj5AIiKJXLjZKl4O/lSFhw+qKR2skvAFOEkmZG9gPDHL7XefR+kta+OxO3aqosVwrvLFnfA/k8tV+3D1KorvmclzfAP3mkMjMaDbWDh5yz8ViGieWL85jaLVMrOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahQQS5xx; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahQQS5xx"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a47680a806so189119eaf.0
        for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 00:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711005217; x=1711610017; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cdehVXsBNnGNu7JIAl0Q10r3P3hbg+hd7rOHH7Isw/s=;
        b=ahQQS5xx9Q9/WqQVvwQnafcwW0gY0B/goLFQ0V5jBtInf4RAi1XIlmPUiRWbPEAVo4
         sXqd8cdbpHs9bs+DVP+fmpTteYNUJnnNOxkM9XV0O6qcCXirZNFNpB1pKj5ZnhhlUj3i
         yJmGMcB7gHbjWmTSdPYMyGhQMyVBUN/p809yxNdGfiEzthZ6wNj/YwBEDtRnv/e/mrJ2
         T0qOXyY2PN6DFCTwVR9zac/4mNR+aKwQMR//7SY8zBPMuKytr2MIYo2gSocNSst//hiM
         ytm67pN7ersEmYDR9o/lXICV753R9T0H/moLRTnFuGunsFElAfo9GHc7+uAvAd0D/Zy9
         gqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711005217; x=1711610017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdehVXsBNnGNu7JIAl0Q10r3P3hbg+hd7rOHH7Isw/s=;
        b=mMlwcynBEHc8OR+ciQW5+Rv/W9cdbyj1n8M5cmmQVTqOH/idpxXI+T1LMMRJZL4IuC
         BQpOjIC4JC4V6km/Sq92p/FEwvxApkBsbp95ohWaqB7oF2cIQfCpTa3KqJjXixm9Bvpy
         FaDwOpOLmzkVMADVAoevbtTn9U7w4gZyqzClqz3rFI5Zy4R+OW0oHBphvLzTO4tCoaBm
         93hrtbEUoX03VdzKk8l8iVm35UDISN/HVNeFpL5QiqLj6btYc6eE/x5BS+01E3TDqEWw
         L4i3+V0xJq8t6hpZjtp2F/U82kDi9/o35WuFkX8NIkKdIxbZpMUWs9qrUcxTfyY0YT5C
         S2eg==
X-Forwarded-Encrypted: i=1; AJvYcCX9/dfkZxvIOGE5aPrxQMNrmjOuI7MhVei62jjK24n6xPA0nT4m7HrMhcaj1dvlrBVEeswfeu/N7HGhB86bQ2K6PT0RzKZMk94=
X-Gm-Message-State: AOJu0YyVQmwotEXqoTKPM6DozK/byygB9NkzZ2PGiK6VvZRbTBias+wl
	DTQdW1IOP2A0X313QSzwoVmIqwKisjtjV/cQskqaUq53Ap+Eyzjv9wyJnMNl1Bs=
X-Google-Smtp-Source: AGHT+IFyBPQ76yKJTbUwHPEhA91L3Dj58RUYtEkSZ5tRp1ui+ThKUlnlraJbQqHDTO2KCUJcjGoqYQ==
X-Received: by 2002:a05:6a21:a59c:b0:1a3:6f13:b136 with SMTP id gd28-20020a056a21a59c00b001a36f13b136mr8311254pzc.6.1711004907652;
        Thu, 21 Mar 2024 00:08:27 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090322ca00b001e04cfa5e8csm4711690plg.99.2024.03.21.00.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 00:08:27 -0700 (PDT)
Date: Thu, 21 Mar 2024 15:08:22 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 00/15] treewide: Refactor heap related implementation
Message-ID: <Zfvc5iqc+BN6v2Oj@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <ofjgwiygmyl4fmstibtrckzdoibsmxqypjg2aohwpsg57urqhw@5bikquw6kwew>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ofjgwiygmyl4fmstibtrckzdoibsmxqypjg2aohwpsg57urqhw@5bikquw6kwew>

On Wed, Mar 20, 2024 at 03:57:59PM -0400, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 10:54:02PM +0800, Kuan-Wei Chiu wrote:
> > This patch series focuses on several adjustments related to heap
> > implementation. Firstly, a type-safe interface has been added to the
> > min_heap, along with the introduction of several new functions to
> > enhance its functionality. Additionally, the heap implementation for
> > bcache and bcachefs has been replaced with the generic min_heap
> > implementation from include/linux. Furthermore, several typos have been
> > corrected.
> 
> looks like something's busted:
> 
> https://evilpiepirate.org/~testdashboard/ci?branch=refactor-heap

Oh...That's horrible.
I apologize for the error in the patch I sent.

As I am relatively new to bcache and bcachefs, I would like to ask if
you have any suggestions on how I can conduct comprehensive testing
locally, similar to the CI process you use. This way, I can ensure that
patches are thoroughly tested before next submission.

Regards,
Kuan-Wei
