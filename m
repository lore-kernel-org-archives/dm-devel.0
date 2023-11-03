Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6F31D55E;
	Fri,  3 Nov 2023 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8DCkJ14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24F5C433C9;
	Fri,  3 Nov 2023 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699030443;
	bh=03QJ3PTCv+FjBj9S/gwPR8AYKtrdfz+IgTjZitD7WdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q8DCkJ14x4w34x3tOqYXmmzrH6nPzt9hDkXcYILMc0TrCTMoTdEuBSnr5IkLwmiO4
	 MWQh8LzkG2oulV82QJ58BrAF2eens8GmnG9gD1nPx4s3Kqo0QMTlswul857GXPBx2z
	 6bPvSxA75lyF9BX1xYaNMLHFNULdewYizxlE1suD6FBl/wTmQ/R557SKvfu6H39aaU
	 YebSBv9hHHEdpRvJpFVqULghgOsdnyuxyVGNjXhIyAaI0Sb4MSi77Vp+W4fua+qCub
	 yqWlPcGYZYyzxOt2UuT7JajDm4SqRzOdihYAf8GAQo3Wj8u1bAzvCMnDqQl5qxxBPn
	 2J3yheVPauoPw==
Date: Fri, 3 Nov 2023 10:54:00 -0600
From: Keith Busch <kbusch@kernel.org>
To: Marek =?us-ascii?Q?Marczykowski-G'orecki?= <marmarek@invisiblethingslab.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com>
References: <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
 <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
 <ZUUctamEFtAlSnSV@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUUctamEFtAlSnSV@mail-itl>

On Fri, Nov 03, 2023 at 05:15:49PM +0100, Marek Marczykowski-G'orecki wrote:
> On Thu, Nov 02, 2023 at 06:06:33PM +0100, Mikulas Patocka wrote:
> > Then, try this patch (without "iommu=panic"), reproduce the deadlock and 
> > tell us which one of the "printk" statements is triggered during the 
> > deadlock.
> 
> The "821" one - see below.

Thanks for confirming!

Could you try this patch?

---
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 60a08dfe8d75f..348fd6c6702a5 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -41,7 +41,7 @@
  * These can be higher, but we need to ensure that any command doesn't
  * require an sg allocation that needs more than a page of data.
  */
-#define NVME_MAX_KB_SZ	8192
+#define NVME_MAX_KB_SZ	8192u
 #define NVME_MAX_SEGS	128
 #define NVME_MAX_NR_ALLOCATIONS	5
 
@@ -2957,8 +2957,9 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
 	 */
-	dev->ctrl.max_hw_sectors = min_t(u32,
-		NVME_MAX_KB_SZ << 1, dma_opt_mapping_size(&pdev->dev) >> 9);
+	dev->ctrl.max_hw_sectors = min3(NVME_MAX_KB_SZ << 1,
+					dma_opt_mapping_size(&pdev->dev) >> 9,
+					dma_max_mapping_size(&pdev->dev) >> 9);
 	dev->ctrl.max_segments = NVME_MAX_SEGS;
 
 	/*
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 946bd56f0ac53..0e6c6c25d154f 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -405,4 +405,5 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.get_sgtable = dma_common_get_sgtable,
 	.alloc_pages = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
+	.max_mapping_size = swiotlb_max_mapping_size,
 };
--
