Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2085.outbound.protection.outlook.com [40.107.255.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0178A3E49E
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 04:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715832195; cv=fail; b=OzB/tZb/SoPDL7XLCdT4EYg9p0ze6TGmJtqSuCzgBMl6/m0eqSeue2whl2PfDsvuKzcFkw4Il+TRAoMBQsCPrbBvHWVv8P0hBI/z5pLnSI5dRKt14xGzVTjLEIThLkGMJjZhOmVMkuCg63apfGkKc+K8ih8Ffcc1ribO2LNs4Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715832195; c=relaxed/simple;
	bh=pPWvRKMPkRY+EnBmIi6erbgSwiPgbkjhyxIFZjHSVZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E2rvwXMEmXTLppsdBcPRgzuc6YuUKdAO1nMlB2pB+WpXgjziIDqds4CKa6/+FKnU4o3nbfdIypRlDPScHZTYNOtLYoUk1d4mYxrNXjAf1Bf+P2tTMkjI+QGPg3aFIXURD6QS3owrnRTL+X3PFd0/xClZyQFjSWx5FUIWMSceUdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Xj6oaKs9; arc=fail smtp.client-ip=40.107.255.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Xj6oaKs9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diMSQDWAvcO3PQTmqbDHgtStmSNel63evlDswiQGXj5ym/I1ft65nSL4FubWBP/VEKBsf2JcPofskjqUaqOKUnwnRUnfx3jr+lX8sZDqDmSvnxW4OKwZYLn5mwJHfp/CI4ff7EKA/CC2b6Fa8ZxqP63U1c7LVrnTOPcfv+BjF6+ZkAeUyZhgDn/aWVuw6W11csS/xA31DJ+oCilIUaQwePbQpvgRrFYPenNP1vCZ5f3tG7rG+mvifarzMjx9uVftoqOdV/W3uSvxGS79Bk5bMZpacgBls4UunRHTNAJXhleO2TxPEuJ0u9B6yujihCn7a2qTDQ7WGSgwh2f4a+kqTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRt2mpHtqBUQEwpYTcZxeN7e22kn1HBl7EsDYJP5O38=;
 b=UIeJsBPtDPMga2eTW8Q2WtGzmViD9lAT7ycs+SL87ihUJpjSJuFjLq81/soiZ67dbwgzUYyNMK+f4M3FVVU30LWWvWO3McNgJAfP+dIaRZG2CdZlrqVasTwovnFzHCNk+ldMhZUKRBFAmwmLVyJ91QLE9FrF1b1ZzlP7+ONPqLNfFTSJGVm0YxcHwx4s9+lbX3fq1hgbMJBt0QA4yZCNp9v+q3qmOu0qK5H/CNdznRfqWG4u689UBCCaNMi4kFJ5BjuOfiQJTwuwWHhiIb/64WTHDdd9u4N6wxElqOV2w7vMy368oUEqRPFLe93xC2sDLy01AJNXDFF5+meL86YHrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRt2mpHtqBUQEwpYTcZxeN7e22kn1HBl7EsDYJP5O38=;
 b=Xj6oaKs9QcTKYF/jK/GDJPi2+NbeWL0MfImlPncEWk8n+ndjSIUNehev0VGQSvCx365xeOAzH/qESFfOAz1ORwxdY0pRj+XFn3a9m1TlvQKGToYNWnS0lHtJPDKjjcBwbGYjC9HuyF5eSWYWC4147Nus6GGE4j3UUI2fvQtF4DhR34T6agToTY95eGGPBCg5uTA7GIBDRhvMr5Eep+j8HPRZE5Mmn05qrd0D+6oG5jkKtZf0JapwV+u/aCEp20bAL7cshmri+gzmLPRZYykOJfr7YOdMb8jcxRoNCTi+dClxYm383Wvwm+t/8fmIITwACGCBMwfHQT3WNPi/xZ+BXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB6807.apcprd06.prod.outlook.com (2603:1096:405:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 04:03:10 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 04:03:10 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v3 5/5] dm linear: enable flush optimization function
Date: Thu, 16 May 2024 12:02:34 +0800
Message-Id: <20240516040235.115651-6-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240516040235.115651-1-yang.yang@vivo.com>
References: <20240516040235.115651-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::22) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|TYZPR06MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: b55282d8-3641-4abe-d945-08dc755d19de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|366007|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ro2YuFHn1bkJC9Xmajkui/McbYeJ7gqshFqOC1ccRZqzy23xlpLr4pF/I9VL?=
 =?us-ascii?Q?tAffn0gTBYgGkxEmZ6w5wd45MMDwUiM/V7dI0gn2cPTPB0qWW3rDDBcspIDA?=
 =?us-ascii?Q?MviWqXh7PLHWYTIHQb2Y2ptwHYJcg/8QoGKmvt7sWmUJVDBrRPSv/f29cD9V?=
 =?us-ascii?Q?ObH2pygHDEwSe6IF1v3U4HTN+7S3hS+fRdu0W3hiX53lT2s0lUZLGSOazqO0?=
 =?us-ascii?Q?JBirwoGnb6jvfBI+/zFfHAskWwuxVHM49kk6LCm+xtO29O0IdzMNt4v8Z/i6?=
 =?us-ascii?Q?fY1vRe4S6DnpvIfMXG+M+V88MZj0a3eyeoHkPu3OjNf/8EXz9OmwEi8m0jbt?=
 =?us-ascii?Q?1rnZ9BHfI0bAQpePOGJJtR4ARXE6X3+K3aZtE9jbQVJAJvl2puY7qVxZfsxx?=
 =?us-ascii?Q?FSjuzGxsJa7eZTtyLGxNpkFWI/YxOR180gPPy9X2fPIaAzy5FCMczQrcdVm1?=
 =?us-ascii?Q?rMy+YnxTGKu3Gm4/zW+HwGE+pLMOtH25K98UdiWquYNdTiD6HBXSI1WuZfTP?=
 =?us-ascii?Q?nO1Rz06p7U0+mHSurS9qY1ZSPQOka4V7jBCB3LCHBYcpv6cxtKHgjmdPYF82?=
 =?us-ascii?Q?jQnedA3mzzo6KiebLY9JmUl9tL7vLbv90KnbHxbygs1kAppdYJp1dOqOG0Eo?=
 =?us-ascii?Q?vgSDL8Bivwt72Yl4p817UQuaGMRsp/wxy1L3hnNgy57BzWjMy+wR3BF+ABLG?=
 =?us-ascii?Q?1HToAKVmA9sTdxyxKEGRG84ILq4OmlsC5weyFoIQXXRMh3AYqraGUYSxvJPB?=
 =?us-ascii?Q?Uv+fsvl2ThofmIetdNP0HyEWZzTge1BkbYHPznOmAkxciEKepI9lmDjPnILZ?=
 =?us-ascii?Q?i7TaSEROgA/K8AdX55cf8xgFiZ0JSN+zAVsQcoXMhCOwiuMFZc6IV5HEWM60?=
 =?us-ascii?Q?Jj+b+uj9h9i0N2Qnxr+bnpWjkhGSLCvwp+aUpg6KzpnNjO0cmkvTq9t+tjF6?=
 =?us-ascii?Q?ZCQU2uSeZ4bqw0yQxF4BYG+W+VcqX0brI1cNMK8dq2TYf60Tu70PFFUct8CF?=
 =?us-ascii?Q?nubd0zaRn+BLQCJ7p8Yw7YRxAcX27tIJbtrdHMC4r+Q6HFcBB/7zDr/PPv5X?=
 =?us-ascii?Q?795CSs3/nQOw9DGQ4+QgG+hl8co/ycByWCdQIfTYXrWHCZkSMIs4IJ9pCV0G?=
 =?us-ascii?Q?Yy566oDupxPoIVueEy4XW2Fzo5+kaWe1yuBZyZVHcFqlQjDzTQMxELrGH17x?=
 =?us-ascii?Q?XtiDJwb+J3hJD1MhkeY4+NYHlUiJcXsirhzo+8fwhsRQXBXkBNhFgJloWYEQ?=
 =?us-ascii?Q?uOJRA4tmyAA+6l+Mabw36goZRP6ug0ZZFuoHzByazM+aWeTJa62+IDyZ6ddf?=
 =?us-ascii?Q?tWFdhOlXlhNvACys24VX7LcalwegRxGJKeocCq2rEyfbhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(366007)(376005)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FEISBvIKuXMhCI4kcbj6uN9QzQRVKwofGsVYzIfA7LWcA1UI9MtZOxVqvL+Z?=
 =?us-ascii?Q?tZLkL7Q4V6f9KMmcKz5Pwx67Tl0hM10PZ6qM8ATAQQ43SppvVxZkBk6Zvp4P?=
 =?us-ascii?Q?fBGFKyvL2U7kRQPitHgACIRQXmPNAhTeseo+n3LPoi8nnv2rAQnWyf0+ruRB?=
 =?us-ascii?Q?wTsqW0siKA0lxjPoOlaKpNsAuXWiBGotajD/22up6KB9bEl4hql16MaZpYSS?=
 =?us-ascii?Q?eSfAtyYuQDWbA76LHJC6La8s+qPIH88QFqATg859xusqohT2wLqxaBgHhK9i?=
 =?us-ascii?Q?mBUf+FluuTDiO4bVp2CKgiN1Zr92Mbxeu5dnAnRPHEcpYzfhxSJr9FLWxUe/?=
 =?us-ascii?Q?3b2jzaUHglw3PHkqDY1Z+vDUbuYJGtZOaFqKWVHsMC22lHiEgSLjc1fe5Wkj?=
 =?us-ascii?Q?krj+kyBrQtjrRSOmxKYqJkpJNgMXFn/R9YFQ5N3SpWUPhvYYVxYsVh9OUa9a?=
 =?us-ascii?Q?gEEXd3ZACfn/+HIqoklncKqti3D2SCJ4124LjLiOaDi/AHWsl8gESD0Wgz0x?=
 =?us-ascii?Q?8R1qtJKXdxC1Rn/PBFfaxlE1f6qCJhaCIE8fpdPbIzaK/f/OpoCe38NbBtxk?=
 =?us-ascii?Q?c3oIUeHVu0DQc5fyPIIgtCMHrjjG7bzvTyhECev/qY/8U7fjS9U8o/A6LsjD?=
 =?us-ascii?Q?efoxqmOMrvzZvZH+8SHbypV7wxZGBlqVjhnjq4nsz0OI516gBXNRQmRwoT3D?=
 =?us-ascii?Q?5HFtBnnU2ayir4Ee2l260AKAeQDi21HaTkiAnndou31SuwSCPlBWq4Z2CACe?=
 =?us-ascii?Q?qq8EcdcQGxauZtDIKJFX3/Ahng6Gwt3I1H8i8QGp6JWfUKjhfaydbhv78P5U?=
 =?us-ascii?Q?Ib0gzJPrEWOlYcoLzBok8rtwDrKdi6S6vxMkkSzMDwzpuxfd/qj/v5lewNLf?=
 =?us-ascii?Q?EdYL+idLIB7NeQKcYMm4kBuY/zBqp2ktLHLTDO073fdL5pK3PQXZUkhfpJww?=
 =?us-ascii?Q?7LkzSkZ4+uN2W8S4Tm3O3Tfie5qkoIa6LlogGrRW6nKLgKdZkdap+S/DqC5H?=
 =?us-ascii?Q?sYr1/PMt1cXg7Sv+plxAXJGnW0q15v9oBEfrxiKyiipV3X6u1xmJovSU6SNd?=
 =?us-ascii?Q?UVxv4Pp/guNKNV3AHqKOE3gyHQR2vUNvwMYGupZc2vpwBoK46hXCL0MCkwlb?=
 =?us-ascii?Q?Bx6IkgOm+1wgFieXgCPAvjKsF2RxzWj4+cVwiVNtcTrx72WiaCMpy7SuJ+GM?=
 =?us-ascii?Q?nBRxBKtZo+IrLFQNtbabIo7schkrb6d10pnurhbBW/lM0Tf0k+/TV0IleqSR?=
 =?us-ascii?Q?jBzDe+NSK8ij8nOmuYN4gxv08KBkEVaTftCLIqNW/87huAlF2XRY8lrTSvhI?=
 =?us-ascii?Q?nxyhJRWS+trtxm71ZnTll6isd75EnTctQriCGQ4STvcRC1ZGcKNmNQMba+vZ?=
 =?us-ascii?Q?kjmUdiatywM6liYZnur/CLLpFQ0AyYDhs5foGUMCy7fdykqa4Uw7AdMBETOR?=
 =?us-ascii?Q?Y4jfNeaTrXfzieh1uDc2mNObYERMi7QX1PVAK/rdhQQxn693h+TA11J/JQF3?=
 =?us-ascii?Q?Ks3BgHZJnuRZq3rfkdJSuL5HAqOHLA2L8gV1xJIPFEjOBFFOgmqBcXrDwLLD?=
 =?us-ascii?Q?0V9Z9w4ev2R80pTDlqnCSNO4owPJh33kfcPyhfww?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55282d8-3641-4abe-d945-08dc755d19de
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 04:03:10.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8T2KekCUOq9JoTndhiNvgS57k9UpLFQPcxZw6qvZrvkP07lh+OlnNVKk5G4eXilhNCDfBb4jEXNFq/WeQdP5bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6807

__send_empty_flush() sends empty flush bios to every target in the
dm_table. However, if the num_targets exceeds the number of block
devices in the dm_table's device list, it could lead to multiple
invocations of __send_duplicate_bios() for the same block device.
Typically, a single thread sending numerous empty flush bios to one
block device is redundant, as these bios are likely to be merged by the
flush state machine. In scenarios where num_targets significantly
outweighs the number of block devices, such behavior may result in a
noteworthy decrease in performance.

This issue can be reproduced using this command line:
  for i in {0..1023}; do
    echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
  done | dmsetup create example

With this fix, a random write with fsync workload executed with the
following fio command:

  fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
      --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
      --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1

results in an increase from 857 KB/s to 30.8 MB/s of the write
throughput (3580% increase).

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 2d3e186ca87e..3e1a33b4d289 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->flush_pass_around = 1;
 	ti->private = lc;
 	return 0;
 
-- 
2.34.1

