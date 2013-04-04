From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: btree vs. linear seach in device mapper
Date: Thu, 4 Apr 2013 19:03:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304041901170.29240@file.rdu.redhat.com>
References: <515599DE.3050104@redhat.com>
	<20130404085848.GC24402@stefanha-thinkpad.redhat.com>
	<Pine.LNX.4.64.1304040916470.17024@file.rdu.redhat.com>
	<Pine.LNX.4.64.1304041021260.23945@file.rdu.redhat.com>
	<20130404144320.GA8207@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130404144320.GA8207@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 4 Apr 2013, Joe Thornber wrote:

> On Thu, Apr 04, 2013 at 10:27:02AM -0400, Mikulas Patocka wrote:
> > BTW. when I see that btree code in dm-table.c, I ask - why doesn't it use 
> > binary search?
> > 
> > We only append targets at the end when constructing the device, we never 
> > insert or remove them, so we don't need a tree. For these operations 
> > binary search would be as good as btree and it is simpler.
> 
> I originally expected dm tables to have many, many more entries than
> they do these days (I remember benchmarking it with 1 million
> entries).  I used a btree to try and be nicer to the cpu cache; the
> idea being that each btree node could fit into a cache line.  Plain
> binary search would have caused many more cache faults.
> 
> Given how dm is used these days I wouldn't mind a switch to a binary
> search.
> 
> - Joe

I see.

If the btree helps to save a few cachelines and doesn't hurt, we can leave 
it there. If it ever causes some code maintainability difficulties, we can 
switch to a binary search...

Mikulas
