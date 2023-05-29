Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DCCC77B7A
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 20:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685393987;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7BAGH8NshzgsRZ+82/GsHyd+is/lH+UOfpUSbDHMa6U=;
	b=RmWdtQdBN5dLZoW8nvceQa71amUK1ENSOvzs5vJdXtYgDhZqkDph7cS+0SCj/5XoJPrjKO
	ueDL+g4TRKMZm7lO77slbia5gQ6ZxIaVeHPp60kFoKXydvC6SrwY8JTbPqC7LqYk1mgBlB
	s+ynXvLP+JG/TfpvG1C9X9n6HnUMkcM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-r1M-bdjTPsK5CnfN1ZBF3Q-1; Mon, 29 May 2023 16:59:46 -0400
X-MC-Unique: r1M-bdjTPsK5CnfN1ZBF3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 693C21C06EC8;
	Mon, 29 May 2023 20:59:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D7EC2166B2B;
	Mon, 29 May 2023 20:59:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E4E91946595;
	Mon, 29 May 2023 20:59:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3870A194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 20:59:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A6D0112132D; Mon, 29 May 2023 20:59:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CD1B112132C;
 Mon, 29 May 2023 20:59:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 34TKxeFj026289; Mon, 29 May 2023 16:59:40 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 34TKxe2E026285; Mon, 29 May 2023 16:59:40 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 29 May 2023 16:59:40 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Kent Overstreet <kent.overstreet@linux.dev>
Message-ID: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] fuzzing bcachefs with dm-flakey
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
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I improved the dm-flakey device mapper target, so that it can do random 
corruption of read and write bios - I uploaded it here: 
https://people.redhat.com/~mpatocka/testcases/bcachefs/dm-flakey.c

I set up dm-flakey, so that it corrupts 10% of read bios and 10% of write 
bios with this command:
dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"


I created a bcachefs volume on a single disk (metadata and data checksums 
were turned off) and mounted it on dm-flakey. I got:

crash: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash1.txt
deadlock: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash2.txt
infinite loop: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash3.txt

Here I uploaded an image that causes infnite loop when we run bcachefs 
fsck on it or when we attempt mount it:
https://people.redhat.com/~mpatocka/testcases/bcachefs/inf-loop.gz


I tried to run bcachefs on two block devices and fuzzing just one of them 
(checksums and replication were turned on - so bcachefs shold correct the 
corrupted data) - in this scenario, bcachefs doesn't return invalid data, 
but it sometimes returns errors and sometimes crashes.

This script will trigger an oops on unmount:
	https://people.redhat.com/~mpatocka/testcases/bcachefs/crash4.txt
or nonsensical errors returned to userspace:
	rm: cannot remove '/mnt/test/test/cmd_migrate.c': Unknown error 2206
or I/O errors returned to userspace:
	diff: /mnt/test/test/rust-src/target/release/.fingerprint/bch_bindgen-f0bad16858ff0019/lib-bch_bindgen.json: Input/output error

#!/bin/sh -ex
umount /mnt/test || true
dmsetup remove_all || true
rmmod brd || true
SRC=/usr/src/git/bcachefs-tools
while true; do
        modprobe brd rd_size=1048576
        bcachefs format --replicas=2 /dev/ram0 /dev/ram1
        dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` linear /dev/ram0 0"
        mount -t bcachefs /dev/mapper/flakey:/dev/ram1 /mnt/test
        dmsetup load flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"
        dmsetup suspend flakey
        dmsetup resume flakey
        cp -a "$SRC" /mnt/test/test
        diff -r "$SRC" /mnt/test/test
        echo 3 >/proc/sys/vm/drop_caches
        diff -r "$SRC" /mnt/test/test
        echo 3 >/proc/sys/vm/drop_caches
        diff -r "$SRC" /mnt/test/test
        echo 3 >/proc/sys/vm/drop_caches
        rm -rf /mnt/test/test
        echo 3 >/proc/sys/vm/drop_caches
        cp -a "$SRC" /mnt/test/test
        echo 3 >/proc/sys/vm/drop_caches
        diff -r "$SRC" /mnt/test/test
        umount /mnt/test
        dmsetup remove flakey
        rmmod brd
done

The oops happens in set_btree_iter_dontneed and it is caused by the fact 
that iter->path is NULL. The code in try_alloc_bucket is buggy because it 
sets "struct btree_iter iter = { NULL };" and then jumps to the "err" 
label that tries to dereference values in "iter".


Bcachefs gives not much usefull error messages, like "Fatal error: Unknown 
error 2184" or "Error in recovery: cannot allocate memory" or "mount(2) 
system call failed: Unknown error 2186." or "rm: cannot remove 
'/mnt/test/xfstests-dev/tools/fs-walk': Unknown error 2206".

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

