Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E3D357A3E;
	Wed, 18 Mar 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856409; cv=none; b=WIkzOP38dsP54xmxxz4kl6wv10LfdW8zINgDv1nmj7ne9JlO9Lb9udkJhBGc/hXjVUpr/orP0o6C8rf8Xb+bQhfQbU7mm2iPd+v69GN6IwmSIFMbfV1+UsO7V1hqijWaDB+O6ED4MVOTOXScM+i14EefZZcMf+KNeoMmIWNwVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856409; c=relaxed/simple;
	bh=zCqHcSQbm78DE/UNPYpagACA39E4G50/Pq3y3kEBexE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIRD8OzFr2zYc+gUT14HvQDuBJ0xGBHfiLFAB8qZAL0GzQR8g6g99hvkQiVOMgU5P6PxYk5Jyl3NoQY6cynwqLxPgfMNtJvY1tWgTmoV1Jm8erR9DuR5IWW+wONal3uf1dwcH1ROo5y1LbibLF1NPMPP4rvhpdyCvZqLE+kqbLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIxIuzZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIxIuzZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E094C19421;
	Wed, 18 Mar 2026 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773856408;
	bh=zCqHcSQbm78DE/UNPYpagACA39E4G50/Pq3y3kEBexE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIxIuzZ3E2xVu3AKy1kLT8oajyYwhVSZddNXTytwDgqrDpyg4OAGbFNvFsO8O5/Cb
	 6jmK8YEyph46kE06P9FKSU1nBFm1YXxj6+rZORo6uFIPIAMEo0kf+7RppKbgLs8nxM
	 s2PW8h3jmYP5xZRHY1manI5xhoiutIyw4pzauobC5zydnA2Tslnn40z7NTobAzdx8o
	 cwN5lwrGk6PhwVRJe8NVmFbhkOylw7OF3pzpFmc+Pnz1D1Bzo4bXmqPA7UBu/83yOQ
	 K9nAe13ISxkoBk5GvMfjkMIpMdfDqqB+7F1QnYwK1XcUjA6jcSt1+tKjPOcXfpiS14
	 Li1NSMXJZni/A==
Date: Wed, 18 Mar 2026 11:53:26 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
Message-ID: <abrmlumkhOQEBk-Z@kbusch-mbp>
References: <20260316150229.1771884-1-kbusch@meta.com>
 <20260316150941.1813568-1-kbusch@meta.com>
 <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com>
 <abraWvuLlTjHF-9q@kbusch-mbp>
 <7cdd50b4-afcf-aa5a-af0b-a00a35b88bdf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cdd50b4-afcf-aa5a-af0b-a00a35b88bdf@redhat.com>

On Wed, Mar 18, 2026 at 06:40:52PM +0100, Mikulas Patocka wrote:
> On Wed, 18 Mar 2026, Keith Busch wrote:
> 
> > But even then, the only thing I know of that really wants this has an
> > offset that straddles two pages per block, so I never need more than 2
> > segments, and the inline scatterlist has four. There's just currently no
> > way for the block layer to report a max-segments-per-block limit, so I'm
> > including this patch to be consistent with the reportable limits.
> 
> Can userspace use preadv/pwritev with many small iovecs on a file opened 
> for direct I/O?

Yes, I have several patches that were accepted last year to block and
iomap that align direct-io memory requirements to the backing device's
dma constraints. You can do dword aligned and sized vectored IO to a
block device today if the block limits say its okay.
