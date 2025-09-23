Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7219C27F73A
	for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 23:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758670445; cv=none; b=ff6VpgkeyRZU6ZLbAV4Twqa3YSpAhf9xbdYTVVXcz3/YkH/j+BPMKlembbkwtSUrvzssdGQbKy6+kJouSRqurprzUx1+QLFDVx9C5MZxBh7WHlQjiquPYLhYVnjRIvpqmpCM7uIHNqZsGsglTwGwftG9DRvfdIlucqp18Mc8CWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758670445; c=relaxed/simple;
	bh=tzGNr5tc8B8Ld0kRgIv+MJEz651NB3hkWLuafy30GFY=;
	h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=ga6yuJUghiNkiV8zWLb/jWk6iYymg+AWB3HQfEDCDNmE73F9slrzJvgmtursQt9u94Dz5Zg+QxgvsZDQ40pzz+4H5Wd0x/3XxCjgKIP+H5dQR8V9syiB8kthIx38EOdC6N8S/M05+sJdG0pbvJ5mmBex/H2hGfSTcZlul+0ftI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZDEqrLS; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZDEqrLS"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-26983b5411aso44136185ad.1
        for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 16:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758670442; x=1759275242; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:user-agent:date:message-id
         :subject:from:to:from:to:cc:subject:date:message-id:reply-to;
        bh=uAwUMBRWQFs5D+LrCLiaLjrqty0fmM24DwH1gcfxuC0=;
        b=VZDEqrLSDurUmYS/TB3Hb8VPF/9tJQN0uKH+23h7wJqbErvhfQA5F4auWXeKKrKetR
         SX9n8niyRF/IN/V/gsLu+t/jHcUv/ve5UH8B9p/eqbrCADFqbzf4D1Pjkp+uI7AskwHJ
         /8S7nvM8vjgLU3cNqMbUitSBI/gXz2Dw1Zwg/e5sytTj6u6/G241S/4BS8t8dVflxZHR
         7H6istKaqEDSVHyAcZiC0YWOeug607oBiqEq0VSwFpKo287GWi0Y+JgmkoYDTPoOTw63
         jxwEzwwfAWNvRqrkxhuNACMMbt3SCVilvPzfqrr46m31ShjWjgrEYtg0pXAoNtBNAfH8
         89wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758670442; x=1759275242;
        h=content-transfer-encoding:mime-version:user-agent:date:message-id
         :subject:from:to:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAwUMBRWQFs5D+LrCLiaLjrqty0fmM24DwH1gcfxuC0=;
        b=ZMrpccKqAID6Gz9wCnEekVgUXBYPxHj8XskbjXcc2OUzZA2LP1q8fpV1HHscQlXQ0n
         YVYwhow2fW3fcSEar8BjQTseOn+qTqV1Wz079XOtBjd//I2dOxqNOn2zdoesDNLnb2cu
         nY3Z4Wjt+NXt8gSysrK6JAXibwMnnYATY5Nj90ykNhxUtdBI7/A8Ny/YTe9D4UbHtCJ4
         sX1pfbi1IoWlqUBFfRCK1uyu0LW11Rfb6iOngHJQKd5PybVQSR9CAppYV5Hxg7Q/E921
         GnH+pLDry8+0AAXUadl1fjTJvjbeQyTmG2VggyaVTfpDNsd8EfysTF3+04fciMJ3NlDk
         /Mbw==
X-Gm-Message-State: AOJu0YyktpHS3schDlOLta50q9Ah6fStQECcAeDOoQWojdjRXE12/f6Z
	eDZ44kvL7Q+/gZBSfcbqRqC5H+VJscAamEZ0Guok+/49B17wRtRKaiio0SsPvA==
X-Gm-Gg: ASbGnctpXNkiJRfF3a5+rNO7j336NX+bWVlEs2lEXrX5fnltW2TTLc/bGl+FEFb5+T4
	qksYxkSXbZ09Acl3WLarVWbxNwO3emaN2oIPUZaDzsAHyI8Avmj4wNCkTH9JwPi+TSe9RXrY73l
	6ZsAiUuPzkLqzdAgp+/nsEBzCjrH1MXK2/EBievRydukbtWomr8FLxVvfSJTlUZtBc4/FAVTki5
	K9kq5M/LmPjj297xUkliSakHcGxJZRVcbfppFhmFeK5IkmUMggAXWBaR0LiVlWBCTDme00Bg65M
	DPVdmdyr5RU6/NH5jdksTz3vp8UCkt1SiFawBTM9decMcgF9Y5dAqNF/31LkqbnvnPwKtw+uWfe
	920jpRKu+S/LL7Xjj1XvCofnik8Vx
