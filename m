From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/3] offload bios to a thread
Date: Tue, 28 Jun 2016 20:16:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1606282014380.7298@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending three patches to fix the deadlocks in snapshot and 
snapshot-merge.

The first patch fixes the deadlock, the following 2 patches introduce a 
timer, so that bios are not offloaded immediatelly, they are offloaded 
after a specified timeout, because immediate offloading can change order 
of bios and it could theoretically produce regressions. I don't know if 
these regressions really exist or not.

If there is some way to push the patches upstream, try it.

Mikulas
