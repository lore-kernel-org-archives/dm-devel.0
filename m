From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: Oops when using dm-crypt with dpt_i2o
Date: Fri, 3 Aug 2007 13:52:39 -0700
Message-ID: <20070803135239.42ae6208.akpm@linux-foundation.org>
References: <46B0D4B4.2040809@web.de>
	<20070803110430.88a4b543.akpm@linux-foundation.org>
	<46B39416.7040809@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B39416.7040809@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Philipp =?ISO-8859-1?Q?T=F6lke?= <philipptoelke@web.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

On Fri, 03 Aug 2007 22:46:14 +0200
Philipp T__lke <philipptoelke@web.de> wrote:

> Hi Andrew, hi everybody!
> 
> Thanks for the reply!
> 
> Andrew Morton wrote:
> >> The oopses:
> >>
> >> #v+
> >> BUG: unable to handle kernel paging request at virtual address 14001000
> >> [...]
> > 
> > So it looks like q->request_fn points at 0x14001000, which is in outer
> > space.
> > 
> > I wonder how that could happen, in the middle of heavy IO operations. 
> > Possibly a memory scribble.  I'd suggest you enable CONFIG_SLAB,
> > CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC.
> 
> That doesn't change anything, apart from adding a line "DEBUG_PAGEALLOC"
> to the oopses.

drat.

> Do I have to enable the debugging manually? After a quick
> grep over the sources and a google-session I think not but I'm no
> kernel-hacker.

No, just enable it.

> > You could also try switching
> > from CONFIG_SLAB to CONFIG_SLUB, then enable CONFIG_SLUB_DEBUG.
> 
> Unfortunately the only change seems to be, that the Keyboard-Leds don't
> flash after the crash. Everything else is the same.

drat.

> Could a hardware-error cause this?

It sounds unlikely.  One wouldn't expect it to crash in the same way each
time.
