From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 21:09:36 +0200
Message-ID: <20091002190936.GT31616@kernel.dk>
References: <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	<20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	<20091002173732.GK31616@kernel.dk> <20091002175629.GA14860@elte.hu>
	<20091002180437.GL31616@kernel.dk> <20091002183649.GE8161@mit.edu>
	<20091002184549.GS31616@kernel.dk> <20091002190110.GA25297@elte.hu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091002190110.GA25297@elte.hu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ingo Molnar <mingo@elte.hu>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Theodore Tso <tytso@mit.edu>, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Oct 02 2009, Theodore Tso wrote:
> > > On Fri, Oct 02, 2009 at 08:04:37PM +0200, Jens Axboe wrote:
> > > > > i'd say 'latency' describes it even better. 'interactivity' as a term is 
> > > > > a bit overladen.
> > > > 
> > > > I'm not too crazy about it either. How about just using 'desktop' 
> > > > since this is obviously what we are really targetting? 'latency' 
> > > > isn't fully descriptive either, since it may not necessarily 
> > > > provide the best single IO latency (noop would).
> > > 
> > > As Linus has already pointed out, it's not necessarily "desktop" 
> > > versus "server".  There will be certain high frequency transaction 
> > > database workloads (for example) that will very much care about 
> > > latency.  I think "low_latency" may be the best term to use.
> > 
> > Not necessarily, but typically it will be. As already noted, I don't 
> > think latency itself is a very descriptive term for this.
> 
> Why not? Nobody will think of 'latency' as something that requires noop, 
> but as something that in practice achieves low latencies, for stuff that 
> people use.

Alright, I'll acknowledge that if that's the general consensus. I may be
somewhat biased myself.

-- 
Jens Axboe
