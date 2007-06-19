From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dmsetup: missing end of string
Date: Tue, 19 Jun 2007 10:58:20 -0400
Message-ID: <4677EF0C.7030308@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070402080707070501020108"
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

This is a multi-part message in MIME format.
--------------070402080707070501020108
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

'devno' field of dmsetup info doesn't work.

# dmsetup info -c -o devno
dm_report: snprintf heading failed
dm_report: left-aligned snprintf() failed

There is a missing '\0' at the end of the copied strings.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------070402080707070501020108
Content-Type: text/x-patch;
 name="dmsetup-info-missing-eos.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmsetup-info-missing-eos.patch"

Index: device-mapper.work/dmsetup/dmsetup.c
===================================================================
--- device-mapper.work.orig/dmsetup/dmsetup.c
+++ device-mapper.work/dmsetup/dmsetup.c
@@ -1629,7 +1629,7 @@ static int _dm_info_devno_disp(struct dm
 		goto out_abandon;
 	}
 
-	if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+	if (!dm_pool_grow_object(mem, buf, strlen(buf) + 1)) {
 		log_error("dm_pool_grow_object failed");
 		goto out_abandon;
 	}

--------------070402080707070501020108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070402080707070501020108--
