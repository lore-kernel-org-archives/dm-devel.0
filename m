Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940B427F002
	for <dm-devel@lists.linux.dev>; Wed, 18 Jun 2025 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235897; cv=fail; b=lJxi15ml/J6mItXsnIBEzPGf2/U3TAs+2M89BpZHJ7ZD+3BPLuQMb1nFknkc3HTPtjS8LX71+p2WgosLTQO9REgxZjfi42dbpg1dZL2ROrdE71l1aXZyuAnMNHR21Rd2haipoQSuibz7k3unAGZ8asEy0MmsT16WyKb1ygfM62w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235897; c=relaxed/simple;
	bh=zKHjtM60CcF57G2RTJPLU2yHQumWQ4OtY2n1SDnQSCo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qMGNKlWbB3mVIlmirgUANvyk2uF4Yx4P5XwdxPwtGJhyrmgevrQe+otF4S0GOzb4qgspFl+TVJACGDhjdMJ+upvY9U9NdgVSLNO8yuUOboLn2V3azHtBjKEvzTisxdR66nOm7yZvfOZQDvQ/8a4XaHzH/POjO5GLpPRt19PlpSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W71mS7vj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eVRaOUVd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W71mS7vj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eVRaOUVd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7HJax025787;
	Wed, 18 Jun 2025 08:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C9SjZ/y+rt7N4q4XzgJjYTKyLcTgLg4nDXpBqvvhM9I=; b=
	W71mS7vjTZZnWqTdAAodxGHDGCZgPF2OP8RTq8jmcm8rxRJdJbas9WpG/7Af75VH
	7HKEItUSJvPGNbqNw7Myu6qDGHa7Dz4JKpusp94JsQMF7WC81SBE8cqsqzC50n6h
	zZj1CPixKmNjItVzkmyl/n+0NAEEAmm9nI3g38Mpsy1K9EsvOneR8yJLlPMR2b6r
	WIfBOyG22FTwr09grlKhur0I483i3JDjCGucaL0WbrSjcEApF1sJcm0uzLtQoI+s
	tEA3BiYXNpg1LGkxAbNBXAZENBQjF/xCUW9blFWlPomZvBw7amkLjTAoRMuCeyr+
	ruj1fLGQuupIh6sMBXU0qg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4qbgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7kfUd036268;
	Wed, 18 Jun 2025 08:38:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhgv7re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZLeitc5MQ/r0fZgr7gHfEnYYZHPmf7+Zna/IQTmFcBdzsVVxoFJhPKwWWR+dJu/LeFTxdGxZRIORIV0VtkyLtu9+7tAGLllObVm97Jb8slgbOFzZ4X+5dhaEcPz2PKsAhpFXk/EyBfmGvbmMTmkurmybNUZTobN6BXTi/VQf/7TXVD1fPTF22+FG2c6PRDZ2U18pphk7tP+BqYxxJdo4dCvsZDkGigSGwrsENONdqqcq749EdORCFf0RLEzaFkqX5br5mX9owBgFhQI/LCLSVy8cXBOF+Wa83qMOenSC07+1iiGh2OoH/vQ1yRX/A4/JT9VVuFgNUGyTTJzzucydGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9SjZ/y+rt7N4q4XzgJjYTKyLcTgLg4nDXpBqvvhM9I=;
 b=KZxJkJfSCNNU4CE9LhyqASn5spZryShOiOgB/q1VLKLc5QWQrKhaW+CaSUAkUyEqMpWEhWB+98C6PiHlYKXTQtR8ZM2Xvp1Aoz8Nxw0NPV/7RjAjCPR66Zg1YmxbTMu8VpbU6jO32ddHjQ9ZkJsekZjdvuxG8g8RZXJ/fN03c2aHKbSAnZDn89+6I0A8jsz8FTbgPf8fRG+m1WvKpBV6Omy9jj0HH0j+8R2v57A8mkY7nJYrXwspbFxxdlHe2DZWzuN56q39htY0h1ACoI7Gfxr4iikkwp0y0mHCljYlndlGgh94Co1HNS3R/kI0ovZt0VWrj+RH3IAulXCVqKshDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9SjZ/y+rt7N4q4XzgJjYTKyLcTgLg4nDXpBqvvhM9I=;
 b=eVRaOUVdSJyzdOA4LGdzkGWvRz1Mc200V6bTMV7cc0kgx9PPQzrutbT+x4dpdEzkjRw4pLw8U8HsoMmX9W8ZhNbPZ69HFgcIhdQGLTkqfqTjizNagienp67eDbXxRUgJqR4Uk0FJpHSdF7gW/B6+dwlje3Wu8L4Ue2mSBpouVGw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:38:04 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:38:04 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 4/5] dm-stripe: limit chunk_sectors to the stripe size
