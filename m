Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56FF219E8D
	for <dm-devel@lists.linux.dev>; Tue, 16 Sep 2025 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758047229; cv=fail; b=emAlg25ECdRqjOnRRbZdyU/2ca4QH+4+0eEm1sW2Gp3u0kn4xjz+Jsca9v6TSGLcuaXkjKUIyvaa/p+BXE5EDihfXjk7u40DoLhX6MkqDyu8JAhNSFiDg3Xlgd8qc7PCijVmQyQiGiJPkA6xowHddUCFnGenpyqeO74V9UKG4o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758047229; c=relaxed/simple;
	bh=6nxJem+cckBtpBz0216dNahw/h6oTUKWy5Ole3NjMSQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oa8DE00D9na2wJ1YOMWS59cleF7b7A+EMVP7ck7ahPtIsrLO+fttl7dNaUlRDE6r83L0QCzD22pQSosK82zL1WGKKjOniPqRZteD1VMxhCe0HXXy5ximCviE+dU38CjM6xLd0j2XbkuSHVuheQD2fJuDs0w5vOcyn4oPJDAkUr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GoUXitJ1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BXTeWMYu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GoUXitJ1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BXTeWMYu"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GINPM4018015;
	Tue, 16 Sep 2025 18:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TSK8IeeTO6Ww5RT4y1
	DuHO3lMlBC4Hv2dPOPWz56gz8=; b=GoUXitJ1g5+63qNNWk8lhHW5bHEE4ezP7b
	uiK7kBaoRj6SI/pGtXJkvaGXm9aukZYbBrkt1E9cI8k/YOQXkPkuwBwGRyzR7rNl
	hUBUlGBG18bmTvZiw3qlMSxxOFNxgr0n68+SMOk26hO7Owqb2GtwRdlUzfbmblx1
	lEdSRB1k2BBBGtzgJuqzoAuK6oya33ugtm60bpj5JR/+TpEme8jev5es/3zWf8xt
	kZMwu8U8bwGHrclEEvs1v3y435XnCs6b1UpGZKkDF+CjFg/Yx8TcHdNfvco/pu7a
	6VQdprJWrcWP/e65dtl0OyfEEJSyYGoadqpm+op6nuLbkF/yHOVg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49507w5apr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 18:27:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58GIL645037063;
	Tue, 16 Sep 2025 18:27:03 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2csu3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 18:27:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H/VPKgveD+WLHbcEpgoKVF8DQmbJ0vW/K1aV84xVPk6WnUglNhT/pCbaO4dpxV9QNO+7+6jDYeCHzVYPkJKK6b5QQ6wo3V0xnjN3B3/DAccevWA9UrGohmzDpnFgyW6hbe5VuCH/3+r1chnbIS00jlVfOxZc+u1hBRJDAScnIy5CSGOxTjqB1sjPug97V5IVvEcLhKsrBkW0PkAh+0fLX6G2D2BEOC3hqMBgqp38ZQ3FiSYVkE12Hld2F9cg44LiqnX06AVZeZe+EvWKYe6jX/oOQVLCg6DUmZ1tAzSwMPXWtkBloZX/rwIipR4xasc6M0v4B7V24lDMM9IeVcAn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSK8IeeTO6Ww5RT4y1DuHO3lMlBC4Hv2dPOPWz56gz8=;
 b=RdFcSVcwPtZ6A8PrSwcHw7ZUIkAZRk+brFQD9i8UWBjy1Tem5cVz/UN4GnoKbfWh0ssmt0Xp+vFSpFcK9JmyX6gJMhkN2rSXWXAQ7V/ti8vHZLKnJ8F76E5TE+UN8tFjuuAaS7vO5VAtvRtG4RWhkahG9V/QjWWR1oDWS7OEFKrBS271oxOD2TpJ+ry8q7F4Kkey3W5BH1JppJ7MIstIHQt7j6fmVsyKQneL3awDqvSIdLak20iYQlwoont1KIlpvJM9I8XjvzYMuAzjwYSpKCsIwg5+DoWeekXHZiD0eiC+TsPV1bz5BacdiA2QcStksJ0mV3l1Nc+5xI1iBSiePg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSK8IeeTO6Ww5RT4y1DuHO3lMlBC4Hv2dPOPWz56gz8=;
 b=BXTeWMYu5OYNEPdl5jPro8/kMgtuq/AELWLRFJLi+iwiW5OxVf7OCYztUUbKVC9EvAWqphVRk4f54nsvQtnt1PoIM5ePuLJu/SU7cUGQ3tW9OmIXTLGZOx9a0nqwENBeqcd1lC0qA0monVr3lwmr0DpLmhaVx4+HalzQJjyvz0U=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4154.namprd10.prod.outlook.com (2603:10b6:5:21f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 18:26:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 18:26:56 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, zkabelac@redhat.com,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe
 <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH] dm-raid: don't set io_min and io_opt for raid1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <c434231d-a71c-4610-612c-a27a44d26d6d@redhat.com> (Mikulas
	Patocka's message of "Mon, 15 Sep 2025 16:12:40 +0200 (CEST)")
