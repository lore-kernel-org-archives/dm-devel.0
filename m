Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104A154452
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713214506; cv=none; b=A3MmQU2N8n0UXQLKqfVymvgSXOY4LQu47eUUNw25dM4lJbA39+jZobOe6UFw0/lskS9mCgkoOTg91kQ6YgC2AOVaHNUeJ/DaZBTAoVsN/Jx5bxx3pCqGE0Udgi/mbQmV+vt3HU54sjWb2sgkXFof6iEav428hsgofoj8FNR53M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713214506; c=relaxed/simple;
	bh=1kLbnkLpwA47PammM8c6gpt8Z5qGwHI0vHaz7g/GBT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MCMF7/wY+7AYtNtIT9B7QWS9saUhrI6NSBrx9SQuIJiryGxkZcb+8WzCAbtkQhjfPe4dSZmDaQZSJPnN6LIg5rEFBxCP8r+M2f6RwpTKO1iOBu45LxaV1EKZyDIb+oT0mves2CT1c3BC/l8l3RBgOqbm/Xaio1c31C5USw9viio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XShDe4rq; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XShDe4rq"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VJKDm1H3lzlgTHp;
	Mon, 15 Apr 2024 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1713214501; x=1715806502; bh=5o4zcRpA0zVDnfcPBNEvgwNg
	jNvZG1IbSS+iXwxvD58=; b=XShDe4rqHGZp1Dafps5mfGA7uz09NPnnhzEVdP/E
	Jsk/tZ8RX6qQ1XU/Zs3fPJ4CaxTSX2MTL7rNWxz1o5K8NTgFx6CJOxV74yHe04tN
	4dFwKTpIcTtqNEENwpu2DL8DdmRqUMYluJpKXvGEuxyHdt77XQLd3KXFetcB5NO0
	4g63O7g43Stk4jsZBGPGEu7yW4F78eNzwI4IyK8wYM/l+yeKNEYJ3I9Pmp4emH51
	BAAXU/qkdTSdwUGEKv0cOfSLSQx/4jgXoOihBDMccTnNNcBuMdk8bVDQzWScj6Rd
	EQg79fTq6/fWwI2ZPNU9KiejXkz/jSWRq9Ie0JkAlbdOPA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IyVkd_lmTHvf; Mon, 15 Apr 2024 20:55:01 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VJKDh1kypzlgTsK;
	Mon, 15 Apr 2024 20:54:59 +0000 (UTC)
Message-ID: <c107bba4-03a1-4121-af9e-7c93f40c24a0@acm.org>
Date: Mon, 15 Apr 2024 13:54:58 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Change the default value of rq_affinity from 0 into 1
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev,
 Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Daniel Lee <chullee@google.com>, stable@vger.kernel.org
References: <20240415194921.6404-1-bvanassche@acm.org>
 <20cf8b38-6c5b-9a10-6a7b-5d587a19eed@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20cf8b38-6c5b-9a10-6a7b-5d587a19eed@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/24 12:56, Mikulas Patocka wrote:
> I am wondering how should QUEUE_FLAG_SAME_COMP work for bio-based
> devices.
> 
> I grepped the kernel for QUEUE_FLAG_SAME_COMP and it is tested in
> block/blk-mq.c in blk_mq_complete_need_ipi (this code path is taken only
> for request-based devices) and in block/blk-sysfs.c in
> queue_rq_affinity_show (this just displays the value in sysfs). There are
> no other places where QUEUE_FLAG_SAME_COMP is tested, so I don't see what
> effect is it supposed to have.

I think the answer depends on whether or not the underlying device
defines the .submit_bio() callback. From block/blk-core.c:

static void __submit_bio(struct bio *bio)
{
	if (unlikely(!blk_crypto_bio_prep(&bio)))
		return;

	if (!bio->bi_bdev->bd_has_submit_bio) {
		blk_mq_submit_bio(bio);
	} else if (likely(bio_queue_enter(bio) == 0)) {
		struct gendisk *disk = bio->bi_bdev->bd_disk;

		disk->fops->submit_bio(bio);
		blk_queue_exit(disk->queue);
	}
}

In other words, if the .submit_bio() callback is defined, that function
is called. If it is not defined, blk_mq_submit_bio() converts the bio
into a request. QUEUE_FLAG_SAME_COMP affects the request completion
path. On my test setup there are multiple dm instances defined on top of
SCSI devices. The SCSI core does not implement the .submit_bio()
callback.

Thanks,

Bart.
