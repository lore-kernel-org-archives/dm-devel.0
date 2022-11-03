Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6966C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462261;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ad8Y2rH2G5ZRMPYhYEXdDCmtERyTmTR3aZ5sOc+pN9k=;
	b=Hwq97l3OGUtsbV55jU0ssWpUcFGxtGupholi2yUCOt/qEQV/c4/L/AQIe5HPgNPFE/qSP1
	eXLtg/JLOUOtfmoT4y+X2fqIaK2LQrIWqA2DsRjJHgXCFydq8TRqNev3V5kfgipab2iAIS
	R+RWCKXJTikoMxB8yAVvxcsEy+sE6vc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-IF3jCro4NWuQrvNrjHCQFw-1; Thu, 03 Nov 2022 03:57:38 -0400
X-MC-Unique: IF3jCro4NWuQrvNrjHCQFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E2A93C0F68B;
	Thu,  3 Nov 2022 07:57:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 081F640C2140;
	Thu,  3 Nov 2022 07:57:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F01311946A73;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C19B61946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 02:25:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AEF7B492B1E; Thu,  3 Nov 2022 02:25:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A55C9492B09
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 02:25:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 874B4185A794
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 02:25:55 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-kQHLoN2PNLaWHIt18Lc4Ug-1; Wed, 02 Nov 2022 22:25:54 -0400
X-MC-Unique: kQHLoN2PNLaWHIt18Lc4Ug-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2Mc1VO002999;
 Thu, 3 Nov 2022 02:25:40 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty33hnw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 03 Nov 2022 02:25:40 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2A30kGFi027286; Thu, 3 Nov 2022 02:25:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtm65yf2-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 03 Nov 2022 02:25:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA3PR10MB7042.namprd10.prod.outlook.com (2603:10b6:806:317::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Thu, 3 Nov
 2022 02:25:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 02:25:36 +0000
Message-ID: <0d88d3d5-1c19-5d2c-c3a6-8ff67f074117@oracle.com>
Date: Wed, 2 Nov 2022 21:25:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Bart Van Assche <bvanassche@acm.org>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-2-michael.christie@oracle.com>
 <569dfa4d-0f0e-a596-1f38-2f4ccc555fe5@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <569dfa4d-0f0e-a596-1f38-2f4ccc555fe5@acm.org>
X-ClientProxiedBy: CH0PR04CA0107.namprd04.prod.outlook.com
 (2603:10b6:610:75::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA3PR10MB7042:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efb4f2b-848a-498e-7ec8-08dabd42b119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ag7cm1EatkNwjF2Jn9+aylpmNvSisDRKCm88sGXqXBpRZg4kKBKstFKYEkfjN5bBSWfCQnbMiUu2ZUT9PsEaHBpPj0wK/lWUW93e3YjtgeonT8uohDHJamXdaNh9abYPEkQWnPaJb6/+/xaj3b0XCRKcLBZxy8IxO3bLCKQt8tXRnNYVopEICPY656ZrKfckZQDcaQFCP2vcXe/QdfRp8jXqxowum78afCu6Ua3MbD9x5RRR/UfmTipYysaW5IDXLgjkmb79wpT88GPqhL+gUiE6S9NawpcQpwaBzcPUlUz8GhI/1iOJyCz2GbMIOkaWHh/4rcovNWITMfZr1vyC0nrEBcnn1iEYOc1LxrWe44ZwuKyqzr4iM/NmIrumQCjItV2mNLUU9AiTIeJiCnp3bn24IS8HLBt7ck5d7eatZ90WvK7mzYqGd3zw4zDNcmkMHVuROWV2v6PpSdW73jjHYrabBNZByewWXekT0GUhv8fVscekCMWijdWaGNEvl88uTZ1rk/lk2keQWsCeNYKHRhZCa+71kDpHI+ZXMpJ5P+mdG/EaVxK1/quWvxhTcVsxz0N5icrd22wHkyP26PTqTIoRQiTnP3KWN/XXsMplbztKTU/Dc858fOY8+mHiLzJ49MAG+bOTB0PaWE4Vf9uIpfSoa8KvJZqqXAhil8iW7Scfo7U3CQHGc/RIsTITTgZe6nXfRun4L1ogj0kvMWEykXw0xykRqcHvXre5gtSz7Htz2p7oKxyfTdeEZuid5AeV+SsosNKZeyt6VcYp065XHtysKeZ7lm3im5N40K2HYJEIbcedSJkdPyGsvudiYCVY
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199015)(921005)(66946007)(66476007)(8676002)(66556008)(316002)(2906002)(26005)(4744005)(186003)(6486002)(2616005)(38100700002)(5660300002)(6506007)(53546011)(478600001)(7416002)(31686004)(36756003)(6512007)(86362001)(41300700001)(31696002)(8936002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0IyaWRVdWRwdFYySDJLVC80SXFwa2JSZzIvVTVhQ0M3eUhWYVZITEVTc3A1?=
 =?utf-8?B?UEQrRGF6QlJyZTFYS0ZMMXpXR0lXZlZKWTd2cUNiSkszQ0JOZXBPcTVabGxL?=
 =?utf-8?B?czZURE54T3R2SmhmL29KdjltUlVQdm4xOWZSWk1tVVBjSnluOWwrd1YyQ213?=
 =?utf-8?B?bkxSUFJRTWR2TDRsM1RPKzcxYTdxVnFxVXRqYWo3YlVyQnhRdGZqSkxJbVNh?=
 =?utf-8?B?WXk1RkZhcW9rTi9ZVk5aeDFzeXBNN0w3bFhjMDVTbVJzbSswWFd6aDRlbWRs?=
 =?utf-8?B?WC8xQkh4a3NUdjlVcU5EZGtqbTl3UEF0TUhVNGxQQm83b2srTnA2L0p1a1RC?=
 =?utf-8?B?YlB2TmtRSk9DMFAzV0FxaVBRU1pZMDhwTUw3aHdvNG5GZE40Z1dUSU9Td3B6?=
 =?utf-8?B?dnpnNlMzSHhUQ1pkbzZtL3QwR2crZytDK2tCdXNYQWh2MnIvNXJUbDIxeklm?=
 =?utf-8?B?NVgyVU9mL0sremNaMERHUFd4cHFmaVJ4K0h3bkxrYXMzdnRxWmQ1NDlwY0Nr?=
 =?utf-8?B?OG9mU3JxVTEzNXUxeTdlRDUxaERDbEcwanZJMUM2Qk1SZWR1Vi9WS3lpcDRQ?=
 =?utf-8?B?cHV5cXBVWWZEWS9yT1Vsdk9oRUVjdmRhc3ptR0RvWmY2RXJyLzRYWWNRaHdz?=
 =?utf-8?B?ZGFZVm9nY3lHblNuMGxUUkJPeHRjcUVXQ3BtWGE3L0VxOGUyWEVKSm9yR2ZZ?=
 =?utf-8?B?TklXRzgybnVxRkZjaFdneWNVOFNVTmtmaUR0Y3Qxck8xM3NvU1EzKythU1lL?=
 =?utf-8?B?bWN5RFczR3dXK2U5c2tBaHF2RzhyNC9vMzRZRXR1bmsrcDNUenVPWmdlTXUv?=
 =?utf-8?B?UEZFVG1KbE5nQ0lUM0llbUpwQXB5MlZMdENadXJKdlp2Z3lKbjhuMjJoVllm?=
 =?utf-8?B?NnV0Z2ZqeExhV0JRN1c5UmttdjMzK0trUzhyZnhqQnVrbVV6SFo2YyswMG5v?=
 =?utf-8?B?NUFmVFV4c0tNT0xGc1Y0Z2pqK2Y3OFZ3TXFBTDlHU1ZjVGN2OUhubnpqTFI4?=
 =?utf-8?B?MEVUMnNBRjl1bGFyZy92YkhiUmNLczhpeFd5eXd1dTU3cEgyV1JZaXlnWGtS?=
 =?utf-8?B?SThwbkE2MzVEaXZINjFIRlczZ3d3WmRINTd2Zndyb3VBR09ZemlrUm1iZlg0?=
 =?utf-8?B?WDYwSFh3MVpEd01FRlV3U3ZKT2VvZUhCWG51MEZTMjlxTlEvdWRCMytrWW5i?=
 =?utf-8?B?SmlQWXh0VFdxRG9JYTRHOTJSWTRNWGROY2lKK0hIRGZVem1PclVnMnVPcnZp?=
 =?utf-8?B?TmlocFp4NFJ3NVZtZ2JwTXVUbFB2aEFKdU05dTFFZVFnNS96QUo1UVNzTytl?=
 =?utf-8?B?SE1vQ3FpVmR1MXJDS0p6NHVvWTVhM3J5S3ZkbWtZRGtoVlo2MEdweUdRdktn?=
 =?utf-8?B?VGtSSHpNMkFjN2lhZ2V6aWdsYmFtK2RVYTJyTW5McHBPOUVkd01ZT2Z3TTVa?=
 =?utf-8?B?WUNLc09LZXpvdzhxNGNlcEJjVHFJNkZXVUVaLytFUUhkdEpRbGVhM25qZ1dt?=
 =?utf-8?B?SHR2M0Vrb2VmVERobTNaMTVFcERVTlkzdER3RTgwdHI5K0c2Skkvd0FFWTNp?=
 =?utf-8?B?NDhSY01WRmRXajJYTmdtQldrRnJnWmZPSnp4TWVWN1VSczNJd09XckdhMmF3?=
 =?utf-8?B?d0J5aXloTnFCZCthQ0ZnNklFOWNrbFF3eHhSMlJaYStyeXA4cVFZeCtoZ2dJ?=
 =?utf-8?B?ZThmcFVVdzdaYTRYeFBHNVYrRDI5cE9WM2N4NlZSYWRET28vZ3N3TkNtR1lL?=
 =?utf-8?B?MG5VMFFVRUp6N2FtSmJsYlRXQUk3TFRXUUN3SFIzeFdPWGZNT3pTL3F2OXp0?=
 =?utf-8?B?aHcyVytydGo1N3B6YmRBcjE1dDJ6WGsvVjVaQWo1WEdPd2ZQa1F1S1RRZWpn?=
 =?utf-8?B?d2lYc0I0RS9zN21CQkxXeFhwb291V0dnTVRHYlRQZm9MT2hZRURoV2dOMXBr?=
 =?utf-8?B?SUdFaEszTkZaVjJpRkFCZS9wQ3pkNTF0VVdpcGttVkhKR0IzbERMSkhraHpL?=
 =?utf-8?B?L1RLc0w3cEE3ZjhLSkJJV3FzUWlNb2kxT2ZrRVhWR3NnUmd1U21ETWtydDZn?=
 =?utf-8?B?UHVJZE42ZGJEYVFQNkhLWlk4c2VhNWF5elFvVzczV1hGdEc4V25neDhIREZO?=
 =?utf-8?B?VWFIK2YxUHdEUjFCNys3UjJmeU5DWXliWEs0K2oyVGxpZ2x4MWZXZjArZFha?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efb4f2b-848a-498e-7ec8-08dabd42b119
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 02:25:36.4794 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yaj9ddQFeAjJ9HfpSr/9IueS6qKJlZg1AEG+4uXEQLKOkjVURx1sBiwie0uT4lL8fKHzDbnZsoK/kcXUXvlDdaMrOZPZKWaUi2oGSJUbgVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030014
X-Proofpoint-ORIG-GUID: JhvFLnldbseX18_QLmdL4ZW-CXhH4v76
X-Proofpoint-GUID: JhvFLnldbseX18_QLmdL4ZW-CXhH4v76
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 2A2Mc1VO002999
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] [PATCH v3 01/19] block: Add PR callouts for read
 keys and reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTEvMi8yMiA1OjUzIFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6Cj4gT24gMTAvMjYvMjIg
MTY6MTksIE1pa2UgQ2hyaXN0aWUgd3JvdGU6Cj4+ICtzdHJ1Y3QgcHJfa2V5cyB7Cj4+ICvCoMKg
wqAgdTMywqDCoMKgIGdlbmVyYXRpb247Cj4+ICvCoMKgwqAgdTMywqDCoMKgIG51bV9rZXlzOwo+
PiArwqDCoMKgIHU2NMKgwqDCoCBrZXlzW107Cj4+ICt9Owo+IElzIG15IHVuZGVyc3RhbmRpbmcg
Y29ycmVjdCB0aGF0IGtleXNbXSBpcyB0cmVhdGVkIGFzIG9wYXF1ZSBkYXRhIGJ5IHRoZSBrZXJu
ZWw/IElmIHNvLCBpcyBpdCBuZWNlc3NhcnkgdG8gY29udmVydCB0aGUgcGVyc2lzdGVudCByZXNl
cnZhdGlvbiBrZXlzIGZyb20gYmlnIGVuZGlhbiB0byBDUFUgZW5kaWFubmVzcz8gU29tZSBTQ1NJ
IHN0YWNrcyBrZWVwIHJlc2VydmF0aW9uIGtleXMgYXMgX19iZTY0IGZvcm1hdC4KClRoZSBwcl9y
ZWFkX2tleXMvcmVzZXJ2YXRpb24gY2FsbHMgd29yayBsaWtlIHRoZSBwcl9yZWdpc3Rlci9yZXNl
cnZlLwpyZWxlYXNlIGNhbGxzIHdoZXJlIHRoZSBzY3NpIGFuZCBudm1lIGxheWVyIGNvbnZlcnQg
dG8vZnJvbSB0aGUgY3B1CmVuZGlhbm5lc3MgdG8gdGhlIHNwZWNzIGVuZGllbm5uZXNzIChiaWcg
Zm9yIHNjc2kgYW5kIGxpdHRsZSBmb3IgbnZtZSkuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