Date: Wed, 18 Jun 2025 08:37:36 +0000
Message-Id: <20250618083737.4084373-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a9be6e3-30dd-45a4-e692-08ddae437110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6etZrRXFaDLDqrHON/4viL4707zZ2FHPEFi8UN8OuVclqWXhBGTkbh3Ed17v?=
 =?us-ascii?Q?iyVPK9Vmb3hbTcxM6Vux9bOHH8RQSb8uRsTFJs2XnNyTjhUCjikQ00qxAjon?=
 =?us-ascii?Q?MEYBmKn9sBwTf2Z4cAvl/cuy/atI2YStqLUGcKGTP/ByQutxPn/wHbcGjAgR?=
 =?us-ascii?Q?UTtIxbNR7dfM399a+uvWI6AIA1fybJ3c+ipjMOBZ5osA0WEHxOPyv8nNFiwU?=
 =?us-ascii?Q?FA3EHn8iZKhv5RnF8OpQ1SxAw5yxpZvDagiQOZIzSRGK1vRMaIkGTfCWnEL3?=
 =?us-ascii?Q?Wo5fhIW9xhQtqCcnKvCcWj3yDoiKVh8E+HAhe54K78rQuOQ9/DN0wHmXTEVE?=
 =?us-ascii?Q?DUJLWYCw3yLohmQXUrt2QvS5gb3+z1Ga86qTfMFR0PPg9KezYcXNEneQI8yQ?=
 =?us-ascii?Q?kui172RBVRhj+03GC7VUmKRCTYCdVIInyb+YHKcE5au/AbeuCfAzlhFn2gEJ?=
 =?us-ascii?Q?nIs8f3QW2YkvlhpOFIoUqFutH5VUAPDOFiak97wBqQBGjS5ZYJ/mR7GdQwuU?=
 =?us-ascii?Q?t1vGgP0iMJLjyXaPHifsKMyUBH2+v/0iJHmI5rjAJsZlfpc/6erf50CdZtOY?=
 =?us-ascii?Q?GjYU0w3L8ehmp6oFgNbzFVxuNFDoepCRK41oWZX5T7Ocinc0BvuNP7qm7V3i?=
 =?us-ascii?Q?FRDF7rP5kGz7I3w7cDd3USkYtQ51wqQshA6k3eEvy8rR/FKO/Nf0LXcU0agM?=
 =?us-ascii?Q?DdgBJcuU+ZED/myc19WKFSSxp/Nb6DeA9FhwvexE3lyGJGUkc01ehmsgzKOc?=
 =?us-ascii?Q?y0LSUGtk/O1Lh4QlA6LyfgWV3U+7U62eDR3BzPuLKLLGv82aSdk3spgHyiV+?=
 =?us-ascii?Q?fXiJ0t2hVy6pL1EavKAWvy/tije2LK4RnRQjNAZxiE+KJwO0gZ9VjOf6iDbe?=
 =?us-ascii?Q?NxaLUvrQG0pwi4C+zywOkANGrytoWU6K4qbR3995Y5DtRwAh4vF8jvAJUCFH?=
 =?us-ascii?Q?+g2F1mlEKHYPWfaWoqXSXw/OcFEEr8YKOYVAWgBJ5VodNgSKzEOvFf+Lz5CD?=
 =?us-ascii?Q?WQdQXVfU/Ej1to37qaJGMtCbrZyxrMrOIZKhMqXmKUBlAy2C6x/RPcJOflJs?=
 =?us-ascii?Q?EdurNaniJySAfXxmAIRsbvgYBVuPyHznwLWHv6FerO/BQDYdOrWcjO0St0CG?=
 =?us-ascii?Q?FpPTiO4tjIPMgho3x9pv9boGlq1hcYJxxDNcx0EaM0XACyutEHUgrHOeNmqs?=
 =?us-ascii?Q?8Rb5Kr8f6iK1i38yNDRDb5FpTVazWYHRop2S43tAwzZSnCha9sQwwKN/ANpP?=
 =?us-ascii?Q?mVPp7/YHVPndVhfjsEwh5dDR4sAWNP9W2NJIilfvmXUQ5GC7lqoXfdJiebzu?=
 =?us-ascii?Q?HDFYWR80iD2LXzjM3f78x8wcn5hauTcqVJ1Iz8WlNr1hQmQ5kt8DI/aqy2k4?=
 =?us-ascii?Q?OyNeh14v622YSQfBO7YkSKoq2xPBZSi3xr23X0XnMDUy1N2D3TYuZX4KIYPD?=
 =?us-ascii?Q?kszQsCXOp7Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G+/k7DqTf49yirvTZw2OQgKz6dx4V9ba/nZfNWRYhVW3qAqSVan0GyRYPqV/?=
 =?us-ascii?Q?jQ9DRVvlDxZ6JQA3rntH/AgQaLW/XoYcU73vEoPF7g0nApvXKHgg8bej4gM+?=
 =?us-ascii?Q?6C3IhI6NNuX/2jsIbtukKSMmi6Z+I3XVDZIgugLDdW/dmuoSCip0zCEALU4D?=
 =?us-ascii?Q?aFFyCGCI5BSLsoNRPOFvfdOy4gqxdIsdtOzHK2jUwKjGZNt+xqGx5OUgwO+b?=
 =?us-ascii?Q?IAEdD+U6uJ0Y83zx/lQ6zpN5kA3EgQJpjU/OjCFlBtZ51OFBJA0N48iwnbMJ?=
 =?us-ascii?Q?hF8kT7qnj/9dMtJNhXbjyfBMmDelgQTTlXchRQJg2JT5+COa6ut/hnMlRidO?=
 =?us-ascii?Q?YgokRtzzzbeYwV5Eg00HvumPvDn3bzRGRr0hb2oBcdB26pcOKQHU6L7L/O7m?=
 =?us-ascii?Q?39knUruW0cNSSlr0gcYqssWmC4kfLdYWVnMFqPe/zf07ssXpSvsksm8Xdu4D?=
 =?us-ascii?Q?B4WEGR75JMDnJHAVerBrgwF7IfI5/BCy2CKDVayAfSRsjxPfm0+Ih3kyMomx?=
 =?us-ascii?Q?Emb3aEKacZ7ACCb7VH2Rk3oICGQSO0CVn++UojiCVcE/nMT23ZrhRqnStC2D?=
 =?us-ascii?Q?yBNnGrcYAFTeR7eZcdq3iXnBK1ulXpNgGt9VpxIupHwsOar0qg68AsmzftTW?=
 =?us-ascii?Q?0lG9Sv6P7iRS5ggUJUlH8uP2Hv4Lgv9Bs13t8hP/tQ8TJuMnOhJK7rVI/57W?=
 =?us-ascii?Q?Fcqq0HRZeSm8sMoi8lhQF6r350qP64c3KXIN0qIQevol4uJBawwOHI4cjz5P?=
 =?us-ascii?Q?tdH1phviHEtRblNNIJFHa7LH9Ku8J1Ob1e8Rj4t8M20vPA1+PlRpkiZukJhI?=
 =?us-ascii?Q?KuLV+ssSyk6QHC5lBaM+rC+Sutyj9A2aOLB5Qyx5eZJcj6CP984iqpg1Psz+?=
 =?us-ascii?Q?OUGdr1xBvYdKgI9eJr6qONih3xY7OxyB3mmytMwyxUA5h7Kf4aZODXF6BRY6?=
 =?us-ascii?Q?BAP7AJv0njCg4w34VBOl0Vb5l78BZj254nmdDDwHtSOmAWJDjBtViTvz9+zu?=
 =?us-ascii?Q?wtXDI/h0eTG0H8m1mnRyVqXVqeW8lA9E5588UxncFkNtqVjihdfT6JS6AHK0?=
 =?us-ascii?Q?YW8V5UgOC12w20HFzuXA8HevQbbsbzI+XIKn3xmyQjkiE5sHcD/kIaOmdNyM?=
 =?us-ascii?Q?qwg8NVKbywPbJmzXg5SIoY3uny8RBJ4BmBd1ND1M3nwb5dTcn3qovNXGjf1f?=
 =?us-ascii?Q?rApLWOPwqUacT+s/7kFwn+bd4R3OULkzn+buIQvv7bzrB0Z5KccCEmN+GXZB?=
 =?us-ascii?Q?/qdI431MqKPr1PShtBfIZPSEljKKzRxyIJFBcCQUvJZhhWdW/ysYgIrgp9G/?=
 =?us-ascii?Q?MPNrNfnL7KnAWaWFfVLJdF5k2HsFIT/z0CTUw10yA7v353dVj7AbuLd6r6Yu?=
 =?us-ascii?Q?NwWE2vLC6Gk7Fo4/U2zNfYDXgF0DRLbp27WNqkZfdJDyejx6EMYfRsP5BThZ?=
 =?us-ascii?Q?V12cJak0LJKUZguGuFUh+qz56GX4Bi+JiiZlhB6nnP67YsIWcKNk5D+89ZEE?=
 =?us-ascii?Q?ddt0l8m7Z2AiRwJ2wJBYoJPvXA5/U7WxAj3pwaEMIAiXsa9J6Ts2kGg1PVPn?=
 =?us-ascii?Q?JtQVfZvAbg6F7tNdecimrSd33yiqpc2cf/etpWTOLff7p/zfedl0l2JkURYi?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7MWB+l9s0UT62JwzdxujNCyzJlTqj/5FjfT00IQ+FahJg2WLKc4B/wsJTeAkgh7WXVllkiXtXwei8ipiqXmu2vWjqRLjGOV2P3dQ4EUcBZKZ+1QXlahcTJSRGWl348XmZz+p9pwIU6qQUpVAeF7SdJUGwcnODh89YicUWLw88y7ZUzhb3FvaURaUZ9+Y4WFvAt1UAXZoqUywucVtEyGSri47Pjrixa/VlRV4eu561NH3D+emTdRLr3V8nc5lHdIue1oDGJ51x2jh/FIglNKObMQ1M/SGLvWqXxjVP9qh4G3L+9xuyQBpNFPabDwCXxy4gD+RjL4foJb9z7X5i0ftt2oKDG7XLFkpq9kBr6EK4WUpD/9I/OH2CzQAfSyntpx4ZccLIHTsdEvtW08UuwZ6j4l1tFLtFqST+8f7YdAlmGSdOyjp6sBc/RVAPAxURNiB4BXD4CqVa0NN4YhE1j1rdjEc8YBABO64dv1nTOnhmqDbSDQG+VY7JyBWgsLi2PGYEDIrn/uG9P7u7CYwK96DxoYUI+q0F+Xv+CZUrZNog0tjAYzeir6WH4EKeCyE636d2ViTIEkN1lvunlUeMm+M1s77yY85sSciNPCHVdz23Io=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9be6e3-30dd-45a4-e692-08ddae437110
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:38:04.1971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0Q+JRNKtdw4aRZ+JM09n+PcD/vPkBrfvwwGIlNBHdAV8ESPnWzFFwoEO8YExnQJrC+luYv0lsvvD3E0onevYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA3MyBTYWx0ZWRfX7UHV0gdvjzxb qfa8yByVAT1HtDu4f3+iD3vSrl/wsd91ydRku+xEDQQEMLoK2wY+D5Xib/g15l3EySxl3XiZP0d e6dcE30+DDHBqeiyVS0wcn7v3/+GevWB3jM6IBibi0e0YuSi2XnArh0r27uqPwrLXDKLF+h7ENy
 PN4btR4Kt/aYCaZmeDIHQNb6W83aSPd7kIRuhGDMt815nu29nNUX2cCH+x8eEPOU4SS+OtAMeXI Cxgvo6eYtwp9PZ1IL8OTLI1r8Q4LxmRFgKwS49MhypDUoyBFGEHvWgotu/el9y4DLH1WLeQeP3X f8Tn7SbcaGKxcFrfPLgrhn3pYI2+LuFeE3/39rJHwa83fTPYhgXI2DReOuF5V3aSB4OFGhxX/77
 OW8p6QIjjyJtY1lxLgODm7ChpNPnSwyE1RF3wUXRuTwMNQnBrxtr2R1jCpXFo0YzozDCmYzB
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68527af0 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=iUzAXkwMV_H6fWZUM-AA:9 cc=ntf awl=host:14714
X-Proofpoint-GUID: UVUXdYKqzqiF9nRGT1z_-BehSNCcvB19
X-Proofpoint-ORIG-GUID: UVUXdYKqzqiF9nRGT1z_-BehSNCcvB19

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5..5bbbdf8fc1bd 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.31.1

