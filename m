Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2087.outbound.protection.outlook.com [40.107.117.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874D1798C
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 03:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447943; cv=fail; b=EpwGsJFghXaPrScfxamhdt3X2eyRAQY92Mwn2g/O1Ikzar1rdAeu7jrIfQH9rEReFE7mIKF/dQaiW6qYtE3lY6QoDVnqykQ9Kqq7U94sj/sxwoFYlisw4wnPolTgsrDyXWFTAFIWppAEirNFboOMTweE8w1YmVE2yX2jYkgbQxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447943; c=relaxed/simple;
	bh=PSAuobTDi8N75afhOI9mdM9LcUe7Wj4BPSGYNK9KGu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J0k4PP6JErCt/HP5ii4YWfygjGb5s0Hk2vggWqNhcj3yVI4EF9mzVt/qZq78ivEYI1fZAjeakc58kpFiR+vFApyH9aX39WU3d1/VUWAiCIdSvYGMDPkvpa/vR2kxw4eMY3k0YvoKVdzqKPRhUdUWe4tPvtjuj1akj4hb8Zcd2xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=k4na3cvP; arc=fail smtp.client-ip=40.107.117.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="k4na3cvP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhR0LoDlCAaH71kKhGE4MX4gVbFuVCWuLFO0kNjNT3T/uoz3jNWOmvcYrTZyFVOQl7KTBRhmYDFkGyoSSyyFzC3+6lTHLzXwLS5uSLUOuLi/KLbaf9Jir87zQnkoDH+neD3wGO5rODdwYb3z0UWZ81nvP+xFYM9S1xr2ivb3K/gG1YyM+dsqVVnjZJAl7Wml7Kwq2wAQwUR2qsbdwmT50EnGtkvP+Oe3KtxLLn4IDVS9sYJWvdMtZON+6VuDYgvn67qCxcepeG6+C4+Q+POwEyw5sm0/06if8Eqd8EY+aRYEZ+OYmxEY7hiajUT+w4SEs6GW4pBYJ68yd8s6R/4Q8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yScezRngV+FPooRtW3MWm3dqdGXcxcvQ98EzExX+0oo=;
 b=d1jfpHr/3lMLuF0XPsio7CqbFV3Suz7WnUdk9VM1+7bZccTC7IdZA83sBmGWcnmKfX1wSggSPLjyHKa74kjUH5aRR3oCB/rtDIKacPdFkHplFddwZeVig7lJamYbojry47dlTp+0hmC7Dpn41hAMa34hSifnqoHWlolNv8RVPpKhCVOjH7DZYA+fZBkAKHPk7lnz2iuglc7ZhveBdWnS0zgFxd3I5q0EJDr4XOemQIkW2k8XR4Xb/99i1yTgdQbTEotORH4fZc+2YtFVHdao+cuFxRk9irPm1nw721X+ofSPNLI8TAmYI8ybCv7xpK62SLs2pjUiWLfh5jdLRCRgSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yScezRngV+FPooRtW3MWm3dqdGXcxcvQ98EzExX+0oo=;
 b=k4na3cvPrRrbiqttcvej5RKkeCs3yD5KoqztgaHiC7Hsg3T6G9CIcwit21NFsDTf0660QTBYmqQp57B51kNf7YBYH05+s0ZJjL/3jOssihblfMY/NPg2E2ufLQrEpHuz6bwZz54fmE/dOgHU/N9Uz9MUzypyY3QZggHisRZKrCdSOpLAHN/p0S3o7Nrjc2YeNbUzlh98/rBbyghFF0KUpa/UFbMAOJY8uuwQodCTmI/0Pqug3fvoCX6dziTB9FOpx/LnYF5+5QoXwDcQg9zY+jJwEOzS/IO5jNXxmzkii83XLZ4t2VU5W5xoTjXIbE5leHjXsb9xtFuOaI2zKgVPdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB6792.apcprd06.prod.outlook.com (2603:1096:820:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Tue, 30 Apr
 2024 03:32:17 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%6]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 03:32:17 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: bmarzins@redhat.com
Cc: bo.wu@vivo.com,
	dm-devel@lists.linux.dev,
	liaoyuanhong@vivo.com,
	snitzer@kernel.org
Subject: Re: [PATCH] dm-table:remove the restriction on zone sector being align to pow2
Date: Tue, 30 Apr 2024 11:32:07 +0800
Message-Id: <20240430033207.875-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Zi_sSyu7CWdFS_v7@redhat.com>
References: <Zi_sSyu7CWdFS_v7@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f0a6740-ec17-46b3-ec0b-08dc68c6226a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e8c7Dd3mu7NPnxb+KfHSFSusGi3oyvQEYtZlt1IGuz67KcRQz4vr8d093+a3?=
 =?us-ascii?Q?M2sLF9u6auG8IDm/pKbKid+trZ8ZsTPdlqfbkBht1WrqZ27c9ezVf/M5kPb6?=
 =?us-ascii?Q?hzOol9PHYy3RzDaKtZwbZ4XDqDMTmmhzZV7R4114YABCyFxcf1rUZfdsTSf0?=
 =?us-ascii?Q?DbhGvBPgGTqKdwoOFdeAG2mAenqjVOY52a9mzOERZR3bzt3tu5JtHMxKGSrz?=
 =?us-ascii?Q?zaAwF3AAcxqWBEAEeaehffnpnRGZ+7IuBqJO2jm6VZjx3Xx4nhpbBflZiEvA?=
 =?us-ascii?Q?4VHkcP2DrHUQB3mAFhcVrOrPGqLNOtTSyN9KFGZ82R4Si4bH1pYtLD2s12aS?=
 =?us-ascii?Q?1bkV5+InBCK8j30p7eiF/m+Sk4Zjg3h6NWNi9J8ZjSfyFzpGmuzAGpzrxUlZ?=
 =?us-ascii?Q?UMzLQKHZIvTcWUY/l3NjOK9YCcs/Owyy80k2SWw/xHby9Q1bZrS+5Pr5AiRc?=
 =?us-ascii?Q?oqA3ltfN0L7GxLiRofGhzMO+5N/kbFPv20vPlNnMBkOQHTwWMl9cm5ZoL75f?=
 =?us-ascii?Q?qg5GKx68zzM0UgDuahB+e8B0QMOAN8wQR05EA2QUoGiF04SliEpFMjLaJlLi?=
 =?us-ascii?Q?pHsDR2WeJLHo2WREzEeYh7XAVrUkXPEBmYNeYJT9enhuGp8cXELbWb1ZoSLX?=
 =?us-ascii?Q?nKt/g+QoLt+LWr+qAbFRNPEmvc2yMNjznZ4URn1p+qUZKHyGRV1+AUO2ZrOy?=
 =?us-ascii?Q?mZoeicykqi6D0b6BEHOBtPMo+/g/lUofitMkV5FcOFz0uDv3qdRT6k4LPCx5?=
 =?us-ascii?Q?EtYBpNZqOJGIlmhdFtkh7cHNU1Ndr8uNVIQTO9PKYjqANuL0NLuDD2NfR/cW?=
 =?us-ascii?Q?QAZTTDHTzjA7sA6vCsfsY5MHrbK74VwnQgtySwfpfWwWiu2EvwAIBZ9c7LOd?=
 =?us-ascii?Q?KpNmI8rrH5KOXribSwuuH0WhN2Xc5Y6VMz1U83uZq5EBYwmrVOrWeOeM4hf4?=
 =?us-ascii?Q?WsE6Gb/5uN9y9F+W6zWsavtpNvMbv76DoXssoC6blAFkQ8/C4noubk+hHCip?=
 =?us-ascii?Q?nQhVi5DQPQ8V0rOeEo/k9Mlxz4cL9jR9JTAuraOofjtWu9gtuda7RxdqokBn?=
 =?us-ascii?Q?qc8GhVakNn93E9ujW6qyF+kLVacSSdUwgwF0WJQkZVgMQP/2sXq8zSGF321b?=
 =?us-ascii?Q?P8pdgP03dU3DfNUNNBdUGInG7FmLee1I6MBqD1OX8wjZqLYJO0JTgqORVx4Z?=
 =?us-ascii?Q?C8cFR12ML7GvbrDFHj7xuqd+i5UhIep1TMIrK3AX1VLFSiqVMErceszxSUu3?=
 =?us-ascii?Q?3ePlgcVelJSm+8cpQcYILAwb9ernLdFRxDiaBQRXrJOsCz+FGGHDyf3kLNDX?=
 =?us-ascii?Q?NPPVoqFGmxoJtI+sd0Vva9uVYqNYidVtdn1yl/gaBNboWw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l+jtjqNGvaqGkZc62ys5Bum/ermCgqZ5G8BYMAXKH721RhFFrIr3FNMrbNVr?=
 =?us-ascii?Q?CEi+yTZuw2J8nBflS3pfBIOCvPvyIQ33cM9507JMP1KboqGJN0UctS0IG5AV?=
 =?us-ascii?Q?yNC6FdXDapHy/6RvdaALZlabxqGGSpAlkwvXxyfwbYBqXuTg9sH8z82XyIDl?=
 =?us-ascii?Q?9btW4TCviAwTZ5E11OJtMKwPjGtR+eqRvMkN5RHXCeXOzDEfrCuFKyz8eKxT?=
 =?us-ascii?Q?ToUJ/gP25LIiBMHtVoyQkgsrxxEcMxHOnRLa2cSF5xYNqc7JRTmIal9bZ+yJ?=
 =?us-ascii?Q?xtM4PjR9fRis6Aqq7mvxQROw6R9JvFYIfh+F8APSc0/blg1/EGSP0zCJgdJh?=
 =?us-ascii?Q?hRen0bADYIh6Ypn0Z2cz8RpI3HkfBlOuf8uiBzv5+p5z8bGbB/DRiSUrgIpC?=
 =?us-ascii?Q?EKud+YPn35ySvR34vOb3khi3E2tbMqHwp/LmE8yXYKxdU5G9OdrRBfauyP2G?=
 =?us-ascii?Q?kWzLHx7JKMWXuf6W5ZFG0YuqrVBzYSJvg/csInU2tHuLDpPv1ppxuL+ccjSf?=
 =?us-ascii?Q?3xs5H6Cs4ryAcnLj0Ghhe65TfETh32tY2gtq3MoxuK+f8SrykXl5AavcAK3o?=
 =?us-ascii?Q?TXNdGt6rPFKmC6dBxFidWqYJpUqu+Q5lQkbgy8WL0h1+7Jq1ndgELjDM89IA?=
 =?us-ascii?Q?+DFyYc3w3itYMVgXXdeGBv+nN2uwRPCYBjddIoyy6QPxLijAZUs+e4n8N2CB?=
 =?us-ascii?Q?xyXgVZAXoMxhs0RsdKk33v00RIkS6UX6DjsKIq7/87S7SYPitYh2D63ItEZ6?=
 =?us-ascii?Q?0BeWoDmgHHJa9qGZgqsSZFh6li8CMsXWoB/RveHI6pAIT+TNkeBTAaT4n5vC?=
 =?us-ascii?Q?HuXkdzV8pqSxWiwPyulXxd1ab7RYY48HeSqaun2v4HVNGg77eptKJAYzSoOE?=
 =?us-ascii?Q?oVi/MJMd5RYWpFEvqa7M/5b7bschf8oi7MQZhQA8ZFw9bnov1V7b7NxBS0oi?=
 =?us-ascii?Q?jTF0Qu5HArKdquRPtvxa1mMEAz0Tgfz7qZn3e3nT7B4ES6MFPHpPt0gPgSDl?=
 =?us-ascii?Q?NjghyJTIh86L9HVxk9BEZ59y4TYpAeiOpce4Y1bC/UqSxOi4YmpAzSKNbDDZ?=
 =?us-ascii?Q?sJQEiY6d4qkGHQHe9MmMoekWy17RlX8jhmvr/9/xTXK9Xr8cnXOLQf09Dt8q?=
 =?us-ascii?Q?tEAcVpHTZtIwJnBII1a/hBX16pG5ta2yptl+ajZKMGfLgh1OkkCuHsES7SqP?=
 =?us-ascii?Q?SR60uU8G6ixM6dzbgP+leVgAz/pqr8zDsk1oZb+D+E4WR0h/+RcpfIQ6fkZk?=
 =?us-ascii?Q?CXufMwk7XuJfTtt6DbhxnqepIojQGYAwZdJMXcOf9JjM/ycZ3ERoQkQrf1ym?=
 =?us-ascii?Q?2I1LIF4ldkSHJg62FTBCXf2u2Cog8akjsTBsWmUWVEpeULjXPrTmpJO3Kq9z?=
 =?us-ascii?Q?pnmXDuyVdUS87YjwNoi4ra6AACPittOgisOp9m5yet4OzSN0RouIEhOVA9hl?=
 =?us-ascii?Q?m7336Ivq19eXfHO2BbE97BwqDWrjtNM2I29eAV8Blb93gwkx3eXpiyj6RpB4?=
 =?us-ascii?Q?fyMq436ySAU27H3HTwnBikGa3gzLTyzGhBDkqUaNMiqt8rlwQ3tGHMF4YDSv?=
 =?us-ascii?Q?JbM2rOcJp60+H22XUMpeaRgenALRm+B7VaWyqbLf?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0a6740-ec17-46b3-ec0b-08dc68c6226a
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 03:32:17.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1nEXg5OUcci3RNFHk+ywk+IEriji3HiGJ4AHJx3c5cO2Y9BpEtBNlrUc3G0PDJyNqBzo9OmUF9PXOobHX23LNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6792

Currently, the zone size of the ZoneUFS provided by Hynix is not aligned
to pow2. After testing on the mobile platform with this fix, we found 
that basic functionality can be executed. May we merge this patch first?