Organization: Oracle Corporation
Message-ID: <yq18qie1cf3.fsf@ca-mkp.ca.oracle.com>
References: <c434231d-a71c-4610-612c-a27a44d26d6d@redhat.com>
Date: Tue, 16 Sep 2025 14:26:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0018.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 11a2f0e5-c4d7-4be8-fb85-08ddf54e9e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C61cq5jboQRBPBRZyRKuMS8D2XsOQ2rPHly5Re9vhcahqlZbEMmoX+x+VQyd?=
 =?us-ascii?Q?TTeB8WFBuC3eWBIpZ4VLMey4YERbsCiEtyG8eGNUm8iula5L3elhSrYwFMhS?=
 =?us-ascii?Q?iIWZykAhqOD3+FDhBkoDp81v4OQlHbY1Cil3VzLEQ6amD2z2KiWbcMMLjdNq?=
 =?us-ascii?Q?cst1lfMZU+gSfJh2oF0nd4zT1r251HlQrdn+zDZKCidZ+N3qoUnW1Sv3UEUv?=
 =?us-ascii?Q?cop+UNy/G/4/D2j+Ki56ozmyiU5agv4W4g72wmLEZISUBCssxXedsDGdgI9J?=
 =?us-ascii?Q?bwgzbpLoAhwlTubJ1g6f7FFjExaGto1y/FCHYxJu4h0/EN/lnZVQaMQVooQ8?=
 =?us-ascii?Q?3LV+8hF1rn16Ta6YLDKCq9lgIK1csufMl1nr6OBYmAA0RVF7xwBUGxMuSCV+?=
 =?us-ascii?Q?IOHzOOu7U+aBa4j+BqGh43LMy6gIzAnfkToXnM9s4d+cjfI/6k2SxxpLd//C?=
 =?us-ascii?Q?FkCxtkFERpVYvw00C0/iVMHHtBLAFfau/+A62+UPQkTpaIGmizYkIVamnK4o?=
 =?us-ascii?Q?nW6oJSTvQQMGBfwJpOHVDq3ZBk1DDLyq9T/Wv6DuM2kzseZ8Nb8t5PHt5K+Y?=
 =?us-ascii?Q?x4V2lZVXDkwiThwJPmSdLUiw0LMkmKMpiOiDGP7+qWV5ZYXi5hEVKB8xL7DC?=
 =?us-ascii?Q?dscrZxfz0abPn5hXvvRIh4XIcrbzw69/IxlMCFYTyCghdO7A69AK3+7P61Gz?=
 =?us-ascii?Q?UXgzSfGVNQuW2Gko/nF/uDk3jcVpUernyafhJ5XEm9IHNyrOpT61SXM3qw+6?=
 =?us-ascii?Q?22Dkc6zocWHjYFxeDa2W3qfZBbsINMqLWThlswABYlsb1XaDOB8XxllKxTd5?=
 =?us-ascii?Q?Rq2ehLmoPcRqwAie1jnq4r7SYG29VcHt1pwn91F7uljIXlLBHAy86LkVSMUq?=
 =?us-ascii?Q?HPQFfZQ0CgSZKs20clp9t5aDKIdL0K8g+oUSQTiFTmvoOCI2nmrKKwhxCOz4?=
 =?us-ascii?Q?4ISNbYjQ2rScYEXWYyYvlnV/oJG63TNZhIbHKXB0nLXnXeOs4RTGz8c/Iw6h?=
 =?us-ascii?Q?1n9GeIKvam2pT4i46TkQsBmqg8uvi2QAhc8QRJvTQArYzz3yfSzIDVJxL+xM?=
 =?us-ascii?Q?jj3kukOgnu8nHqqtFTYOtrYLs6PvG93oDX43/RPp3dPR2Q4xEc25q8T1yhEY?=
 =?us-ascii?Q?OvKUjyZ3syjt8fsmU2KQfgBRGbU7luj/n46S5ZU8p1CvT8eYXvDCSOMsqvo8?=
 =?us-ascii?Q?thtdaUGKEwZBh+MyhDsO68jpHIF6X2hpIwCupWOuPqagrxOPozObiy8eAY3y?=
 =?us-ascii?Q?Vz2Vzmo1FoAQkVfpwVzuv11Rbv0buGUMDsNbWttmQ9ll0G1bfHlqpecGMipo?=
 =?us-ascii?Q?Ggd4wo3rdJyAR3J1N2nfFYtQkXgGOasYknKyoPwen7zF2AlqRpbRrP6EDlJ5?=
 =?us-ascii?Q?xGTMK0bBqwOvEVbf64BbxgpiwH6WSijK7/hdNWGODiybE1FdVXYwYLsIKIug?=
 =?us-ascii?Q?NWUAR2HWfTI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SdbVPrQWMyjBSv54CQ27yNvsJ7eLutUOBxbELBrI35O+bvX+EizCR7WqRjq3?=
 =?us-ascii?Q?FceX8FeDSGkkvW/yOXSyUg9Oky0ExoaafTh1cuofiIcwnUNrq7I8JB/xA+ZH?=
 =?us-ascii?Q?OR6zxRoaxxl+blRKPy+iL1gHH8AyA2WL4zS3RMx6UGAs4/btM5Agn4nGDQaO?=
 =?us-ascii?Q?ID5dA8sMhhIlVupdBzn9WOv4LW88BReRo4THrj4eiC+NIc3JC2Tt41YRm+iN?=
 =?us-ascii?Q?eCZ5cET+cDU+0Jg9b00mODSnhbkDzY5fBNjMWXaJ5bpAxgBayPbo8ZkcZeD9?=
 =?us-ascii?Q?rdMvLU1JW0StUljd1IyPKCPAZJaBP4pfnYO0YJk0c483FM5klHc2/aZreLoD?=
 =?us-ascii?Q?U8IbSG5MoMoi9tri0I8KA12nVSescx8NX/xVi7soyz7e53IiAFx1DXsocLoQ?=
 =?us-ascii?Q?3900FFYXZjiHh7iq79jwVnFMK56hyrJjtNEWWEXS+nAlQDPgZw9kZTqbDuUN?=
 =?us-ascii?Q?ID05pt6upb7QbNx7KQ7E52sXaz1MtFolgiqOFUgESuipKmwlycPXb46Xh/SC?=
 =?us-ascii?Q?amVCP4q3GS5x5RTAGkE7mxLgN9cKe+C1SxFVBzQ10ZSRhQP91sy6jsEebeLW?=
 =?us-ascii?Q?gY20Cph9HTVJ+ToAZkfE1PBmOkGIxbHlH0QIla5L2rrcdBQ8awiF3goOLflb?=
 =?us-ascii?Q?BxhqlXavaYqKUqnocWxAFavyJ60ah/i00071U/Sm1oraIjMmkg9qakWv+vvs?=
 =?us-ascii?Q?HhIA+SbOlLnyl/IbyY3LXkpPgCPhw9l8pl1F1vK3NO5vRGXUeX0c2qr7OxvQ?=
 =?us-ascii?Q?ncsAyUIcTNE9sjkd3ZnV5RwvOsGItF6YKhPn+DoiDqKkuG83T9pCP7/56UG7?=
 =?us-ascii?Q?YmJQ1lXIospBC+Usy8oj7Ajzslf1mfBzFZrXFUjLTQ73DZqNIiqMmJWuYPml?=
 =?us-ascii?Q?dbaj4UxRImHmPGOafZ/7BeA1n6B5A6+lmJ0JkJ6SgTz2CtcgCEa82316KYvw?=
 =?us-ascii?Q?InIl8GgdpP2djUpWSflf62duc4Aj9+3QF2AXlzDhMLU41VQLtQswGzkEbhly?=
 =?us-ascii?Q?AzqDMzc5UIwkNU9c0pb/SB70pIWF3WbJqp4TDsawoBVmjBita3rzt8dGNi0c?=
 =?us-ascii?Q?O6H/93vCLFoeJ6pquQI6S5jXcgTT4PI0hhOF+q/P0vvE4SrlRhdPTrT0FOFA?=
 =?us-ascii?Q?MBG+XwhmGFWvNORpQ7agci1KVyQ0eKTGJmNW50tN+nKcQaqm11ymeNC/uLh7?=
 =?us-ascii?Q?jAGEX2lBQf1wHTnqzRAtTOGkuTfXseqEllxX6h0ujQRSMzDX1ow8RiVIZEhU?=
 =?us-ascii?Q?TQkYRa1bkUHCPcwntKipBsUvar+mMIYlwe1KOK6PRr7c3MiR4jI2ENEapHw3?=
 =?us-ascii?Q?3luVzDXfmg8mo1dP4Z6zSl0XrvXVFAvVx720tQKxf2DeKb1F+0QKF04DE0h1?=
 =?us-ascii?Q?ZdA+iAi2r0NePI6NilHJif2drtUph4woDa7c/T7XbuFaDYPU4k8qOQa+REtc?=
 =?us-ascii?Q?tD4/Jfua13s3Hfyu1v8Fqi1W7jvb4qgzLxHT386KOyuYyfth5s+uxDdhRiPg?=
 =?us-ascii?Q?2aoxjvP+QSDBk3LE4h0B0XT1h/eMqZeZE6QhIZfI2s8LUZFe0M3M7QqVBM6+?=
 =?us-ascii?Q?y4zDMC0z2pFW5mS+sho6opU93dKPPGwNbjdz0flj2x7pVs31UZ08eWcRinIS?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tu1g6B4KFYk/yzVnjiGMbAHjlwZFzmzK9gEME1LgTcoQp368bR39u3PXzwgxyRkZqEv9c26yHPmqtWNESgUTqO/BqkgEIGA7eHlBl2v0eA3FF/qFDecAwGJT/2gV3yddjM9MPEpKVKQlsvt777p0PAOs2wJCYLVqQfI6oZ9wnQ96kpoLwlwpeCHgeP+yka4zqFanMfw8V4kDpc8O81Qr788PlrbcIkqcAkNBKb+HhH2uhtmo0gzV95ZbBFfD2fISPqjUFZ63MjX8WGI9EYciyURtL4D5rLyepeZgwyIUzm/fFTpiMlotC8P2hplz5ezvxuEnerg2Sj7BvV3W/bfSuPbMMTP5BvcgUMUiLN+2ym2UeaumGrgC7yP7zBZSFJJdRsyUu1bBo7pHqehVzGU0sK5mCoNUta9RacTW+QJfLmLKwUWK3J++9y6NonjbLdAjleq1Vp8ml9lrOdiKxlDsBhJkvYmRoJLH1UssIDqBDF3URbvnp2Wdv3xlmG1ovpIiZib4/Gm6FxSXz9VAM5WY4K2pCJZdeY2Ldfgp6kBo+FBc29iC/btmX6sY0fxoXsdMCqBe2CodD0uZsS7246Dg3wwXuTUbLPd+rx1dnD/hUW8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a2f0e5-c4d7-4be8-fb85-08ddf54e9e1a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 18:26:56.6743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMnYu2h7dd2P0JBuwGIYlx5VHBDdg58wf1LijWoGdde0VG6wk1criohg55ihvus04ua9/yr2xEsrqOGnNJHOqluM7zDx2dylMFZeE0qg7Ew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4154
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160171
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNSBTYWx0ZWRfX7nZ8eHQYTyX0
 jjbKjO43q+LBnofRiDxI5Sy8D1ixTjAP7UjQqIvXQ4uOUrkXAWeht4oNM43BxsyPV7N569bow2u
 okDRPAaTG3/OwAnscJsddSoPBxbEOOuVEcoUkpCeSK+pO3ldKE8d//ooREq7s8aroewpap40R2w
 7PYrHl8atMOYmjdzoo1SBbWNb5YD0DPeLl5tJzfyHLcYWvOZ3TRihrWxnvTeDF0Ase7wNsg5TcD
 eTKU+D1TS778LEMUHjRbY9whdMCsZIWgYfjjOdLpdbt958wccj0wpGmMOaKHT9KEqm4vhu6yrDz
 Eob0MCRnO+d1f77FpY5uZI/WMig/Zm5omPpqH0suHBQhMDYPmj3oHUI5t4xzaUFZg3f0DTl7k/2
 j8eEXKA2xV+vd+1J4YNRX1hKQ4qdwA==
X-Proofpoint-ORIG-GUID: cdb9fVpDalki7zZwh7XKVoG87CeXiUI6
X-Authority-Analysis: v=2.4 cv=RtPFLDmK c=1 sm=1 tr=0 ts=68c9abf8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=S2BEyegQ6yeZ2gB9dp0A:9 cc=ntf
 awl=host:12084
X-Proofpoint-GUID: cdb9fVpDalki7zZwh7XKVoG87CeXiUI6


Mikulas,

> The warnings are caused by the fact that io_min is 512 and physical
> block size is 4096.
>
> If there's chunk-less raid, such as raid1, io_min shouldn't be set to
> zero because it would be raised to 512 and it would trigger the
> warning.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
