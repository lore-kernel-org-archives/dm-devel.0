From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/9] mpathpersist: call usage() just once on
	return
Date: Mon, 27 May 2019 14:59:34 +0200
Message-ID: <20190527125942.8366-2-mwilck@suse.com>
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

This simplifies further changes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 mpathpersist/main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 10cba452..94e89c13 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -265,7 +265,6 @@ int main (int argc, char * argv[])
 
 			default:
 				fprintf(stderr, "unrecognised switch " "code 0x%x ??\n", c);
-				usage ();
 				ret = MPATH_PR_SYNTAX_ERROR;
 				goto out;
 		}
@@ -283,7 +282,6 @@ int main (int argc, char * argv[])
 		{
 			for (; optind < argc; ++optind)
 				fprintf (stderr, "Unexpected extra argument: %s\n", argv[optind]);
-			usage ();
 			ret = MPATH_PR_SYNTAX_ERROR;
 			goto out;
 		}
@@ -296,14 +294,12 @@ int main (int argc, char * argv[])
 	if ((prout_flag + prin_flag) == 0)
 	{
 		fprintf (stderr, "choose either '--in' or '--out' \n");
-		usage ();
 		ret = MPATH_PR_SYNTAX_ERROR;
 		goto out;
 	}
 	if ((prout_flag + prin_flag) > 1)
 	{
 		fprintf (stderr, "choose either '--in' or '--out' \n");
-		usage ();
 		ret = MPATH_PR_SYNTAX_ERROR;
 		goto out;
 	}
@@ -334,20 +330,17 @@ int main (int argc, char * argv[])
 		{
 			fprintf (stderr,
 					" No service action given for Persistent Reserve IN\n");
-			usage();
 			ret = MPATH_PR_SYNTAX_ERROR;
 		}
 		else if (num_prin_sa > 1)
 		{
 			fprintf (stderr, " Too many service actions given; choose "
 					"one only\n");
-			usage();
 			ret = MPATH_PR_SYNTAX_ERROR;
 		}
 	}
 	else
 	{
-		usage ();
 		ret = MPATH_PR_SYNTAX_ERROR;
 		goto out;
 	}
@@ -356,7 +349,6 @@ int main (int argc, char * argv[])
 	{
 		fprintf (stderr, " --relative-target-port"
 				" only useful with --register-move\n");
-		usage ();
 		ret = MPATH_PR_SYNTAX_ERROR;
 		goto out;
 	}
@@ -378,7 +370,6 @@ int main (int argc, char * argv[])
 	if (device_name == NULL)
 	{
 		fprintf (stderr, "No device name given \n");
-		usage ();
 		ret = MPATH_PR_SYNTAX_ERROR;
 		goto out;
 	}
@@ -496,6 +487,8 @@ int main (int argc, char * argv[])
 	}
 
 out :
+	if (ret == MPATH_PR_SYNTAX_ERROR)
+		usage();
 	mpath_lib_exit(conf);
 	udev_unref(udev);
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
-- 
2.21.0
