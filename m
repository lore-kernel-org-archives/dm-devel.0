Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC8B201033;
	Fri,  2 May 2025 09:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746177657; cv=none; b=dAust/ggCXg3MWN9lGqRN6Z5ZsvrwJ17Ldr/ZQJ4xztn96LrLWuynXlkD9/zC2aF4RyC12qsNNQFbY5G7qApQma+5jcgrrFw36HSDYZqH6LWVrWxlRdmgqbtm/IVSdmLdqxTPuVB8VcYnfIxgkasBQxKzx5j2/Q9R6CjmX3h+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746177657; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d251SIS0NgVnp6q6ZKa+6rcR4vlEG0M8yFIUwS39sSGXaW4dCGf2nH8AEzp5bEd7ElOYTcxRwOqcjNTIGRKry8oIxkPdeBsx8o31WwmtFzd4/hIol4BFDj5WNng2mc1TdDXy/PfroCq6Fm6m8zMatZdjbi0t8mKtLtdSMaM781M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so10345165e9.2;
        Fri, 02 May 2025 02:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746177654; x=1746782454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
        b=vH/cIiSYCosnf/P33dtGzCAsGURXC+WzRt5iZALG0TacGLQoBw9UYxxjzXaHyrUB3c
         BY4/TNL/VfG0rjrIV2YT2CkknoqhQm5pDw4Nru9OhoXIYI27v4SMlTKo/feYt/sViGDr
         MTOlG6WqdjH0XfgnSCiUmV67o9Qu+aY0y7FgpBE1LWekeYGF47ynetL7bIMlaD+p0QbB
         HxVo3lxi1DwtLjyKTndTTqvWQa2E2Z61rl8m0yPdWN8xu6lmDJFrJBPxgjBHmIjA/FgB
         OfYtZVlkc5TrJexBFMDRwuKuc0ZVewwbj+9lBq2F8NDOL/mEWumQbXvZKzUc0Se3h07i
         5btQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFbHnODw2uWSLhC87MwoduwQPjHk7EXcsUYqRREUFmNgSKv1ttTdtTFvU3XQQW3rM+voeI7jcBQQ==@lists.linux.dev, AJvYcCVF5kL8J7xQGEFfR/ZjmAVuiU6NWDi1NWCN91wVW/iKwGiZwcs0XVada62uVAU6mGHXwhqJbQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwcdhZ4uu6m84VyFaan+G9OOVVLZggidGGVqel1NxyV9DpEf+Mp
	nskn2MzCNTIRXYi+qptZfflQwdXyqRVkHOOhv0+EtjEPWekui6yj
X-Gm-Gg: ASbGncuBgiFTSqz3hgdS/k8LbZClCEPydQ2ZShvH6/t2AXSxsIDOt49DE3J9CPiSBdE
	IY4U1ixrTLviA0VUrJHVJ9Y4EMZPVgcgCnKIohVptIwjTwp9B4S7tZiEFfrwhCKL8deKA6mAFr0
	KovUmIOBXPT5lZglXA7VJtqHtJkwAhSgY94Nlqb2/ajNsYuVhXfIaocwGqB1vqpd3sLBFy84U5p
	lLEgIWSH5JwlY2EGw+cJAeJCFd/AKgBRADVhxwZE0zddihP819lYRD8UqthH0whQBKXENPRFJ1o
	DplDAd7irmjvQqEOS4PJyYe4Ocx9n28VP1SkuqlVRDnPambf1EBUmV7APg==
X-Google-Smtp-Source: AGHT+IFgGSam1M2eyL/4Vk4mDkIaVvxS1jdjCI6lel5HYbzONYXZiJZ8VWNJWL/XzxR8+LguUZV9dA==
X-Received: by 2002:a05:600c:3b20:b0:43c:fb95:c76f with SMTP id 5b1f17b1804b1-441bbeb0efbmr17223385e9.9.1746177654117;
        Fri, 02 May 2025 02:20:54 -0700 (PDT)
Received: from fedora (p54ad9a78.dip0.t-ipconnect.de. [84.173.154.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae0b9fsm1571335f8f.4.2025.05.02.02.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 02:20:53 -0700 (PDT)
Date: Fri, 2 May 2025 11:20:51 +0200
From: Johannes Thumshirn <jth@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 04/19] block: add a bio_add_vmalloc helpers
Message-ID: <aBSOc4-xWw9JLUgB@fedora>
References: <20250430212159.2865803-1-hch@lst.de>
 <20250430212159.2865803-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430212159.2865803-5-hch@lst.de>

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
