From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Mon, 29 Jun 2009 20:04:17 +0400
Message-ID: <4A48E601.2050203@vlnb.net>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760650AbZF2QEr@vger.kernel.org>
In-Reply-To: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Hi,

Vivek Goyal, on 06/20/2009 12:37 AM wrote:
> Hi All,
> 
> Here is the V5 of the IO controller patches generated on top of 2.6.30.
> 
> Previous versions of the patches was posted here.
> 
> (V1) http://lkml.org/lkml/2009/3/11/486
> (V2) http://lkml.org/lkml/2009/5/5/275
> (V3) http://lkml.org/lkml/2009/5/26/472
> (V4) http://lkml.org/lkml/2009/6/8/580
> 
> This patchset is still work in progress but I want to keep on getting the
> snapshot of my tree out at regular intervals to get the feedback hence V5.

[..]

> Testing
> =======
> 
> I have been able to do only very basic testing of reads and writes.
> 
> Test1 (Fairness for synchronous reads)
> ======================================
> - Two dd in two cgroups with cgrop weights 1000 and 500. Ran two "dd" in those
>   cgroups (With CFQ scheduler and /sys/block/<device>/queue/fairness = 1)
> 
> dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null &
> dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null &
> 
> 234179072 bytes (234 MB) copied, 3.9065 s, 59.9 MB/s
> 234179072 bytes (234 MB) copied, 5.19232 s, 45.1 MB/s

Sorry, but the above isn't a correct way to test proportional fairness 
for synchronous reads. You need throughput only when *both* dd's 
running, don't you?

Considering both transfers started simultaneously (which isn't obvious 
too) in the way you test the throughput value only for the first 
finished dd is correct, because after it finished, the second dd started 
transferring data *alone*, hence the result throughput value for it got 
partially for simultaneous, partially for alone reads, i.e. screwed.

I'd suggest you instead test as 2 runs of:

1. while true; do dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null; done
    dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null

2. while true; do dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null; done
    dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null

and take results from the standalone dd's.

Vlad
