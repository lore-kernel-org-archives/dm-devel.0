From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [patch V2 28/29] stacktrace: Provide common infrastructure
Date: Thu, 18 Apr 2019 09:52:01 -0500
Message-ID: <20190418145201.mjzyqbmkjcghqzex@treble>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418084255.652003111@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, linux-arch@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek
List-Id: dm-devel.ids

On Thu, Apr 18, 2019 at 10:41:47AM +0200, Thomas Gleixner wrote:
> All architectures which support stacktrace carry duplicated code and
> do the stack storage and filtering at the architecture side.
> 
> Provide a consolidated interface with a callback function for consuming the
> stack entries provided by the architecture specific stack walker. This
> removes lots of duplicated code and allows to implement better filtering
> than 'skip number of entries' in the future without touching any
> architecture specific code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-arch@vger.kernel.org

This is a step in the right direction, especially if it allows us to get
rid of the 'skip' stuff.  But I'm not crazy about the callbacks.

Another idea I had (but never got a chance to work on) was to extend the
x86 unwind interface to all arches.  So instead of the callbacks, each
arch would implement something like this API:


struct unwind_state state;

void unwind_start(struct unwind_state *state, struct task_struct *task,
		  struct pt_regs *regs, unsigned long *first_frame);

bool unwind_next_frame(struct unwind_state *state);

inline bool unwind_done(struct unwind_state *state);


Not only would it avoid the callbacks (which is a nice benefit already),
it would also allow the interfaces to be used outside of the
stack_trace_*() interfaces.  That would come in handy in cases like the
ftrace stack tracer code, which needs more than the stack_trace_*() API
can give.

Of course, this may be more work than what you thought you signed up for
;-)

-- 
Josh
