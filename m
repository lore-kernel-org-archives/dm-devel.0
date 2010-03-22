From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] shared snapshots release 17
Date: Mon, 22 Mar 2010 15:18:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi

New shared snapshots are here. It incorporates Mike's changes and it has 
reworked memory limit:
- a minimum of 8 buffers is guaranteed to prevent thrasing with too big 
chunk sizes
- the cache for multisnapshots is limited to 2% of memory or 25% of 
vmalloc memory (whichever is lower) [ I'm thinking about making this 
configurable in /proc ]
- big chunk sizes (8MB or more) allocate memory always from vmalloc, there 
is no point in allocating from general allocator

Mikulas