X-Google-Smtp-Source: AGHT+IFG5ZtzKIjigDeZ8/QQgrLNYvISX3NCpOahuXASiqphH+KvTkmuQGHJRHOTY7sQlJP0TXRMaA==
X-Received: by 2002:a17:902:ccd1:b0:264:a34c:c62 with SMTP id d9443c01a7336-27cc8f051afmr45274675ad.61.1758670442316;
        Tue, 23 Sep 2025 16:34:02 -0700 (PDT)
Received: from [192.168.100.150] ([177.50.1.87])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698016c265sm172013405ad.49.2025.09.23.16.34.00
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 16:34:01 -0700 (PDT)
To: dm-devel@lists.linux.dev
From: Augusto <augusto7743@gmail.com>
Subject: BTRFS issues using dm-cache writeback
Message-ID: <596a2005-32b5-78e8-d069-c2634e360a89@gmail.com>
Date: Tue, 23 Sep 2025 20:33:58 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.21
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello.
Thanks for reading my email.
I am an novice Linux user.
I had contacted an dm-cache developer to say about issues using BTRFS 
with writeback cache.
He had replied to me send an message to dm-devel@lists.linux.dev
If here not was the correct area to say it please excuse me.

Writeback cache does damage in file system being an expected behavior, 
but in BTRFS is an serious problem even.
Partial writen in ext4 not does fatal damage, but does it in BTRFS.
Any partial writen in BTRFS does the parent transid error being in some 
times an fatal error not allowing mount or to do any fix.
I when using the OS for an long time without doing an dm writeback flush 
run the command below
sudo btrfs check --readonly --force --mode original --progress /dev/sda5
If is showed the parent transid error will be done in sequence the 
command below to writecache flush
sudo /usr/sbin/dmsetup message /dev/mapper/rc-wb_sda5 0 flush
running again the btrfs check command will show not errors.

I believe is possible an solution to avoid that issue in BTRFS.
If the error happen when is done an partial writen to disk the solution 
maybe for example :
- In dm-writeback cache with 256 MB size was done write of 2 files of 
128 MB so the writeback cache is full.
- Another file is in queue being 64 MB size.
- The writeback need free 64 MB so the first file will be partially sent 
to disk and so does the damage in file system.
- To avoid that issue the dm-cache writecache module will free cache 
memory sent files with complete file size to disk. If need free 64 MB 
wil be sent do disk all files with complete size in that case the file 
of 128 MB.

If that issue is related with BTRFS need an fix for that file system to 
avoid issues when using writeback cache.
I use BTRFS with writeback cache before of 2022 and continue happeing 
that issue.
For me is how if BTRFS developers not has information about that type of 
issue are happening. Thus need to be reported.

dm-cache writeback avoiding any partial writen to disk avoid any 
possibilty of damage in the file system.
I not see any command or option to enable it in dm-cache module.

Please excuse if my explanation not was enough good. I am novice Linux user.
OS Ubuntu 24.04.1 and kernel 6.14
The disk was partitioned for the OS in three partitions being
sda3 = OS
sda4 = /home
sda5 = /opt
the writeback cache are the rc-wb_sda3 , rc-wb_sda4 and rc-wb_sda5
rd0 , rd1 and rd2 are block devices
I have used multiple settings and "combos" in the fstab for BTRFS and 
not is possible avoid issues. I not see that issue being related with 
any settings in fstab.
Please I not want post question or support using btrfs or dm-cache 
module. I only want report the issue with BTRFS and writeback cache and 
so wait an fix or solution to avoid that problem in dm-cache and BTRFS 
future versions.
I wish to you an nice week and good luck in your path in that world. 
Have an blessed week.
Thanks very much for reading that message.

Below are commands used in terminal and outputs.

==== lsblk ====

