From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Wed, 13 Jun 2018 11:16:54 -0700
Message-ID: <20180613181654.GA24315@infradead.org>
References: <alpine.DEB.2.20.1804170940340.17557@nuc-kabylake>
 <alpine.LRH.2.02.1804171454020.26973@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.20.1804180952580.1334@nuc-kabylake>
 <alpine.LRH.2.02.1804251702250.9428@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1804251917460.2429@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.20.1804261354230.6674@nuc-kabylake>
 <alpine.LRH.2.02.1804261508430.26980@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.20.1804271136390.11686@nuc-kabylake>
 <alpine.LRH.2.02.1804271513320.16558@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1806131300370.1012@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806131300370.1012@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christopher Lameter <cl@linux.com>, Mike Snitzer <snitzer@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 13, 2018 at 01:01:22PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I'd like to ask about this patch - will you commit it, or do you want to 
> make some more changes to it?

How about you resend it with the series adding an actual user once
ready?  I haven't actually seen patches using it posted on any list yet.
