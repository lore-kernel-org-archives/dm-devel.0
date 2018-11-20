From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [RFC PATCH 3/3] dm: expand valid types for dm-ioctl
Date: Tue, 20 Nov 2018 18:20:37 +0800
Message-ID: <20181120102037.4536-4-yehs2007@zoho.com>
References: <20181120102037.4536-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181120102037.4536-1-yehs2007-ytc+IHgoah0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

If use DAX way to mount the origin device of dm_snapshot, when
merging back snapshot to origin, system call table_load during the
construction of snapshot-merge will try to detect new dm_table's type
equals to the existed md's type or not.
The existed type equals to DM_TYPE_DAX_BIO_BASED, but the new created
type belongs to DM_TYPE_BIO_BASED. So, we need to expand valid_type in
function is_valid_type.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
---
 drivers/md/dm-ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a27016e..158d657 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1295,7 +1295,8 @@ static int populate_table(struct dm_table *table,
 static bool is_valid_type(enum dm_queue_mode cur, enum dm_queue_mode new)
 {
 	if (cur == new ||
-	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
+	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED) ||
+	    (cur == DM_TYPE_DAX_BIO_BASED && new == DM_TYPE_BIO_BASED))
 		return true;
 
 	return false;
-- 
1.8.3.1
