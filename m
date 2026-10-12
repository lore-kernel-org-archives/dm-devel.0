Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E224968ED
	for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 13:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810532; cv=fail; b=c97Qy1CBmKt5q/1kCBELp1r8zuPxE7ULNVV+CymyYlijlmklF14yZQDR7nCz3nIM2uX62xucMwHwz1R+F9C5655Lw1WcVp0nETeknVPXEkYSpsiusZZ3roEyj8feUiKwue1AOQBurYilKtBlUuEOP5Z6LHxmyLFlS8PqiB1+kW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810532; c=relaxed/simple;
	bh=s9WjurBLSeZ4vgKj/p+2yRIxYTFLNmj+Z9UZEpIdLRs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WjBe9hLNnB6C5Q6DhkY2DUSuMqt37BzTsOyVONgRdMmYV3Dx9Dg/o6ZASzXn7ofy4j39Gja1F3wgiMAjyF9bJNkmzyqA2shubBJE02twDuXArBiO7sl8mAABGiaknogOyXeT+fhwqqDAVLMQbgSS9MOsXBDElsiM1EGuKa916DY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMN0qMtV; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMN0qMtV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791810530; x=1823346530;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=s9WjurBLSeZ4vgKj/p+2yRIxYTFLNmj+Z9UZEpIdLRs=;
  b=mMN0qMtVFaophtTBjB/VZPBdqc1WUc/WkFhouuZ5lnfVPgfht6tczfae
   pWlAwfGiferqOBOGr9Ewfn6+rHUBD5lqUxA5WNzlD9yi+0OqEY3IRDpt0
   TDfzGLEMo4glxPsJWYCMBoK2WAV85rCR4neHBQ9S79t5h4amyCzryftFk
   lna/iGgDU3h0L9gMl+BjUXRX+gTkY2D/eXWqMMdXsd+1p0C8+XQ2UQvfy
   fuC0aX2BthcEG4dnoDEVYmIhNLly6RDm36zr6myVwP9k+eqzUZi/7HO6L
   wuKnIqxvtMISPJrkNuHwM8+IcOicv7h5xKE+19zTqu/rh6mI+FQKJZcA+
   Q==;
X-CSE-ConnectionGUID: 5kMlX7RnTdWMDlih+wIkSQ==
X-CSE-MsgGUID: rlixMzEKQQy1VUXF9c19CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="527697"
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="527697"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 06:08:49 -0700
X-CSE-ConnectionGUID: rTWlvXbCRomcwlerM6LVgA==
X-CSE-MsgGUID: JrGtH9PaQRig2g42AmJRqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="991349"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 06:08:48 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 06:08:48 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 12 Oct 2026 06:08:48 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.46) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 06:08:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zCA/TH+UiqwsAAeMkYMaGd1KcPm2U+RH4pHA2o9DoxPhYZlNkLh4aP7CAaiCLmhvTgpFPuXcbgRuMhafz+E9ZcrIMpx01THuz8pis5lvfG4IXBI9C4I7F/gxymKYkHAGZsGH2nH635ZbtrFfQFrx9YwrkcuN76p/Kwhq9xxyrVHXd/Ac6CJHZLknJrtavB0JlPo0FjVnizOHdglLpN71AQLXg8AXqSHsKQA7icSH7Jp1Qc6q2pI7WhbP5xX34IgqF/2eZ6u7yi03GspZMfdeDk8ipwKrWUiTwCwVi/R2CG33rjG8x3Kh5PIgbk5n1rpfxKcBEB8GYoRtYuSPedtdBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uExqKiCgtpBXttS3eAro1n89/QXnujtULz2DlTEqysI=;
 b=duXvNVnu3LWoo66NlhCzi2Y0GnEk7rDYhu7Cho54ijdG2xsdjvgcPnnd+s+1pygY/mA9Jx8pKiDwJp+7YzyPs9SALE0HF730tz4Fb0vtXYnF+Q8KIJu43yRm3THaOMx/cfxOo4cH4T0Y0SYqmEcdcgmNdpfM8wO4YNeENfdCzRPSJAyNoBmZEGOBQ1SPUOzekBHaWjnenf1s3d46udMBLP+Lz3Rm0Jg+NZLSPF8cxKA6kB5WtSbhm6dCCdCzYv0QLKONtWxXBSF/IfHxew0tuZ1imLcSPo5dEJ//WxQmE1vOyltqgXrNeLB5oDVwJU4nIx57qybnyeW2sxXhHsYZ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by BN9PR11MB5259.namprd11.prod.outlook.com (2603:10b6:408:134::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 13:08:19 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::fec9:8db4:c768:8289]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::fec9:8db4:c768:8289%6]) with mapi id 15.21.0472.016; Mon, 12 Oct 2026
 13:08:19 +0000
