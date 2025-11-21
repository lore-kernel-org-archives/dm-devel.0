Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617721A3BD7
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743735; cv=none; b=HLZjubJCo+f4JZZOhO8iS6p3fn2RoJ5Zcq56GiGxeP+rqNvr26v003msCBfAMMR9ZwwfkTRh70GowZAzV12ze/wHLJ+SW08WC/ythNTP9bvPLz0D/3roZ0iUiBqrmBW+Z+KUIy/k5eKRWC1gJV0VhYmYHAsXPGYNYUF06lW4Pvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743735; c=relaxed/simple;
	bh=Py+eUaG7KjKGE2UByt0X5KqgWPv3DKjcfHuHBSO/W5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+vo+WrEwBlPw3PhoVCwsbBhz7d9qaZl49cSJ+mh/yRXiDLnHRrHDLdTVHHXBQNX3+a9Vh3KLx8ErECN9eQKsW7FM5qadIVSoDqnmJyQVl9y6aoAwT5kDYbWrMylkywJqZmyousoLuNz/vbCOabx9+alvNLYfgdsiPUoWfuBvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UIhtrFuO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UIhtrFuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763743732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MG7U0FeK78zPIuCL+1OBmvgEb3SpMMFvrUNSSf8ey7M=;
	b=UIhtrFuOT7K0P89JnMObzMYWMMU/mTcuXs74128s1543JNdSdjsbCnJB++eCC4+1gtlc8P
	jUOqe8CKxsgzahMGp5tR2kJ6EdbsfQlZlyf/qp981n5o7Z/DqaJCF1JfVDUxPBw6r6PJM+
	/VPYqlpvtcApWIAkYypTkOU+fPu3NZQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-m5j9GWt5OvSX-IuIszzM9A-1; Fri,
 21 Nov 2025 11:48:48 -0500
X-MC-Unique: m5j9GWt5OvSX-IuIszzM9A-1
X-Mimecast-MFC-AGG-ID: m5j9GWt5OvSX-IuIszzM9A_1763743727
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B7A21800447;
	Fri, 21 Nov 2025 16:48:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75A6230044E7;
	Fri, 21 Nov 2025 16:48:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5ALGmjDK1021652
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 21 Nov 2025 11:48:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5ALGmiAl1021651;
	Fri, 21 Nov 2025 11:48:44 -0500
Date: Fri, 21 Nov 2025 11:48:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aSCX7MNcRBWwrD6g@redhat.com>
References: <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
 <aR8E2ZZtOi0RZt06@pc636>
 <20251121072421.GA29754@lst.de>
 <aSBnXqX9jmoKuv4Y@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSBnXqX9jmoKuv4Y@pc636>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Nov 21, 2025 at 02:21:34PM +0100, Uladzislau Rezki wrote:
