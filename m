From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [multipath-tools] [patch] fix select_alias weirdness
Date: Wed, 31 May 2006 20:09:14 -0500
Message-ID: <20060601010913.GA25695@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In select_alias, the code that tries to pull the alias from dm_get_name()
sets mp->alias. So even if it fails,  mp->alias will never get set to mp->wwid. 

This patch fixes that.

-Ben

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alias_fix.patch"

diff -urpN mp-devel-clean/libmultipath/propsel.c mp-devel-patched/libmultipath/propsel.c
--- mp-devel-clean/libmultipath/propsel.c	2006-05-23 11:12:15.000000000 -0500
+++ mp-devel-patched/libmultipath/propsel.c	2006-05-31 13:33:13.000000000 -0500
@@ -165,10 +165,16 @@ select_alias (struct multipath * mp)
 		if (conf->user_friendly_names)
 			mp->alias = get_user_friendly_alias(mp->wwid,
 					conf->bindings_file);
-		if (mp->alias == NULL)
-			if ((mp->alias = MALLOC(WWID_SIZE)) != NULL)
-				dm_get_name(mp->wwid, DEFAULT_TARGET,
-					    mp->alias);
+		if (mp->alias == NULL){
+			char *alias;
+			if ((alias = MALLOC(WWID_SIZE)) != NULL){
+				if (dm_get_name(mp->wwid, DEFAULT_TARGET,
+						alias) == 1)
+					mp->alias = alias;
+				else
+					FREE(alias);
+			}
+		}
 		if (mp->alias == NULL)
 			mp->alias = mp->wwid;
 	}

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--45Z9DzgjV8m4Oswq--
