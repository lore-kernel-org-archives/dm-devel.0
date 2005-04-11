From: k-ueda@ct.jp.nec.com
Subject: [PATCH] dm_mapname fix in multipath-tools-0.4.4-pre11
Date: Mon, 11 Apr 2005 16:15:59 -0400 (EDT)
Message-ID: <42686.4909161397$1113250495@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hi Christophe,

In multipath-tools-0.4.4-pre11 kpartx/devmapper.c:135:
-------------------------------------------
        mapname = dm_task_get_name(dmt);
out:
        dm_task_destroy(dmt);
        return mapname;
}
-------------------------------------------

dm_task_get_name returns a pointer to dmt->dmi.v4->name
which will be freed at dm_task_destroy() just before return.


--- multipath-tools-0.4.4-pre11/kpartx/devmapper.c      2005-04-07 09:47:26.000000000 -0400
+++ dm-mapname-fix/kpartx/devmapper.c   2005-04-12 04:15:14.990239582 -0400
@@ -132,7 +132,7 @@ dm_mapname(int major, int minor)
        if (!dm_task_run(dmt))
                goto out;

-       mapname = dm_task_get_name(dmt);
+       mapname = strdup(dm_task_get_name(dmt));
 out:
        dm_task_destroy(dmt);
        return mapname;


Regards,
Ky (Kiyoshi Ueda)
