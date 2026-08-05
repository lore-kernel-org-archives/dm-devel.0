Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9073442B11
	for <dm-devel@lists.linux.dev>; Wed,  5 Aug 2026 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785934044; cv=fail; b=UDoI+C6R8pe90ll8DIqx8lYcO99yWUXtNNkdQYUwun4Nj68IbwoihNTfoPlAq4SQpmyNnuLD8UMjsyBYKuwRAbFrHCTzTY9ErbQStmtgZHm00nTIHLTBpyP06y9M0en6LRJi/ASPvVVvxatoIQjAHlhH4celJNkPvqnXSxQLvy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785934044; c=relaxed/simple;
	bh=lsxzo4Iv+6plnXPZ27W1EKoanrQjqD52lgJNLKCEzdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=opU/d9EoNpOoBB/KPRDR+QWrfpEiZGZWaJAeNcb01mb1bntDnQdthrZ4KO/R4i9MRktAL1JG+sj6SgkPVVJG065YLMI2umxtA4HIy9pFj4GYo2XdQbrxIsLgk+Tefk+ijQpGbNbRH9+SItV+5TyShXw2o9KDVlk1vMQr0K6NWgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=A1VpBK/H; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dWhaySU6; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A1VpBK/H";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dWhaySU6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1785934042; x=1817470042;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lsxzo4Iv+6plnXPZ27W1EKoanrQjqD52lgJNLKCEzdg=;
  b=A1VpBK/Hc+w9n/8BXtRyTQotyKe0JeF67JtHOxMxRegbb0WM0vR09jCY
   0rqUZzqF5nBFCxlyVHsE9ugcePm1ViTPv8Eo1A4hbyoKCVxHYG++KyKrB
   LDiH4eUOYBNhd9m7O556uthb8pgiaFxUapbY/yNsQ+feHcYVGuRSoJ3Wa
   /J8eKWaB420JeMQm8uePGbdKV4ZUUdIe7TTDTpvVUDl7ye9sG5T0GuMkw
   W9uXjKgtbWp17tNuXGZDLxZ/IBgIKx+Uqv63HHu/BxBUr+LpArJv1nsEP
   733Sy/Oh0EkyKsmjbJYu3QObzyyctu8ettEjFN3zAboTA9UTGUOh2Uipe
   w==;
X-CSE-ConnectionGUID: lqnuD0WdRYyBZ2UL6LAgGA==
X-CSE-MsgGUID: qX+Z+wA+QDybqiGrJ+rQRg==
X-IronPort-AV: E=Sophos;i="6.25,206,1779120000"; 
   d="scan'208";a="153427253"
