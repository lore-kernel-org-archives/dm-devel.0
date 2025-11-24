Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224292F60DB
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763981033; cv=none; b=q8AZiuZKkn2qGC1tT3WROus7AUwnLp1X/eGwFaDBWoeugYeRpHHuI8uUUCBLcDwG6hb+fKUdHP3k36yEq60KOzqikGjCLpUAZcW1MwBJioh20ZYB8kgwSyrZcug1ww3V82YKuZEOojbLgc/+i4tSSYXduRZaWo3q2J05/3rYlBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763981033; c=relaxed/simple;
	bh=CxCA4y8/BJ/JwLUdxkmwMqlMk1aZcH0moLk102MrHyE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0OYvM8//xKugV9wa+q4E7KS2MyFM31wgpyDcF2rp/H9sUdATNPnOuc3XnYzyq+3EfcxsBg3IPWeda3UpCeOxvahVbQcpP/l94KFnL1FV00SgFPT8uTwUPDsYNvAGHpOqJkwGx+wxF/24UKhol1KXIChEKj+xvBq03ifNAMf5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E2NRw5tT; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2NRw5tT"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5958187fa55so3203151e87.3
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 02:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763981029; x=1764585829; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P2PGWsdLhD0UHioq5spGbiC1oJojO375NQ+ltp+eNyk=;
        b=E2NRw5tTs7ofwHCEQ3wTE6LTc30XGbCZrb8VN/lQY7gTDVyjcQjD2N5Uz/jpjdAPeq
         SqIDEjJEDgYazCaWW8JHuH4HM/Te67+rjMxy4hb/SXHZC+4Q9S2nHz8dWlWnXtlkFIGh
         b24q5fR2/4YR9yGaBnMSVQMB1/mC70S4++/q7M6OtAz1Lef4vt7HywJ6c9Wo45OKbHGi
         SoP2KKmUZzLGGOYTjDICjgcfSf0N6XFzkt973hLqeF4zkr79Xxqp9ON+VyitQQxCgXAh
         j4YMFbrNeFt469AYj/qcDLTwI7ZmLVauEc9K4fEJPh4W1I+CQ2BoueP1MiKY/sHWkAG9
         KMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763981029; x=1764585829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2PGWsdLhD0UHioq5spGbiC1oJojO375NQ+ltp+eNyk=;
        b=QGNNVSM/Oehinms6pCLHRhfhUKrDlBHmMq2yd/CCOq0U/tZ4P5v3iQluCc87OpXpLg
         whlkfE2hvO11bWfhgJhdWuOlDtoz7E9G6gUfzZUp8lCjL2z6qVyxmpOu7wjsSrJzeKjp
         VQGd6PlrbLgEGPQjohp9xWEnIEw1QjbsiiP2WekM3ogxqEKFJFjPF7ma1IiCA8zsUKVI
         ty6RF0ZLlcoKLM3CHBw8w66mBC5xIpl1YiOWyx9uQJex1/SmNw8w1F75BJk1PJyJf06a
         GmQTbtJ7lTEqmTHPhc988E3y9wan8eew2LwcBpUN56vrHtliPrXvCfA2qME5btlfZh4G
         dZpA==
X-Forwarded-Encrypted: i=1; AJvYcCUzgCKQo1hs0XF69RsjbSy04DKn/td4qhKfxEqNd+5uxci0k6xcuOb51W+48tzLvkFgNFo3TBhYTg==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo9qOv7kdYxXnQCRsfjb0c66AyrGoXTMHUqjiJP3DbDEMGduor
	s61tcQFEtawK4wNBRmR0VOGr0sAi2BOIEfcXnpFwisIa3pJPbTIJhf1M
