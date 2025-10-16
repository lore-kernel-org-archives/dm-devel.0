Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC781A9F83;
	Thu, 16 Oct 2025 19:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760644792; cv=none; b=IiGpkXzJXZ8mnuv0TcvIxNoqS1RKHiEnehfqMCWyBph8Psi8bzc/GKR9irXuGeoKQN04mm3Y8FcDG5s1logo1UBj+MiImWM/n04t+5HkssWZANs7OkR44thoPGoRPydaGIJQPji33Dm2JJwAKGJ+tT/lNiVD8ZkoJacliWi1tVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760644792; c=relaxed/simple;
	bh=wnGFXUkhjqjH4Y7p0XOQY5X5G0LvDy62Z/nsMgRH3Y4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=IK+pQdOvcT58pjg6p2VIfMb6SfXowBTzLiKS6qWzJ6peHAQrOmSGQH9xBi7dc//CKfhiOkiLFnBaUwOqTPd1hTWWzX8hQVIMOiQLctHYDk5MkglAnrElzSRoRYmFYACOctNnQ5r/DbdHMspVrqQxhfOkwkK9ujLxjp8zTR33qYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cbJGIBPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cbJGIBPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D10C4CEF1;
	Thu, 16 Oct 2025 19:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760644791;
	bh=wnGFXUkhjqjH4Y7p0XOQY5X5G0LvDy62Z/nsMgRH3Y4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cbJGIBPjRBEzTENEs2o55pYzrUGYSsXVM/b4EEIDQvoUD3i70DZ3oIy8jqnRv+7JX
	 CHPKPlBz63ESlyOVqSa/s0fT/gPAFZ6DiguDteMbTtC7tZ+MrVD94gqR1Za8ozZ3MH
	 PegFgwB6pnYQ9WUqowXufTwP4bSuOyIsBK8DHwuw=
Date: Thu, 16 Oct 2025 12:59:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, LKML
 <linux-kernel@vger.kernel.org>, DMML <dm-devel@lists.linux.dev>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-Id: <20251016125951.27bb194ab31fe5c61f657a71@linux-foundation.org>
In-Reply-To: <20251014144731.164120-1-urezki@gmail.com>
References: <20251014144731.164120-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Oct 2025 16:47:31 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> When performing a read-modify-write(RMW) operation, any modification
> to a buffered block must cause the entire buffer to be marked dirty.
> 
> Marking only a subrange as dirty is incorrect because the underlying
> device block size(ubs) defines the minimum read/write granularity. A
> lower device can perform I/O only on regions which are fully aligned
> and sized to ubs.
> 
> This change ensures that write-back operations always occur in full
> ubs-sized chunks, matching the intended emulation semantics of the
> EBS target.

It sounds like this can result in corruption under some circumstances?

It would be helpful if you could spell this out clearly, please.  What
are the userspace-visible effects of this bug and how are those effects
demonstrated?
