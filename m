From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH v3 4/5] Documentation/device-mapper: add optional parameter
 reinit
Date: Thu, 31 Jan 2019 10:29:54 +0800
Message-ID: <20190131022955.9920-5-yehs2007@zoho.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190131022955.9920-1-yehs2007-ytc+IHgoah0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

Add intro and usage guide for reinit.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
---
 Documentation/device-mapper/writecache.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/device-mapper/writecache.txt b/Documentation/device-mapper/writecache.txt
index 01532b3..255c68c 100644
--- a/Documentation/device-mapper/writecache.txt
+++ b/Documentation/device-mapper/writecache.txt
@@ -45,6 +45,10 @@ Constructor parameters:
 		afterwards
 		- some underlying devices perform better with fua, some
 		  with nofua. The user should test it
+	reinit		(by default off)
+		applicable only to persistent memory - use the REINIT flag
+		when the surper block has messy data, that would cause fn ctr
+		failed to work with invalid magic or version in the superblock
 
 Status:
 1. error indicator - 0 if there was no error, otherwise error number
-- 
1.8.3.1
