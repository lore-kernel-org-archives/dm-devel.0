From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: RE: [PATCH] multipath-tools: multipath should allow	only
	path with valid size to get added in the map
Date: Mon, 23 Nov 2009 11:21:58 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C74E91@inbmail01.lsi.com>
References: <1258754235.20768.1.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258754235.20768.1.camel@chandra-ubuntu>
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
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

=20
On Friday, November 20, 2009 at 21:55:00 UTC, Chandra Seetharaman wrote :
 > Looks good to me except one comment below.
 >=20

 > > +			if ((!pp->size) || (mpp->size !=3D pp->size)) {
 > > +				condlog(0, "%s: failed to add=20
 > new path %s, "
 > > +					"device size mismatch",
 >=20
 > Appropriate error message for the two different cases=20
 > (pp->size =3D 0 and
 > mpp->size!=3D pp->size) would be the right thing to do, IMO.
 >=20
 > > +					devname, pp->dev);

Chandra, Thanks for you comment. I have made the changes as per your comm=
ent.

Please let me if it looks fine now.


Thanks,
Vijay


---
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
+++ multipath-tools/multipathd/main.c	2009-11-23 16:37:16.000000000 +0530
@@ -396,8 +396,29 @@ ev_add_path (char * devname, struct vect
 		return 2;
 	}
 	mpp =3D pp->mpp =3D find_mp_by_wwid(vecs->mpvec, pp->wwid);
+	if (!pp->size) {
+		condlog(0, "%s: not a valid path %s, "
+			" device size is 0 ", devname, pp->dev);
+		int i =3D find_slot(vecs->pathvec, (void *)pp);
+		if (i !=3D -1)
+			vector_del_slot(vecs->pathvec, i);
+		free_path(pp);
+		return 1;
+	}
+
 rescan:
 	if (mpp) {
+		if (mpp->size !=3D pp->size) {
+			condlog(0, "%s: failed to add new path %s, "
+				"device size mismatch",
+				devname, pp->dev);
+			int i =3D find_slot(vecs->pathvec, (void *)pp);
+			if (i !=3D -1)
+				vector_del_slot(vecs->pathvec, i);
+			free_path(pp);
+			return 1;
+		}
+
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
 		if (adopt_paths(vecs->pathvec, mpp))
--
