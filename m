From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 0/8] dm-bufio patches
Date: Mon, 26 Mar 2018 20:55:22 -0400
Message-ID: <20180327005521.GA23487@redhat.com>
References: <20180326182939.169591126@debian.vm>
	<20180326185746.GA22409@redhat.com>
	<alpine.LRH.2.02.1803261619480.29393@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1803261619480.29393@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 26 2018 at  4:20pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 26 Mar 2018, Mike Snitzer wrote:
> 
> > On Mon, Mar 26 2018 at  2:29pm -0400,
> > mpatocka@redhat.com <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > Here I'm sending the second version of dm-bufio patches for arbitrary
> > > sector size.
> > > 
> > > I dropped the patch that removes alloc_pages because it turns out that
> > > alloc_pages is faster than the slab allocator.
> > 
> > I had already staged the previous set, so I need to go back over that
> > and update accordingly.
> > 
> > > I also added a patch that removes struct bio from struct dm_buffer
> > > (reducing the size of dm_buffer to 1/3) and allocates the bio only when
> > > doing read or write.
> > 
> > OK, I'll go over your new set and try to tease out any differences.
> > 
> > Mike
> 
> One more patch that I forgot to include.
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH] dm-bufio: delete outdated comment
> 
> This comment was true when dm-bufio was written, but since the kernel 4.3,
> bios can have arbitrary size and the driver splits them.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I had already included this one back on March 4.

I've pushed dm-4.17 with all your bufio changes.  I tweaked headers and
some whitespace, etc.  Please review and verify all looks fine, thanks:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.17
