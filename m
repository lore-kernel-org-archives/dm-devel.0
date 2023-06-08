Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C164C77B7A
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 02:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686190073;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xvQdl2cz0hHlJiRTak6sznir41GELmMqPXKANSmi4gI=;
	b=dn8loobUudbhR817WPlnu8Xa6sgZVUEvA1yucrnE1QAtWiM7PoUz11rt1QWSzTzzhlQjYO
	ezIoulH2iFGiDnYlEgIoZj0KRnkX3nMpSumjdgrPK3za7kHUiGoNeoKUbFYW0R5RDD7N2S
	P295zdfUSEAZUxwKFKgRD6ECYOlSDGo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-Oi1xBeAxPZOXtizyunVQhg-1; Wed, 07 Jun 2023 22:07:49 -0400
X-MC-Unique: Oi1xBeAxPZOXtizyunVQhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61FDC29AA2CE;
	Thu,  8 Jun 2023 02:07:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DBE31121319;
	Thu,  8 Jun 2023 02:07:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD53D19452C4;
	Thu,  8 Jun 2023 02:07:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 570EC19465BA
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 02:07:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18FFA40CFD46; Thu,  8 Jun 2023 02:07:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FB9340CFD47
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 02:07:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0D7B185A792
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 02:07:43 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-9b_VOXUcMr-jE7rywlT_7w-1; Wed, 07 Jun 2023 22:07:42 -0400
X-MC-Unique: 9b_VOXUcMr-jE7rywlT_7w-1
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 357N5eOs017147; Thu, 8 Jun 2023 01:19:05 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6pk5xv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 08 Jun 2023 01:19:05 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 357N3h8o015848; Thu, 8 Jun 2023 01:19:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3r2a6mft83-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 08 Jun 2023 01:19:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 01:18:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 01:18:56 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qim4uqa.fsf@ca-mkp.ca.oracle.com>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-22-hch@lst.de>
Date: Wed, 07 Jun 2023 21:18:46 -0400
In-Reply-To: <20230606073950.225178-22-hch@lst.de> (Christoph Hellwig's
 message of "Tue, 6 Jun 2023 09:39:40 +0200")
