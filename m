Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739E547CA9D
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 12:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791981046; cv=fail; b=X9k3C7AHMIHmhK1eNJhz3i+tAEHzpCjRliYhPIwtTsfnocKpMbSA4kXPq9T93H5EMZZQuPwlQPZpaRavSfeta2561rQqIvhsquDnPFwlb0kd+gNevSFPnoumvlVHuUxcgAwNRVEbd2R+Smvub1twJPCJUlfzWYg+Yn6+qzSAi58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791981046; c=relaxed/simple;
	bh=6TiPr3hPhijSRMQGw/HDBez1iAqtRSfrOJXZ8zQpTac=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dKT8iEygxSDu2SOVJKOTtUfXdHepvhGYl086i/MUJmdKETtTSaaNb35iK/Z7k8sPGTbAxAVTgU29rhjDGLd9TDBVGVinuhp9LTa1DEpRzv4F4jhBNo/GF1KlnnaPGnf3pWEHfRkc2c2Z3Em9qBkFvWydHS00OHst3vBWyI7V2a8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kFNZ+bIu; arc=fail smtp.client-ip=52.101.48.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kFNZ+bIu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SnRP79ac7EmRT67Zcoi8KDr1xga6/2mwhRYBQq0DJYYRzrIRtXkwZF2Vgo9JAynV9AFbIoU3hOxMiCYl9WDWweWO3nigU1WcXVmn8xDziY09NNy+a2aru2IjeIGItg2Q23gvBJd5tmWu5wcwsXp3LzuWsa/o/eq7Deq+U9/uho6Z94PMlZ7JJX8DpjNtMISElFGX//W1ahdcJj03TyUbeoTrFOPqmbzTmdI1kaeeqGP0GgeU2qrhFXs4cfwKkcXxyBu/QOaEnGZ/1JjlvXVkRly0e0pPV6NFlxz9EFJl+/r/+C5sTqi9+s8JGwnPTpU1c455+P0F9897K7DuKAYr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEovVH5ZLepGig/vSz/09do6NCtXVGpKP5VbxB1APP4=;
 b=o132EQmgxkpcSWkiHcaXB23xLQlRRfgmkVGRbvtvMHjxqOw2aZRa6J9qHW1IxDZBPYDCzpsTEsOZfAVlwT7t6P4NvsyqUn14cEgjF2PutyVV8wr1zkzT4k5RrRT29cANRRXnxljKNyNwPL954wxRlYN6lRuwasLKdoZTuxsdpik2BxvfVBsdo9qeIzybuCiX8hKutkBo+BHmuQ7+dCNsGATNEn/pjaetRMqPlbCJBNj3owVjNrLB290RZwle6pB8SHFuorskfnDJWE5QXm52TPIEGE0/Wyt9nhIFOqfJ06NsMmAVESUiKv64zyYm5IxG9xyYemBkDzXrNzLDMnhlvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEovVH5ZLepGig/vSz/09do6NCtXVGpKP5VbxB1APP4=;
 b=kFNZ+bIu+I18j7UZ+PFqQT1h+QI3KMXfALfLa9UoxV4dYRcUMkqUDFuUrgeViA1IzhFE/xyS1a5X/xtFo/6GC2PD9s+HSOGN/DBnQ72603yAcWP7MDe8Pd5BnntAK2AtWqzGFxJHbvtxeecLU+vFB+lwYaOdY3i/5zC6DKllZqg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8658.namprd12.prod.outlook.com (2603:10b6:610:175::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 12:30:40 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 12:30:40 +0000
Message-ID: <b461d367-8965-4798-b7ac-cffd4301cd1b@amd.com>
Date: Wed, 14 Oct 2026 14:30:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/13] dma-buf: introduce initial file I/O
 infrastructure
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, dm-devel@lists.linux.dev
References: <cover.1791975048.git.asml.silence@gmail.com>
 <49e24334953262e85d5616c9afde88c680e4f3a3.1791975048.git.asml.silence@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <49e24334953262e85d5616c9afde88c680e4f3a3.1791975048.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::6) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b3f1500-fd4d-4ca3-64bc-08df29eef531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|261009223027099003|56012099006|4143699003|11063799006|261009221227099003|18002099003|22082099003|6133799003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	+s29Yh0ZKLDd/KlvThiFZ7UAjNZqbqTiMrFgYzzjP2pVWO0sGO81o+CTcOeNQQ1FfuOR5F+pz08tZ/tcuIzGPxoJ2T+eKwPYm3KxthPd13YJJHyPbipGcyCnZC0Uo8n0Q1MWAWnlXRyfcGnUrF7kdj2LQwNlIXhNaZylurLxyRhyRDQXNivNdjMUka1cYVIapWlGFFPyTh4nZgp3pK1w6fCL6SDdzq/Pj8m4iowrngnnT2ptBovt25Wttbr/WB7ngsMcDY5SmIRzXNNli0hmsT1GyoYU0bA1I83Liy3HmEFqz+n/aGHvGq6C5vk9qmo/EVwTaf0wgelshIj77jdbUNWQS/aJoqkNo746h5qcV9JAzxUji6z9mU6DVkPblsfbvgC7v8a043M99x8aAL2dOjUrik5+7xA1YBoKRgS86fMtdxnyMDxER914A8MXBAwYCOUz6HUrnkaUmTDIFso2+ykfeo0ENtsvyCCGON4h5SKn4vDR8GI0rk88IGz6O7Ax6Afhixd2Dkd59joT681hWBAlbKaDXsfZbHKdF7CNJq6B6794Kkjny40XQJ64VRCARYa09EcJmEoeckcYb+cXSjdK4pskBe10qx6UrwMqR8lsSWlI+dd4+uiCVJVkVK0htQAbdL7C2FgmIXUoJiWSKafDnjpiaWqEhw1SQGz4hfY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(261009223027099003)(56012099006)(4143699003)(11063799006)(261009221227099003)(18002099003)(22082099003)(6133799003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUszNXluS3J5WEN1L3FMY2Z5aThIYnpuWGZHbTlKeDhLUFZmQVZ3eEJOajUz?=
 =?utf-8?B?YVFsMGVHMld2SWQ3Y3lmSmpkK29hVDR5bVVyT2s0am9Ia1ZlNFJJYnoyVDA1?=
 =?utf-8?B?azVETVljUDA0Vmgxc2dRNlgzanJnZ01yanZpM2k0WXY2T2ozd2padkxlSWJL?=
 =?utf-8?B?SThlTERpTmdEaXk5eUphSlZROHo2MHpDbUpUNkpWN21KWU9WaW02SDdqMGRa?=
 =?utf-8?B?ZktOVUdsQ0tiZW95TGVaR1dXcU5SaDF2VjBIQUQ1dWc4WkpqdGhsK1c2Uys0?=
 =?utf-8?B?YVNmQ1hVTC9XaGNaWWhQUWw4Z240SkxSR3YvSGpXRFIwZzFhbDI4MU5QeFJD?=
 =?utf-8?B?d2JQazBWdysrY0hPSFQ1WCtFQmRXdEdYTVR0emdLYkE3VVBPYTF2T0hmSndj?=
 =?utf-8?B?RGxZMVhVMDJGd0I1SWE2bTBZVmc1emRPM05BZm5XRWZpNCtRejJnN2pwWmFV?=
 =?utf-8?B?ZU9HZW1HZnVUY0duVjFoanE5NlQ0Zy9OaWNYcElTejFJcXFtbzJvanhmWExx?=
 =?utf-8?B?NVBuMWo5empzTmduNkN6ZW00SlZyM1NLWW9US0lIMTlsdjNYdzIzNVNVcWpG?=
 =?utf-8?B?blpmQ042VCt2TGI4ZFJ1ckUzTUIrZWdUbzNNZkRlcWxud0ZwNG0weXRvSWp3?=
 =?utf-8?B?MTFnYlFRTWRoUG5EQlBRVmdwRHBHZUQrMTdyWFFkalN2K0FIMHowYUxreDFo?=
 =?utf-8?B?dXRBYytralc3eHhQTGlHY3BySmJnSFY5MVFyRHRmSFRtdWwyWjl5ZmV5S0Np?=
 =?utf-8?B?Z3F2TkVQR0hrOUxoT1ZhdVdPaXJ5U2s2YVltM2l5M0pVcHprTENhMi9pQ1B4?=
 =?utf-8?B?K0lPcWN0YmltM0ZqcDlHSEdCNmtETERVSkNmYUFWWWZSY1Y5aEZ4WG95ZUFr?=
 =?utf-8?B?Z1plWFZ4a0NNbUVuR0tXbVZkbzlqM0hoUzdVVUJJbldZYmUxK0h6QUtlL3N4?=
 =?utf-8?B?Z2ZrL1pmVDI1UXZUNEs5WUJ2Y2xTZ0gvcklIWXQvNFpCb250S3l3cm1icHRI?=
 =?utf-8?B?WG9NSUd6cXljeFgvL1hDSno5Vml0ZUZzUWtDUlhqelZBdC9XUUZLZGJ4ejdW?=
 =?utf-8?B?Y1NHVm1nNFRiczR6ZnIwMnFWZ2dEcFdlb3J2NmtoeUxNdVVJSEVZTkNlS2o1?=
 =?utf-8?B?TzdTZGRMUlJSZUZKaHl6YVM5WXR4UXRyRlVxNGMwN3FYTFZscytzTEVCNFh5?=
 =?utf-8?B?OStiY0FHYUFVaHRlcGlkVk1iZXZaeWRibkRuQ2NFbnVReFdCNWxsbXRSNVkr?=
 =?utf-8?B?Yll4eWdPbVk3NjloRzJJaHVmN2VwU0NEUEh5b1lKdWkyUmQrOG9UV2JHeHZB?=
 =?utf-8?B?WDYvNGJYZEYyWGJFRXNYaWpLdFNFN3RGYUZuUFBqOGxIUU13cVl1YkZDcjJi?=
 =?utf-8?B?bmhlM21Fcm8xRXBFdnlBdkpYRWh5UWxSQlRNbGU5ZlVhb0d3dEhtaXZGaGNi?=
 =?utf-8?B?TVlWNVFYcXgzcGc4VXBYY1dKeFlUanBGVTJtbWxmQmtFb0hlTXJIUTV6Nm5j?=
 =?utf-8?B?Q1djSkJ2d0hlR0ltWExTeS9uV2l0UGhrek5PL21zbXQwY3lESGdFbDJHQ3BF?=
 =?utf-8?B?NmtSd1dEVCtZNFdGbFFISzZ6b2JUQmdkUUt5QVNGYnVYTVIxUUpFSjZ5eVR4?=
 =?utf-8?B?SmtuMWdlRlI3b0xNMXRUcDE0bitRT3g2Sy84Yzg4TDk3enNyand0RjVoQzdq?=
 =?utf-8?B?c091ai8yUjZLZ0VCWSsvUkpKeEJXU2JPS3dPa09tWWdNaGcwVkVrSXIvTHpS?=
 =?utf-8?B?NEJ2V1phRW4zVTRQZ0ttK2xwMDluYVp3aVN6UG1qVEtCeFROcW9mSTZKa1Q4?=
 =?utf-8?B?cnNIaWFaL1RWV0VFSzAyWlZQRDZ3N3Fid1ZpYUx4WGhTa3FrTUFJSFFqQkxT?=
 =?utf-8?B?ZVlBT0FyMmVCN1RZeUYxZ1VxNzhtbTh3ekVYNldmbU4rTHdPSm1LbTdVME1T?=
 =?utf-8?B?VVdmVWJqMEhaN1ZSQzcvMUtaclZLakFBcktnZUo4NE83dVc4WXFJN0V2UHpu?=
 =?utf-8?B?QlBUaUk3NFg2ODFGaElhNHdkUzZESEN1T1pQNklqTEVtUDZOdGtoeTBMTDZx?=
 =?utf-8?B?cmZMRXlTNmxSTHpCVU9VYXhFeU1MOGpIWWN2L0RLWlNobXpRSEhHbnNHTTJm?=
 =?utf-8?B?eld3K3BCdWJ0UnhBSWhaR1pVem9EU2FUZDBTUkM1S2tXMGRvRERFck5nM1c5?=
 =?utf-8?B?bk5xWDY3UExlb21yZFpQdjZCVWhPQndTN0FWMkxxUGppSm5EVWFJMnBiZmNV?=
 =?utf-8?B?RGRQMVAvY0E1SEpIVWI3QSsxL2ZIaGZHcGl4WnRDNzhiYjR4ZU91WEFrd3Bs?=
 =?utf-8?Q?XFi1bSEEQnYMWUiW2h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3f1500-fd4d-4ca3-64bc-08df29eef531
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:30:40.6540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6wUKt8i9m+V254PAqWLiD3vo6ZRCUdxRhSyCRI6G5mczwtHgyk8Fb0M8nWi/csa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8658

On 10/14/26 13:01, Pavel Begunkov wrote:
> The goal is to be able to natively use dma-buf in the read-write / IO
> path. This patch adds basic building blocks serving as a glue and API
> between drivers and upper layer subsystems providing the uAPI. Later
> patches implement it for NVMe raw block devices and expose it to the
> user space via io_uring.
> 
> There are two main objects. struct dma_buf_io_ctx and struct
> dma_buf_io_map. The ctx is used during initial registration and serves
> as an interface between the upper layer user like io_uring and to the
> importer subsystem / driver. The map represents the actual dma map
> established for the target device[s] with dma_buf_map_attachment() and
> stored in a device specific format. The context is created via a new
> file operation ->init_dma_buf_io_ctx.
> 
> The ctx-map separation exists to facilitate map invalidation (see
> dma_buf_io_invalidate_mappings()). A ctx can create
> multiple maps during its lifetime, but there can only be no more than
> one (active) map attached to it. Invalidation drops the active map
> if present, and any new I/O request will try to create a new one.
> 
> The primary task of dma_buf_io_map is to count requests using it
> and wait for their completion when we want to destroy the DMA map.
> 
> [un]mapping and any work with dma addresses is delegated to the
> importer driver via an ops table stored in the ctx, see struct
> dma_buf_io_ops. Only the target driver / subsystem knows about devices
> it wants to use the dma-buf with, especially in case of multi-device
> filesystems or stacking in the future.
> 
> Acked-by: Matthew Brost <matthew.brost@intel.com>
> Tested-by: Matthew Brost <matthew.brost@intel.com>
> Acked-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/dma-buf/Makefile     |   2 +-
>  drivers/dma-buf/dma-buf-io.c | 229 +++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf-io.h   | 125 +++++++++++++++++++
>  include/linux/fs.h           |   2 +
>  4 files changed, 357 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/dma-buf/dma-buf-io.c
>  create mode 100644 include/linux/dma-buf-io.h
> 
> diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
> index b25d7550bacf..523731b0f83e 100644
> --- a/drivers/dma-buf/Makefile
> +++ b/drivers/dma-buf/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
> -	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
> +	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o dma-buf-io.o
>  obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
>  obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
>  obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
> diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
> new file mode 100644
> index 000000000000..21296bd3dde1
> --- /dev/null
> +++ b/drivers/dma-buf/dma-buf-io.c
> @@ -0,0 +1,229 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common infrastructure for supporing dma-buf in the I/O path.
> + *
> + * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
> + */
> +#include <linux/dma-buf-io.h>
> +#include <linux/dma-resv.h>
> +
> +static void dma_buf_io_map_release(struct dma_buf_io_map *map)
> +{
> +	struct dma_buf_io_ctx *ctx = map->ctx;
> +
> +	dma_resv_assert_held(ctx->dmabuf->resv);
> +
> +	percpu_ref_exit(&map->refs);
> +	ctx->dev_ops->unmap(ctx, map);
> +}
> +
> +static void dma_buf_io_map_refs_cb(struct percpu_ref *ref)
> +{
> +	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
> +
> +	complete(&map->drained);
> +}
> +
> +static void dma_buf_io_kill_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf_io_map *map;
> +
> +	dma_resv_assert_held(ctx->dmabuf->resv);
> +
> +	map = rcu_dereference_protected(ctx->map,
> +				dma_resv_held(ctx->dmabuf->resv));
> +	if (!map)
> +		return;
> +
> +	rcu_assign_pointer(ctx->map, NULL);
> +	percpu_ref_kill(&map->refs);
> +	/* make sure the map is not visible via ctx->map */
> +	synchronize_rcu_expedited();
> +	wait_for_completion(&map->drained);
> +	dma_buf_io_map_release(map);
> +}
> +
> +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map,
> +			struct sg_table *sgt)

