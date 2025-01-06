Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEB1DD871
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167314; cv=fail; b=ouo6qnqMGKoYtBuVmS+OTLD3tdd74JTe7MEztU2OVQIWyIwc14KxreWxVMh8vZbOdWc9ga+WeGzgwdWw0gVFFW/y3Q3q45otAOu83DXM+5gn73hUo+OIinuW6V72N1u+T04uU4kKcb7vO15fi4gmA1RWq8FPgV3v9q8n4GcAI+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167314; c=relaxed/simple;
	bh=mjTBV0NvoYASbDzEOfAgJ9USzJJSlHYH4IzKVILrZ3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IiwNuXML5RhdMPsaPSgX0h7HkRDdGh0hHXy1JYNzJVIZIEDdDSC776npIxlV1Zyug9WQ8F6frPZE4wwWAA7Q8MP4ukAgKol2qweqDQoXaZjAv1DNxVs/5/OiN/SGq7f+IaVIXIDPXU35XDczxCxhAPmpEeQEC/69LLWUnfxK3XE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jKTYQPHD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WALSxV9l; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jKTYQPHD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WALSxV9l"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068tnm4019244;
	Mon, 6 Jan 2025 12:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5dzqNWVwztqjK5VjNo1kKu3j8emTw6TD8G0pkZ+lPEc=; b=
	jKTYQPHDLLfQgR5Ib5DNNzmcGww5TUXdsmqdsfM7/uXVW65czQiEGJbkFByV7o4K
	WpW8vB8nU7WIXKB4BpNxWKadww6ZDJJENhhWW3o5ujEd4jewySIqwBh1H1Iu5/lI
	Qq+mFL9zsZ2Hm1eX9fRDq2bIOHQHp/hDKNHcS9GLOGTjA/UN6tyvJoaOduaqZRjY
	xcNrdsAXFmqBv9Zj3YTXoV8wNlQYLDGKwF7vk6Mb3Zu42HfuLJY6DpuNhpXNFJrT
	Tv/P+B+nVMN85rAAu7oPZIKbOx+8ppUaMymJVlcJn5qW3AZ32Dsbx85MVkMT6EpY
	IdY7UARV3SopQvwovAxHOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1bt89f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506CRHYC022790;
	Mon, 6 Jan 2025 12:41:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue77s52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKGpH+7KxkOIxD/fZQzDKTvTzMA+u60tkewEA03GLENEg+2fRtmQzflvlyHFgrLz4HddUoEMKK2Sr1Duh42BjTuyJIaT0USkCfItaqTcbA8OjXXSIj57/eNSHHvu7TVl6lXMbGKgAyX7Grd4kvF1JiR2EUm7t3aOdGAVzvZ16nBq0UMD3aPHHzXcKO87L1/63UDbNNVvN/0JVdzWMZmoL6nt7J1FqOweVBS2Ms86HHa2Li77peFOBX4FtvzyNPVJvjCN6l00UNYAWlOVVn7yKaeVfA9NoLsFFTDbsJWpSKP0MMWvmTTjWEgJu6aZmKNjj/tQj66s6XqABSh76FTlbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dzqNWVwztqjK5VjNo1kKu3j8emTw6TD8G0pkZ+lPEc=;
 b=O1qq7MgoH2ZBLUu8iCnuhPeoTnLfZt+/tAmmpLp9YOdkrwDWu5NJKbjQhEae9qaS5sdBEH6ERlAAQcGiuJO46BA39rjv83/VyZrDqJE4r9YMZ9D2pIWC50Uk3hfbXCWSUktLV6PPzQR7Zk6L8yyLhCDMuVJ+LAQHl4G6PS55Q4Qm7LVhMoumf+pVXG90VwswDSh0Spzxmx3efEmngy2DvcI4D1MFCwcEd1azVjcGo3SrTMCw+cgq2QQGJX1WhU+zPbiB1JtuPneApYvmZZkk4UzCbip22Tyl3Jqy61pUDCjRwRtAElvnh3HfNwNf6/gW2iqY8cSeAve8as9WLpmZFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dzqNWVwztqjK5VjNo1kKu3j8emTw6TD8G0pkZ+lPEc=;
 b=WALSxV9lNbbY5luP3Q7VhtWYB6YD0657WhZ80IdWtXPHmMWZP3CWCImuraDEryqn1Ya6tAx8QTWtx6Lq5hKQYwxpgYrkM7KljgdX0l4ByHDMtT2Yb5Kvw8jyfxOshsBmiJoUjT3FkpePRREMsemijDb8hHzfMUkHOuPw1ul0u6U=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7662.namprd10.prod.outlook.com (2603:10b6:806:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:41:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 12:41:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de
Cc: mpatocka@redhat.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 2/5] block: Change blk_stack_atomic_writes_limits() unit_min check
Date: Mon,  6 Jan 2025 12:41:16 +0000
Message-Id: <20250106124119.1318428-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250106124119.1318428-1-john.g.garry@oracle.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0537.namprd03.prod.outlook.com
 (2603:10b6:408:131::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: bb78f2c8-aada-417f-e2ad-08dd2e4f75de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OLiNNg8xivXjR6Ho32+yF1nGlUWzwTBir8Kxm3oNkftUZl7lO9VY5FZ+bNyE?=
 =?us-ascii?Q?5FfQBA0gpI26S9zeSIpF0KKNbRuTmE91lMvQ/P4XBg6h6akLJKXL+zx/KrjR?=
 =?us-ascii?Q?ubRMIy7XFbLo/GpGF6n/lM7FmYn+RsHguKlw47Z1oo10tvLLqesv3laKo+VT?=
 =?us-ascii?Q?206MJXTiQIl7UuHT/hDveWEakeCQM5onNVQFYwpbXH3SlC/dIjV1pSOWGnEg?=
 =?us-ascii?Q?UgIsxVfB/wq2xAbpmtmO1OZ2F/rVKdEo0DvZ1uT9/M2WPtVIAkVK2Tr6CNzL?=
 =?us-ascii?Q?V+N1lpjPPu7VzzNkaIhbNp1Vz+74kddVrcdL6aIBX8ZukfjNh+Qp0bTmhmR/?=
 =?us-ascii?Q?cgv/7Tz4u5trovXOD59DgO8uaLlr941swf/6OQE0bTWO2iQpCiKm6yGvrtrk?=
 =?us-ascii?Q?POeeagJ21yRkhwJ3LGOkdWzJsTLvzGrQs7cF8udE3XLpuUWVQn94srnCbKvo?=
 =?us-ascii?Q?BNrfFN+Ln7SaZyFNsMCWZIwPHMevtVPkWs4K/GjUpWwBRFKMl1v90ANhrJvQ?=
 =?us-ascii?Q?p25P+47DmGCKL8XHrTb0DEGatBr8mWrCTmwBmnZ+9baqWoHLnmPLzOsPTw5z?=
 =?us-ascii?Q?TAcBqZJuN9bH5ynDbCCbD1h0EozTqfJNi2se3Oq9oG1X32H8VHTeJG1CZiXf?=
 =?us-ascii?Q?eU1WJw0oRVzsfse8W0OYD1nvUjKd4u0rM2wyRUxVMRrmJVMNDjgBBBT+nwOS?=
 =?us-ascii?Q?ZLy2VpqQr2F8NmkcEciQc9DG34fL6CXUSFdmaNhIh1rmX2xb0hNRW2AN988a?=
 =?us-ascii?Q?WhZnBtKTTnDPPGCIbCSg7tMXqM/w1HMomtcMXfJ3vvHVI3P2Z5zpKNUHjJMa?=
 =?us-ascii?Q?JmbuPGD/z+FMs/wZ92+RFEGKyPI46eb9R0aKr/xih8ZqhFH+yhMBfKfcoT34?=
 =?us-ascii?Q?4qR1v8EsG+7B+wnfkkJccci5SifxxrWQmOSaGFrASneLgpVi679weNpRM6Rn?=
 =?us-ascii?Q?MRQjn/BWNPev+mDItYRLsj/EjsQ+n6OUQLWA0YKdIxe+N6m0m9D/DgsOKqtR?=
 =?us-ascii?Q?dqbIfXwoRIMHE1CU2APGVjnGRrFbTAP7EHvxVc/K0UeuXm2BNs0sfxW4lKVs?=
 =?us-ascii?Q?vcdx7vD0h/FN4sIwwF4zNiN4KHmLTILs+2uizg6524vaU9RFqmsmys9iXpwt?=
 =?us-ascii?Q?g/L3eWEUXJpCtcCBl1S1jYvl+NLB0B5sBAfkIs1OQuCXZ7XKIgjdxgzBqd35?=
 =?us-ascii?Q?Uddm+Iz9MZ6CkortLI5vxGGLEjyYQtFAtM75yJnBV4ozBOFU1mhOSq/SeM0H?=
 =?us-ascii?Q?UB5W1/DDPtAvubNHu0Pms2kEmbV7MUe0iL+1fnHikhqircyw5HvYiDWskRvf?=
 =?us-ascii?Q?yQuE+Al4BkWS69C98micwoyfOlifDzNy1wlvxdjJ4aZZ/y68g/DScsnXImX8?=
 =?us-ascii?Q?zl8KK812wpNN2tY9tWSZQKD8dmW0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yjhsvaJpdEK+H89vmMDLI8JcPkdUoakz0CT7iCIMaVpAIH2hy6w0QQe7rxM8?=
 =?us-ascii?Q?gcA82TtCzRGWLULOVJPZ99TxAgnYqbvFyxnajvom7wymj4Z8hCG4M3IH70KD?=
 =?us-ascii?Q?VxD1rbSUnHWs01R4tBwYOd6F/4d6U8nvfSMbRbaQc4BcTwSAabMmg8xFR6Kw?=
 =?us-ascii?Q?vsmrjCF7wBAkyE0QWWf9AsKEjO7qIolP5aJ3sYUMpMMTQbA2sZdG2uQ3mymj?=
 =?us-ascii?Q?Y1Y36TrfK7bant824wNbpfuS/KTFeQtqpKm7tc4mdTMlVwsm/ZPccWGzFFWR?=
 =?us-ascii?Q?fJl03S3JQETWK0OEUsn3zWMlZ/F82sSrisapTY/SEiSV/ynaazk06cO5qzS/?=
 =?us-ascii?Q?W0dAbEGWafN8qT+sa6Ymeo1cxspJ5HyDfd5egdh1J8AXeuAnork0VZFQkYAc?=
 =?us-ascii?Q?cAZ2RttsAKZD8wTHladaLteekOcrBMPzkRm7/sPA0v/9azdStYTDQjh/mDMq?=
 =?us-ascii?Q?Ka1MgsXG2a6RmNin1BVrpIeXyOKSS3Icy3ESI1TSZfznlQnhPlPkouqyvZFm?=
 =?us-ascii?Q?p4abO/uFkf8ji3KwoH2T917Xa/7HxtH0JK2D0BjMqSxEwV5TSzxA1eD4U1jz?=
 =?us-ascii?Q?3MmsNMlwg0WTYWEmyaFzM1uiik4XkGYZugESjWZ8oHYa2Ef2hrjgk9Px0a8s?=
 =?us-ascii?Q?wpY8nWEv1cH6vvXnk1pEdvuIvSXwflvs1rwGrxPWRCwUTLJuv+OEKGqfMoRL?=
 =?us-ascii?Q?prGrf/vV0sM4atlqbB/4XB07ktf65eZ+/1jMTSocUR3AlVoLLD+Y46/FP54n?=
 =?us-ascii?Q?FpMS9RVzayoYAHGBWbXeBNB4T+0WqrB5moFgJokMKVrggUvLu+wB3nh8hGj7?=
 =?us-ascii?Q?/Eif19Sadkq6QJZ+l3Lm07cUmfJ5R+ZB0jaaD4EhS6zjQ/Ew4U+Xn6fOewtW?=
 =?us-ascii?Q?0ZiT/y7x3lnQqVN20xWRK/+4znY5hNjU92ibt/pzbp0QAiIstSY2+UitZmCO?=
 =?us-ascii?Q?cT3Et1R8uy/rpU53a6V3EKIuCCi/dWJ1gUXfNMmDlqX/5iQHXNqHGRmLoo69?=
 =?us-ascii?Q?VXVkXdfytKMf85BIOZRlvrFHu+xAS+aZnDG9U8ADpo+1jb11Jn7yfGIlUJ9r?=
 =?us-ascii?Q?Rizw0C3dLkkz/3ZQ+ONGXmWKda7FE3PYl0ZySuCvKOJ128mNvJS7trdfvBPt?=
 =?us-ascii?Q?71NhXMdrHFjUJ9bDegitwE7H6YSP79J3b1lGfYbKNOJ6ngBX2g2jmpiRhDPD?=
 =?us-ascii?Q?i91CiYk6ZAtEEY4QehXTucpRsn1tJtKKyixutJ2m0ze1/AdatZdh89VlTj5+?=
 =?us-ascii?Q?XqjqA+IrC08thMVAzigG4hqVytLW1/YFzHoL2XAN4lltcEkLMRymmYWY3hpK?=
 =?us-ascii?Q?2Tx8v6l0XU9gnxXZxvrENvR/yO96gy6983LFI5+Sg8dQBAcjGWiWaq9QvDKP?=
 =?us-ascii?Q?KCKbBY4CeETsVLupbMty5W+3IV4TIh/U4QZQbq/Mm1Pbc0r3J2ZknDE7ghk4?=
 =?us-ascii?Q?Os1K1NNy33d6mPimZVL2aXA6vH43AJCLajn10UnQkc8dPbmlt/EzHeDILStq?=
 =?us-ascii?Q?7fbO3dSyLAHjXHvrmE8d6lE5ZsxN2oZ5uxE9oJTD4yGH+bx8isa9JH6nzQXW?=
 =?us-ascii?Q?2Wq1mmd2ZtAask4St6vqCs0CbM7fuv/Hpnbo/qZ1TkeT9glKo5eelevSShBZ?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VdYyyb/SDGfcN/kaYMR+b8dgYYGE4QmDG5kyF8JZvwjVY/LBOfPz52hfJOHNpiYZnrzQ7/OFTt5JKSHo8z16S0jjS4GkH98uKuvXNytenNrk6JLxs+EBtqEN/QNmvFEVK06wB6r1yM6gogA/dhzWC/A6uxvi8isY9pcmSqFZhGT6Xv8LaToyX7dhszU4XvAktFuyCZeJU/1/UVUO0hxhdcEzvBtHCkHLcKbY+ttoCZ95MS6C+GQInejilAtlEhTysP+rkmmlf7ORnGk2RdKTovEBWI9yRMtSLnNTCdicsrfRShcjYp5CmnGuy+81ZVk8g1SXJ/i2Iodf55GKdzG2OK9R1Y8uQ7ADlddRmYOfc68LLCwoDeB2xl+kuP3rRLVtTHkaTt+4nDYylFU2EtEbqTWixVy+G62+A19nr2WwbCsdcVGoGlBlmgd9k2zeeW4X9KFYe46keoahfdc6WHHwoQHWoKLo20d0omm4bs5OPVSXv5ca0VSpfBjYPb1aceum3SO7/Fdm5MSRq0rKYveDrt3iwiSXHAfBUw/HUAHsvi+w6PVo1gVhISdOcjvro0cOyOezM10W3Wxzf/bYZ/Ej6fYhgpDN6fB30HPcGvLtnbw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb78f2c8-aada-417f-e2ad-08dd2e4f75de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:41:37.2765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1jz3eYH/A/dlJldRA4u4u9DdZwI3imncBrowHcgg08GQDPmONq8cfp3MwMAw+3EgIv7m3V/+lpakTZ3+w4ogQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060112
X-Proofpoint-ORIG-GUID: ZDEDZ7pKQcUeA9TfBX1sYBBq6Exsn_1d
X-Proofpoint-GUID: ZDEDZ7pKQcUeA9TfBX1sYBBq6Exsn_1d

The current check in blk_stack_atomic_writes_limits() for a bottom device
supporting atomic writes is to verify that limit atomic_write_unit_min is
non-zero.

This would cause a problem for device mapper queue limits calculation. This
is because it uses a temporary queue_limits structure to stack the limits,
before finally commiting the limits update.
The value of atomic_write_unit_min for the temporary queue_limits
structure is never evaluated and so cannot be used, so use limit
atomic_write_hw_unit_min.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a8dd5c097b8a..d4fccd09e237 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -589,7 +589,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
 		goto unsupported;
 
-	if (!b->atomic_write_unit_min)
+	if (!b->atomic_write_hw_unit_min)
 		goto unsupported;
 
 	if (!blk_atomic_write_start_sect_aligned(start, b))
-- 
2.31.1

