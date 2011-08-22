From: Mikulas Patocka <mpatocka@redhat.com>
Subject: new dm-bufio
Date: Mon, 22 Aug 2011 16:05:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I uploaded new dm-bufio patch at 
http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/dm-bufio.patch

It reports the number of allocated bytes in 
"/sys/module/dm_bufio/parameters/". There is a file "total_allocated" that 
contains the number of bytes allocated for buffer cache. There are files 
"allocated_get_free_pages", "allocated_kmalloc", "allocated_vmalloc" that 
contain a number of allocated bytes with each method.

BTW. if you store "1" in "cache_size", it switches to a mode where it 
won't allocate any memory during operation, relying only on preallocated 
reserves --- useful for testing reservation deadlocks.

Mikulas
