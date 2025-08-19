Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68031AF2D
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 09:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755595149; cv=none; b=Hg/c8woCbsBfwKTWHbtXy6YY38Ww9cMqcbAaoWS4GptCWwoFZKyTEXagOt32ojaZG5CrrZ33ZzLU4u0veyDDQI/FWvysQaJv4NSs7QcfDpmzWbxrkvJ3vDCf2MT7/ZqdjT5Yt9pIlKWG5UYGqhC/59cXRlYRU7I01myQVSeDzsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755595149; c=relaxed/simple;
	bh=9vwyyv6M8c/hl6Z5N7i4nf1QvVFHMShkdfD5zOPDfyc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Drh2H1z9ABbPBxlmiV2INuqZN6OyOX2RPDfqg8U2jxHOFkOgp+cS+zGKYnvgVYIWW8QeCyM9eswwCAe4ds8vX9bRrnBTGYvtH/rgEo0IPCggmmH/xl7+Kf1Pi/Gm0ygEnJ8YIuLvv0Ot1ZLZ1LRnpvAskDla7CPqNIfqwsjFZv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YCS2Pk0V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCS2Pk0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755595146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUvUjaL1BgW0A4kRuInofwLPACogF6eJZaXX6bWphNI=;
	b=YCS2Pk0VvkjVFLDln00uyvdzvs/4Ayt9yusVeBCahkvozmYa2Wsu72bDrWBWKUkeh/gEAY
	Zu+FSUP4/v6N6fu1uFYFm9ce0mq97vC0dhZ0gVbG0v5wtjoP1GUm04M/JfJQRG9xizfsI3
	rd2OmaM/nhd/cYzPNyOTElx3PkAs9X0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-ydRrXgQUOpyf2izVBtKYlA-1; Tue,
 19 Aug 2025 05:19:00 -0400
X-MC-Unique: ydRrXgQUOpyf2izVBtKYlA-1
X-Mimecast-MFC-AGG-ID: ydRrXgQUOpyf2izVBtKYlA_1755595140
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79302195F164;
	Tue, 19 Aug 2025 09:18:59 +0000 (UTC)
Received: from [10.22.80.227] (unknown [10.22.80.227])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83F3230001A5;
	Tue, 19 Aug 2025 09:18:57 +0000 (UTC)
Date: Tue, 19 Aug 2025 11:18:50 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    dan.carpenter@linaro.org
Subject: Re: [PATCH 0/2] dm-pcache: fix warnings found by smatch
In-Reply-To: <20250819034322.4109073-1-dongsheng.yang@linux.dev>
Message-ID: <62f88dff-4348-5b0f-bf0c-e60b128131d3@redhat.com>
References: <20250819034322.4109073-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5Rjr8jRR86Vw76IiY0hwB42p8X71VRUsI4oWhgQVqI8_1755595140
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 19 Aug 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 	Please help to apply these two changes into dm-6.18.
> It fixes two warnings found by smatch.
> 
> Thanx for the report from Dan.
> 
> Dongsheng Yang (2):
>   dm-pcache: fix uninitialized variable issue found by smatch
>   dm-pcache: fix an indenting issue found by smatch
> 
>  drivers/md/dm-pcache/cache_req.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> 2.43.0

Thanks. I folded them into the existing patch.

Mikulas

