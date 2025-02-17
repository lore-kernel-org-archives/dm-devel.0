Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FACF217F48
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 10:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739788664; cv=none; b=E+6yXk0R0bi8ire1vpx34N2XKkWgcKU6TCu8QYXWL3DnyuCaJMXCzjOndetMb/E0NZY5kQODJ1i5ehQ2XxYvqR1zoaFVJScmY6nZKxg+H9pdii//eYtHZLCYNeImF3O18FglEMeOoB/IaDjsDj3fquqtTW8FdeiGZHfR5pHmD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739788664; c=relaxed/simple;
	bh=/bzErt8G8FR8t19khjbds1mKwjOt8namzpNBNSdxkO8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IXmFqwcA7LV36m/s+C2MqurKDOL+lr8VwmUhHDjKSp7ZekgGRlULU0/SsXIctbwg9VJT0FCjAx/oe7louMtKAEkjYIOdOyNx8A9a9VVppqiqwATrYC6e5EAcQZ94PrBPzTUGdRVfgFfzJVJtNC6bJic5xvBrjuTPZQ4yR/XWmeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RqyYHqUb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RqyYHqUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739788659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3QnuqXmgdzniJaLsLCeMzB55GWfy15gVerT6MR0b5Q=;
	b=RqyYHqUbq9fy825f1w3BKHZkx/wN5kbJt+GM8ont03t63Pjo4ZKnTS1i86UUxc4UUaZ32n
	lOPthM4PyrBG1Ro5VSwmvRVUS/2NnzmmkcrYU/ywkXclvvAAqhGcfBHCOvEc8iM9/alU2B
	5xu5bgCpaphuolZ2oSyYjhlMLDee1Mc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-a8Jdl3BLPTupGR9toQtJGA-1; Mon,
 17 Feb 2025 05:37:37 -0500
X-MC-Unique: a8Jdl3BLPTupGR9toQtJGA-1
X-Mimecast-MFC-AGG-ID: a8Jdl3BLPTupGR9toQtJGA_1739788656
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B4D21800873;
	Mon, 17 Feb 2025 10:37:36 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B885300018D;
	Mon, 17 Feb 2025 10:37:34 +0000 (UTC)
Date: Mon, 17 Feb 2025 11:37:30 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] dm-integrity: Avoid divide by zero in table status
 in Inline mode
In-Reply-To: <20250216104210.572120-1-gmazyland@gmail.com>
Message-ID: <457c7061-2e0a-6a33-ab3c-3a69b7be47c5@redhat.com>
References: <20250216104210.572120-1-gmazyland@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Sun, 16 Feb 2025, Milan Broz wrote:

> In Inline mode, the journal is unused, and journal_sectors is zero.
> 
> Calculating the journal watermark requires dividing by journal_sectors,
> which should be done only if the journal is configured.
> 
> Otherwise, a simple table query (dmsetup table) can cause OOPS.
> 
> This bug did not show on some systems, perhaps only due to
> compiler optimization.
> 
> On my 32-bit testing machine, this reliably crashes with the following:
> 
>  : Oops: divide error: 0000 [#1] PREEMPT SMP
>  : CPU: 0 UID: 0 PID: 2450 Comm: dmsetup Not tainted 6.14.0-rc2+ #959
>  : EIP: dm_integrity_status+0x2f8/0xab0 [dm_integrity]
>  ...
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
> Cc: stable@vger.kernel.org # 6.11+

Both patches applied, thanks.

Mikulas

