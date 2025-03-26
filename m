Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC0E1D4356
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742987096; cv=none; b=Vr/tBXLXnpliuSgwR/8rJ8Ns1NpoY7ffXQia0mcHo+qJLL6BqLy8xdJwQw/gU/s425Cm+QnVbZKmw4VJS9GXWLowJ4RlUaum+JsOZUXt7/7mKyjDl35+NXms2Z5h00ZwrOwMNZ9na5CF6x4aWa4XRVk3caOgHxrDaFz2S2ft13w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742987096; c=relaxed/simple;
	bh=0cZyWaX/gQo4bamLP6fQwNhY3A/aOkn65ocTbF+EtCk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VIAquOgMx/PJS6Vj70nTLcQJzuy0uAo2jTDI8jx+IbBKtJatEgP1lZrNQFCEBtxKPUjwwWOx5Wy/q7w693E+ys1Xwia+Bpek+ODpiQ5U9mI9hAIjZppzcd70IYtZxUcJ3UaP0oMV1KiIq1Ws0/NjgOSsWeZnxvlp4AP1i/nMzxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=htAz0bBx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="htAz0bBx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742987094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/t9awXKUA14OwKiV6sSDvF1NTBD2trHXytJaD40+aU=;
	b=htAz0bBx+G9sup/x8bSor5raNCd4y40kBrejOEE/0uUGzJ1jKO9aMR0G1+1zUxEPgUHatr
	WlSRiLfnZtQe7BehmfCJwplGMZhvExEduiwANEDQpfchbb3uSzn10iFSAL9huDrcY8Or58
	mci9pht/0wx5bGL9WCjfWJa+skNk7Pw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-0qfI9tZINpagUe2WrPlUsQ-1; Wed,
 26 Mar 2025 07:04:48 -0400
X-MC-Unique: 0qfI9tZINpagUe2WrPlUsQ-1
X-Mimecast-MFC-AGG-ID: 0qfI9tZINpagUe2WrPlUsQ_1742987088
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2C8C196D2DC;
	Wed, 26 Mar 2025 11:04:47 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC24D1801750;
	Wed, 26 Mar 2025 11:04:45 +0000 (UTC)
Date: Wed, 26 Mar 2025 12:04:41 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: agk@redhat.com, dm-devel@lists.linux.dev, guoweichao@oppo.com, 
    snitzer@kernel.org
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <20250326013049.1292617-1-weilongping@oppo.com>
Message-ID: <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com> <20250326013049.1292617-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4UUYr81vJRTxRhv44BQpR6fBwgdV7fncgmEmwZY9YNo_1742987088
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 26 Mar 2025, LongPing Wei wrote:

> Calling verity_verify_io in bh for IO of all sizes is not suitable for
> embedded devices. From our tests, it can improve the performance of 4K
> synchronise random reads.
> For example:
> ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
>  --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
>  --filename=/dev/block/mapper/xx-verity
> 
> But it will degrade the performance of 512K synchronise sequential reads
> on our devices.
> For example:
> ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
>  --numjobs=8 --runtime=60 --time_based --group_reporting \
>  --filename=/dev/block/mapper/xx-verity
> 
> A parameter array is introduced by this change. And users can modify the
> default config by /sys/module/dm_verity/parameters/use_bh_bytes.
> 
> The default limits for NONE/RT/BE/IDLE is set to 4096.
> 
> Call verity_verify_io directly when verity_end_io is in softirq.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>

Are you sure that 4096 bytes is the correct threshold?

I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k, 
256k, 512k and set the default threshold to the largest value where bh 
code performs better than non-bh code.

Mikulas

