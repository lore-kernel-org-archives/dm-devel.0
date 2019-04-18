From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch V2 09/29] mm/kasan: Simplify stacktrace handling
Date: Thu, 18 Apr 2019 13:53:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904181350080.3174@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de>
	<20190418084253.903603121@linutronix.de>
	<5b77992a-52b6-807e-f77d-9cf3e648c71f@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <5b77992a-52b6-807e-f77d-9cf3e648c71f-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jani Nikula <jani.nikula@linux.i>
List-Id: dm-devel.ids

On Thu, 18 Apr 2019, Andrey Ryabinin wrote:
> On 4/18/19 11:41 AM, Thomas Gleixner wrote:
> > Replace the indirection through struct stack_trace by using the storage
> > array based interfaces.
> > 
> > Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Acked-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > Cc: Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
> > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> 
> Acked-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> 
> >  
> >  static inline depot_stack_handle_t save_stack(gfp_t flags)
> >  {
> >  	unsigned long entries[KASAN_STACK_DEPTH];
> > -	struct stack_trace trace = {
> > -		.nr_entries = 0,
> > -		.entries = entries,
> > -		.max_entries = KASAN_STACK_DEPTH,
> > -		.skip = 0
> > -	};
> > +	unsigned int nr_entries;
> >  
> > -	save_stack_trace(&trace);
> > -	filter_irq_stacks(&trace);
> > -
> > -	return depot_save_stack(&trace, flags);
> > +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
> > +	nr_entries = filter_irq_stacks(entries, nr_entries);
> > +	return stack_depot_save(entries, nr_entries, flags);
> 
> Suggestion for further improvement:
> 
> stack_trace_save() shouldn't unwind beyond irq entry point so we wouldn't
> need filter_irq_stacks().  Probably all call sites doesn't care about
> random stack above irq entry point, so it doesn't make sense to spend
> resources on unwinding non-irq stack from interrupt first an filtering
> out it later.

There are users which care about the full trace.

Once we have cleaned up the whole architeture side, we can add core side
filtering which allows to

   1) replace the 'skip number of entries at the beginning

   2) stop the trace when it reaches a certain point

Right now, I don't want to change any of this until the whole mess is
consolidated.

Thanks,

	tglx
