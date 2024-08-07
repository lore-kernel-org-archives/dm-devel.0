Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A86178C7E
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059242; cv=none; b=ASeJVIDj9z9qoX9IhxrAiB6NbiTepOKmwN/WJFHFfWZ62ue0FMEppnMRsm58fpI/5QYoyw4KQi1G56IJKCdTBLJGAwQfjxb4IkQO86gh397KY0PTJLaZtLJFy/z75DhPW1cKND3yKo14H/lJiDb2pJRiAFHUsZch8sy9C3EpCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059242; c=relaxed/simple;
	bh=GfgJ0uahyieexhF++78bvJjM+MOd0zlcggaXLt1RSNA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LYZ1PG8XLqSQ2bgZdZQtZRBskzrdvctcaB/CULykzTKnIGMnOFPSeF8RVvSICYvCiXMMyiZLAzSxMOtjNxbyyaH9QU9d4xY+FhGLJrwqDSfkm8B9BWioE5M8UFE1uMBao8ILFNS/QC6Up8lzNjTBbkzKTLdlsPNTjPGXeOowbF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=a4KewVce; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="a4KewVce"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4C96741AB8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1723059237; bh=NIDZV7w4XvptuW+/PhlC0IXD8oT0OHvantSGMMYSo0g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=a4KewVceYlZ+IpSi2alsIZrgzut49MW4bOzMq6afZOxVqaHYAKNz9ykEQJCMml3FN
	 yvZ7vjdsmHOmZxRk4mERx/vXrLwGLvbWOPyE0pXd1S5dHEtZ+izB+mNpU5n8xdfX7a
	 7Wm6jpmikgqWV/u2+HN5oY/7jaAaDzaGJ+gRjK5EtnU/MXP5ISutcxUh02+w7qk8oy
	 jsEGCFoDyrnaatrowEaj4W790qWDubNgsYMc15w1EVHa0q0Qr9Dk4FKH/T0vKgWUF5
	 9N8nh6YUHeQ1OjZNemPs6oVaEqt01GvFQ2ROaZ74OhCSViAL5f6cK195I08OKSt+1Q
	 0Mi8h1PCxSatA==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 4C96741AB8;
	Wed,  7 Aug 2024 19:33:57 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Yang <danielyangkang@gmail.com>, skhan@linuxfoundation.org
Cc: danielyangkang@gmail.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
 <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: dm-crypt.rst warning + error fix
In-Reply-To: <20240807090121.61064-1-danielyangkang@gmail.com>
References: <20240807090121.61064-1-danielyangkang@gmail.com>
Date: Wed, 07 Aug 2024 13:33:56 -0600
Message-ID: <87zfpoqg9n.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Daniel Yang <danielyangkang@gmail.com> writes:

> Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
> ---
>  .../admin-guide/device-mapper/dm-crypt.rst        | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> index e625830d335..552c9155165 100644
> --- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> @@ -162,13 +162,14 @@ iv_large_sectors
>  
>  
>  Module parameters::
> -max_read_size
> -max_write_size
> -   Maximum size of read or write requests. When a request larger than this size
> -   is received, dm-crypt will split the request. The splitting improves
> -   concurrency (the split requests could be encrypted in parallel by multiple
> -   cores), but it also causes overhead. The user should tune these parameters to
> -   fit the actual workload.
> +
> +   max_read_size
> +   max_write_size
> +      Maximum size of read or write requests. When a request larger than this size
> +      is received, dm-crypt will split the request. The splitting improves
> +      concurrency (the split requests could be encrypted in parallel by multiple
> +      cores), but it also causes overhead. The user should tune these parameters to
> +      fit the actual workload.

Thanks for the patch.  It would have been better to include a proper
changelog, even for a simple change like this.  Unfortunately, I got
another fix for this error a few days ago, and have applied that.

jon
