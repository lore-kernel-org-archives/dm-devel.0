Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969DF1DFFD
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 12:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747656920; cv=none; b=koqdUBHLpXW/LKkxPVnqQMtCsIKtemVH4Hg2BXmYE+VJbcUZtZCBe+LuJLe/iJNZS+L/Z6GE9cVdCT9zfY/3leDp2Cj8d77I9x62DgDGHWKqJuXOjRSQuCnWrWN0Vz20Wvl/OkQoM6cTUEssb5At6uhWZxw21j+33ZebuNQC5LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747656920; c=relaxed/simple;
	bh=4kk67u0XGB0R4MzlZ/xRoRuUr+uiYX+/l3Pdihk1zZo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NU8dAI2rH+cZLefqTexQTwS5gE0FXTy4KYwrMMh8iymRV0fo+03VqBbYs20BBY7qOtfe3Sx0XjUlZpfE60O5JLcO0xWq4qtI220PjABKDBg0oW9HW5y5/Pz2zO4aDwEj3b0ZGtpE/6pRjZFyaoHO4T6iaEgpACr3jBg1fMPuNeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7K4/FhO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7K4/FhO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747656917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OFvItQUkD7Tf2Ef8tnYlfmQt5ZH1dAKyaC+l+C/WeUc=;
	b=E7K4/FhOdJnc+hIma40GvIsHoPdcc4EatH82n1g9+u5pWCB72EP8adPOqJOT5Z5R0acge5
	H8YjBu3ssEaqSaFdVKO1b23IxdDjp1UE/fcj65nvbm9cEXxMdY1hNMYmPWS0jubnj/jY7v
	RIv68UQFUJrpBwZ9oGxM1ViUUd5/vtQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-ZeJ-5dhzOASUcN43MxgAPw-1; Mon,
 19 May 2025 08:15:16 -0400
X-MC-Unique: ZeJ-5dhzOASUcN43MxgAPw-1
X-Mimecast-MFC-AGG-ID: ZeJ-5dhzOASUcN43MxgAPw_1747656915
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96AF518001D5;
	Mon, 19 May 2025 12:15:14 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE61719560AB;
	Mon, 19 May 2025 12:15:12 +0000 (UTC)
Date: Mon, 19 May 2025 14:15:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, zkabelac@redhat.com, 
    linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
In-Reply-To: <b560f87d-0072-91be-2a87-43f3510737d1@huaweicloud.com>
Message-ID: <068abc04-ffe4-e2df-95e8-9812031f6222@redhat.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com> <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com> <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com> <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com> <10db5f49-0662-49da-9535-75aded725950@huaweicloud.com>
 <b560f87d-0072-91be-2a87-43f3510737d1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Mon, 19 May 2025, Yu Kuai wrote:

> Hi,
> 
> Please ignore the last reply, I misunderstand your commit message, I
> thought you said dm-raid, actually you said mdraid, and it's correct,
> if read_bio faild raid1/10 will set badblocks which is not expected.
> 
> Then for reada head IO, I still think don't kill REQ_RAHEAD for
> underlying disks is better, what do you think about skip handling IO
> error for ead ahead IO?
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 657d481525be..b8b4fead31f3 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -380,7 +380,10 @@ static void raid1_end_read_request(struct bio *bio)
>                 /* This was a fail-fast read so we definitely
>                  * want to retry */
>                 ;
> -       else {
> +       else if (bio->bi_opf & REQ_RAHEAD) {
> +               /* don't handle readahead error, which can fail at anytime. */
> +               uptodate = 1;
> +       } else {
>                 /* If all other devices have failed, we want to return
>                  * the error upwards rather than fail the last device.
>                  * Here we redefine "uptodate" to mean "Don't want to retry"
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dce06bf65016..4d51aaf3b39b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -399,6 +399,9 @@ static void raid10_end_read_request(struct bio *bio)
>                  * wait for the 'master' bio.
>                  */
>                 set_bit(R10BIO_Uptodate, &r10_bio->state);
> +       } else if (bio->bi_opf & REQ_RAHEAD) {
> +               /* don't handle readahead error, which can fail at anytime. */
> +               uptodate = 1;
>         } else {
>                 /* If all other devices that store this block have
>                  * failed, we want to return the error upwards rather
> 
> Thanks,
> Kuai

I confirm that this patch fixes the test.

Tested-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas

