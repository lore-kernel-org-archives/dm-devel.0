Return-Path: <SRS0=Tzat=JZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A9FC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 14:06:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC892613FA
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 14:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC892613FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-Y3RSqEGpOZKQk78bObQbVw-1; Wed, 28 Apr 2021 10:06:02 -0400
X-MC-Unique: Y3RSqEGpOZKQk78bObQbVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A885D8018A7;
	Wed, 28 Apr 2021 14:05:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A76D160938;
	Wed, 28 Apr 2021 14:05:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52FA51806D06;
	Wed, 28 Apr 2021 14:05:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13SE5nlX026681 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Apr 2021 10:05:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BBD6210624E; Wed, 28 Apr 2021 14:05:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7A90103CB0
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 14:05:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE7D2858F0D
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 14:05:46 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-243-3ndMknEqPeK4JhUUqvTxsA-1; Wed, 28 Apr 2021 10:05:45 -0400
X-MC-Unique: 3ndMknEqPeK4JhUUqvTxsA-1
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net
	[72.74.133.215]) (authenticated bits=0)
	(User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13SE3HW3018990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 28 Apr 2021 10:03:17 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id DB1D515C3C3D; Wed, 28 Apr 2021 10:03:16 -0400 (EDT)
Date: Wed, 28 Apr 2021 10:03:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: kernel test robot <oliver.sang@intel.com>
Message-ID: <YIlrJCdhVaFPdPgb@mit.edu>
References: <20210427081539.GF32408@xsang-OptiPlex-9020>
MIME-Version: 1.0
In-Reply-To: <20210427081539.GF32408@xsang-OptiPlex-9020>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org, dm-devel@redhat.com,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: Re: [dm-devel] [ext4] 21175ca434:
 mdadm-selftests.enchmarks/mdadm-selftests/tests/01r1fail.fail
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

(Hmm, why did you cc linux-km on this report?  I would have thought
dm-devel would have made more sense?)

On Tue, Apr 27, 2021 at 04:15:39PM +0800, kernel test robot wrote:
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 21175ca434c5d49509b73cf473618b01b0b85437 ("ext4: make prefetch_block_bitmaps default")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 

> in testcase: mdadm-selftests
> version: mdadm-selftests-x86_64-5d518de-1_20201008
> with following parameters:
> 
> 	disk: 1HDD
> 	test_prefix: 01r1
> 	ucode: 0x21

So this failure makes no sense to me.  Looking at the kmesg failure
logs, it's failing in the md layer:

kern  :info  : [   99.775514] md/raid1:md0: not clean -- starting background reconstruction
kern  :info  : [   99.783372] md/raid1:md0: active with 3 out of 4 mirrors
kern  :info  : [   99.789735] md0: detected capacity change from 0 to 37888
kern  :info  : [   99.796216] md: resync of RAID array md0
kern  :crit  : [   99.900450] md/raid1:md0: Disk failure on loop2, disabling device.
                              md/raid1:md0: Operation continuing on 2 devices.
kern  :crit  : [   99.918281] md/raid1:md0: Disk failure on loop1, disabling device.
                              md/raid1:md0: Operation continuing on 1 devices.
kern  :info  : [  100.835833] md: md0: resync interrupted.
kern  :info  : [  101.852898] md: resync of RAID array md0
kern  :info  : [  101.858347] md: md0: resync done.
user  :notice: [  102.109684] /lkp/benchmarks/mdadm-selftests/tests/01r1fail... FAILED - see /var/tmp/01r1fail.log and /var/tmp/fail01r1fail.log for details

The referenced commit just turns block bitmap prefetching in ext4.
This should not cause md to failure; if so, that's an md bug, not an
ext4 bug.  There should not be anything that the file system is doing
that would cause the kernel to think there is a disk failure.

By the way, the reproduction instructions aren't working currently:

> To reproduce:
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install                job.yaml  # job file is attached in this email

This fails because lkp is trying to apply a patch which does not apply
with the current version of the md tools.

>         bin/lkp split-job --compatible job.yaml
>         bin/lkp run                    compatible-job.yaml

And the current versions lkp don't generate a compatible-job.yaml file
when you run "lkp split-job --compatable"; instead it generates a new
yaml file with a set of random characters to generate a unique name.
(What Multics parlance would be called a "shriek name"[1] :-)

Since I was having trouble running the reproduction; could you send
the /var/tmp/*fail.logs so we could have a bit more insight what is
going on?

Thanks!

					- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

