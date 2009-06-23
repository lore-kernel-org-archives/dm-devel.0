From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Tue, 23 Jun 2009 12:22:42 +0530
Message-ID: <20090623065242.GI8642@balbir.in.ibm.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <20090621152116.GC3728@balbir.in.ibm.com> <20090622153030.GA15600@redhat.com> <x497hz4l1j9.fsf@segfault.boston.devel.redhat.com> <20090622160207.GC15600@redhat.com> <x493a9sl0bx.fsf@segfault.boston.devel.redhat.com> <20090622170812.GD15600@redhat.com>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754406AbZFWGxk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090622170812.GD15600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

* Vivek Goyal <vgoyal@redhat.com> [2009-06-22 13:08:12]:

> On Mon, Jun 22, 2009 at 12:06:42PM -0400, Jeff Moyer wrote:
> > Vivek Goyal <vgoyal@redhat.com> writes:
> > 
> > > On Mon, Jun 22, 2009 at 11:40:42AM -0400, Jeff Moyer wrote:
> > >> Vivek Goyal <vgoyal@redhat.com> writes:
> > >> 
> > >> > On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
> > >> >> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
> > >> >> 
> > >> >> > 
> > >> >> > Hi All,
> > >> >> > 
> > >> >> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
> > >> >> [snip]
> > >> >> 
> > >> >> > Testing
> > >> >> > =======
> > >> >> >
> > >> >> 
> > >> >> [snip]
> > >> >> 
> > >> >> I've not been reading through the discussions in complete detail, but
> > >> >> I see no reference to async reads or aio. In the case of aio, aio
> > >> >> presumes the context of the user space process. Could you elaborate on
> > >> >> any testing you've done with these cases? 
> > >> >> 
> > >> >
> > >> > Hi Balbir,
> > >> >
> > >> > So far I had not done any testing with AIO. I have done some just now.
> > >> > Here are the results.
> > >> >
> > >> > Test1 (AIO reads)
> > >> > ================
> > >> > Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
> > >> > respectively. I am using cfq scheduler. Following are some lines from my test
> > >> > script.
> > >> >
> > >> > ===================================================================
> > >> > fio_args="--ioengine=libaio --rw=read --size=512M"
> > >> 
> > >> AIO doesn't make sense without O_DIRECT.
> > >> 
> > >
> > > Ok, here are the read results with --direct=1 for reads. In previous posting,
> > > writes were already direct.
> > >
> > > test1 statistics: time=8 16 20796   sectors=8 16 1049648
> > > test2 statistics: time=8 16 10551   sectors=8 16 581160
> > >
> > >
> > > Not sure why reads are so slow with --direct=1? In the previous test
> > > (no direct IO), I had cleared the caches using
> > > (echo 3 > /proc/sys/vm/drop_caches) so reads could not have come from page
> > > cache?
> > 
> > O_DIRECT bypasses the page cache, and hence the readahead code.  Try
> > driving deeper queue depths and/or using larger I/O sizes.
> 
> Ok. Thanks. I tried increasing iodepth to 20 and it helped a lot.
> 
> test1 statistics: time=8 16 6672   sectors=8 16 1049656
> test2 statistics: time=8 16 3508   sectors=8 16 583432
>

Good to see.. Thanks! 

-- 
	Balbir
