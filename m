From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch V3 00/29] stacktrace: Consolidate stack trace usage
Date: Thu, 25 Apr 2019 12:09:33 +0200
Message-ID: <20190425100933.GB8387@gmail.com>
References: <20190425094453.875139013@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425094453.875139013@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>
List-Id: dm-devel.ids


* Thomas Gleixner <tglx@linutronix.de> wrote:

> -	if (unlikely(!ret))
> +	if (unlikely(!ret)) {
> +		if (!trace->nr_entries) {
> +			/*
> +			 * If save_trace fails here, the printing might
> +			 * trigger a WARN but because of the !nr_entries it
> +			 * should not do bad things.
> +			 */
> +			save_trace(trace);
> +		}
>  		return print_circular_bug(&this, target_entry, next, prev);
> +	}
>  	else if (unlikely(ret < 0))
>  		return print_bfs_bug(ret);

Just a minor style nit: the 'else' should probably on the same line as 
the '}' it belongs to, to make it really obvious that the 'if' has an 
'else' branch?

At that point the condition should probably also use balanced curly 
braces.

Interdiff looks good otherwise.

Thanks,

	Ingo
