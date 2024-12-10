Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D415382
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 01:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794128; cv=fail; b=lXyKrJn8jhbqgMvSUeOC8CdWV7KbcZnQogXDMKjjTF6uZvI13oc7Tu3UtSMH0niGAnPaadpfQ9hVGow/ViT8ZhC3B1ZVjHassDnt6Xfk6Jwby0W/0wNoLXZq9EYseUF3HIgYmean4Dz0xT4OUyldqvj+ZzW9X2XUbHLKc0CENH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794128; c=relaxed/simple;
	bh=U1lQTTOAkHSTf8UuUFTI3/flE1wIn0DqSW9LEnicW3k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eRS2WVnNs2Y7PsID+UpbngagaS4hEPga8n0Hznv/K1LN4eEJpMdJRzHYWV0ox7fP2dC+RRwfvaIzOTeB1g9/yZ7sgoNH9LhscoK7Ed/2wfnJBqFM5fStNEB89VzEhVOxVgk/FTkOfxyTlce5qJ6/vBdSZ+/lAkFnwuEqHA6oAu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q8pXQn1f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rlNRDL8J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q8pXQn1f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rlNRDL8J"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1Br9s015768;
	Tue, 10 Dec 2024 01:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=UctlmO7/vd4NQl4Xvg
	s3YM1mIHjH0lZYuWnhx/SpYzA=; b=Q8pXQn1fPAX4BUYECVJQgrhOzlFhqhdqHP
	r/+PERnVUW/wUAjuzN4CKYkEJYN1zCWI2rjY5jH22g6/vmzkMVQoMSEs5LKSCeV4
	CGy/QZtd37qGxZad54gxI04QcnEUm5wRUyb0O2sZ9ev930zI6ELMMzs4g24YL5I1
	AMa5kHNU4z9fsyjcZAUsDiMlgHivaO8meuy4cTcIbdLx66LVQLjtdH3wDRm01bWI
	ZaDebc00XYIcnCNvdjLtGKLi1o+T3CGmE4Vby1JxJkEDfOLEp6W63sQoQ5uDmle1
	N9qgkFujOG0Uh/f5xrsv6w26Xr5D+2kVPze9v/mISWMMlYYRTQqQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cedc4p08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 01:28:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1AeQK035607;
	Tue, 10 Dec 2024 01:28:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct822ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 01:28:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=audtdUJIfcw9FMzXOL2eh/VV9JdZT2Fh8llRBBVPW/R0D8EdABSxmrkY1mvjyEUalld3D1qpdoqqYCRwpGczx6Lbtq2poeDKZckVHhvbzCmoyeCPikvkNn5Axh8ym9VPwf4A3tqE2uWM3egdQGKfI5HpQYlvBBdHu+7hQqO+wNf7lN/QcvuJarbQmG5/N4W5rJDgXGTzMoVxXBPLXJQC+8O/waVDnzF9Y6AjNhgqRLvZFJuSRyVntG8SEx0+fKAEEpyly5HiG95cJVJ3xHpRP/tfDCWn7EtTHl7YFNtFN1CUYtGjt3k6Q1IYDHykAX0VbjB+q7cJzCI865F4HgaFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UctlmO7/vd4NQl4Xvgs3YM1mIHjH0lZYuWnhx/SpYzA=;
 b=hRp08cTWzqwDlbXGxzkna1Ol/KPvWmHByOlN8B9xf2JWRVY9CxQ1wQQijz9Wm9d6fYCTwPpkI6fhOYvv3O9w5bWZi3m4DCKh58LFlxcKg3rn4Y831oB5mm5nzsMfiFdSTHWou9O783GeDO1OsSxj5FWlfN7cAivwmOanjBmKrf5znsbtePSrb/vJ20w25ba/1YMk3Efr9zxp5p6mOKzeqY+oqUIlyVJ0kHvur0Ko/e565mDtaU5C9uj9Dq/1jioVbeKF5JQSEa3ucMRWI7u0rlQgnkIHiorVgd7724N2GCpB1wO4x8SN7zGtjAUrUdswXgz33gvPkWL2YKrIL4c01w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UctlmO7/vd4NQl4Xvgs3YM1mIHjH0lZYuWnhx/SpYzA=;
 b=rlNRDL8Jvv5Z+9DyzGcYocbI/LeFsIKkro9WX5j0saE388dil48TkFm3527HXk55KmPtACLoTWAlWFIW3bluWroNnH6XQH9tHET2WBg981TW82zmNwvcAvGl1F69wYcVxa9wNCEh2CjPwgjLPEzowNaUiZp3sGVIFXzlwfzlZf8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4826.namprd10.prod.outlook.com (2603:10b6:610:c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 10 Dec
 2024 01:27:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 01:27:45 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mike
 Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        Christoph Hellwig <hch@lst.de>, Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/4] Zone write plugging fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241209122357.47838-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Mon, 9 Dec 2024 21:23:53 +0900")
