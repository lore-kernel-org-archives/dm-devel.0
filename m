From: "goggin, edward" <egoggin@emc.com>
Subject: multipathd(8) and multipath(8) memory problems
Date: Mon, 4 Apr 2005 15:30:51 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A8AA@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Several multipath related issues with linux-2.6.11-rc3-udm2 and
multipath-tools-0.4.4-pre5.  Still pursuing the EMC CLARiion NDU
use case using 16 dd write processes, each one writing 1GB to
a single FC CLARiion LU with 4 paths.

Sometimes multipathd dies.  I've noticed this for about 1 week.

I've also noticed that sometimes my host is left in a state where
where the dd write threads are stuck due to dirty page congestion
since several logical units are being left in an all-paths-down state
because there is no multipath running to restore the kernel state
for currently usable paths.

In this state, the machine also showed
the log_pthread, checkerloop, waiterloop, and 5 or 6 waitevent
multipathd pthreads blocked on the same kernel futex.  Difficult
to debug, but I think this must be the logq_lock (or the logev_lock)
since I don't see any other lock which is taken by each of the
threads mentioned above.  Not sure what's happening here --
I would have expected the entire multipathd process to have died
if one of the pthreads took a SIGSEGV.  Any ideas?

With full debugging  enabled on a multipath executable on a
machine in the state described above, a manually invoked
multipath was dying with a SIGSEGV.  Last debug message
indicated an inability to allocate a multipath priority group vector in
group_by_prio.  Subsequent de-reference of the mpp->pg field in
numerous other places in the code could cause the SIGSEGV.

I'm surmising that possibly both multipathd and multipath invoked
from multipathd are occasionally dying in this test scenario due to
similar memory allocation difficulties and later taking a SIGSEGV
when de-referencing uninitialized ptrs to un-allocated memory.
