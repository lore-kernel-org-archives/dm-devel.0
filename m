Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0CB8002C
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707411380; cv=none; b=iZd6cbietWQ7xULFT3Y7Jp1dmbn069Hha1mauGz6VR+uFXjVhTd7pSJc54aTOffHJJMqCu29hPE54PuXcqz61Ax0MfcQS/gA4blflel6EkaOYG0FLXg7L+tfVQvcdxSaC+mJCOBNia8i7qelFFoX/kclpjh62wtAmPgvilfoWX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707411380; c=relaxed/simple;
	bh=BWu/28fRzjkSvdnGNYlpR0IqiCP38+waS7beyb9M788=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVTe2pZvlZrUu2ztKUdEoRp9mS3OmH+czXA0WmCU2ssmm//ZtPUxqC3j4YCtr3RYG2NrLE8XiPKLs9t4SBti7RSGRf7CdMxMHrgbxRF3ZgiNsI9oLT6OqBRF4BRFqt22hFi7KNDQPEf0gZ/GEKTkBbqPT75UmB0B5eCPwo1U+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1STdH9s; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1STdH9s"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d7232dcb3eso16706185ad.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Feb 2024 08:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707411378; x=1708016178; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N4xRu64XxLbwyXH7oYCu6PRDtlp7yUhISnlJKKI/0Tc=;
        b=E1STdH9sVmrZhgA0VKMgRGn3kgZXudJddsWIZqX1QrkGeqzz2CTvGqhCgYQS33E8EF
         gLh7QBFVGq039Drc1Fxh/cDPxF9WR6Ks/T8+hC4cnZNvvlw4luWwmqSnZCpQbG/nFmyC
         qGbi5+wHGPtakHE+oiGXkG8ko8P5NfLTH53JTz5824/JQLwt8lrsw1FClLEi2GGynsit
         9MNia3AGU8GQP/TjWUYj86MQOiQlWA2GfaMJQc4BG2yRzE2weOj69Yr+mIU29tDWbJXt
         z3GEK6yZLZWJgSfyLng5DKbBS9CN+jC75rrLfJgmqB7iN3rZ3+YhiS6sje7P71UbC0SR
         DrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707411378; x=1708016178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4xRu64XxLbwyXH7oYCu6PRDtlp7yUhISnlJKKI/0Tc=;
        b=qWVMpQuEvXABZvlcyTOvw38hvaW97nsMDONtBTvCrMHYJDhhKe4noJ+6dRsW08mrZB
         YSms212idjU2VGLJZ12CLISe2EwE9BaWx6DEyAUE6vwuaP8XTa8XxAjQ+Qt3fMoOt8dW
         xu9+kwyO1bzMSprxZuoSi0FmZIZjy2snrnykGkfdHnGih+LggKdTB81OaRU+n4VbdmIl
         Q6g7o+FNaf1gCCcvQKNG0ghCWxxidiZs3xhGiAkxNmGhJrEFy3VEhJvimB1W+hRHpuej
         GInkE64I7H4b7g9bmd0DyIIFaeCNSTFV6W1DVqHxENNaBnCFd4OEp0a5rYuFK1w4uRq0
         xMTA==
X-Forwarded-Encrypted: i=1; AJvYcCVtcOsFtAka33RGyQWYx4MlOXDiQZsekWWPuBYDoChZvuy4yfNsvJfwONiHXYvlp7gggtG+T8IMIS+tSMMo1PsH7blfO8sxORc=
X-Gm-Message-State: AOJu0YyyGiVygcbwm27CkN6FsfLU+/BxhjZlE9RMo6mRvBPF4ACnHUfd
	KUKzONVzzjve+ThJtxCE06w7UD4/28FBG3k+8gZ3zxgLkdYKUamr
X-Google-Smtp-Source: AGHT+IHOzIx5Ag+DssraT1KoaXuGtKOQFpMJMlaapfeV7Mba5cBbHY7UXR37Bl9QXvIi0G8qvZShSA==
X-Received: by 2002:a17:902:6bc1:b0:1d9:b89c:1bd2 with SMTP id m1-20020a1709026bc100b001d9b89c1bd2mr8331484plt.63.1707411378283;
        Thu, 08 Feb 2024 08:56:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXW/GNbCDzV0WwQk4yUkzYM+KTU+52Xlbx7rNGl0IimjaMAKSmnUrqBf5JekcRV0M3g8ZYMeRo9E9LhChbKrDG5J+PK5X4WuPAtlxRcjY5f67ZpTNya395BntBypX2JwlSkE4vJl7KymTrEX2CzKtnxHIaac6PvS82qQ8nx056xBI9KfVWOmeLXl2+Q9tl6yyAQYLll5xPmvUvXUokP+BF38Hr9L0pFFlkMrAJg5lR7nq+l9HiwjdyDAMavs7h+au4Oo15mCEMN0VyEP7DHukUs/1aN+li9tP9KcmQAYXjTFGabTO+KqQuHWHrIMk4PdodOhY1POZoJvXct+SW64h5aGy34nkJ9ot/NI/2A91ae5D06U77mMUq2/xfqAhoDxTS8nbO93V1MLtm+vm3wNVSMN0176ekXPLFYa5IWxeRaqi0LU8Ir6EZfvndgzcM=
Received: from localhost ([2620:10d:c090:400::4:3c45])
        by smtp.gmail.com with ESMTPSA id ko4-20020a17090307c400b001d9606aac46sm9840plb.212.2024.02.08.08.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 08:56:17 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 8 Feb 2024 06:56:16 -1000
From: Tejun Heo <tj@kernel.org>
To: Allen <allen.lkml@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
Message-ID: <ZcUHsHzlLpE7meaW@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <ZcACvVz83QFuSLR6@slm.duckdns.org>
 <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com>
 <ZcFPKaWwxJhgy8HQ@slm.duckdns.org>
 <CAOMdWSKQC4UWXp57qubcSOHmPj0E7wHZWWbCz+yCZqROhoPSGw@mail.gmail.com>
 <CAOMdWSLF9AaQF0ux03-tonw-Jy+4rXdKEZGzPrp_v+fnas6SnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSLF9AaQF0ux03-tonw-Jy+4rXdKEZGzPrp_v+fnas6SnQ@mail.gmail.com>

On Wed, Feb 07, 2024 at 11:02:37AM -0800, Allen wrote:
> https://github.com/allenpais/for-6.9-bh-conversions
> 
>  I am holding on to the patch that converts drivers/media/*, as I haven't found
> a right way to replace tasklet_[disable/enable] api's. The rest should be ready
> in a day or two.

Yeah, we'll need to add something to workqueue to support that. As for the
rest, looking at the code, I think tasklet_kill() should be converted to
cancel_work_sync(), not flush_work().

Thanks.

-- 
tejun
