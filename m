Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C1E101DF
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 09:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfXPFUtS"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1cc2fc281cdso27642315ad.0
        for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 01:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700471087; x=1701075887; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZP2pGqhjcW1cIuiHffLEE4yPgm+Ha/UDWGdnJ3PgW/s=;
        b=lfXPFUtSJ4mrBqqDzPUzcTVufXO7TUsmlu5jqDpEeeG5lAaAY1E8ftjQ00RkTz/xo5
         xGqy38nU5o0l3dsW0C7zX/gyd28ItO3ICn/7mP5tIlMosHpmb95GWEOo8l07iVdR2jWc
         3UKUIePrvinjjWqtU24pI2pO4YZCgxg+jpodLJPd2rinFEs0gduUNs7RN5oLmo2WsIOU
         38/1Hm39x32R6lqIHckhfQeEWynZSgiNOFxbPQtJjamKQCoCWkqzxnzAYOQsBZXZLSTF
         2Bd2fbHC1V6G1fROInkYT6jpBu89MK6YtvVnpm1VzL7c+UVvBeCkE6ecmt/xrVwmHrdh
         2IgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700471087; x=1701075887;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZP2pGqhjcW1cIuiHffLEE4yPgm+Ha/UDWGdnJ3PgW/s=;
        b=tlUprokTsHcnB+6ZAkNgUK74LxL9PSX9ChZ0ENY8phz7HLpIS0FBjbJ5JhLU9zsSER
         i3jbYmvqJ5URICO96v2kj9A7QcF0RZzBWY3UX2cKd7sA0ghhv0oLAm9qxepW2BEIAl+0
         mbMvhsnvEpo0IR37ZrXsRtzg6FUDForjfk8s35ldJY5UlikzQ6hlgChZuIbsCX7Mwab5
         V0pkHI0eK5gMuQeVNEFKgsqw4kk1b9cjZ7E1zj8+0O8HA5o5+cqg8YCvn/voGKKeh2Ht
         qreEmblWX4mhUacN1B7vW/NsVFDm/RbKmj01aORsJ1Ec9U5sY9K+s79HghOf7Cbs68fC
         qUrA==
X-Gm-Message-State: AOJu0Yx9uzNOoG9PEhnZKZ8+ahaK855uanc56z+43JwmojUN8RInqd2H
	SNGwF/mYGg3KM8RvcgYQzZE=
X-Google-Smtp-Source: AGHT+IEUlQG5PpnhVHUcFkVZilyCsDB9tsc2mW+VYDfgwTm51ozkMKDsha1GzPMpCFZggdSBJCH9Jw==
X-Received: by 2002:a17:902:d381:b0:1cc:5258:845c with SMTP id e1-20020a170902d38100b001cc5258845cmr4627042pld.57.1700471086948;
        Mon, 20 Nov 2023 01:04:46 -0800 (PST)
Received: from [192.168.0.106] ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902c18400b001c9c47d6cb9sm2563398pld.99.2023.11.20.01.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 01:04:46 -0800 (PST)
Message-ID: <8539e7cb-43d7-4191-bf55-6ac15b5e9e48@gmail.com>
Date: Mon, 20 Nov 2023 16:04:41 +0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Device Mapper <dm-devel@lists.linux.dev>,
 Linux ext4 <linux-ext4@vger.kernel.org>,
 Linux RAID <linux-raid@vger.kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Song Liu <song@kernel.org>,
 Matthew Stapleton <matthew4196@gmail.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: fdatasync to a block device seems to block writes on unrelated
 devices
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I notice a bug report on Bugzilla [1]. Quoting from it:

