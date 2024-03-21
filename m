Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6558212
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 07:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711004421; cv=none; b=ZRKbtNx48VGSwcKQ0GxcCA+eXTAILHh+D2uDXTj39SULkIcZwMGHoMRfJcGWQn7hVD1KxmI6zNBNJGgKluzxeO48IWP9kQR1iS1DVQJKNY9rOQJxrjLsHAJfn1rv83yih7d/c/O0cgkmIEgnYewx+0j8JsmytVVEBe3W7bsHPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711004421; c=relaxed/simple;
	bh=C6RQygeMnW/XJWtdkg9o9IMsvbD+zCntQd3itTZvF3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ai7oJ4H/OaOW97kVI6gsFaKAacqRX4ojWhCqOks/tMp6ielIcY60SdtUYnB0S/vpGrP+JmHKw1waoxhqvyHxYWwW4+vec9WPxwKjt13Tc9iZBgqAFta6SpU1voH0uXIg0zAnjwO2aLH14dBIym7z0MiaSkscZllCd1/kd0Ny25k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0S5vJyM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0S5vJyM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e0678265b3so1853005ad.0
        for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 00:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711004419; x=1711609219; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yuRYtnmCnecoco60awXI1rXerQ2CUVZkzhEeKkO92PI=;
        b=Q0S5vJyM995JIc+oN4fH7YJytID5UFlnHyK73kjipQa/VXOwAe++CD6dEeHnE/dBRT
         WhvsVAFUcOqf8PumnkNd0/BcPmDVzC73aPPxw7CmwO38YnC2E6cUQUJM9D+irDdsmiLU
         17udIfH5DcMLrpgh4lWrr1/+VkjuQc9rR8h9AZ7JFySArjn6WSN/96Q0sXAeSBEreLPl
         CbvYsRYPN7kTKk6D2zCxr4xD2PvrqtjnAWHYm2QUGkWo27HtTnmVto5VD+FsuTkFH58r
         MSM7mtk+t+elz+Pk1J6J4dUiAOPefTYKrCWszWuRoatMtGxatIDEQYIm3Efcw4Od0pFt
         akVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711004419; x=1711609219;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuRYtnmCnecoco60awXI1rXerQ2CUVZkzhEeKkO92PI=;
        b=AZR+vfR7Ezt4f99VuQY3X01yMaK4RBmZSsRWzR3B8ydYU3bNUFJ8X2KK6VZfH3gyFq
         h3ucCFxQymrA6xiGY2k1CMmI5N+ENWJS5OBLJxlAiNmp8tHn3kZdYro4emg9E0pIc2qd
         x7y1tUk3/qS8pv9mC6Jwo9srHp0AKt5beCh7iOM14AN0FqMf6CxlYYrwZXaZmEdkNA53
         iMqj33n0Q2m5d26/MvkFBaB4dgiwtP1pmI9DDTHeIrWWaexHFHDccCWlF2DTk52Gf7TU
         L9H+W+eLsvcE2YP1YnVDWlvB2TVC7RU6YCIeQ3tlzSEOy6VJ7czN+m8G3Jm9QQtLvYNd
         FaRg==
X-Forwarded-Encrypted: i=1; AJvYcCUg3ARaqL0lj4IDxI6Zl3KakXsz89hcaD2uo+rvy20fNpegXF6OrQZSdAvsWOw8SMR0pGsS/zNcrF8pfdeihPU9U7GKsXvc/yY=
X-Gm-Message-State: AOJu0YzLTMMzX76otlxs3M2+cNVVWIlBrpmx6yRgcZ7FEvDGWK3OIkTZ
	HBmcRs1Jq1m6RZeoVVPuTdjKPzTnFXAMF5HoPvx0rC4zrWXcv4IcZNX8hWg/k/A=
X-Google-Smtp-Source: AGHT+IGetQAA3uKa4M11qYFc4ZpIk2cFDmpiqBhR080pzhKlAYhF5Nq5NnMOAwNr6bGazui6FenSig==
X-Received: by 2002:a17:902:ea03:b0:1dd:a3d6:3aff with SMTP id s3-20020a170902ea0300b001dda3d63affmr22699523plg.3.1711004419070;
        Thu, 21 Mar 2024 00:00:19 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d4-20020a170903230400b001db5ecd115bsm13468894plh.276.2024.03.21.00.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 00:00:18 -0700 (PDT)
Date: Thu, 21 Mar 2024 15:00:14 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Ian Rogers <irogers@google.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org, bfoster@redhat.com,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
Message-ID: <Zfva/gJ8h5G+1YfC@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-10-visitorckw@gmail.com>
 <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>

On Wed, Mar 20, 2024 at 10:15:08AM -0700, Ian Rogers wrote:
> On Wed, Mar 20, 2024 at 7:55 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Add min_heap_sift_up() to sift up the element at index 'idx' in the
> > heap.
> 
> Thanks, should min_heap_push be updated to use this sift up rather
> than its inline version?
> 
It's better to do it that way.
I'll make that change in v3.

Regards,
Kuan-Wei
> 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> >  include/linux/min_heap.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index 36023e0be232..af12531474a4 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
> >  #define min_heap_push(_heap, _element, _func)  \
> >         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
> >
> > +/* Sift up ith element from the heap, O(log2(nr)). */
> > +static __always_inline
> > +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_t idx,
> > +               const struct min_heap_callbacks *func, void *args)
> > +{
> > +       void *data = heap->data;
> > +       size_t parent;
> > +
> > +       while (idx) {
> > +               parent = (idx - 1) / 2;
> > +               if (func->less(data + parent * elem_size, data + idx * elem_size, args))
> > +                       break;
> > +               func->swp(data + parent * elem_size, data + idx * elem_size, args);
> > +               idx = parent;
> > +       }
> > +}
> > +
> > +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> > +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
> > +
> >  /* Remove ith element from the heap, O(log2(nr)). */
> >  static __always_inline
> >  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
> > --
> > 2.34.1
> >
