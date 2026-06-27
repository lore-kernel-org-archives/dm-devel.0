Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB872EBBAF
	for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782577818; cv=none; b=OVEEUD4whGgLnTUUm1Hm7+ZJ25pypbE09AGHqWH7A5IqIQ/xNPqRQIt61N+PbFC94m7EGF6l8gV1tx/Q6r/ZDMVQv1BGCm3nCi4q7ZnHCG4Z+JHSg9blW963SdBYi0Kq5knO6PUODp13Q3Oa3v/6LkQ6i664SQYezxTIWJctn3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782577818; c=relaxed/simple;
	bh=T9Xh9+d6qi4HBB5tejaQShSI6NeXDd5Yqy8wC7NGHnQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aaYG+hYByv7k5CRjoXXx5SO7JwJM4BqydznWodsRBNG1VyJ4mEfuUnQxnzDCuzDvNJdmdFSAvryIi7Q2ootqbdR1Sl2yrGrcHckspdOhOCP9SRL//uBnPE8Ci5IxO9wbaqVDNk/InQ7kzar60JhnsRZLfvqgSR4k5j6MPXe7ct4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=b++FewPX; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="b++FewPX"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 03EF140E52
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1782577485; bh=8UtNI14qUP/qApC73hXztpsStGcuLHgTk0AYTTh/tx4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=b++FewPXQIhsJV90Djx9KlncZ8xI1edHIysIqAzSyW9XbbTi78I0SeScyMtERgQzC
	 0Hxsmy2e10cDREvhDWKjW04e+v6psqpwzASlKw6Y39hPbD7SVv1vN5WGCixaqVp2+V
	 Piwwa31zeLWDuVer8QWXcI0gJLHwfsWlNQYZhr9JdV+p5jUJHtsixmxjgIf/Tn2JnQ
	 aPTqHtt6FEUJXdkn8VDrA1Hdmietx48mu+hb44oUyUaVqNcnwLm6nG31UUtWqh8zOX
	 XIXRVBQEgBq5iADzEPIU1+8x03uKV47L8on2FXdbW5n46AA/0MXUHK5GKMC3X1wbNJ
	 2wRof3bjCWdgg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 03EF140E52;
	Sat, 27 Jun 2026 16:24:44 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebner@mailbox.org>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
 <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>, "open
 list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list
 <linux-kernel@vger.kernel.org>
Cc: Manuel Ebner <manuelebner@mailbox.org>
Subject: Re: [PATCH] Documentation: device-mapper: adopt new coding style of
 type-aware kmalloc-family
In-Reply-To: <20260627091506.29534-2-manuelebner@mailbox.org>
References: <20260627091506.29534-2-manuelebner@mailbox.org>
Date: Sat, 27 Jun 2026 10:24:44 -0600
Message-ID: <877bnkymr7.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Manuel Ebner <manuelebner@mailbox.org> writes:

> Change the Documentation to reflect this commit 69050f8d6d07 ("treewide: Replace
> kmalloc with kmalloc_obj for non-scalar types")
> kmalloc -> kmalloc_objs
>
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> ---
>  Documentation/admin-guide/device-mapper/statistics.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/device-mapper/statistics.rst b/Documentation/admin-guide/device-mapper/statistics.rst
> index 41ded0bc5933..2190b90118f8 100644
> --- a/Documentation/admin-guide/device-mapper/statistics.rst
> +++ b/Documentation/admin-guide/device-mapper/statistics.rst
> @@ -30,7 +30,7 @@ region, etc.  Unique region_ids enable multiple userspace programs to
>  request and process statistics for the same DM device without stepping
>  on each other's data.
>  
> -The creation of DM statistics will allocate memory via kmalloc or
> +The creation of DM statistics will allocate memory via kmalloc_objs or

A nit, but if you're going to fix the function name, why not make it
kmalloc_objs() so that the automarkup code can do its magic?

Thanks,

jon
