From: Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: [patch V2 20/29] tracing: Simplify stacktrace retrieval in
 histograms
Date: Thu, 18 Apr 2019 15:22:22 -0500
Message-ID: <a8b9954d0c0a6cc4c213ff65c9ec3795ed0a05ba.camel@linux.intel.com>
References: <20190418084119.056416939@linutronix.de>
         <20190418084254.910579307@linutronix.de>
         <20190418094014.7d457f29@gandalf.local.home>
         <014a7564d606b249a5e50bef0fedf266977a935b.camel@linux.intel.com>
         <20190418161342.34f4abca@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418161342.34f4abca@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Hi Steve,

On Thu, 2019-04-18 at 16:13 -0400, Steven Rostedt wrote:
> On Thu, 18 Apr 2019 14:58:55 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> > > Tom,
> > > 
> > > Can you review this too?  
> > 
> > Looks good to me too!
> > 
> > Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> > 
> 
> Would you be OK to upgrade this to a Reviewed-by tag?
> 

Yeah, I did review it and even tested it, so:

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Tom


> Thanks!
> 
> -- Steve
