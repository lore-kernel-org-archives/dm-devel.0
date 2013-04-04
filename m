From: Mikulas Patocka <mpatocka@redhat.com>
Subject: btree vs. linear seach in device mapper
Date: Thu, 4 Apr 2013 10:27:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304041021260.23945@file.rdu.redhat.com>
References: <515599DE.3050104@redhat.com>
	<20130404085848.GC24402@stefanha-thinkpad.redhat.com>
	<Pine.LNX.4.64.1304040916470.17024@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1304040916470.17024@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 4 Apr 2013, Mikulas Patocka wrote:

> There are no scalability problems regarding performance - device mapper 
> uses btree to search the target table, so the number of target don't 
> affect performance.
> 
> device mapper uses vmalloc to alloc all targets linearly, so it is limited 
> by avaiable vmalloc space. It is not a problem on x86-64, but it is 
> limited on x86 - vmalloc space can be as low as 128k (one target structure 
> has 64 bytes for 32-bit architectures and 96 bytes for 64-bit 
> architectures).

BTW. when I see that btree code in dm-table.c, I ask - why doesn't it use 
binary search?

We only append targets at the end when constructing the device, we never 
insert or remove them, so we don't need a tree. For these operations 
binary search would be as good as btree and it is simpler.

Mikulas
