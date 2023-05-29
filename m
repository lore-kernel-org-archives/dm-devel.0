Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A8C0C7EE33
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480089;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ulNFB46MG8xqnX3fvSEcx2OQkR0pQ/rYbNbgUv2To+s=;
	b=fkwQZmpa/fzof3ClmjthPlS2RBRrrzhY0R5N9c0x4cbY9mKT2lwGT5F0FMe2729lcLOTjT
	YOVUOdTLi6SN6Cg5eJ5yl/JtfnaxV0NzWXhz9HLVb+rOUCrV0ovj7k3SebBZLHmdRlNpPb
	dbI2Sf6MWZOIqWeHeACNF50ZsQqS7HA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-xhfLFBGTMUewArMp0gpaWw-1; Tue, 30 May 2023 16:54:47 -0400
X-MC-Unique: xhfLFBGTMUewArMp0gpaWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6E041C01E94;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93CE140CFD45;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CF46194F260;
	Tue, 30 May 2023 20:54:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA85E194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 21:51:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91B46140E954; Mon, 29 May 2023 21:51:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B395140E955
 for <dm-devel@redhat.com>; Mon, 29 May 2023 21:51:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C033858EEB
 for <dm-devel@redhat.com>; Mon, 29 May 2023 21:51:09 +0000 (UTC)
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com
 [91.218.175.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-ARWcOKxkNviqol00vsvMNA-1; Mon, 29 May 2023 17:51:06 -0400
X-MC-Unique: ARWcOKxkNviqol00vsvMNA-1
Date: Mon, 29 May 2023 17:43:53 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZHUcmeYrUmtytdDU@moria.home.lan>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
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
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
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

I've got some existing ktest tests for error injection:
https://evilpiepirate.org/git/ktest.git/tree/tests/bcachefs/single_device.ktest#n200
https://evilpiepirate.org/git/ktest.git/tree/tests/bcachefs/replication.ktest#n491

I haven't looked at dm-flakey before, I take it you're silently
corrupting data instead of just failing the IOs like these tests do?

Let's add what you're doing to ktest, and see if we can merge it with
the existing tests.

> I created a bcachefs volume on a single disk (metadata and data checksums 
> were turned off) and mounted it on dm-flakey. I got:
> 
> crash: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash1.txt
> deadlock: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash2.txt
> infinite loop: https://people.redhat.com/~mpatocka/testcases/bcachefs/crash3.txt

Fun!

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

Good catches on all of them. Darrick's been on me to get fuzz testing
going, looks like it's definitely needed :)

However, there's two things I want in place first before I put much
effort into fuzz testing:

 - Code coverage analysis. ktest used to have integrated code coverage
   analysis, where you'd tell it a subdirectory of the kernel tree
   (doing code coverage analysis for the entire kernel is impossibly
   slow) and it would run tests and then give you the lcov output.

   However, several years ago something about kbuild changed, and the
   method ktest was using for passing in build flags for a specific
   subdir on the command line stopped working. I would like to track
   down someone who understands kbuild and get this working again.

 - Fault injection

   Years and years ago, when I was still at Google and this was just
   bcache, we had fault injection that worked like dynamic debug: you
   could call dynamic_fault("type of fault") anywhere in your code,
   and it returned a bool indicating whether that fault had been enabled
   - and faults were controllable at runtime via debugfs, we had tests
   that iterated over e.g. faults in the initialization path, or memory
   allocation failures, and flipped them on one by one and ran
   $test_workload.

   The memory allocation profiling stuff that Suren and I have been
   working on includes code tagging, which is for (among other things) a
   new and simplified implementation of dynamic fault injection, which
   I'm going to push forward again once the memory allocation profiling
   stuff gets merged.

The reason I want this stuff is because fuzz testing tends to be a
heavyweight, scattershot approach.

I want to be able to look at the code coverage analysis first to e.g.
work on a chunk of code at a time and make sure it's tested thoroughly,
instead of jumping around in the code at random depending on what fuzz
testing finds, and when we are fuzz testing I want to be able to add
fault injection points and write unit tests so that we can have much
more targeted, quicker to run tests going forward.

Can I get you interested in either of those things? I'd really love to
find someone to hand off or collaborate with on the fault injection
stuff in particular.

> Bcachefs gives not much usefull error messages, like "Fatal error: Unknown 
> error 2184" or "Error in recovery: cannot allocate memory" or "mount(2) 
> system call failed: Unknown error 2186." or "rm: cannot remove 
> '/mnt/test/xfstests-dev/tools/fs-walk': Unknown error 2206".

Those are mostly missing bch2_err_str()/bch2_err_class() calls:
 - bch2_err_str(), to print error string for our private error code
 - bch2_err_class(), to convert private error code to standard error
   code before returning it to outside bcachefs code

except error in recovery, cannot allocate memory - that's ancient code
that still squashes to -ENOMEM

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

