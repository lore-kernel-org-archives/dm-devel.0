From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] branch-check: fix long->int truncation when profiling
 branches
Date: Mon, 4 Jun 2018 16:54:44 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806041653260.18196@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180528155432.2864616-1-arnd@arndb.de> <alpine.LRH.2.02.1805300818140.24812@file01.intranet.prod.int.rdu2.redhat.com> <20180604165024.3be78887@gandalf.local.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180604165024.3be78887@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: dm-devel.ids



On Mon, 4 Jun 2018, Steven Rostedt wrote:

> On Wed, 30 May 2018 08:19:22 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > The function __builtin_expect returns long type (see the gcc
> > documentation), and so do macros likely and unlikely. Unfortunatelly, when
> > CONFIG_PROFILE_ANNOTATED_BRANCHES is selected, the macros likely and
> > unlikely expand to __branch_check__ and __branch_check__ truncates the
> 
> Nice catch.
> 
> > long type to int. This unintended truncation may cause bugs in various
> > kernel code (we found a bug in dm-writecache because of it), so it's
> 
> I'm curious to what that bug was.

printk("%ld", writecache_has_error(wc))

... and writecache_has_error was defined as
#define writecache_has_error(wc)	(unlikely(READ_ONCE((wc)->error)))

Mikulas
