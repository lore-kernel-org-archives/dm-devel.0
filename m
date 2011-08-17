From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Wed, 17 Aug 2011 09:26:57 +0100
Message-ID: <20110817082656.GA3267@ubuntu>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 16, 2011 at 06:03:00PM -0400, Mikulas Patocka wrote:
> The working set is 2% of memory or 1/4 of vmalloc space (whichever is 
> smaller). This can be changed in 
> "/sys/module/dm_bufio/parameters/dm_bufio_cache_size".
> 
> Buffers are freed when they are unused for 60 seconds (can be changed in 
> "/sys/module/dm_bufio/parameters/dm_bufio_max_age").
> 
> Total size is divided by the number of active clients using dm-bufio. So 
> that each client gets a fair share.
> 
> Writeback is done on commit. When 3/4 of the cache size is used, 
> background writeback is started.

This all sounds good; get the locking interface in and I'll switch to
bufio straight away.

- Joe
