From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/7] dm: introduce dm_kvmalloc
Date: Tue, 7 Jul 2015 09:25:42 -0400
Message-ID: <20150707132542.GA15860@redhat.com>
References: <alpine.LRH.2.02.1507031658500.28837@file01.intranet.prod.int.rdu2.redhat.com>
 <20150706134750.GA31600@redhat.com>
 <alpine.LRH.2.02.1507070848480.3944@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1507070848480.3944@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jul 07 2015 at  8:50am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 6 Jul 2015, Mike Snitzer wrote:
> 
> > In general I like what you've done with this patchset _except_ I'm not
> > seeing why dm_kvmalloc() should be in DM at all.  It should probably be
> > elevated to an kvmalloc() export from mm/util.c and include/linux/mm.h
> > along-side kvfree().
> 
> If memory management maintainers agree to put it into mm core, it would be 
> nice. If not, put it into device mapper.

Please rework your patches so that the mm changes are split out into
clean patch(es) at the start of the series.

Please cc Andrew and David on posting v2.  Also, please chain the reply
so that the patchset is properly threaded.
