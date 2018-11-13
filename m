From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] multipathd: reset delay_wait_checks counter
	on failure
Date: Tue, 13 Nov 2018 22:30:52 +0100
Message-ID: <20181113213052.2009-3-mwilck@suse.com>
References: <20181113213052.2009-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181113213052.2009-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If path reinstantiation is delayed by delay_wait_checks, wait_checks
is counting down, the path fails during the delay phase, and then
comes up again, the wait_check counter starts counting down at the
same value where it previously stopped, which may be very low (even 1).

To avoid that, reset the counter to pp->delay_wait_checks if a failure
is encountered during the delay phase.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0dddddb3..622aa1ac 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2035,8 +2035,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 					pp->wait_checks = pp->mpp->delay_wait_checks;
 					pp->watch_checks = 0;
 				}
-			}else
+			} else {
 				fail_path(pp, 0);
+				if (pp->wait_checks > 0)
+					pp->wait_checks =
+						pp->mpp->delay_wait_checks;
+			}
 
 			/*
 			 * cancel scheduled failback
-- 
2.19.1
