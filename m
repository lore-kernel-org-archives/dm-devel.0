From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch V2 01/29] tracing: Cleanup stack trace code
Date: Thu, 18 Apr 2019 18:19:38 -0400
Message-ID: <20190418181938.2e2a9a04@gandalf.local.home>
References: <20190418084119.056416939@linutronix.de>
        <20190418084253.142712304@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418084253.142712304@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids

On Thu, 18 Apr 2019 10:41:20 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:


> @@ -412,23 +404,20 @@ stack_trace_sysctl(struct ctl_table *tab
>  		   void __user *buffer, size_t *lenp,
>  		   loff_t *ppos)
>  {
> -	int ret;
> +	int ret, was_enabled;

One small nit. Could this be:

	int was_enabled;
	int ret;

I prefer only joining variables that are related on the same line.
Makes it look cleaner IMO.

>  
>  	mutex_lock(&stack_sysctl_mutex);
> +	was_enabled = !!stack_tracer_enabled;
>  

Bah, not sure why I didn't do it this way to begin with. I think I
copied something else that couldn't do it this way for some reason and
didn't put any brain power behind the copy. :-/ But that was back in
2008 so I blame it on being "young and stupid" ;-)

Other then the above nit and removing the unneeded +1 in max_entries:

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


>  	ret = proc_dointvec(table, write, buffer, lenp, ppos);
>  
> -	if (ret || !write ||
> -	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
> +	if (ret || !write || (was_enabled == !!stack_tracer_enabled))
>  		goto out;
>  
> -	last_stack_tracer_enabled = !!stack_tracer_enabled;
> -
>  	if (stack_tracer_enabled)
>  		register_ftrace_function(&trace_ops);
>  	else
>  		unregister_ftrace_function(&trace_ops);
> -
>   out:
>  	mutex_unlock(&stack_sysctl_mutex);
>  	return ret;
> @@ -444,7 +433,6 @@ static __init int enable_stacktrace(char
>  		strncpy(stack_trace_filter_buf, str + len, COMMAND_LINE_SIZE);
>  
>  	stack_tracer_enabled = 1;
> -	last_stack_tracer_enabled = 1;
>  	return 1;
>  }
>  __setup("stacktrace", enable_stacktrace);
> 
