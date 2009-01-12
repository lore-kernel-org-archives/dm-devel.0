From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] new barriers
Date: Mon, 12 Jan 2009 09:36:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901120927320.20106@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

Here I announce my new barrier support patches:
http://people.redhat.com/mpatocka/patches/kernel/barriers/

They are for plain 2.6.28, if you applied Andi Kleen's partial-barrier 
patch, you need to revert it.

My implementation work by offloading all the requests (both barrier and 
non-barrier ones) to a thread if the barrier is seen. The thread makes 
sure that it will flush all active requests before and after a barrier. 
When the thread finishes work, processing is switched back to dm_request.

TODO:

- doesn't support DM_ENDIO_REQUEUE, non-barrier DM_ENDIO_REQUEUE requests 
may be incorrectly reordered around a barrier, barrier DM_ENDIO_REQUEUE 
requests are aborted with an error. Needs redesign of DM_ENDIO_REQUEUE.

- flushing hw disk cache in targets (especially snapshots and raid1)

- on multipath it flushes hw cache on both paths, which is wrong (if one 
path has failed)

- parallel flushing of hw caches on linear devices for better performance, 
currently they're being flushed sequentially

Mikulas
