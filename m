From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [patch V3 00/29] stacktrace: Consolidate stack trace usage
Date: Thu, 25 Apr 2019 08:31:05 -0500
Message-ID: <20190425133105.54uyebwcdkxx5trg@treble>
References: <20190425094453.875139013@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425094453.875139013@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids

On Thu, Apr 25, 2019 at 11:44:53AM +0200, Thomas Gleixner wrote:
> This is an update to V2 which can be found here:
> 
>   https://lkml.kernel.org/r/20190418084119.056416939@linutronix.de
> 
> Changes vs. V2:
> 
>   - Fixed the kernel-doc issue pointed out by Mike
> 
>   - Removed the '-1' oddity from the tracer
> 
>   - Restricted the tracer nesting to 4
> 
>   - Restored the lockdep magic to prevent redundant stack traces
> 
>   - Addressed the small nitpicks here and there
> 
>   - Picked up Acked/Reviewed tags

Other than the 2 minor nits:

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
