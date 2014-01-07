From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: kobject: provide kobject_put_wait to fix module
	unload race
Date: Tue, 7 Jan 2014 17:32:20 -0500
Message-ID: <20140107223220.GA20588@redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
	<52C98BCC.9040900@acm.org> <20140105182640.GA2522@kroah.com>
	<alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com>
	<20140106213111.GA2536@redhat.com>
	<alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com>
	<CA+55aFw+kS-jJencvQgQcn0yTw_a4=2RDynopL7Gu0PNemkUvA@mail.gmail.com>
	<alpine.LRH.2.02.1401071253510.8158@file01.intranet.prod.int.rdu2.redhat.com>
	<20140107191910.GA8884@redhat.com>
	<alpine.LRH.2.02.1401071506420.26598@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401071506420.26598@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-Id: dm-devel.ids

On Tue, Jan 07 2014 at  3:16pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Tue, 7 Jan 2014, Mike Snitzer wrote:
> 
> > I've staged your patch in linux-next for 3.14, see:
> > http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=af7b1e5c767fc895788c971c8f4686402ac8344f
> 
> Looking at this patch, I realize that it is buggy too. If module unload 
> happens at this point (after the completion is signaled, but before the 
> release function returns), it crashes.
> 
> static void dm_kobject_release(struct kobject *kobj)
> {
> 	complete(dm_get_completion_from_kobject(kobj));
> 	>========== module unload here ===============<
> }

That race isn't a surprise, thought you pointed it out earlier in this
thread?  Anyway, I'm inclined to keep the racey patch staged in
linux-dm.git until the stalemate with gregkh is resolved.  DM is no
worse than other code that follows this same wait for completion
pattern.

> The patch that I sent initially in this thread doesn't have this bug 
> because the completion is signaled in non-module code.
> 
> That goes back to my initial claim - it is impossible to use the kobject 
> interface correctly! But if Greg doesn't want a patch that fixes the 
> kobject interface, I don't really know what to do about it.

Right, I'm missing what is wrong with your proposed kobject_put_wait
interface.

Greg, can you please establish that you understand the problem, and
existing kobject patterns, before you dismiss a fix?
