Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B5A330B35
	for <dm-devel@lists.linux.dev>; Fri, 17 Oct 2025 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716532; cv=none; b=ZDBlQLKVBJ4kmgar6jYRESis32Z/4IP4o4v1LfFVjQX2b2grkMOU+FlDzZawTsni+5lmxchKu71YHqBmmheHIJYfLP3gDir0iZMI4EDCBRPlZ609dQipK8xeg8E4IwyK57Z5f19Q9g/rdh7HgbLRDHFpFdFJRR4VEXWQJUSgeXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716532; c=relaxed/simple;
	bh=1tvSfTHGurP+YgnYoYArqQ4i1F37sHNvWcmfmhmMExM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2m6atu+aTezHFFYL2coF8G07xA3pgd6NQNR6bw/c3Tk8SElWJvriZPseesCwDWxIYOSdpdx6CY3qS6tXeAoM/0BOFy4+T8QUp4qjlWnrM6I7IR0vHh3yqqPFRY0C7W1N9+qI/1WgCNMHamJcIgaVzNIpQcRDSgwrUHICjO142M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QD1Ywsw9; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QD1Ywsw9"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37775ed97daso32326741fa.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Oct 2025 08:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760716528; x=1761321328; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RajXSrmZKy8qXDxaoJ6uPaA9OuJZXMNzYpFQjJFfOz0=;
        b=QD1Ywsw9VQv3zi9HwvbnVx/H2nPb8FQZW5Js5pTsIvZiYlRpPkPUJKAW+K2CbelpdJ
         U+nfJEdqTFOOcDUDhwxH79cwsaTQ/QQWy5/Y+Hw2HIcd/2M9ab6a4ZXVUB86OgjEN6mj
         cPaN9qGzWiqRbgeICmOcgUExFT5KfyMv9PACf1YCzC1FfWX31pP6Xg8XZV720xN8ij2K
         JrTO8PIDEeSUTrurv/c5EQ7ZWNNi9C1/otQNKmsZ21pkAie0HH1TZlstugeBdL5iHJl0
         M34nVPA0xRCf5+QB2Lbq4KLSW5aGiBeW2ReA/Z0q8fSMIfRmI/zU58GeD82tHSe8rwNE
         jP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760716528; x=1761321328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RajXSrmZKy8qXDxaoJ6uPaA9OuJZXMNzYpFQjJFfOz0=;
        b=vgVk5UI3cJXPh1/NY6X9OGnEuBGgRoPhkGztYEHtLLBCWWEM4SvOZjJit/zOy5tpqh
         RezyyAh7vTz/sw0txAHbKx8Gzjwk9j9A5HvjbI4EU2hHKJyc/5DfulLtLordLSE6wwg6
         e/Q0lwlOGF2CZQyYPqJgPgjtV0cJ+83uKO9qfYkiS6d44MoGj24FAF4DSdK3tRPCxQ6J
         DaCkx2JJTQeIZL7kt+V1LVrMKfC18rcSNH09zt57K9yfsmlhOggN8ojziT2ujO+D0k2L
         M4SDKJO/O9oKYVtUWmWRik/zPRZWStAS5aU+IPSLBjtjxLX07j9qu4lF+LRhUTuQxXlj
         IpEw==
X-Forwarded-Encrypted: i=1; AJvYcCWYt68juqIkfFUwix2fXWM6YWce4freS3FC336s7iwtLRU4mLaWJ2xcR4JtydjYY0bOLlUq+05exA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwGYVcBSdy7vdADrLr/hGJ34BxY8BHcauILJToUwqWgAFF37nHj
	qWOkoG9Rl9mmF96GBmFAMsFydFuvShdeKRdQbqpx6tLhjC1GQKRkCrKe
X-Gm-Gg: ASbGnctM6lExd9JqwEB3zNgb0PqiCZxef32K+pQXqAVsHY7U4bd7NC3+Ydtpwhp4TVT
	Chf6NjnvfAm6GGk5FwSNkliJja3xUXLM6BYYoEk/qBfbdQWBBxhs3imi+cdqPSpkGvAHD7HV3Eh
	k2H9376t0zRXxSPOZiw8T8q5Egr28gvrY0Doto/Ut3ZhhNAxWvdkpdWpY27ewZoKEmYlkcIywgB
	vLCBR2g4NOrusqrSD6ZrT85RNd2cd2JIE3PvQvB2cpsOmRfFJMf6W/qstBcKyRiNqE1Ejew4p8J
	cjvVPkgYwEsJTVfGbR0m9lzh/I2KMKeC/WmOSGHK0Bp7Bo+Y9E0epRTN+9gm4Q+JiNFb7hXnG/1
	PkKaYCvmUOvmiPWUowlpmANF8I7Xh4hKf746AVI+JRZ4SeQXlOYZJoQ==
X-Google-Smtp-Source: AGHT+IFTA12aXzaOiABKMYAu9IJovlveJhjnsuF7ZTZcu0BvXPxLXKDrAfPiJQtLGl23ibsv7H9gsg==
X-Received: by 2002:a2e:bc05:0:b0:352:91ce:b759 with SMTP id 38308e7fff4ca-377821386e4mr19184011fa.1.1760716528129;
        Fri, 17 Oct 2025 08:55:28 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-377a9586b2dsm331251fa.46.2025.10.17.08.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 08:55:27 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 17 Oct 2025 17:55:25 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
	DMML <dm-devel@lists.linux.dev>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aPJm7Y-O9IxiSBWQ@milan>
