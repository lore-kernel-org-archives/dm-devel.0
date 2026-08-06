Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F069D3EB809
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 08:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003454; cv=fail; b=FbXGfwNdsTEZNXTmi9q66u6Qeeg86MZn2g7qd+Ku/3Hk9dh+elj92dZB3gINJz8KRpFBQncYhhf+zfJj5hPSoZkcwWMEAglfVS5UV9x2OVmDIUBgDcqW+O/QoSI8xhqh/R2viBAO0IRukHHzRy1JGvvZKFLY2oyjjcN+QggWAl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003454; c=relaxed/simple;
	bh=ROrfI40do/rrpwwUrHiC2mSnMA7SNmEC/glvTY3iMQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AJCUBGzwTEkn8+DiaWUVvxfJTxOV1suOmWImfQ1oVyeCI0H4f1OSUoAPZRfJuLUd39nwB2U8Z/Z2c24bO35x7FXjHtWZWvqjRmqs2SW6JSUmiBb+MEgmFtuxzsNgz2wo2jGQXTPiSIWzuJzgUfzRu7QmcEq4aDD/JldKumlJ08M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c8VlibGv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RHXqy2vp; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c8VlibGv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RHXqy2vp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786003452; x=1817539452;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ROrfI40do/rrpwwUrHiC2mSnMA7SNmEC/glvTY3iMQg=;
  b=c8VlibGv4933hQkIjnId9jmxW5Ks77Y62iGBbOcXVLnFCQipUrCne3nP
   5MuEutKdNxHtkr8BxcmkNAnVC2rBwf/cUU+zKnalcnpNppk48mTdw1ijo
   SeoCsMytFYh3immKewPB0WLzH+2ZcZyWKoWMFWXpwtvoBfnVaExkiAteu
   lkA9ilafqCEST69XZCzx+WGL5bkavJyhaCtWdQx+GqASOEZEO2csdT9uh
   oZKSQycuDXhLJQJZ49SqXoPYbWIpzd6SsSHan8W265yNOIGCQN9vRXpJ1
   Bv+AAhCq/tv+XkcjkamrDEB3DXo2w2HuiNxzOhYbmPSPZu6na9u2s0w1l
   A==;
X-CSE-ConnectionGUID: rOVhungaQwmZ4J8EA9GtfA==
X-CSE-MsgGUID: cHL7qiz0RyG67bSRD+BFxA==
X-IronPort-AV: E=Sophos;i="6.25,208,1779120000"; 
   d="scan'208";a="152316260"
