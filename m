From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V6
Date: Wed, 8 Jul 2009 09:41:14 -0400
Message-ID: <20090708134114.GA24048@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<20090708035621.GB3215@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090708035621.GB3215@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 08, 2009 at 09:26:21AM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-07-02 16:01:32]:
> 
> > 
> > Hi All,
> > 
> > Here is the V6 of the IO controller patches generated on top of 2.6.31-rc1.
> > 
> > Previous versions of the patches was posted here.
> > 
> > (V1) http://lkml.org/lkml/2009/3/11/486
> > (V2) http://lkml.org/lkml/2009/5/5/275
> > (V3) http://lkml.org/lkml/2009/5/26/472
> > (V4) http://lkml.org/lkml/2009/6/8/580
> > (V5) http://lkml.org/lkml/2009/6/19/279
> > 
> > This patchset is still work in progress but I want to keep on getting the
> > snapshot of my tree out at regular intervals to get the feedback hence V6.
> >
> 
> Hi, Vivek,
> 
> I was able to compile and boot a 2.6.31-rc1 kernel with this patchset.
> I have a request could you fold up all patches and make one
> consolidated patch available somewhere (makes it easier to test), may
> be a git tree?
> 

Thanks for trying it out balbir. Ok, for ease of patching and testing, I 
will also maintain a consolidated patch. For V6 you can download the patch
from here.

http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v6.patch

> I did some quick tests with some io benchmarks and found in a simple
> scenario that the scheduler worked as expected, except that it took
> very long. I'll investigate further and revert back.

Thanks. I will wait for details.

Vivek
