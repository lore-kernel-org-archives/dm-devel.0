From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH RESEND] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Wed, 13 Jun 2018 14:53:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806131446110.26196@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.DEB.2.20.1804170940340.17557@nuc-kabylake> <alpine.LRH.2.02.1804171454020.26973@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.20.1804180952580.1334@nuc-kabylake> <alpine.LRH.2.02.1804251702250.9428@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1804251917460.2429@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.20.1804261354230.6674@nuc-kabylake> <alpine.LRH.2.02.1804261508430.26980@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.20.1804271136390.11686@nuc-kabylake>
 <alpine.LRH.2.02.1804271513320.16558@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1806131300370.1012@file01.intranet.prod.int.rdu2.redhat.com> <20180613181654.GA24315@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613181654.GA24315@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christopher Lameter <cl@linux.com>, Mike Snitzer <snitzer@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Wed, 13 Jun 2018, Christoph Hellwig wrote:

> On Wed, Jun 13, 2018 at 01:01:22PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I'd like to ask about this patch - will you commit it, or do you want to 
> > make some more changes to it?
> 
> How about you resend it with the series adding an actual user once
> ready?  I haven't actually seen patches using it posted on any list yet.

dm-bufio is already using it. Starting with the kernel 4.17 (f51f2e0a7fb1 
- "dm bufio: support non-power-of-two block sizes"), dm-bufio has the 
capability to use non-power-of-two buffers. It uses slab cache for its 
buffers - so we would like to have this slab optimization - to avoid 
excessive memory wasting.

Originally, the slub patch used a new flag SLAB_MINIMIZE_WASTE, but after 
a suggestion from others, I reworked the patch so that it minimizes waste 
of all slub caches and doesn't need an extra flag to activate.

Mikulas
