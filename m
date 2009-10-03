From: Mike Galbraith <efault@gmx.de>
Subject: Re: Do not overload dispatch queue (Was: Re: IO
 scheduler based IO controller V10)
Date: Sat, 03 Oct 2009 21:49:46 +0200
Message-ID: <1254599386.7153.46.camel@marge.simson.net>
References: <20091003124049.GB12925@redhat.com>
	<20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com>
	<1254578553.7499.5.camel@marge.simson.net>
	<20091003142840.GE31616@kernel.dk>
	<1254581496.8293.8.camel@marge.simson.net>
	<20091003151445.GF31616@kernel.dk>
	<1254585420.7539.2.camel@marge.simson.net>
	<20091003173532.GG31616@kernel.dk>
	<1254596864.7153.9.camel@marge.simson.net>
	<20091003192321.GA26573@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091003192321.GA26573@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Sat, 2009-10-03 at 21:23 +0200, Jens Axboe wrote:
> On Sat, Oct 03 2009, Mike Galbraith wrote:

> > > So that's pure goodness, at least.
> > 
> > Yeah, but it's a double edged sword, _maybe_ cut too far in the other
> > direction.  (impression)
> 
> How can it be too fast? IOW, I think you'll have to quantify that
> statement :-)

Oh boy.  It it were perfectly fair, it should be roughly twice the time
it takes to load seekily when running solo, which it's exceeded
considerably.  I'm not complaining mind you, just being a worry wart.
Previously the reader was suffering the pains of hell, which the two
dinky changes made match my expectations nearly perfectly (1.7 sec is
real close to 1.8, which is real close to the 0.9 it takes to get the
bugger loaded cold)

> > > So far that looks like a winner. The dictator wanted good latency, he's
> > > getting good latency. I'll continue working on this on monday, while I'm
> > > waiting for delivery of the Trabant.
> > 
> > I'm unsure feel wise.  Disk is sounding too seeky, which worries me.
> 
> Care to elaborate on the feel? Seekiness is not good of course,
> depending on timing the async delay could cause some skipping back and
> forth. But remember that when you don't hear the disk, it could likely
> be doing the async IO which will make the disk very quiet (since it's
> just a streamed write). The konsole test is bound to cause seeks, when
> it's juggling async IO too. Even alone it's likely pretty seeky. So is
> the seekiness persistent, or just shortly when starting konsole?

It's a huge winner for sure, and there's no way to quantify.  I'm just
afraid the other shoe will drop from what I see/hear.  I should have
kept my trap shut and waited really, but the impression was strong.
Sorry for making unquantifiable noise.  Ignore me.  I've been
watching/feeling tests for too many hours and hours and hours ;-)

	-Mike
