Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94A12C11D9
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786020744; cv=none; b=oOugL0vVcEmHvG0VPG0ruQAOYIblpqdURjagaXJYMiXis/vSY2V2QayCUUfXKjzMNMaYEOvHadB5HZ03beHFKg9UJPwDuU+ceg5huaTrleeknXx8cmmcNCrSpJMsrJiiY/bH0C3Zo5t+3VQDqa+Xdqr8GzPx6er92GMzTMiIX2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786020744; c=relaxed/simple;
	bh=E+t1gFtcHDiraPPrfsroY+Aj4GCqUrp3X08deU2GKIU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FScFZouDCiabw92LEejJYDhfpan27OGe6wzWtBPyuo9rYY5Z+v68XCJUc0ASjCGr+qwKKnqB2D3CpxhzndXc0Zciuprn9XGISDwOS7pEV5QrugB1SOxRSjNpapuX8nSGlgya1uEoWhVjy+vSBxWctEsYR7wsxizz4XHLbJUxDX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=DyTfwgdN; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="DyTfwgdN"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92f03daaa97so124117085a.2
        for <dm-devel@lists.linux.dev>; Thu, 06 Aug 2026 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786020741; x=1786625541; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vo5x/LABgr4z5KWlM8OBLiF0UJfhkaG4qblmSgV8YMA=;
        b=DyTfwgdN+LS8PpTre9FFVAIAZUz0w6KUwa2Cn2A6z1CUSClybLXbQIYWEOEf7gHHHy
         SI0oL16CRE2jBUD1IGw2+MSXvpZ2pLHZIydEc+whd3ODs6XsQaHrUaXolGeg4zmnmC9A
         qrBaALjL4r0CS1Im2wnDg1eOxLR/zYUlgMPcKDauSSaxXAb1+nZlKbN7YmKoPA8hsqRQ
         dgY/oCsluR1XG6EUfU7234AddH4tXprwlFvZ2vfhRvKu20ooao4EV8AunP4nggh2lxz3
         eqBIVDB/lWx00btPxUaSIYYr1Z8o7bPTEhsUwriYBU8RJc8eu+69Th1tNUWzj/5MrV5y
         BpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786020741; x=1786625541;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vo5x/LABgr4z5KWlM8OBLiF0UJfhkaG4qblmSgV8YMA=;
        b=VkFlCLJSjcQBIO5Lc1dneWrOXzK+uXcBeRiLfLXZVvjDxbvJYA1Hv9yYKHyfd+dDdV
         OKJTiIS/aTERrE7eb5CFiLk6zcuVmUB2JP/C8/gRU0B4RIOXiGQxp3qV3p+SSpHD7DyS
         BEo8zymE/wXvTkEdrqKWCy615gn70MUtZnRVuzJh84MKIWFdruIdoeU2Ft06Ahgsv2Tu
         O60dAt25Yr8Ji8J2m6rigqlvHtkLQBcqmHsNq/NonvnEtIoQlBx5BzbyyutF+TGq+xmn
         EX1HfhrZ3QK1lTnD69k4xvUb3cx/FawqRCAGou64s1IC+sNzT9g+OHC8XNgiIJAm6Ms4
         494A==
X-Forwarded-Encrypted: i=1; AHgh+RoezdOJGoW9MvUhKW4UzCDltmPaFzWV0+Pk+XgEu/BQ3ShpnpIFSPQ+lgJWZTHK45zAGKAWOP6+Hg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyV71wU1PQqiowS9ipmIA+Pslzbw5tGfk3BFj0IcaTPO3drc9eU
	/mUraQndnb/QUpH9DhXO13qN/TE0Y4A9DWVTe7DHU5P7PLwPkSMtpkDmotZeJZMMrCQ=
X-Gm-Gg: AR+sD11mj1xOzfegAW23hvNRhrDRNQq3fO9uD63mpsjv6mKDaAnmzwRzGcZ88Dpq5Un
	w1GtUpJNbuLLte5WowKp9xpaEsa/NJWlN1nG2p0bmnWZK2xp4gVHjXe3bzX0OtDoWzkDmsaO6ji
	yjvuhy0x1khzIaJc5qVhAikU8JVqpgHUetxbWn32mD4OMEsZSROYDXfyuzQ5kOffJW9pMpfJLZS
	S9Km9J2aNijoK4Xobb/W90VvIwWWKcZn4dhdX6HEdUb79XyqK38ekdyWDNSReXXJlTIXGp4kRc8
	7CELiDAlycPpletsJ2DQRu2u6/rYgMZC351+/Y8FmBPI0Oo9eqaE6zM0ZDBvHubmaxoIuvS23ux
	AC+kAYWVCpAF81KiywlSu7uy2s2qY9prHfXxEOWxmZRAWrGZNFDk5oBcs4b9zmi89TKynapnVe9
	cJP7KjN6A3J1R7u2np+HxErSiisNfsGyG/IGWuj1YizkPal4lnd/wk/+M+xJn7RNLcE/w9dLqMJ
	LIUmEI6G4O8MfU8kYkskdSjUAjeHzYkQIESvfQISX5Fdddl
X-Received: by 2002:a05:620a:2311:20b0:930:84d0:fd3b with SMTP id af79cd13be357-93648fafbc7mr1150209885a.7.1786020740525;
        Thu, 06 Aug 2026 05:52:20 -0700 (PDT)
Received: from [127.0.0.1] ([2605:59ca:42bb:f910:6d9f:8dfb:ae1:441b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9365ef833edsm123847685a.3.2026.08.06.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:52:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Hannes Reinecke <hare@kernel.org>, 
 linux-doc@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
 linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ceph-devel@vger.kernel.org
In-Reply-To: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
References: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] block: rename bi_bvec_done
Message-Id: <178602073720.2137920.17721545855702977301.b4-ty@b4>
Date: Thu, 06 Aug 2026 06:52:17 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Thu, 06 Aug 2026 13:19:27 +0100, Pavel Begunkov wrote:
> struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
> let's rename it accordingly for better clarity. I also plan to use it
> for non-bvec based iteration in the future like dma-buf, so drop the
> "bvec" part.

Applied, thanks!

[1/1] block: rename bi_bvec_done
      commit: b539aeacf8cc5e9d8e5d94625d2d9c697a167add

Best regards,
-- 
Jens Axboe



