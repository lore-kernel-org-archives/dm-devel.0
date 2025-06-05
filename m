Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CC418C031
	for <dm-devel@lists.linux.dev>; Thu,  5 Jun 2025 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749136174; cv=fail; b=DqNzvL0tzfIGfA1HfARJGuZhMlUDqfoLNAk2cYX/VuENxL4DnG0xLipviL3j9QHQMLyAani5ZKH8zASBLet/tXXF7zJfiRr0Rr8GrYAjCkAmMtzuopCU5eczxUFK3BP18Jbx0K/fs2mUVDvb3ZxgXtmJpe31EsvFjVJ2FmS2Vzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749136174; c=relaxed/simple;
	bh=9giRpCcEgI/3R5FlpI5m7DHzh58B+JGTjMSgfVzcL3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R5+nK3Yst2LAZyeKO03SPMll3vFTwLm2fA1OkUGQK8731TrDuIwttt/royh/NssB9481eFlwUEyCK9crFs7xg+K86CpJd0fDjW963NxnypJKJ6Y9nvCtz0Tdf/ovMm3Zu0YYg5nV/kwX/kM8aNZwn0sKt5tP2/lu9XbuXzyC2AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VXdMMl7D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v8fORBT+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VXdMMl7D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v8fORBT+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtVhv032029;
	Thu, 5 Jun 2025 15:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xtvu+EC16Mg8nc5Z62s94E9qUE5VsnotzEgLJgisq8U=; b=
	VXdMMl7DXNXYDqnHnkFqOCZyR7QbsTBa4J6tRMD4SLSEFlzM2JeD5tFkOUUZFG1m
	I0xFv6hck181D5IH8fAFA/ZB9tVRn67JBKQuznu0Yop5rRXbibpyu2zlcMdR9ejH
	SPtpNC2YDTmuNUN4dVpJZ+F4gt9pEyk9MuCwX9pFEaq9DHBWtuF3KoiBIvHP2ya2
	csRVe8ByKm0bKSxrJtMZDmVhmfdDT7Z1ZDqd3kJzG1//vwsSa7Rm9BXB+CO8kbwr
	2CFLCWLHmrrICTmPzrROTufrOB4weBkTiKCtrB/aaJlLA4MpbWLdzmBBLm6iSX01
	lwI851ea2ifUudrhW4pQXQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8ge98n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555Esxrv034993;
	Thu, 5 Jun 2025 15:09:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7cejv4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gvhKzHyXvUnGkDUbttr7BGTTmf8sTkAGq/a8DPIOShEbSwXS1uzv8MoLnyYXUyu5IHEBPiaDo5n3iY301tHiu2e4dw/iY2YC+lmspnbPLhmKkaSMlaYbLZGtuNPT1psWpA5GqpIoqfpYrrwsz+tc9u5mAJBjG+uiPv7k7ywtxphnPZTcCDBcg0tASFyFsSgyZrdMRN26m94cwDiVivpVTHXxhgadjx+F/V6mKi7i636nom4tc8z28BqVtXLZds8n56CyYXqx+RTdfjbCm41auEqdaUPqonGGFK8tQ7MAIAVmDpslEY1loN7ote2BoWbFBU9Zeoyt+3ukXcmqxLgGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtvu+EC16Mg8nc5Z62s94E9qUE5VsnotzEgLJgisq8U=;
 b=YAFumcd5ANTGIeemU2RoFjKmKatX3Lq5pcKwoGqyfymtWMFFWyCPQOfhrJUkvhYCmcwDrlhUBqHJY9PeYgSDDTFbowLZ3u75FNCbErugtENs8yKICrSk4lmn0h+RiOHoVrTFfDekmxpI4YVsbj503LMYPs2vv49fmQ00lkWzoCjdP5iYs/H7AhPQNbV1GP2w0PjknH8LMOacXPZi/REMjvjOB4cY66RTp23LZmJKK/7iSckRXT/6vot16Fwyq3I/dFF4Snl44ejCwLd1hI6LcRtDabtns/YLrQMTJ4VZc267KunLGAI/gI3IYYs+s8No3bYoPgVcim2guc/9q2fkoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtvu+EC16Mg8nc5Z62s94E9qUE5VsnotzEgLJgisq8U=;
 b=v8fORBT+rEbnwcfFBJwowg8pnRBoIpKvUUzNo4JwYkK2DyXCreDkEZDHXbrp/AKzYCbGBjCJAh3//OBGW1b3SlfpM27Yod84Vw4EGnjmRHJbtfrm5IZUwyzxXwtiRk5LeOTA6/RsceFYx50cYdDiMCqw8vZ5jnQ4Y/wWnevC5co=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 15:09:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:09:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 2/4] md/raid10: set chunk_sectors limit
