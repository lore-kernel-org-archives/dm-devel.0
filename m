From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch V2 21/29] tracing: Use percpu stack trace buffer more
 intelligently
Date: Thu, 18 Apr 2019 11:46:29 -0400
Message-ID: <20190418114629.023b63d7@gandalf.local.home>
References: <20190418084119.056416939@linutronix.de>
        <20190418084254.999521114@linutronix.de>
        <20190418105334.5093528d@gandalf.local.home>
        <alpine.DEB.2.21.1904181743270.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904181743270.3174@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids

On Thu, 18 Apr 2019 17:43:59 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 18 Apr 2019, Steven Rostedt wrote:
> > On Thu, 18 Apr 2019 10:41:40 +0200
> > Thomas Gleixner <tglx@linutronix.de> wrote:  
> > > -static DEFINE_PER_CPU(struct ftrace_stack, ftrace_stack);
> > > +/* This allows 8 level nesting which is plenty */  
> > 
> > Can we make this 4 level nesting and increase the size? (I can see us
> > going more than 64 deep, kernel developers never cease to amaze me ;-)
> > That's all we need:
> > 
> >  Context: Normal, softirq, irq, NMI
> > 
> > Is there any other way to nest?  
> 
> Not that I know, but you are the tracer dude :)
>

There's other places I only test 4 deep, so it should be fine to limit
it to 4 then.

Thanks!

-- Steve
