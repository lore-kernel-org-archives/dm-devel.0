Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712DA1AD3E0
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 02:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387275; cv=fail; b=UjPcOX43xh0BOmBZnxSNI8ZUPYQG/W7bAC3hOIxq9mlb1Y4iBQXRGGc/Ye3Ukqz4lWZF644MalA7f0YuBKNIAb3KaAuBRrq9b/ytRJ2tcvrsbCja8PSQy0eIRbB3rGDJqHt0zN3Hh0Mekaurg9z8QoWLHwEoca1wHeY78rvP3+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387275; c=relaxed/simple;
	bh=u9J2PYSnqDtBWejAV4C2RzBUQtYP3iHUrM1GwrPuDuc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=R7ByscGY63T6oWcNA5YxaQ2nW6vDzKt57IpMZjQeBOpCDp9htovm+Hoo8OyW0FdAYdL2crTZWb/n80CwMyPCgDKbr3da+X/zRayV/2XFYGOuuppToZNom06HgclNdiT1g9cs0dTmUTU9KqMMhNpn5TyRmTdPS2dw3QNa+2xs+Co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JX9Cj3ju; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ThFPWdde; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JX9Cj3ju";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ThFPWdde"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K0XhYX009759;
	Fri, 20 Jun 2025 02:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FIDqm5Hq/P1rzedm4Q
	0NVMElavYF0kc/6fWjzwnlWBs=; b=JX9Cj3juJ9xI2PHMdCsz3MGn1+gEYEZgmb
	52YTSMIuMEzobgLj7pMvs6whMYZKfoTa57lY9T6LOxjM/xeuOIPCAi24JZjgpWXf
	/6G/miKTxZLjeq9EFpZx6FPyUrQV8+dAykld6o9VXMbVbEqQLmB+Ovq8379/ty0m
	8nM+/OfRNJ+/HwrPJKfp0qKWwaGH1SwIAbnylFGG1HaaOw2UbX6ggn0RDoQ+lOg6
	+B6ABTeWb59W6qWsD+rDzpj0LnnMLX4NZ6+KcPnZ3X4rdi8hl4W7QEm9JdztmiCL
	N2UadgBmcRyxK9LOQvg05oR4TyqeRqwKQZ2DpIjgFFWlJhyb9Jxg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914etuma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 02:41:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1FJoL038193;
	Fri, 20 Jun 2025 02:41:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhceevc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 02:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCrbQsqo9x56wwiePMldOhhQOnnuRn1Q/dZICNFrfsMJL9wK93+HB9UgtGrcv6YL2HcDqfFPrWdOJxyNgLRmO+4CI2D0uYmkqrd/sGtiBvxI1CDrBH73TyuVXB+mJCNgd15U7pJl/y4Ev5VzJQfB1P2Y2c80sofH6wEOeEko6jIxVbSTEQ47hb/mMIwieP8wVJKF9v9VaW+mj0zmUe/kDdSlDmblmMnPf18neBlnQRYjZwsdPIEFbJoWnMV76JAHfN4f2dCh6r1JBRG6COiyYZYoxBZ69dULbxJmTa654VM/whMS84HH56p0Qcrae5Ltl07xNXyOqGZKxBzKX2I9hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIDqm5Hq/P1rzedm4Q0NVMElavYF0kc/6fWjzwnlWBs=;
 b=TL1kkGF+VlXzgzUapFOcQH+jumR1CZFt54zSanbCoW//6A4lh/XGSBgzrwf0F2PMBS1o6UI4xfxN9/f6QCk/9NHz510qMpcdhfyho/2ujO/2+3/W/ukeCJKhqFT5prHR+UUfBTOFqpbhcymXOWEbbvGWnNm861RLVPUVjfR6lVT0u/xjVHqGKMreb3harZdR5THNPKwRf+IYZaMbr4kYfv6hNkszy505wDEQO7dh5k+P3oDY0Mry9AoNwPYcRNQy8aT0fddNcCvV1caFtreaPVCKsrY8WuNqTfOEm/4/ai4gfm2GSiTv95kBSB3AL27KrktiJEmkJB1yp0RjYgN0tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIDqm5Hq/P1rzedm4Q0NVMElavYF0kc/6fWjzwnlWBs=;
 b=ThFPWddeMmFWazEDz4Ge1gjGXbdU7Fo0QIsuUW9gCPYBPaZnFtBlCan6FX76C20DnI9BxHrMpO9GfUFfERP/vtCIops2RF+Td5vNdOtsCsQjEIPb8/r8a9CzZnIwj12c+dSeKUq33jWvNgaaqcdqa04rSr6PQl5Kmv/gcADE650=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6452.namprd10.prod.outlook.com (2603:10b6:806:2a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Fri, 20 Jun
 2025 02:40:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.020; Fri, 20 Jun 2025
 02:40:55 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
        <song@kernel.org>, <yukuai3@huawei.com>, <hch@lst.de>,
        <nilay@linux.ibm.com>, <axboe@kernel.dk>, <dm-devel@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <ojaswin@linux.ibm.com>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250618083737.4084373-6-john.g.garry@oracle.com> (John Garry's
	message of "Wed, 18 Jun 2025 08:37:37 +0000")
Organization: Oracle Corporation
Message-ID: <yq1tt4bt9y5.fsf@ca-mkp.ca.oracle.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
	<20250618083737.4084373-6-john.g.garry@oracle.com>
Date: Thu, 19 Jun 2025 22:40:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b4f5dbc-ea6b-4af8-a201-08ddafa3e109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OD1+etAoVj2Y75z4ap+IEz4dzzZGMi7wLy30aIU7iq50p+m6Eys+I201NHf3?=
 =?us-ascii?Q?qz16XNN14pzZGNdasCv9C9Qk19YyQa+DnZIFKoXKsQA1vdhqT+0bqsdCsNR0?=
 =?us-ascii?Q?zWJIj0AOX46xA0IPx9rR1KHSOzreCAklC3GO/xTEaUAvfHImuggBmSqll7QQ?=
 =?us-ascii?Q?H+BDNM6X/5uPSiecfC0lMatM7K8ryCcd8rKpWnUvC90CK5qWsppRMo40dag4?=
 =?us-ascii?Q?iFfYEB98cbfr82sKU/pxPqsEGOiDeQy0G5wRVaaG27GVEs7ftisv8VffxoMK?=
 =?us-ascii?Q?4D61ADFQRRjlDZNf8eNU6sJ0moxXPf3LJfB/7Uj366X5CgJjrwoNLVBMji4k?=
 =?us-ascii?Q?QLFzarPBFpSLq3moxaiyIopbIpoaCXXtxFBYB/6Fdl9/xKd2NgvjPqAhgJgj?=
 =?us-ascii?Q?n5RS5QRbG7q6niTZ85XPSilD8Dp4e7krasP/NAC5YBiI+oJvQweHomABBcvr?=
 =?us-ascii?Q?ndCKL3I42eWO6l4mmZgUhNEOfUdRtN+4DDiRti3iM1VnX4L6HbB7Y4RT1UnG?=
 =?us-ascii?Q?wzi9AsdMg3JSeMK3RJuHZU4EwyFufN5tOHKLEyQXo6rf8xOCgN3PNmdFR0HI?=
 =?us-ascii?Q?CesbSHlJmiuhVc3U4zBpmajlAZuwze8ILKnZuZHcnvKAKxJXHyuzSquVYFaz?=
 =?us-ascii?Q?/96ixckhijbUsOVaSK9CwBjepkXVNx3ReJIqetqT9R+S4RgEQqX5MwRNBCyh?=
 =?us-ascii?Q?xvLKyys50eqKOZ0Dh0XNs8wPyqu3n/EgSXY0ZwuGiL3/6c6OTdnX5Ey3NxeO?=
 =?us-ascii?Q?Z4RC/F0Fnko9z0t3EtvBmVCUrDw88jnGk56GapAHtcIkAPZPy02zdc0lSDKM?=
 =?us-ascii?Q?bY4/CYkg5GZA4meTbyN4JyW0Jt5i09gvOtMqk7uIApJ6qLGyKJxMTTHalUek?=
 =?us-ascii?Q?Hznh4phtutmgQYzguHoGiYVevbN/zk0pCPo2VgVym0eK7cgQDuWtYiHQGM9x?=
 =?us-ascii?Q?1BYPabk8JJQNKjghIOJQXtPN7Cy0eq6HOR4hRBDPVIyUSDjaOMaHN5k0iSVz?=
 =?us-ascii?Q?icPvvddMvv5N3g3zn7p1N5wKqkS0OyIHhFj9X0xt6KRhnt1aSnegoFdp+x4I?=
 =?us-ascii?Q?R2sdmYeKQmSHwn7gAsBb2K+PJvZoyM5Ma51VeFm++KFNNTXFrzg77a8O4pLc?=
 =?us-ascii?Q?ONDcyveZCTwOm6zzGV7LqvV+NUr7yyl1T2lxTsP0A5Yrfthso7nRfD4KLThH?=
 =?us-ascii?Q?14jo3nlrs4QKK1kDvKitmAgLTdQDUXNXR00KtJJ/eiqpnRKLQDc529KEjx0h?=
 =?us-ascii?Q?syOLWN21kVnj6spO21Z+tyRpOIwASn0x/BLsab2sjUR6ONg3WhCQ/Jm33y73?=
 =?us-ascii?Q?zMf+32nAFbhQJ/Wcw1k9IIz1ZIiRx9YxLTOeHk4XcYUJVx4LXSgeR4F9RWDW?=
 =?us-ascii?Q?KoGuZSXZ2Q+G+qV78uSvJFDT1k7bIDoGa/CThZjYNG6xmR1fOYFXvGATs2Bu?=
 =?us-ascii?Q?lI8MSFWsGXI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jmHf4sdn4KgF/VtL7vgIQ6XnCihcEhdoyCpD7u0zp0S12BcriKc3u54f+IOr?=
 =?us-ascii?Q?f+8lnBDJA3eZ/Kx4pKMRAOc0JvumI3Y9vSNNkYGTxdIdQXD+m+PnO6eFvk9e?=
 =?us-ascii?Q?1EhVm1HGJeLAmha2JpUu8ILyELuSZ3rCoq7xdGLscD4qCekrci69aYwq1LmT?=
 =?us-ascii?Q?6DP5wcAJxVOLO/z4mUyf93V45bshdYRopqL0gnWYMnC7C+Lj+3I7qg8naLmJ?=
 =?us-ascii?Q?qN24vzrLaQN/nCRgORwArhWUbo/YxFHkN5eNUf2CGP3CINEiqzZgAwu6X6C7?=
 =?us-ascii?Q?AX7ctWSIwBi00JQhLJRW56yHr6NevBq21EMLZU8xKkqyPJKRkGEOZ33F9VUh?=
 =?us-ascii?Q?A6TijrjdrVaPAK+un8vWfyiQgfKcl9T+VuuXScl/OUHvPgFMjAGI1q5nsski?=
 =?us-ascii?Q?PPFTlc4JZfGtTNMYiJo8cwABa4AS8MBPkseihSh2wkbWEChFZQ9mA7z4b9lk?=
 =?us-ascii?Q?+UUJBUWxH/RFWvQINMADsH3U+76N4K5UbRGFN0ep6ZkfT8xYBpKJyws4840N?=
 =?us-ascii?Q?wkFenAp/MZal2Mz+yhK7O42KzcI/jmtotdmU44F47eLHK6btLm5UA2arMsQO?=
 =?us-ascii?Q?/xzns6jJwdwv55TKT1kAl3bAMhajVxx8idg1NHFnQJAmaPiYngxqnjdwOh3n?=
 =?us-ascii?Q?qQqGR0y3nCNdigzqCEv33QzIArzHpAoxJJEzisQe23ZEtqBYwZplbwyVK4BI?=
 =?us-ascii?Q?UI1b5zCzTrIX0c9fl3QS2+2USgEZaE+plfyrxi95L3B0bIjluRh4vz3I7yf4?=
 =?us-ascii?Q?17VMfgzX8rgbS05nq0ZFxFwq7VYKf4tYOL7/72wbbmsWxEvVJCUsHBhVecKa?=
 =?us-ascii?Q?Bbr0XZ/Z3BioKdEJ7oNYy3M2uiYD+CApN2sYH5WFKfKqW9vxL6vzwqeP307/?=
 =?us-ascii?Q?Eiw6q5b4tsZSLDqgbt/m0rqxpy9Wl/CVUz9szUlprTwCEjyT8YQjfJYb0mWb?=
 =?us-ascii?Q?9V772/J459QuyNg2fWiQKpVO4POyZXtZzx6OnCF+9e9xFeXvRqxGsBONzEVE?=
 =?us-ascii?Q?XPOiSK95FkbZ6X0KsGg0eZv/mzTLX6+A+Aa8gn7JjBRH6lCYInJAaxPbza1g?=
 =?us-ascii?Q?Jho2X+TmY7UdZ5y9o023epasRM6aj60Px2Rr+T5iJreAAX6eIWd01GNCZhJD?=
 =?us-ascii?Q?Gb7W4sLcJtqoKju11Gmfdk93UdVKT/RmU5CpKuHcc2OsW6ZFEPixe7iWrbWi?=
 =?us-ascii?Q?0gepRK0buvSlBDpPz4nSJzgs6SUWkcyJndqxderKJh1uVbww11KONO+Yxcjv?=
 =?us-ascii?Q?jreq5csXnlNIXlkWaNd84F5nGhpJKXm6kb8m2zNlWzGx6dSqLR09W54b0F6m?=
 =?us-ascii?Q?Tn8UGjvO4Tlp9Z10ymK1aOy2aOXrOx+ctP5ITVhSV/05jreKCe6KV1Xt4G2O?=
 =?us-ascii?Q?v0taqtxJcfmtDzltkYArXewPNYDpuedszpZYqGgBjx+lA6i5RmZIfgGT/E43?=
 =?us-ascii?Q?Bp+DFZXHl2XvxRPy75wj5ioolE0auEYapMw4IvSfdSUZfy/LOC9BEjj7Hq5U?=
 =?us-ascii?Q?lEmwtrjPJWHd92lV1Fv+lKqIXMvl6NngHFQGV/fRQKBEMS1AZ4Gv0em7eE2H?=
 =?us-ascii?Q?d9UZNUl2l9NhxmLBbMwd/RKunJC265U7msCUo1m7MTCMErVhPxyTUYw93VxA?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nB7/v/ky3/vHMynjTsaNUBtFAaMBHS90mPQ8RWsrUeiAurL5D5SyxcjFCr87bCkyuX9Q3Aakd4+AaaHJYQ2wDIqL/bioaItyTRN7NQSHuoMahEvperFVNe2qQLMz75XlVai46/PXmr2cknsouv5IEV8bzC+oVF1a9fnJDKG6ThYWR84AdNyrqW4L+H14qAZWLGuYfhpAaua2IHdruV2gI4VoKB9OUDQ6UadWxijEshUz8Zu4Pfo7kTw0C9aAW0TSI8NNFPdpikQU4EVYc4aBJMoJm9kst5ShMp76ISwmgzyVnC7COS3Va8bF2IMYwWDRtFupUP0nszL+YUh7gWUfLl5ArhZeLJEoDi0gkt0DhxE2DhnyXOjsOCpniKfkGyU350ueLguunQY/MsBEO7HuEfVV3tMo35FO/xCLZwAohn7f6DtAC+m9tPXcCmh2XLgbizk07pKDjKu8hNz/Ffu0mpXOv5cADcsgz4X/bjnL6iiHGgdX1qG4jvIOwbMS+pF1I6QkKlWiYN1YOqDynADkwLheGI8BD25qB36i1Ak4dSkBqocWTWIIwmadS3PqcpGwGmvKotwwnOSdH3JyfN/3/Z4Afl9NepzMgVdxaeQyKhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4f5dbc-ea6b-4af8-a201-08ddafa3e109
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 02:40:54.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGN/EjP66D6PEivcgensVOtSXNrNJyKeDp1yzJNRldiE8iA/jK3F+qChG+sDzz+g+iHuVnQuCWlOOfugznbUkBFGWbUXSXHotDjmSmdUIWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=910 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAxOCBTYWx0ZWRfXy6aNywAJOn0J oDe7E+BIM1wjVhBCOa/iZcFOkGTV262A+C8Omyd9QJzTXdIGb5fhVSewu7P7OrLnSCjzUInVOqE 0Q+B+w1XvhniZ/ToOhDncbajZbXTtl5aEjx6ONPJiwzHn+1yCQIY0I6eAmbJNMTDEx42PsheaVV
 LfnqMzgmXk/rI/Wmu9TEien6pZ3mY1gelR0siCiGQpMsLjvl2qCiwsMoqmwx6NtG+1PGzO6GVw0 OEAX9UsmmLJ/LhTW4bYoxrOfVVU9EAgco82EOZJkIZCaB5/xaQcU4dwqdz5ai/bR123YuIIrlLn HMTkYc39tFkTToIEKQFLl4o0KTWMFPN1zGGbpLj6MSjp+guCC0O9mIP6f12Y8tBu7Cs+AOBk9U7
 qRqD4K9oESsOdDVPHtLriGZ+6r9O5691A8IbDq9YL8spDjKD/nAJgN5ISvgsVw2ga+jY/Rez
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=6854ca3f b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=W2hwjCq3PClIEuyETYMA:9 a=ZXulRonScM0A:10 cc=ntf awl=host:13206
X-Proofpoint-GUID: F-g-FjURkZrAxLbWFt1hqb00PHEJOe7i
X-Proofpoint-ORIG-GUID: F-g-FjURkZrAxLbWFt1hqb00PHEJOe7i


John,

> Furthermore, io_min may be mutated when stacking devices, and this
> makes it a poor candidate to hold the stripe size. Such an example (of
> when io_min may change) would be when the io_min is less than the
> physical block size.

io_min is not allowed to be smaller than the physical_block_size. How
did we end up violating that requirement?

  logical_block_size <= physical_block_size <= io_min <= io_opt

-- 
Martin K. Petersen
