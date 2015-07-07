From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/7] dm: introduce dm_kvmalloc
Date: Tue, 7 Jul 2015 08:50:36 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507070848480.3944@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1507031658500.28837@file01.intranet.prod.int.rdu2.redhat.com> <20150706134750.GA31600@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150706134750.GA31600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 6 Jul 2015, Mike Snitzer wrote:

> In general I like what you've done with this patchset _except_ I'm not
> seeing why dm_kvmalloc() should be in DM at all.  It should probably be
> elevated to an kvmalloc() export from mm/util.c and include/linux/mm.h
> along-side kvfree().

If memory management maintainers agree to put it into mm core, it would be 
nice. If not, put it into device mapper.

Mikulas

> David and/or Andrew, what do you think?
> 
> FYI, full patchset starts here:
> https://www.redhat.com/archives/dm-devel/2015-July/msg00004.html
> 
> (but Mikulas didn't chain the reply so the 7 patches aren't properly
> threaded/navigated, you can dig out the patches toward the top of the
> list here: https://patchwork.kernel.org/project/dm-devel/list/ )
> 
