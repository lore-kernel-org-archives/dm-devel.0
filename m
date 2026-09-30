Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106EB2F8EAE
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 03:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790737272; cv=fail; b=QO2DkKpPsW/Sp7HOCR7gtZQPrVIqVG4vI+mlRVUkRbTUxbtZgbldvkxbq//fuEfrghttd9sRKrSs9o4UR26c2PvBtrQ84dP1mFnKFcMxZHFN39m+hjJD5jA498ooNTznTCoY21HC/Ja2c0FopPNFxPaBG6Sus5aaT57dBDQEiC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790737272; c=relaxed/simple;
	bh=T+LxAxlz/OagPXyWUGcNCK3jOcv0QGJs1dpP3kz661E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N3qnQUa4eAi9RCSUiHUfXrufrAxoEwwwZguRdY6JZEW2Bh1mMrwijScwBlP0edZgVZTzhBXOK7ihS7qxu4Yrh/wruYG2sBCmEBul/2eXad5zBGNdzdW0EM7vxc4NXiZrv6kNtOd0FxSWBCHRubaYPzmErt8UhHqtQvG+MDu6gek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoqXixjk; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoqXixjk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790737269; x=1822273269;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T+LxAxlz/OagPXyWUGcNCK3jOcv0QGJs1dpP3kz661E=;
  b=PoqXixjkKQ6ikI4IM4ZYL9cVPwVElma5WHF7ao88Kx57pbBdJQnp2jaz
   3M+VvKVyDgpN/1UhAXsKXKDx9xqiEVaHREVIS02z+hWIvF39pyFsQ00S9
   OQ/zSXztR1WAoMlHjoCUIOsdBL2jje0bGrkuc/Ol+CmRBICCWN7x+dpcQ
   uwdpCBeo1tz8wCBy3xdyLqnnd9wmedBwUB/PBVb2fDj70VrFnSoe1aYX7
   XBft6jATbRi/b+WHLMtuNsTtpMKbU5BPH5BVlyrPexs3gr16pNLeEaQJN
   TfbdGZ0CiGjMgiy7d/7bKTtirbaVFoJmbwok6cIIjhchLO5Qf2pxGMcH6
   Q==;
X-CSE-ConnectionGUID: se5ZbfHfQeyLcdpDYvt/0Q==
X-CSE-MsgGUID: O1ChLAKYQ/+7QFvVxKC3mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="113251367"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="113251367"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 20:01:08 -0700
X-CSE-ConnectionGUID: 90ZpLuj3QEaxPqBLOJWdVA==
X-CSE-MsgGUID: rT/Rm3mQT8SP1cTCKZ5PRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="313503512"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 20:01:08 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 20:01:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 29 Sep 2026 20:01:07 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.33) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 20:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lKf2v2b1fh9s4oGMk5kr9kdJZ/lP7XuQCsXQwWNkTKW3z2mOErOWskBrjBYlz+6snapFRaXPkksqQ9YaXOg+1hBs1nYrTmMya2flEmLLu9QkWJYWXwSMzPDIZoknJDOHhbci86CIsdu1kGpTh5sQYLPuI7vPW+E/eIckg7xWykezpUsVPx/kxgya4Fy6gGMj9gy+5RbLIntNNjN7CrqdetHk5hozNTVVZtv4eLIhgKx9mpRorZMdUb7wjkxBnRdd16eBanCNlmQ72Qj8yZ5L6Ye18sZwwmw7kGlM47rzF7ScMdNgUad/+ZPs7owRtMBfKqwnPeGRSYmPI+pxqpU9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVcDh0j3mwcdHOKjik8JLRjVpAlLlBrcFV38Etm9kPY=;
 b=pf6DoPPTrWsTBHcSmLEpOmdkLHIbSNBozJ6IJfmbXOlzWUvjT49I5qQBP2NY3R8/uSYW4ifyB/uG8nunrhG/mVuDNDKUcrLTt+6MilWO59z9b5FlwSrr1NNhcHoaGHPlSakDACd25pMevGMJ2D9OyVc3cy/bZHv0FcVKoUxiMim+2Bt0xBmXClxqWvyJdYTSUTcVJBxHybfu12qw0Sh6nZW+lEV09VTtTYKX9uPM5Zp9iBDvw94p+lMxQPZuZPHkT4c77FI8gKgVq4kEtfmqTUS3gs6US4FFtPEEQTpiM66AIodwmyCWepoLSmhq3jnrBWuBuNM2Zts5omVhtS+oew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:95::23)
 by CY8PR11MB7267.namprd11.prod.outlook.com (2603:10b6:930:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 03:00:57 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::e7eb:a872:53d1:21fd]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::e7eb:a872:53d1:21fd%4]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 03:00:57 +0000
