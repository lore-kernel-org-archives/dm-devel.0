From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Remove might_sleep from wait_event_cmd
Date: Tue, 3 Feb 2015 12:06:30 +0100
Message-ID: <20150203110630.GK26304@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1502020935580.13510@file01.intranet.prod.int.rdu2.redhat.com>
 <20150203091253.60ded1d7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150203091253.60ded1d7@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 03, 2015 at 09:12:53AM +1100, NeilBrown wrote:
> I support this patch.

It should hopefully already be en-route to tip.

> However in case it doesn't get in, I've queued up a patch to change raid5.c
> to use __wait_event_cmd instead...

So those primitives are useful in their own; their typical use would be
when you already know @cond to be false and want to avoid the extra
invocation.
