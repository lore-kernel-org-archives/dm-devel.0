From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Thu, 16 Apr 2009 22:28:51 -0400
Message-ID: <20090417022851.GC23152@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090416205720.GI8896@redhat.com>
	<20090417021139.GB23152@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090417021139.GB23152@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>, linux-kernel@vger.kernel.org, Moyer Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Nauman Rafique <nauman@google.com>, Morton Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, agk@redhat.com, Andrea Righi <righi.andrea@gmail.com>
List-Id: dm-devel.ids

On Thu, Apr 16, 2009 at 10:11:39PM -0400, Vivek Goyal wrote:
> On Thu, Apr 16, 2009 at 04:57:20PM -0400, Vivek Goyal wrote:
> > On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> > > Hi Alasdair and all,
> > > 
> > > I did more tests on dm-ioband and I've posted the test items and
> > > results on my website. The results are very good.
> > > http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> > > 
> > > I hope someone will test dm-ioband and report back to the dm-devel
> > > mailing list.
> > > 
> > 
> 
> Ok, one more test. This time to show that with single queue and FIFO
> dispatch a writer can easily starve the reader.
> 
> I have created two partitions /dev/sda1 and /dev/sda2. Two ioband devices
> ioband1 and ioband2 on /dev/sda1 and /dev/sda2 respectively with weights
> 40 and 20.
> 
> I am launching an aggressive writer dd with prio 7 (Best effort) and a
> reader with prio 0 (Best effort).
> 
> Following is my script.
> 
> ****************************************************************
> rm /mnt/sdd1/aggressivewriter
> 
> sync
> echo 3 > /proc/sys/vm/drop_caches
> 
> #launch an hostile writer
> ionice -c2 -n7 dd if=/dev/zero of=/mnt/sdd1/aggressivewriter bs=4K count=524288 conv=fdatasync &
> 
> # Reader
> ionice -c 2 -n 0 dd if=/mnt/sdd1/testzerofile1 of=/dev/null &
> wait $!
> echo "reader finished"
> **********************************************************************

More results. Same reader writer test as above, the only variation I 
have done is change the class of reader to RT from BE.

ionice -c 1 -n 0 dd if=/mnt/sdd1/testzerofile1 of=/dev/null &

Even chaning the class of reader does not help. Writer still starves the
reader.

Without dm-ioband
=================
First run
2147483648 bytes (2.1 GB) copied, 43.9096 s, 48.9 MB/s (Reader)
reader finished
2147483648 bytes (2.1 GB) copied, 85.9094 s, 25.0 MB/s (Writer)

Second run
2147483648 bytes (2.1 GB) copied, 40.2446 s, 53.4 MB/s (Reader)
reader finished
2147483648 bytes (2.1 GB) copied, 82.723 s, 26.0 MB/s (Writer)

With dm-ioband
==============
First run
2147483648 bytes (2.1 GB) copied, 69.0272 s, 31.1 MB/s (Writer)
2147483648 bytes (2.1 GB) copied, 89.3037 s, 24.0 MB/s (Reader)
reader finished

Second run
2147483648 bytes (2.1 GB) copied, 64.8751 s, 33.1 MB/s (Writer)
2147483648 bytes (2.1 GB) copied, 89.0273 s, 24.1 MB/s (Reader)
reader finished

Thanks
Vivek
