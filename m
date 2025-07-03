Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489242E6130
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 11:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543227; cv=fail; b=Z44uWg0v9tigK/MHyAQtmT2HEevgc5LpJFZZb8CO1geBXm4jIuhqpRVJrvLyaiJFmUS/64RHO1smju9AlvMbMbODZAzxX4fdAMECquzjiXE57894QhKzvuTqcxgzVf4PammUYt7HZi2SvUBHddXRDA/7d/BQROMKZXmb1KJqFG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543227; c=relaxed/simple;
	bh=UC7lMDCfd2c1UpzeRxVVSAiGvQkTcCoigvC0mkW13RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Rgw0+f+ahmA/bfZxSgFjKT99R7CFO5Np9G5SuWrOaw8FANbd8gwxmHU4UHOZ2QyinueUJ6f4JGpehyaF/VRHfja3Lv+kAd/7CgSDoPM678y4jiDZ1BUe8MuSMHPpmyq/iCSO9t0MK7keJMwUhIxlxpftqcN5GnUHxf2VXBkgDbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pFZN7UAC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ob5j6q+7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pFZN7UAC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ob5j6q+7"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5639YroU001099;
	Thu, 3 Jul 2025 11:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5Mss9O4EBhdDEinXfQRkABIrVphYflkcaFcFJqpXvtA=; b=
	pFZN7UACUaobcRNHak432mgK7fej/7lu0PvMDe+IQQlD1wwv5u3UqOMoJm+89XBx
	1PfeFlUeG5PNyTRyX3nyinlcU5POirBad2U46XY6saljpHD3jurnK7gQI0i8vhN8
	RHfY9YWnp/oGB+kDnGaWWIu9GHVdRq4LwgQxT1oCFfh1Ite71cIta41PZctDa7TV
	GxH7LJVr780IwGpVkot05XFN0xld8eIUsoUO1FIIuupgC4LSG5fwK/DEnAK75UNp
	ul3bsPxrfTgzMcE5iN/uGybxDYvqsHMoYYiR3fTsJ13uMLvMaj7nC0T3vphNtoIN
	grHEOFZkXY6Tln8igRqlgw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j8xx8tuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563B1ctH033663;
	Thu, 3 Jul 2025 11:46:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uch38f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gH1aQmQNVxvzI/r8cQeJTZq8L/hdKX7MCm/kiUXbx4gaGrX7sawScNhXdGdClqIrQT5mxi7KBKCozbFxFepibz3Wcg30YxtHAXzTrPGIK7+9nC9TX7fExi18vojTKoPTkKnftrmH+nzn+Jb8CPy3h0nx5kuE+/BkO9ZqkitefMTge5LKg5Ihp/IXqd7ZC3Ay5LE9GVLCplUn/k/zFB71+f+AMWDdf5oqvF8uThPcXqz8OL8VSx+fcuOiuzV/QE9MNramdM/FpADMPWBDJkBCbKk33Iu7h8rse2OtnIa9qIzyvGexUIO4+BTu8bM39vMv0Eka06lBvaXsDvBCT28hTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Mss9O4EBhdDEinXfQRkABIrVphYflkcaFcFJqpXvtA=;
 b=ko4LiKtSrievdm7VILUWGQqdB3re3FC5dJGtcVLE0y/8WohP8nAst1LzyyaAUS8s0tnduUJvbTyQZwwlfv8ecvwmzZ6FUYfI6eNUI3ZUsq3Lt7XvK+D4dDt63MmD9Do2dulE2z3LVOaNXJ14V+SZM9XfdO0wYjS/qTUP3G6iRmnD0kV4wLn600QwGJzo0EigIzkXVuhlapU2JuFbDGDpylQD6tMSJAjmu3nd4Y02JnkBSAu2czbhCqjH9njSLt5aoKD79qFcAx7rNKegw4sYoiZPfTjc7TqTQT0t5xCb5Ro7pN68MYfIYWMMGah1ST8Tc9QrxnbCgvIVy3rbAJgB/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Mss9O4EBhdDEinXfQRkABIrVphYflkcaFcFJqpXvtA=;
 b=Ob5j6q+7mHCG/eWWKOqlmkLRl7ZhIgl+W+bWQOCDkMTEkpcsZbNHPJmN1g9xFuyz3azc1Diu/aaAm/55qZSMdSUSKNKmpT5o3LgSf4fUZhbcMaWtHPk1ad+T1NjGKB5HLcNzmWZvdotT2cSL9BNTTcY0o5WA0EO0+/GZV7rPhgw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF262994532.namprd10.prod.outlook.com (2603:10b6:518:1::78f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Thu, 3 Jul
 2025 11:46:46 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 11:46:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Thu,  3 Jul 2025 11:46:13 +0000
Message-ID: <20250703114613.9124-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250703114613.9124-1-john.g.garry@oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0070.namprd17.prod.outlook.com
 (2603:10b6:a03:167::47) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF262994532:EE_
X-MS-Office365-Filtering-Correlation-Id: b4058077-d4b1-4cd1-78e5-08ddba274a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CYLQoAn3RwF9DvXWcmL7v4vaQ67MzUHHfLJRB3TlCJb/op0zNFc3i+HdPfCb?=
 =?us-ascii?Q?VNtt17IeBhA+8agiq1CfEiVWgPM0z/3dRbSqcMgDh8zI7Ytpiw9wsOrLpCYL?=
 =?us-ascii?Q?fDtflZjg01kpFjpIyhk9VRUvullqNmDMs5Hmsoa+NbrrZbbgH60UlD4xzX4a?=
 =?us-ascii?Q?nKcUGgwohHvzhAEr6q1Hb6NRuUNn6ipNzEec7urtu37HMOBFhMp28IMu8rK4?=
 =?us-ascii?Q?1gl4g495OnuEnTV2XDambyGNjoPwB1iVe7uM9PYh7IDrX+ZQpDR5qSkTmv/z?=
 =?us-ascii?Q?pwDthBY+ox2CQpgEtS7FJuezxz8+s+ukUHG4/txSWTh/stztHli4P6Dg2ksS?=
 =?us-ascii?Q?OIG0ZmBzyP3gKJGJ5rGDPAOJruNARSRkyJ9nO6h9ZxQ5v2UQl8S0CzALQ3nl?=
 =?us-ascii?Q?m5xKhIaD23fZBLDNmMGwH6nwttkAxycf6ZM8brqU6muTSnax/6MEGQ+qEjzG?=
 =?us-ascii?Q?SJxLF8lviN8uHFru7COvMEZTdp44h1GHPCSnGw4UFf8In/HNFddYIm8tD7hN?=
 =?us-ascii?Q?Jr6OQHgwiw066g0SW37JBII3DjACCyF9QCGt80hHcYdIRdlrQTLDTA9pBoxq?=
 =?us-ascii?Q?P8Z6Ie5Kt7C82yx4PSvjcPdISmBPqtZyQyj9fI9jRw9kzLfnzUyP0LedUWm4?=
 =?us-ascii?Q?jwb22umFtDOCmu2UDYGu+YtPa7DF0BpFLjvmzIapV9enHdvQlGBnXKMknVUd?=
 =?us-ascii?Q?TMrFv6BfEEAamKF9PGaSUBwRw6ErizkHOSfH03Ubh/GYffDXGFqpKUgEH9/A?=
 =?us-ascii?Q?7zlNJmiweh/gpVW/raO8Wt24V2ERp3yYf/2FXJ9DZY2/6e3qPAy+cTtC/+/n?=
 =?us-ascii?Q?i4DjsHoCpJ//TAQc493eGdXEeFOezK0FF8tuANM15rHeVGQuIC/F1azXZJ6o?=
 =?us-ascii?Q?dNq2B7YZgB4dRtpFgOiAXoQDnWmWOsN9qKk3Ec6c2b21A9eHk6pCw2R7cUqd?=
 =?us-ascii?Q?06Jn5HeTiJH0co7igJEamm6xw4vznpGM9s639acnWT7gxHs4w3nuR3WGKISS?=
 =?us-ascii?Q?lA94k6wlLXhjADnBSkyZyZKYEauET38B4aVhHDTh5oXMR3Ekexr+z+zeMvcU?=
 =?us-ascii?Q?BMlZSv20mpivkTpNzitAb4hqKaXNlIflUKZTRy5Pfx7B1mIEBYpfx63Wuijv?=
 =?us-ascii?Q?G/SuAD/RqD4ELsUGBfyURZR154I8ar5H1l5x2l0IjY7UoZiVU6+NlQAF5xib?=
 =?us-ascii?Q?r3+dyyzD4f1JHsGRvCb3DTOxOw2mg2CSDXGUnj17f9N1HZ+jGlzgYezQgWLH?=
 =?us-ascii?Q?0duedm/zeVzqx+2Tx/MnjktgkgeJ5gw4/IpVris9p6cMdiPpMnPsodtK76Ia?=
 =?us-ascii?Q?rxHAxJAYq2wAFsAyj7oXfj991/+43NVDVwyk+mtfv72elLgdwvF1ZfOek9hn?=
 =?us-ascii?Q?MZgaN5J28UJq/kV1b8wlBDOhdBNz1l1QQTbrBg/XM0zwjgeamTMndWAFD5Rp?=
 =?us-ascii?Q?UZjavuJ2BF4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XnqkDJq2Rk+p2XxZEIHGwdmBZ5kZN/Ifv3CLy1ec+C3e5P5vPBbr+1MXxeIF?=
 =?us-ascii?Q?drM+3N7ED35FX828DKbISsb4URNzdPzSepXPw0hmNQUNAoFxTyKZgc77fQmg?=
 =?us-ascii?Q?0O60gV8mdWxhU4u//J9GmEspPvg/8BlqMKm+wNBhU4pj0py5qDlhvaVPKpbh?=
 =?us-ascii?Q?d5EET0Mo/wyxEWeYucPZiyy5Mw330rpcQuQ+t7ueMR/UZUuiMg0hSlOJMZkp?=
 =?us-ascii?Q?REQoIzxD+JUikDe2x3CHyKemUnqbEB7QCtcOVw6oHW4rw3amWUSU41lSTW4q?=
 =?us-ascii?Q?ZZFymJUcPZ1Wgp8b40fNb3tOkG5wdGcGTX2g1Ok0uqIBN/vagyAb53uKZ8sY?=
 =?us-ascii?Q?YRBRUNFT3UPfVKtw5iS9jK/7HijfdX4oUKpSv7X/+UJGX0ysyBlcLyln8iPt?=
 =?us-ascii?Q?Tvcn4c81lkmxIhVoAZCX4lHkVybrPTo4yX2BJINnWUOJcCLr4COWkL16LzF4?=
 =?us-ascii?Q?TphuppghuXKPwtDmm+kE7ZXOGDBXA5LDt4OpKUVL1NaDli1wSYy2MDi0/l1f?=
 =?us-ascii?Q?zoBIyu5YOaUQPwQHjbRMe6kMVh2hFDhIR9FD/DbB6rJ67gzhgFwFzmO/heg8?=
 =?us-ascii?Q?yMfyIv52yhzkmeg7yZXDahwZuKT8lE7lXcXpp88RN6GFA6VscMZYfU64e0uK?=
 =?us-ascii?Q?EaD7r1KM55Mj7zReGHqxq9M6ckgZ2O6SW7hZxv5WxdUqaJ7MSjpx5kc7bcaz?=
 =?us-ascii?Q?XpQM0uNjgA4/U3aPJOSkRuWGHTMTjZLXM0LyJl3as1qU8CWsi57ArxU1wWrS?=
 =?us-ascii?Q?i/3nE43VuDejb4P4upBPcnr5FHP0zkj6xuGzsY1WQ2nmxLtFBYuZjbgKdMXj?=
 =?us-ascii?Q?GeQ41LQJycOmlrL/5dSCCR92+8JeviIUPlKTl3PGh6ElL+eFutRXaLOa/Wf6?=
 =?us-ascii?Q?HFR9Mwlsumd6yBnqZ0izWwt9ViDf1wtfKgSTRThRPRdgtgRCqcD2f1bcZ00u?=
 =?us-ascii?Q?099CTPf4OEjJYC4R+2PGbeO46wtvYSbokeaXVJrE6iL6n0vLKEiTnrUG1frj?=
 =?us-ascii?Q?9AP9bW50EiJDD/CohG0iY01HZdX5gFb7v2Ld1whKFZvFJi4JpNUiMetj+8kc?=
 =?us-ascii?Q?ZFLzgyxMuDvW2lQvPKxn7D1b5tXfTz7In4vA0ww9Bi0iDx/OMp14EY+Km7CV?=
 =?us-ascii?Q?/eZNgEn21ljNBXBUor0j1DGIKBluZmPFv0ai4YGLGtkamUaTmn5XU7P4F626?=
 =?us-ascii?Q?66RtVykWWgQ2gBEuUgltXaozF445zbQc0kHhxTrnhQLe3n/zJgia95MdsB61?=
 =?us-ascii?Q?IIuzGIYgGjjfEsaiVeX8pIUV0brRN17+AoC/a9JjvM+gXWDBZkcGQ/RuBOjn?=
 =?us-ascii?Q?Va2kUX8g2l6Ls89rpFy8Zg3utO054IGZup59kG1Wm7LSVsB1xBiWqZ63T0HC?=
 =?us-ascii?Q?XO6UjcYDUm8PlkYW1aiUVIoejQn8L1tSzivVGNpfQYzK1pRqzVlA7USWCWCl?=
 =?us-ascii?Q?Cab/2yZvNdYUdVvea+6JeYrxJChBsfeuAy+OUKDHYsJgxmoe++l1NOGW3p8i?=
 =?us-ascii?Q?qEmkVQPGPnYXp04kcCVwAhoM+CNzoNd71iCwGMPVnHKwHQxDK/IJ1qwFXbrg?=
 =?us-ascii?Q?iVAUnlqcWzpkAinNYgZIugWrOb7WiHBkSjQkXeLWJOAmE2aeWqh23Z9qCD+j?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	10Y7xG1mNL04l2+JvIlRRJyURs/qp+bMD6DNHZYwfxjITEeOC2vBufVHdeMtsFMns7Wio8if6ESdcW5zO+pX1GzVsLf/+zS9NxsmTPOCFF1KkchvZaMd6sddKLr5FDUWNhlZS1Dx3hY+1Zm8q9Rg57oHYr0msgTKEozPSl3a6vzZVRZieoUcJvUMiJn0cYCYFBGXx7bMtFNWcAF8h7SkyYHp2HUAq34CYD8mxpum1al7krlrg8dq0lfmrq02Kk26Pj0RJG7KwTCNUk0p4Pzh5y9VpahtU6PgoGpgdgmzKP0S6tGveSii5xTpKKPmwWTgIcWXWR73uWYgjKujlUBODgl/Gfye5IzGLl1GXvOpmiKKczGy5tW9XAqYCEwFNRFvV9rpCchohpDVl3/UEE7nkYzffLk/EWprvPdpyIRHciL/EcvFOAMHUGYk8/eKz2fRm5/Pkx4386TQnvcK4gaUWQzKF74B+5T/7OGmqQqt2+JqASSRkaMwNxODEru7fke4MFhn3K5JOEBvDuB/eh8R9Hy9Uss04hlzkA+hZ51MURH0iVwFutKhO9oTWw1pildUkQi+J3ivLZBjiWRQJclzzpyxJfBYuYnbb0BvWBjMqwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4058077-d4b1-4cd1-78e5-08ddba274a1d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 11:46:46.7314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kHihd/svIo8/fqjZ117VvBvv6kqyoI8byJ5T4XyDNhtAODzBHXHw84GkBtZzWty8pcjH5WNZy5s3DguWsgo6Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF262994532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507030097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA5NyBTYWx0ZWRfXwGn/W3UcJYjH LOkFU6cmIU8XB+zYIIrEZKRViBUbdv6Epi2RrWnB2usRDJFem6AmoX/MPwKg11AauhmGXlmGwA0 HGO7B8G6FJNEL4p+3KsO2obo3pluo09n5gmpt1Z+ASxj8yin0TwGUKyP7V/mi3uvII7OptNUYdr
 vq9cgqlu5rYWRA8X5O9lkkQST86uRz1x+uNS/NY+0j8k8xWcQPNqv5OBmvtflYkKCie3J1dLpeZ lmSrnuHpjmczqrMWPuFBvTw+aK74wLL78Z5CjuDYjkd73rF60giYMF99iM7TOLuoGCvOb2mUyow CIGpisAPTfSBojaEq2P9I+Z4S4PHfzLwddzHFTl9A4W7++2r3dUb08Z0YUdIscxIB5X2CuSuUId
 X6c/jba2Qc0+CrkF5m9WTgZALqppzp83RK+/g8cu17thLkBr2JAPN8HwzGbT09Vb4fE+NMj0
X-Proofpoint-ORIG-GUID: POa7fsbNLLoy1qwygsQi9VCJq5s2zZXE
X-Proofpoint-GUID: POa7fsbNLLoy1qwygsQi9VCJq5s2zZXE
X-Authority-Analysis: v=2.4 cv=QfRmvtbv c=1 sm=1 tr=0 ts=68666daa cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=qbs3ZK57z4IZS5yrueoA:9

The atomic write unit max value is limited by any stacked device stripe
size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example (of when
io_min may change) would be when the io_min is less than the physical
block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 51 +++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 7ca21fb32598..20d3563f5d3f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -596,41 +596,47 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 	return true;
 }
 