X-Gm-Gg: ASbGnctdOCZbPhArcTlThXouMf9oeoSm4Xqi4TyxR0YjDk0JIBrLy6WRl2ollEBR178
	m6qjLiZtbRoRrhPMRgxQC51CKUyPDbrDQb86fn71ZuAnzSDVyPEey+9yX9qnVT7g/pYYDp4adqJ
	YGYDHaB6i2VCSzXWul7Pb/1thPlXOppmDFerfv0Z4fTqko8raVtO5kWZMMrl4U6OczQPDRDEwIB
	PCUoqRMTO6J21I7nzAJDGLm2Tf1ZO2NOCAreq/WbONtJkfn08tPHOSVpvI7aWzwZ8V/xT8my0mN
	xRFoMz9j3BRGJftmtdylmFIif5chPulifRD7mBdaLJjAUgtDsdrVtfpsmB2gcs6P4FX/DHfeRsi
	x6QzJKYgsY6YP3dttRG6O/yRGayy0TfDJ3ESIG6Iux5RWRX4TFlIp
X-Google-Smtp-Source: AGHT+IH3Uk9Kti1JIogEMznrVti6mi0YSJi04pQ9ed/XWX3dCfZJseuziaeO9Kv9YU8kLBUfkg7l5g==
X-Received: by 2002:a05:6512:3e27:b0:594:347e:e679 with SMTP id 2adb3069b0e04-596a3eddb0dmr3282352e87.43.1763981028847;
        Mon, 24 Nov 2025 02:43:48 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5969dbcc936sm4024190e87.89.2025.11.24.02.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 02:43:48 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 24 Nov 2025 11:43:46 +0100
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aSQ24uN3A7PAo7VY@pc636>
References: <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
 <aR8E2ZZtOi0RZt06@pc636>
 <20251121072421.GA29754@lst.de>
 <aSBnXqX9jmoKuv4Y@pc636>
 <aSCX7MNcRBWwrD6g@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSCX7MNcRBWwrD6g@redhat.com>

