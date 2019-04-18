From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [patch V2 09/29] mm/kasan: Simplify stacktrace handling
Date: Thu, 18 Apr 2019 13:39:45 +0300
Message-ID: <5b77992a-52b6-807e-f77d-9cf3e648c71f@virtuozzo.com>
References: <20190418084119.056416939@linutronix.de>
 <20190418084253.903603121@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418084253.903603121@linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: dm-devel.ids

On 4/18/19 11:41 AM, Thomas Gleixner wrote:
> Replace the indirection through struct stack_trace by using the storage
> array based interfaces.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: kasan-dev@googlegroups.com
> Cc: linux-mm@kvack.org

Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

>  
>  static inline depot_stack_handle_t save_stack(gfp_t flags)
>  {
>  	unsigned long entries[KASAN_STACK_DEPTH];
> -	struct stack_trace trace = {
> -		.nr_entries = 0,
> -		.entries = entries,
> -		.max_entries = KASAN_STACK_DEPTH,
> -		.skip = 0
> -	};
> +	unsigned int nr_entries;
>  
> -	save_stack_trace(&trace);
> -	filter_irq_stacks(&trace);
> -
> -	return depot_save_stack(&trace, flags);
> +	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
> +	nr_entries = filter_irq_stacks(entries, nr_entries);
> +	return stack_depot_save(entries, nr_entries, flags);

Suggestion for further improvement:

stack_trace_save() shouldn't unwind beyond irq entry point so we wouldn't need filter_irq_stacks().
Probably all call sites doesn't care about random stack above irq entry point, so it doesn't
make sense to spend resources on unwinding non-irq stack from interrupt first an filtering out it later.

It would improve performance of stack_trace_save() called from interrupt and fix page_owner which feed unfiltered
stack to stack_depot_save(). Random non-irq part kills the benefit of using the stack_deopt_save().
