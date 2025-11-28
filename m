Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DEE134CF
	for <dm-devel@lists.linux.dev>; Fri, 28 Nov 2025 07:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764314743; cv=fail; b=donbKFjF1OlzwlBF7ziOtMtW9GDgD335O4b1ZCJKha4EZlgLMjWtswNmEXcd7sx1ELT7QXUA3psLiUrt82EbuTvL+3WsZ2N1tL7BHGQdUYB+gEfR7KydWYBoFCCBGmCIemu7VIaMFP0E8JXof6eKBBrNDw9gzGoX/F++IvGm6PA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764314743; c=relaxed/simple;
	bh=zUDR6rGY/T3DncPRSyn7Rps5D5gP1FwxZcSzSJh/I4w=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XgDINx24iUESVzxuJo1mhft4l5f1CGZrA43Swg0oRCMoGoMCvrnFPxaQgUzOWVHHGc0FZ6DMUGyG0vygMKgJN3pnGdDpUf/big4PUq+k562NqHbHAqwjKjDpJNE1sWVmNRx3dzs/IjDzDrsDFWarygHabTrPltT5z8o3lbg4Bhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=P1BWNKjB; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="P1BWNKjB"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS5ZlQS3416142;
	Fri, 28 Nov 2025 07:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=6LOm5eg1z
	B8wYE3T+o/T4uaFtOtpI6+bVd0PWdiGp0U=; b=P1BWNKjBmcC9OzSTnUGzubDf/
	sDpTtOP+Ht6ENIMLb6aUSMwY8+eHCBre96cT+IyTSnDwOkLMX/A5NhMW8h+jN4Aj
	tgIlEuVB8GkYKEXs3XdP02LV7YXZ+/mwmPBxYjI8Znm1/TrVt664/VVg3lFqZCo1
	KKA8mf2Ut914CPvrwsAWKoPebtmT+FLinWY0aSPIhlGVkQes+d4Qg+ZVfK8JXd9a
	DMJFBKcOGzZjmk9Sg54AWkGQSX7EAdNboqRvbQM7gXhypVRX2nu6n2RSyY/mpc8C
	aA/95aR0UHEUKIwZyz//qQd38g8llr6gJ9DffoCpxw49DVPV1PdXAq0WHRCMg==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ak455pmxs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 07:25:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFp98RUUBvyTiUGAN2dXSl5oVAbkOyCZVQJzCkttHIAfoOGqU0OvNo50nEVMJtKbING7daE+dQYCPHJVUF4Au0NIQUncAb08KrNL4iWSlJB1S71/EuaXNGvrK43tUbGyAYxHEwVu4/e1QnaHX6QDGAWigQWtZVcbXWT2RqYD1Cg7qZy25xlSa37mBWPLbh/6buoEwqjjnbNrhACvSBM6mF8LIMdCHm8l0k341qY90IKKITw+j+mfV7gPoqeQ3lBLK8mG9SGNRLtiAYxkKGfoCqiMfsnUKTGKFxMLV4O9ieW3wijFrTX5nXk+ppxdFwA7LHz1Y3oPdubusVFvu93BwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LOm5eg1zB8wYE3T+o/T4uaFtOtpI6+bVd0PWdiGp0U=;
 b=cVlmkpIQn/gMjutYAYz7ZxjC4mzSJs5haxNFAVUFjs8/ApC5dq6yY+LYKuS0aBK/AzJQKntFavkAl2ZvBxNly2WJI+ovBznaruRpE+lY5PLK7aZBz7aM5iAzgAfIZo6dqkIrMJjQ5VZZFBtkMAulGosjFzFaiVuttnNtEWB0hv44dHQ2+GKjj/yQSwlNcEHfcFdaf7gnNCQ92mWKmSHIZuuZ4UH7ebNtzMsKAvav0u7nFiNcKpFxF0Ch6GADE7HqKEddpYNPFXEi5ooZJlOKuJZxeEISpRoj5hZ8YvVXHObJYfgDjpldjlSQnRUQee/775zdS0G4tNON1ueatGC4Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB6503.namprd11.prod.outlook.com (2603:10b6:8:8c::7) by
 SJ5PPF01FB7113C.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::804) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Fri, 28 Nov
 2025 07:25:34 +0000
Received: from DM4PR11MB6503.namprd11.prod.outlook.com
 ([fe80::5881:5ec3:6913:3119]) by DM4PR11MB6503.namprd11.prod.outlook.com
 ([fe80::5881:5ec3:6913:3119%5]) with mapi id 15.20.9366.009; Fri, 28 Nov 2025
 07:25:34 +0000
