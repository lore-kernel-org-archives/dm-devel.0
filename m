From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch V2 28/29] stacktrace: Provide common infrastructure
Date: Thu, 18 Apr 2019 17:42:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de>
	<20190418084255.652003111@linutronix.de>
	<20190418145201.mjzyqbmkjcghqzex@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190418145201.mjzyqbmkjcghqzex@treble>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jani Nikula <jani.nikula@lin>
List-Id: dm-devel.ids

On Thu, 18 Apr 2019, Josh Poimboeuf wrote:

> On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:
> > All architectures which support stacktrace carry duplicated code and
> > do the stack storage and filtering at the architecture side.
> > 
> > Provide a consolidated interface with a callback function for consuming the
> > stack entries provided by the architecture specific stack walker. This
> > removes lots of duplicated code and allows to implement better filtering
> > than 'skip number of entries' in the future without touching any
> > architecture specific code.
> > 
> > Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> This is a step in the right direction, especially if it allows us to get
> rid of the 'skip' stuff.  But I'm not crazy about the callbacks.
> 
> Another idea I had (but never got a chance to work on) was to extend the
> x86 unwind interface to all arches.  So instead of the callbacks, each
> arch would implement something like this API:
> 
> 
> struct unwind_state state;
> 
> void unwind_start(struct unwind_state *state, struct task_struct *task,
> 		  struct pt_regs *regs, unsigned long *first_frame);
> 
> bool unwind_next_frame(struct unwind_state *state);
> 
> inline bool unwind_done(struct unwind_state *state);
> 
> 
> Not only would it avoid the callbacks (which is a nice benefit already),
> it would also allow the interfaces to be used outside of the
> stack_trace_*() interfaces.  That would come in handy in cases like the
> ftrace stack tracer code, which needs more than the stack_trace_*() API
> can give.

I surely thought about that, but after staring at all incarnations of
arch/*/stacktrace.c I just gave up.

Aside of that quite some archs already have callback based unwinders
because they use them for more than stacktracing and just have a single
implementation of that loop.

I'm fine either way. We can start with x86 and then let archs convert over
their stuff, but I wouldn't hold my breath that this will be completed in
the forseeable future.

> Of course, this may be more work than what you thought you signed up for
> ;-)

I did not sign up for anything. I tripped over that mess by accident and me
being me hated it strong enough to give it at least an initial steam blast.

Thanks,

	tglx
	
