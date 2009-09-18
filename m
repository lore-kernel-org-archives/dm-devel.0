From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: ioband: Limited fairness and weak isolation between groups
Date: Fri, 18 Sep 2009 16:33:43 +0900 (JST)
Message-ID: <20090918.163343.193694346.ryov@valinux.co.jp>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<20090916044501.GB3736@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753771AbZIRHdm@vger.kernel.org>
In-Reply-To: <20090916044501.GB3736@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, riel@redhat.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> I ran following test. Created two groups of weight 100 each and put a 
> sequential dd reader in first group and put buffered writers in second
> group and let it run for 20 seconds and observed at the end of 20 seconds
> which group got how much work done. I ran this test multiple time, while
> increasing the number of writers by one each time. Did test this with
> dm-ioband and with io scheduler based io controller patches.

I did the same test on my environment (2.6.31 + dm-ioband v1.13.0) and
here are the results.

      The number of sectors transferred
  writers   read    write   total
     1     800696  588600  1389296
     2     747704  430736  1178440
     3     757136  455808  1212944
     4     704888  562912  1267800
     5     788760  387672  1176432
     6     730664  495832  1226496
     7     765864  427384  1193248

I got the different results to yours, the total throughput did not
decreased according to increasing the number of writers. I've attached
the outputs of the test script. Please note that the format of
"dmsetup status" have been changed like /sys/block/dev/stat file.

launched reader 3567
launched 1 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 85 0 680 0 100087 0 800696 0 384 0 0
ioband1: 0 112455000 ioband share1 -1 4673 0 588600 0 0 0 0 0 0 0 0

launched reader 3575
launched 2 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 197 0 1576 0 93463 0 747704 0 384 0 0
ioband1: 0 112455000 ioband share1 -1 3420 0 430736 0 0 0 0 0 0 0 0

launched reader 3584
launched 3 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 237 0 1896 0 94642 0 757136 0 384 0 0
ioband1: 0 112455000 ioband share1 -1 3614 0 455808 0 0 0 0 0 0 0 0

launched reader 3594
launched 4 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 207 0 1656 0 88111 0 704888 0 159 0 0
ioband1: 0 112455000 ioband share1 -1 4462 0 562912 0 0 0 0 0 0 0 0

launched reader 3605
launched 5 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 234 0 1872 0 98595 0 788760 0 384 0 0
ioband1: 0 112455000 ioband share1 -1 3077 0 387672 0 0 0 0 0 0 0 0

launched reader 3618
launched 6 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 215 0 1720 0 91333 0 730664 0 384 0 0
ioband1: 0 112455000 ioband share1 -1 3937 0 495832 0 0 0 0 0 0 0 0

launched reader 3631
launched 7 writers
waiting for 20 seconds
ioband2: 0 112455000 ioband share1 -1 245 0 1960 0 95733 0 765864 0 384 0 0
ioband1: 0 112455000 ioband share1 -1 3391 0 427384 0 0 0 0 0 0 0 0

Thanks,
Ryo Tsuruta
