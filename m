From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm snapshot: improve documentation
Date: Wed, 2 Dec 2015 12:32:49 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512021230450.15019@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Regarding bug 1286898 - the documentation doesn't specify the requirement 
that the origin target must be suspended, so we should add this paragraph 
to the file snapshot.txt.


From: Mikulas Patocka <mpatocka@redhat.com>

Add a node to snapshot.txt that the origin target must be suspended when
loading or unloading the snapshot target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/snapshot.txt |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-4.4-rc3/Documentation/device-mapper/snapshot.txt
===================================================================
--- linux-4.4-rc3.orig/Documentation/device-mapper/snapshot.txt	2015-12-02 18:26:34.000000000 +0100
+++ linux-4.4-rc3/Documentation/device-mapper/snapshot.txt	2015-12-02 18:29:10.000000000 +0100
@@ -49,6 +49,10 @@ The difference between persistent and tr
 snapshots less metadata must be saved on disk - they can be kept in
 memory by the kernel.
 
+When loading or unloading the snapshot target, the corresponding
+snapshot-origin or snapshot-merge target must be suspended. A failure to
+suspend the origin target could result in data corruption.
+
 
 * snapshot-merge <origin> <COW device> <persistent> <chunksize>
 
