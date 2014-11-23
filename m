From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH ] drivers/md: use proper rcu accessor
Date: Sun, 23 Nov 2014 09:31:13 -0800
Message-ID: <1416763873.17888.33.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
	 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20141121133145.GA17245@node.dhcp.inet.fi> <546F4C8C.4040904@gmail.com>
	 <20141121145817.GA17710@node.dhcp.inet.fi>
	 <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
	 <1416760829.17888.19.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAMM=eLe5mXBfg_W=bjkFN3_pVAYi1WqRr4nOb90aveA3LvaGDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMM=eLe5mXBfg_W=bjkFN3_pVAYi1WqRr4nOb90aveA3LvaGDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com, =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, 2014-11-23 at 11:53 -0500, Mike Snitzer wrote:
> On Sun, Nov 23, 2014 at 11:40 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > rcu_dereference() should be used in sections protected by rcu_read_lock.
> >
> > For writers, holding some kind of mutex or lock,
> > rcu_dereference_protected() is the way to go, adding explicit lockdep
> > bits.
> >
> > In __unbind(), although there is no mutex or lock held, we are about
> > to free the mapped device, so can use the constant '1' instead of a
> > lockdep_is_held()
> 
> That isn't true.  dm_hash_remove_all() -- which calls dm_destroy --
> holds _hash_lock.  Why leave __unbind() brittle in the face of future
> DM locking changes?
> 

Well, tell me. Before the 33423974bfc1 patch there was no protection.

If really you are about to delete an object, you have to be sure no one
is going to use it.

rcu_dereference_protected(X, 1) is how we express this thing, there is
nothing wrong here.

Fact that you hold a lock at this point is irrelevant and wont protect
the bug from happening. If you believe so, then you are wrong.


> > Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Fixes: 33423974bfc1 ("dm: Use rcu_dereference() for accessing rcu pointer")
> > Cc: Pranith Kumar <bobby.prani@gmail.com>
> 
> Hi Eric,
> 
> I'll pick this up once I get clarification for why your __unbind
> change is safe.. but it really would've helped if you cc'd
> dm-devel@redhat.com or myself directly (not a single person that you
> cc'd actively maintains DM).
> 

Hmm, my mailer complained because the mail had too many recipients
already. I did a 'reply' on the original thread.

> Hopefully these DM rcu "fixes" are finished after this.

You added a Signed-off-by on 33423974bfc1, not me.

Kirill gave the report 2 days ago and so far nobody fixed it.

I will send a v2 because other rcu_dereference() need to be changed as
well.