Date: Tue, 29 Sep 2026 20:00:53 -0700
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
	<tushar.gohad@intel.com>, William Power <william.power@intel.com>, "Phil
 Cayton" <phil.cayton@intel.com>, Alasdair Kergon <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	"Benjamin Marzinski" <bmarzins@redhat.com>, <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v6 01/13] dma-buf: introduce initial file I/O
 infrastructure
Message-ID: <arx7ZQ8o9aeHsAqS@gsse-cloud1.jf.intel.com>
References: <cover.1789997898.git.asml.silence@gmail.com>
 <5490ee42c4452fd4198b245ead20fcf7438c066e.1789997898.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5490ee42c4452fd4198b245ead20fcf7438c066e.1789997898.git.asml.silence@gmail.com>
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:95::23)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4787:EE_|CY8PR11MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea7fa84-ffcf-4bda-e921-08df1e9f0c64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: mjbYyzAPaT8M9XQdBlNpmzPpIF22EP8ADzhAUmOdeEbSGnGbMqpr32RtivoX4DvX4+5XF0KSn/SghqPUoev4SDY/nlF7kksKFrE+oHIUHF1LcWpCqtpEVJFTjCTdnwZVHJ61r2bXm3OKjUKQmHrO2Gyy04ZIVr87it5Lut+/UPtNITY/Z6wdeWDErq1lEBR20YksQxLdPdcM6ACn+rqL4oJXvumvn5BTKoZvaThmZC3bMUzWN0ZGDRlhxxbUM+fycIS95aWvTeP9zbJCjJudMZQE5h/HINu4CL0oiUHBcUabhne22vVzAzknsdAFjq0+1N05yYcLDdvMZbM/AYEwzRhAXy7fMHgRNcVXN/AiOpWSlocqdXIYrLxKvwxrdSUdOi3nSXRCRUFWGhJdyK4u2hjIRHVyNfY81T6d2rwqdiki0EKpc0bpD2cKAACxGHdOpV03UcccJNpUlAp5buA43fEkDbGWaMffD8WheZMaYuXLq6m8bz23mHYe3g9RxHsVBsUsxKVmyCeET/20Yx3oqFSikHmY+8k/dkJYX2VYV0zIghgo4u/tm0f+Vwbc3NCDyOIE3StM7NfskbavcQzaPhADmbzwUfC2Ger+OmogbOrevVvKr/PhmZJwmj7+WStLK9ox/LegsVL++RPLwqsEa+iXeLlPOfT1Vho5kZusyog=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ok6RsDoH8LcC7yteCR6erDPlSReiQjbaCUDeCi+ZnG7CWy4KXHwcic9F9GyV?=
 =?us-ascii?Q?2AcsrKtucSbhMGDT+Qc3d2Ne3XwW+drm4m+2qIBHaibv96iLV80EwZBSiT48?=
 =?us-ascii?Q?lioFnZGPvDh2+2K+cOLq9rj9Lv+EqeDRgsLBmE3hqIXeQK8KWYVvHYFOvh4Q?=
 =?us-ascii?Q?9yLwUP8Rwjx6+4/g9qy5Lknf/sD63vvB5zs9ekf7x2IGgXnl0PXzKbySjWL/?=
 =?us-ascii?Q?Koeia1+UZvvjDURcWZnb4P00j9PrgOmdHlpvTXUY74tun2WAsj98E1zUbq3K?=
 =?us-ascii?Q?T9gNEIVFNJgrSQgSJZbNDHPZ9rpwkUdVQ0bN70+4XKHxYOELsr3EjaNQXQ6X?=
 =?us-ascii?Q?X+rBLuAi57AbfOdOLCsb4Qf9wHUFDQG4OOp8RmGCxvH4QAfRVQLDNcBAgQ9M?=
 =?us-ascii?Q?8Pc2Kebv1Fb4uaYNB50jUHNGjmOhe2A39cUvzAHg5MqIxcL2KtX9ZjvJ2Fyt?=
 =?us-ascii?Q?L7Bq06caMeQVc1Q5QprlqdqvDxgVh4Arj1ry8avGgM6kDEq8nc89whYPjQd0?=
 =?us-ascii?Q?FKQSiwlbDTRalHfifys4FKpEVQgEtSRN1PJKhBI9UfEtrsM/QzSE3NSNR0BK?=
 =?us-ascii?Q?WvDJRdhniAP8ZWK8x2Jyo4aqo08z6vxmPEDaARB13VwRywtUNojAYVWqZRkU?=
 =?us-ascii?Q?hCW+YHcRwaQTgoSyYyW/2nCvQbgDRmgnYAHeGLazviPCv2STjaZOKKC88TA4?=
 =?us-ascii?Q?8aOFJaqKWq7gsU37+VG43hlHlP3NC1SKURQNVhCPNSkKsjS3j58Ohxx8dfj8?=
 =?us-ascii?Q?t4FNEAjIbA9Edd024KiqICzvQcNQeVE28Hs6ZrPWs3iK6kItr2xyt6jYwRMl?=
 =?us-ascii?Q?oWkIWqjIz6fg6pC4xIGjyQXn3bAevMP8aE5Z5t92npgu9JC57kZotRvBtXfE?=
 =?us-ascii?Q?d8GBDGlj9YZ9Tws5bEuN/4rX7aqfjnkz0guZaPIcrg2zr/r9C6OVG2HLMbtT?=
 =?us-ascii?Q?NpToctaNID6RLfuZgqV6I+GQov2+csuntNawJEmHurryQ5IA7WzMuiGSoydX?=
 =?us-ascii?Q?55wk+nGoiKoqsTucFQW6SRJFkp5uV/e/QWQH4o9dM9gJhPIcDzayX3f6WmLm?=
 =?us-ascii?Q?4pJMKgNCSeBOpL2qonOrMS/cZnBPBhf9eRFptKrRwI0UZ98XT+7I7cAPtSab?=
 =?us-ascii?Q?rkOcrLg7UYUAEhzI4bKaOJN0k7/EOEUXOb3TunSQ9odI9WdPojesLNGGO+uh?=
 =?us-ascii?Q?DSqcJ4Q70X04jk+pP14/VunH07bgLrtZPPtilZxWIsuWLhbO0XmuODFt4yYT?=
 =?us-ascii?Q?8GrfZdhW+4QP9rNsC/2bqbjIgO14SrW87bTYhZhVNhtaqGs0gAzRNMhkOYta?=
 =?us-ascii?Q?wgBDX6fmRbguLnEDuB7EZ6HV+5VqD+qX/8kW/Kpxzkbre57e6gDNqru8iYeh?=
 =?us-ascii?Q?h9yEW3GPJ9r+U3VqyjyLan3GGdpBjkdWPYJtRq62j5+iLcq7zbVSiJk8MHiQ?=
 =?us-ascii?Q?RNTj45Dhs6bJ4gcK5ZpMnqFpH5p/YoVJWKd3AP+kFiM7hJ4cZXuIoi/X3835?=
 =?us-ascii?Q?0h+o/2rYmkIyWwWanIVXbpuNpJISMiN3DCj1digZNmJO43T3lOuh9BBTLaxP?=
 =?us-ascii?Q?C81jvxOnbidU4OyY0sKwjE3wYLx898carrBcK8MfS17NHqv49oPgdNbWpHLr?=
 =?us-ascii?Q?04g4e8aK3n/qNof3g1WAX5cvUAohOq9oTdBxBGzAlFC3zNPa9qD412wQ1fkq?=
 =?us-ascii?Q?Eq5AlZtvrSCemL91mFFN6+0cWZd06Gl1fs3UQ0MiLb3OQJc2/8THy6Py91eA?=
 =?us-ascii?Q?F4OgsXqOcflMP/4YTmH0dwu/4Q7Bzx4=3D?=
