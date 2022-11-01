Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BF3C43217
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667378507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TPwdVdi28xyROZBDB3e6FeU8Rj7QJ/zWFD0EaMBNpq4=;
	b=JKcWkOHwOYuhKR2NZYqSq9HHDnx5U/Wt0XKeYeUl4jWhg66xc18Qi5w7+2qMaSksq8qXKC
	knbRboUMvbrCzR6fpUjkiZx9Xd7N8NIgJN/ZT8OeFFSs9/4UgtfI84ImevAb2LWZVOAAu1
	jtM0js2UJBfIHcupihIOaq8MwlGDKpo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-oDnifjJhPau2NqEWxVN3lQ-1; Wed, 02 Nov 2022 04:41:43 -0400
X-MC-Unique: oDnifjJhPau2NqEWxVN3lQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEB8C857D11;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E6CD4A9256;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94CF21946A62;
	Wed,  2 Nov 2022 08:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1BBE1946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 16:43:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E4574B4011; Tue,  1 Nov 2022 16:43:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8699E4B400F
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 16:43:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6725A85A583
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 16:43:23 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-BPEtD_fZOZaaWjG23bZjlg-1; Tue, 01 Nov 2022 12:43:21 -0400
X-MC-Unique: BPEtD_fZOZaaWjG23bZjlg-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1FQUau026156;
 Tue, 1 Nov 2022 16:43:08 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkd703j-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 01 Nov 2022 16:43:08 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2A1FbpSf013949; Tue, 1 Nov 2022 16:43:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtm4m2vk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 01 Nov 2022 16:43:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Tue, 1 Nov
 2022 16:43:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 16:43:04 +0000
Message-ID: <6d29c713-47b1-a924-651f-e54b6b1d4785@oracle.com>
Date: Tue, 1 Nov 2022 11:43:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
 <7f837cb5-8439-a1e6-48c5-d1df039d77ef@nvidia.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <7f837cb5-8439-a1e6-48c5-d1df039d77ef@nvidia.com>
X-ClientProxiedBy: CH2PR05CA0005.namprd05.prod.outlook.com (2603:10b6:610::18)
 To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB4781:EE_