Date: Thu,  5 Jun 2025 15:08:55 +0000
Message-Id: <20250605150857.4061971-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250605150857.4061971-1-john.g.garry@oracle.com>
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:408:e8::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4177:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bc3a680-8f0f-44d3-d47f-08dda442efdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s910V1MgwIxBZJhucJ0Mt7qdJRtP+MmkyuNXMNXukRxsrvfN4YFnnInkmNWN?=
 =?us-ascii?Q?wxkRHl7O72XNK8vxsL9Lnuceklq9+yt/R1hKweENeOcnsAZhMJ6/KsLRfV6J?=
 =?us-ascii?Q?bKBqIDMf+1Lyj4YUsdWNKoV843/zM4UkjZsP0BCJyWIRbfgk6+kSknNhbkAN?=
 =?us-ascii?Q?KGKNPjE4SccLgirqtJJV9m8KgHIzmrdQMhb9vGTp5WBSK9KZ/PxJM7QqvVOR?=
 =?us-ascii?Q?9ATilulgi7idES5/xAVRkaSjqWboq+t4vjzjEAfeN/AhImNdERLvNyWb6f9f?=
 =?us-ascii?Q?cvpyiUMxL/ILyyNM7H41Evy+5VgP/qo6b4PSRoPkYPQSSZja5AjhV4tG0gXY?=
 =?us-ascii?Q?APNbxExESMD29HENtT1pbwc4F0ndEas4gcP98JglKho5+NqmGW3VCgXoGU6L?=
 =?us-ascii?Q?EgtTgQqlmgX9xbnn6MpdrknT6yWRtRa62XixJHwWOuiSvSkKsKaKvNHVrt5Q?=
 =?us-ascii?Q?k6zd0wZ1ABn3SqNgSLHf8I+UCkOa0Pc7L3tTHoU3kjDflROSsq3Xk4UNbJfz?=
 =?us-ascii?Q?uglF/ADrisOmcyUxwRGaTTITAtLTmV4Ivu6bjuyMfFe2SiP2IUZxPUHXEA57?=
 =?us-ascii?Q?fQ0wDHZxVE2lGFkRgortV/Icjcdl9MjPFuxoG4hEuDlrc0JfOwWCr4V73jsA?=
 =?us-ascii?Q?GTi8RjOq5Uj2dcf7ogbR1Xp78t307RouKQwN3xKFNdCh53ywWMEf6EwIMjmA?=
 =?us-ascii?Q?mmIp3mFDhpnmncQuwNeEtP/XxfeXoZzffMGTQyN+PmNEJswW1HMZWV+ATQth?=
 =?us-ascii?Q?kRD2i2cn8enMhGrDc3d59Z6qs1/cxSe08yRF7Yg6ETIFt2FZmWlE1Kx+o+QC?=
 =?us-ascii?Q?03ly19sW4TAE71W8Eb60Vh7o2TVoV8OItRbiUUax44ZfLzy4IWUc4dje87mk?=
 =?us-ascii?Q?zntd2ih2lFOOOzZMk61XxLF2Ru+sVd+YAeZvogcpU1gOXvhhKE5kS9wqUlCP?=
 =?us-ascii?Q?hyaw/nl/fu/0CBYCMg0o+9ZtGoTkTLHf8Ujtkbbwt53itXZ02WVw4+eabbhi?=
 =?us-ascii?Q?Yh4krBHgjPHIUIGXOeatvZCx8ihRMwZUwQRx1s795pURfPyvjXe3o8DWQeFh?=
 =?us-ascii?Q?4VgqXn/vkXQUkXfm2T4x7Gu6uRXo6ORC45gxPb5hjJRiFCTBXtv2aR4iUGhH?=
 =?us-ascii?Q?tSqJi6Cp4+PdQxvl0bELn7sreoXe4ENi3+Vp6O14qxH6931ofGR9y5xaKOJy?=
 =?us-ascii?Q?eAH/mH4mZYCfoWYViaMV7+8fs/LEMwRDBEIW4weS50IlAgr+9IqVOCpS+c/s?=
 =?us-ascii?Q?4dni68RQEdPmZmUw3y+FflzcEChXuk1hyHzxkDdhpVc/0J7e9P6+V/iCuBnX?=
 =?us-ascii?Q?ASkXUAr4It9EAH4f18s3EhyB9Z5BvqGdnHVJI7iVXVF1j1rse9nY6hcGFaGg?=
 =?us-ascii?Q?n7YSyBc8up0O9HUBGi9puA9xPvyvllWE61T+0drf+4jsxzqokjji4zcaHT8B?=
 =?us-ascii?Q?9tc6+4tfaOQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kEkVKsl5h/jiJKUmf6M9l6N5mWgbJ1CGE85d/U0xCxAysOPMZmbJ3C6LDJ15?=
 =?us-ascii?Q?/Sa7o5PW5MQUROThS1ypUtcL0hBZrsFkozuu8iZLMp0EzximwM0Ce4M2o4X+?=
 =?us-ascii?Q?fXC4e3pm9GgcxuNJrQNwwRGXC04VK6YppONBkEGm3PzybMuL9N7rZ6G3S/Ku?=
 =?us-ascii?Q?Ov6VOZxTssJ/8gIWqacLryf94A88XJcGqQWeAb0RPOQa8WHn39O00MuVo7Ux?=
 =?us-ascii?Q?vB0sAlPbth0H8cU5e90PoGNCK+NZF5DhU9teDCANTjkGbHQf59FwEX0JjbxJ?=
 =?us-ascii?Q?Jw3+dVbypm8cK0hudgeR6Qa0xfqlTgo6zvjJqucczOSoHUpjRUH7kegzqoIR?=
 =?us-ascii?Q?yr2gKPps+Nc2ZgbryYf4OGo6mTb/BhRqYp1YWe0j+4maoQKlFvTunGIzjzek?=
 =?us-ascii?Q?v+d5O4JESo+oZ2QTMrRlVxHVZtLjFHsLV2tv4zYJwNjn4zBwU/KUfHk2Wxv4?=
 =?us-ascii?Q?DusXgZuMKmC2iaHHvXmMzaA735tutqVO3RzTGfcQc0H/ZEfZo+iO/hiqsmQs?=
 =?us-ascii?Q?zCK4Die83bV+UbPt6Revkd8Y2ZQI8AK37g3sjkhGOTakO5Yf8IzNtifZRZGt?=
 =?us-ascii?Q?2eIY+DWQsZMp3ml8mThj49X8tMwFuom9wzgDfq44dW6ZR9878HL2FqRwXyEb?=
 =?us-ascii?Q?KSg/h/c7kDNomkWp+VM9Xt3QwC844zV8LONR8JwSUaj2fijVyKq7jrbuWDhT?=
 =?us-ascii?Q?e4azarL2DrJV3VCczyA3e7X+4Lf1yHl64l/m8pJQnX0kS/VBOfxcn12BlJdF?=
 =?us-ascii?Q?/dr5rKhTukI4aqXScpYc21XJSQbaGFhW2GnV7nD06TTIVAX6To6/evIkIgyG?=
 =?us-ascii?Q?HqLIfVsMHwsgDis3Xfi9LF6/QvdMcXtkJWK9XYokz+WSLGLzcYis3p5KuaFK?=
 =?us-ascii?Q?RQ6gR+v4SWFDsgPePoPJWWASk+IMmZVHz1SvNwn3ta4AaETHhKJlofl83e+8?=
 =?us-ascii?Q?2Umd0Ppu+Cscc2ccD3+Sq4UeoasQhh37GIJ4a0+2uxoVFc+cukXfp6RJZWNH?=
 =?us-ascii?Q?SM8QIefOA6tjqEdYgdDE7KyEK9plWbfg/gSIQ4xrxjqPcDj5yScPPJQwBFmX?=
 =?us-ascii?Q?QwVb3Y+E/1VIqObAkdgPyVdOci1zGrVIoYaoiFfLQwtDo3IYvnvs8o7Bsqv+?=
 =?us-ascii?Q?+vYGJmCv1F27oj4NjIBJr3/0ehq0qL0lBgqpHMkJzVw4EGZui51Ika0zKFE6?=
 =?us-ascii?Q?gDoITymleZ2OY19FaipNChoMTh3rKoaGvud81F6BqknjcwnjK92Ebeyctm4R?=
 =?us-ascii?Q?j9voKrMcTawarsnLjmHr4W6tPNIh+Xkszh7jOZFntunEs2JZQ7/161HR2Y+y?=
 =?us-ascii?Q?iThdvmeKUqa7QfuAclt6ZzUX3YB7MkZ2TUaEHYIiJg028hEQDLgJ9LVjy31o?=
 =?us-ascii?Q?06SlB0NK6M0mFoWzi/bZzJrwg+aybdVrlUQqQR+xoOlDsjFiiBR4GYmYaqCN?=
 =?us-ascii?Q?8k46hIK2jAovVdMDb5ClYN3y67cNUcQ+UsOk39+RM7n9bQ9CyW5NIGCeOHjA?=
 =?us-ascii?Q?SXs3+1vzYBsHJyYrdhowBxvrjraZlGtGLXtPDDapxhtE7uYBOCSTp0r+LP0o?=
 =?us-ascii?Q?W7Cn2tpccnKXwGMF7NsdzUBFlzWSPsGI3VGvaNJD1DWfxS/5/zfvZdwEq+F6?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c6v0oQ6Eh51vs3oMGyn7BCGH9FwCUzIkrB6ixsYiXcfBmCn8YKqvB4au0cmQ5r5sDol8D2XvTb5p19yzDHmLR/pGQfLD6d5ZvHXJD6IfRT/CI6kKGg9Qebs0aGiL/gzXpG9jz8TYlsvO9R61zTGlU9xOfIKRyiL+BB+5kAUuFD72RnnnZngMH0d+mpT+lGpdOqAGxipbpfdJphyvkdvJvbOyXS8laDgp0qGKY25hmHy4aJb0Y7bCjZv/A/ISD5todsCk1NjeJwX5s7vNotRqWGfl+9JDRawbWvLuPvY5+KV5t+kfjCsfmPOzIA4OdVZAF1JHkoGd+6Pn+Bq8kq/7vpU7XHddv1/sRiFwkM5v6YZMZ8qYA2C2QlnIWdaKX0SlX5GZTyrsP66aKU7ZMxY/zOHGfF7HDxfLbEkuP0dIUAaOZLeaw+mwpuX49a2ELv+hrUIJdU3ad5uw0B9CIoMYDVq2AP57eD4sh08ynHEtq++WozsMmMdMZMinWlKw1POkeEIV8pizIVAQ6i7shG5SCOT0Tg0MTETGrO8/b8SW5JHyWm5R7gWzMXhaiwBoLxLFZdS5/xUN+GqRRF7s9qkzazY8XwhezA9OcOeHb2K3V3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc3a680-8f0f-44d3-d47f-08dda442efdf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:09:15.8638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Av94MbNjVhcq/fUzOhmT6UDrpeP1JvKRbD0p5U5xV954fdvD2u1bgmTzZ1YUNjIreUyLGrgdXvrSH5pyzxSBHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506050131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzMSBTYWx0ZWRfX/Z98iMZHRmpq PrK8iFrvH3UwyLSIXpHKMVn6SMFGQfhg4UQAbh7UT04PLrYSzWHtaIawZIrA/fC8Ll1xk5fSkkI SXO+iup7jLJFlYjp1LBQBG8NBANyfZPVkGDr99pOwipmo5oDLRXWFHI3aWsEo6UsBLe/+pmGQtU
 ScFrmxC4tSZguS75EWiU9WPpUdcLpnr22gxfGBSsOrKoom5sFIbyTEOtwxmlX8oE9vrDUY/PeRn AR9JFU4i6DWvtsmdm4xFuEWr3yTrNXiSNYOZ2o/hCWkKLtec5irh/4hswC147iuoHKptHdQYPZK qUKJaJCammh1EMX+bckiI+E3Inb94J+DMXLag3Jsd+kD7Q+EQtb0UItrEKpxtSmKjPhmv+sP9xP
 1fDSD2ZGe4dwS90MurMs+A9ib7o+hhpxRuLi0w+sN7+IsWeZYqq3+Xaay35/NMaIFxZXMYva
X-Proofpoint-GUID: Mt_JMHvusltLd9JIWgnuoSCS5zqDhne_
X-Proofpoint-ORIG-GUID: Mt_JMHvusltLd9JIWgnuoSCS5zqDhne_
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=6841b31f b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dce06bf65016..60abe063f248 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4003,6 +4003,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.31.1