From: Jiping Ma <jiping.ma2@windriver.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev
Cc: jiping.ma2@windriver.com, linux-kernel@vger.kernel.org
Subject: dm-snap: there are issues for the rt kernel
Date: Fri, 28 Nov 2025 07:25:24 +0000
Message-ID: <20251128072524.1462256-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0048.namprd11.prod.outlook.com
 (2603:10b6:a03:80::25) To DM4PR11MB6503.namprd11.prod.outlook.com
 (2603:10b6:8:8c::7)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6503:EE_|SJ5PPF01FB7113C:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c44e7a9-6b0b-45f8-b4e9-08de2e4f51cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Z3AY02qp+BrNfWDTlzqlBrJI2gpg3VM0DwXs3u11Zd9YONYVKZlc83k8q8y?=
 =?us-ascii?Q?BM87/lXNyqGzmhL5+fv8yfaLikTWwpLDW4XmWyL3UGu8JKZp5uk7H3yg0ZSW?=
 =?us-ascii?Q?1PmM1hc1JQcyWN6h2+bA/7pkFdpSGXKsHz/9RGGQtPJutPLtpKK6pBoHo1n4?=
 =?us-ascii?Q?+9LL29J+T2WjhndrDuYlXmtpqg3XLx0bKnx6wA2y5O2Qw2I2jRz1hqWyw/wr?=
 =?us-ascii?Q?+Q/+c5jRt23OzaeI9HMS069WwHlSp5MMe5iG5O2DCU+QyCVkwQR2wid3WFNW?=
 =?us-ascii?Q?3sZF7KFlJ+bf7cVBwRyfPBShU62P3zHaGM052G0BTDrFbtdlwN9Hm4Wrl2gP?=
 =?us-ascii?Q?zXf0SMUNGXQkaq2Uj+hQYpA4vv7JYQLKE8WilyF/TbdlTUP+Qz0HtmdGPRDT?=
 =?us-ascii?Q?mEd8Nc/Mv5+Yqpj3jgHneAdvVT7JPPJ3MroQS9DOb6nlgFrI4xoHHkWRVBim?=
 =?us-ascii?Q?QXpnQsUi013xMHCjjGX4SaXLtMaqtFRP5ek060KyLke9d5K/XRJ6Owqqujc/?=
 =?us-ascii?Q?S8VvHHCxgkAB86uVAYwuMP/4R65c1ouf8WBDrRAYv49VkqRL72eQNfYGgxvB?=
 =?us-ascii?Q?YGwgi+whb/igr/1gK2SOD7kYzcQBS98un8BQ2SHNGPBlbI3STHKpZVUOUTZJ?=
 =?us-ascii?Q?bMeU5igGpZjmTujovKK1li78Khvl0Vda3TGXUSC5RZEEHRR54TRZ4DWXrw8L?=
 =?us-ascii?Q?LHg+G4N4/9p+AFHD71/SerTqr2aYhwmSAtQ+cCa0Vx/BRhN75ISvCAsAjeQP?=
 =?us-ascii?Q?oE8RZnWHcRjVKPBaMVT/889lv0GvwitpkJ4BWFBx8OxYh73pX7UwTB22Cs3i?=
 =?us-ascii?Q?2a5pS60f/ufqQtsvO71MZPkgO/+JMDZ5CFxmOqlkr8cKmc6bhQlWcQTRHVh7?=
 =?us-ascii?Q?uuvowBdWswCf13LcoFUZPS38S08kuC5F/1ZYBvis6Jk/dJw9ogkwmOvyBN4R?=
 =?us-ascii?Q?La+0uJLSo4+T7G2hLggTDpqaAPJgT3gKfzpWbP5ybuNk3RJpccEieKNxIoY4?=
 =?us-ascii?Q?eTy/8gdmkG/eRlA3NyebvUMnn7ZNbDP+/6ea3HIWISlLwf36bcmhUnxBulvA?=
 =?us-ascii?Q?knpr7visZWteqxBee/7HVOcZxP2s0nqj9xenT11VGk8Jpg5Mpj0VCTopJgnr?=
 =?us-ascii?Q?VR17cB9k9LvfsDaa/zxwddrLgtbjtAtE0+bJp7+7HO6FGyYd8F6t2LnxEctB?=
 =?us-ascii?Q?n5m3ycLk5dVvAq2gkKLEWCmZuuP6FwypRXoiv0Ku4W/jjVMQx4Y/RVyhjUg/?=
 =?us-ascii?Q?jIgsHXIECLOi9Dreiyy5K1ctDGAsGJ/VfJPKY7kIMgReyTQDWJuYtG2b8D8k?=
 =?us-ascii?Q?wB3IwSTwS9e4ISAsadpuaHszYreETdjjP55zQYL3GFJZCYc4GiCMtW/UqUku?=
 =?us-ascii?Q?NGxsWjB8soWD2yEtMj1JOG7iwFVL7LhpNY9CI7xNlXZ7MUdF75n1pvyixfq/?=
 =?us-ascii?Q?co4+Jrj7A2ylfbe2XZNG315kNGkYVkNuYf30lkMbLV72ctQgcpC5trLH1p0b?=
 =?us-ascii?Q?tna3OTkui9Ewhv4UHnsuEEqp2xL7PUZGDnO/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6503.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/cpb+6r85FpVB8gGiZOzz+M2l1Bq1x075BfsfyZD2MfARVh7mZtQXac0C3Bz?=
 =?us-ascii?Q?O8BUlqb+dilW9EbowtEPxdjH8gEHv5TTIjdxYDCoBbuQjghCkGgDJ/4Ao6Eh?=
 =?us-ascii?Q?lLgSByWM+CI+gsM/fWQdB02Jx21S+JUcINA0iSyV5GNxZwOsiMV9tAyzQQo7?=
 =?us-ascii?Q?h863nURWy0pUFHkwqvUHZHKtGJJLYEWpyRTP5FqAmbYLCnd02gkz9FuNzMCw?=
 =?us-ascii?Q?7ZfrZ8CjD5ybFuFisStq9BoelFeEE60s/gUllGa2+IOyKI2wWxvhFM5wTa/O?=
 =?us-ascii?Q?WML72n6dZeZg1fp7HdHirp/nBq1ZSKoh1/oCu5jsZlsMnuq7GLIq24zC/ggz?=
 =?us-ascii?Q?z+bzq+vBs65JTlhul0vi3JGhmcRf07TJ1816/njS0WwZgtYecw5wcNYXDjUP?=
 =?us-ascii?Q?fb9FfKRrfUQMfh//qTMt1VpVO2IrpP8xLz3qPuoOZP9dLPhiiUEpU48f0ufa?=
 =?us-ascii?Q?x5VQc86ZXuGaDfhB53R+UN2dWmIeJf0hNIwGNo19tVuCFR/E4p212uFQM6qZ?=
 =?us-ascii?Q?hge2ka8F0dZGs7v+BU1UjFuKNCDo/xR9BxDDcbXn6Qb8POsmS9xIL5AKrXDR?=
 =?us-ascii?Q?MkxKF+0KAQjIkcMMpB7iVrb3+HC7ZvZZDmXR9fl+44DsGwFydPpqzyRR2+Q4?=
 =?us-ascii?Q?9p+aHeugItZCeXf/JQv+79pNq7oumWEi6hVQrPqLXafmZ7Re8XDpCia85W0b?=
 =?us-ascii?Q?GQJCEQMa6DY0xoZCnvDqVCDS3W7X01UKgy94BvqQqJr1dFEIM9zeAdYJpY09?=
 =?us-ascii?Q?BTkxLSUcTNjxIuXsihiYAG9M1oe4lTR39MtivzPKzNXvjQjDa/uktz8chjDy?=
 =?us-ascii?Q?x65CeQEPIBzptrqGAkWxwsw2WAngFn6/8nDfIzGEMPlPAVrNkXdbtjbzapXM?=
 =?us-ascii?Q?q2FeAwuAjLhpTqR83emUYos3XOBdqimOWvCkbsD74VFJVd7djuJRRv3qPw8g?=
 =?us-ascii?Q?HEMv3VqHyohMMsof0hb+T2Yy9VgfA3B5J3Z+otbTn4LdfLz4s1zix0U+Cki3?=
 =?us-ascii?Q?s/bMvoTzGf5oGVkRjoZO7kJLDIp+CCS3Ys6Ggvjc4MiHziXPtoD9BfqpgvjB?=
 =?us-ascii?Q?s2X8nxLObtngAfcuw8Evxsz3/URAtR9zof4RRX8R+bilPRaIEzgYgWiSdfTx?=
 =?us-ascii?Q?bR+J2UZGBph9bhE4ynQRb9CX9xILXinAh+VNRc+68n/2TxmcLXuFiHrWxhgt?=
 =?us-ascii?Q?SUrP754xP+XbipqB8tswY2t0Iz9kOxQXYnBrFsq9GIy+ClND9Gmkfflu9/xr?=
 =?us-ascii?Q?GPN5Oo4dDR0wQIB5WTksX3SqQ2e3ORe5/Y2nI6ozEafqqFL4+0NtaPD8WJTM?=
 =?us-ascii?Q?LAyMRhYR+3xC1/Zo5NZ1rcttnh9fJhIw+rwI9YXzZ8YGpHQ7VxoSJfb4ExfM?=
 =?us-ascii?Q?F4Aw6wDqTbsk2U3btQC5qUemVdhXoXAUE7GnEQ+0eJkKiCAK3ByDwiT+8FEM?=
 =?us-ascii?Q?hJ492Rkk74RPoih7wROOupN0ZttjM+x5SdGdAX4T12v5InSqRvBSkUM9csX3?=
 =?us-ascii?Q?NqENBvMdRdI2gqadAd9yL4GOwdc0M8XhqH16EvXDDs4T40M4tbO/H/30zJci?=
 =?us-ascii?Q?XMuppRAlGxgDFZgLmuJdaFvW0FPotwHLbTEKSjPhhxigMKZU4pECxLt7k3Tc?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c44e7a9-6b0b-45f8-b4e9-08de2e4f51cd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6503.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 07:25:34.6109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqIm6Ny4vTxe75Lsi9NwA7yBdzbZJUbaDkI42BMcu7vBHKoD2ZlEwpv/spocyUFa6NAlBCADAfJqGYD4quprNaNt9MbxushXkpOfiJ8MkGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01FB7113C