X-Exchange-RoutingPolicyChecked: Id/ZSdetRAKJ7OVCMxdZBUXd7lH0vu93KfRqzJrNCJHs8ZYky6gw7TJpYbSs2zi+x1M99ock3PoT3copZm+ErdJk4SGoaYUrSzFLcB7UiK5aBpuM3rM6SO9pOrtVX4EtoJiuoMA4gVAvZP4eTPvQOXwDHJZ81lC0agv8PYkcJttXKulVscnRXABXtsJWLwEwAzh/4d0GKQ5bK1oAztd6/zhKTQsGOImV2BoujpWyUEK5QlXyLmsceUeX9p1i3riJjiC1u1JDLBAtyT6K/DQdMU9IFJDVoZB1wPP83PRmS8I64WRVtlJFeARxeGLenowm/oEyqpVqv+oNBGRv/CZS0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea7fa84-ffcf-4bda-e921-08df1e9f0c64
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 03:00:56.9642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qh6G3w0sVpk8jZsUkz/tRq72k3UOTFWDq9bswEDrhjfwr30ah0omulUO1JQJ+D93qHi6ejfIaqESpyuhBDfL2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7267
X-OriginatorOrg: intel.com

On Mon, Sep 21, 2026 at 02:38:45PM +0100, Pavel Begunkov wrote:
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
> The ctx-map separation exists to support map invalidation (see
> dma_buf_io_invalidate_mappings()). A ctx can create
> multiple maps during its lifetime, but there can only be no more than
> one (active) map attached to it. Invalidation drops the active map
> if present, and the next map will only be attempted to be created
> once there is a new request that wants to use the dma-buf IO ctx.
> 
> The primary task of the dma_buf_io_map object is to count requests
> using it and to wait for their completion when we want to destroy the
> DMA map.
> 
> [un]mapping and any work with dma addresses is delegated to the
> importer driver via an ops table stored in the ctx, see struct
> dma_buf_io_ops. Only the target driver / subsystem knows about devices
> it wants to use the dma-buf with, especially in case of multi-device
> filesystems or stacking in the future.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/dma-buf/Makefile     |   2 +-
>  drivers/dma-buf/dma-buf-io.c | 219 +++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf-io.h   | 113 ++++++++++++++++++
>  include/linux/fs.h           |   2 +
>  4 files changed, 335 insertions(+), 1 deletion(-)
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
> index 000000000000..8312637a299f
> --- /dev/null
> +++ b/drivers/dma-buf/dma-buf-io.c
> @@ -0,0 +1,219 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common infrastructure for supporing dma-buf in the I/O path.
> + *
> + * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
> + */
> +#include <linux/dma-buf-io.h>
> +#include <linux/dma-resv.h>
> +
> +static void dma_buf_io_put_ctx(struct dma_buf_io_ctx *ctx)
> +{
> +	might_sleep();
> +
> +	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
> +		return;
> +
> +	ctx->dev_ops->release(ctx);
> +
> +	dma_buf_put(ctx->dmabuf);
> +	mutex_destroy(&ctx->map_mutex);
> +	mutex_destroy(&ctx->map_create_mutex);
> +	kfree(ctx);
> +}
> +
> +static void dma_buf_io_map_release_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_map *map = container_of(work, struct dma_buf_io_map,
> +						  release_work);
> +	struct dma_buf_io_ctx *ctx = map->ctx;
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +	ctx->dev_ops->unmap(ctx, map);
> +	dma_resv_unlock(dmabuf->resv);
> +
> +	percpu_ref_exit(&map->refs);
> +	kfree(map);
> +
> +	atomic_dec(&ctx->all_maps);
> +	wake_up(&ctx->maps_wq);
> +}
> +
> +static void dma_buf_io_map_refs_release(struct percpu_ref *ref)
> +{
> +	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
> +	struct dma_buf_io_ctx *ctx = map->ctx;
> +
> +	/* There are no more requests using the map. */
> +	atomic_dec(&ctx->active_maps);
> +	wake_up(&ctx->maps_wq);
> +
> +	/* might sleep, use a worker */
> +	INIT_WORK(&map->release_work, dma_buf_io_map_release_work);
> +	queue_work(system_percpu_wq, &map->release_work);
> +}
> +
> +static void dma_buf_io_wait_active_maps(struct dma_buf_io_ctx *ctx)
> +{
> +	wait_event(ctx->maps_wq, atomic_read(&ctx->active_maps) == 0);
> +}
> +
> +static void dma_buf_io_wait_maps(struct dma_buf_io_ctx *ctx)
> +{
> +	wait_event(ctx->maps_wq, atomic_read(&ctx->all_maps) == 0);
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
> +	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_release, 0,
> +			      GFP_KERNEL);
> +	if (ret)
> +		return ret;
> +	map->min_seg_shift = seg_shift;
> +	map->ctx = ctx;
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
> +
> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	struct dma_buf_io_map *map;
> +	long ret;
> +
> +	guard(mutex)(&ctx->map_create_mutex);
> +
> +	scoped_guard(mutex, &ctx->map_mutex) {
> +		if (ctx->maps_killed)
> +			return ERR_PTR(-ENOENT);
> +		/* recheck under the lock in case it has already been re-created */
> +		map = __dma_buf_io_get_map(ctx);
> +		if (map)
> +			return map;
> +	}
> +
> +	dma_buf_io_wait_active_maps(ctx);
> +
> +	ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				    true, MAX_SCHEDULE_TIMEOUT);
> +	if (ret <= 0) {
> +		if (!ret)
> +			ret = -EAGAIN;
> +		dma_resv_unlock(dmabuf->resv);
> +		return ERR_PTR(ret);
> +	}
> +
> +	map = ctx->dev_ops->map(ctx);

