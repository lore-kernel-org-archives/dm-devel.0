From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 6/9] mpathpersist: initialize data structures
	only once
Date: Mon, 27 May 2019 14:59:39 +0200
Message-ID: <20190527125942.8366-7-mwilck@suse.com>
References: <20190527125942.8366-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190527125942.8366-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We now have the possibility to run several PR commands in a single
mpathpersist invocation. Run initialization / discovery and teardown
only once at program invocation / exit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 mpathpersist/main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 6df9762d..cbb59623 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -374,6 +374,9 @@ static int handle_args(int argc, char * argv[], int nline)
 		/* set verbosity */
 		noisy = (loglevel >= 3) ? 1 : hex;
 		verbose	= (loglevel >= 3)? 3: loglevel;
+		ret = mpath_persistent_reserve_init_vecs(verbose);
+		if (ret != MPATH_PR_SUCCESS)
+			goto out;
 	}
 
 	if ((prout_flag + prin_flag) == 0 && batch_fn == NULL)
@@ -480,7 +483,7 @@ static int handle_args(int argc, char * argv[], int nline)
 			goto out;
 		}
 
-		ret = mpath_persistent_reserve_in (fd, prin_sa, resp, noisy, verbose);
+		ret = __mpath_persistent_reserve_in (fd, prin_sa, resp, noisy);
 		if (ret != MPATH_PR_SUCCESS )
 		{
 			fprintf (stderr, "Persistent Reserve IN command failed\n");
@@ -540,8 +543,8 @@ static int handle_args(int argc, char * argv[], int nline)
 		}
 
 		/* PROUT commands other than 'register and move' */
-		ret = mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
-				paramp, noisy, verbose);
+		ret = __mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
+				paramp, noisy);
 		for (j = 0 ; j < num_transport; j++)
 		{
 			tmp = paramp->trnptid_list[j];
@@ -580,6 +583,8 @@ out :
 		free(batch_fn);
 		ret = ret == 0 ? rv : ret;
 	}
+	if (nline == 0)
+		mpath_persistent_reserve_free_vecs();
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
 }
 
-- 
2.21.0