X-Proofpoint-ORIG-GUID: S7gUs-emrp-GvP8BJ3IS9zXozwje3xkM
X-Proofpoint-GUID: S7gUs-emrp-GvP8BJ3IS9zXozwje3xkM
X-Authority-Analysis: v=2.4 cv=T6eBjvKQ c=1 sm=1 tr=0 ts=69294e71 cx=c_pps
 a=vzv6YJZFwQv9rWyERtU3yg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=k1WYu_JLADfj9mKxDE8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA1MyBTYWx0ZWRfXy2Paa/8VfiGr
 fsx6le+PCfU9lo5/FyOu+1R39zS77PnEsuUZJ9Q5QVbWZs9/v43fEXxEYCZUqduYQKRozoMas/g
 9lv6UKC5lM+UKOn4iuWQ4eSVOlPt5is62e2ujCq5Rf6WBCGehmLbAnHSfNSs9yIPb5MSrSKdq6u
 9DhpP+gePsEPHJtD54cfM7fZm7XkxDU5iFrC9MctoNoa0OB8rsL9PXhMHwhP1i+gna0sor8Bw/x
 dZP9WMJWJ7jQ41x9bZHUvNsFWyLhb34+fbWhSvG1t4TAenMYG7sqgf4hkEI/1UU6N1usoVlIhII
 hiwXWqvkvAdyILryePMv4H6i648FTkbuJCnnx5grryGqlzn8wsG1fXwvX77NMb59rdBvhALSqfD
 d4C9zInQerGmGu2E+QK6JN7gj6Y8wg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511280053

