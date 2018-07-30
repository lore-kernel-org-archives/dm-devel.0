From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v3 2/6] s390,
 dcssblk: kaddr and pfn can be NULL to ->direct_access()
Date: Mon, 30 Jul 2018 15:15:44 +0800
Message-ID: <20180730071548.9172-3-yehs2007@zoho.com>
References: <20180730071548.9172-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180730071548.9172-1-yehs2007-ytc+IHgoah0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

dcssblk_direct_access() needs to check the validity of pointers kaddr
and pfn for NULL assignment. If anyone equals to NULL, it doesn't need
to calculate the value.

If either of them is equal to NULL, that is to say callers may
have no need for kaddr or pfn, so this patch is prepared for allowing
them to pass in NULL instead of having to pass in a pointer or local
variable that they then just throw away.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Acked-by: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
---
 drivers/s390/block/dcssblk.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index ed60728..23e526c 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -922,9 +922,11 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
 	unsigned long dev_sz;
 
 	dev_sz = dev_info->end - dev_info->start + 1;
-	*kaddr = (void *) dev_info->start + offset;
-	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
-			PFN_DEV|PFN_SPECIAL);
+	if (kaddr)
+		*kaddr = (void *) dev_info->start + offset;
+	if (pfn)
+		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
+				PFN_DEV|PFN_SPECIAL);
 
 	return (dev_sz - offset) / PAGE_SIZE;
 }
-- 
1.8.3.1