Received: from mail-centralusazon11011003.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Aug 2026 16:04:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ckvI1irpB1bmJqmM6iyyRX817uv9U2EdxVoBVGbuASk8xCWaX1Egz4cZlfUISvMMH+q2ovkAVtHeKOSa/BuLJGUz3s6BjjUsTQum9O4JoqAEp64AbcynPi0bQ4dYuIHWhGDYP/bnRIlGICUANdV1SDzwqlkjrvQ9olZ+LQLpS4f493/X1/Z261kK/DP9uZax4RvX7EOGgbUvsDTIKRxS7yt3OGwzjqYzU9tXysW9/5ucmbtPyDtJ/8KkxtRfvEX5zs6FTUn4rgvwnikFRIxvsyZZCIEg2fommEX7e7uutDMkCcCvH1SOFm4s/I9HR5lCalJ3yVyHHWNKoENjjtpsbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gkp1WrvtPYfyewV3GMAWyLZq7ubfwBxr1VMdOV5B7y4=;
 b=bqE/2AC+A8k1ifWc2hClzGZVyeh00prAZKDcALgSEyryIdiXPJUKmL7yq8AJyzLSa/e5lZyrNPU+3fsFnLi7AjJsL0m9yAH+PDMTO6yKdhQkllt2vdDuHBEeVDXb+ezu0/R/u2jdIHd3+/UXm+Po9C2tt9qp9eF8v1+WL6SnjenwH4BPuopYTJrvwcyvmHnVD1wx86yUrVlFL+1BhAYVtW0G2hbghsMcRL2G1sE4P2CFB4yoEmivCdGTT/SjxTPQpbwyBsSJ2mEcT1azlQFyDjaDy49RGK9ZnsExnpoiEEIEsAyafvtQ1TC3pGKFu9dYcLR8DSvLLe09beSkaIWNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gkp1WrvtPYfyewV3GMAWyLZq7ubfwBxr1VMdOV5B7y4=;
 b=RHXqy2vpEd9QFaV367OTsOmCFN3k0vpvxd7ffQcJ+cArmeOS/2YYAKe2ltGvKt9oesxBpWlGOeL5ldnNMlhC7qsRqcti/roLCmNrU3yTbx0etJdQJtxS0PvgtSRbpR7MIoqZupiA+TYk+cD6O9Ki7KPcGeSRgrRP7Y+CfUVaRPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by DS1PR04MB9096.namprd04.prod.outlook.com
 (2603:10b6:8:1df::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Thu, 6 Aug
 2026 08:04:00 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 08:04:00 +0000
Date: Thu, 6 Aug 2026 17:03:53 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk, brauner@kernel.org, 
	djwong@kernel.org, viro@zeniv.linux.org.uk, Keith Busch <kbusch@kernel.org>, 
	stable@vger.kernel.org, Hannes Reinecke <hare@kernel.org>, 0wnerD1ed <l7z@0b1t.tech>
Subject: Re: [PATCH RESEND 5/5] block: validate user space vectors during
 extraction
Message-ID: <anQ-28nxOqBmQjxu@shinmob>
References: <20260720201057.1862857-1-kbusch@meta.com>
 <20260720201057.1862857-6-kbusch@meta.com>
 <anMscoGkR5BYjSGy@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anMscoGkR5BYjSGy@shinmob>
X-ClientProxiedBy: TYCP286CA0170.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c6::11) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|DS1PR04MB9096:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f48aa6-8830-46c0-8e10-08def39145e6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|366016|376014|7416014|1800799024|6133799003|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	P/N2HL9w28hfKbS799/iVv3npUMdWEnGC3w40uIwJTinsvWDxyCzK+7RhCvCIR+x8ehlsCSPvLl/d/Sadr+PwzeP8L8SMCTaLGg+GNixY55u51ccKWLluJZWQsudkxivSD6UVkUP2N2Nch5OQ6EwrOYatYODee9GZkGby4oalJwZ/NiRvcvkPgOX9xR6bs5LpnTR72VKShafH0pX3PoPzeLRtGAmVpwCf2JR6bJjBImQ8kqdS8DwlXqS22H5Nbl2mzBCrM+xKYItsE7EH/NrUy2MqoS8boLNqVnqYtfsMEInpuEb9KDmMPSrvWO1josQsaKhJnYVZb9dOP3Mfe8pW1dKTOQ2d+DkM5hFMKhh3+cV7ME+HIBjZPkknGpzpCVHYCs2/QRKRCzInXWIFqrhXBauP1jV/wgKzwKSrCL340vEvLBfZFzxR2MIl8yRj9A0pXpAZ58rwGDdx8g11enJIMA2yjPoW+h4/fj+dqXNdUioiUeqRd5YlwTmu+TeMjqgxu38en7GdJg/hOvFdpw40+pFD1JZWtGibfb4I5isWzyeWnTjazXO141vhze1pRHwF4k3mQla3NuSJbKtQk1IRihmh2n92JK0NAlANfDjzEeg/u9qoKtmChfGUzfxO3mssHJffJHS1/Cs2bhkCsn8ireKigTTYjey3xBXU+ZF00A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(366016)(376014)(7416014)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HHU6ZI7vAUMuWWk5GMqZBM0Jw9CjjnDBJ1pVA9Hb0qpbvlu2xJOlvHnmQ+CL?=
 =?us-ascii?Q?NMl+LL72DV7XpMXS5TKq2d0Zf0SRf19C09da6wP/+XHjknyqvnislj86NeYY?=
 =?us-ascii?Q?c1biMSGyOtuM2wipa4ERBaCrHGTZ2ePl+iwYUMSSkt8DVV9pccN/OpJEWHrb?=
 =?us-ascii?Q?HcCd0IyVIj7OnkQ6lH00B85eznj4MjHiZqFQjTx0aAtwrqUZrEsylPnUaJej?=
 =?us-ascii?Q?hRxR8hpOug+Zdpdbngx1aeN9YLsug+2oSQ8OXZEQ7opHO7pXrlHQOi2WiWdf?=
 =?us-ascii?Q?pc9KXKOHHi7qtMw1dWTaP0viyRhjAubANx8XrO+uMI5axskzKFnRXnTZjcPr?=
 =?us-ascii?Q?rfp6+repVBYIBuRTFzGIg4H80JBoSaKSBz135yXfyatnGHZpJsfqICyI1xoB?=
 =?us-ascii?Q?cOvIceggmx7bvQ1gmMtGu6vjfgVA/AFVPPK8Xo/Pg8VceBWwQrjsK6D+92Ob?=
 =?us-ascii?Q?U01D0YQCYsNuPz7tGTbAnCR19rEkpSiqBIsBxNwnoxW2WWn0fnfMiQ5C8YQj?=
 =?us-ascii?Q?V0U4stxXhir+u15B9a7/STzbkiKgKKirXGO0puhEK24MaoLX2vonySPoK4wo?=
 =?us-ascii?Q?I6ajchebZjIIW9YktneVScycC+36CX0Be39d2+BueC6uEUwe2R2+q0ExGJaD?=
 =?us-ascii?Q?TiS2nFX8KLP76jFEEUwA8sYHvIwsa3Zfto68CPM1d6lU5XAJ1xXoE5PgBXKw?=
 =?us-ascii?Q?rG2PJNJvnVr/tkkRsXVb4FtnogeyqmYCZKha5UixaB4KQ+vUpxv3x+V1stzn?=
 =?us-ascii?Q?Dmb9fRv/uOQeT0GyMDUyypY/rAfdenfiYJkI8nbOe6qCStU45wxPHIgakS0H?=
 =?us-ascii?Q?Y2RsLJe649zqtvanBej0MNM+ULgjSJIyu9dwt+XG1cfx5GINoLqSjniGf1n8?=
 =?us-ascii?Q?k7QvnJ5y5w0irwlL4VO5ofBObyKG4zccXmoKvrChnuPL8naKfuINntLD4ggS?=
 =?us-ascii?Q?3AzxJc78HF8SmyPRYJSthbm9ETYpP9wS6Qj5bKuk0r+9JxU9f5Mvo3yIKlfh?=
 =?us-ascii?Q?6AnhDCT0gUQC+je9QW7s3FzIZSMb+9kN/PhB/tWewa9zNiuuXPi5H1LHSLOW?=
 =?us-ascii?Q?nhxBca/QXfX7AxXXWCzVudGgps3714nRU0feUaGp4k3Zprl+ofZ+9eyrr1Un?=
 =?us-ascii?Q?d4IEM+JH4CSsnM3KaQQM62thGqyXvX0GU+PDWndgc/0ZKh0XMt5JtHLV9EjH?=
 =?us-ascii?Q?x4bth+OFUuT1xRcGaAgphIZS/nlzQtvEO8gr0cJvXscSTGHp1gdyxF+ZRiUn?=
 =?us-ascii?Q?mgTwdUOgZtVNk2WHNMZHdXHstWY7QeKdpcYsL3OzLZIEhsS6j4Er8IewlvcR?=
 =?us-ascii?Q?RDYg2S1cQnvPouawWo4GIdAUt13lBmVGoE577VAAbAu1592UE2QTwT78cKqA?=
 =?us-ascii?Q?16IUbX2tA/wd+aKHTnI9onTgmuHihPbtHta93DXRp1KODNqtw3ahPYDy7YiC?=
 =?us-ascii?Q?5vYapnFvEqgziJEan4FK+hS5HykUlo/QlK4Azju+6EQpYJEM5UQ/F6RNdyzx?=
 =?us-ascii?Q?fUUn0fFFlmwykgUiOa0f1+T8HCHheel+sXvQjt4dq2dHM34fyOFHMixGX1og?=
 =?us-ascii?Q?HhUKcmAiaNZJB351eiUeWRNBIVQ7xEbFEdJNme4K2uiTjO9pMRaul8EEOkTy?=
 =?us-ascii?Q?bTft0jkoagIwgKxCzHCFbcYGlsmyChHmP4vbbvJLS77ds7zCs+55QT05BfnO?=
 =?us-ascii?Q?VgRDr8/jjJc0YA5xR2k7p6YDydBeKdZiaFBCmvlb8J/M4NYdkKnbDwh22m7z?=
 =?us-ascii?Q?fGKG5RgjyZHrDFndjrCf4eOt1+QiWMw=3D?=