We observed instability for the rt kernel under the upgreade and rollback test in 6.6, 6.12 and mainline.

The issue is related with dm_exception_table_lock(&lock), in which function preempt_disable() is called twice.
The code block is between dm_exception_table_lock(&lock) and dm_exception_table_unlock(&lock),if the code involves rt_spin_lock that will trigger such as "BUG: scheduling while atomic: kworker/u72:11/349/0x00000003" because the preempt number is 3 in this time.

There are several places that involve the same issue in dm-snap.c, such as dm_add_exception(), pending_complete() and snapshot_map().

Do we need reimplement dm_exception_table_lock?
Any suggestions or assistance would be appreciated.

[  862.410151] Kernel panic - not syncing: scheduling while atomic: panic_on_warn set ...
[  862.580196] CPU: 2 UID: 0 PID: 349 Comm: kworker/u72:11 Kdump: loaded Tainted: G           O       6.12.0-1-rt-amd64 #1  Debian 6.12.40-1.stx.130
[  862.593223] Tainted: [O]=OOT_MODULE
[  862.596714] Hardware name: Dell Inc. PowerEdge R740xd/00WGD1, BIOS 2.24.0 03/27/2025
[  862.604453] Workqueue: writeback wb_workfn (flush-253:21)
[  862.609852] Call Trace:
[  862.612306]  <TASK>
[  862.614411]  panic+0x34a/0x370
[  862.617470]  check_panic_on_warn+0x50/0x50
[  862.621569]  __schedule_bug+0x4d/0x60
[  862.625236]  __schedule+0xa0c/0xbb0
[  862.628729]  schedule_rtlock+0x1a/0x30
[  862.632481]  rtlock_slowlock_locked+0x20b/0xcc0
[  862.637014]  rt_spin_lock+0x40/0x60
[  862.640506]  __insert_pending_exception+0x4e/0xe0 [dm_snapshot]
[  862.646424]  __origin_write+0x2fb/0x360 [dm_snapshot]
[  862.651477]  do_origin+0xd5/0xe0 [dm_snapshot]
[  862.655923]  __map_bio+0x17c/0x1b0 [dm_mod]
[  862.660117]  dm_submit_bio+0x1ad/0x5a0 [dm_mod]
[  862.664649]  __submit_bio+0x144/0x240
[  862.668315]  ? __submit_bio+0xc1/0x240
[  862.672067]  submit_bio_noacct_nocheck+0x19a/0x3c0
[  862.676860]  iomap_submit_ioend+0x42/0x80
[  862.680873]  iomap_writepages+0x5f8/0x8d0
[  862.684886]  xfs_vm_writepages+0x62/0x90 [xfs]
[  862.689473]  do_writepages+0xcc/0x240
[  862.693136]  __writeback_single_inode+0x41/0x330
[  862.697756]  writeback_sb_inodes+0x21c/0x4d0
[  862.702028]  wb_writeback+0x7c/0x2f0
[  862.705607]  wb_workfn+0xc1/0x450
[  862.708926]  process_one_work+0x179/0x390
[  862.712940]  worker_thread+0x237/0x340
[  862.716691]  ? __pfx_worker_thread+0x10/0x10
[  862.720964]  kthread+0xc6/0x100
[  862.724111]  ? __pfx_kthread+0x10/0x10
[  862.727863]  ret_from_fork+0x2d/0x50
[  862.731441]  ? __pfx_kthread+0x10/0x10
[  862.735193]  ret_from_fork_asm+0x1a/0x30
[  862.739122]  </TASK>

