Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5765728383
	for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-777745f1541so457993185a.0
        for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 11:19:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700075939; x=1700680739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78UuAtipIZ8GmhbzCifsUVbGef3yo/47opetMAHEqdg=;
        b=V1kUODHVX1Z4uFuluBJnopNLmP5/t6EnaaWpaHhLEJcIRMsv1LygVpgpIbyrXMX9dK
         6yBWn+6zFef1dlRbBh1Xj0q7LswP26p6cn6H1IpmN7ssirnak1cd5VL0eHoQs7EkQAV5
         EHz2IMsJcNBQo/REvqe5sPJ6bKvt7AWxp2QlKzjtaJnXPqTujP8H/RaTTMiYL6lbMj++
         0gpslk6Omb2p/mexxhtyLjhTiXffo7KCXR2qMtFzg6Y+Vi9Q62GFXpHFlZCN7NrsIKIn
         GBuHOI86VB2m4QyjqfrzPcgnkH2qOtN+/afkTlT7pzJ23Wgsro3xDsscs6bQ2FqpVjAu
         hhuw==
X-Gm-Message-State: AOJu0YxS8pr2h6yZo3X8ZXZvJdz26JZGc/CG2fWamhStCXzkC2Db+BJa
	+amSjokMcocb/PJJbdAoIGEP1jmFBItACnMvbA==
X-Google-Smtp-Source: AGHT+IFa7VL66knzfiwPn20E4FjS0AwJIPoFfRpDOiyI0jJPNRAzj3NOOZ5zqdMxlBJixfnTVRWWNA==
X-Received: by 2002:a05:6214:2349:b0:677:9f7b:6a01 with SMTP id hu9-20020a056214234900b006779f7b6a01mr9346513qvb.23.1700075939146;
        Wed, 15 Nov 2023 11:18:59 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ej8-20020ad45a48000000b006715ebb014fsm760786qvb.36.2023.11.15.11.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 11:18:58 -0800 (PST)
Date: Wed, 15 Nov 2023 14:18:57 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Yarden Maymon <yarden.maymon@volumez.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, thornber@redhat.com
Subject: Re: dm-thin: Improve performance of O_SYNC IOs to mapped data
Message-ID: <ZVUZoe7kqcouR0QN@redhat.com>
References: <20231029161756.27025-1-yarden.maymon@volumez.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231029161756.27025-1-yarden.maymon@volumez.com>

On Sun, Oct 29 2023 at 12:17P -0400,
Yarden Maymon <yarden.maymon@volumez.com> wrote:

> Running random write fio benchmarks on dm-thin with mapped data
> there is 50% degradation when using O_SYNC.
> * dm-thin without O_SYNC - 438k iops
> * dm-thin with O_SYNC on mapped data - 204k iops
> * directly on the underlying disk with O_SYNC - 451k iops, showing the
>   problem is not the disk.
> 
> The data is mapped so the same results are expected with O_SYNC.
> 
> Currently, all O_SYNC IOs are routed to a slower path (deferred).
> This action is taken early in the procedure, prior to assessing other
> ongoing IOs or verifying if the IO is already mapped.
> 
> Remove the early test, and move O_SYNC to the regular data path.
> O_SYNC io to a mapped space, that does not conflict with other inflight
> will be remapped and routed to the faster path.
> All the other O_SYNC io's behavior is maintained (deferred).
> 
> The O_SYNC IO will be deferred if :
> 
> * It is not mapped - dm_thin_find_block will return -ENODATA, the cell
>   is deferred.
> 
> * There is an inflight to the same virtual key - bio_detain will
>   add the io to a cell and defer it.
> 
>     build_virtual_key(tc->td, block, &key);
>     if (bio_detain(tc->pool, &key, bio, &virt_cell))
>         return DM_MAPIO_SUBMITTED;
> 
> * There is an inflight to the same physical key - bio_detain will
>   add the io to a cell and defer it.
> 
>     build_data_key(tc->td, result.block, &key);
>     if (bio_detain(tc->pool, &key, bio, &data_cell)) {
>         cell_defer_no_holder(tc, virt_cell);
>         return DM_MAPIO_SUBMITTED;
>     }

One of thinp's biggest reasons for deferring flushes is to coalesce
associated thin-pool metadata commits.

Your change undermines bio_triggers_commit() -- given that a flush
will only trigger a commit if routed through process_deferred_bios().

This raises doubts about the safety of your change (despite your
documented testing).

