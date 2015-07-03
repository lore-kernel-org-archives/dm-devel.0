From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/7] reliable memory allocation and fix for bug
	1225370
Date: Fri, 3 Jul 2015 16:56:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507031646240.28837@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm posting a set of patches that introduce a new function 
dm_kvmalloc and fix bug 1225370.

dm_kvmalloc is general memory allocator for reliable allocation of objects 
of arbitrary size. It tries to use kmalloc first (because it is faster and 
it results in less pressure on the TLB). However, kmalloc of a large 
object may fail because of memory fragmentation - in that case it reverts 
to vmalloc.

The memory allocated with dm_kvmalloc should be freed with kvfree (that 
function is already present in the kernel in mm/util.c).

Mikulas
