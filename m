Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B2627A130
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 06:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763534373; cv=fail; b=cpixxpkDq54L/Sn0KVwxKNDnJAIamCMREUywGAtv6iqu5CHL03owVrtIEnEe+ql5G0AJ9+An0WYnCZrMQn6yTGOYKADQbYuUqBop9Inp10Ne1hHnzmBE50QnFielSh3Mr/9gwo7mptjjTCZBJdwYVJvLD95/6s95k9okbuxVFD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763534373; c=relaxed/simple;
	bh=Xhp7HAYmjqEo+BvLh67/XhKOXSCs6b1SfbxwIu8yfzo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Y6BnVrxP7k0c6vpOscIOvWHzyfj2rqbvSDMvjw/7E8Zy3W/Qjt0l6DLVcIYgRliFbHtznCNFYqqkET/xt+681fprHnNtrLikikP7X3RoSzAjASTNi+Myt8AjD+EIb5ti9Sv7lHakm9FAxn0k6HTyVgeQX2obvKCELQR0PUKA5pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=o3R/q80y; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="o3R/q80y"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AJ5ob1M3893201;
	Wed, 19 Nov 2025 06:39:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=HUc7Pfcwu
	PxnpENm/adm7NaQV/B0yRBnjBr9slUVR3c=; b=o3R/q80y2wfJ2H1Rz0Onv+uzs
	F7rU/YNpI5QfpSACe7/W7RK4J0aixNdrmMUTPhmZrp4SoTJD55CD6zJAyFpGLI6a
	hq3y+bNd4ta4Z/t1+Zl8/4NVxSQpPu7zOHriz3U3XBLuX5HwnQmrhZYvzhxuLkKC
	edmeaYLLuP8X8n3x19NbAHMSYIvL3VmMoEnvaMjBiM4dpFLvoaVYlevovxVfUrp0
	hmmp0uYBGYs1oEzQoUov6/ZlQ0n3b5jpZy0udMl1F3ctk4grFc2SeCNdnj/4xI2j
	OVxaSLjw0qneJFOCUhx0F4Eax0cmnlsb5K8ffo+b6LDYbvqFERW+iCr/Xe4wg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4aeeqwmpgc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 06:39:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEkDNygCWvExF9eqxtHKk/ZvzkEP+UIu4mAOTkO1pdI2U4XP2tkAa+YwHSHwFMra1doH5h1d8YdU5pvzgR9allolf9kTpzUxctL3BAWIbqTV7jkWutY3wasfnLFzXs75f9uSDQX8ckTJvF+PbdRIWW98WR28tEPpvfTLS+A4pISLz+k1TdFwGmWDc8NgUoECCsTNKlRQvrQ9pOY98ZtcX3bvg8P9wurEDB2KdjL4GWLU/8s9hLEjwA0p9qzvaaaehIm3Zj+RyNQdeSP6fxO0T6vL3UkUbrt5PzcavAU6eF4Nc0Plvqqfq34vskaprrTCyv/fbXvGhnEHgJ7CAgLOSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUc7PfcwuPxnpENm/adm7NaQV/B0yRBnjBr9slUVR3c=;
 b=H1afi4nwuJ2GWHfDzOmc633CnY1cHoVW4zy7DHBsCzoBTgP6sueWA0QWGckBrYmQ5LK8RVcOjslQQa1K/Vqn1mkQyi+8O+cx3KhH983wpJmHNre8bmPKUUXAMlwESM7+3Yjrf2DVpMs7dVihZdczCv+l7fx8Mn1sueqijKuUDF52IaKTVG6zzh5jxXLuW6sBBZ3TH3SvF8Yk4sB7ninPGSr5MgczW0Et7oca1pC0Qhy/abkwmWDzpWFTarKb7IWWrzS+VQih/9IjRdHP/2sWpAyDtlA3hEkybKAiBwZGhuFUPSN8eOx3h9qAa/YtjnlgmiKS3izz0eF0FNs6F/ZnmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH7SPRMB0014.namprd11.prod.outlook.com (2603:10b6:510:127::7)
 by DM4PR11MB6429.namprd11.prod.outlook.com (2603:10b6:8:b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 06:39:02 +0000
Received: from PH7SPRMB0014.namprd11.prod.outlook.com
 ([fe80::4d72:5875:d040:cab9]) by PH7SPRMB0014.namprd11.prod.outlook.com
 ([fe80::4d72:5875:d040:cab9%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 06:38:55 +0000
From: Jiping Ma <jiping.ma2@windriver.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, jiping.ma2@windriver.com
Subject: BUG: scheduling while atomic: lvm/1380/0x00000003
Date: Wed, 19 Nov 2025 06:38:48 +0000
Message-ID: <20251119063848.2461235-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:254::11) To PH7SPRMB0014.namprd11.prod.outlook.com
 (2603:10b6:510:127::7)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7SPRMB0014:EE_|DM4PR11MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c6fca38-9997-442a-0a88-08de27364ff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pj9VnZufhB3GM/V1Zy3ykmpYHUk9CqnkfdxYK8dKNwc2Y8e9NgqJVo93Kx2v?=
 =?us-ascii?Q?RuVDeFGKQ1XmOty7F5ovesZgLqSquy1lGejyQvkNd+2cIsG9oxetL6yc9AnV?=
 =?us-ascii?Q?dvtz8Ufj/713Xr5buT+Dmi6cn9EJQ7p73Zs8X5I61Wp9YWN3fKLWtH6EpWrA?=
 =?us-ascii?Q?xaQ0JfhfFilLBYKVI6o3etQf8yFe5zGMqDwh7zbHEMjeA7GEQxC3JQj5GSq1?=
 =?us-ascii?Q?V15eehhlgpOwXZowFsxu4S8T/Mz+oPwgiiNOzwxbD81857h24+Mv8Oo8/tNP?=
 =?us-ascii?Q?tvKwzirvv0sMl6zoAmRRasrhCYiubx0Up2jo5ogk76vablFNGfhicmTA5Hku?=
 =?us-ascii?Q?l6PRyk82z+nFgmlvsz4s9zC9ZQtoARLPuBjXUmzWFEO8Bh8W1bav84/4f0YI?=
 =?us-ascii?Q?BG7t+IxWLlsuEuNLKCfJCSiw4jAgRwERxlgtgUc2jihzLAPc1G1Sfu4V8++n?=
 =?us-ascii?Q?xJ8sPDCE1rn0l5qwHTYPQACiofcUx0QAl4NGQNkjrHegN0ClbLiVd4uNQ0nE?=
 =?us-ascii?Q?V8pqXNmpsbUYzoHX2eHaQuBlTGsCtcGfR3A9FopQQ318nun9DWtrbErhAecF?=
 =?us-ascii?Q?i/JFN1RTyUF2tBv0LH/YoVFByHwNztU1KaFBuEQ4Bhl4BrBxBDXUkY0sueWX?=
 =?us-ascii?Q?85Dwmk2Q4OQqaayPsdxzLmFu8BSseFjscFZNPSrdwgvAApImJOxOgrsF6MKh?=
 =?us-ascii?Q?GTWMdR+8p+lPztoIy16zQSmRKuL+sBdQY6e6ICYfUOTKXvaRpja/kpommdAV?=
 =?us-ascii?Q?NgJmNI3IE7t5sk6fQSbomI4+/Bt2M+gLVNkWb3k2Y7AECuIgQWnbJYKlrafM?=
 =?us-ascii?Q?NTEPCQk74sdCTXkl++PPNyq84K6E2Y/CXgUImFXkPx9Dh8AwAxqzYX6zM3Qv?=
 =?us-ascii?Q?6QTUs76l5ANlKDmqzJ9l7e4Dl6MJptO68JZBHybUZ5QGrjw8fcuG3Xnjw7Ce?=
 =?us-ascii?Q?+1uw0Uu9+JscOyxs7UVZfKsIdI4655mSfaz8dR+AGadbHxwpY8aUVLpnwBfI?=
 =?us-ascii?Q?KsbEU5rD2GX4+MF6uN1ajZFDgpaZxgzJfSKt3dODo8ujSTmCks2kjhJQ1Xf7?=
 =?us-ascii?Q?opM2vq/JZujv/Wyyfpu0yWk0rqLXZ+0fzm3IQXkYbtgbnrEp+FU/z9kVyxB5?=
 =?us-ascii?Q?4VzaCzJwDWYKf1xwQlUYhH2d5QFAO1uPzCr8QABUl/O5H/YCvRXiyRW2m+F8?=
 =?us-ascii?Q?awVv4dvGZ4LSYQ8xf+TIC1MoFKSjcI0CyZjtuP0ydvXzZ3374X7um0g3Vxph?=
 =?us-ascii?Q?Iq6TmmG3fsvirMlGKFN3ne2DKRousZ7gv1RQq/3izCYqPm6shPmbdmeV36js?=
 =?us-ascii?Q?XIlaPoJHKmTcAUWIzfjbEZZDvNq6WNoA5gyGqxK1DD2VhFPVVPQPpfBbuA/n?=
 =?us-ascii?Q?evcBjQ3nxCVuASECdrRdG5iFzcTXIUi5a0p9odpMjvWpY0MZriw+zcyJVdTr?=
 =?us-ascii?Q?3jyIVnXcm9Zhokeecu/Wx1NHWYWGoXFbrHETfzz8aQH6eAcOhP6HkXeGOFl/?=
 =?us-ascii?Q?O/0vEW44lGD4kyT40BcFK9i0WmNGqqLAsO0O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0014.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f+udDx7Zo5181FuIAJw1SSLnLOO+ZTicY7KszLZQv3BmMkt3AhyC+dxcbje8?=
 =?us-ascii?Q?SOwy6/uX0RK8Viy/gjn3bMj4uJfj4Vtxu9g55cvN1hUCvstPvVF70h8Usf3U?=
 =?us-ascii?Q?6Os+RpVbqJKonYBCCUE3w2m10LWLGluaC6YQU0vn/hzjOrCf6EuB9Q0W/9P4?=
 =?us-ascii?Q?BWAIggZ94P+HOmxi1p/VW+9BWFdazW3OW2i7x0DvS6PW4V84BEHeWQlJppEI?=
 =?us-ascii?Q?iEXavZIQ1h7T+p+I56aF6xk2ns1xVdfjzFpYF0lpx+u3hmkQ/xmO4FJCDySg?=
 =?us-ascii?Q?V0QtZ6RtM/WvcMx7nPULwKnfc+IpbDm30cngJxnxtnlwyHEv4gcBifbK8X2/?=
 =?us-ascii?Q?veeG8elV7Ab/tNv12lspgWDXpp191LWE94J0Syuq7TVPiffniS6lpRJ95W9X?=
 =?us-ascii?Q?ZHmO358+K0Xjd4a2VIYA+TQhhiFrJmRa3LOWGRSdYZjhUjy8IaF7ATp3otLd?=
 =?us-ascii?Q?mQ7pDMN3Lzo36nXPf0c9vWF6MJ4IRGUBxu7lklTWV1SJrzqZ5Yyc2Ug30ybt?=
 =?us-ascii?Q?xYMhHl0h2JaXSl3V5gFT24w4EWL3b1D/gHBDOaOcTu1wVpGSGWWaMVg1UPtF?=
 =?us-ascii?Q?uHEIXesNHd2Ivfa2xxYIe0/6XyK4vT4XI5dotVzV2qEcC2itPkx/aaQ1W0ig?=
 =?us-ascii?Q?EnL+9Ik3m9IoW0HsfceSkP/ZbYBclyOrIR9x7BhpiPXqOF63VOamLIZgNPZ+?=
 =?us-ascii?Q?ISRZz2FMFH+p81raX/BM/6RMVupxxzecSJLDL1OprBbaZJ7Y1mIQYGa4UqOX?=
 =?us-ascii?Q?GID/pRe09cnTZ2OMhZBMmM+sVyWJxyhLHJuRfb0wBpMnLRC+fWpk6CNflFXm?=
 =?us-ascii?Q?Blwgh35h33pU5mPmq1/9yEyc7y8G+WT6tloQFO/65JU2kR7gErp6RG95/+Ik?=
 =?us-ascii?Q?kwBMR4hRnHsdzKki0lrZU4VTIuNwe9FFXqJsjXm2X1Ki37zEhP0Na+qQ3YJc?=
 =?us-ascii?Q?jiWRIFUVBl4siisD8Cz5qLSxtWIwKwcF3+xev4JcHWFYXolkRFXZ+xtnblDz?=
 =?us-ascii?Q?IqpcrKeKznQNVJkkqukoPQoLVhuIz7ZLn5i4GHn2rT0+9QgEfPqA6Ce+HKGI?=
 =?us-ascii?Q?DCBwjUzXzUllqVRobPSixSWyIeLSgRaWT7Uwo8m+xmfzGrjuUPKGAbjElTu6?=
 =?us-ascii?Q?1h+RGxs5ABS9vSQPxSXXpFVX+C1rCy8ZyAB3OkZ27jQDaKMcgQclS8ffTEPO?=
 =?us-ascii?Q?fUkFrMLSvx9LS31GqP7bD7lvP3oG47mH4E3UGfInOIKNCalfN8PzAYz8Bh9k?=
 =?us-ascii?Q?RgUuXuQiGWzcudSpHvJ/JtZV7fsh6OGJJ4eDUyLkLTf+waIzy9+B8GOoCOCL?=
 =?us-ascii?Q?WxIbgAOatUlZewH5GwW+7ilWgeWiWbwJ2F3oDLs+13cCGqRJwcm8q1yrTzNF?=
 =?us-ascii?Q?nT0j3d+3W61jIJyKQUsTS7V84Kfy9Qf3f2LAOZMTgbrSxG9+jQcOfkzh5fM7?=
 =?us-ascii?Q?JWqfOzxMowpRehPMIvdSr423NC8P2/tfknB25xEkVtht3fd77ThSiJWnt4jN?=
 =?us-ascii?Q?xppAc51fmoZ3UY/eMkboEotVJPz/uBsljzJ5pfuxcaB9FRstvZ/V4Q1LPNvL?=
 =?us-ascii?Q?MIZ3cz3GkncEyjdbtc/tehSM6veoXdQn2JwMau6gqt+Dx5PkdrEnXCmDfUXY?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6fca38-9997-442a-0a88-08de27364ff1
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0014.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 06:38:55.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2AkfEHeh5Yh2KcvUOY5UJuDZUQ63kySlPsBW7Xe/EA1KA2LJrwj6tsyQLcNhlIms3IG+aVH/cNoabUwbbDzLdiMWaEB+AReh0VBjL9tG/Ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6429
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE5MDA1MCBTYWx0ZWRfX9+6gmQ3yn05M
 roxvsGS67Va924SKna1el+E4wK3U/OARXd2B09TZToU2EQv/TL0C8VzFJvFBLmv1M9g4brK1ifF
 BakthPuUM6IBHvHPsGQ4AOCiGpeBvxQU45xfpYIbwnXyJ7oKxZap1wDNHDYdn9vay1sfxIXW7aN
 hs/m6NHvidz8YNRY8dob9JT5cfCvzs8h6XQea+PwSLwmRI5DzcPpJSmHOybzevLkWqFqcL/dStU
 XC0att4tq4HdGjIQriVb9zuUm6b1YG6Z8juPNgb3Gs2SG9hBbKEBCVfaTY80eDqfUZFyz7/Cfv5
 /uXTjDi2NIiYOKEYN6i4ay8eqGfkrgTkSsqqNeuyHHey98nW4OZBR+4D/1oUyFXRFaEcip7Q2E3
 1I+eNHxrol2Mk+BC/ZCEgJtE90Tw2w==
X-Proofpoint-GUID: PT2wYHePGKZbAqI_OQcz7D5Ya3mMdyUy
X-Authority-Analysis: v=2.4 cv=OuxCCi/t c=1 sm=1 tr=0 ts=691d6609 cx=c_pps
 a=NVF+LlzI6OJHpaJcpVMg1w==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=u53OqzRQrpnVx2Ykf_MA:9
X-Proofpoint-ORIG-GUID: PT2wYHePGKZbAqI_OQcz7D5Ya3mMdyUy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2511190050

I'd like to draw the attention of the dm_snapshot maintainers to "BUG: scheduling while atomic:", the kernel version is 6.6.71.
The issue can be reproduced during rollback to the old version(6.6.71) from the new version(6.12.40).

We haven't yet bottomed out the root cause.
Any suggestions or assistance would be appreciated.

thanks,
Jiping

[   35.418736] iTCO_wdt iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
Discovering and coalescing multipaths...[   35.481177] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
[   35.481226] device-mapper: uevent: version 1.0.3
[   35.481395] device-mapper: ioctl: 4.48.0-ioctl (2023-03-01) initialised: dm-devel@redhat.com
done.
Multipath activation: SUCCESS
[   36.563812] BUG: scheduling while atomic: lvm/1380/0x00000003
[   36.563817] Modules linked in: dm_snapshot dm_bufio dm_multipath dm_mod iTCO_wdt pmt_telemetry iTCO_vendor_support intel_sdsi pmt_class intel_uncore_frequency intel_uncore_frequency_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl intel_cstate nvme nvme_core intel_uncore t10_pi crc64_rocksoft_generic idxd ahci crc64_rocksoft i2c_i801 mei_me intel_vsec idxd_bus crc64 libahci i2c_smbus mei i2c_ismt wmi acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter iavf(O) i40e(O) ice(O)
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
[   36.563989]  ? do_syscall_64+0x65/0xb0
[   36.563991]  ? __ct_user_enter+0x2f/0xd0
[   36.563993]  ? syscall_exit_to_user_mode+0x32/0x40
[   36.563994]  ? do_syscall_64+0x65/0xb0
[   36.563996]  ? __ct_user_enter+0x2f/0xd0
[   36.563998]  ? syscall_exit_to_user_mode+0x32/0x40
[   36.563999]  ? do_syscall_64+0x65/0xb0
[   36.564001]  ? __ct_user_enter+0x2f/0xd0
[   36.564003]  ? syscall_exit_to_user_mode+0x32/0x40
[   36.564005]  ? do_syscall_64+0x65/0xb0
[   36.564006]  ? do_syscall_64+0x65/0xb0
[   36.564008]  ? exc_page_fault+0x3f7/0x740
[   36.564010]  ? __ct_user_enter+0x2f/0xd0
[   36.564012]  entry_SYSCALL_64_after_hwframe+0x78/0xe2
[   36.564015] RIP: 0033:0x7f092a7fe2e7
[   36.564017] Code: 00 00 00 48 8b 05 a9 cb 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 79 cb 0d 00 f7 d8 64 89 01 48
[   36.564019] RSP: 002b:00007ffe43a0fa58 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   36.564021] RAX: ffffffffffffffda RBX: 000055622809697b RCX: 00007f092a7fe2e7
[   36.564022] RDX: 000055624b967380 RSI: 00000000c138fd09 RDI: 0000000000000004
[   36.564023] RBP: 00007ffe43a0fb10 R08: 00005562281fc6d0 R09: 00007ffe43a0f8c0
[   36.564024] R10: 00005562281fc3f8 R11: 0000000000000206 R12: 00005562281fb98a
[   36.564025] R13: 00005562281fb98a R14
[   36.564025] R13: 00005562281fb98a R14: 00005562281fb98a R15: 00005562281fb98a
