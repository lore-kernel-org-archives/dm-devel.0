Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B341EC433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 493AB61206
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 493AB61206
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-p1rgR4GuNc66Flt83mIMKw-1; Mon, 17 May 2021 03:51:07 -0400
X-MC-Unique: p1rgR4GuNc66Flt83mIMKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56AF66D587;
	Mon, 17 May 2021 07:51:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E1E4917240;
	Mon, 17 May 2021 07:51:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 039F255350;
	Mon, 17 May 2021 07:51:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DEVKGb017768 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 10:31:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 38F612142F1B; Thu, 13 May 2021 14:31:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 334D2215AB05
	for <dm-devel@redhat.com>; Thu, 13 May 2021 14:31:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0992C18E0926
	for <dm-devel@redhat.com>; Thu, 13 May 2021 14:31:17 +0000 (UTC)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-230-Wl7fkdrAO1y_jBYUUJIWLQ-1; Thu, 13 May 2021 10:31:14 -0400
X-MC-Unique: Wl7fkdrAO1y_jBYUUJIWLQ-1
IronPort-SDR: cDjH1q1TKfnvTpBXy/Pi8gz1bsW9NS6Xud6Hcfl9kC0zl5lHTc8K7YIN6FHoYWsISIbtdYZHvC
	tXJhiOw40tog==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="261201776"
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; d="scan'208";a="261201776"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
	by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	13 May 2021 07:31:12 -0700
IronPort-SDR: 1w+Fr7BDs7KibBuHH2nvv7S7MWcDG+82O653mKtrOk34KnFyowG0bNYtCGTAELPU3W+m0/0ni1
	sGt8t7L1XcUQ==
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; d="scan'208";a="626232328"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020)
	([10.239.159.140]) by fmsmga005-auth.fm.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2021 07:31:10 -0700
Date: Thu, 13 May 2021 22:48:09 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <20210513144809.GF20142@xsang-OptiPlex-9020>
References: <20210427081539.GF32408@xsang-OptiPlex-9020>
	<YIlrJCdhVaFPdPgb@mit.edu>
MIME-Version: 1.0
In-Reply-To: <YIlrJCdhVaFPdPgb@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 17 May 2021 03:51:00 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Theodore,

On Wed, Apr 28, 2021 at 10:03:16AM -0400, Theodore Ts'o wrote:
> (Hmm, why did you cc linux-km on this report?  I would have thought
> dm-devel would have made more sense?)
> 
> On Tue, Apr 27, 2021 at 04:15:39PM +0800, kernel test robot wrote:
> > 
> > FYI, we noticed the following commit (built with gcc-9):
> > 
> > commit: 21175ca434c5d49509b73cf473618b01b0b85437 ("ext4: make prefetch_block_bitmaps default")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > 
> 
> > in testcase: mdadm-selftests
> > version: mdadm-selftests-x86_64-5d518de-1_20201008
> > with following parameters:
> > 
> > 	disk: 1HDD
> > 	test_prefix: 01r1
> > 	ucode: 0x21
> 
> So this failure makes no sense to me.  Looking at the kmesg failure
> logs, it's failing in the md layer:

just FYI. we rerun the tests for both parent and this commit, up to 56
times. the failure seems persistent on the commit, though not always.
but the test never failed on parent.

f68f4063855903fd 21175ca434c5d49509b73cf4736
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :56          61%          34:56    mdadm-selftests.enchmarks/mdadm-selftests/tests/01r1fail.fail


> 
> kern  :info  : [   99.775514] md/raid1:md0: not clean -- starting background reconstruction
> kern  :info  : [   99.783372] md/raid1:md0: active with 3 out of 4 mirrors
> kern  :info  : [   99.789735] md0: detected capacity change from 0 to 37888
> kern  :info  : [   99.796216] md: resync of RAID array md0
> kern  :crit  : [   99.900450] md/raid1:md0: Disk failure on loop2, disabling device.
>                               md/raid1:md0: Operation continuing on 2 devices.
> kern  :crit  : [   99.918281] md/raid1:md0: Disk failure on loop1, disabling device.
>                               md/raid1:md0: Operation continuing on 1 devices.
> kern  :info  : [  100.835833] md: md0: resync interrupted.
> kern  :info  : [  101.852898] md: resync of RAID array md0
> kern  :info  : [  101.858347] md: md0: resync done.
> user  :notice: [  102.109684] /lkp/benchmarks/mdadm-selftests/tests/01r1fail... FAILED - see /var/tmp/01r1fail.log and /var/tmp/fail01r1fail.log for details
> 
> The referenced commit just turns block bitmap prefetching in ext4.
> This should not cause md to failure; if so, that's an md bug, not an
> ext4 bug.  There should not be anything that the file system is doing
> that would cause the kernel to think there is a disk failure.
> 
> By the way, the reproduction instructions aren't working currently:
> 
> > To reproduce:
> > 
> >         git clone https://github.com/intel/lkp-tests.git
> >         cd lkp-tests
> >         bin/lkp install                job.yaml  # job file is attached in this email
> 
> This fails because lkp is trying to apply a patch which does not apply
> with the current version of the md tools.
> 
> >         bin/lkp split-job --compatible job.yaml
> >         bin/lkp run                    compatible-job.yaml
> 
> And the current versions lkp don't generate a compatible-job.yaml file
> when you run "lkp split-job --compatable"; instead it generates a new
> yaml file with a set of random characters to generate a unique name.
> (What Multics parlance would be called a "shriek name"[1] :-)
> 
> Since I was having trouble running the reproduction; could you send
> the /var/tmp/*fail.logs so we could have a bit more insight what is
> going on?
> 
> Thanks!
> 
> 					- Ted
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

