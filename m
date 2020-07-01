From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [willy@infradead.org: Re: [PATCH 6/6] mm: Add memalloc_nowait]
Date: Wed, 1 Jul 2020 15:35:32 -0600
Message-ID: <20200701153532.63d49389@lwn.net>
References: <20200701041316.GA7193@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200701041316.GA7193@casper.infradead.org>
Sender: linux-doc-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-doc@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Wed, 1 Jul 2020 05:13:16 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> > > -It turned out though that above approach has led to
> > > -abuses when the restricted gfp mask is used "just in case" without a
> > > -deeper consideration which leads to problems because an excessive use
> > > -of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
> > > -reclaim issues.  
> > 
> > I believe this is an important part because it shows that new people
> > coming to the existing code shouldn't take it as correct and rather
> > question it. Also having a clear indication that overuse is causing real
> > problems that might be not immediately visible to subsystems outside of
> > MM.  
> 
> It seemed to say a lot of the same things as this paragraph:
> 
> +You may notice that quite a few allocations in the existing code specify
> +``GFP_NOIO`` or ``GFP_NOFS``. Historically, they were used to prevent
> +recursion deadlocks caused by direct memory reclaim calling back into
> +the FS or IO paths and blocking on already held resources. Since 4.12
> +the preferred way to address this issue is to use the new scope APIs
> +described below.
> 
> Since this is in core-api/ rather than vm/, I felt that discussion of
> the problems that it causes to the mm was a bit too much detail for the
> people who would be reading this document.  Maybe I could move that
> information into a new Documentation/vm/reclaim.rst file?
> 
> Let's see if Our Grumpy Editor has time to give us his advice on this.

So I don't have time to really dig into the context here...but I can try.

Certainly there needs to be enough information to get people to think
about using those flags, even if they are copypasting other code that
does.  I'd be inclined to err on the side of including too much
information rather than too little.  Of course, you could make the
reclaim.rst file, then cross-link it if the result seems better.

In other words, do all of the above :)

jon