You somehow forgotten the kerneldoc I asked for here.

Apart from that still looks good, but I had only time to skim over it.

Regards,
Christian.

> +{
> +	unsigned seg_shift = ~0U;
> +	struct scatterlist *sg;
> +	unsigned long tmp;
> +	int ret;
> +
> +	for_each_sgtable_dma_sg(sgt, sg, tmp)
> +		seg_shift = min(seg_shift, __ffs(sg_dma_len(sg)));
> +
> +	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_cb, 0, GFP_KERNEL);
> +	if (ret)
> +		return ret;
> +	init_completion(&map->drained);
> +	map->min_seg_shift = seg_shift;
> +	map->ctx = ctx;
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
> +
> +static struct dma_buf_io_map *__dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	struct dma_buf_io_map *map;
> +	long ret;
> +
> +	dma_resv_assert_held(dmabuf->resv);
> +
> +	if (ctx->is_dead)
> +		return ERR_PTR(-ENOENT);
> +
> +	map = __dma_buf_io_get_map(ctx);
> +	if (map)
> +		return map;
> +
> +	map = ctx->dev_ops->map(ctx);
> +	if (IS_ERR(map))
> +		return map;
> +
> +	if (WARN_ON_ONCE(!map->min_seg_shift))
> +		return ERR_PTR(-EFAULT);
> +
> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				    true, MAX_SCHEDULE_TIMEOUT);
> +	if (ret <= 0) {
> +		if (!ret)
> +			ret = -EAGAIN;
> +		dma_buf_io_map_release(map);
> +		return ERR_PTR(ret);
> +	}
> +
> +	/* get a reference for the caller */
> +	percpu_ref_get(&map->refs);
> +	rcu_assign_pointer(ctx->map, map);
> +	return map;
> +}
> +
> +/**
> + * dma_buf_io_create_map - Create a new or reference an existing map.
> + * @ctx:	[in]	dma-buf I/O context
> + *
> + * A slow path part of dma_buf_io_get_map() and shouldn't be used directly.
> + * Behaves in the same way but allowed to block.
> + *
> + * Returns a map on success, or ERR_PTR encoded errno otherwise.
> + */
> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf_io_map *map;
> +	int ret;
> +
> +	ret = dma_resv_lock_interruptible(ctx->dmabuf->resv, NULL);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	map = __dma_buf_io_create_map(ctx);
> +	dma_resv_unlock(ctx->dmabuf->resv);
> +	return map;
> +}
> +
> +static void dma_buf_io_ctx_shutdown(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_resv_lock(ctx->dmabuf->resv, NULL);
> +	ctx->is_dead = true;
> +	dma_buf_io_kill_map(ctx);
> +	dma_resv_unlock(ctx->dmabuf->resv);
> +}
> +
> +/*
> + * dma_buf_io_ctx_create - create a new dma-buf I/O context for the given file.
> + * @file: 	[in]	file for which the context is created
> + * @dmabuf:	[in]	buffer to create a context from
> + * @dir:	[in]	direction of DMA transfers
> + * @out_ctx	[out]	resulting ctx
> + *
> + * Create a new I/O context from the given DMA buffer for the given file.
> + * It only works with files implementing ->init_dma_buf_io_ctx and fails
> + * with -EOPNOTSUPP otherwise. Once created, the user can create a map
> + * and use it to issue I/O like read / write requests to @file.
> + */
> +int dma_buf_io_ctx_create(struct file *file,
> +			   struct dma_buf *dmabuf,
> +			   enum dma_data_direction dir,
> +			   struct dma_buf_io_ctx **out_ctx)
> +{
> +	struct dma_buf_io_ctx *ctx;
> +	int ret;
> +
> +	if (!file->f_op->init_dma_buf_io_ctx)
> +		return -EOPNOTSUPP;
> +
> +	ctx = kzalloc_obj(*ctx);
> +	if (!ctx)
> +		return -ENOMEM;
> +	ctx->dir = dir;
> +	ctx->dmabuf = dmabuf;
> +	get_dma_buf(dmabuf);
> +
> +	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
> +	if (ret) {
> +		kfree(ctx);
> +		dma_buf_put(dmabuf);
> +		return ret;
> +	}
> +
> +	if (WARN_ON_ONCE(!ctx->dev_ops ||
> +			 !ctx->dev_ops->map ||
> +			 !ctx->dev_ops->unmap ||
> +			 !ctx->dev_ops->release))
> +		return -EINVAL;
> +
> +	*out_ctx = ctx;
> +	return 0;
> +}
> +
> +/**
> + * dma_buf_io_ctx_release - destroy the I/O context
> + * @ctx:	[in]	dma-buf I/O context
> + *
> + * Destroy the context. It makes sure all maps are waited on and destroyed,
> + * and can block for I/O to complete. It detaches from the importer and
> + * destroys all its resources via the ->release callback, and frees the
> + * context.
> + */
> +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_ctx_shutdown(ctx);
> +
> +	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
> +		return;
> +
> +	ctx->dev_ops->release(ctx);
> +	dma_buf_put(ctx->dmabuf);
> +	kfree(ctx);
> +}
> +
> +/**
> + * dma_buf_io_invalidate_mappings - invalidate the current map
> + * @ctx: 	[in]	dma-buf I/O context
> + *
> + * Importer's helper for invalidating the current map. Waits for all I/O
> + * using the map to complete and destroyes the map. Called with the
> + * dma-buf reservation lock held.
> + */
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_kill_map(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
> +
> +/**
> + * dma_buf_io_detach - detach the @ctx from the importer.
> + * @ctx:	[in]	dma-buf I/O context
> + *
> + * Importer's helper for removing the I/O ctx. It kills all maps and
> + * prevents creation of new ones. Upon return it's safe for the importer
> + * to release all its resources such as dma-buf attachments.
> + */
> +void dma_buf_io_detach(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_ctx_shutdown(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_detach, "DMA_BUF");
> diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> new file mode 100644
> index 000000000000..b9bbeca1744f
> --- /dev/null
> +++ b/include/linux/dma-buf-io.h
> @@ -0,0 +1,125 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __DMA_BUF_IO_H__
> +#define __DMA_BUF_IO_H__
> +
> +#include <linux/dma-buf.h>
> +
> +struct dma_buf_io_ctx;
> +struct dma_buf_io_map;
> +
> +struct dma_buf_io_ops {
> +	/*
> +	 * Create a new map for the given ctx. Called with the reservation
> +	 * lock held.
> +	 */
> +	struct dma_buf_io_map *(*map)(struct dma_buf_io_ctx *ctx);
> +
> +	/*
> +	 * Clean up device specific parts of the @map. Called with the
> +	 * reservation lock held.
> +	 */
> +	void (*unmap)(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
> +
> +	/*
> +	 * The user tries to destroy the ctx. Release all device specific
> +	 * parts of the token.
> +	 */
> +	void (*release)(struct dma_buf_io_ctx *);
> +};
> +
> +struct dma_buf_io_map {
> +	/*
> +	 * Counts attached requests and other users. Device specific unmapping
> +	 * is deferred until all refs are dropped.
> +	 */
> +	struct percpu_ref		refs;
> +	/*
> +	 * Shift for the minimum segment size of the mapping.
> +	 */
> +	unsigned			min_seg_shift;
> +
> +	struct dma_buf_io_ctx		*ctx;
> +	struct completion		drained;
> +};
> +
> +struct dma_buf_io_ctx {
> +	struct dma_buf_io_map __rcu		*map;
> +	struct dma_buf				*dmabuf;
> +	enum dma_data_direction			dir;
> +	bool					is_dead;
> +
> +	void					*dev_priv;
> +	const struct dma_buf_io_ops		*dev_ops;
> +};
> +
> +int dma_buf_io_ctx_create(struct file *file,
> +			   struct dma_buf *dmabuf,
> +			   enum dma_data_direction dir,
> +			   struct dma_buf_io_ctx **ctx);
> +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx);
> +
> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx);
> +
> +static inline struct dma_buf_io_map *
> +__dma_buf_io_get_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf_io_map *map;
> +
> +	guard(rcu)();
> +
> +	map = rcu_dereference(ctx->map);
> +	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
> +		return NULL;
> +
> +	return map;
> +}
> +
> +/**
> + * dma_buf_io_get_map - Create a new or reference an existing map.
> + * @ctx:	[in]	dma-buf I/O context
> + * @nowait:	[in]	specifies whether it's allowed to block
> + *
> + * Create a new or acquire an existing map. When succeeds, it returns
> + * a referenced map, which should eventually be put down with
> + * dma_buf_io_map_drop(). If @nowait is set and the function would block,
> + * it return -EAGAIN, and the caller is expected to retry from a context
> + * where blocking is allowed.
> + *
> + * Returns a map on success, or ERR_PTR encoded errno otherwise.
> + */
> +static inline struct dma_buf_io_map *
> +dma_buf_io_get_map(struct dma_buf_io_ctx *ctx, bool nowait)
> +{
> +	struct dma_buf_io_map *map;
> +
> +	map = __dma_buf_io_get_map(ctx);
> +	if (likely(map))
> +		return map;
> +
> +	if (nowait)
> +		return ERR_PTR(-EAGAIN);
> +	return dma_buf_io_create_map(ctx);
> +}
> +
> +/**
> + * dma_buf_io_map_drop - Drop the map.
> + * @map:	[in]	dma-buf I/O map
> + *
> + * Put down a reference for the @map acquired via dma_buf_io_get_map().
> + * Should be called as soon as I/O is completed.
> + */
> +static inline void dma_buf_io_map_drop(struct dma_buf_io_map *map)
> +{
> +	percpu_ref_put(&map->refs);
> +}
> +
> +/*
> + * Device API
> + */
> +
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx);
> +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map,
> +			struct sg_table *sgt);
> +void dma_buf_io_detach(struct dma_buf_io_ctx *ctx);
> +
> +#endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f9d1e05e8ae6..05c1ff495732 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1914,6 +1914,7 @@ struct dir_context {
>  #define COPY_FILE_SPLICE		(1 << 0)
>  
>  struct io_uring_cmd;
> +struct dma_buf_io_ctx;
>  struct offset_ctx;
>  
>  struct file_operations {
> @@ -1960,6 +1961,7 @@ struct file_operations {
>  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  				unsigned int poll_flags);
>  	int (*mmap_prepare)(struct vm_area_desc *);
> +	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
>  } __randomize_layout;
>  
>  /* Supports async buffered reads */

