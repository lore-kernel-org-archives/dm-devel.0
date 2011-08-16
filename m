From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Tue, 16 Aug 2011 18:03:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110816091600.GA4284@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> For me the main attraction to switching to bufio is you don't use
> dm-io.c.
> 
> Hopefully Alasdair will allow you to keep the different memory types;
> I was allocating the buffers in bm either via kmalloc, or pages
> depending on size, but he wanted this changing to a kmem_cache in
> order to 'segregate' the memory.
> 
> I'm not clear how you ascertain the correct working set size for your
> cache, or choose when and how many blocks to flush.  Have you got any
> documentation for this?  thinp shouldn't need a big cache and I'm a
> bit worried a 'grab another buffer if there's memory available' policy
> will make it grow too much.

The working set is 2% of memory or 1/4 of vmalloc space (whichever is 
smaller). This can be changed in 
"/sys/module/dm_bufio/parameters/dm_bufio_cache_size".

Buffers are freed when they are unused for 60 seconds (can be changed in 
"/sys/module/dm_bufio/parameters/dm_bufio_max_age").

Total size is divided by the number of active clients using dm-bufio. So 
that each client gets a fair share.

Writeback is done on commit. When 3/4 of the cache size is used, 
background writeback is started.

Mikulas

> - Joe
> 
