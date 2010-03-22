From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: shared snapshots release 17
Date: Mon, 22 Mar 2010 15:31:03 -0400
Message-ID: <20100322193102.GA13346@redhat.com>
References: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 22 2010 at  3:18pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> New shared snapshots are here.

http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r17/

> It incorporates Mike's changes and it has 
> reworked memory limit:
> - a minimum of 8 buffers is guaranteed to prevent thrasing with too big 
> chunk sizes
> - the cache for multisnapshots is limited to 2% of memory or 25% of 
> vmalloc memory (whichever is lower) [ I'm thinking about making this 
> configurable in /proc ]
> - big chunk sizes (8MB or more) allocate memory always from vmalloc, there 
> is no point in allocating from general allocator

Thanks, I'll have a look.

Mike
