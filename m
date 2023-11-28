Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B295A0E4
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZL7dtzC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701180452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fQxu/Q+/3YRfoin23/gnMqXUeIr+YHYWByn9KpCUiOo=;
	b=RZL7dtzCIJdraeoWBAN8uNqJWyZFJj8nCwO7mp1ghcPeZoVMG204EkKpXmhaLHlRuRsSxy
	7aGHoiMhkYZ2Z6n8MDs2oFwjpJ/XdiYU28f5x5TGKZ9GxpJpAQnbGez5nfAAivIIK3xoNh
	N/r9sxnIG44TilJqCTcFzUee7eP3u4k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-iwcpNMSPMTaHQiZc-nN-HA-1; Tue, 28 Nov 2023 09:07:30 -0500
X-MC-Unique: iwcpNMSPMTaHQiZc-nN-HA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB44A101A53B;
	Tue, 28 Nov 2023 14:07:29 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3A71502A;
	Tue, 28 Nov 2023 14:07:29 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 90D0330C1A8C; Tue, 28 Nov 2023 14:07:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8E2303FB76;
	Tue, 28 Nov 2023 15:07:29 +0100 (CET)
Date: Tue, 28 Nov 2023 15:07:29 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yunlong Xing <yunlong.xing@unisoc.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, yibin.ding@unisoc.com, hongyu.jin@unisoc.com, 
    dongliang.cui@unisoc.com, xiuhong.wang@unisoc.com
Subject: Re: [PATCH] dm: increase the io priority of the kworker-kverityd
 process
In-Reply-To: <20231128094414.583666-1-yunlong.xing@unisoc.com>
Message-ID: <83e8ea6c-1d9-36d5-1c23-da686dbfaf80@redhat.com>
References: <20231128094414.583666-1-yunlong.xing@unisoc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Hi

This isn't correct - the workqueue process is reused by multiple work 
items - from dm-verity as well as from other subsystems - so you would be 
unexpectedly boosting priority of other tasks.

The correct solution would be to set the ioprio field of the outcoming 
bios in dm-bufio explicitely.

Mikulas


On Tue, 28 Nov 2023, Yunlong Xing wrote:

> From: Hongyu Jin <hongyu.jin@unisoc.com>
> 
> When obtaining the hash value of a high IO priority data block
> from the disk, the kverity-worker that obtains the hash will
> also have a high IO priority to avoid being blocked by other
> IO with low IO priority.
> 
> Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
> Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
> ---
>  drivers/md/dm-verity-target.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index e115fcfe723c..ade9c6734154 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -22,6 +22,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/string.h>
>  #include <linux/jump_label.h>
> +#include <linux/ioprio.h>
>  
>  #define DM_MSG_PREFIX			"verity"
>  
> @@ -639,7 +640,9 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
>  static void verity_work(struct work_struct *w)
>  {
>  	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
> +	struct bio *bio = dm_bio_from_per_bio_data(io, io->v->ti->per_io_data_size);
>  
> +	set_task_ioprio(current, bio->bi_ioprio);
>  	io->in_tasklet = false;
>  
>  	verity_fec_init_io(io);
> -- 
> 2.25.1
> 
> 

