From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: dm-multipath [PATCH] "better" return codes.
Date: Mon, 27 Feb 2006 15:11:10 -0600
Message-ID: <20060227211110.GB7357@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
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


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I think that these multipathd return codes make more sense (failing if the map
is not a multipath map, and not failing if it has already been added).

-Ben

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="returns.patch"

diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2006-02-27 15:09:55.000000000 -0600
+++ mp-devel-patched/multipathd/main.c	2006-02-27 15:16:13.000000000 -0600
@@ -569,7 +569,7 @@ ev_add_map (char * devname, struct vecto
 	if (map_present && dm_type(alias, DEFAULT_TARGET) <= 0) {
 		condlog(4, "%s: not a multipath map", alias);
 		FREE(alias);
-		return 0;
+		return 1;
 	}
 
 	mpp = find_mp_by_alias(vecs->mpvec, alias);
@@ -709,7 +709,7 @@ ev_add_path (char * devname, struct vect
 		/*
 		 * allow reconfig of orphaned path here
 		 */
-		if (pp->mpp) return 1;
+		if (pp->mpp) return 0;
 	}
 	else {
 		/*

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--fdj2RfSjLxBAspz7--