Date: Mon, 12 Oct 2026 06:08:15 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, <linux-nvme@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>, "Christoph
 Hellwig" <hch@lst.de>, Sumit Semwal <sumit.semwal@linaro.org>, Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe
	<axboe@kernel.dk>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad
	<tushar.gohad@intel.com>, William Power <william.power@intel.com>, "Alasdair
 Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	<dm-devel@lists.linux.dev>
Subject: Re: [PATCH v9 01/13] dma-buf: introduce initial file I/O
 infrastructure
Message-ID: <aszbv7TgDOPHBEem@gsse-cloud1.jf.intel.com>
References: <cover.1791336930.git.asml.silence@gmail.com>
 <b44df9fed6e346110c504ee312bb0083c7e75574.1791336930.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b44df9fed6e346110c504ee312bb0083c7e75574.1791336930.git.asml.silence@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0070.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::15) To PH0PR11MB4792.namprd11.prod.outlook.com
 (2603:10b6:510:32::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4792:EE_|BN9PR11MB5259:EE_
X-MS-Office365-Filtering-Correlation-Id: 8093d30a-7871-42e2-8923-08df2861e2d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|22082099003|6133799003|261009223027099003|261009221227099003|10067099003;
X-Microsoft-Antispam-Message-Info: gxqc9nFVcWXySQwQq3B1QJ7m3qn1CH8OTDcp3/m1WgsuxchdjUVJpHHs/rJdZ4vCzoeDgoq9+/yI1N8TaZCakuR2y8rBrodKOMx2PHxP66depPtexKoU21hQ2WefoBP9vENHp56TScIVDeakt0Cf6aOmmWZ340BWh8Q9fBt792ud6o/zyvLqn6WRWdkntBy0e/RLHPvVhnO3Ex2IdH5+ufgeJUwaywhN8DIVVX/9siC8/g9nlrP4MpnddSAmrP+pOD99xlc+4v8KsXxRIvvque0ixGIf4svV7vQFDnSp0ja3QqX5eTNTVLngr1ubb5tFlfOctYnLqna1lbc5CaEGFMY9jSprWKJYUsH68SQHEr2GhukND/6DVYXyWE8Vjn7y7b2kjeszafReMhrAzhf5ZCFbC4YLUCT2chz3gE8SrcgDz0P3HmeSE3vSkZOFYDvD9RMwPDBjr/fgya8TllkqLCeb19DH+0E3I3U8kUx22Zx0inuSMza03TsUv6QoniKqGfcztL8ZfViFz+oWOKIUQpg/9DUiNyMu/PV80jY6sCzZJzR3cET6YtAxAnGV6FcuRMxfZjQoGl+An9HE37rSXncSINGdbdFTK76wz4lkUYYOCqk/DcyZ6ztvTv44E8BV6LQMexJN++ZMizp32abITWkmatiAALzVHX5UyD65nkA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003)(261009223027099003)(261009221227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?21R9KoACdfHGQ6K+HehTkAcVXBr/vx7iyB/GGLfTDjdPWgwtdGpzDD+nDZfH?=
 =?us-ascii?Q?g6WmH7ZmTYKFpT2Ho62BJA+JICukmvq2Lm3bW7YCdQSs+b2htJGdZp8aB8Vq?=
 =?us-ascii?Q?6lrZzz1K80dCMKeiyJ579ydIfJV/QE91ebPjVaBPK/Lbf7JLLrs92dod/KBk?=
 =?us-ascii?Q?6KYyKOGY5Jdk4ZzAqkA24WU/JV77Xo5tp3Wl3lIBfxyB/rZ8F2rxT/AD9BkH?=
 =?us-ascii?Q?O5lSwMcXQf8OlG1RMW7Awjz8Ok9FEzVolwXAJv+6d+sxlCw2YZum8skVlUR/?=
 =?us-ascii?Q?FlEcJhlU0oP5yNs673Aqo+3JNdmEHMzDOeeXQYMNLzZXHzxSR0X5nU/D1ETO?=
 =?us-ascii?Q?Jc4sqAq3m826kOG1VbAz1TcWHYbwEyWfjNreTV2NM8ViNu5nddv2TSpm8Qin?=
 =?us-ascii?Q?6fkXORhMESW7CjSwqiu/+GPrn5pv+vDDk4ViZ+Yop6qWLFWQgydWu28S+bVj?=
 =?us-ascii?Q?P3vBYKl9ksl+0aXs9IXw+HgTdbQQYoYWM92xwqY4Nr+WllHRd0jvtfNEyz9O?=
 =?us-ascii?Q?Au78GTy0XyIjY/+0UxUm/Kj+3TOxfU+mo6qPIk6kwwsxf9CHnD+/ue8guYMs?=
 =?us-ascii?Q?rcr+UD6gvY+PTuW7qyY4v/VWqiQ860gujLkepFfyVOxeKT6YAy/4+SR5JjT7?=
 =?us-ascii?Q?Ew2z+jS209AF5ZHh9pV7K7/VcES7q9V31MxCUBJRDriRpV0d5H7CQNBhiCiQ?=
 =?us-ascii?Q?xP0Rcvp5Pra7LU7b7wFnl6gerQBHeZZJrrN3nq3PwDnY8JShuViccAVzeSM/?=
 =?us-ascii?Q?QBIbstm66Nfvk5D91vc+n81D+NytiWpELP5hGGHE5du6GGxBQhcxFZCic8rt?=
 =?us-ascii?Q?fOc/ewuTxNx65W+hisuZJ1TGm5+MLjtbaY1VKTa47SdW+Sm2v4O2NqCs/G6T?=
 =?us-ascii?Q?Re2uzllxNGvwvMSwv/VdWuVk6EGnCBav3zUYrcO01j5GBCsuvufbVA+BTwcz?=
 =?us-ascii?Q?VxAYps1l7/q9cTpzHKyUMGmo/JFedlNSds41WlVW3WcDTJWZ+R6JvxELLxA8?=
 =?us-ascii?Q?MLrKfbVqNXA5hlkoU8UFLliMCdLK46yyRKaBYaDxi72+knyW9SUnJTqQBgxp?=
 =?us-ascii?Q?FwUv3gQXUchxGRP4QeLxerXkY5C3xLZGYUttdUAm+am58Jl86OhuSoEplE57?=
 =?us-ascii?Q?XnEAtHJXDdv1wTZZ7mWLqwD7vL1IUyu5jkGdwXuT/GvhACd49hPUtRkceCXt?=
 =?us-ascii?Q?iRNnjRbJc9zrpt1KdtQFYoVWc5CP68kTQlmuuUZmBesaoaYBZJ8glV6SES1c?=
 =?us-ascii?Q?Eb/8q+BmJqwNar+UBKSgqulrNeQQhLsD5kUKsMKFpCJJHicTVr6hNWS0h/EL?=
 =?us-ascii?Q?JVNi7gdQuSQ507IiftGNQjENNsTJwJvUPE4r10xW8TNbvK0Lg5OSbuwajTWO?=
 =?us-ascii?Q?neUuCN4foHTsSiYit3IByWLEQGhVnk/qi9joFernTMiT0oYjB7bh4sOga8Wp?=
 =?us-ascii?Q?YoA7guw9Qhn1WwmErCpUl7if9eTDL3gyKxQoORK2C8YHfWEediRQjFrGPHhf?=
 =?us-ascii?Q?OTARmTf+VEl901MDtWDlrI/2vuBIrzEKfuw8t5OVRynYP7C7bju5gfc4p8+v?=
 =?us-ascii?Q?INtUCmWXPEl5X3pWF4O9gPgxIp1O6gZ6Qis50Q9OzR+1ShDuYdZCoN+snbkR?=
 =?us-ascii?Q?6eQKsSZO6dPvEBNsiR7vsKa8KGRrDSd5OJRU+xyU/pqgcjFuJqN6UzquXcAu?=
 =?us-ascii?Q?H9RFMRONARAK2hHt7tkTB6EfbBllqpePxtNG2stvSN6yqG55OxVneS+9YEoR?=
 =?us-ascii?Q?811HtUtDdQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: DPyKZCyFiL+Pxh5xLe54ks+3GeS8taqEz8sIqp/95P78aRo3b8G94BMHBb928xLGtCm3nGK1RiGn/pCausj9CVGlpv7KDaGFIcoDpQC7jvxQLqC2UUtE8zbaWGhzlipWuj+zls1Ya5oJ5dPVHz9neCebVtx81C1tm4fZCUGUVwCrNTVUCzEhg0Ng+kmgJf9jjIOUIqWzT7mgf9fcosQ6MuRjfhozl7t7xK6+EDI7kuulLiIX3qV+sEvZx8hjidaPq1Nuh0YOLBMJnXe6uaBwolu0KZarMRWuTHSIzsSmMNnx4GfYq7stiDp3AlWF7aIc3bmmKnYqWBFjMwlYZ2XXqw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8093d30a-7871-42e2-8923-08df2861e2d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 13:08:19.4589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upp+7BhRin6/K27iLCHNmDehiIkBDSzt1nXHvxUwaBO6HkCm9fJUpIn7XMi9FsMJLSiaLYWPhmw2HIep/ZrShw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5259
X-OriginatorOrg: intel.com

On Wed, Oct 07, 2026 at 02:42:44AM +0100, Pavel Begunkov wrote:
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

Full disclosure Pavel incorporated some of my ideas wrt to locking
cleanup which I shared off the list.

So I can't in fairness give an RB but:
Acked-by: Matthew Brost <matthew.brost@intel.com>

For the series - I can give this and I have pulled to code + have Xe
nvme + IGT setup showing this working:

Tested-by: Matthew Brost <matthew.brost@intel.com>

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/dma-buf/Makefile     |   2 +-
>  drivers/dma-buf/dma-buf-io.c | 183 +++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf-io.h   | 105 ++++++++++++++++++++
>  include/linux/fs.h           |   2 +
>  4 files changed, 291 insertions(+), 1 deletion(-)
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
> index 000000000000..9ba9c17f900a
> --- /dev/null
> +++ b/drivers/dma-buf/dma-buf-io.c
> @@ -0,0 +1,183 @@
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
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_kill_map(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
> +
> +void dma_buf_io_detach(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_ctx_shutdown(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_detach, "DMA_BUF");
> diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> new file mode 100644
> index 000000000000..8ac338df51ff
> --- /dev/null
> +++ b/include/linux/dma-buf-io.h
> @@ -0,0 +1,105 @@
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
> -- 
> 2.54.0
> 