and

[   36.563812] BUG: scheduling while atomic: lvm/1380/0x00000003
......
[   36.563841] CPU: 32 PID: 1380 Comm: lvm Tainted: G           O       6.6.0-1-rt-amd64 #1  Debian 6.6.71-1.stx.104
[   36.563844] Hardware name: ZTSYSTEMS Galene EI/Galene, BIOS 1.01 12/07/2023
[   36.563845] Call Trace:
[   36.563848]  <TASK>
[   36.563849]  dump_stack_lvl+0x37/0x50
[   36.563855]  __schedule_bug+0x52/0x60
[   36.563859]  __schedule+0x87d/0xb10
[   36.563861]  ? update_load_avg+0x7e/0x750
[   36.563865]  schedule_rtlock+0x1f/0x40
[   36.563866]  rtlock_slowlock_locked+0x232/0xd40
[   36.563870]  ? __set_cpus_allowed_ptr+0x55/0xa0
[   36.563873]  ? dm_add_exception+0xb4/0xf0 [dm_snapshot]
[   36.563879]  rt_spin_lock+0x45/0x60
[   36.563881]  kmem_cache_free+0x182/0x480
[   36.563884]  dm_add_exception+0xb4/0xf0 [dm_snapshot]
[   36.563889]  persistent_read_metadata+0x29d/0x550 [dm_snapshot]
[   36.563895]  ? __pfx_dm_add_exception+0x10/0x10 [dm_snapshot]
[   36.563900]  snapshot_ctr+0x60b/0x8f0 [dm_snapshot]
[   36.563905]  dm_table_add_target+0x246/0x3b0 [dm_mod]
[   36.563919]  table_load+0x136/0x4b0 [dm_mod]
[   36.563930]  ? __pfx_table_load+0x10/0x10 [dm_mod]
[   36.563940]  ctl_ioctl+0x1b3/0x500 [dm_mod]
[   36.563950]  dm_ctl_ioctl+0xe/0x20 [dm_mod]
[   36.563960]  __x64_sys_ioctl+0x8f/0xd0
[   36.563964]  do_syscall_64+0x58/0xb0
[   36.563967]  ? dm_ctl_ioctl+0xe/0x20 [dm_mod]
[   36.563976]  ? __ct_user_enter+0x2f/0xd0
[   36.563978]  ? syscall_exit_to_user_mode+0x32/0x40
[   36.563980]  ? do_syscall_64+0x65/0xb0
[   36.563983]  ? exit_to_user_mode_prepare+0xa9/0x190
[   36.563985]  ? __ct_user_enter+0x2f/0xd0
[   36.563987]  ? syscall_exit_to_user_mode+0x32/0x40

Thanks,
Jiping
