Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20696338918
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 20:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766174836; cv=none; b=pkaEt7+TD8bw1cSyb9ax8KSUEzcs660VmKDJmBDWFY9wb575kk+iZp32syXzF9W5HYKiB9awFCQUNhtyH+MERe5h8pFtlXUFpaDEGz2IixnxBwe9yi3Xb112H4Q3oUL1pKfzx4jW63q6HQgqZDJoX2HSgUXPNIZ+vf5h+IU3UJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766174836; c=relaxed/simple;
	bh=x9g+r0B1cV6KQvgRgL/L46NdgXxy7px+2XlJPSBHJWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u8TBlaX4gl9nn1zAjIUgLFXlwURen9t1owIRp1wZR0lBXWY2R50LGhflECiY+jlb6oSQwDQu5DuQtx+8sErwKRso9eD97AqswK6NMQZjt9P9ZRpSp/mKlJaZu/T1hS0eJhKMQadHHdDJ0cNpJjQcucjSV0f86Ej79uZkyzJAzWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ChXcole2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ChXcole2"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29f02651fccso242865ad.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 12:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766174833; x=1766779633; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5chjM/Sk5rfJ/BgyBe1pD3THP6lmKgHTA4tgTmqpYoA=;
        b=ChXcole2c/WsY26reXhhzqiZwKdiF+aBwVBYnGBroQ/NliVc/QM4ouVi5D6EIOB3rn
         Tao6XrEFy7T7f9mMjfrXNbj9Sm/kQowNwX3rC2eItg9nCF4W7tSAZaslWFQ/EgghU0kw
         Pr0XVcjv67XUnszXozc6L87K2Woe2vTuwZnPoPWR8kbwWnJmN8oxp6fci8UriQ6YNGfi
         veZU2C3ZA7wRNPx062Gu1mREeJ26HvetQpwN4GJmJx+Ic7r8A13dnRiCV3CiCaiMAF+P
         AKsa7avyZ842nn5tSO4Ed0zXvu8GOEV3zkuOOLZwy4lMjYw4A5daiQEZh4XPTOzyc0Sw
         D4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766174833; x=1766779633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5chjM/Sk5rfJ/BgyBe1pD3THP6lmKgHTA4tgTmqpYoA=;
        b=bs1DJxwsDi/LuliWeIKrqHGCRXioxU4cXdNAqkUh81wdr2EvKbv1Q6emgUI79U+Ng5
         XrFWHbZxcU7VHBZDSepH6FElLPWIA3QhqQAAy/+zLxoSleAkINZtHRqWsvZ7k/gd8Y11
         PXur2b+StJzjZRnWBwVaX2B4SxYzZuA2hxc7f3eTzeS+HOw5EjDTR6SFsEJS5HRDFwMu
         psnOiHApSUgZedVjd8AXnGrIZaNFKSAHUfYz4+lOGZ2czbqOqS8vcXfOhveDNZP5v8mM
         zQtpqLwVlZ9CkZ1F+xAB+KItw6LwDs0LVZq+tlBbgoYHcVmtX5NkaFcWfZKXVAvukyZk
         NJhA==
X-Gm-Message-State: AOJu0Yz8W7RrXVjjLWyNo9T5ta/y7bVIjbKmjS7ij/uPheJent9HwkZ4
	sJHuDj4tOHgUvgr1Ms0bdntqaolSiFDXyE0NZzwWzVPOFsw6IIL/YndJZJ/31JXQ9A==
X-Gm-Gg: AY/fxX4LKvUywQnr9dWh/Rz0n2smtRXdQhDRYhm5tD47CgOt4xuA6tPEwkVnwkoNXwj
	cwMOkG8DiHbj06yqf42gCTjm6F5rjW/JvpicYT0OoZ2tvBld/f+oHgofCOxafQ+0RdCdaFruVsb
	eIiS256FbYFEsL2ZgBwEXM0sY8PCXNnm4Q5EXa597KwzQZucSD+qO1QHHxIdWNfiEq7PqNcWqZe
	4B/UsOeZAUIDJZUSnarDpz+X5D1VI6IfXQoVJTgTw+iK81Z65Ibc1XB5woRTIp2PrzNkANjkzr0
	JhjWTxXimfElMT8SIjJZY+oDHLJ2Yhq1Bde89o1hR+3X+s+UE2elLbSd3pKk513zZyWQwsavbqT
	4LU55n4M5jLpKTlDG9Y3INz6ukBLdJIkTLBrv3SOr6KdXCSQipUwOS+ZKucjZfxfeZfU2+rjD1t
	h5vtuci7ji3GdR3Tob/+Nmcp3n/2LbkptDPF4jj4zIanS3A+XSmvNwDc7pxVv1tuY+0g==
X-Google-Smtp-Source: AGHT+IGraRFRdepC6AoX90L9fIl2imC1ZhHdm4L7Q8WhmO4BhOfo+SNFGmPnlklnJALRX5/FaYMKyg==
X-Received: by 2002:a17:902:ce0d:b0:294:d42c:ca0f with SMTP id d9443c01a7336-2a31177cf63mr504845ad.2.1766174832616;
        Fri, 19 Dec 2025 12:07:12 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82a10sm30046535ad.26.2025.12.19.12.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 12:07:12 -0800 (PST)
Date: Fri, 19 Dec 2025 20:07:08 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] dm-verity: make dm_verity_fec_io::bufs
 variable-length
Message-ID: <20251219200708.GA2662043@google.com>
References: <20251219192909.385494-1-ebiggers@kernel.org>
 <20251219192909.385494-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219192909.385494-3-ebiggers@kernel.org>

On Fri, Dec 19, 2025 at 11:29:04AM -0800, Eric Biggers wrote:
> When correcting a data block, the FEC code performs optimally when it
> has enough buffers to hold all the needed RS blocks.  That number of
> buffers is '1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS)'.
> 
> However, since v->data_dev_block_bits isn't a compile-time constant, the
> code actually used PAGE_SHIFT instead.
> 
> With the traditional PAGE_SIZE == data_block_size == 4096, this was
> fine.  However, when PAGE_SIZE > data_block_size, this wastes space.
> E.g., with data_block_size == 4096 && PAGE_SIZE == 16384, struct
> dm_verity_fec_io is 9240 bytes, when in fact only 3096 bytes are needed.
> 
> Fix this by making dm_verity_fec_io::bufs a variable-length array.
> 
> This makes the macros DM_VERITY_FEC_BUF_MAX and
> fec_for_each_extra_buffer() no longer apply, so remove them.  For
> consistency, and because DM_VERITY_FEC_BUF_PREALLOC is fixed at 1 and
> was already assumed to be 1 (considering that mempool_alloc() shouldn't
> be called in a loop), also remove the related macros
> DM_VERITY_FEC_BUF_PREALLOC and fec_for_each_prealloc_buffer().
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
