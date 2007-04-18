From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (2/6) Fix trailing separator
Date: Wed, 18 Apr 2007 12:47:31 -0400
Message-ID: <46264BA3.6090705@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090106030607080304060000"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46264A57.1020800@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090106030607080304060000
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch fixes dm_report_output() so that it can correctly check
the end of the row.

It uses list_end() but trailing fields may have HIDDEN flag and
not be printed.

For example,
# dmsetup info -c -o name -O minor VG0-lv0
Name
VG0-lv0
# dmsetup info -c -o name -O minor --noheadings VG0-lv0
VG0-lv0:
# dmsetup info -c -o name --noheadings VG0-lv0
VG0-lv0

The patch fixes it by inserting hidden fields at the head of the list.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------090106030607080304060000
Content-Type: text/x-patch;
 name="libdm-report-fix-trailing-separator.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="libdm-report-fix-trailing-separator.patch"

Later, dm_report_output() loops through rh->field_props list
and checks the end of the list by list_end() whether to display the
separator or not.
The check doesn't work if hidden field is on the tail.

For example, try 'dmsetup info -c -o name -O minor' and
compare the results with and without '--noheadings'.

---
 lib/libdm-report.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: device-mapper.work/lib/libdm-report.c
===================================================================
--- device-mapper.work.orig/lib/libdm-report.c
+++ device-mapper.work/lib/libdm-report.c
@@ -315,7 +315,12 @@ static struct field_properties * _add_fi
 	/* Add additional flags */
 	fp->flags |= flags;
 
-	list_add(&rh->field_props, &fp->list);
+	/* Hidden field must come first, otherwise list_end() doesn't work
+	   as expected */
+	if (fp->flags & FLD_HIDDEN)
+		list_add_h(&rh->field_props, &fp->list);
+	else
+		list_add(&rh->field_props, &fp->list);
 	return fp;
 }
 

--------------090106030607080304060000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090106030607080304060000--
