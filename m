Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBC26E6F4
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731300; cv=none; b=LHd5ZfU5TYkFQ8aRzoHEC0s1si+9MPWp1R4VcSst0yPoj5lzl1msSJBmDnWyemCWo2HeP8n4N4sc5k65DqI1BtVfQYAznaRRHb2KfUfifJJF+u0zumFpQLv4G3sZEezT/BuWWQbACN75P9PNfzCmH7dTh6xicSA/mVd9/kKLcas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731300; c=relaxed/simple;
	bh=nl2Ah5lw6/NvHF0Hv+J6MtSi9ILBKTcajaAQ/aYHv+Y=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EX73F2xTNzKK3v2HG/thf+Sfly4zb99B2HYPqKzStD3bniJRowZRDeBtib/HplOS67Dl0MVkiR62b+m8G5RMRMXuh5hxad8eARugqJFx7bYEpqcpsMjYDlJ9idiAbS2zIkS1zekuEv+ZnkkxF+iPOJQt/5uNT7zHzT4D8B/0uSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BO4qLo1V; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BO4qLo1V"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-37bac34346dso15748261fa.2
        for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 05:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763731297; x=1764336097; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=79GwkU2/fy3f+SepLi3u1RyiaJD0RiWh7OhFW1VczvI=;
        b=BO4qLo1Vn+GSA7fMfKv+we3X972Z6mQZsDWxZglHFlhHiJVFvM86Jp4avvcR52H69l
         sMuRgAszNL1JAFCYoBeb2JPwAtqer4GG1lNszgJ27IdCBM60RBVeTqf4h53QM2rCBR5r
         DzNRnHTr1frXHdOuya9RKNR/Pe/1198h/XA6EpcZVXfNpds6Dag5ilEJruHywoLrIAZc
         U0LXp6X4d0mzi7CE77UVBYSExzzt18a8xclL42lKYQnY8UIQ6D0kj/WN9lhFE/iGCXhF
         JueeYfTJIZVl0jSyv5fGMimwDJniPHvzXdgHzM7Rv3300j1S3PYoxUnuY8d0gkZdhPud
         0NbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763731297; x=1764336097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79GwkU2/fy3f+SepLi3u1RyiaJD0RiWh7OhFW1VczvI=;
        b=H72TAN6hT0bigaOAtSd4S0IANlp0Uy2Qd6K9N9EVlHzUSVJXerCHfbrr6Q4g7gO0LV
         OrH5t9Ft2cdt4hcSroNxrHneGjK1jWf5t5AqeYNvSoUndP4Gxj54yj4qq/OSOAeYHBZn
         l4OfHF+THuZiA/PhThu43ipTqmZUMaTCeVHpJRotemkQPCrUMgHIP55SI6yaUzo1Tps4
         HW0ewOFXiKZfX6ENRUsDUvwEUjdTacUz4DRPhlKEDV3wCqVLt6aHjzm6/nwz2UnuGNMI
         vRT/NSt+dpp0DfoX4pZHQ7MKrmYSMS1wr3GNbxfEVyoNcB/Cccc3cRh94eCSndKpSL4G
         o0VA==
X-Forwarded-Encrypted: i=1; AJvYcCVSscxf3m3fJl9Fp9NITWOrujyTUdGe4Zcz3TYKuml5xnw44ZrKem/qwke+JYuk8b7IP956p19hlA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxkN5rGrPF3CCHNNdh9t2mc5V+ooQTT1OvyuvpaINplvnYjCnNv
	ooQNplg1APbAK0isfqelczkaJ3hONeFThAm3xM/jkyChFXCEXDeKxM2j
X-Gm-Gg: ASbGncvKCG8DjOnf1KGRNmtuvdhUCNKE6cmF3wG8MVoEa9buYnTPPBkB9S90C4o1MD3
	eXMCrMeN1i22Ql/SFVuVX1CaQVq11ZgNTw6E9dN7j7qfUBWnwNP+MBKccwl32cleH++czHvnObT
	LlCJbrrwNFmJaszTCt+s60LFC2gNkXTVdBWPvUV9e++kuJ4pXuEu1f4qwLmwQ206MbDYe5fc/Yb
	WimtMQouGrX98NEMsV25j9EyR27jjPytCsvBnmS1OtLOebNNKwPWdzTePX4Tv2fqDH/iwnLP1+E
	d91rozF0pFWByboNQ4e9j+6wyGHwTDYY93o38uNb8TCxFZjNxLA7bFs2HclpO/VnFt3zs1XwIza
	JfFT5ZTXkfpXVCa3cIaSegyECms8YGVLvcrMavbG2AuJ8Ryt09+dTKdwMzcjrfLPBXWRYsMI0Ai
	tvtI4SYY/zEADgf7ZsYDLS93FqIA1IrSeFSLtyg6Qy
X-Google-Smtp-Source: AGHT+IE6eqBNnnsPc/kl4pBOnRsoJFDtFinObeP8AvNr0yenZJ5OZ1u/FVuBTd4dSwaQrAWxv6AjhA==
X-Received: by 2002:a2e:954c:0:b0:37b:575d:6403 with SMTP id 38308e7fff4ca-37cd91ac037mr5652341fa.6.1763731296665;
        Fri, 21 Nov 2025 05:21:36 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37cc6b4b49bsm11323141fa.4.2025.11.21.05.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 05:21:36 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 21 Nov 2025 14:21:34 +0100
