Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F2F1991C6
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731936474; cv=none; b=Qd2m8sa4hB4DDyii4gFXAe8v/iSH+f62GPR4UKMjkcS1SFUs4UpWiOsq/6loXNyqaXgv9n/KINPd9j8ZfuWG1pYcnMypfHxVn4OI4cJVxRwdGphGYfQDtUJkjZTkQamO+JIQ1fHeRNWYDmxFQWljijYno3fvNQf5hvqmWvOpjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731936474; c=relaxed/simple;
	bh=KsYgEKMVuCtkLEOVEFdN7zNdiBpIEEHVTxa0+j3Ppvs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h1AfDz6LXa7u6dbECTiKN7T2eKmGfR5RyfzGxbTkEqCIC0S39WtIP+LqyTDvBzuc2avL9h3VRInefsdlvHTDw2o6NlNvb8i4jzC/A1in5aiITjYbwNb5Ee/U9DUwcx4ZUu5pjDNvSfzm+O5dvoERYNLUTPMy75RkoroxWFpLgos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LRc/h+Hn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LRc/h+Hn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731936471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=APu+QkOVXvSecmWzcnKFo9p1FT3MjvcEmQqpSW0TQqs=;
	b=LRc/h+HnnSQAIYo+Gy4l+FoQhtpt4uZNb+66WUjswlf969tkWiDfQkKsPtUrqmXhOeV6jj
	g7tFTa6dGJYdxxMxZAVj+YM1+IzcBHKHmW+1kFik3JoH9hox+fkRQzn6sd273AKZmx4K+x
	LAWarevoIRHCxgo+Ocf5FhfsJnzwnJw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-pqwgpntzNiG4WA64k6OqmQ-1; Mon,
 18 Nov 2024 08:27:45 -0500
X-MC-Unique: pqwgpntzNiG4WA64k6OqmQ-1
X-Mimecast-MFC-AGG-ID: pqwgpntzNiG4WA64k6OqmQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BF791953941;
	Mon, 18 Nov 2024 13:27:44 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8814B1955F3C;
	Mon, 18 Nov 2024 13:27:40 +0000 (UTC)
Date: Mon, 18 Nov 2024 14:27:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dap581 <dap581@protonmail.com>
cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@lst.de>, 
    Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>, 
    Ilya Dryomov <idryomov@gmail.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Jens Axboe <axboe@kernel.dk>
Subject: Re: kernel 6.12-rc7 device-mapper inconsistency
In-Reply-To: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com>
Message-ID: <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com>
References: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GngM8wLwp4jphjVUAnIHpxWHAsD9UdY_tGjzlJlsrCk_1731936464
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-897948747-1731935872=:1414951"
Content-ID: <aa14829a-12a7-5c53-07cf-e9fe7f2175cb@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-897948747-1731935872=:1414951
Content-Type: text/plain; CHARSET=KOI8-R
Content-Transfer-Encoding: 8BIT
Content-ID: <6242d23a-f1ea-041c-369c-5199d0ff837a@redhat.com>

Hi

Please apply this patch and report what it prints. So, that we can find 
out which limits cause the problem.

Mikulas



On Sat, 16 Nov 2024, dap581 wrote:

