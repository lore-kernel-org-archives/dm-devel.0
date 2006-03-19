From: "Abhishek Gupta" <abhishekgupt@gmail.com>
Subject: [PATCH] Fixes for clone_bio and __clone_and_map
	functions in dm.c
Date: Sun, 19 Mar 2006 10:24:00 -0800
Message-ID: <5055b5c00603191024q5e8212b7rbb5074182cc31474@mail.gmail.com>
References: <Pine.GSO.4.60.0603191017150.8166@cascade.cs.ubc.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_6720_15763655.1142792640820"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.GSO.4.60.0603191017150.8166@cascade.cs.ubc.ca>
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

------=_Part_6720_15763655.1142792640820
Content-Type: multipart/alternative;
	boundary="----=_Part_6721_27525087.1142792640820"

------=_Part_6721_27525087.1142792640820
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Alasdair and others,

I found a small bug in the clone_bio() function in dm.c . The number of bio
vectors in the cloned bio is incorrectly set to the index of the last bio
vector in its range. I have corrected it in the attached patch.

I encountered another problem in the final else condition of
__clone_and_map()
function where the bio vector is split in to two parts. This is perhaps
based
on the assumption that the next target can completely accomodate the bio
vector. However, I have encountered situations when this assumption can be
violated and have introduced a do-while loop to correct it.

Please review the attached patch and let me know if you need more
information.

Thanks

Abhishek Gupta
2nd Year Graduate Student
Department of Computer Science, UBC.
Vancouver, Canada.

------=_Part_6721_27525087.1142792640820
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Alasdair and others,<br><br>I found a small bug in the clone_bio() funct=
ion in dm.c . The number of bio<br>vectors in the cloned bio is incorrectly=
 set to the index of the last bio<br>vector in its range. I have corrected =
it in the attached patch.
<br><br>I encountered another problem in the final else condition of __clon=
e_and_map()<br>function where the bio vector is split in to two parts. This=
 is perhaps based<br>on the assumption that the next target can completely =
accomodate the bio
<br>vector. However, I have encountered situations when this assumption can=
 be<br>violated and have introduced a do-while loop to correct it.<br><br>P=
lease review the attached patch and let me know if you need more informatio=
n.
<br><br>Thanks<br><br>Abhishek Gupta<br>2nd Year Graduate Student<br>Depart=
ment of Computer Science, UBC.<br>Vancouver, Canada.<br><br>
<br>

------=_Part_6721_27525087.1142792640820--

------=_Part_6720_15763655.1142792640820
Content-Type: TEXT/PLAIN; name=patchfile; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-ID: <Pine.GSO.4.60.0603191017550.8166@cascade.cs.ubc.ca>
X-Attachment-Id: 0.1
Content-Disposition: attachment; filename="patchfile"

diff -uNr linux-2.6.15.6.vanilla/drivers/md/dm.c linux-2.6.15.6.new/drivers/md/dm.c
--- linux-2.6.15.6.vanilla/drivers/md/dm.c	2006-03-05 11:07:54.000000000 -0800
+++ linux-2.6.15.6.new/drivers/md/dm.c	2006-03-18 11:48:22.000000000 -0800
@@ -441,7 +441,7 @@
 	clone = bio_clone(bio, GFP_NOIO);
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
+	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
@@ -501,30 +501,43 @@
 
 	} else {
 		/*
-		 * Create two copy bios to deal with io that has
+		 * Create multiple copies of bios to deal with io that has
 		 * been split across a target.
 		 */
+		unsigned int offset = 0;  
 		struct bio_vec *bv = bio->bi_io_vec + ci->idx;
+	
+		len = to_sector(bv->bv_len);
+		do {
+			if (len > max) {
+				clone = split_bvec(bio, ci->sector, ci->idx,
+						   bv->bv_offset + offset, max);
+			}
+			else {
+				clone = split_bvec(bio, ci->sector, ci->idx,
+						   bv->bv_offset + offset, len);
+                                /* Terminate do-while. */
+				max = len; 
+			}
+			
+			__map_bio(ti, clone, tio);
+	
+			ci->sector += max;
+			ci->sector_count -= max;
+	
+			len = len - max;
+			if (len > 0) {
+				offset += to_bytes(max);
+				ti = dm_table_find_target(ci->map, ci->sector);
+				max = max_io_len(ci->md, ci->sector, ti);
+
+				tio = alloc_tio(ci->md);
+				tio->io = ci->io;
+				tio->ti = ti;
+				memset(&tio->info, 0, sizeof(tio->info));
+			}
+		} while (len > 0);
 
-		clone = split_bvec(bio, ci->sector, ci->idx,
-				   bv->bv_offset, max);
-		__map_bio(ti, clone, tio);
-
-		ci->sector += max;
-		ci->sector_count -= max;
-		ti = dm_table_find_target(ci->map, ci->sector);
-
-		len = to_sector(bv->bv_len) - max;
-		clone = split_bvec(bio, ci->sector, ci->idx,
-				   bv->bv_offset + to_bytes(max), len);
-		tio = alloc_tio(ci->md);
-		tio->io = ci->io;
-		tio->ti = ti;
-		memset(&tio->info, 0, sizeof(tio->info));
-		__map_bio(ti, clone, tio);
-
-		ci->sector += len;
-		ci->sector_count -= len;
 		ci->idx++;
 	}
 }


------=_Part_6720_15763655.1142792640820
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_Part_6720_15763655.1142792640820--
