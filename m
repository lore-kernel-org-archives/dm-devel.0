From: ding.yemin@zte.com.cn
Subject: [PATCH] Add break for switch-case in
	prin_do_scsi_ioctl().
Date: Tue, 25 Oct 2016 14:56:36 +0800
Message-ID: <1477378596-4916-1-git-send-email-ding.yemin@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, "ding.yemin" <ding.yemin@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "ding.yemin" <ding.yemin@zte.com.cn>

Add break for switch-case in prin_do_scsi_ioctl().

Signed-off-by: ding.yemin <ding.yemin@zte.com.cn>
---
 libmpathpersist/mpath_pr_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 8b9ac3d..ffe7468 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -392,6 +392,7 @@ retry :
 			break;
 		case MPATH_PRIN_RFSTAT_SA :
 			mpath_format_readfullstatus(resp, got, noisy);
+			break;
 	}
 
 out:
-- 
2.8.1.windows.1
