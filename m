From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [PATCH] multipath-tools: multipath should allow only
 path with valid size to get added in the map
Date: Fri, 20 Nov 2009 20:38:18 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C74DFE@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@free.fr" <christophe.varoqui@free.fr>, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids


Hi,

If READ_CAPACITY fails during device discovery, sd device gets attached w=
ith device size 0. Currently multipath discover these paths and adds into=
 the map. RDAC patch checker sends inquiry on each path to check path sta=
tus, which eventually marks this path as up. If this path is from owning =
controller then mode select will be issued to switch the pathgroup. But a=
ny I/O sent to this path(path with size 0) will eventually fail in sd_pre=
p_fn due to incorrect device size and resulting to ping pong between path=
groups.  We should only allow valid paths to get added in the map. Below =
patch checks two cases before adding paths; i.e.:
	1) device size of path is not 0
	2) there is no mismatch between mpp size and new path size.


Thanks,
Vijay

----
multipath should only add paths with valid size to the map. If there is m=
ismatch between map and path size it should not be added. This patch also=
 check if the device size is not 0 before adding path. During device disc=
overy if READ_CAPACITY fails, sd device get attached with device size 0. =
multipath should not allow the such device to get added in the map.

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

---

diff -uprN multipath-tools-orig/multipathd/main.c multipath-tools/multipa=
thd/main.c
--- multipath-tools-orig/multipathd/main.c	2009-11-20 23:39:09.000000000 =
+0530
+++ multipath-tools/multipathd/main.c	2009-11-21 01:09:16.000000000 +0530
@@ -398,6 +398,17 @@ ev_add_path (char * devname, struct vect
 	mpp =3D pp->mpp =3D find_mp_by_wwid(vecs->mpvec, pp->wwid);
 rescan:
 	if (mpp) {
+			if ((!pp->size) || (mpp->size !=3D pp->size)) {
+				condlog(0, "%s: failed to add new path %s, "
+					"device size mismatch",
+					devname, pp->dev);
+				int i =3D find_slot(vecs->pathvec, (void *)pp);
+				if (i !=3D -1)
+					vector_del_slot(vecs->pathvec, i);
+				free_path(pp);
+				return 1;
+			}
+
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
 		if (adopt_paths(vecs->pathvec, mpp))
@@ -408,6 +419,16 @@ rescan:
 		mpp->action =3D ACT_RELOAD;
 	}
 	else {
+		if (!pp->size) {
+			condlog(0, "%s: failed to create new map,"
+				" %s device size is 0 ", devname, pp->dev);
+			int i =3D find_slot(vecs->pathvec, (void *)pp);
+			if (i !=3D -1)
+				vector_del_slot(vecs->pathvec, i);
+			free_path(pp);
+			return 1;
+		}
+
 		condlog(4,"%s: creating new map", pp->dev);
 		if ((mpp =3D add_map_with_path(vecs, pp, 1)))
 			mpp->action =3D ACT_CREATE;

--