X-MS-Office365-Filtering-Correlation-Id: 247e5414-fefb-4643-7c3a-08dabc2825c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: L7F5VPa+9mWv34ckVVjcDWrIn1uLtxY8hkHJM+31ogUcxq2yqLenSnQt5h5LA4dbNySd2aSBchVgxfIZfpEu+M/BKAH+8M7Jnv+iO6vha37u1nNOx6joBQj3A9f4w/57TaKfew+LqurFXDRKz4txD8fSzw08s5MzfSzSp//Kzcf6iXE35dVvqMSE55LMFCuOcSGY2wLvEieoNyIjYjtVKUTyvOZq1Jnem3Su0eWqwDIDLXRVajl2AubNIV0fzBfhx5vCJpCgHz8ZrtD+vDmWKZWpmNkuVKwZH9Gu12xa8WcvTLu5G5+PQr/2RVE5Km4lFdH+DUSSulyjVGPdgs2Ejdkjv+3Sfpz78Ubb8NZ91AdD9KI2lLTmaPxycrfeU3RjZCJYV7QHnVsfNJnjysQWDBEM68sAuod8J9pvMqlOzZ0EZmzYHivqkz2YJYy+MMDb7lyfbavf+Pa29MiB7RV98xVjy4zgJ79krqDRWUvPmyh+X1wZARoegEI2UR/S6Tm5XclWnQVJGG5r8poyASn+CunJmIOWXQSv+gNjAnKpZEW6n7hKZD7sfmrFdKFsVyFZu8+ZLBzzA11y6jsnypLp1Tdnlzx8tzZbGeBX8UR5IvjMdY+O/+AK3Yr3jsVLDnEZEuaGzKLQ1wkZZA/THaqw65v8nTfg8fPh+5lcdn1TS9mTle6TiVBtpBk+mXDeuArKgjSh/C/CRmqbXfpQOM/rDDbotHK0wS4noNg1I/ymtf/bfz+sB7PGeazB4wqLRxKPdlUAPh0ozY2b+DK7yiAt5M8c/nBAuWy9Eq6EdpYLrMG2fZhaPV2Eb7NmcvFYaMlx
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(83380400001)(66946007)(86362001)(5660300002)(31696002)(8936002)(38100700002)(8676002)(53546011)(6506007)(66556008)(66476007)(26005)(2906002)(41300700001)(186003)(316002)(6512007)(110136005)(921005)(478600001)(2616005)(36756003)(6486002)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEEyaW5YVWVXcXVtWEtZeERQTnFhTGhpbG1vc2RaUm1IWGpOa09GcS9kMnZa?=
 =?utf-8?B?eVh3bnRVUWZBaEl6L293RWVZTVF5SlhrZzMwL0dGOW5keVFWRjZLYnNxTUtx?=
 =?utf-8?B?VGVkSytyaGh2TlRhNDgzWFJSdDQwczY4VFEzbGxSeG9Fa3piWTRmZWtLL0Qr?=
 =?utf-8?B?eEJRUDRDMFFvMDQ0am83aEUrK0Q4LzlHOXVMUFdibk1yN3krS08zbnMvcXAr?=
 =?utf-8?B?UGx2a1A3NFZWMHphTUJTM1RmdUM0MFR4M3FZSFd1OXNtSlhndDdtd0E5cXJi?=
 =?utf-8?B?OWZmd2lNL3M2dTZvLzlQa0ZMTllFQjZ4d0tPbzFlbDVqKzRCaE1OWnNnK3Zy?=
 =?utf-8?B?STZ2b0xxS1JVOUFOZ0FLREJwRitMMDhFUHpEZ0hyUVVTZloxYzhtY0dSSXph?=
 =?utf-8?B?bFk4Sy9XQ0VMaWhTYUZoTENzWFVHNnN0bzB6czFIVEpmYlYyYnNRb0N2OFVy?=
 =?utf-8?B?YkdWZ0ZraXNvZWF6VGNacnNHeXJPMWx0aStJRlFleEordG9pTnpDYVpra29v?=
 =?utf-8?B?Sm9yT0ZKSCtrOGdzc2VYbkJSRDFwb0VyQ24xL2lKcHFacXBUTGVOeWo3NVhn?=
 =?utf-8?B?UXZ4WnRPb2NPWHBUK255L2MxWGRuTmt5bU1oN3Z2RFVreklHaXp1TU5SNUxj?=
 =?utf-8?B?NnFhNXpnbDZncnI0VE1HRjM1MjY1NCtwS25EaWxwdG1nbVNkTk1kZzVpZ2VH?=
 =?utf-8?B?UmVHcWRSQTBjRXQ5REhFT0NBNEZlWWlOY1dKWW1KV01naFRxNDhXNHdFQlFS?=
 =?utf-8?B?c1VpZHJpNlFZbTJSaitTb1JDSWFsSHJCZDlXSmxGK2tnQ1ZpcFRIVEZXVTlx?=
 =?utf-8?B?a0YrcnR1MXNQdEhxZjZ4bEluclg4a0dTRHJHdlhnR2NtbGJWYUJKNGJ0eFk3?=
 =?utf-8?B?V2tqR0gwSUMxSUxwcnJqWklTWjkrbVpEOERpLzNOMlpUZzIwWUt6TWQ4bmV6?=
 =?utf-8?B?VldEVUNKTTB3YkdvNjVsZUxUa3diWlY0ZG9RdDQ0T3RmSUg1Z0Zrd2N2MUg5?=
 =?utf-8?B?OHphNmZEUk9TRUtScjhIVVFaNmIyenJGK3ZwLzFuMWdYR3Z5TUlNNmJCamxa?=
 =?utf-8?B?ZjAzdUlWT25lcnpTc3VqZWtaL2VabVFrVU8rQkZGQlQvczlncUl2eGJDRXJ3?=
 =?utf-8?B?dG54QVAveCtJaXUrZGN4TXVrK2dDbGM1U0cvQjBzaERKWmwrb3JON3V2K0JT?=
 =?utf-8?B?S2xLZnpvRkt4eFkyV0xHQ0V4TWJlenZkVnQ4Ym41SWhNT21acGJlaUQwcUNY?=
 =?utf-8?B?ZFhHQlFaOStwSTR5elpUbVhIeTIxdHI0ckNlaGVSWU5hT1F5ZmplSS9yWEZX?=
 =?utf-8?B?VXBsQTVoZUJzMUVhSTQ3MHpkOUhqQm5rcmFhSVlsRUtlSVJyZVl4bjF5aFBG?=
 =?utf-8?B?SnV1UUJUbzA5d2lxUHZPRkdRVUl1SFgzL29KMDlRbFowSm9Yc1R0QzNmQnFp?=
 =?utf-8?B?Nm0zaWlTVU5LdFRoYk42eko2LzFvVzhpek5xRjJaUmJQTDVDNmVVeVArTUZa?=
 =?utf-8?B?RHYvRzdHMFlUcXV2bDdyZzkySGlxV3crMUxKbi9zdGtjd2pjNVk3RUxqc2ky?=
 =?utf-8?B?WXN5QXVXSVR5TUZyUlZLTWl1eHFseDBuZDFZNVBpVTNlSmo1RWZYWnFKcElT?=
 =?utf-8?B?dzRlSERvRFluTFJyQzNUbUVUeXhnUHIzdDV2OW92RlZ1TlpVSTRkM25IOTBn?=
 =?utf-8?B?RjZGUndNWGp3NUZ6d0M1NDl3KytkaCtFVFdXUXZ1SGtsMTNrYlRaQ3J3cXAv?=
 =?utf-8?B?eW1sRllJWStwOEl1aWoxQ3ljdURMaHlreFg2NmVQajYzSDRTMHM1ZWV2NVhQ?=
 =?utf-8?B?T1h5d3lRY21UZXRRTnZ0Uk1MTFN5MnNQUDJEaTlSM05sejFpMUlQTjdPNDRN?=
 =?utf-8?B?ZWIxWWcvT3MxN0MvMFVXVStSV2w0aENoZjBEZzBOWVptS0h2Z2VBNko2RUNQ?=
 =?utf-8?B?T0gyU3Qyb29JU0FQTzN1WE1EaytsVjJNVWUyY2lWUWtsWis4OXYvN0MyUXhx?=
 =?utf-8?B?eDIwTHc2QTQ4eWU4dkpiZS9FY2YxTC8rNElQSUZ4Q3orSlhtdjZzUXZEaTY1?=
 =?utf-8?B?cy95TFVsbnNRVFljZmpUZXUrTzRjNHhLdmt0aDFUTE1jTVRwYXI0L3pSajZY?=
 =?utf-8?B?bnkzeU5COTcwU1Q1b21UZGFtL0sxOFpNUXBHaVo2Ym1NVjU2d3puQVMxMHVz?=
 =?utf-8?B?S3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247e5414-fefb-4643-7c3a-08dabc2825c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 16:43:04.6100 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqoNJRi8X0TGdfedGlKcyQ2WtTLI1c+eQgzFlL+rok/DkU/OwfLBtgpnBe4a4r3ZhJ51+a36kRdi56MRldSdrqtk3x6rAWLUW0ZK0ekCbd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_07,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211010124
