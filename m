From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: patch to discovery.c to still get
	pathpriorityforpaths with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 23:33:43 +0100
Message-ID: <1163630023.10466.141.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-wuDxynyUsFoXy6kTlR2X"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, dave.wysochanski@redhat.com
List-Id: dm-devel.ids


--=-wuDxynyUsFoXy6kTlR2X
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le mercredi 15 novembre 2006 =C3=A0 14:48 -0500, Edward Goggin a =C3=A9cr=
it :
> On Wednesday, November 15, 2006 1:49 AM, Dave Wysochanski wrote
>=20
> > One other thought I had was the notion of a "priority valid"=20
> > flag (or a
> > special priority value) in the path for the case of=20
> > group_by_prio.  Set
> > it to invalid in alloc_path(), then just don't add the path to the
> > multipath struct in coalesce_paths() if the priority value=20
> > was invalid.
> > Then over in checkerloop(), add the path to the multipath map when yo=
u
> > get a valid priority.
> >=20
> > It is more complicated than that I'm sure (e.g. checkerloop() assumes
> > pp->mpp is non-null in places, etc) but seemed like a half-decent
> > approach to at least consider.
> >=20
> > This approach doesn't take into consideration the general case of a
> > change in path priority though.
>=20
> I very much like the first part of your "priority valid" idea
> mentioned above.
>=20
> I've enclosed a patch for the first part of your idea.  The patch
> should address the concern you had about recalculating priority
> for a path when its path state changes from not PATH_DOWN to
> PATH_DOWN.  It now only retrieves the priority for PATH_DOWN
> paths if the path's priority has never been successfully
> retrieved before.
>=20
How about the following, clarifying PRIO values and avoiding the
additional "struct path" element ?

Please have a careful look at the multipath/main.c:update_paths change,
because the (!pp->priority) that was there awfully looks like a bug (as
0 is not a defined prio value).

Regards,
cvaroqui



--=-wuDxynyUsFoXy6kTlR2X
Content-Disposition: attachment; filename=0010-prio-defines.diff
Content-Type: text/x-patch; name=0010-prio-defines.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b66cf23..9d17022 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -441,7 +441,7 @@ coalesce_paths (struct vectors * vecs, v
 		if ((mpp = add_map_with_path(vecs, pp1, 0)) == NULL)
 			return 1;
 
-		if (pp1->priority < 0)
+		if (pp1->priority == PRIO_UNDEF)
 			mpp->action = ACT_REJECT;
 
 		if (!mpp->paths) {
@@ -468,7 +468,7 @@ coalesce_paths (struct vectors * vecs, v
 					mpp->size);
 				mpp->action = ACT_REJECT;
 			}
-			if (pp2->priority < 0)
+			if (pp2->priority == PRIO_UNDEF)
 				mpp->action = ACT_REJECT;
 		}
 		verify_paths(mpp, vecs, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 69c9bc3..f21e5bc 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -638,14 +638,14 @@ get_prio (struct path * pp)
 		pp->getprio_selected = 1;
 	}
 	if (!pp->getprio) {
-		pp->priority = 1;
+		pp->priority = PRIO_DEFAULT;
 	} else if (apply_format(pp->getprio, &buff[0], pp)) {
 		condlog(0, "error formatting prio callout command");
-		pp->priority = -1;
+		pp->priority = PRIO_UNDEF;
 		return 1;
 	} else if (execute_program(buff, prio, 16)) {
 		condlog(0, "error calling out %s", buff);
-		pp->priority = -1;
+		pp->priority = PRIO_UNDEF;
 		return 1;
 	} else
 		pp->priority = atoi(prio);
@@ -701,13 +701,12 @@ pathinfo (struct path *pp, vector hwtabl
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	/*
-	 * Path state of PATH_DOWN does not necessarily prevent
-	 * path priority callout (or getuid callouot) from
-	 * succeeding since the path may be being considered
-	 * failed for reasons other than transport connectivity.
-	 */
-	if (mask & DI_PRIO)
+	 /*
+	  * Retrieve path priority for even PATH_DOWN paths if it has never
+	  * been successfully obtained before.
+	  */
+	if (mask & DI_PRIO &&
+	    (pp->state != PATH_DOWN || pp->priority != PRIO_UNDEF))
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f0564c2..db3f824 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -31,6 +31,7 @@ alloc_path (void)
 		pp->sg_id.scsi_id = -1;
 		pp->sg_id.lun = -1;
 		pp->fd = -1;
+		pp->priority = PRIO_UNDEF;
 	}
 	return pp;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index faa2b8f..7db7faa 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -18,6 +18,9 @@ #define NO_PATH_RETRY_UNDEF	0
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
+#define PRIO_UNDEF		-1
+#define PRIO_DEFAULT		1
+
 enum free_path_switch {
 	KEEP_PATHS,
 	FREE_PATHS
diff --git a/multipath/main.c b/multipath/main.c
index a5f122e..accb230 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -134,7 +134,7 @@ update_paths (struct multipath * mpp)
 			if (pp->state == PATH_UNCHECKED)
 				pathinfo(pp, conf->hwtable, DI_CHECKER);
 
-			if (!pp->priority)
+			if (pp->priority == PRIO_UNDEF)
 				pathinfo(pp, conf->hwtable, DI_PRIO);
 		}
 	}

--=-wuDxynyUsFoXy6kTlR2X
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-wuDxynyUsFoXy6kTlR2X--
