Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF3C7494
	for <dm-devel@lists.linux.dev>; Fri, 12 Sep 2025 20:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757710326; cv=none; b=A89M4GsQ4vW6vLiX9P6ca583qvDJgCxCJPEWyt23j1njjsC4z1Juf7m9TDIhCiGZkl95QG4A6hPjsehb7so/7oeeJBieoNiikcZreeDreQY5SmWm2iMmHrKy/r7T1U6JseJ8Ys9pY1tfWTARssu6xqtuPHdQgQMafz0SHLOkOi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757710326; c=relaxed/simple;
	bh=X6/S3HTyjC5lqnZgkbNhOQQqfHl9wAkxFVkvwpcpqis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hIgp6Hr2B60kU7hCfQTAjDCdX6mee5x13frUeWCYlE56Mx7VVKqvhdzJzrSdwiKtZe16lw0+gxlodfXl+5v71LaKOltgg262S7jdHV72Hv8eok2ctMvgHMCtUCPkBJxvFzoFqwn6Egn4r1cW3DC+A9+KNWZ8dYbtf53XhTn59qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YPehN50K; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YPehN50K"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cNmnb3rn6zm0yQq;
	Fri, 12 Sep 2025 20:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757710322; x=1760302323; bh=7iQgCfJ6CaYSs6qWcDMsyOLT
	p/Irx4bCOYV/eM0pR/U=; b=YPehN50Kn/m02CpSj0TAtXE6HhQzXOx6eaL3+XJi
	C6Jk6qQ8NYH0+z7YMPs9p5OSYwKyNKEDC1cItgAyztBr5ZCRUXnVyoNSV8Ab4wwR
	esQRxtpsiuVUjtz26CuGB+wEVU90RqMWnOveLW1dNn1Ilnt8OKdYUCUmXPQ6D0wa
	Vd+YjeaKcZQRO7fNF/yLdDRm4SQmjv2Mo4JYzgcMRY69hNU7D+UgDOZLsa1ZfR7h
	1VDmDZOlXgveTxbWGpGZ6g4CWbYv78GQvv0deNn8v5UUCrIub/PD2L2xeeah9vgw
	nYf/FgEysSTg2iDHNEityCcjZjDtH2Q7Vo//vBHdvmpYWA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8vAgC-iFE0aK; Fri, 12 Sep 2025 20:52:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cNmnW2kftzm0yQC;
	Fri, 12 Sep 2025 20:51:58 +0000 (UTC)
Message-ID: <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org>
Date: Fri, 12 Sep 2025 13:51:57 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dm: optimize REQ_PREFLUSH with data when using the
 linear target
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
 <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/25 12:56 PM, Mikulas Patocka wrote:
> If the table has only linear targets and there is just one underlying
> device, we can optimize REQ_PREFLUSH with data - we don't have to split
> it to two bios - a flush and a write. We can pass it to the linear target
> directly.

Thanks! Since this patch works fine on my test setup:

Tested-by: Bart Van Assche <bvanassche@acm.org>

> @@ -1996,11 +1993,19 @@ static void dm_split_and_process_bio(str
>   	}
>   	init_clone_info(&ci, io, map, bio, is_abnormal);
>   
> -	if (bio->bi_opf & REQ_PREFLUSH) {
> +	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0)) {
> +		if (map->flush_bypasses_map) {

How map->flush_bypasses_map makes submitting REQ_PREFLUSH bios that have
data safe is nontrivial so it's probably a good idea to explain this in
a comment.

> +			struct list_head *devices = dm_table_get_devices(map);
> +			if (devices->next == devices->prev)
> +				goto send_preflush_with_data;

Should it be explained in a comment that devices->next == devices->prev
checks whether there are either no elements or one element in the list
and that we know that the devices list is not empty?

> +		}
> +		if (bio->bi_iter.bi_size)
> +			io->requeue_flush_with_data = true;
>   		__send_empty_flush(&ci);
>   		/* dm_io_complete submits any data associated with flush */
>   		goto out;
>   	}
> +send_preflush_with_data:
>   
>   	if (static_branch_unlikely(&zoned_enabled) &&
>   	    (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)) {

Isn't it recommended to leave a blank line above goto labels rather than
below?

Thanks,

Bart.