X-Exchange-RoutingPolicyChecked:
	O7ZAzqV6Jq3106eNKe5mGTAUv1ou+/kp3hSdQiMjPnWi3Q17eJkH314iV9Bg3PnmXbvxs5TspaaiKBlH+JQX3gJnwpj9LJvIzecexm0CS93+zueOYC51uoByLG3aw/8TPtBV8VLHg+UERcolBhWK6a3joUgiEP1dC8a4Rn4uLUXrI3RRa0kUYJ4iAnxp5bxoIBIw6j2JAJUMnweWhxWKdopl4VSziQnZtEQLwrUmvtuAULz1My/NbcO35NmfiMHvrkBRPlqprhoGT8Gu2QlRykbx7zcgaLWKNiAsqpJW7YCiGgTT1NWQxB7BqaK1/OIl28RSoKPBJ3VIvfH6C7Nhiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lraHDGijr08mm6EXYiB1yFwWbhknxVqquarq9N3MnNgEolLxrusw97nzUSrdAK43IsDnVNbxFpQULyLqIdTPzOiCgun5BkTzTwiM4ORoFOVab6BOdzt2MlihpW3GdTv2XESYK1jL8416Dw3dvmTzf1fJF1+4EK5wockkGIdp/W4QIoPiXUHwoMn9ebyevnVvgj6F0+4aVkQJhi1qHKNGoOJbPbrUyrVhYLhmr+jaeSthfocZUwHQf2i5O4wOFYz9Fc66sRwdjjo6/bxpaqy2qMV4Dtt51swnrSlqN20zT7T0HmwszVPOBt4wJ+KYXQr3Qj6sPrz5jte5l6D3uTi+ZeryB+1RIpn8UzEPLVUX5VqB64zWM4a1QN7sNsCpy58g6E8b8j/1+WBfrJqr2HVO5QMcM3+pPNKCb487JlKzYPCvplIp0e2QRXIbyDGYwe2sdoxdEk1ke8YvXQ0Vcm1Tr3RZGjdJkxRMha0PUYqLn6hEda1Ac1HINCLLvzqWLj1q4Jq7cqZkrMgftu1iePFl2f9zyXbOoAeLVhinbBgE7UY+h9mKht/gAp+s54ikYwadkJ23Jv83mOntduw1xbzj+wBcwutUYIahstOK9B/SJdTaWk0GEnI5WLzsii/umusL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f48aa6-8830-46c0-8e10-08def39145e6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 08:04:00.3948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwxZtXyW550yTRFwO390nnbtnp6yyp8q+basO1WOa6C0AV+p2FYJTflbQeJ9KmHwWdoBjw5eQn5MZk1IjcN9dgalfN5mo5OOlFbIq6RS/so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9096

