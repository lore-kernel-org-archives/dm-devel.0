From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch V2 20/29] tracing: Simplify stacktrace retrieval in
 histograms
Date: Thu, 18 Apr 2019 09:40:14 -0400
Message-ID: <20190418094014.7d457f29@gandalf.local.home>
References: <20190418084119.056416939@linutronix.de>
        <20190418084254.910579307@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418084254.910579307@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids


[ Added Tom Zanussi ]

On Thu, 18 Apr 2019 10:41:39 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> The indirection through struct stack_trace is not necessary at all. Use the
> storage array based interface.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Looks fine to me

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

 But...

Tom,

Can you review this too?

Patch series starts here:

  http://lkml.kernel.org/r/20190418084119.056416939@linutronix.de

Thanks,

-- Steve

> ---
>  kernel/trace/trace_events_hist.c |   12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -5186,7 +5186,6 @@ static void event_hist_trigger(struct ev
>  	u64 var_ref_vals[TRACING_MAP_VARS_MAX];
>  	char compound_key[HIST_KEY_SIZE_MAX];
>  	struct tracing_map_elt *elt = NULL;
> -	struct stack_trace stacktrace;
>  	struct hist_field *key_field;
>  	u64 field_contents;
>  	void *key = NULL;
> @@ -5198,14 +5197,9 @@ static void event_hist_trigger(struct ev
>  		key_field = hist_data->fields[i];
>  
>  		if (key_field->flags & HIST_FIELD_FL_STACKTRACE) {
> -			stacktrace.max_entries = HIST_STACKTRACE_DEPTH;
> -			stacktrace.entries = entries;
> -			stacktrace.nr_entries = 0;
> -			stacktrace.skip = HIST_STACKTRACE_SKIP;
> -
> -			memset(stacktrace.entries, 0, HIST_STACKTRACE_SIZE);
> -			save_stack_trace(&stacktrace);
> -
> +			memset(entries, 0, HIST_STACKTRACE_SIZE);
> +			stack_trace_save(entries, HIST_STACKTRACE_DEPTH,
> +					 HIST_STACKTRACE_SKIP);
>  			key = entries;
>  		} else {
>  			field_contents = key_field->fn(key_field, elt, rbe, rec);
> 
