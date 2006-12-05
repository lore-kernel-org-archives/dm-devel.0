From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH][STABLE 2.6.18] dm snapshot: fix freeing pending
	exception
Date: Tue, 05 Dec 2006 16:11:18 +0100
Message-ID: <45758C16.5010905@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Fix oops when removing full snapshot
kernel bugzilla bug 7040

If a snapshot became invalid (full) while there is outstanding 
pending_exception, pending_complete() forgets to remove
the corresponding exception from its exception table before freeing it.

Already fixed in 2.6.19.

Signed-off-by: Milan Broz <mbroz@redhat.com>

Index: linux-2.6.18.5/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.18.5.orig/drivers/md/dm-snap.c	2006-12-02 01:13:05.000000000 +0100
+++ linux-2.6.18.5/drivers/md/dm-snap.c	2006-12-04 17:55:28.000000000 +0100
@@ -691,6 +691,7 @@ static void pending_complete(struct pend
 
 		free_exception(e);
 
+		remove_exception(&pe->e);
 		error_snapshot_bios(pe);
 		goto out;
 	}
