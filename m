From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Mon, 22 Jun 2009 12:02:07 -0400
Message-ID: <20090622160207.GC15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<20090621152116.GC3728@balbir.in.ibm.com>
	<20090622153030.GA15600@redhat.com>
	<x497hz4l1j9.fsf@segfault.boston.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <x497hz4l1j9.fsf@segfault.boston.devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, Balbir Singh <balbir@linux.vnet.ibm.com>, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 22, 2009 at 11:40:42AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
> >> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
> >> 
> >> > 
> >> > Hi All,
> >> > 
> >> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
> >> [snip]
> >> 
> >> > Testing
> >> > =======
> >> >
> >> 
> >> [snip]
> >> 
> >> I've not been reading through the discussions in complete detail, but
> >> I see no reference to async reads or aio. In the case of aio, aio
> >> presumes the context of the user space process. Could you elaborate on
> >> any testing you've done with these cases? 
> >> 
> >
> > Hi Balbir,
> >
> > So far I had not done any testing with AIO. I have done some just now.
> > Here are the results.
> >
> > Test1 (AIO reads)
> > ================
> > Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
> > respectively. I am using cfq scheduler. Following are some lines from my test
> > script.
> >
> > ===================================================================
> > fio_args="--ioengine=libaio --rw=read --size=512M"
> 
> AIO doesn't make sense without O_DIRECT.
> 

Ok, here are the read results with --direct=1 for reads. In previous posting,
writes were already direct.

test1 statistics: time=8 16 20796   sectors=8 16 1049648
test2 statistics: time=8 16 10551   sectors=8 16 581160


Not sure why reads are so slow with --direct=1? In the previous test
(no direct IO), I had cleared the caches using
(echo 3 > /proc/sys/vm/drop_caches) so reads could not have come from page
cache?

Thanks
Vivek