X-ClientProxiedBy: LO4P123CA0282.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bc9e3d-07b5-4fa0-8e96-08db67be54bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: r5vJ01UBQvoxkQ3cbKqr9+CqKErDMy8fLZjoxasZ+e33E82E7qLoASeZP3Jf7u99djD4gpte2J+e7FXIkZKktVGnQLsNC+tl8R8ARGrpGgB/L9azG0uDeoaISsXRy2/BYQngOvWD+TTIV++LxTDYFLytKmF7ywz3D1VRn+2gLl640xb5oCWIGqtR0jkqJjd+HtbvHiAiiaZ3nAaOnWR+GNcR7PNJOgRkxPisNJm/+mj49b1vwaivotEdYXEUzEMcHRCVgOaCT83qPOx9sBpcAkv8Ml7t8GJf5uWP+dbS573KQKC7pA9U4BAv+3injpcglT554WP3CNoiMDO4SHidU8lEBiD7fN4AJkmgE2IlkgaF8evA2s0+GaAHnZhriW2YbZLVdylZ0N7oAl0skfhJrzaC+7XxZIsFi6wVi3Pm7sC6R4Ydnh/jPsunvBp6cs0nebTY9bRGqtekZBOXyn+NIt0x38jQc28b3JnAphQ+xctYZxj8MQL7hbLCHE8jgvmqnJSfjcBm8ZKEiJ8lf1brJuBavX0Z4ih9ZZriE5eRADd4mLHAQwqeW2DIkddfhhir
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(41300700001)(8676002)(4326008)(66556008)(6916009)(66476007)(8936002)(66946007)(5660300002)(7416002)(316002)(54906003)(2906002)(478600001)(38100700002)(6512007)(186003)(6506007)(86362001)(26005)(36916002)(6486002)(6666004)(558084003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nnm2eAnNJVbXNkQcbF+FqLQAZvlsE50K7S0Zk11DwRWR2TGEndm760fwjGXf?=
 =?us-ascii?Q?mgqjH//BlqVTuWwXJoSeRSDkbZUp+gAK8k6wegOyeCUQufMH8opd+qIfrr9X?=
 =?us-ascii?Q?Lih/2aSRF3sifvjq2tmet5UccHciZbCu3b+b4xlblN3nYkpkm9fE09k9HhUx?=
 =?us-ascii?Q?2ecU7S1aAwV1XNGBB0goesbwodZslJ2piII+4AzqtuLkcIdpH/043a2PMR/G?=
 =?us-ascii?Q?4eki4b8dI0FZK/kRi3PH/mQMbsc6W/kR1vdjA6+1bo9EHiMITZTtl+vTLzzr?=
 =?us-ascii?Q?lry/8nzLJJAmX67UXll4ujT2p/Y2ysujubnrONe1i/dUv3bDnSb5W7bsde5O?=
 =?us-ascii?Q?vbERzuJoBVrI9boHG6gLayvnrGUyg+U111wZ/GUjOUYpBKjx+Il8ESd825nx?=
 =?us-ascii?Q?xJZczr8jCIpXMUQCD18alfwhAZ6ABg0zwaKwpcWphICm5fKi2jyOGBCJYQsr?=
 =?us-ascii?Q?2l8ComK2t9QAj0EFB+bNxXhvYqWjvlCn3vkCjgfY5CS8BUA9Dn6EDiVIT969?=
 =?us-ascii?Q?wO8CgYDdNJg4E9B+FcSryViQa+ZOB9j/XJo0BEtjGm8A0fCtswJPT3ogztgh?=
 =?us-ascii?Q?WeJCbyofe9yFDsSnjrGO+qHwxAcmJ7PUW4mNPdckQRAx2pYpFB+kjbWXkLHA?=
 =?us-ascii?Q?O+oD5gGhSWfMfJwXTeJADSwFCjF5ZCDcvSOS9hzhMiYY6quwINaMjKM+9qNq?=
 =?us-ascii?Q?m1blA4QMEiJ/Uijv2pJzQaJCJTJuyMxRueCSyw83g05ztykWEZ1YjY2PKbiO?=
 =?us-ascii?Q?kBXIwZcBo23mdKJsBD1K3gdb1BklWlT0Tgf2390kMknB2WEtGczCXDbhynXT?=
 =?us-ascii?Q?9DZrosDP81ginhQS+KLEfyJeeIB5az04IeGvccHRy1ewH02WFrjwq4s9QSLH?=
 =?us-ascii?Q?CsNS5T1cfCrw71fGBQrWGiOtVucEGHDGuKeRSQP6ybqXt1GBzwJrFuHTTWop?=
 =?us-ascii?Q?3HhNzXAPYo8UMbhNBDEnfybZ7t5ZSq7mZyS6qHTb+UMGc5QQSOKETXsyzEck?=
 =?us-ascii?Q?ToOtrsMLP8tFtUJfNDGnAbZ5q/uKXCJ8a3vbVgqh6p+Pe1pQz2TXsiwlUoTn?=
 =?us-ascii?Q?qIdcD0lLieF7/NyYSM8EhTMUmqNdPh1MnxXIjxof9y18zyH7sDViv+9qDtV7?=
 =?us-ascii?Q?zvKLbBmj5QlhGpyGSwY9bFpk8tIuMOZLtHKlRgyNd5IJIjxYZH/KGJusUsiX?=
 =?us-ascii?Q?n1IpcRm/tOyG5mROnbsC2JM/xF/WgKPxzjNwtFpR0e0YXx+aWTwjTt3C10Fj?=
 =?us-ascii?Q?Lwbb3cjyfImCJxQWkhCQKqwuT4fVmD4td8Uv5xx8zxsVtn60nV1zA2BG3jER?=
 =?us-ascii?Q?A4z03xSCmXmn4ol8eYQKSjXIyYNbDdhWVlYXsBT0C2TQ3wYbu49gd2SvuxHT?=
 =?us-ascii?Q?0uUTHArkJU5BR58IiWsmzQv4sXfPSB2bdXzN4ZNc7NJY6CcDIQIRGgk1QZVK?=
 =?us-ascii?Q?9AyZNtmlAWMkCnFhnfhLlz72zlnLQMQvb+jFXhq22V8csQOHYnmoEHNp9F7j?=
 =?us-ascii?Q?Zga6INXgc3rVQIq0F9ePihn1i2BAdMCxV1AGcihSPP5MdyCOpUt4Ma0EWQmI?=
 =?us-ascii?Q?WPvAbKB6e4VfMH0HXlCUe7pH3NGbWUG1TDQ+qvm5VhagszHfNtQQKhQc6TNR?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?NKrg+HjsIahvdj1/VHD2P/Y1o44gp/wcfcVQDWTS5/L3G0nX214S3yPMRosj?=
 =?us-ascii?Q?FNOcNuo7akB0MumP0kIQjkQNf37VfKCKFBICDq79OiVSv8WcSWhpS/O4btOI?=
 =?us-ascii?Q?FupNkQsnSon+HcaxGP83KAbwRi8Dc1ULBcvPAllCoO8bh8jiRXdY/NA8G9uR?=
 =?us-ascii?Q?524jsB/xErwEwD9FWWPYXYgektWx3KxO5IbMmDsjtuqNEzQJPD0A+rky67wW?=
 =?us-ascii?Q?nMY3aunLhP5wZA8zkFjb8zN5WGfX7QABdeZAFIpv15EWO63TzQihUOyH/Pf4?=
 =?us-ascii?Q?f+buN5jXbIzS3BgTAaur4uvJWQERpRcGUVNymc6iE1o0A6ZGsbb3EESJWgzS?=
 =?us-ascii?Q?hsk0EBtAWm0uV065iL5/GcWh6zFybhcj8VnfzYs8Bt4VC3+miwLiY+IYR3VL?=
 =?us-ascii?Q?HgiulBQzE8+75Cbqt9QEINzmuCBAzJ7jJcB3LPqla/ZB4AvMQ92x1rwxHxMv?=
 =?us-ascii?Q?cPnfYO0rYcj79sQABc6P1RO/Gb+pVpie7Ulh/7xrGyKGqFwX6OjvJ5S+Yi3k?=
 =?us-ascii?Q?2hyIad+3RaseX6wKWix+Vevn5t3PFz2hySBkzR8o9P4MKiJp53E/OSg1g4L5?=
 =?us-ascii?Q?S9Xu4NI5CLLvPaTP/lDvRgtnf832XYFjFykzMpyhNlKYRI8SqNI3YXZPoLvN?=
 =?us-ascii?Q?1acqggN0vizaCHMO/tlK0+P5DwHBMkz3/fZe/63J/Oag/YOrBK+zc6aC/Izb?=
 =?us-ascii?Q?qnZIpxKJhzk8hBGAeDj/tj+Iipt7+ytj60ZJQrTTtsgrQPeyE2/4CdQbcevF?=
 =?us-ascii?Q?sYL7rGJSjiiMOMjftS8FmfduWLuBR44lr4k+kSMQGiBQ01yxeOSLn2EXJP+6?=
 =?us-ascii?Q?TGSuT0Eet5Dca0f3T0IEmEEMeA0MVEuTGi6YNXK7LMdE8npSnOS0olIXjby7?=
 =?us-ascii?Q?oX8+9Ky0QAKRlhAZRmmdxyh3vn+UZkkSEQYjZe3cFVbVtEy3V/TR3pqp1fcS?=
 =?us-ascii?Q?/fhNtmdhdhEubvvyLqoeAwSBqWjE2K5JoiMfPB7Q+2PHREAk8uPCjGEu5nHx?=
 =?us-ascii?Q?pAsBSgSUbHuqrS+nCwoSz9tsSA4Mq3BUhm1gBNuKtQxEPDcOPEzdjTVi4i5m?=
 =?us-ascii?Q?rURL+813/mLF8B1Rw6CdlYWCrjRjjkrBpmwGnMMvnYF8V5Co5egNPxpyB5i9?=
 =?us-ascii?Q?DRS0lf+ksiVT1VI6wQhHL+0pH3Mq31e8fPUSOyoyX+7ow/FyHHk+n/t0ThWk?=
 =?us-ascii?Q?hRM0RllOrQJ/tgfHsXyieBGpdtzKLJTu8vVscdeftYECyIh+fiB6F2zA4vnM?=
 =?us-ascii?Q?zGOcFFcKmyX8r14QXXdyO+M8tABVBceuscT2cMwN7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bc9e3d-07b5-4fa0-8e96-08db67be54bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 01:18:56.7300 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKKm+PJQPDKt8ZCDErCqtwLzWg8O+0JRmYIsPLC6p0p9Yp/DaUHOEl9QrwIDOW5cryc/jXuVQhYFzg80X2hHGg/zna3PepxWh4zFEjUwOJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=586 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080008
X-Proofpoint-ORIG-GUID: TaScGZo-CrxEG8au8lYxCKW2rvQdrWKX
X-Proofpoint-GUID: TaScGZo-CrxEG8au8lYxCKW2rvQdrWKX
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 21/31] scsi: replace the fmode_t argument to
 ->sg_io_fn with a simple bool
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

