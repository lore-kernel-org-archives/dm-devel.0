Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AB64A35
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 10:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743158143; cv=none; b=ldPWl8kpwf0g/Ki5lTg+9G0Y7O6Q29fogr+qowgvQsezShJDUgftMdTueOHcOWtvY1VwuZfbL1qJfTtzij4Mpfc+h7+H1gFs7EKaIbiwq+K4YJlJ9OsL6ADdzfy/kTJQHzmSnn6n3nkbPz/vq6VUDphBs2UgFiOr5ODwIjU77hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743158143; c=relaxed/simple;
	bh=Kgpzf0pwPxe1dvUmdDrGfEH+js6TEXN4iTEWCkzGnBE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=a/gC85l/wap4/GVNEhYTnQxdcaZMVspeNLo1Bs3jQhMtXwb0sAXFWq4Vb9WYrxHRapbkKczbA9MdKnG7bbPHCG3HpUNP2JIORBPrOdV9ww4PMZLsFD/Y6kLwMUBtTSXbqYLsMIFEyu6nTJ4vnievfJa4qlGknVQPf9/hhK8+nHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDK6jW6W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDK6jW6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743158141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9mqZSUh7VEXz/M7ICmEmr0Ia4+eg9cWAgrrWVSSGL9k=;
	b=gDK6jW6W3d85qH78IKbr64079eaPvqR/4U46jD5D6zJJoFOk3OvPwaUNqjbRz4RBLwtLRK
	/7Ml8Z79jHC91h2S7Yf0yPpj0W8ywNrRq34+0fvSNYRGU3V0PlzZJP6Z2Zjcvju2Upu1ob
	aIP+HluMGbZpRKwUNJnlcucj6uhtCvU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-_W2B60J9N4KCsjYVCb6Biw-1; Fri,
 28 Mar 2025 06:35:39 -0400
X-MC-Unique: _W2B60J9N4KCsjYVCb6Biw-1
X-Mimecast-MFC-AGG-ID: _W2B60J9N4KCsjYVCb6Biw_1743158138
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18E8619560BA;
	Fri, 28 Mar 2025 10:35:38 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12A1A1828A84;
	Fri, 28 Mar 2025 10:35:35 +0000 (UTC)
Date: Fri, 28 Mar 2025 11:35:31 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com, 
    ebiggers@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH] dm-verity: pass correct bytes to verity_use_bh
In-Reply-To: <20250328004056.2071351-1-weilongping@oppo.com>
Message-ID: <55d54787-6e34-27e0-8900-b9490312dd4f@redhat.com>
References: <20250328004056.2071351-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3vO1i5RPMMCk44CbFuyPSnDDy3BEdZjOtYbZpO99by8_1743158138
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 28 Mar 2025, LongPing Wei wrote:

> bi_size is always 0 here since the iterator was already advanced.
> 
> Fixes: 8cf3ae875ee4 ("dm-verity: support block number limits for different ioprio classes")
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-verity-target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 2ed10b4c63c5..40448a8c74b1 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -689,6 +689,7 @@ static void verity_end_io(struct bio *bio)
>  {
>  	struct dm_verity_io *io = bio->bi_private;
>  	unsigned short ioprio = IOPRIO_PRIO_CLASS(bio->bi_ioprio);
> +	unsigned int bytes = io->n_blocks << io->v->data_dev_block_bits;
>  
>  	if (bio->bi_status &&
>  	    (!verity_fec_is_enabled(io->v) ||
> @@ -699,7 +700,7 @@ static void verity_end_io(struct bio *bio)
>  	}
>  
>  	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
> -		verity_use_bh(bio->bi_iter.bi_size, ioprio)) {
> +		verity_use_bh(bytes, ioprio)) {
>  		if (in_hardirq() || irqs_disabled()) {
>  			INIT_WORK(&io->bh_work, verity_bh_work);
>  			queue_work(system_bh_wq, &io->bh_work);
> -- 
> 2.34.1

OK, I merged both patches into the existing patch.

Mikulas

