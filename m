Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2F3191A7
	for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 20:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763412547; cv=none; b=QGVjUm0E8oUKdKTu4RnBQOFixOgYE/3CamLaNFK1YH1ot4v8I5gCICzedfiovHE1Mg8ITTBpN69Iy4tlyC7R8tvJqAWBmWCVC2//kCG3XsGWwJ44st1qRC2Geo5OKCRzRYrGVUwUPpF0ALxeu8It+EplXEKlGt31G5oh7hjuSfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763412547; c=relaxed/simple;
	bh=ynQCbG6N/gXYZfkBDVHtvIWwpgnYwr6SxWbyOOzEM4A=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=URQcve7x1Ptjzd8oG/swynqi2znualh2MocgRBEiErSSVjH7B+kzaLd8JwRlcE3JKzafa6qVj4orjQAz8P+mici0hXFdq5t43SnmkF0MPIZAXsKenKYVCYWg9B7ze3oGdinN/fiIJF4CaBDYN/aFF7kS+RxWqeZoVaOxGoBhhq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DKZuMudV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DKZuMudV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763412544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJlXniEMfLKYKm86uGte1tV2pA7hG9A9kTBTHOH60vo=;
	b=DKZuMudVyfmO0+NZObZMHgunKT5ocB3wWaliSfgdo0kvrsdkkCIgHPZenRiX2bhqiorCGg
	IxH/MAZjIgcBMuNGj3Wq0LrzI0yHFXBNrnYqIWj5x/uKEZNhWNFby+ppoST6AVO5womj/R
	4lSK3m164LHkooUN3fX/YaA3HnLDO5s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-dExqWat7PpSzWhB7KhKbbA-1; Mon,
 17 Nov 2025 15:48:59 -0500
X-MC-Unique: dExqWat7PpSzWhB7KhKbbA-1
X-Mimecast-MFC-AGG-ID: dExqWat7PpSzWhB7KhKbbA_1763412538
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C574218AB40D;
	Mon, 17 Nov 2025 20:48:57 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA1F3180049F;
	Mon, 17 Nov 2025 20:48:54 +0000 (UTC)
Date: Mon, 17 Nov 2025 21:48:49 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
In-Reply-To: <20251117105945.10179-1-urezki@gmail.com>
Message-ID: <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
References: <20251117105945.10179-1-urezki@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi

What is the logical_block_size of the underlying nvme device? - i.e. 
what's the content of this file 
/sys/block/nvme0n1/queue/logical_block_size in the virtual machine?

Mikulas

On Mon, 17 Nov 2025, Uladzislau Rezki (Sony) wrote:

> When performing a read-modify-write(RMW) operation, any modification
> to a buffered block must cause the entire buffer to be marked dirty.
> 
> Marking only a subrange as dirty is incorrect because the underlying
> device block size(ubs) defines the minimum read/write granularity. A
> lower device can perform I/O only on regions which are fully aligned
> and sized to ubs.
> 
> This change ensures that write-back operations always occur in full
> ubs-sized chunks, matching the intended emulation semantics of the
> EBS target.
> 
> As for user space visible impact, submitting sub-ubs and misaligned
> I/O for devices which are tuned to ubs sizes only, will reject such
> requests, therefore it can lead to losing data. Example:
> 
> 1) Create a 8K nvme device in qemu by adding
> 
> -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> 
> 2) Setup dm-ebs to emulate 512B to 8K mapping
> 
> urezki@pc638:~/bin$ cat dmsetup.sh
> 
> lower=/dev/nvme0n1
> len=$(blockdev --getsz "$lower")
> 
> echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
> urezki@pc638:~/bin$
> 
> offset 0, ebs=1 and ubs=16(in sectors).
> 
> 3) Create an ext4 filesystem(default 4K block size)
> 
> urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
> mke2fs 1.47.0 (5-Feb-2023)
> Discarding device blocks: done
> Creating filesystem with 2072576 4k blocks and 518144 inodes
> Filesystem UUID: bd0b6ca6-0506-4e31-86da-8d22c9d50b63
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
> 
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
> urezki@pc638:~/bin$ dmesg
> 
> <snip>
> [ 1618.875449] buffer_io_error: 1028 callbacks suppressed
> [ 1618.875456] Buffer I/O error on dev dm-0, logical block 0, lost async page write
> [ 1618.875527] Buffer I/O error on dev dm-0, logical block 1, lost async page write
> [ 1618.875602] Buffer I/O error on dev dm-0, logical block 2, lost async page write
> [ 1618.875620] Buffer I/O error on dev dm-0, logical block 3, lost async page write
> [ 1618.875639] Buffer I/O error on dev dm-0, logical block 4, lost async page write
> [ 1618.894316] Buffer I/O error on dev dm-0, logical block 5, lost async page write
> [ 1618.894358] Buffer I/O error on dev dm-0, logical block 6, lost async page write
> [ 1618.894380] Buffer I/O error on dev dm-0, logical block 7, lost async page write
> [ 1618.894405] Buffer I/O error on dev dm-0, logical block 8, lost async page write
> [ 1618.894427] Buffer I/O error on dev dm-0, logical block 9, lost async page write
> <snip>
> 
> Many I/O errors because the lower 8K device rejects sub-ubs/misaligned
> requests.
> 
> with a patch:
> 
> urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
> mke2fs 1.47.0 (5-Feb-2023)
> Discarding device blocks: done
> Creating filesystem with 2072576 4k blocks and 518144 inodes
> Filesystem UUID: 9b54f44f-ef55-4bd4-9e40-c8b775a616ac
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
> 
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> urezki@pc638:~/bin$ sudo mount /dev/dm-0 /mnt/
> urezki@pc638:~/bin$ ls -al /mnt/
> total 24
> drwxr-xr-x  3 root root  4096 Oct 17 15:13 .
> drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
> drwx------  2 root root 16384 Oct 17 15:13 lost+found
> urezki@pc638:~/bin$
> 
> After this change: mkfs completes; mount succeeds.
> 
> v1 -> v2:
>  - reflect a user space visible impact in the commit message.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  drivers/md/dm-ebs-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> index 6abb31ca9662..b354e74a670e 100644
> --- a/drivers/md/dm-ebs-target.c
> +++ b/drivers/md/dm-ebs-target.c
> @@ -103,7 +103,7 @@ static int __ebs_rw_bvec(struct ebs_c *ec, enum req_op op, struct bio_vec *bv,
>  			} else {
>  				flush_dcache_page(bv->bv_page);
>  				memcpy(ba, pa, cur_len);
> -				dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + cur_len);
> +				dm_bufio_mark_buffer_dirty(b);
>  			}
>  
>  			dm_bufio_release(b);
> -- 
> 2.47.3
> 

