Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F158375AB8
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778599667; cv=none; b=Cq+yuMi6jxBDvVtNAPSnoYMHJjH7mwF7PNfltkL28fzfLcTCKDE6rrgLNQpIrrOc0tG0+UyARCsUzD1qMYxXPn50axWf8G6S1U15fGAo4SzPCpDiX/nYj6BA7TEY71YL+RDvcXkxYDLiRXaG5q24Rk+gISzjVLZaSFwPiHbgQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778599667; c=relaxed/simple;
	bh=So5T+PwK0h5wB2TBy4BEBdk40dKHXVlqW1XorlNO6P4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XVNn7HK2YgTc6bkI5OM2BjjehAVscwd+ld5PLU0UUZNc40ig3c6iMuBwtfmKrugZ094z7t8hOR4S2lh4HegZ/82w1exQbFC+VzOb34hYYewyBQ5mGgbWLD9uK5thEWAGFSKgVOKuUM8XEclQt0m0YAwvgDB0LBSzqilbwImgMTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=cSqBCukv; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="cSqBCukv"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-43034c0fd27so2113880fac.1
        for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778599665; x=1779204465; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEsOf8XubBs/oNOFxIW9V5cC+c0JsyhoGC4fUhIAwv0=;
        b=cSqBCukv7GP/TB9AZXqgCeAdrHca5Y0yGAwuV3zIExxqDTwT2ROpr/sbTSNluNNO/s
         NcXMaRDaEG0uldIpj53g+oKnlVhfetP8RLVlEJJqVzUYCLU4qqpbCdegLa/VGb4kRSYQ
         TpSb5LEg7AcgAqYAY1ZVCxUOO9eThKILfUXr/fTJB3bC5qOTAxg2ADI7dPezGS7OyXPb
         SFRQqiScyqM3n1Sf8gMFfDNUSV8AlA1fnf3X4c8WNoK/w5Hscs+ap6VC9Nb7ZZJ4GDUe
         XRMJXuWBdocGBMqvWBAq85UNg5o8SbmN6KvdI1E7VbqmYiphTpzC4oJFm1I8pHuBtPt6
         FK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778599665; x=1779204465;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vEsOf8XubBs/oNOFxIW9V5cC+c0JsyhoGC4fUhIAwv0=;
        b=XirbvUHZXYO16vD4OQeDOKvRLdYKPozJr981pl915ntwXZ+P1Zx0L0VUafznAKeKSd
         rFciH2jjPGNJUOlL8dRB5vcbG1agHcBJwVdDQ6QQ9C9HORavWL0kHsfVBjCcj+K1qIoq
         T96KA3KVZGtStCcwmo/xo/YE93fDTQMN10UjqPZf9f4lA8OlifXV9//4kI2LPvwSyIxZ
         T3bm5cAGfB1TnLtw3yKh044ZxYCkZTMnII3hoEMWkJm/dRxIVnj/SX9y45MdWHnDSV1z
         dA9V3Wll6fdfM/cJoFE4ihQ4Ln2seYUgzLa/Zya7pIWr/VWAJTo8Y1ygr16YueW5EfcO
         ASWw==
X-Forwarded-Encrypted: i=1; AFNElJ/8iHjAeYQoFRqVdUgtiD5/6diRxwY/Fcb7E4KxWnERPNSLlEqf7F/W54LzfV4TcQG25XznlYGj8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMGR5kVFGdVSEzpM5DlBrpITx3PW09xS+BQJwfiPNv5CM1O6cG
	wBPIw+1GePmIQIOOafb7n9t9vwOVrYai2lmQCbBEfP7FjNDhdJPWVCTFBfBExvo2ATE=
X-Gm-Gg: Acq92OFjxbasjzZ52xBQCOGqmBmxNOmNOFLi/vSwViboX0N4bOz3i4w63v/IzLVREDc
	GzIGjWOUtshgxjV1MYJkLS2OEz77FhDDD1FvtM7gJwSyXeZ880dw+Bfae96emNHCsL11lSgace7
	OFgFCFMBHK0rHLIV8Sxc4P+HA2XjS0IrUwW4BBG9weiU0/JKgoBmbRdp073Gl9PD2fdUrieKg4b
	HXapHzTdetXfhQ9gJccQmDAOebxR+5vkwCm+U5CI6YW0Cv2boVO9zK5hWwi++zvILZ9G4eLxwes
	ZD9MFbg8IsQppEhYNLlIh92Vo2RaoiySa0ZLPD5JFDyBX/geUolhmeDHabwIqEeZnBtTv4PcBaG
	4H/7d2Grk5dfVJjr1U7xeAl4SXbglHkNiM/b3/tOU1zIjNMxSXc+mfWphFClL6nzri5ykSvDZRr
	DQrKX3Tkr7a7NYfPRFST7zz3RUzmnilB7T19JtGZob7AqCpaLhBYJdkZs/eaIEq0lSa1pQJy7Tb
	OY=
X-Received: by 2002:a05:6870:970f:b0:42c:259c:6c8c with SMTP id 586e51a60fabf-439a2441508mr2107070fac.3.1778599665025;
        Tue, 12 May 2026 08:27:45 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4355736f517sm13044552fac.12.2026.05.12.08.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:27:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Casey Chen <cachen@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
In-Reply-To: <20260511212230.27511-1-cachen@purestorage.com>
References: <20260511212230.27511-1-cachen@purestorage.com>
Subject: Re: [PATCH] block: recompute nr_integrity_segments in
 blk_insert_cloned_request
Message-Id: <177859966380.306312.3636019256841689076.b4-ty@b4>
Date: Tue, 12 May 2026 09:27:43 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 11 May 2026 15:22:30 -0600, Casey Chen wrote:
> blk_insert_cloned_request() already recomputes nr_phys_segments
> against the bottom queue, because "the queue settings related to
> segment counting may differ from the original queue." The exact same
> reasoning applies to integrity segments: a stacked driver's underlying
> queue can have tighter virt_boundary_mask, seg_boundary_mask, or
> max_segment_size than the top queue, in which case
> blk_rq_count_integrity_sg() against the bottom queue produces a
> different count than the cached rq->nr_integrity_segments inherited
> from the source request by blk_rq_prep_clone().
> 
> [...]

Applied, thanks!

[1/1] block: recompute nr_integrity_segments in blk_insert_cloned_request
      commit: 2c6e6a18a37b905cb584eb0dda3ae482162a81ca

Best regards,
-- 
Jens Axboe



