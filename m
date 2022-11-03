Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A481C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4a6ibiaFXGiPKISNgL2XzRlhb6NXgwxJqZvOigwZWzk=;
	b=N78tv9FtpOcoG1XleKgDYPHC2TPlb4+mJF8RfkqW+W229013I4fQYx71MidecgJN2//qS9
	+eVrvuKh7yQVeUPXUsvXyUTm6z7MJO0BZRHaCBzV8iaW/X3kwIoTta4jfKTjchQmc6z57V
	sRMHiC5WSBcgjYql/FrNVYE32PFJK+c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-iGsHDBx8MiiKoeBwnotdBw-1; Thu, 03 Nov 2022 03:57:22 -0400
X-MC-Unique: iGsHDBx8MiiKoeBwnotdBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B9EE2823812;
	Thu,  3 Nov 2022 07:57:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2855C4EA55;
	Thu,  3 Nov 2022 07:57:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EAF319465B3;
	Thu,  3 Nov 2022 07:57:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77FD619465A4
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 01:54:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54E1B40C6E14; Thu,  3 Nov 2022 01:54:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CBA940C6EE9
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 01:54:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 283623C0CD43
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 01:54:38 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-ImyAukPBMcGDM1qZtVQxqA-1; Wed, 02 Nov 2022 21:54:36 -0400
X-MC-Unique: ImyAukPBMcGDM1qZtVQxqA-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2MjvgA029530;
 Thu, 3 Nov 2022 01:54:09 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussudtd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 03 Nov 2022 01:54:08 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2A31M9jN009664; Thu, 3 Nov 2022 01:54:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtmc74wj-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 03 Nov 2022 01:54:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6336.namprd10.prod.outlook.com (2603:10b6:510:1b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 01:54:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 01:54:04 +0000
Message-ID: <37fda332-3f07-4d98-4317-78d84763218c@oracle.com>
Date: Wed, 2 Nov 2022 20:54:02 -0500
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
 <6faaba2b-5fb3-7121-5796-af2b2f73b6e7@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <6faaba2b-5fb3-7121-5796-af2b2f73b6e7@acm.org>
X-ClientProxiedBy: CH0PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:610:cc::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: f76d0a37-9a8c-43e2-3f5f-08dabd3e4976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: oiVE+SY1SxSsogsGZXWI2EJwUnE+t5p+a7hhK7FNnQ5+roRPZTVjlPgNoi4BogNcXnfVnWLEz+/+tPR/CCzWynDzRkYuLgG3p3V83xfeOf1PIDS1ne1iQ7t9tjlHnCBGekEwE6+raJVjgKF1/3q/rZatUaN56pPoDTHGZ2sdx+HsFdXLMRR8fX7ASjT6nQIH6h6gZtDawvB4W+gQGXaMNP0bxFqjJGLhPSVSzLQsAc/mtHGg0/KhGyXNHColjFpOsvtleesCsJKDbVDpp620DXXNSyCnXCjI49UbyT7YwQGGVPtnlZ1uS52BNty1x2uDBRZMGXucGCYRbv/MXH6nccqPsFpNCV96Ih7EGkSNX0ZDTA3TUlslF2NVo+AtaKmk4pwpPfLEAnEVIwiak4MwJeH4wL9SKZC3PJvLLIodgIyW2qZtDiFj2J52An5V/vG5/LcysSzASfWmVbv+iFVXQohFECN/r603mSK9db8GVDhM6NgUm4vH0O7QZnPN8ASY4HQu/yQeHXo8HcHGpmW16odtHRGwpiX3ogJxfSOuafZenYx+qBj5/Ro/ZMWGl0AedjKStSIejlCurjzrF5gu23yMCBGDZ0v0t+wQkwfn0JFv3jxq/R8T2hsBSd4ZFSoz/GJ9yx2ollPMxv3bX+mNvOhz3v5hL/DrjVY0Nj4gWiuZER0MQabQOUAADtI2Wzroubi/v95yLvagTjrCi7q1BcQhxIS4WHLzuJMX2qsAyGNi5psPJLH4qsdKgFZ0xm9fpEinum4uCL5qdzKG3B+ZW/XFq6Nx+Mx11dSQQst3F0YBm6Ox+gEwIVa0NW4zmjro
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(6486002)(316002)(8936002)(41300700001)(5660300002)(7416002)(38100700002)(66946007)(8676002)(66476007)(66556008)(6506007)(186003)(26005)(2616005)(53546011)(6512007)(478600001)(31696002)(83380400001)(86362001)(921005)(31686004)(36756003)(2906002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0VxTHZNc2xYNFA4RkRxb3p0MEMxWFZrWUVKeFZyUlZiYWlMVTMxTlhXRVpI?=
 =?utf-8?B?WUtNaHVpTUhZUGw0N0ZmNlhtSmhFZEFZWTVzTUNQWGZwbDJkUUFmZkFkbUh2?=
 =?utf-8?B?elpsdWxpVFEzWjJMTWR1bVlUQTZKTm0yY0ErOVpEalpPVjF2RXl4VFJWdkhz?=
 =?utf-8?B?OVFNUjZwem5zTkEwcmpHNHZZVTJXc3FQVXg0c0wxSU1JRFZWRlJhMHhQSm51?=
 =?utf-8?B?RGRzVE13YityQTJBT2d2NkNubUhmNWpYR3hhZEpBZmk3a0lzVDBVZTdEWkZE?=
 =?utf-8?B?UkV3T0kwb0pyRmF6WTFKT2R5bkVNMGlkRGtiWFBIWHNtWHpPUXllV01wM0k5?=
 =?utf-8?B?R3p1d3p1RytLVW52M0s3aXJ1c2h1MGZCZ2FOTDhOVWgyOE5KU3N1WXlOYjls?=
 =?utf-8?B?dFUvU1JNMTFsS0U4bGRrVjlJdnl6TDdUaC95TDFVV0hnSkxYdUpQaElvLzJ2?=
 =?utf-8?B?bllHdHVYdjRWQjh5TFZEZGtRaEJ1TGxSWVFyaXNheThtNFplaXFjS1hGNi85?=
 =?utf-8?B?YVlPQjlnNTNmVXdZOEJISmVQZnFpRjV6dzhnSFpsOTdxbVB5NFlpd3BTa1Ax?=
 =?utf-8?B?QVdhdjdsejNqelREMU9GbkorQXozcERXcm1OYUJYVys3TDlyRm4zVG1zVDFr?=
 =?utf-8?B?M1JBb2I3c0w4aExFUHVIUGFuZDkxNjRybFZzWnJqRHNOV0Z2Y1hqT1RISTAx?=
 =?utf-8?B?YTFQM0doNnN6QkNzTnhNSEszTXdLY0llYVMva3pweVVERjFuSjNDcXJwUVlU?=
 =?utf-8?B?SjNQQXBUQnhvRytMeEZMdmNzc3FtRE1tai93dFJUTlRpODVrYXFoQTArSDZT?=
 =?utf-8?B?WEh3aGhrUXR6Vkg2REtDK3Y5ZGp1UEVRVjF2R0d2eUtDQ1RhQkFYbHdOUXlu?=
 =?utf-8?B?cUdBeER2UFI1ejhpeDdFVHJOQW1tbnQrbkdNNVpORkZ5UnVNV2JqUFV6bUlx?=
 =?utf-8?B?Sm1PelpJbjB2NC81cjdXOTFhTGJpcW1hNGtjT2hRUlMxWjJ6OG5ReWJiOC95?=
 =?utf-8?B?cVExdW9JZXZ5cGZYemVDUllsNU5WUWIzVGpiS1JDUm5yc0RSelh0NGlzVFRB?=
 =?utf-8?B?SExuUmJjdTEydGQrc1VjOUo3alBMVmFuLzRDRVJWbHhJN3VJWDJaYTNWRkJT?=
 =?utf-8?B?ZmVVNXlybjR3bEgzNHFZdis5Zjcrcm03dmRiYVkvQzlqakZLNUZ6V2haQlBm?=
 =?utf-8?B?RkRFaFp4ZzVmSjdaaHNsVktRb3VhcC9odUhPemRwclpwQ3N1QU5pcmZGNjhX?=
 =?utf-8?B?YnlHU2xJRXFBQ3ZGYWEwMW83MElEZCtIQ2d5MzVqMlhwZVZrYklnZWZYQ2R1?=
 =?utf-8?B?V2huUW1VQm9GVytaVmlsVm5hTHdzMGdlN3BzRHB2QThGLzlEbW5OOWhTSGcr?=
 =?utf-8?B?SXpkU1IwQ3RKeGxpWXptTXR3aVNxZ2krblJ5bEhDYmN5bzYrdzcrbnRkNlg1?=
 =?utf-8?B?ajBwRnFqVFhaS0hER0VoZG0vU2JMRFQ4SzIvZ3p3M3pIdVZtMmxXWElhQm8v?=
 =?utf-8?B?akJNZ213TmNMNllZWnJHVEVFTVgwYkdVZmcwYlA3WisxalA5Mk1pQ20wdlFG?=
 =?utf-8?B?QWhxZ3dQUjlLcytlSFJXZFBGUVM1L1R3K3l6TXUxUkJ6TVNHMG1zZEluMXAy?=
 =?utf-8?B?SFEvZDBSanczdXk3NFlGZE9mL3k0bmt6TUFITDJ5ZElXUjBLVlZYZmN2SkhL?=
 =?utf-8?B?UThrQ3YxWEYxNlhmMWZMZ21NTGRRNklNVzlhVDB6OWFNYk9BSHdzSjdrYkQ0?=
 =?utf-8?B?R0huYjZoYi8ySlVCS2JJb25Xd0lVYi9FNUcrK3p4blFNUXkwV054WjNKdjNz?=
 =?utf-8?B?MHk0VTdxbmUxNjBob2xrQUlOQjFLM2NyMEE0SkxBbnRrNHFWbURPSEpGemRQ?=
 =?utf-8?B?OW1LMWZEeHg0dFQrYkw5VDQyYzljalcxNWJBTjA1WVA5YlpWaStnenNYRUVK?=
 =?utf-8?B?aEUzSjJvQmhVR0hEdE5OdEl0MVBsa2t5aVk4TTFmWEI2N2cxYnRDa1FlMjhV?=
 =?utf-8?B?VzR4TUp5a2kzMVNqNGxtWWdXMUVGWUhzWHRrWnFMbGV3S3NERXIxdUt6dmtk?=
 =?utf-8?B?NVhXTU41Wlo0K0swWCs2L3pVZTcraTRTcjVYWXpWekRVejVYak02YjFlS0xU?=
 =?utf-8?B?UzJNaG9MQjBtWDB2QlZSNFdESDFMM3NUSlVvODJieUFGNEJpSmRKMlNFc1NX?=
 =?utf-8?B?VkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76d0a37-9a8c-43e2-3f5f-08dabd3e4976
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 01:54:04.7267 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zc/xdPZYWjGPycNvByeWi58z7Osk6LySoQEI1vDAUzD0MjN5QDsOIbAO19SytYH8QusCQt0fYr1E21x7LGhzO/aTwa80h7GXIqQESI+asQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030011
X-Proofpoint-ORIG-GUID: -KB-NS4_DQP3JaHwKjjHHnGESiz_kkAQ
X-Proofpoint-GUID: -KB-NS4_DQP3JaHwKjjHHnGESiz_kkAQ
X-MIME-Autoconverted: from 8bit to base64 by mx0b-00069f02.pphosted.com id
 2A2MjvgA029530
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTEvMi8yMiA1OjUwIFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDEwLzI2LzIy
IDE2OjE5LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPj4gK3N0cnVjdCBwcl9rZXlzIHsNCj4+ICvC
oMKgwqAgdTMywqDCoMKgIGdlbmVyYXRpb247DQo+PiArwqDCoMKgIHUzMsKgwqDCoCBudW1fa2V5
czsNCj4+ICvCoMKgwqAgdTY0wqDCoMKgIGtleXNbXTsNCj4+ICt9Ow0KPj4gKw0KPj4gK3N0cnVj
dCBwcl9oZWxkX3Jlc2VydmF0aW9uIHsNCj4+ICvCoMKgwqAgdTY0wqDCoMKgwqDCoMKgwqAga2V5
Ow0KPj4gK8KgwqDCoCB1MzLCoMKgwqDCoMKgwqDCoCBnZW5lcmF0aW9uOw0KPj4gK8KgwqDCoCBl
bnVtIHByX3R5cGXCoMKgwqAgdHlwZTsNCj4+ICt9Ow0KPj4gKw0KPj4gwqAgc3RydWN0IHByX29w
cyB7DQo+PiDCoMKgwqDCoMKgIGludCAoKnByX3JlZ2lzdGVyKShzdHJ1Y3QgYmxvY2tfZGV2aWNl
ICpiZGV2LCB1NjQgb2xkX2tleSwgdTY0IG5ld19rZXksDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB1MzIgZmxhZ3MpOw0KPj4gQEAgLTE0LDYgKzI2LDE4IEBAIHN0cnVjdCBwcl9vcHMg
ew0KPj4gwqDCoMKgwqDCoCBpbnQgKCpwcl9wcmVlbXB0KShzdHJ1Y3QgYmxvY2tfZGV2aWNlICpi
ZGV2LCB1NjQgb2xkX2tleSwgdTY0IG5ld19rZXksDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBlbnVtIHByX3R5cGUgdHlwZSwgYm9vbCBhYm9ydCk7DQo+PiDCoMKgwqDCoMKgIGludCAo
KnByX2NsZWFyKShzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCB1NjQga2V5KTsNCj4+ICvCoMKg
wqAgLyoNCj4+ICvCoMKgwqDCoCAqIHByX3JlYWRfa2V5cyAtIFJlYWQgdGhlIHJlZ2lzdGVyZWQg
a2V5cyBhbmQgcmV0dXJuIHRoZW0gaW4gdGhlDQo+PiArwqDCoMKgwqAgKiBwcl9rZXlzLT5rZXlz
IGFycmF5LiBUaGUga2V5cyBhcnJheSB3aWxsIGhhdmUgYmVlbiBhbGxvY2F0ZWQgYXQgdGhlDQo+
PiArwqDCoMKgwqAgKiBlbmQgb2YgdGhlIHByX2tleXMgc3RydWN0IGFuZCBpcyBrZXlzX2xlbiBi
eXRlcy4gSWYgdGhlcmUgYXJlIG1vcmUNCj4+ICvCoMKgwqDCoCAqIGtleXMgdGhhbiBjYW4gZml0
IGluIHRoZSBhcnJheSwgc3VjY2VzcyB3aWxsIHN0aWxsIGJlIHJldHVybmVkIGFuZA0KPj4gK8Kg
wqDCoMKgICogcHJfa2V5cy0+bnVtX2tleXMgd2lsbCByZWZsZWN0IHRoZSB0b3RhbCBudW1iZXIg
b2Yga2V5cyB0aGUgZGV2aWNlDQo+PiArwqDCoMKgwqAgKiBjb250YWlucywgc28gdGhlIGNhbGxl
ciBjYW4gcmV0cnkgd2l0aCBhIGxhcmdlciBhcnJheS4NCj4+ICvCoMKgwqDCoCAqLw0KPj4gK8Kg
wqDCoCBpbnQgKCpwcl9yZWFkX2tleXMpKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsDQo+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgcHJfa2V5cyAqa2V5c19pbmZvLCB1MzIga2V5
c19sZW4pOw0KPj4gK8KgwqDCoCBpbnQgKCpwcl9yZWFkX3Jlc2VydmF0aW9uKShzdHJ1Y3QgYmxv
Y2tfZGV2aWNlICpiZGV2LA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHByX2hl
bGRfcmVzZXJ2YXRpb24gKnJzdik7DQo+PiDCoCB9Ow0KPiANCj4gSXMgdGhlcmUgYW55IHByX3Jl
YWRfa2V5cygpIGltcGxlbWVudGF0aW9uIHRoYXQgd29uJ3QgaGF2ZSB0byBkaXZpZGUgQGtleXNf
bGVuIGJ5IDg/IEhvdyBhYm91dCBsZWF2aW5nIG91dCB0aGF0IGFyZ3VtZW50IGFuZCBtYWtpbmcg
Y2FsbGVycyBzdG9yZSB0aGUgbnVtYmVyIG9mIGVsZW1lbnRzIGluIHRoZSBrZXlzW10gYXJyYXkg
aW4gdGhlIG51bV9rZXlzIG1lbWJlciBiZWZvcmUgY2FsbGluZyBwcl9yZWFkX2tleXMoKT8NCg0K
VGhhdCBzZWVtcyBvayB0byBtZS4gDQoNCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

