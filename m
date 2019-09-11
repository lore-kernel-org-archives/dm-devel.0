From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-bufio: Allow clients to specify an upper bound on cache
 size.
Date: Wed, 11 Sep 2019 11:49:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1909111142400.11772@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190906074526.169194-1-maco@android.com> <20190909145703.GA16249@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190909145703.GA16249@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Martijn Coenen <maco@android.com>, agk@redhat.com, dm-devel@redhat.com, dariofreni@google.com, jiyong@google.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, maco@google.com, ioffe@google.com, narayan@google.com, kernel-team@android.com
List-Id: dm-devel.ids



On Mon, 9 Sep 2019, Mike Snitzer wrote:

> On Fri, Sep 06 2019 at  3:45am -0400,
> Martijn Coenen <maco@android.com> wrote:
> 
> > The upper limit on the cache size of a client is currently determined by
> > dividing the total cache size by the number of clients. However, in some
> > cases it is beneficial to give one client a higher limit than others; an
> > example is a device with many dm-verity targets, where one target has a
> > very large hashtree, and all the others have a small hashtree. Giving
> > the target with the large hashtree a higher limit will be beneficial.
> > Another example is dm-verity-fec: FEC is only used in (rare) error
> > conditions, yet for every dm-verity target with FEC, we create two FEC
> > dm-bufio clients, which together have a higher cache limit than the
> > dm-verity target itself.
> > 
> > This patchset allows a client to indicate a maximum cache size for its
> > client; if that maximum is lower than the calculated per-client limit,
> > that maximum will be used instead, and the freed up cache size will be
> > allocated to other clients (that haven't set a maximum).
> > 
> > Note that this algorithm is not perfect; if we have 100MB with 3
> > clients, where the first set a max of 1MB, the second set a max of 40MB,
> > and the third set no maximumm, the ideal allocation would be 1:40:59,
> > respectively. However, because the initial per-client limit is 100 / 3
> > =~33MB, the requested max of 40MB is over the per-client limit, and
> > instead the allocation will end up being ~ 1:40:49. This is still better
> > than the original 33:33:33 allocation. An iterative algorithm could do
> > better, but it also complicates the code significantly.
> 
> Definitely not very intuitive.. but yes I think it is a reasonable
> tradeoff between your goals and further code complexity to be able to
> achieve the "ideal".
> 
> Think the documented example can be made clearer by documenting that
> dm_bufio_cache_size_per_client = 49.  And that _that_ is the reason why
> the client that didn't set a maximum is bounded to 49.
> 
> Overall I think this patch looks reasonable, but I'd like Mikulas to
> review this closer before I pick it up.
> 
> Thanks,
> Mike

I think the proper way how to solve this problem with large amount of 
clients is to have a global queue holding all the buffers and clean up the 
oldest buffers in the queue.

So that if one instance of the dm-verity target uses the buffer cache 
heavily, it can evict buffers loaded by other inactive dm-verity 
instances.

I am now working on the global queue patch.

Mikulas
