Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7ACFA374A
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kHaDdl1jta4jD1vjZLPfgGu9gbZzFLybYYB9CIXpUdk=;
	b=MyV+YEHvJRbWfKiKBWs65Z+drGunrjgRA8VHkilro8lDr/fVCLlNIRJZkV0RbbTj+j0Jz/
	Alb//2zG6et9d3kU4/i1UUwS8ew9UYESFoex9k7mZgJfPMFBAEkIqzqfjY/GGUuIYMPIFN
	7FaBu3p5/NujbGy3f3YNRQHWT9W5UeU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-GK1xHD5GM0CeoP9Byu9XBQ-1; Mon, 31 Oct 2022 02:38:49 -0400
X-MC-Unique: GK1xHD5GM0CeoP9Byu9XBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 197B4101E158;
	Mon, 31 Oct 2022 06:38:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00E8863A54;
	Mon, 31 Oct 2022 06:38:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EFEB01946A43;
	Mon, 31 Oct 2022 06:38:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D5B001946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 20:47:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C1B62166B2F; Sun, 30 Oct 2022 20:47:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 83DA72166B29
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 20:47:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ECA01C07593
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 20:47:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-tkezJE4ZPgefxZW2bsovzg-1; Sun, 30 Oct 2022 16:47:34 -0400
X-MC-Unique: tkezJE4ZPgefxZW2bsovzg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29U8ETV0012622;
 Sun, 30 Oct 2022 20:47:12 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts11yum-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 30 Oct 2022 20:47:12 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29UCnQD8023892; Sun, 30 Oct 2022 20:47:11 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtm2kg2w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 30 Oct 2022 20:47:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5046.namprd10.prod.outlook.com (2603:10b6:408:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Sun, 30 Oct
 2022 20:47:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 20:47:08 +0000
Message-ID: <a842f741-79cc-3236-c5d0-e9a4633cd3fc@oracle.com>
Date: Sun, 30 Oct 2022 15:47:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Christoph Hellwig <hch@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-10-michael.christie@oracle.com>
 <20221030081708.GA4774@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221030081708.GA4774@lst.de>
X-ClientProxiedBy: CH2PR14CA0058.namprd14.prod.outlook.com
 (2603:10b6:610:56::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5046:EE_
X-MS-Office365-Filtering-Correlation-Id: e9dbf366-7de5-471c-8a0f-08dabab7e905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: OA8DFzxccpkn1Up1gQA1WHnJMq4e/0KPqGx8YxbmBZFvqCKLUq8AuKp6s5vX5rDGjUsooPnXyhgJjOMulepfjPTzIIzRHUC6FXOXpXcJeEUoDPyjrOrbVSwg3FSwu47ya0iMUklK16cGxI81lOkMG1W4X1OhDUXQt1TS5slDyFi0kfkQcEyGstPxQxWDWTO3bkgg1ss8WqfPHATWXZN+7YBGWVwdLsKsHPgMg1chxcw6f9aObW+2iHG1foh1EbIUbTTA1rJCbLhaM9YMtBVA8i/gwC9twYUbYAuPbYjjpcVwoMIGcl5YURrIIqb8BSDBRAOMHKs2RDzLDjLEBw/I96iQqbI2wJegxHK1PEKEpOukkBSDyEzSh0d7F1vb/nW7Vk/yVdYRfA/sTUXYvsLQ9jJk1P5BPYm1sv0j6O1TYP3gZmVGjSsv7td8W1KZ91UaU8h5aF4Woj/T5dKCol9bqZRxP4ZQYXlQtD8GmL6IbTD+Kr8dE7j9KGseBfEkFYCWKRBWgSrOEoTLb7eIOhNCWQ3bO6fNv1IvxtOTcg5SnWX4+w6cg+YPor9F0pcV/ytMUwU8dK9rUtKM6+NT1r4/R7bjv26g7u1IQgALwx2/QncbjPnaNrgNeL1YpyRuJD0aF8yvoHeY00dsTx9/TduWJ5A6OOxz3gwPh43FUmBmfVMS3ATTVcC1oTBGc97qsEjaIoNR+Lnzv8eVPB5dH0qtQBV6VrDk1GeFkuYi9PAlWvSMoECtEjHjCsqjIitcAavSy+Q+FmtR1lLG39dN+2ECE9MKuierD/nqFk2d2659uH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199015)(26005)(53546011)(36756003)(6506007)(186003)(6512007)(2616005)(2906002)(478600001)(6486002)(38100700002)(86362001)(31696002)(83380400001)(316002)(31686004)(8936002)(66946007)(66476007)(66556008)(8676002)(6916009)(4326008)(41300700001)(7416002)(5660300002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1Vc1RYcG05RXpqSXF1azdGc1VOS2M1QmZpTFRkRFdRNld5ZUx5eFpVSzBH?=
 =?utf-8?B?MHRmdG5XWkNYaTRtRk5RSE5sNS8wVzBRSm1WQ1ZwR25xQ01IZ0k4VW8wUUhP?=
 =?utf-8?B?VGF0dDJZZ0xta2lRa1FxbjB2dlJya3dJeEtTbVlmUHdCaFN4OGNrNmE0Q1Mv?=
 =?utf-8?B?K2Y4TERuYnFWc2xKUXYxTHBBb2NmQXNVbEptb3JTOWEyOEhzOUcwbFRaU3Az?=
 =?utf-8?B?L1lTcGovRzJKVm00TlZhN1k3WTBBeG9HanE3QzVKeDF4OTlXUlN4SERFaGZ5?=
 =?utf-8?B?ekZ4WElaalZyY2ZtdGh1enZoWnBrRlNuWk5reTlPOFFORDNxZmtZSzRPZTBt?=
 =?utf-8?B?STRpSzU0dHA2WlU1UnhyakIzOUFSZ3lsU1hEbTN0ejVHdmlPZnNzMGVlSFc4?=
 =?utf-8?B?VnQ2WExmWWlnVXg5b3IzcmJWYk1BdHQ3UVNrckNNbjRHemhoNTBGWmN4T2dR?=
 =?utf-8?B?ekxmUENNcFVQZGs3ODZ2cHJFSDRiT3h1ZEVWVk53dXJwU0ZDTURnT1h4VjIr?=
 =?utf-8?B?YWlWdVhDZlB0MW9LSndMTUowNDE1Ry95cm8rczB6ZXJrczN2OE1tRnNIOFJ6?=
 =?utf-8?B?Y3B1eDRkaldVR3Y4UUlFOHd4dWZuVWhxQXNEbEFrNzBvb1lXRmYvcWg0SGtM?=
 =?utf-8?B?clFyUTREcDdqb01LZWdUWTdjRS9PRkVmZHJBbnlOcVBJR3Q1aEZGVnptVjdC?=
 =?utf-8?B?S1A4dVdQS08xYk05UHdSb1BjVTNGbWZOYnB6YllaWXdGQ0t6azkxbFN1TmEr?=
 =?utf-8?B?ejQvT1VQMjFYSWJjam5JUGFCMlNuckF3RlhzakJPNzJBeG90Z2REaUwxT1Fj?=
 =?utf-8?B?ejMzTG5HWk05MENzRUFiU1VpSjFEWngzdGRGRTE1Rm1MbUV1a0hzamIvTnJI?=
 =?utf-8?B?UTdLMGt5RFY2ekdSRWVIUExaSnVPZ1ZMeDdQQWUvOEhMMXpVeVlXcHU4Sk9T?=
 =?utf-8?B?aDlTM2FjdnF0ZmQvSDhmb1pDdTY2ZXV2OGZDU1JVUzk4a20vY21GeTZyd2gy?=
 =?utf-8?B?U09JaGJWWTZrcFpDbWpvNTA2MVdFbzZkdDk4MDBLL3RvdlZ1NUV5RENURzYy?=
 =?utf-8?B?RUJkdVFLZ25xQkd1emNOVXVjT0pteDVNODVGMHN4RVhsb3ZFYnJxNU81YkV3?=
 =?utf-8?B?dzhOc2V3MlYyMERrRmMwQVFCYjJaSHB2Y3V5eU55Y2k3L2hXTUVqYlhXNk83?=
 =?utf-8?B?VDdTRUV6V0RHMUlkc09OUkVzYUNTWklPZzdkc2E5MkdmOGgvYnVuSFRTTHNN?=
 =?utf-8?B?bFpjWndDRUp3bFR6S0Zxb1ZEdy9tTE5xc1FCV2xqMzVQWi82dE1xbldKMStr?=
 =?utf-8?B?K0xzQmFUNm9rbXQ3N1FTVlRKem5xQUxFQnRuajhPZ0x2di9NQ240eW9FUE16?=
 =?utf-8?B?NXZrQ2YrVVJJUisrdCtwZG9jM3luR0FGWDBVN2RlVGgzVjFrUStVSUJPbmYw?=
 =?utf-8?B?SkpBQkhPWUszWjh2WW1DalJDSko1b29DL2Z0d2pwTm9pemoxaVF6UUxUQTNM?=
 =?utf-8?B?b3NJeDlUSEZUcnZHMXdiNVIwVm9xRHZNWFV2TnBZM05wRjR0VXJSazRsVVAr?=
 =?utf-8?B?bGYvTDY4QmwxajFZcUdhV1Jlb0l0eTVDWFZacUI1T0RQSDY4VzVBSTNTQU1C?=
 =?utf-8?B?emIvMU5mcnhXcWhEdUFDUTl5dUtUMVJEM1p3UHBVZTVKcTV2QnZYT2xLdEFC?=
 =?utf-8?B?a0pJNFFJZjA2U3VwRk1OMGoxaVBYUVJsZzQyazhwZ3VKaWhFUlRVM05MWjB4?=
 =?utf-8?B?d1UvajBqeUVPQkRTaFp2QlZ6WERNVE4xQ3dHMGJjbEZuR2VhUWd1Q0hCeDRY?=
 =?utf-8?B?Q1FYWjJMYXJ1WEVYRUNuMWFLYUQ2RjByZVgrcXNmYkxkM2tNZDJkNnkydWlU?=
 =?utf-8?B?T0dWMFlYVWFJU2JjVi8vYU5xblIwSFdIVGxkTFEvV2dxSFFWTkVpZDIwQlJu?=
 =?utf-8?B?bWJkcDJPZDFUamtpemtFdkM1RmJRa0lSTCtvN2FmUnArQzkwZGVuQVhkWndq?=
 =?utf-8?B?Y2lCL0lZVUk0UEFiTStPSlpmKzc2aHZWc1FqT3pSemRPVU1xQUtBYlZyem9l?=
 =?utf-8?B?RFNEbkRnZFpySkNHSWJEY05mdnpYMmNTbGVZbCtuRXZZcGJVbUhZa01uNGlW?=
 =?utf-8?B?ekJPTE9OcTB6NlpYVWRCcmtzQkpIL1pPOUtvNnQ2NzlTNUdWUCtqLy96VzZj?=
 =?utf-8?B?WUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9dbf366-7de5-471c-8a0f-08dabab7e905
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 20:47:07.9300 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pv69yP40N6jX3aM1TOSYqY/IquGuFRwwUFI9EFgOANeJFa8HAeLR7h8ElbG7HhesjgBHytB0MMDOjvfIflDDr39lVpUGnbWYHSMFR4hCUiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-30_14,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210300140
X-Proofpoint-GUID: vvBj8ECQLd-tkf7IQzFUFMycoKjrFvFp
X-Proofpoint-ORIG-GUID: vvBj8ECQLd-tkf7IQzFUFMycoKjrFvFp
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH v3 09/19] nvme: Add pr_ops read_keys support
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 bvanassche@acm.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 kbusch@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/30/22 3:17 AM, Christoph Hellwig wrote:
> On Wed, Oct 26, 2022 at 06:19:35PM -0500, Mike Christie wrote:
>> This patch adds support for the pr_ops read_keys callout by calling the
>> NVMe Reservation Report helper, then parsing that info to get the
>> controller's registered keys. Because the callout is only used in the
>> kernel where the callers do not know about controller/host IDs, the
>> callout just returns the registered keys which is required by the SCSI PR
>> in READ KEYS command.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/nvme/host/pr.c | 73 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/nvme.h   |  4 +++
>>  2 files changed, 77 insertions(+)
>>
>> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
>> index aa88c55879b2..df7eb2440c67 100644
>> --- a/drivers/nvme/host/pr.c
>> +++ b/drivers/nvme/host/pr.c
>> @@ -118,10 +118,83 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
>>  	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
>>  }
>>  
>> +static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
>> +		u32 data_len, bool *eds)
> 
> Is there any good reason this method seems to take a u8 instead of a void
> pointer?  As that seems to make a few things a bit messy.

I did it because the helper functions nvme_send_ns_head_pr_command/
nvme_send_ns_pr_command took a u8.

Looking at it some more I see those functions use nvme_submit_sync_cmd
which then takes a avoid pointer.

To handle your comment about the helper below I'll fix all that up to
take a void pointer.


> 
>> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
>> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
>> +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
>> +	else
>> +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
>> +					      data, data_len);
> 
> Can you please add a hlper for this logic?

Will do.

> 
>> +	for (i = 0; i < num_ret_keys; i++) {
>> +		if (eds) {
>> +			keys_info->keys[i] =
>> +					le64_to_cpu(status->regctl_eds[i].rkey);
>> +		} else {
>> +			keys_info->keys[i] =
>> +					le64_to_cpu(status->regctl_ds[i].rkey);
>> +		}
> 
> If you shorten the status variable name to something like rs this becomes
> much easier to follow :)


Will do.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

