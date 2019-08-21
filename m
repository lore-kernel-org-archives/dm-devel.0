From: "boojin.kim" <boojin.kim@samsung.com>
Subject: [PATCH 3/9] mmc: dw_mmc: support crypto operation
Date: Wed, 21 Aug 2019 15:42:18 +0900
Message-ID: <003f01d557eb$94210260$bc630720$@samsung.com>
References: <CGME20190821064219epcas2p28b42391923012ecc7875313b8b2b9a1a@epcas2p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Language: ko
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Cc: 'Ulf Hansson' <ulf.hansson@linaro.org>, 'Mike Snitzer' <snitzer@redhat.com>, dm-devel@redhat.com, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alasdair Kergon' <agk@redhat.com>, 'Eric Biggers' <ebiggers@kernel.org>, linux-samsung-soc@vger.kernel.org, 'Herbert Xu' <herbert@gondor.apana.org.au>, 'Krzysztof Kozlowski' <krzk@kernel.org>, 'Jaehoon Chung' <jh80.chung@samsung.com>, 'Kukjin Kim' <kgene@kernel.org>, linux-ext4@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 'Jaegeuk Kim' <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org, 'Jens Axboe' <axboe@kernel.dk>, 'Theodore Ts'o' <tytso@mit.edu>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, "'David S. Miller'" <davem@davemloft.net>
List-Id: dm-devel.ids

This patch supports the crypto operation in mmc driver.
Two vops are added to dw_mci_drv_data for it.
The crypto_engine_cfg() is required to set crypto information such as
key and algorithm modes before I/O.
The crypto_engine_clear() is required to clear the crypto information
set in the H/W after I/O.

Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 drivers/mmc/host/dw_mmc.c | 22 +++++++++++++++++++++-
 drivers/mmc/host/dw_mmc.h |  6 ++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index eea52e2..0cdf574 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -470,6 +470,7 @@ static void dw_mci_dmac_complete_dma(void *arg)
 {
 	struct dw_mci *host = arg;
 	struct mmc_data *data = host->data;
+	const struct dw_mci_drv_data *drv_data = host->drv_data;
 
 	dev_vdbg(host->dev, "DMA complete\n");
 
@@ -481,6 +482,9 @@ static void dw_mci_dmac_complete_dma(void *arg)
 				    data->sg_len,
 				    DMA_FROM_DEVICE);
 
+	if (drv_data && drv_data->crypto_engine_clear)
+		drv_data->crypto_engine_clear(host, host->sg_cpu, false);
+
 	host->dma_ops->cleanup(host);
 
 	/*
@@ -577,8 +581,10 @@ static inline int dw_mci_prepare_desc64(struct dw_mci
*host,
 {
 	unsigned int desc_len;
 	struct idmac_desc_64addr *desc_first, *desc_last, *desc;
+	int i, ret;
+	const struct dw_mci_drv_data *drv_data = host->drv_data;
+	int sector_offset = 0;
 	u32 val;
-	int i;
 
 	desc_first = desc_last = desc = host->sg_cpu;
 
@@ -618,6 +624,20 @@ static inline int dw_mci_prepare_desc64(struct dw_mci
*host,
 			desc->des4 = mem_addr & 0xffffffff;
 			desc->des5 = mem_addr >> 32;
 
+			if (drv_data && drv_data->crypto_engine_cfg) {
+				ret = drv_data->crypto_engine_cfg(host,
desc,
+						data, sg_page(&data->sg[i]),
i,
+						sector_offset, false);
+				if (ret) {
+					dev_err(host->dev,
+						"%s: fail to set
crypto(%d)\n",
+						__func__, ret);
+					return -EPERM;
+				}
+				/* mmc sector size */
+				sector_offset += desc_len / 512;
+			}
+
 			/* Update physical address for the next desc */
 			mem_addr += desc_len;
 
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index da5923a..b32d39b 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -563,5 +563,11 @@ struct dw_mci_drv_data {
 						struct mmc_ios *ios);
 	int		(*switch_voltage)(struct mmc_host *mmc,
 					  struct mmc_ios *ios);
+	int		(*crypto_engine_cfg)(struct dw_mci *host, void
*desc,
+				struct mmc_data *data, struct page *page,
+				int page_offset, int sector_offset,
+				bool cmdq_enabled);
+	int		(*crypto_engine_clear)(struct dw_mci *host,
+				void *desc, bool cmdq_enabled);
 };
 #endif /* _DW_MMC_H_ */
-- 
2.7.4
