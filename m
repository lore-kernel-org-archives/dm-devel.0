From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/3] offload bios to a thread
Date: Mon, 4 Jul 2016 18:53:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, snitm@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the second version of patches that fix deadlocks by redirecting 
bios from current->bio_list to rescuer workqueues.

I found out that the original patches caused deadlock with the loopback 
device. When the loopback device is used, both lower and upper filesystems 
use the same bio set - fs_bio_set. Consequently, bios submitted by both of 
them end up on the same rescuer workqueue. There is a deadlock possibility 
- if generic_make_request for the upper filesystem's bio blocks (because 
there are too many requests in flight on the loop device), it may stall 
processing some bios for the lower filesystem.

Ideadlly, each filesystem should have its own bio set. But it doesn't. So 
I fix this problem by not offloading bios allocated from fs_bio_set.

Mikulas