References: <20251014144731.164120-1-urezki@gmail.com>
 <20251016125951.27bb194ab31fe5c61f657a71@linux-foundation.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016125951.27bb194ab31fe5c61f657a71@linux-foundation.org>

On Thu, Oct 16, 2025 at 12:59:51PM -0700, Andrew Morton wrote:
> On Tue, 14 Oct 2025 16:47:31 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > When performing a read-modify-write(RMW) operation, any modification
> > to a buffered block must cause the entire buffer to be marked dirty.
> > 
> > Marking only a subrange as dirty is incorrect because the underlying
> > device block size(ubs) defines the minimum read/write granularity. A
> > lower device can perform I/O only on regions which are fully aligned
> > and sized to ubs.
> > 
> > This change ensures that write-back operations always occur in full
> > ubs-sized chunks, matching the intended emulation semantics of the
> > EBS target.
> 
> It sounds like this can result in corruption under some circumstances?
> 
> It would be helpful if you could spell this out clearly, please.  What
> are the userspace-visible effects of this bug and how are those effects
> demonstrated?

See below:

<snip>
commit 333b5e9ff2ccb35c3040fa8b0fd7011dfd42aae2
Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
Date:   Wed Oct 8 19:49:50 2025 +0200

    dm-ebs: Mark full buffer dirty even on partial write
    
    When performing a read-modify-write(RMW) operation, any modification
    to a buffered block must cause the entire buffer to be marked dirty.
    
    Marking only a subrange as dirty is incorrect because the underlying
    device block size(ubs) defines the minimum read/write granularity. A
    lower device can perform I/O only on regions which are fully aligned
    and sized to ubs.
    
    This change ensures that write-back operations always occur in full
    ubs-sized chunks, matching the intended emulation semantics of the
    EBS target.
    
    As for user space visible impact, submitting sub-ubs and misaligned
    I/O for devices which are tuned to ubs sizes only, will reject such
    requests, therefore it can lead to losing data. Example:
    
    1) Create a 8K nvme device in qemu by adding
    
    -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
    
    2) Setup dm-ebs to emulate 512B to 8K mapping.
    
    urezki@pc638:~/bin$ cat dmsetup.sh
    
    lower=/dev/nvme0n1
    len=$(blockdev --getsz "$lower")
    
    echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
    urezki@pc638:~/bin$
    
    offset 0, ebs=1 and ubs=16(in sectors).
    
    3) Create an ext4 filesystem(default 4K block size)
    
    urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
    mke2fs 1.47.0 (5-Feb-2023)
    Discarding device blocks: done
    Creating filesystem with 2072576 4k blocks and 518144 inodes
    Filesystem UUID: bd0b6ca6-0506-4e31-86da-8d22c9d50b63
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (16384 blocks): done
    Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
    urezki@pc638:~/bin$ dmesg
    
    <snip>
    [ 1618.875449] buffer_io_error: 1028 callbacks suppressed
    [ 1618.875456] Buffer I/O error on dev dm-0, logical block 0, lost async page write
    [ 1618.875527] Buffer I/O error on dev dm-0, logical block 1, lost async page write
    [ 1618.875602] Buffer I/O error on dev dm-0, logical block 2, lost async page write
    [ 1618.875620] Buffer I/O error on dev dm-0, logical block 3, lost async page write
    [ 1618.875639] Buffer I/O error on dev dm-0, logical block 4, lost async page write
    [ 1618.894316] Buffer I/O error on dev dm-0, logical block 5, lost async page write
    [ 1618.894358] Buffer I/O error on dev dm-0, logical block 6, lost async page write
    [ 1618.894380] Buffer I/O error on dev dm-0, logical block 7, lost async page write
    [ 1618.894405] Buffer I/O error on dev dm-0, logical block 8, lost async page write
    [ 1618.894427] Buffer I/O error on dev dm-0, logical block 9, lost async page write
    <snip>
    
    Many I/O errors because the lower 8K device rejects sub-ubs/misaligned
    requests.
    
    with a patch:
    
    urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
    mke2fs 1.47.0 (5-Feb-2023)
    Discarding device blocks: done
    Creating filesystem with 2072576 4k blocks and 518144 inodes
    Filesystem UUID: 9b54f44f-ef55-4bd4-9e40-c8b775a616ac
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (16384 blocks): done
    Writing superblocks and filesystem accounting information: done
    
    urezki@pc638:~/bin$ sudo mount /dev/dm-0 /mnt/
    urezki@pc638:~/bin$ ls -al /mnt/
    total 24
    drwxr-xr-x  3 root root  4096 Oct 17 15:13 .
    drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
    drwx------  2 root root 16384 Oct 17 15:13 lost+found
    urezki@pc638:~/bin$
    
    After this change: mkfs completes; mount succeeds.
    
    Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 6abb31ca9662..b354e74a670e 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -103,7 +103,7 @@ static int __ebs_rw_bvec(struct ebs_c *ec, enum req_op op, struct bio_vec *bv,
 			} else {
 				flush_dcache_page(bv->bv_page);
 				memcpy(ba, pa, cur_len);
-				dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + cur_len);
+				dm_bufio_mark_buffer_dirty(b);
 			}
 
 			dm_bufio_release(b);
<snip>

--
Uladzislau Rezki
