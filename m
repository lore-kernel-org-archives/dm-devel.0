Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E05226D05
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 16:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741018248; cv=none; b=cHjgkRBgXRXVVLOwzzwm8JLvtZ5jWuQvaebrfFHFVCNHXm2w39qAAxqk8/LqRJ8zP3NCH4xCIkvU9lxUmxPFHCOgK3VzkYuAVUqIjbjpdiBUir2XWhbFiFohfXk/OTdALDXDyvlKtOgZ5Y/JQaltUbhWdh0VsTFZLvDWt7HPJi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741018248; c=relaxed/simple;
	bh=lTiBD0Nb5wgFh0cqwOiHEIg6CbN4WvJ97FKBo4L2wGg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HF6HCZ9tQPaVKPWt5WwR9qky3kzDeZ12Db+n2cG9kcOCiQxrhHRfbd2802SXFTeYvqlkV4SjOCkXnkUHeVNV4E15WlJp54+xEqYuGyYuBneVfW/5KV4beLChG6AvkS1W3qDLOxONDl8ynez0DV8+aObLd+b/GCTmRiaquS5z1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TypuzGSb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TypuzGSb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741018245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mNh7Kci5c/4oXZJmvCbC7SBx/UyvEwxV3D7Je6nSjLo=;
	b=TypuzGSbG+yiMwVfj596pXirMw0hDp8ZWYnJ2BaGnJQUxLFGWRwuLgrLyIeM1+z9RmCLFI
	ERZcKRRhLuR6NqEEt+Q5h4lcDJLLhBlYqqskP2/XoIPsTOfJVAukNq4Ima5Id2Ub8iVbm7
	2dPnv5jFuZ5Su6L3yxhcp1lYtR1HxqA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-Xe6mJXQ2OgaPBUW78ni5wQ-1; Mon,
 03 Mar 2025 11:10:39 -0500
X-MC-Unique: Xe6mJXQ2OgaPBUW78ni5wQ-1
X-Mimecast-MFC-AGG-ID: Xe6mJXQ2OgaPBUW78ni5wQ_1741018238
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FDAD1801A1D;
	Mon,  3 Mar 2025 16:10:38 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C185119560AA;
	Mon,  3 Mar 2025 16:10:36 +0000 (UTC)
Date: Mon, 3 Mar 2025 17:10:32 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming-Hung Tsai <mtsai@redhat.com>
cc: dm-devel@lists.linux.dev, Joe Thornber <thornber@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH v2 0/2] dm cache: support shrinking the origin device
In-Reply-To: <20250303155332.45339-1-mtsai@redhat.com>
Message-ID: <b1219fb2-b60f-5a04-6b63-462a92e46b29@redhat.com>
References: <20250303155332.45339-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E6Z0ZV39VgkhLYGVH5qq7_p7lqV1KlgmH-lAhx8cZPo_1741018238
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 3 Mar 2025, Ming-Hung Tsai wrote:

> This patch series introduces formal support for shrinking the cache
> origin and ensures that failed resume attempts, such as those caused
> by shrinking failures, do not trigger BUG_ON.
> 
> The only change in v2 patchset is the updated dm-cache's version number.
> 
> Ming-Hung Tsai (2):
>   dm cache: prevent BUG_ON by blocking retries on failed device resumes
>   dm cache: support shrinking the origin device
> 
>  drivers/md/dm-cache-target.c | 96 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 93 insertions(+), 3 deletions(-)
> 
> -- 
> 2.47.0

Ok, I increased the version number.

Mikulas

