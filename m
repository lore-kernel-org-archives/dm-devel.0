From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [patch V3 24/29] tracing: Remove the last struct stack_trace
 usage
Date: Thu, 25 Apr 2019 08:30:32 -0500
Message-ID: <20190425133032.ds27oje6nxswvdji@treble>
References: <20190425094453.875139013@linutronix.de>
 <20190425094803.340000461@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425094803.340000461@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids

On Thu, Apr 25, 2019 at 11:45:17AM +0200, Thomas Gleixner wrote:
> Simplify the stack retrieval code by using the storage array based
> interface.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_stack.c |   37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> --- a/kernel/trace/trace_stack.c
> +++ b/kernel/trace/trace_stack.c
> @@ -23,11 +23,7 @@
>  static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES];
>  static unsigned stack_trace_index[STACK_TRACE_ENTRIES];
>  
> -struct stack_trace stack_trace_max = {
> -	.max_entries		= STACK_TRACE_ENTRIES,
> -	.entries		= &stack_dump_trace[0],
> -};
> -
> +static unsigned int stack_trace_entries;

"stack_trace_entries" -> "nr_stack_trace_entries"

-- 
Josh