> Hello,
> Starting with kernel 6.11.x series up to current 6.12-rc7
> when I unlock my encrypted hdd (storage, not root) with cryptsetup:
> 
> cryptsetup luksOpen /dev/sda1 hdd5 -d keyfile_hdd5
> 
> it triggers an alignment inconsistency:
> In dmesg log, I read:
> ----
> [  105.841278] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> [  105.841292] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> [  105.841601] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> [  105.841607] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> ----
> 
> Also, starting with Linux >6.11.x up to current 6.12-rc7, "lsblk -t" 
> returns different values than before in OPT-IO & RA column.
> 
> ----
> With kernel >6.11.x
> With device closed:
> NAME         ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE    RA WSAME
> sda                  0   4096 16776704    4096     512    1 bfq       256 32764    0B
> „€sda1               0   4096 16776704    4096     4096    1 bfq       256 32764    0B
> After luksOpen:
> sda                  0   4096 16776704    4096     512    1 bfq       256 32764    0B
> „€sda1               0   4096 16776704    4096     512    1 bfq       256 32764    0B
>   „€hdd5            -1   4096        0    4096    4096    1               32764    0B
> 
> 
> I tried to track down when this started exactly, to do so, I compiled kernel:
> 6.7.12, 6.8.12, 6.9.9, 6.10.14
> and none of them returns this device-mapper inconsistency.
> lsblk -t with kernel 6.10.14 and earlier:
> NAME         ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
> sda                  0   4096      0    4096     512    1 bfq       256 128    0B
> „€sda1               0   4096      0    4096     512    1 bfq       256 128    0B
>   „€hdd5             0   4096      0    4096    4096    1               128    0B
> 
> So far, I have been able to locate this commit (part of Linux 6.11.x) 
> a23634644afc2f7c1bac98776440a1f3b161819e (block: take io_opt and io_min 
> into account for max_sectors ) that seems to trigger the change in lsblk 
> output and introduces opt-io & ra value but as a casual user, I can't 
> say for sure, I'm not a developer either. On the other hand, if I 
> compile a kernel using one or two commit before 
> a23634644afc2f7c1bac98776440a1f3b161819e then the lsblk -t output is not 
> changed and no "device-mapper inconsistency" appears so it seems at 
> least related somehow. By the way, after enteting my password (or using 
> keyfile) cryptsetup returns no error and the filesystem (btrfs) mounts 
> correctly.
> 
> Let me know if you need other info.
> See also: https://gitlab.com/cryptsetup/cryptsetup/-/issues/919
> 
> System used: Gentoo
> 
> The HDD is connected to an SAS HBA (Dell Perc H310 with IT firmware) 
> Actually, there are also 4 other HDD (same brand, model, capacity, same 
> configuration used) connected to it and they all show the exact same 
> message "device-mapper inconsistency" as soon as there are unlocked.
> 
> gdisk -l /dev/sda
> ----
> Disk /dev/sda: 5860533168 sectors, 2.7 TiB
> Model: WDC WD30EZRX-00D
> Sector size (logical/physical): 512/4096 bytes
> Disk identifier (GUID): 4D31A7E7-A2A6-4A5A-8FE1-8368581B78DC
> Partition table holds up to 128 entries
> Main partition table begins at sector 2 and ends at sector 33
> First usable sector is 34, last usable sector is 5860533134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2924 sectors (1.4 MiB)
> 
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048      5860532224   2.7 TiB     8300  Linux filesystem
> ----
> 
> luksDump /dev/sda1
> ----
> LUKS header information
> Version:       2
> Epoch:         5
> Metadata area: 16384 [bytes]
> Keyslots area: 16744448 [bytes]
> UUID:           d1ff1c64-a294-4287-ab33-215327716e96
> Label:         hdd5
> Subsystem:     (no subsystem)
> Flags:       (no flags)
> 
> Data segments:
>   0: crypt
> offset: 16777216 [bytes]
> length: (whole device)
> cipher: serpent-xts-plain64
> sector: 4096 [bytes]
> ----
> 
> 
---
 block/blk-settings.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2024-09-30 16:40:54.000000000 +0200
+++ linux-2.6/block/blk-settings.c	2024-11-18 14:25:19.000000000 +0100
@@ -557,6 +557,7 @@ int blk_stack_limits(struct queue_limits
 
 		/* Verify that top and bottom intervals line up */
 		if (max(top, bottom) % min(top, bottom)) {
+			printk("failure 1: %x, %x\n", top, bottom);
 			t->flags |= BLK_FLAG_MISALIGNED;
 			ret = -1;
 		}
@@ -578,6 +579,7 @@ int blk_stack_limits(struct queue_limits
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
+		printk("failure 2: %x, %x\n", t->physical_block_size, t->logical_block_size);
 		t->physical_block_size = t->logical_block_size;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
@@ -585,6 +587,7 @@ int blk_stack_limits(struct queue_limits
 
 	/* Minimum I/O a multiple of the physical block size? */
 	if (t->io_min & (t->physical_block_size - 1)) {
+		printk("failure 3: %x, %x\n", t->io_min, t->physical_block_size);
 		t->io_min = t->physical_block_size;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
@@ -592,6 +595,7 @@ int blk_stack_limits(struct queue_limits
 
 	/* Optimal I/O a multiple of the physical block size? */
 	if (t->io_opt & (t->physical_block_size - 1)) {
+		printk("failure 4: %x, %x\n", t->io_opt, t->physical_block_size);
 		t->io_opt = 0;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
@@ -599,6 +603,7 @@ int blk_stack_limits(struct queue_limits
 
 	/* chunk_sectors a multiple of the physical block size? */
 	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+		printk("failure 5: %x, %x\n", t->chunk_sectors, t->physical_block_size);
 		t->chunk_sectors = 0;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
@@ -610,6 +615,7 @@ int blk_stack_limits(struct queue_limits
 
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
+		printk("failure 6: %x, %x\n", t->alignment_offset, t->logical_block_size);
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
 	}
---1463811712-897948747-1731935872=:1414951--