On Aug 05, 2026 / 21:46, Shin'ichiro Kawasaki wrote:
> Cc+: 0wnerD1ed
> 
> On Jul 20, 2026 / 13:10, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The bio-based drivers don't necessarily check the alignment split, and
> > stacking block drivers don't always handle a misalignment detected after
> > submitting the bio. Validate user vectors against the device's
> > dma_alignment as the bio is built from the iov_iter, rejecting
> > misaligned early with -EINVAL.
> 
> Recently, the new test case block/045 was added to blkests through a GitHub PR
> [1]. The test case passes with the Linux master branch tags v7.2-rcX. Today, I
> found that it fails with block/for-next branch tip [2]. I bisected and found
> that this patch triggers the failure.
> 
> 0wnerDied, Keith, may I ask your help to resolve the failure? I'm guessing
> the test case needs to care device's dma alignment, but not so sure.

I took a closer look. I modified the test case to respect the dma alignment [*],
and now the test case passes. This approach looks working. Will post the change
as a formal patch for review.

[*] fix trial patch for blktests

diff --git a/src/bio-full-trim.c b/src/bio-full-trim.c
index e304b2c..7cea3f9 100644
--- a/src/bio-full-trim.c
+++ b/src/bio-full-trim.c
@@ -12,20 +12,38 @@
 #include <sys/mman.h>
 #include <unistd.h>
 
+int msb(unsigned int v)
+{
+	unsigned int b = 0;
+
+	while (v >>= 1)
+		b++;
+
+	return b;
+}
+
 int main(int argc, char **argv)
 {
 	unsigned int block_size;
 	unsigned char *p;
 	long page_size;
+	unsigned int dma_alignment;
+	unsigned int dma_aligned_offset;
 	ssize_t ret;
 	int fd;
 
-	if (argc != 2)
+	if (argc != 3)
 		return EXIT_FAILURE;
+
 	page_size = sysconf(_SC_PAGESIZE);
 	if (page_size <= 0)
 		errx(EXIT_FAILURE, "invalid page size");
 
+	dma_alignment = atoi(argv[2]);
+	dma_aligned_offset = 1 << (msb(dma_alignment) + 1);
+	if (dma_aligned_offset >= page_size)
+		err(EXIT_FAILURE, "unexpected dma_alignment");
+
 	fd = open(argv[1], O_RDONLY | O_DIRECT);
 	if (fd < 0)
 		err(EXIT_FAILURE, "open %s", argv[1]);
@@ -40,7 +58,7 @@ int main(int argc, char **argv)
 		err(EXIT_FAILURE, "mprotect");
 
 	errno = 0;
-	ret = pread(fd, p + page_size - 1, block_size, 0);
+	ret = pread(fd, p + page_size - dma_aligned_offset, block_size, 0);
 	if (ret == -1 && errno == EFAULT)
 		return EXIT_SUCCESS;
 	errx(EXIT_FAILURE, "pread returned %zd (errno %d)", ret, errno);
diff --git a/tests/block/045 b/tests/block/045
index 65bfcb9..6e112b6 100755
--- a/tests/block/045
+++ b/tests/block/045
@@ -25,7 +25,8 @@ test() {
 		return 1
 	fi
 
-	if ! src/bio-full-trim /dev/nullb1; then
+	if ! src/bio-full-trim /dev/nullb1 \
+	     $(< /sys/block/nullb1/queue/dma_alignment); then
 		echo "bio-full-trim helper failed"
 	fi
 
-- 
2.55.0