> I was running nwipe on a failing hard drive that was running very slow and while nwipe was running fdatasync it seemed to cause delays for the filesystems on the other drives.  The other drives are attached to the same onboard ahci sata adapter if that is important.  After stopping nwipe, performance returned to normal
> 
> The system is using ext4 filesystems on top of LVM on top of Linux RAID6 and the kernel is 6.1.53.
> 
> Is this a design problem with fdatasync or could it be something else?
> 
> Nov 18 08:10:27 server kernel: sysrq: Show Blocked State
> Nov 18 08:10:27 server kernel: task:nwipe           state:D stack:0     pid:61181 ppid:42337  flags:0x00004000
> Nov 18 08:10:27 server kernel: Call Trace:
> Nov 18 08:10:27 server kernel:  <TASK>
> Nov 18 08:10:27 server kernel:  __schedule+0x2f8/0x870
> Nov 18 08:10:27 server kernel:  schedule+0x55/0xc0
> Nov 18 08:10:27 server kernel:  io_schedule+0x3d/0x60
> Nov 18 08:10:27 server kernel:  folio_wait_bit_common+0x12c/0x300
> Nov 18 08:10:27 server kernel:  ? filemap_invalidate_unlock_two+0x30/0x30
> Nov 18 08:10:27 server kernel:  write_cache_pages+0x1c6/0x460
> Nov 18 08:10:27 server kernel:  ? dirty_background_bytes_handler+0x20/0x20
> Nov 18 08:10:27 server kernel:  generic_writepages+0x76/0xa0
> Nov 18 08:10:27 server kernel:  do_writepages+0xbb/0x1c0
> Nov 18 08:10:27 server kernel:  filemap_fdatawrite_wbc+0x56/0x80
> Nov 18 08:10:27 server kernel:  __filemap_fdatawrite_range+0x53/0x70
> Nov 18 08:10:27 server kernel:  file_write_and_wait_range+0x3c/0x90
> Nov 18 08:10:27 server kernel:  blkdev_fsync+0xe/0x30
> Nov 18 08:10:27 server kernel:  __x64_sys_fdatasync+0x46/0x80
> Nov 18 08:10:27 server kernel:  do_syscall_64+0x3a/0xb0
> Nov 18 08:10:27 server kernel:  entry_SYSCALL_64_after_hwframe+0x5e/0xc8
> Nov 18 08:10:27 server kernel: RIP: 0033:0x7f02a735f00b
> Nov 18 08:10:27 server kernel: RSP: 002b:00007f02a6858c80 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Nov 18 08:10:27 server kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f02a735f00b
> Nov 18 08:10:27 server kernel: RDX: 0000000000000002 RSI: 00007f02a6858d80 RDI: 0000000000000004
> Nov 18 08:10:27 server kernel: RBP: 00000118badb6000 R08: 0000000000000000 R09: 00007f02a0000080
> Nov 18 08:10:27 server kernel: R10: 0000000000001000 R11: 0000000000000293 R12: 00000000000186a0
> Nov 18 08:10:27 server kernel: R13: 00000000000186a0 R14: 0000000000001000 R15: 000055b7a0775850
> Nov 18 08:10:27 server kernel:  </TASK>
> Nov 18 08:10:27 server kernel: task:kworker/u64:4   state:D stack:0     pid:7842  ppid:2      flags:0x00004000
> Nov 18 08:10:27 server kernel: Workqueue: writeback wb_workfn (flush-8:0)
> Nov 18 08:10:27 server kernel: Call Trace:
> Nov 18 08:10:27 server kernel:  <TASK>
> Nov 18 08:10:27 server kernel:  __schedule+0x2f8/0x870
> Nov 18 08:10:27 server kernel:  schedule+0x55/0xc0
> Nov 18 08:10:27 server kernel:  io_schedule+0x3d/0x60
> Nov 18 08:10:27 server kernel:  blk_mq_get_tag+0x115/0x2a0
> Nov 18 08:10:27 server kernel:  ? destroy_sched_domains_rcu+0x20/0x20
> Nov 18 08:10:27 server kernel:  __blk_mq_alloc_requests+0x18c/0x2e0
> Nov 18 08:10:27 server kernel:  blk_mq_submit_bio+0x3dc/0x590
> Nov 18 08:10:27 server kernel:  __submit_bio+0xec/0x170
> Nov 18 08:10:27 server kernel:  submit_bio_noacct_nocheck+0x2bd/0x2f0
> Nov 18 08:10:27 server kernel:  ? submit_bio_noacct+0x68/0x440
> Nov 18 08:10:27 server kernel:  __block_write_full_page+0x1ef/0x4c0
> Nov 18 08:10:27 server kernel:  ? bh_uptodate_or_lock+0x70/0x70
> Nov 18 08:10:27 server kernel:  ? blkdev_write_begin+0x20/0x20
> Nov 18 08:10:27 server kernel:  __writepage+0x14/0x60
> Nov 18 08:10:27 server kernel:  write_cache_pages+0x172/0x460
> Nov 18 08:10:27 server kernel:  ? dirty_background_bytes_handler+0x20/0x20
> Nov 18 08:10:27 server kernel:  generic_writepages+0x76/0xa0
> Nov 18 08:10:27 server kernel:  do_writepages+0xbb/0x1c0
> Nov 18 08:10:27 server kernel:  ? __wb_calc_thresh+0x46/0x130
> Nov 18 08:10:27 server kernel:  __writeback_single_inode+0x30/0x1a0
> Nov 18 08:10:27 server kernel:  writeback_sb_inodes+0x205/0x4a0
> Nov 18 08:10:27 server kernel:  __writeback_inodes_wb+0x47/0xe0
> Nov 18 08:10:27 server kernel:  wb_writeback.isra.0+0x189/0x1d0
> Nov 18 08:10:27 server kernel:  wb_workfn+0x1d0/0x3a0
> Nov 18 08:10:27 server kernel:  process_one_work+0x1e5/0x320
> Nov 18 08:10:27 server kernel:  worker_thread+0x45/0x3a0
> Nov 18 08:10:27 server kernel:  ? rescuer_thread+0x390/0x390
> Nov 18 08:10:27 server kernel:  kthread+0xd5/0x100
> Nov 18 08:10:27 server kernel:  ? kthread_complete_and_exit+0x20/0x20
> Nov 18 08:10:27 server kernel:  ret_from_fork+0x22/0x30
> Nov 18 08:10:27 server kernel:  </TASK>
> Nov 18 08:10:27 server kernel: task:rm              state:D stack:0     pid:54615 ppid:54597  flags:0x00004000
> Nov 18 08:10:27 server kernel: Call Trace:
> Nov 18 08:10:27 server kernel:  <TASK>
> Nov 18 08:10:27 server kernel:  __schedule+0x2f8/0x870
> Nov 18 08:10:27 server kernel:  schedule+0x55/0xc0
> Nov 18 08:10:27 server kernel:  io_schedule+0x3d/0x60
> Nov 18 08:10:27 server kernel:  bit_wait_io+0x8/0x50
> Nov 18 08:10:27 server kernel:  __wait_on_bit+0x46/0x100
> Nov 18 08:10:27 server kernel:  ? bit_wait+0x50/0x50
> Nov 18 08:10:27 server kernel:  out_of_line_wait_on_bit+0x8c/0xb0
> Nov 18 08:10:27 server kernel:  ? sugov_start+0x140/0x140
> Nov 18 08:10:27 server kernel:  ext4_read_bh+0x6e/0x80
> Nov 18 08:10:27 server kernel:  ext4_bread+0x45/0x60
> Nov 18 08:10:27 server kernel:  __ext4_read_dirblock+0x4d/0x330
> Nov 18 08:10:27 server kernel:  htree_dirblock_to_tree+0xa7/0x370
> Nov 18 08:10:27 server kernel:  ? path_lookupat+0x92/0x190
> Nov 18 08:10:27 server kernel:  ? filename_lookup+0xdf/0x1e0
> Nov 18 08:10:27 server kernel:  ext4_htree_fill_tree+0x108/0x3c0
> Nov 18 08:10:27 server kernel:  ext4_readdir+0x725/0xb40
> Nov 18 08:10:27 server kernel:  iterate_dir+0x16a/0x1b0
> Nov 18 08:10:27 server kernel:  __x64_sys_getdents64+0x7f/0x120
> Nov 18 08:10:27 server kernel:  ? compat_filldir+0x180/0x180
> Nov 18 08:10:27 server kernel:  do_syscall_64+0x3a/0xb0
> Nov 18 08:10:27 server kernel:  entry_SYSCALL_64_after_hwframe+0x5e/0xc8
> Nov 18 08:10:27 server kernel: RIP: 0033:0x7f8e32834897
> Nov 18 08:10:27 server kernel: RSP: 002b:00007fffa3fb78c8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
> Nov 18 08:10:27 server kernel: RAX: ffffffffffffffda RBX: 0000558d8c4f8a70 RCX: 00007f8e32834897
> Nov 18 08:10:27 server kernel: RDX: 0000000000008000 RSI: 0000558d8c4f8aa0 RDI: 0000000000000004
> Nov 18 08:10:27 server kernel: RBP: 0000558d8c4f8aa0 R08: 0000000000000030 R09: 00007f8e3292da60
> Nov 18 08:10:27 server kernel: R10: 00007f8e3292e140 R11: 0000000000000293 R12: ffffffffffffff88
> Nov 18 08:10:27 server kernel: R13: 0000558d8c4f8a74 R14: 0000000000000000 R15: 0000558d8c503c78
> Nov 18 08:10:27 server kernel:  </TASK>

And then ...

> Also, I was running badblocks -b 4096 -w -s -v on the failing hard drive for a few days before trying nwipe and it didn't seem to be causing slowdowns on the server and the man page for badblocks says it uses Direct I/O by default.  I decided to try nwipe as it provides the option disable read verifying.
> 
> I could probably try removing fdatasync from nwipe or modifying it to use Direct I/O, but I haven't done that yet.

See Bugzilla for the full thread.

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=218158

-- 
An old man doll... just what I always wanted! - Clara
