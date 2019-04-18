From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [patch V2 01/29] tracing: Cleanup stack trace code
Date: Thu, 18 Apr 2019 08:57:21 -0500
Message-ID: <20190418135721.5vwd6ngxagrrrrtt@treble>
References: <20190418084119.056416939@linutronix.de>
 <20190418084253.142712304@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418084253.142712304@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids

On Thu, Apr 18, 2019 at 10:41:20AM +0200, Thomas Gleixner wrote:
> - Remove the extra array member of stack_dump_trace[]. It's not required as
>   the stack tracer stores at max array size - 1 entries so there is still
>   an empty slot.

What is the empty slot used for?

-- 
Josh