X-Proofpoint-ORIG-GUID: uWZ_D26lFwzl5bj4tBLyHj2JRpwLij7w
X-Proofpoint-GUID: uWZ_D26lFwzl5bj4tBLyHj2JRpwLij7w
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 02 Nov 2022 08:41:39 +0000
Subject: Re: [dm-devel] [PATCH v3 03/19] scsi: Move sd_pr_type to header to
 share
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/1/22 12:43 AM, Chaitanya Kulkarni wrote:
>> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
>> +{
>> +	switch (type) {
>> +	case PR_WRITE_EXCLUSIVE:
>> +		return SCSI_PR_WRITE_EXCLUSIVE;
>> +	case PR_EXCLUSIVE_ACCESS:
>> +		return SCSI_PR_EXCLUSIVE_ACCESS;
>> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
>> +		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
>> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
>> +		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
>> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
>> +		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
>> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
>> +		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>> +	default:
>> +		return 0;
>> +	}
>> +};
> 
> 
> do we need above semicolon ?

No. It was a mistake.

> 
> how about not using switch case pattern totally untested below ?
> 
> static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
> {
>          enum pr_type pr_to_scsi_pr[] = {
>                  [PR_WRITE_EXCLUSIVE] = SCSI_PR_WRITE_EXCLUSIVE,
>                  [PR_EXCLUSIVE_ACCESS] = SCSI_PR_EXCLUSIVE_ACCESS,
>                  [PR_WRITE_EXCLUSIVE_REG_ONLY] = 
> SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY,
>                  [PR_EXCLUSIVE_ACCESS_REG_ONLY] = 
> SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY,
>                  [PR_WRITE_EXCLUSIVE_ALL_REGS] = 
> SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS,
>                  [PR_EXCLUSIVE_ACCESS_ALL_REGS] = 
> SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS,
>          };
> 
>          if (type > ARRAY_SIZE(pr_to_scsi_pr))
>                  return 0;
>          return pr_to_scsi_pr[type];
> }
> 

Keith also wanted something like this for nvme so will fix up
the scsi and nvme code.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

