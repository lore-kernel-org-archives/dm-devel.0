From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/21] dm: Minor output tweaks
Date: Sun, 9 Oct 2016 16:28:55 +0300
Message-ID: <20161009132855.GA2201@obsidian>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005.192828.566127461630656590.yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Trying to make it more C-like and in line with common practices
regarding structure printing.
---
 dm.c             |   21 +++++++++++++--------
 tests/ioctl_dm.c |    2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/dm.c b/dm.c
index d81983d..ebdfc44 100644
--- a/dm.c
+++ b/dm.c
@@ -120,7 +120,7 @@ dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
 			offset = new_offset;
 		} else {
 misplaced:
-			tprints(", misplaced struct dm_target_spec");
+			tprints(", /* misplaced struct dm_target_spec */ ...");
 			break;
 		}
 	}
@@ -150,7 +150,7 @@ dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
 		tprints("}");
 	} else {
  misplaced:
-		tprints(", misplaced struct dm_target_deps");
+		tprints(", /* misplaced struct dm_target_deps */ ...");
 	}
 }
 
@@ -182,7 +182,7 @@ dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
 			offset = offset + s->next;
 		} else {
  misplaced:
-			tprints(", misplaced struct dm_name_list");
+			tprints(", /* misplaced struct dm_name_list */ ...");
 			break;
 		}
 	}
@@ -216,7 +216,8 @@ dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra,
 			offset = offset + s->next;
 		} else {
  misplaced:
-			tprints(", misplaced struct dm_target_versions");
+			tprints(", /* misplaced struct dm_target_versions */ "
+				"...");
 			break;
 		}
 	}
@@ -240,7 +241,7 @@ dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
 				    QUOTE_0_TERMINATED);
 		tprints("}");
 	} else {
-		tprints(", misplaced struct dm_target_msg");
+		tprints(", /* misplaced struct dm_target_msg */");
 	}
 }
 
@@ -255,7 +256,7 @@ dm_decode_string(const struct dm_ioctl *ioc, const char *extra,
 		print_quoted_string(extra + offset, extra_size - offset,
 				    QUOTE_0_TERMINATED);
 	} else {
-		tprints(", misplaced string");
+		tprints(", /* misplaced string */");
 	}
 }
 
@@ -275,8 +276,10 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	 * if we use a different version of ABI, do not attempt to decode
 	 * ioctl fields
 	 */
-	if (ioc.version[0] != DM_VERSION_MAJOR)
+	if (ioc.version[0] != DM_VERSION_MAJOR) {
+		tprints(", /* Unsupported device mapper ABI version */ ...");
 		goto skip;
+	}
 
 	if (ioc.data_size > sizeof(ioc)) {
 		extra = malloc(ioc.data_size);
@@ -292,7 +295,9 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	dm_decode_device(code, &ioc);
 	dm_decode_values(tcp, code, &ioc);
 	dm_decode_flags(&ioc);
-	if (!abbrev(tcp))
+	if (abbrev(tcp))
+		tprints(", ...");
+	else
 		switch (code) {
 		case DM_DEV_WAIT:
 		case DM_TABLE_STATUS:
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index cb6dd97..ba484ee 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -98,7 +98,7 @@ main(void)
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", target_count=4294967295, flags=0, "
 	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
-	       "misplaced struct dm_target_spec}, "
+	       "/* misplaced struct dm_target_spec */ ...}, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
