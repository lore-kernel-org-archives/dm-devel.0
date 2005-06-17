From: "Zhao Qian" <zhaoqian@aaastor.com>
Subject: [patch] dm-raid1.c  fix  a race bug in __rh_alloc()
Date: Fri, 17 Jun 2005 10:21:30 +0800
Message-ID: <003101c572e3$4a0a9f80$1f000064@polaris>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

after write_unlock_irq and just before read_lock, there's a small window =
which enables a race causing deletion of the region struct in function rh=
_update_states(). then in rh_dec(), the __rh_lookup() will return null, c=
ausing kernel panic.=20


[root@darkstar md]# diff -u dm-raid1.orig.c dm-raid1.c=20
--- dm-raid1.orig.c     2005-06-16 14:17:04.000000000 +0800
+++ dm-raid1.c  2005-06-17 10:02:04.000000000 +0800
@@ -252,15 +252,16 @@
=20
        else {
                __rh_insert(rh, nreg);
-               if (nreg->state =3D=3D RH_CLEAN) {
-                       spin_lock(&rh->region_lock);
-                       list_add(&nreg->list, &rh->clean_regions);
-                       spin_unlock(&rh->region_lock);
-               }
                reg =3D nreg;
        }
        write_unlock_irq(&rh->hash_lock);
        read_lock(&rh->hash_lock);
+       if (reg->state =3D=3D RH_CLEAN) {
+               spin_lock(&rh->region_lock);
+               if ( list_empty(&reg->list) )
+                       list_add(&reg->list, &rh->clean_regions);
+               spin_unlock(&rh->region_lock);
+       }
=20
        return reg;
 }

Sincerely,
    Johnson <dujun@aaastor.com>
    AiM9 <zhaoqian@aaastor.com>
