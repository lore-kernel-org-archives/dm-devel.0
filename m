From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch V2 28/29] stacktrace: Provide common infrastructure
Date: Thu, 18 Apr 2019 13:57:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904181355300.3174@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de>
	<20190418084255.652003111@linutronix.de>
	<20190418115207.GB13304@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190418115207.GB13304@rapoport-lnx>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmKsTnJN9+BGXg@public.gmane.org>
List-Id: dm-devel.ids

On Thu, 18 Apr 2019, Mike Rapoport wrote:
> On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:
> > +/**
> > + * arch_stack_walk - Architecture specific function to walk the stack
> > +
> 
> Nit: no '*' at line beginning makes kernel-doc unhappy

Oops.

> > + * @consume_entry:	Callback which is invoked by the architecture code for
> > + *			each entry.
> > + * @cookie:		Caller supplied pointer which is handed back to
> > + *			@consume_entry
> > + * @task:		Pointer to a task struct, can be NULL
> > + * @regs:		Pointer to registers, can be NULL
> > + *
> > + * @task	@regs:
> > + * NULL		NULL	Stack trace from current
> > + * task		NULL	Stack trace from task (can be current)
> > + * NULL		regs	Stack trace starting on regs->stackpointer
> 
> This will render as a single line with 'make *docs'.
> Adding line separators makes this actually a table in the generated docs:
> 
>  * ============ ======= ============================================
>  * task		regs
>  * ============ ======= ============================================
>  * NULL		NULL	Stack trace from current
>  * task		NULL	Stack trace from task (can be current)
>  * NULL		regs	Stack trace starting on regs->stackpointer
>  * ============ ======= ============================================

Cute.

> > + * Returns number of entries stored.
> 
> Can you please s/Returns/Return:/ so that kernel-doc will recognize this as
> return section.
> 
> This is relevant for other comments below as well.

Sure.

Thanks for the free kernel doc course! :)

	tglx