> 
> -----------------------------------------------------
> 
> Benchmark results :
> 
> The benchmark was done on top of ubuntu's 6.2.0-1008 with commit
> 450e8dee51aa ("dm bufio: improve concurrent IO performance") backported.
> 
> fio params: --bs=4k --direct=1 --iodepth=32 --numjobs=8m --time_based
> --runtime=5m.
> dm-thin chunksize is 128k and allocation/thin_pool_zero=0 is set.
> The results are in IOPs and represented as: avg_iops (max_iops).
> 
> Performance test on the underlying nvme device for baseline:
> +-------------------+-----------------------+
> | randwrite         | 446k (455k)           |
> | randwrite sync    | 451k (455k)           |
> | randrw 50/50      | 227k/227k (300k/300k) |
> | randrw sync 50/50 | 227k/227k (300k/300k) |
> | randread          | 773k (866k)           |
> | randread sync     | 773k (861k)           |
> +-------------------+-----------------------+
> 
> dm-thin blkdev with all data allocated (16GiB):
> +-------------------+-----------------------+-----------------------+
> |                   | Pre Patch             | Post Patch            |
> +-------------------+-----------------------+-----------------------+
> | randwrite         | 438k (442k)           | 450k (453k)           |
> | randwrite sync    | 204k (228k)           | 450k (454k)           |
> | randrw 50/50      | 224k/224k (236k/235k) | 225k/225k (234k/234k) |
> | randrw sync 50/50 | 191k/191k (199k/197k) | 225k/225k (235k/235k) |
> | randread          | 650k (703k)           | 661k (705k)           |
> | randread sync     | 659k (705k)           | 661k (707k)           |
> +-------------------+-----------------------+-----------------------+
> There's a notable enhancement in random write performance with sync
> compared to previous results. In the 50/50 sync test, there's also a
> boost in random read due to the availability of extra resources for
> reading. Furthermore, no other aspects appear to be impacted.

Not sure what you mean by "boost in random read due to the
availability of extra resources for reading." -- how does your change
make extra resources for reading?

> dm-thin blkdev without allocated data with capacity of 1.6TB (to
> increase the random chance of hitting a non allocated block):
> +-------------------+-------------------------+------------------------+
> |                   | Pre Patch               | Post Patch             |
> +-------------------+-------------------------+------------------------+
> | randwrite         | 116k (253k)             | 112k (240k)            |
> | randwrite sync    | 100k (121k)             | 182k (266k)            |
> | randrw 50/50      | 66.7k/66.7k (109k/109k) | 67k/67k (109k/109k)    |
> | randrw sync 50/50 | 76.9k/76.8k (101k/101k) | 77.6k/77.6k (122k/122k)|
> | randread          | 336k (349k)             | 335k (352k)            |
> | randread sync     | 334k (351k)             | 336k (348k)            |
> +-------------------+-------------------------+------------------------+
> In this case, there isn't a marked difference, with the exception of
> random write sync, since the unmapped data path has stayed the same. The
> boost in random write sync performance can be explained from random IOs
> hitting the same space twice within the test (The second time they are
> already mapped).
> 
> -----------------------------------------------------
> 
> Tests:
> I have ran thin tests of https://github.com/jthornber/dmtest-python.
> I have ran xfstests on top of thin lvm https://github.com/kdave/xfstests
> 
> I conducted a manual data integrity test :
> * Constructed a layout with nvme target -> dm-thin -> nvme device.
> * Using vdbench from an initiator host writing to this remote nvme
>   device, using journal to a local drive.
> * Initiated a reboot on the media host.
> * Verified the data using vdbench once the reboot process finished.
> 
> Signed-off-by: Yarden Maymon <yarden.maymon@volumez.com>
> ---
>  drivers/md/dm-thin.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 07c7f9795b10..ecd429260bee 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -2743,7 +2743,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_SUBMITTED;
>  	}
>  
> -	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
> +	if (bio_op(bio) == REQ_OP_DISCARD) {
>  		thin_defer_bio_with_throttle(tc, bio);
>  		return DM_MAPIO_SUBMITTED;
>  	}
> -- 
> 2.25.1
> 

Did you explore still deferring flush bios _but_ without imposing a
throttle?

Doing so would still punt to the workqueue to handle the flushes
(which could be a source of delay) but it avoids completely missing
thinp metadata commits.

Please revert your patch and try something like this instead:

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f88646f9f81f..704e9bb75b0f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2748,7 +2748,10 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	}
 
 	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
-		thin_defer_bio_with_throttle(tc, bio);
+		if (bio->bi_opf & REQ_SYNC)
+			thin_defer_bio(tc, bio);
+		else
+			thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
 