Organization: Oracle Corporation
Message-ID: <yq17c88miq0.fsf@ca-mkp.ca.oracle.com>
References: <20241209122357.47838-1-dlemoal@kernel.org>
Date: Mon, 09 Dec 2024 20:27:44 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:91::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4826:EE_
X-MS-Office365-Filtering-Correlation-Id: 48265acd-1947-4469-f3a7-08dd18b9d986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NykzCfgqbNmxc4ZpPmdaYTUOyUw0U/w0uwx/myKNjld0a4hwitjuDbxeAljt?=
 =?us-ascii?Q?3uzczzQG7T5iL2deHq/GYuGjoVvf9LNO1iGMLRqbCuzL4I8Vg8T7h4thwy59?=
 =?us-ascii?Q?cszMWU0gaDRg9q5x/Ott+OMneiqYZpSJyu/YZEe30yszMXCAYvN2EK8+yK7C?=
 =?us-ascii?Q?ldGKBasLX7/GD3uqRLgNT5sY23Xcyz1PiEEwHiaD9EckzROQlF/OP3Nug5kU?=
 =?us-ascii?Q?klgehW/dhXrC8sjkrvna20SQ0TQzSuloone5ztRIu1ZW85ElRmzgfR6WM7k4?=
 =?us-ascii?Q?/f5jKT7hoLVskILfHDUowZC4OL75o3Rf7tURDh8iDUbpEY2VwnegZ4ZKiymk?=
 =?us-ascii?Q?Gyfo4YYGKQrohcxo8xPljI/3G0yt8Pmrou1V07ga041f8zhE1Lhez5DCBdgY?=
 =?us-ascii?Q?/NT10vaRMzDTPvejrSLshi3FFG/+eWHGtCU73lTLcvJ1/ITt/gZGxNPxA/yg?=
 =?us-ascii?Q?fPqNeyUJSPRlWF7OV39QqXzr5UHD2Hosqyv9zwha8yg6lz+OEbGq766M0xLp?=
 =?us-ascii?Q?JXvUSvp0IP9mUpXLzcU+Wmf4FK6rJgEhsLL1/mt8JY9jWEySoMGslHEPJJ/Y?=
 =?us-ascii?Q?wCx3j0Xfe8YvdcwlSxPe6jDO6n4zZ+CG/vOhSqwUUoKn9DLfz7FfBzEPICtn?=
 =?us-ascii?Q?bZT5okWyk3VsCCcT/6rf/vQvk4ZOCiKSVXdNYOGI44wy1fBnimvV9fkq+rpl?=
 =?us-ascii?Q?xZF/+C3fKtUaiFb1XEhLDYatGgGfcRyTbzarCE9LT15FWlGVTgCUmuLk0LvT?=
 =?us-ascii?Q?IMzhNOnabTaMPOe22LnZwDAwhLOgJGhvAhv44x2qYA8mMgbuehnrRBcF3E93?=
 =?us-ascii?Q?Um+Jfzoen3YMQCDaThONubi3KXNHGtuvOdiaHyS/hGKnvKnlUWXge5B2Qc78?=
 =?us-ascii?Q?SCU4CImhcBXY33wapv8g9l2YTOSBVfhU9+chJkrqxOS+uXRVxnxxsvJaicJc?=
 =?us-ascii?Q?hUFdlSlWDMGX1Sd0ZZvfX8oY73NnKvVZzaIlFJOKXENcB1CkQ6wqEIOyXouC?=
 =?us-ascii?Q?zaSH0f5VzljEBuHptLBkffBD1MlaSm+WBDSnXJlf4xy1RiK59f2Bc2qMgNvI?=
 =?us-ascii?Q?gAmZVoiK4Qr3Tk6dF5OkH5kfBK1QB6bi/MRnCyaUAzQ4v2CSAb3ieRreIPBT?=
 =?us-ascii?Q?fWAs8W3QMvEDV4yzAlnJ51muAf0KTH+NNZBMjwjncoDVs4d2vEsbTsBD4Iyp?=
 =?us-ascii?Q?vrtx/sixbiX29JVFrw4QysErDWaY+Y8QDek10dfQ7qrnoxsbm/RRJt/9M+h6?=
 =?us-ascii?Q?JqrbE8LOSUF/oxiDMD5yCAIusbFfIXfexS8C9IEaRIyQaefXxV4E2u2YXLHe?=
 =?us-ascii?Q?8GvbRj547LGpau9QsgCn7wb5KPnKW15lVo8MghVBqyMThw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GyuJi9Imfht5t42p85pwT0BDBI+1HQQJx3lica3zKgqdvVcwMB6WqcnwJ+qL?=
 =?us-ascii?Q?3SvW1V9Q7roVMMO6+QT8OQmuGGBSsWUibKdOEiRfCOszQVsBSuEyauGvbky2?=
 =?us-ascii?Q?jP4mmGAibs73fwcM68jWIX50NU1izUZNbu9ZnR07iR5IDMPWBNZIyigYGhF2?=
 =?us-ascii?Q?TV3U7zBldQLZx4GyTikL6Kd18pvIFxeFrSWugvrHCv4Ots6IzrDCJCvKP4Ut?=
 =?us-ascii?Q?s0XZ0jBSrYur00ke3kGN6PPa5AHBl6jzh4824RQcM1/3rSaQewT0XjcWS4Le?=
 =?us-ascii?Q?6XuDzErxCnu7eIz5brFY1TKXj+S81mGL2qpiZlCKBrVu6B84OsnDaqfu06XG?=
 =?us-ascii?Q?pgygqgfRZSemomQaGz7d5qIJ+ThS7LynIP+IMi/LuetbTord2TKqhr37n70n?=
 =?us-ascii?Q?fZra7pmDYb3cRDEDgM4lS9F6VY8JzLBaA4MaXYXWjyAVRyuCMMFIRZ7k5F2E?=
 =?us-ascii?Q?+xbvp/YoNP5p4twPMVEcWEfuF4cfmbWFm8Jv1nn5WFGNMSKw2REBq/akQ8sX?=
 =?us-ascii?Q?MQ0MU/WX4741OFweMjzul+gTFN7CmNYR0DqGz7XYBFEKWrjHr3F7w5htaWBK?=
 =?us-ascii?Q?TzYpxMOxvUjmJtViMegvzRJAT2EGbV2NNMxUMrgGK2ZORx7lozzBAzl1wORE?=
 =?us-ascii?Q?lMiPUslSb+yiI5MdDAi2I4FtAA30aaFD7Mx9Dkvgo9d/AblEB1xDjppqPt7b?=
 =?us-ascii?Q?WAY9K0cKa11eg52EiKf9kOv4iedBOnsS6VxLzCiJCIc4iX7KRADufLKski2x?=
 =?us-ascii?Q?+lLwTa/H2jw03KfPzzh26bpO/OSwatmV09VPXCLw4cyYscrVLht2zYHbkumL?=
 =?us-ascii?Q?lWQQiJSPoD+EROraPHiqd/3s3jicETIHV2vCq/86oXNrvw/2NMz9v6++v+pu?=
 =?us-ascii?Q?LkUuLKzooeu3qX/eAiL7kmIujcSwvB/1Q0FX3G/gdIVIXUv9nPDqUfzik3rl?=
 =?us-ascii?Q?DcGW33IFpluJgL6vDB5YKik52o5v1vRfUdVRirq+s74e2vRlBbN0/NacEgCa?=
 =?us-ascii?Q?hsU/MQH0qQtZn+AnIJaf4qFGTVcITsvJjk+2EqeeIJcdaq5AStLCg3w7kSWp?=
 =?us-ascii?Q?jeYiF0kv/IRWWIWje8EtZIABuWvLcVG5C2ZQbppMQBLgG3jIwwdRSyPbUj2t?=
 =?us-ascii?Q?LLDQSsSSfAVc3YHk9styUELZXxJHMrJcppJVORR6FQ+MaX0zcbjhpbOEv0B/?=
 =?us-ascii?Q?Wr3c1hZQlYSygQCNORRnJGvl1pTPwuOYDYwYFFPp8SOUD16B5qY6bG7Z1v+G?=
 =?us-ascii?Q?Tye2K0vLUDPydo+RjCjJ2FVenLUU0OWXQV8+yVCCj2FefSfGJRiyO2lihcpY?=
 =?us-ascii?Q?hd8Lup/PyCY1uS/o6MT6yWAgv/VazBwgwQht0Q2U04CX9yTuJczvv7UXlAZU?=
 =?us-ascii?Q?RVf6S6sFB6VA57iVPDn1fWlshmlnmTKWwXAHZ5hIguFm5gFeIPn9ddmGhgRR?=
 =?us-ascii?Q?/rK84yagJsUtROeZYWCadhZc3XjsxxIWXJD6EEBxRpfmDtbvWfWnn4lXWuHE?=
 =?us-ascii?Q?DEPDlCG1GD+bFIdh3ATRQ1zy6o9DhBaz0VxI+jn5uTtGBrjc+w2WvnFtCZOT?=
 =?us-ascii?Q?RVy52aLTXxGzKrv/QwzwEpMt2AcvG6s2GR0vWfLIx4q09zf83rhmN1LLMf2S?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B1J8lKFABXCZqN04fHiFZ8A+bkugxUR8egRRe8bvCok/hlMnEy0y2X74kyJxgail86iI0nATtiE624rbK8TyrrDXDC+fZ/5djgs/vED6rNUuh0qQPiNEylWE14lkpIK29xEfaPl7hBOVRvUohlYr0aeWSP7YnTI5CgErnCM5ex0lN1NmxG7dxKWNIGsyOqQxBkOOnAijX/VyY2I6Y/eAoMxOzBKFflgSSGRA/EkY3m8+a8nvM0BjAGcfMx8gQTfw5uTwoGmWsHKQiIm1+sg++/y9Arqq6mAchS3mKrfFd32Yp7HA2NMlII2iUHab8xQ4mh2K7Mw+2FUAAlP3fDjLa48Gdnp3fduCXVKfv/LvTbTJeT+WOutmpmhrBLUDmys2ultTkceoiq3CHTuizkDHxqOLG+dR3yYD0wU9cWzeL3XD7Jv499yLPvd31pE90GkXcwAvcsfX3tJRnBOT962XS0/CbDGnzLQ4KqIa+NGJvYqgmzU2yyozUZUY6r8e87NXrwCVvRy7rP7bqiGQdCgSqq3ddtLaEECuZHjwI/KZDqTl6vQykpuqkkDgpBOesglGOeNS43Hyc5DBaJ+wWWn1E3do5piNM6Ch/gdSAP0u30A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48265acd-1947-4469-f3a7-08dd18b9d986
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 01:27:45.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBKyO0AwDHzQHDD1YS0UOpAtXEfuAxhFagCZcCGkyE0SNszkhbiECWIiljfzIehC0SsUuJ8HXJWielUZTxt4z9ka149xIEix+2gBjwXn4I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412100008
X-Proofpoint-ORIG-GUID: X0w1ox95tKIM2oQXiuB1t3u7kqk1E6Dj
X-Proofpoint-GUID: X0w1ox95tKIM2oQXiuB1t3u7kqk1E6Dj


Damien,

> These patches address potential issues with zone write plugging.
> The first 2 patches fix handling of REQ_NOWAIT BIOs as these can be
> "failed" after going through the zone write plugging and changing the
> target zone plug zone write pointer offset.
>
> Patch 3 is a bigger fix and address a potential deadlock issue due to
> the zone write plugging internally issuing zone report operations to
> recover from write errors. This zone report operation is removed by this
> patch and replaced with an automatic recovery when the BIO issuer
> execute a zone report. This change in behavior results in a problem with
> REQ_OP_WRITE_ZEROES handling and failures in the dm-zoned device mapper.
> That is fixed in patch 4.

Complicated set of fixes but they all look good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