> On Fri, Nov 21, 2025 at 08:24:21AM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 20, 2025 at 01:08:57PM +0100, Uladzislau Rezki wrote:
> > > Could you please check below? Is the last one is correctly reported?
> > 
> > The latter looks unexpected, but is is becase qemu is not passing through
> > the qemu physical_block_size attribute to any of the nvme settings Linux
> > interprets as such for NVMe (NVMe doesn't actually have the concept of
> > a physical block size, unlike SCSI/ATA):
> > 
> OK, understood and thank you for checking this.
> 
> >
> > root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep npw
> > npwg    : 0
> > npwa    : 0
> > root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep naw
> > nawun   : 0
> > nawupf  : 0
> > root@testvm:~# nvme id-ctrl -H /dev/nvme0 | grep awupf
> > awupf     : 0
> > 
> > but as said multiple times, that should not really matter - the logical
> > block size is the granularity of I/O, the physical block size is just
> > a performance hint.
> >
> Right.
> 
> As stated in commit message of the patch which is in question. 8K
> emulated in qemu device with CONFIG_TRANSPARENT_HUGEPAGE=y:
> 
> urezki@pc638:~$ sudo nvme list
> Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
> --------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> /dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
> urezki@pc638:~$ cat bin/dmsetup.sh
> #!/bin/bash
> 
> lower=/dev/nvme0n1
> len=$(blockdev --getsz "$lower")
> 
> echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
> urezki@pc638:~$ sudo bin/dmsetup.sh
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
> 8192
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
> 8192
> urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/logical_block_size
> 512
> urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/physical_block_size
> 8192
> urezki@pc638:~$ sudo mkfs.ext4 -F /dev/dm-0
> mke2fs 1.47.0 (5-Feb-2023)
> /dev/dm-0 contains a ext4 file system
>         last mounted on Fri Nov 21 12:22:55 2025
> Discarding device blocks: done
> Creating filesystem with 2072576 4k blocks and 518144 inodes
> Filesystem UUID: f71adb05-c020-4406-bc0d-bdb9e5c29af7
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
> 
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
> urezki@pc638:~$ sudo dmesg | grep -i "i/o"
> [   71.813322] Buffer I/O error on dev dm-0, logical block 10, lost async page write
> [   71.813373] Buffer I/O error on dev dm-0, logical block 11, lost async page write
> [   71.813395] Buffer I/O error on dev dm-0, logical block 12, lost async page write
> [   71.813415] Buffer I/O error on dev dm-0, logical block 13, lost async page write
> [   71.813433] Buffer I/O error on dev dm-0, logical block 14, lost async page write
> [   71.813451] Buffer I/O error on dev dm-0, logical block 15, lost async page write
> [   71.813475] Buffer I/O error on dev dm-0, logical block 16, lost async page write
> [   71.813493] Buffer I/O error on dev dm-0, logical block 17, lost async page write
> [   71.813516] Buffer I/O error on dev dm-0, logical block 18, lost async page write
> [   71.813537] Buffer I/O error on dev dm-0, logical block 19, lost async page write
> urezki@pc638:~$
> 
> with the patch:
> 
> urezki@pc638:~$ sudo nvme list
> Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
> --------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> /dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
> urezki@pc638:~$ cat bin/dmsetup.sh
> #!/bin/bash
> 
> lower=/dev/nvme0n1
> len=$(blockdev --getsz "$lower")
> 
> echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
> urezki@pc638:~$ sudo bin/dmsetup.sh
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
> 8192
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
> 8192
> urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/logical_block_size
> 512
> urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/physical_block_size
> 8192
> urezki@pc638:~$ sudo mkfs.ext4 -F /dev/dm-0
> mke2fs 1.47.0 (5-Feb-2023)
> Discarding device blocks: done
> Creating filesystem with 2072576 4k blocks and 518144 inodes
> Filesystem UUID: c7dff4c7-aa7e-4c94-98ee-f9ea2da92a06
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
> 
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> urezki@pc638:~$ sudo mount /dev/dm-0 /mnt/
> urezki@pc638:~$ ls -al /mnt/
> total 24
> drwxr-xr-x  3 root root  4096 Nov 21 12:22 .
> drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
> drwx------  2 root root 16384 Nov 21 12:22 lost+found
> urezki@pc638:~$
> 
> How do we solve this?
> 
> Mikulas proposed to use below patch:
> 
> <snip>
> Index: linux-2.6/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-bufio.c        2025-10-13 21:42:47.000000000 +0200
> +++ linux-2.6/drivers/md/dm-bufio.c     2025-10-20 14:40:32.000000000 +0200
> @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
>  {
>         unsigned int n_sectors;
>         sector_t sector;
> -       unsigned int offset, end;
> +       unsigned int offset, end, align;
> 
>         b->end_io = end_io;
> 
> @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
>                         b->c->write_callback(b);
>                 offset = b->write_start;
>                 end = b->write_end;
> -               offset &= -DM_BUFIO_WRITE_ALIGN;
> -               end += DM_BUFIO_WRITE_ALIGN - 1;
> -               end &= -DM_BUFIO_WRITE_ALIGN;
> +               align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> +               offset &= -align;
> +               end += align - 1;
> +               end &= -align;
>                 if (unlikely(end > b->c->block_size))
>                         end = b->c->block_size;
> <snip>
> 
> and it fixes the setup which i described in the commit message, but i
> have question.
> 
> Why in dm-ebs we need to offload partial buffer < ubf size?

Um, did you notice that Mikulas accepted your patch?

> 
> Thank you for answers!
> 
> --
> Uladzislau Rezki

