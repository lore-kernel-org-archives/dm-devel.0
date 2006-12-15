From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 12/24] dm snapshot: fix freeing pending exception
Date: Thu, 14 Dec 2006 17:33:49 -0800
Message-ID: <20061215013648.197529000@sous-sol.org>
References: <20061215013337.823935000@sous-sol.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964947AbWLOBeH@vger.kernel.org>
Content-Disposition: inline; filename=dm-snapshot-fix-freeing-pending-exception.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, torvalds@osdl.org, akpm@osdl.org, alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

2.6.18-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Milan Broz <mbroz@redhat.com>

Fix oops when removing full snapshot
kernel bugzilla bug 7040

If a snapshot became invalid (full) while there is outstanding 
pending_exception, pending_complete() forgets to remove
the corresponding exception from its exception table before freeing it.

Already fixed in 2.6.19.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-snap.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.18.5.orig/drivers/md/dm-snap.c
+++ linux-2.6.18.5/drivers/md/dm-snap.c
@@ -691,6 +691,7 @@ static void pending_complete(struct pend
 
 		free_exception(e);
 
+		remove_exception(&pe->e);
 		error_snapshot_bios(pe);
 		goto out;
 	}

--