I'm playing around this code now.

I think you need the dma_resv_wait_timeout after the 'map'?

If a device doesn't support p2p ->map() will typically trigger an async
migrate to system memory and data will be moving but the map is valid -
Xe 100% does this, I checked AMDGPU and fairly confident it has the same
async behavior.

Matt

> +	dma_resv_unlock(dmabuf->resv);
> +
> +	if (IS_ERR(map))
> +		return map;
> +	if (WARN_ON_ONCE(!map->min_seg_shift))
> +		return ERR_PTR(-EFAULT);
> +
> +	atomic_inc(&ctx->active_maps);
> +	atomic_inc(&ctx->all_maps);
> +	/* get a reference for the caller */
> +	percpu_ref_get(&map->refs);
> +
> +	scoped_guard(mutex, &ctx->map_mutex)
> +		rcu_assign_pointer(ctx->map, map);
> +	return map;
> +}
> +
> +static void dma_buf_io_kill_maps(struct dma_buf_io_ctx *ctx, bool final)
> +{
> +	struct dma_buf_io_map *map;
> +
> +	scoped_guard(mutex, &ctx->map_mutex) {
> +		if (final)
> +			ctx->maps_killed = true;
> +
> +		map = rcu_dereference_protected(ctx->map,
> +					lockdep_is_held(&ctx->map_mutex));
> +		if (!map)
> +			return;
> +		rcu_assign_pointer(ctx->map, NULL);
> +		percpu_ref_kill(&map->refs);
> +	}
> +}
> +
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_kill_maps(ctx, false);
> +	dma_buf_io_wait_active_maps(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
> +
> +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
> +{
> +	/* Remove and wait for the last map, there should be no new ones. */
> +	dma_buf_io_kill_maps(ctx, true);
> +	dma_buf_io_wait_maps(ctx);
> +	dma_buf_io_put_ctx(ctx);
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
> +	ctx = kmalloc_obj(*ctx);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->dir = dir;
> +	ctx->dmabuf = dmabuf;
> +	get_dma_buf(dmabuf);
> +	mutex_init(&ctx->map_mutex);
> +	mutex_init(&ctx->map_create_mutex);
> +	atomic_set(&ctx->active_maps, 0);
> +	atomic_set(&ctx->all_maps, 0);
> +	init_waitqueue_head(&ctx->maps_wq);
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
> +void dma_buf_io_detach(struct dma_buf_io_ctx *ctx)
> +{
> +	guard(mutex)(&ctx->map_create_mutex);
> +
> +	dma_buf_io_kill_maps(ctx, true);
> +	dma_buf_io_wait_maps(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_detach, "DMA_BUF");
> diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> new file mode 100644
> index 000000000000..5ea92fc78582
> --- /dev/null
> +++ b/include/linux/dma-buf-io.h
> @@ -0,0 +1,113 @@
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
> +	struct work_struct		release_work;
> +	struct dma_buf_io_ctx		*ctx;
> +};
> +
> +struct dma_buf_io_ctx {
> +	struct dma_buf_io_map __rcu		*map;
> +	struct dma_buf				*dmabuf;
> +	enum dma_data_direction			dir;
> +
> +	/* synchronises map reassignment */
> +	struct mutex				map_mutex;
> +	struct mutex				map_create_mutex;
> +	/* maps that may still be in use. */
> +	atomic_t				active_maps;
> +	atomic_t				all_maps;
> +	struct wait_queue_head			maps_wq;
> +	bool					maps_killed;
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
