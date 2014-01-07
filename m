From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: kobject: provide kobject_put_wait to fix module unload race
Date: Tue, 7 Jan 2014 15:16:41 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401071506420.26598@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <52C98BCC.9040900@acm.org> <20140105182640.GA2522@kroah.com> <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com> <20140106213111.GA2536@redhat.com>
 <alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFw+kS-jJencvQgQcn0yTw_a4=2RDynopL7Gu0PNemkUvA@mail.gmail.com> <alpine.LRH.2.02.1401071253510.8158@file01.intranet.prod.int.rdu2.redhat.com>
 <20140107191910.GA8884@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140107191910.GA8884@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>
List-Id: dm-devel.ids



On Tue, 7 Jan 2014, Mike Snitzer wrote:

> On Tue, Jan 07 2014 at  1:00pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Tue, 7 Jan 2014, Linus Torvalds wrote:
> > 
> > > This looks completely broken to me. You do a "kobject_put()" and then
> > > after you've dropped that last use, you wait for the completion of
> > > something that may already have been free'd.
> > > 
> > > Wtf? Am I missing something?
> > > 
> > >                Linus
> > 
> > It is correct. The release method dm_kobject_release doesn't free the 
> > kobject. It just signals the completion and returns.
> > 
> > This is the sequence of operations:
> > * call kobject_put
> > * wait until all users stop using the kobject, when it happens the release 
> >   method is called
> > * the release method signals the completion and returns
> > * the unload code that waits on the completion continues
> > * the unload code frees the mapped_device structure that contains the 
> >   kobject
> > 
> > Using kobject this way avoids the module unload race that was mentioned at 
> > the beginning of this thread.
> 
> I've staged your patch in linux-next for 3.14, see:
> http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=af7b1e5c767fc895788c971c8f4686402ac8344f

Looking at this patch, I realize that it is buggy too. If module unload 
happens at this point (after the completion is signaled, but before the 
release function returns), it crashes.

static void dm_kobject_release(struct kobject *kobj)
{
	complete(dm_get_completion_from_kobject(kobj));
	>========== module unload here ===============<
}

The patch that I sent initially in this thread doesn't have this bug 
because the completion is signaled in non-module code.

That goes back to my initial claim - it is impossible to use the kobject 
interface correctly! But if Greg doesn't want a patch that fixes the 
kobject interface, I don't really know what to do about it.

Maybe another possibility - maintain a list of all kobjects and walk them 
in the generic module unload code to check if their release method ponits 
to the module that is being unloaded? Greg, would you accept a patch like 
this?

Mikulas
