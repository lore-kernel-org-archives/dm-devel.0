Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A798C77B7E
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685668449;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1gGgbOXRLLiVf9t3Nsnve/xJM9oDXC2pZCapyEFydEY=;
	b=bPUCGBI+XZ353YcpMLs1x+ylXprdCWI+LTzhkLVht9575ryi3JTAO5MJOLl49njTYryirq
	TM/Trd9VDw2ilpY4h/F1nmc9uchFK0S2MsZ7aVIDVwb9OcmtuWfykrHdQkIK6jJyUJFWAF
	StTHnhChA3cIYyxjSZX2aNNUCDbVpGk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-3l-Vl1GsMAqUJb9XY27ZoQ-1; Thu, 01 Jun 2023 21:14:05 -0400
X-MC-Unique: 3l-Vl1GsMAqUJb9XY27ZoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C8229AA2D1;
	Fri,  2 Jun 2023 01:14:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4567B14171BB;
	Fri,  2 Jun 2023 01:14:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 054A21946595;
	Fri,  2 Jun 2023 01:14:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A645194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 01:14:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27064492B0B; Fri,  2 Jun 2023 01:14:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EFB7492B0A
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 01:14:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 039208007D9
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 01:14:00 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-H0G74Dn7PVyNndPHBGj1HQ-1; Thu, 01 Jun 2023 21:13:58 -0400
X-MC-Unique: H0G74Dn7PVyNndPHBGj1HQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8A58A64AEF;
 Fri,  2 Jun 2023 01:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAADFC433EF;
 Fri,  2 Jun 2023 01:13:55 +0000 (UTC)
Date: Thu, 1 Jun 2023 18:13:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230602011355.GA16848@frogsfrogsfrogs>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] fuzzing bcachefs with dm-flakey
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 dm-devel@redhat.com, Kent Overstreet <kent.overstreet@linux.dev>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 29, 2023 at 04:59:40PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I improved the dm-flakey device mapper target, so that it can do random 
> corruption of read and write bios - I uploaded it here: 
> https://people.redhat.com/~mpatocka/testcases/bcachefs/dm-flakey.c
> 
> I set up dm-flakey, so that it corrupts 10% of read bios and 10% of write 
> bios with this command:
> dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"
> 
> 
> I created a bcachefs volume on a single disk (metadata and data checksums 
> were turned off) and mounted it on dm-flakey. I got:
> 
> crash: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash1.txt
> deadlock: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash2.txt
> infinite loop: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash3.txt
> 
> Here I uploaded an image that causes infnite loop when we run bcachefs 
> fsck on it or when we attempt mount it:
> https://people.redhat.com/~mpatocka/testcases/bcachefs/inf-loop.gz
> 
> 
> I tried to run bcachefs on two block devices and fuzzing just one of them 
> (checksums and replication were turned on - so bcachefs shold correct the 
> corrupted data) - in this scenario, bcachefs doesn't return invalid data, 
> but it sometimes returns errors and sometimes crashes.
> 
> This script will trigger an oops on unmount:
> 	https://people.redhat.com/~mpatocka/testcases/bcachefs/crash4.txt
> or nonsensical errors returned to userspace:
> 	rm: cannot remove '/mnt/test/test/cmd_migrate.c': Unknown error 2206
> or I/O errors returned to userspace:
> 	diff: /mnt/test/test/rust-src/target/release/.fingerprint/bch_bindgen-f0bad16858ff0019/lib-bch_bindgen.json: Input/output error
> 
> #!/bin/sh -ex
> umount /mnt/test || true
> dmsetup remove_all || true
> rmmod brd || true
> SRC=/usr/src/git/bcachefs-tools
> while true; do
>         modprobe brd rd_size=1048576
>         bcachefs format --replicas=2 /dev/ram0 /dev/ram1
>         dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` linear /dev/ram0 0"
>         mount -t bcachefs /dev/mapper/flakey:/dev/ram1 /mnt/test
>         dmsetup load flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"

Hey, that's really neat!

Any chance you'd be willing to get the dm-flakey changes merged into
upstream so that someone can write a recoveryloop fstest to test all the
filesystems systematically?

:D

--D

>         dmsetup suspend flakey
>         dmsetup resume flakey
>         cp -a "$SRC" /mnt/test/test
>         diff -r "$SRC" /mnt/test/test
>         echo 3 >/proc/sys/vm/drop_caches
>         diff -r "$SRC" /mnt/test/test
>         echo 3 >/proc/sys/vm/drop_caches
>         diff -r "$SRC" /mnt/test/test
>         echo 3 >/proc/sys/vm/drop_caches
>         rm -rf /mnt/test/test
>         echo 3 >/proc/sys/vm/drop_caches
>         cp -a "$SRC" /mnt/test/test
>         echo 3 >/proc/sys/vm/drop_caches
>         diff -r "$SRC" /mnt/test/test
>         umount /mnt/test
>         dmsetup remove flakey
>         rmmod brd
> done
> 
> The oops happens in set_btree_iter_dontneed and it is caused by the fact 
> that iter->path is NULL. The code in try_alloc_bucket is buggy because it 
> sets "struct btree_iter iter = { NULL };" and then jumps to the "err" 
> label that tries to dereference values in "iter".
> 
> 
> Bcachefs gives not much usefull error messages, like "Fatal error: Unknown 
> error 2184" or "Error in recovery: cannot allocate memory" or "mount(2) 
> system call failed: Unknown error 2186." or "rm: cannot remove 
> '/mnt/test/xfstests-dev/tools/fs-walk': Unknown error 2206".
> 
> Mikulas
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