> On Fri, Nov 21, 2025 at 02:21:34PM +0100, Uladzislau Rezki wrote:
> > On Fri, Nov 21, 2025 at 08:24:21AM +0100, Christoph Hellwig wrote:
> > > On Thu, Nov 20, 2025 at 01:08:57PM +0100, Uladzislau Rezki wrote:
> > > > Could you please check below? Is the last one is correctly reported?
> > > 
> > > The latter looks unexpected, but is is becase qemu is not passing through
> > > the qemu physical_block_size attribute to any of the nvme settings Linux
> > > interprets as such for NVMe (NVMe doesn't actually have the concept of
> > > a physical block size, unlike SCSI/ATA):
> > > 
> > OK, understood and thank you for checking this.
> > 
> > >
> > > root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep npw
> > > npwg    : 0
> > > npwa    : 0
> > > root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep naw
> > > nawun   : 0
> > > nawupf  : 0
> > > root@testvm:~# nvme id-ctrl -H /dev/nvme0 | grep awupf
> > > awupf     : 0
> > > 
> > > but as said multiple times, that should not really matter - the logical
> > > block size is the granularity of I/O, the physical block size is just
> > > a performance hint.
> > >
> > Right.
> > 
> > As stated in commit message of the patch which is in question. 8K
> > emulated in qemu device with CONFIG_TRANSPARENT_HUGEPAGE=y:
> > 
> > urezki@pc638:~$ sudo nvme list
> > Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
> > --------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> > /dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
> > urezki@pc638:~$ cat bin/dmsetup.sh
> > #!/bin/bash
> > 
> > lower=/dev/nvme0n1
> > len=$(blockdev --getsz "$lower")
> > 
> > echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
> > urezki@pc638:~$ sudo bin/dmsetup.sh
> > urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
> > 8192
> > urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
> > 8192
> > urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/logical_block_size
> > 512
> > urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/physical_block_size
> > 8192
> > urezki@pc638:~$ sudo mkfs.ext4 -F /dev/dm-0
> > mke2fs 1.47.0 (5-Feb-2023)
> > /dev/dm-0 contains a ext4 file system
> >         last mounted on Fri Nov 21 12:22:55 2025
> > Discarding device blocks: done
> > Creating filesystem with 2072576 4k blocks and 518144 inodes
> > Filesystem UUID: f71adb05-c020-4406-bc0d-bdb9e5c29af7
> > Superblock backups stored on blocks:
> >         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
> > 
> > Allocating group tables: done
> > Writing inode tables: done
> > Creating journal (16384 blocks): done
> > Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
> > urezki@pc638:~$ sudo dmesg | grep -i "i/o"
> > [   71.813322] Buffer I/O error on dev dm-0, logical block 10, lost async page write
> > [   71.813373] Buffer I/O error on dev dm-0, logical block 11, lost async page write
> > [   71.813395] Buffer I/O error on dev dm-0, logical block 12, lost async page write
> > [   71.813415] Buffer I/O error on dev dm-0, logical block 13, lost async page write
> > [   71.813433] Buffer I/O error on dev dm-0, logical block 14, lost async page write
> > [   71.813451] Buffer I/O error on dev dm-0, logical block 15, lost async page write
> > [   71.813475] Buffer I/O error on dev dm-0, logical block 16, lost async page write
> > [   71.813493] Buffer I/O error on dev dm-0, logical block 17, lost async page write
> > [   71.813516] Buffer I/O error on dev dm-0, logical block 18, lost async page write
> > [   71.813537] Buffer I/O error on dev dm-0, logical block 19, lost async page write
> > urezki@pc638:~$
> > 
> > with the patch:
> > 
> > urezki@pc638:~$ sudo nvme list
> > Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
> > --------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> > /dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
> > urezki@pc638:~$ cat bin/dmsetup.sh
> > #!/bin/bash
> > 
> > lower=/dev/nvme0n1
> > len=$(blockdev --getsz "$lower")
> > 
> > echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
> > urezki@pc638:~$ sudo bin/dmsetup.sh
> > urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
> > 8192
> > urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
> > 8192
> > urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/logical_block_size
> > 512
> > urezki@pc638:~$ sudo cat /sys/block/dm-0/queue/physical_block_size
> > 8192
> > urezki@pc638:~$ sudo mkfs.ext4 -F /dev/dm-0
> > mke2fs 1.47.0 (5-Feb-2023)
> > Discarding device blocks: done
> > Creating filesystem with 2072576 4k blocks and 518144 inodes
> > Filesystem UUID: c7dff4c7-aa7e-4c94-98ee-f9ea2da92a06
> > Superblock backups stored on blocks:
> >         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
> > 
> > Allocating group tables: done
> > Writing inode tables: done
> > Creating journal (16384 blocks): done
> > Writing superblocks and filesystem accounting information: done
> > 
> > urezki@pc638:~$ sudo mount /dev/dm-0 /mnt/
> > urezki@pc638:~$ ls -al /mnt/
> > total 24
> > drwxr-xr-x  3 root root  4096 Nov 21 12:22 .
> > drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
> > drwx------  2 root root 16384 Nov 21 12:22 lost+found
> > urezki@pc638:~$
> > 
> > How do we solve this?
> > 
> > Mikulas proposed to use below patch:
> > 
> > <snip>
> > Index: linux-2.6/drivers/md/dm-bufio.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-bufio.c        2025-10-13 21:42:47.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-bufio.c     2025-10-20 14:40:32.000000000 +0200
> > @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
> >  {
> >         unsigned int n_sectors;
> >         sector_t sector;
> > -       unsigned int offset, end;
> > +       unsigned int offset, end, align;
> > 
> >         b->end_io = end_io;
> > 
> > @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
> >                         b->c->write_callback(b);
> >                 offset = b->write_start;
> >                 end = b->write_end;
> > -               offset &= -DM_BUFIO_WRITE_ALIGN;
> > -               end += DM_BUFIO_WRITE_ALIGN - 1;
> > -               end &= -DM_BUFIO_WRITE_ALIGN;
> > +               align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> > +               offset &= -align;
> > +               end += align - 1;
> > +               end &= -align;
> >                 if (unlikely(end > b->c->block_size))
> >                         end = b->c->block_size;
> > <snip>
> > 
> > and it fixes the setup which i described in the commit message, but i
> > have question.
> > 
> > Why in dm-ebs we need to offload partial buffer < ubf size?
> 
> Um, did you notice that Mikulas accepted your patch?
> 
I saw, he mentioned that and i am glad that during this discussion
we came to one more extra patch. I got the feeling that there were
misunderstanding between us, so i decided to make it more clear
that is it.

Thank you.

--
Uladzislau Rezki
