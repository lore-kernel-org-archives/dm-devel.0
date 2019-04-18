From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch V2 14/29] dm bufio: Simplify stack trace retrieval
Date: Thu, 18 Apr 2019 09:33:56 -0400
Message-ID: <20190418093356.5d4b7732@gandalf.local.home>
References: <20190418084119.056416939@linutronix.de>
        <20190418084254.361284697@linutronix.de>
        <CAG_fn=WP9+bVv9hedoaTzWK+xBzedxaGJGVOPnF0o115s-oWvg@mail.gmail.com>
        <alpine.DEB.2.21.1904181353420.3174@nanos.tec.linutronix.de>
        <CAG_fn=WL0yLqavV_mhodT=B6KcAzJ+LS0hss1jqany9Cn92RHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG_fn=WL0yLqavV_mhodT=B6KcAzJ+LS0hss1jqany9Cn92RHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Potapenko <glider@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev <kasan-dev@googlegroups.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linu
List-Id: dm-devel.ids

On Thu, 18 Apr 2019 14:11:44 +0200
Alexander Potapenko <glider@google.com> wrote:

> On Thu, Apr 18, 2019 at 1:54 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > On Thu, 18 Apr 2019, Alexander Potapenko wrote:  
> > > On Thu, Apr 18, 2019 at 11:06 AM Thomas Gleixner <tglx@linutronix.de> wrote:  
> > > > -       save_stack_trace(&b->stack_trace);
> > > > +       b->stack_len = stack_trace_save(b->stack_entries, MAX_STACK, 2);  
> > > As noted in one of similar patches before, can we have an inline
> > > comment to indicate what does this "2" stand for?  
> >
> > Come on. We have gazillion of functions which take numerical constant
> > arguments. Should we add comments to all of them?  
> Ok, sorry. I might not be familiar enough with the kernel style guide.

It is a legitimate complaint but not for this series. I only complain
about hard coded constants when they are added. That "2" was not
added by this series. This patch set is a clean up of the stack tracing
code, not a clean up of removing hard coded constants, or commenting
them.

The hard coded "2" was there without a comment before this patch series
and Thomas is correct to leave it as is for these changes. This patch
series should not modify what was already there which is out of scope
for the purpose of these changes.

A separate clean up patch to the maintainer of the subsystem (dm bufio
in this case) is fine. But it's not Thomas's responsibility.

-- Steve