Received: from mail-westus2azon11010056.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Aug 2026 20:46:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uau73XN0E4s44Zwngkb/vTUBooDyPOyEsQJTraH8PMYlqxXIh7/YsnwhaZictXXpHWSDurXJIBxocdYtv9LKoeLy0TPPnLxGWKchIdLt8yI425b7S8HmwQWISF+VkQb3G7ron1KZck/XWimjBN2rNP6h2VtVQ8UJIz0h1pK2hrq5Q+nPKOt+90P28u/5uuZ5RRqHkgN9nDlVBROowaHQCIRBO676Q7M8dgqQxzQN7Ti3b6eNbAVFTOtflDkSBPdrpuVb5KLdWj39k4+5cFXPvb74HgRGBKOSp7nt/QDtcQtdxV8tsz1eBKhyJdN69oj1UHnplVlI4DYqXoG0d2iw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgN77DChCoiS6xeD4XFr9JoFN+Bi+ChTvw9YZ+Xfyyo=;
 b=WKsILjqRreHMeTOJHfyR1SYkwo+ascn2Y8mAaqRu0MuqECteEtM/y2PZJAGwXsHR7EMNMfydixj+HHBOEgLxNyvavP4P4thRVWudQWN2wtmfdvXFnTZzoGwyVYkUFD6YCKoafRGzuZP5Zme6PH64ki3peMZ5NamYN9yV0hxMHOwXWxGLoYprjYVVF42l7017xu/5nIZAsovxo0rVzxnwUMP05RAECiKoYhdSB9+nAiCvp10L/bjTq5lf2GQb3kn0lNd3G3YxWG3gYmgqWzEh1ZVp/PvIry+Egpjm5VLxsODXY0N6wn7OgOLNUN4TC3NxBP3135vyMtQzPtbfOWfj0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgN77DChCoiS6xeD4XFr9JoFN+Bi+ChTvw9YZ+Xfyyo=;
 b=dWhaySU6VxN9Ule3ICdXl79Jw0t58EEA95gPEzkZrJ7/Fn2CgdvHqU/pfNEWj3A1DrdfSYnKgKHST2poPAz6aIlzuidLdogJXSs7iUM1qSzApvYkTQMlYa7DFl7XdWhzj47PNASwregEsJTekb06hCHPF/37dgjjxBtq6DLcftc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by SJ0PR04MB7344.namprd04.prod.outlook.com
 (2603:10b6:a03:29f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 12:46:11 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0292.015; Wed, 5 Aug 2026
 12:46:11 +0000
Date: Wed, 5 Aug 2026 21:46:03 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk, brauner@kernel.org, 
	djwong@kernel.org, viro@zeniv.linux.org.uk, Keith Busch <kbusch@kernel.org>, 
	stable@vger.kernel.org, Hannes Reinecke <hare@kernel.org>, 0wnerD1ed <l7z@0b1t.tech>
Subject: Re: [PATCH RESEND 5/5] block: validate user space vectors during
 extraction
Message-ID: <anMscoGkR5BYjSGy@shinmob>
References: <20260720201057.1862857-1-kbusch@meta.com>
 <20260720201057.1862857-6-kbusch@meta.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720201057.1862857-6-kbusch@meta.com>
X-ClientProxiedBy: TYCP301CA0086.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7b::12) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|SJ0PR04MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 93f3c997-92b9-4058-ec7a-08def2ef8723
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|23010399003|7416014|22082099003|18002099003|4143699003|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Dteq0r+AkXLVHeeDomHFdxvOF/+yUtmwkE7tQqQ2G5gWfjV5vIUhWkl1vQMOGKEI2U+eufucRYrApxxUzYO2ppzFBaZRdedQe43r0BZ2o7PxM8oBBMTNZjYcbG/KVpaEiPH9/gGSKg3ngZ8Cwnagg45gb1nbRVcRw9zGLAlJIuR2OPqqYcWjy1pa0bor6K0n7UUDmlmcDCyvZKWrZySETczFpUTemRJKW5HlvurFPnweSyOiSSOtv2nUP/O4YVz2aRoHnE4QPTprW7+2m6f6wbe+AgcyAUIqnjlOb6Sy97pejed1cCavqe0YlphODTlt4xXPRCdAF+IaFMm4dGsVuTOdQVSiLK0lSj1/smvIOn7AJYjdZBSIHym7skKVxLl7/9AQfEZK9qKsCkUW0YOGt5Sj9Gzve2UEVmPfscy78UancVpC+ktaKSaxt5UoqXNkMm5fMrSD1ODnF8sRlpRPaYXl7l3MdPn7vKAp+w84iHg/TZ8Zv9iKHClv2oddHOmT/mvgBKb8rmo8l7U4QN3JC5S2L0eTgFYpHLTIk/RC9HigU5gXK0PuHpwtdiENF7VbrlMqPaEUUiC5xONbvpqJTGtph5241erzYmLt3cVKoNyU/z+vk92cC50CPtU/0PORkePSFVl+FdM2/FX3ux2Mprowg360plk2/BvOCjgjagY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(23010399003)(7416014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h4Vi0nVJG0qSDe9UB1GZtqLJJkIQekEKlKJlZZt8Dh7yuPC6SYS88M/nUXMj?=
 =?us-ascii?Q?F4BSmdSeJ7oGqNDBWtbHFjrp5/YeQ4KVAd4jO/icQ2bVXbDLN+Gf3eRc9oRs?=
 =?us-ascii?Q?NDh2oMI0wW4vxDSoOwd3+qeg/scnfWbGw/4P2ECzR6Xtz83gowoFlasXtP+z?=
 =?us-ascii?Q?yAEuGVrGslYIAhE/qHHsAs5ndbQ6tkKyAqLY/EezXDrXZAdCOQYpNFA5D1fd?=
 =?us-ascii?Q?6oFS+I2RLuUOwb1TQijVAhuGZDMEk5n3tzMC3qcVxamV8QYn5Hod+zuj2uCq?=
 =?us-ascii?Q?IfUHXPPTG6uTjN83yHwBSGSR3QfiEGbCAW1zoFo4KshlViTX8tBw1CwmlQHW?=
 =?us-ascii?Q?4UMcHGkSbao3isZ/XSCFgkIzeC8dsZKEIAJpE5f/Vp1ax2DOc5lO5HIbRGhf?=
 =?us-ascii?Q?2C4i5RM2WtnhWVNeLoMlF3YTHB4QkWc/q5qhVo6VX5ZtbQN/DBEdu/R8v9oj?=
 =?us-ascii?Q?JFjX6WUulOWGT7lJ1ToKdNC/6jqphRRkq1gYL8WXDWdVawpXOM8QLGkA12KM?=
 =?us-ascii?Q?MI3wRzvJheRBKOs1NFzfBrGHKQuaFy9/78cS8gR1NlAZcArtT3XaQVHGFzYj?=
 =?us-ascii?Q?rHvDDbOjuyi8jYtyK/mPszSvA9VXq6abU8+WsxvQYhsgvC+qP+VqXh/t7c95?=
 =?us-ascii?Q?T6SlbvByiZx0V18V5naNcmIDIWLmSkoWORwXBnATOu0okYFvZzkEDoWbBj5w?=
 =?us-ascii?Q?169V0sMtCOFhSsN+lRRqTNYTNGnqdQ7aeL55n54REBfJMk3elbaUWYpyqyyO?=
 =?us-ascii?Q?3x4a3V036fPxnESwsai1ehwSaa/tO9bhWcbEvi64/SyqemqonSSSKRXQXx1w?=
 =?us-ascii?Q?yidnovxmkHxCc8AZmmUI+6urx2j1GJl5d8RgC1SojqAzLt1/VF5ur6xrBzsc?=
 =?us-ascii?Q?R7uNofBw83zEKMpK5YqRi9ot6vFzHZgIC44vMnD50q3vERCxSZ8dZUY3MFZk?=
 =?us-ascii?Q?liQZKYGjo6YM2MeNAZY31yVG9mIoQBugJmjDkLVDK+9c+9WlMteQDycrv0o1?=
 =?us-ascii?Q?PB2BiVU0f/OxMnNHFTSNvUg+UvMWwSWqYXluyZD7Hk/06m6+9/U+oiMEWe8b?=
 =?us-ascii?Q?uNc8khIoqecPoG8TU9dxP0kF9v73V35OHJskHDVQ+7qUKUv0yvFIk4pj0hXA?=
 =?us-ascii?Q?IVSDpKFkq/6w+Kx9WEJMFCGT0V9aCB+v/6cNjiIAfHdUMlA5JnLTPHmF0AOt?=
 =?us-ascii?Q?hrWxbZpWq/yDvvjxZv5NaeAQdD1+4i/2AWrrxMpiuCUdLUA4DR4krjljVtOv?=
 =?us-ascii?Q?D1IVnY6a4XHPMl0mkw9FeLjQMG74svq7hkr26vgifh5VtxCoMnkgXfLnA/Wz?=
 =?us-ascii?Q?1N5aAYGLJWp4Qcid/IyEBGeieFDMPThWZLhV0h4q25JTA1ykeDx3GIWfaSD8?=
 =?us-ascii?Q?9ziiv/0zEpeWPH3PiINckuzHYef2Kc9zQludLz/2tNnGdPqwQJcmNT/+F9V9?=
 =?us-ascii?Q?g6U1WIa4JqAaHKKyQid9Mg24EVaNdWaMYCATABlLEYfphVRMAbabFo2daH66?=
 =?us-ascii?Q?eZVzFi0HAE9WoLJzd2/uIInTD+xwLKn+rtaAFCD4hat/jrhUUEVWpxmmKzCD?=
 =?us-ascii?Q?m9NSFKLzAbf81/LcxbKmMudsdtB4zWM28opsjI392nlKddRQW8yecO34ulPG?=
 =?us-ascii?Q?b7/48Bvk0XDPOu5IEjji5CD2r3GJoT6ehsqbwsAJQ0yM47dW0sgmHOtIu0+V?=
 =?us-ascii?Q?wmSNAuz7QJV/Nb32+ju9ZG+BUunRtvTzpfNRITU8fAk4XTV09f63JA0UPKnV?=
 =?us-ascii?Q?UT6KhVc0R4ksAANbyz7f494Sz6qJR3s=3D?=
X-Exchange-RoutingPolicyChecked:
	A71h9SfwExqLvPfZ7ZXpXBvDu/Xv4rEN9IPRW7qm18UhniODQIWx3xZJEGYx4OD+tcUpPY6tV+QHy4sPa1mSLWcvE+AfGBOeZBRZr5glc+wt0oklJ5PuWeGYYk+oO8X1011ZfksSMbuvNd36RL1pWmS3C8DT+AYQq3SUCHVCiufw+iojlW1218aqVT0/54SDw6Q5AikwHfugPHw89Cay2AreS85djKX0iDF5POtUPKXSPtXJGkmOyvRIg9V3VupCIPzHNUP3/GTEQ7/8DgKYt5Hoe7XQbjUdy/EPdZ/ixli9e+u3zOeP1P9QDSNHKLQ+KPliZQlOzqgh3elE7N3cSA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yjJ0RTs6yYoex9sn+h5Ega7YxTTnWUDN8cQ+Dd9ZROK72xnq//1yKZlWSdfwcWoVzG1nufFW7FzyeDlcVnuNLxa/P2+UExLrOCyY04ACY+3j/Qz3AZDwhf/AquaI0wxKqfmjPoo7tthR4R5XJWvfDFBpQp/TLSZ6/+tEzM2xeduVOo/GxrC3suY2R6BSprpxkWEky3HJPYdJ0BCFYu4342w1tG3jN/1WeHW8KV/0jD28vpPjtzQyexMi7hcLXLByBGBpuuWDEOMB8cXBO0pXYkP1UAJpf7dp5NNOSMWHbbwMzzOLIeGPZxCC880IK+msFqCC749gC0PPNSVzsDjmyUTx14Y/pOQ0jsuDiaJDKWX7xxJOhgr1ubvlVdVKq5Idq6l9Pj4HzfWBg+8IO5++5hbcnRdKj6FGtQGgHsW7jDfFi74Zw2+Tl0VB5yYN/ccGAs/yREJS+uC9+Ym1nFU12KxnOp19E55Jmjhttn+Rb3TPHE/huz0rObFlNMwjUeMvTxH9q6p+J9cknXi13vbgU1Fp4TDsvFN0Y/J2pu1or+O6uIANPoxLnPtRO2SIO0peWQDT952yUt+f+0571GO0SkFRU/4Q+rlCRrPeX+xpYjQWzVewSZQHcMJMmfNi16ky
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f3c997-92b9-4058-ec7a-08def2ef8723
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 12:46:11.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4Ya8gY0s4ZfoEU/gAWLSiZv5BAbl6gKAZBAM022Tp1v47tuMm6XNc4jOZpQ1Ll+b4rjh1ssvF5uz7twuJeeLVBNSvA3yQADUV6JEJF7AX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7344

Cc+: 0wnerD1ed

On Jul 20, 2026 / 13:10, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The bio-based drivers don't necessarily check the alignment split, and
> stacking block drivers don't always handle a misalignment detected after
> submitting the bio. Validate user vectors against the device's
> dma_alignment as the bio is built from the iov_iter, rejecting
> misaligned early with -EINVAL.

Recently, the new test case block/045 was added to blkests through a GitHub PR
[1]. The test case passes with the Linux master branch tags v7.2-rcX. Today, I
found that it fails with block/for-next branch tip [2]. I bisected and found
that this patch triggers the failure.

0wnerDied, Keith, may I ask your help to resolve the failure? I'm guessing
the test case needs to care device's dma alignment, but not so sure.


[1] https://github.com/linux-blktests/blktests/pull/251

[2] failure log of block/045

block/045 (test direct I/O full-trim bvec alignment)         [failed]
    runtime  0.550s  ...  0.630s
    --- tests/block/045.out     2026-08-03 19:26:40.407053612 +0900
    +++ /home/shin/Blktests/blktests/results/nodev/block/045.out.bad    2026-08-05 20:48:33.366932845 +0900
    @@ -1,2 +1,4 @@
     Running block/045
    +bio-full-trim: pread returned -1 (errno 22)
    +bio-full-trim helper failed
     Test complete
block/045 (zoned) (test direct I/O full-trim bvec alignment) [failed]
    runtime  0.578s  ...  0.636s
    --- tests/block/045.out     2026-08-03 19:26:40.407053612 +0900
    +++ /home/shin/Blktests/blktests/results/nodev_zoned/block/045.out.bad      2026-08-05 20:48:34.550929436 +0900
    @@ -1,2 +1,4 @@
     Running block/045
    +bio-full-trim: pread returned -1 (errno 22)
    +bio-full-trim helper failed
     Test complete
