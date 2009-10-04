From: Mike Galbraith <efault@gmx.de>
Subject: Re: Do not overload dispatch queue (Was: Re: IO
 scheduler based IO controller V10)
Date: Mon, 05 Oct 2009 00:15:27 +0200
Message-ID: <1254694527.7175.14.camel@marge.simson.net>
References: <1254585420.7539.2.camel@marge.simson.net>
	<20091003173532.GG31616@kernel.dk>
	<1254596864.7153.9.camel@marge.simson.net>
	<20091003192321.GA26573@kernel.dk>
	<1254599386.7153.46.camel@marge.simson.net>
	<1254653434.7237.18.camel@marge.simson.net>
	<20091004173901.GD26573@kernel.dk>
	<1254680622.27889.2.camel@marge.simson.net>
	<20091004183822.GF26573@kernel.dk>
	<1254685638.7637.6.camel@marge.simson.net>
	<20091004201708.GJ26573@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091004201708.GJ26573@kernel.dk>
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

On Sun, 2009-10-04 at 22:17 +0200, Jens Axboe wrote:
> On Sun, Oct 04 2009, Mike Galbraith wrote:
> > On Sun, 2009-10-04 at 20:38 +0200, Jens Axboe wrote:
> > > On Sun, Oct 04 2009, Mike Galbraith wrote:
> > > > On Sun, 2009-10-04 at 19:39 +0200, Jens Axboe wrote:
> > > > 
> > > > > So I'll commit a change that doesn't do the delay at all, basically it
> > > > > just offset the current code by one slice.
> > > > 
> > > > Ok, when it hits block-for-linus, I'll take it out for a spin.
> > > 
> > > It's committed:
> > > 
> > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=e00c54c36ac2024c3a8a37432e2e2698ff849594
> > 
> > Looks like a keeper to me :)
> 
> Wonderful, so I take it this passes your 'gut feel' test too? :-)

Heh, yeah.  Box feels good, disk sounds happy.. none of those little
indescribables that make you suddenly go alert.

	-Mike