NAME           MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda              8:0    0 931,5G  0 disk
├─sda1           8:1    0     8M  0 part
├─sda2           8:2    0   586M  0 part /boot
├─sda3           8:3    0  11,4G  0 part
│ └─rc-wb_sda3 252:0    0  11,4G  0 dm   /
├─sda4           8:4    0   977M  0 part
│ └─rc-wb_sda4 252:1    0   977M  0 dm   /home
└─sda5           8:5    0    20G  0 part
   └─rc-wb_sda5 252:2    0    20G  0 dm   /opt
sdb              8:16   0 931,5G  0 disk
├─sdb1           8:17   0     8M  0 part
├─sdb2           8:18   0 585,6M  0 part
├─sdb3           8:19   0  17,2G  0 part
├─sdb4           8:20   0 890,3G  0 part /BTRFS
├─sdb5           8:21   0    12G  0 part
└─sdb6           8:22   0  11,4G  0 part
sr0             11:0    1  1024M  0 rom
zram0          250:0    0     3G  0 disk [SWAP]
rd0            251:0    0   128M  0 disk
└─rc-wb_sda3   252:0    0  11,4G  0 dm   /
rd1            251:1    0   256M  0 disk
└─rc-wb_sda4   252:1    0   977M  0 dm   /home
rd2            251:2    0    16M  0 disk
└─rc-wb_sda5   252:2    0    20G  0 dm   /opt

==== mount ====

sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
udev on /dev type devtmpfs 
(rw,nosuid,relatime,size=3988400k,nr_inodes=997100,mode=755,inode64)
devpts on /dev/pts type devpts 
(rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs 
(rw,nosuid,nodev,noexec,relatime,size=806428k,mode=755,inode64)
/dev/mapper/rc-wb_sda3 on / type btrfs 
(rw,noatime,nodiratime,lazytime,max_inline=0,compress-force=zlib:9,nossd,space_cache=v2,commit=6,subvolid=256,subvol=/@)
securityfs on /sys/kernel/security type securityfs 
(rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,inode64)
tmpfs on /run/lock type tmpfs 
(rw,nosuid,nodev,noexec,relatime,size=5120k,inode64)
cgroup2 on /sys/fs/cgroup type cgroup2 
(rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
bpf on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,relatime,mode=700)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs 
(rw,relatime,fd=32,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=3959)
debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime)
hugetlbfs on /dev/hugepages type hugetlbfs 
(rw,nosuid,nodev,relatime,pagesize=2M)
tracefs on /sys/kernel/tracing type tracefs 
(rw,nosuid,nodev,noexec,relatime)
configfs on /sys/kernel/config type configfs 
(rw,nosuid,nodev,noexec,relatime)
fusectl on /sys/fs/fuse/connections type fusectl 
(rw,nosuid,nodev,noexec,relatime)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,relatime,inode64)
tmpfs on /var/crash type tmpfs (rw,nosuid,nodev,relatime,inode64)
tmpfs on /var/log type tmpfs (rw,nosuid,nodev,relatime,inode64)
/dev/mapper/rc-wb_sda4 on /home type btrfs 
(rw,noatime,nodiratime,lazytime,max_inline=0,compress-force=zlib:9,nossd,space_cache=v2,commit=6,subvolid=5,subvol=/)
/dev/mapper/rc-wb_sda5 on /opt type btrfs 
(rw,noatime,nodiratime,lazytime,max_inline=0,compress-force=zlib:9,nossd,space_cache=v2,commit=6,subvolid=5,subvol=/)
/dev/sda2 on /boot type ext2 (rw,relatime)
/dev/sdb4 on /BTRFS type btrfs 
(rw,noatime,nodiratime,lazytime,max_inline=0,compress-force=zlib:9,nossd,nospace_cache,commit=360,subvolid=5,subvol=/)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc 
(rw,nosuid,nodev,noexec,relatime)
tmpfs on /run/user/1000 type tmpfs 
(rw,nosuid,nodev,relatime,size=806424k,nr_inodes=201606,mode=700,uid=1000,gid=1000,inode64)
gvfsd-fuse on /run/user/1000/gvfs type fuse.gvfsd-fuse 
(rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
portal on /run/user/1000/doc type fuse.portal 
(rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)

==== dmsetup table ====

rc-wb_sda3: 0 24000512 writecache s 8:3 251:0 4096 0
rc-wb_sda4: 0 2000896 writecache s 8:4 251:1 4096 0
rc-wb_sda5: 0 42000384 writecache s 8:5 251:2 4096 0