To: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aSBnXqX9jmoKuv4Y@pc636>
References: <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
 <aR8E2ZZtOi0RZt06@pc636>
 <20251121072421.GA29754@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121072421.GA29754@lst.de>

On Fri, Nov 21, 2025 at 08:24:21AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 20, 2025 at 01:08:57PM +0100, Uladzislau Rezki wrote:
> > Could you please check below? Is the last one is correctly reported?
> 
> The latter looks unexpected, but is is becase qemu is not passing through
> the qemu physical_block_size attribute to any of the nvme settings Linux
> interprets as such for NVMe (NVMe doesn't actually have the concept of
> a physical block size, unlike SCSI/ATA):
> 
OK, understood and thank you for checking this.

>
> root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep npw
> npwg    : 0
> npwa    : 0
> root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep naw
> nawun   : 0
> nawupf  : 0
> root@testvm:~# nvme id-ctrl -H /dev/nvme0 | grep awupf
> awupf     : 0
> 
> but as said multiple times, that should not really matter - the logical
> block size is the granularity of I/O, the physical block size is just
> a performance hint.
>
Right.

As stated in commit message of the patch which is in question. 8K
emulated in qemu device with CONFIG_TRANSPARENT_HUGEPAGE=y:

urezki@pc638:~$ sudo nvme list
Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
--------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
urezki@pc638:~$ cat bin/dmsetup.sh
#!/bin/bash

lower=/dev/nvme0n1
len=$(blockdev --getsz "$lower")

echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
urezki@pc638:~$ sudo bin/dmsetup.sh
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
8192
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
8192
urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/logical_block_size
512
urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/physical_block_size
8192
urezki@pc638:~$ sudo mkfs.ext4 -F /dev/dm-0
mke2fs 1.47.0 (5-Feb-2023)
/dev/dm-0 contains a ext4 file system
        last mounted on Fri Nov 21 12:22:55 2025
Discarding device blocks: done
Creating filesystem with 2072576 4k blocks and 518144 inodes
Filesystem UUID: f71adb05-c020-4406-bc0d-bdb9e5c29af7
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
urezki@pc638:~$ sudo dmesg | grep -i "i/o"
[   71.813322] Buffer I/O error on dev dm-0, logical block 10, lost async page write
[   71.813373] Buffer I/O error on dev dm-0, logical block 11, lost async page write
[   71.813395] Buffer I/O error on dev dm-0, logical block 12, lost async page write
[   71.813415] Buffer I/O error on dev dm-0, logical block 13, lost async page write
[   71.813433] Buffer I/O error on dev dm-0, logical block 14, lost async page write
[   71.813451] Buffer I/O error on dev dm-0, logical block 15, lost async page write
[   71.813475] Buffer I/O error on dev dm-0, logical block 16, lost async page write
[   71.813493] Buffer I/O error on dev dm-0, logical block 17, lost async page write
[   71.813516] Buffer I/O error on dev dm-0, logical block 18, lost async page write
[   71.813537] Buffer I/O error on dev dm-0, logical block 19, lost async page write
urezki@pc638:~$

with the patch:

urezki@pc638:~$ sudo nvme list
Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
--------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
urezki@pc638:~$ cat bin/dmsetup.sh
#!/bin/bash

lower=/dev/nvme0n1
len=$(blockdev --getsz "$lower")

echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
urezki@pc638:~$ sudo bin/dmsetup.sh
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
8192
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
8192
urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/logical_block_size
512
urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/physical_block_size
8192
urezki@pc638:~$ sudo mkfs.ext4 -F /dev/dm-0
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 2072576 4k blocks and 518144 inodes
Filesystem UUID: c7dff4c7-aa7e-4c94-98ee-f9ea2da92a06
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

urezki@pc638:~$ sudo mount /dev/dm-0 /mnt/
urezki@pc638:~$ ls -al /mnt/
total 24
drwxr-xr-x  3 root root  4096 Nov 21 12:22 .
drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
drwx------  2 root root 16384 Nov 21 12:22 lost+found
urezki@pc638:~$

How do we solve this?

Mikulas proposed to use below patch:

<snip>
Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c        2025-10-13 21:42:47.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c     2025-10-20 14:40:32.000000000 +0200
@@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
 {
        unsigned int n_sectors;
        sector_t sector;
-       unsigned int offset, end;
+       unsigned int offset, end, align;

        b->end_io = end_io;

@@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
                        b->c->write_callback(b);
                offset = b->write_start;
                end = b->write_end;
-               offset &= -DM_BUFIO_WRITE_ALIGN;
-               end += DM_BUFIO_WRITE_ALIGN - 1;
-               end &= -DM_BUFIO_WRITE_ALIGN;
+               align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
+               offset &= -align;
+               end += align - 1;
+               end &= -align;
                if (unlikely(end > b->c->block_size))
                        end = b->c->block_size;
<snip>

and it fixes the setup which i described in the commit message, but i
have question.

Why in dm-ebs we need to offload partial buffer < ubf size?

Thank you for answers!

--
Uladzislau Rezki