+static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
+{
+	return 1 << (ffs(nr) - 1);
+}
 
-/* Check stacking of first bottom device */
-static bool blk_stack_atomic_writes_head(struct queue_limits *t,
-				struct queue_limits *b)
+static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
-		return false;
+	unsigned int chunk_bytes = t->chunk_sectors << SECTOR_SHIFT;
 
-	if (t->io_min <= SECTOR_SIZE) {
-		/* No chunk sectors, so use bottom device values directly */
-		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
-		t->atomic_write_hw_max = b->atomic_write_hw_max;
-		return true;
-	}
+	if (!t->chunk_sectors)
+		return;
 
 	/*
 	 * Find values for limits which work for chunk size.
 	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
-	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * size, as the chunk size is not restricted to a power-of-2.
 	 * So we need to find highest power-of-2 which works for the chunk
 	 * size.
-	 * As an example scenario, we could have b->unit_max = 16K and
-	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
-	 * aligned with both limits, i.e. 8K in this example.
+	 * As an example scenario, we could have t->unit_max = 16K and
+	 * t->chunk_sectors = 24KB. For this case, reduce t->unit_max to a
+	 * value aligned with both limits, i.e. 8K in this example.
 	 */
-	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
-		t->atomic_write_hw_unit_max /= 2;
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+					max_pow_of_two_factor(chunk_bytes));
 
-	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+	t->atomic_write_hw_unit_min = min(t->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max, chunk_bytes);
+}
 
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
+
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+	t->atomic_write_hw_max = b->atomic_write_hw_max;
 	return true;
 }
 
@@ -658,6 +664,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 
 	if (!blk_stack_atomic_writes_head(t, b))
 		goto unsupported;
+	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
 unsupported:
-- 
2.43.5

