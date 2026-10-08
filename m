Received: from sonic305-19.consmr.mail.sg3.yahoo.com (sonic305-19.consmr.mail.sg3.yahoo.com [106.10.241.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C744335F164
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 04:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791434291; cv=none; b=jNNc9GFi67xgxvvXw2Azff4Mf3kUk7S9x4HPJJG5PPMKoyUAC9o4G7Tnu3gowfQDTQlBLYyapbG1Y9Tk1uxHvBJP0cmzKZiVCNTfjqF1emnP662mSPmnzWGfEtlRuCgiSmOWitczVqS/EtI1U23xFGFvCANCDVoIk89HLSna5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791434291; c=relaxed/simple;
	bh=l95/+/RyjgGt9W12BZKaUvc0XYk+4SCwkQqXKYqpE0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS6RHFdrJ2kETqq8xe4RmXF/F7wO2rwJGyrMvQsFB8M7g0uB6IZ8hFzWXazSibXIZbY+f5wycJeqXnaW7RIeZyel+GtcwXO615GaDoFID4sHbMAyPZ6e8DhGw2Uy64XzpveD1gLN5UlHg1SFA5b3nncgMxvJPRwObqDD/uWJwDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=KnSx5xD2; arc=none smtp.client-ip=106.10.241.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="KnSx5xD2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434282; bh=5kcHwpSpU++ojVGe8gUWq+naTa316eEPqQBGG3YkYb0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=KnSx5xD28DOz6kH8dEIYZ9bS9PVZcWGVZFRPXloppM9AOI6NN/5siX9Dg2M/o4Dpvbl+cE86WrxbJfuuRV9sUuPScLwXLrRUuq5mQQPJs5QiBi2hYwfTDNY8BLjuxJ8ht2TroFD6NqofsRvQJcSFcNRMGR2Nh3OkVr6k0RmeEY3Ng8VORMt2jvbbwdymWWbnDta6/UplGmnZskTfhdTUzyhGnHdUFxNdhq9Ll9la6CNnIxGTC7YqzjUkQwYAflfGD74lhwbLXu+JpuJLklBrlhCBOZGeLtZK9rQNLS5wsyylQpz/+2ElGtOEV2GO73tgbtpztaCRPGh2ueFKgzeMrQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434282; bh=sZlMlHIMiScPP2zPhVg3mwLaW1lrDsM3+I7pNEc53ed=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ATaQgJwedV7UOC/WpgAvDA9ClOHtgLoIe3x27BHr/mpFGaZBilWbl8pb8xsCJ53C46dYKlOshUhO6mR2bYMSVKQ/lJFwbCAChPcGJ47Rq8YWnyHZh41Eb9bHz1ky0duIDgNgDBqtjtqNWa75dazZOQD/Pcw8YdWiUVggcoqwF3vrNkWrp/5gt5rCEM0cqSTLCqjjo43N4TfVLeDrOt59lwW+yp0le38Qw7ntOn/h8FKvKVmPiRoxo5fOLcUwGdO/S1uglIWL+SOGuNeiSPIPvD+bffjvoyLKSbASbE8mfGwxO6kAE5WnIXu/hHlJnnkgNGuxkJdICHaBlMaT1zlzYA==
X-YMail-OSG: .75huU8VM1kAs0Du9Ex906FBqQiGAfZSXrhmfwjG.na4mSoE28hR3nvlaLzRRH7
 tQPxn3kGOJpDJj0yL2WPevVvTpxI2WltAlWjzqZLaPalnCLgEO4P3WEFnlbFgJZFSoUDlaz1iLX3
 kGbz3vCncvHeldxTT2KMB25OnlOJ.FjTDX2Hqodfu_mw55CSWvxQR8Vm293OW31ixPu4V46l2gE9
 xUkE25noIk4mQpVGCOxObSQzB8NFddpp4DsbTMwxdXMuWfLh3nKCl8tiAZwovws43yWFPs3IACsB
 cZn5Mu4P.ydZR_jpYa0Ydy6miGDef_YOcC5LSl1vfgFxtAlwVMJMGQe_ww5xM6vyWcDS0qMGYw0r
 Gan7EUnuzJsHY8KrcYBNS93.56HKBNEecGTiDPdqOTqW.kgLAtHFGaytxjaYtp6l5DF7XIeMDnem
 pJ36J2rCEumOWlNFG8eEeE3k9i10dTle.S8ZwkSeOHgSxFH2vr0hFoFsxSR95uYM7DDGROyNNzWW
 iAHEUWdh6EpSIzQH_vQRn1OCJ2EDQKbnmWC.xEutLWTMH3o9_7g11bSdZG0d.gSKBJfnNgqU25PX
 hC0FvdijoX5KGJRphyGkC6NuqrF0Sn6T5MCfLeG6BwIRS9_5scwO7NzaNfeYqPKIK.A_GdGwwJh_
 HR.LwQpsW10L098S_s5cIv0VK0RJcq5KARREo2yUk1BBLaYlXzlCY089CDxapH2PKkHC7FqsY9M7
 IZjznWYPoBFbwo.BQKR9wJkXfnVcbCqv2fAgmbUc1EtS1kIqfcezw7cdXvEeM0M9NpJtTMSLoQI4
 1vDepTRYokWf8JLKIoAJBjyVOGGCVDtR.pESOWI6GlDKEzvQeHYjsUbzmr.MzyBn5CY5UNsX4O2b
 VxCqnslqvG3dedHvsZpriczjlC.jE7enS8sadKoWK2o1I90nPOzAWgLIcA8ei_g93yNkAwoBPVt4
 VSQUgERfOKv7ObHasTQu2wq.EAJgfew90d29pFOTsUZtQMjyA33ExVJECO7OHspcSYs0y_10Fn3l
 FDST6ZAk3_hNiHK1DxdtGPnJmjKkE9kHztJJ_3t.KQ0GtQO3PqkadFJzAxb0Xuwvkb.TJJTWu2Od
 zzlhe76aid9oE5GcFzkaOdG_ReWA282AiaRoXLgJnQLqlXVMJ3pIGswhaDJpVjHjg0eD3Z0BYtrB
 glDYkrkGMSXPM1vr2w8cqjCM4NPLGvJgXZfw3.695O4EbI6sZiLxA6cpPlTq3gtVgaYtY_QXaGpa
 zSuOSI6K3yDpcSTXdh8sGnoi0Q0qP.mNlU793XQ7OEM3ZSLkBJ3T7SCznM4oPl1piHSxfqbt.HES
 Y_zxcMI58ArdNEgwFJNuNKLfN0i.Qbxxnnxudo.ieQnpzxDCRWE1UEt6UBIBPcVvtYEiQndfyNYl
 8X2b8XG8w9DZeHU1lbmU0JInIZ_ZUzNLV4X2sDZW9zkw5r6G19Qm9EANH2FCPJCxqlGsBqS1a.34
 9ONcgdAtQaTv5oLHIyuRmI4SgbTPC488K4GNqwACZ3GV8Jz.vk2qsxVLQOGo8.o1VoTXusdqmAHn
 muidThVDLcgBrL4RPApZC5w1flFf6XQH11KXBPqqJEaYkJisQ4JvXmwn9Cn_dZnfv5oIEC4.gGOu
 rDXlXOaqByxQgPis3C8UvqWT4LxA2l8Q4D1i0hNysA5P32iOx5lv3qas_XLKE9Osm5OOFuFeEtug
 JtnP3lo1x0BoqZfpwlBzU.aKozzsCLUMuL0e8z.iz8sS3zPoYWzF_.lRQxr8zOsZlrhyeJeLvCDi
 yPC0vJokBxj5OLOYdDvqA26Upr24esvdRQ.NXuFeOgkSAXdgarf.feNy7enOcJoKfEpoMzKjHJij
 4PmPaD3eeWJuZZk0MkzVxa34XcCKSQyAEYo2Tq1IaVdbIeKcevXd9BmIQddPjjQknXE7I_hjNbRh
 bfyfL0lN71.rm46YdpVdOUS2Bl3BrS4EjwaO9RAO67m0NC6w72sfl8kuvZJ5_idEOhooRgJtVI0I
 .MssYIDIaS4R_kZ4nfeWW2zOnm5iUzl6hQAfRvCCh07Llo7KzRcLewd4MJJet1x9emccJ23DYVvI
 NnNJrv44ZnuXalNjkYD9DC_VwDIxtrtjzjdSR9pIFAuBg5XpliviLwR.yCO_1RDV6gZrxd5szqoG
 QfVWot0bHAyjmgeAqfvPLmhKzC3llo9NCDsym1eXbgyZVdx5dwA4m5ajJAToG60jN3AKhuB.Hc16
 ExMI8aUYnVNWbUhHwMzs.a6rx..7h5lrU4_A8I_33yeBVQ0paLacObCZHdk1SBhCxsg--
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 97640624-abd2-4db1-849e-71bac7464847
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.sg3.yahoo.com with HTTP; Thu, 8 Oct 2026 04:38:02 +0000
Received: by hermes--production-sg3-cd7bfcc7f-9nsxm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7fbaa42255083875bb3346c67ecc2047;
          Thu, 08 Oct 2026 04:37:57 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH v3 1/2] libmultipath: dm_flush_map__: do not treat query error as external removal
Date: Thu,  8 Oct 2026 04:37:48 +0000
Message-ID: <20261008043749.23389-2-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008043749.23389-1-suresh.thelkar@yahoo.com>
References: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
 <20261008043749.23389-1-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a failed DM_DEVICE_REMOVE, dm_flush_map__() classified anything that
was not DM_IS_MPATH_YES as "removed externally" and returned DM_FLUSH_OK
without resuming the map it had just suspended. dm_is_mpath() also
returns DM_IS_MPATH_ERR (-1) when the status query itself fails, which
happens transiently under a heavy ioctl load (e.g. LUN-number recycling
plus ALUA transitions). A transient error was thus misread as a
successful external removal, and the map was left suspended
indefinitely, wedging later I/O node-wide via sync().

Only DM_IS_MPATH_NO now counts as "removed externally". A query error is
logged and falls through to the resume path instead of being reported as
success.

Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e3870f59..a5570a85 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1042,13 +1042,26 @@ int dm_flush_map__ (const char *mapname, int flags, int retries)
 			}
 			condlog(4, "multipath map %s removed", mapname);
 			return DM_FLUSH_OK;
-		} else if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
-			condlog(4, "multipath map %s removed externally",
-				mapname);
-			return DM_FLUSH_OK; /* raced. someone else removed it */
 		} else {
-			condlog(2, "failed to remove multipath map %s",
-				mapname);
+			int is_mpath = dm_is_mpath(mapname);
+
+			if (is_mpath == DM_IS_MPATH_NO) {
+				condlog(4, "multipath map %s removed externally",
+					mapname);
+				return DM_FLUSH_OK; /* raced. someone else removed it */
+			}
+			/*
+			 * A query error (DM_IS_MPATH_ERR) must not be treated
+			 * as "removed externally": under an ioctl storm the
+			 * status query can transiently fail, and returning
+			 * DM_FLUSH_OK here would leave the map suspended.
+			 */
+			if (is_mpath == DM_IS_MPATH_ERR)
+				condlog(1, "%s: unable to verify map state after failed remove",
+					mapname);
+			else
+				condlog(2, "failed to remove multipath map %s",
+					mapname);
 			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1) {
 				dm_simplecmd_noflush(DM_DEVICE_RESUME,
 						     mapname, udev_flags);
-- 
2.43.0

