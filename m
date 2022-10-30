Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 829DAFA3746
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198339;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t9XNhMGbV0ikiGGX6CIxMALtPXbN9fpzpDVt8IKRv2c=;
	b=hMRRtfMZpQXys12M8J8p62I0bosBZdnqdOSQnNpR9kYZG3JxyU63v3N9/l5shljZ35i24i
	Vflc1L/jKFU/sHfFDa+7i/NWEMqUSh3jL0H5Fnp1L1JRw3Ep/5BkgDQpaCpu83fFwlNE34
	YnksNg7fXoupjpn20ibwXYyia9SRFp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-LHouJj4TNnOhkplc8zI0aQ-1; Mon, 31 Oct 2022 02:38:56 -0400
X-MC-Unique: LHouJj4TNnOhkplc8zI0aQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 926D884AC9C;
	Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76903C1E1B1;
	Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC189194705A;
	Mon, 31 Oct 2022 06:38:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD68F1946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 23:06:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B9C12166B2F; Sun, 30 Oct 2022 23:06:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 536B42166B29
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 23:06:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E8421C05146
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 23:06:06 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-RoTdFMp-MpCU_TnqXyvg6w-1; Sun, 30 Oct 2022 19:06:04 -0400
X-MC-Unique: RoTdFMp-MpCU_TnqXyvg6w-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29UIHMHm014032;
 Sun, 30 Oct 2022 23:05:46 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqt9yhp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 30 Oct 2022 23:05:46 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29UMYAhQ029388; Sun, 30 Oct 2022 23:05:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtm2m4y8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 30 Oct 2022 23:05:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6304.namprd10.prod.outlook.com (2603:10b6:a03:478::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Sun, 30 Oct 2022 23:05:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 23:05:38 +0000
Message-ID: <a7e447b5-b26e-7aa0-ab6a-3463b8497d26@oracle.com>
Date: Sun, 30 Oct 2022 18:05:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Christoph Hellwig <hch@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-13-michael.christie@oracle.com>
 <20221030082020.GC4774@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221030082020.GC4774@lst.de>
X-ClientProxiedBy: CH0PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:610:b1::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 8916f4e5-371d-42f7-fe2d-08dabacb4270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: e2y7Pi1MUJhEqj17Nv8PnQpaAV6EGYjGQ3M7l9b1LN6T1+2myMdwXwqIFCz4ELFWDLb8D0ntYyRO7GaZCMjtllblKWkGNxv5bjLs2L97yL6jwMgmlXXm3eX11eIIsJp+KWvSt38x7yNnh0quVZoOJUrqp41iaYahNpzkQ0G/cEYHQ00rtMsoGJnDQlkc7pmS5npEUaQvQ6+F3wnBsTHCGQaC1kNRE9cHhkd/O0j9iyp2iRCrTuYf8SNiil+tkODu7gjdqMc+lJeE6hD905nnze+fw4XY0PA9PZX6qxSRYlNsn/1/c5O9+rNriSp+AMmmkMLhCu8jAmBWPZ4pGGIzBsCPMEa5Uj726LdEuXYkqwU5lui0xeeaXLgBTvwoCIUcgZXyv5YD678jwqM39QK+MtKkeJ37Jis9+u7Z0Bmq5/NvF8+8ZXQ8qZNkYbJdeSYIGMqNuLvBiuJhh/dLvtvX6bhCvMQ12PowsEpkqnQ3amx9ITZnqwdTlpXBeOCT+0z9itWGTTLdDq9JLlM9lYUXrG2tTz4/1faT9ou8q57wc6KTKy09W7kIcWusYiC2c0jc56Zej/LLBLEp/xQlqTGRZuexL5rQgZWP1qOy0lkakLQ2o8ExQccWXRYHv2c9Vpcu+FIgT1adT0pXpzhbPfn3OsNV7mOOK7qeD4/JNytPknoPbJiiSo4Lyp1Tc1yJF9oJgPwsKbnuXIfPrlINOsKRT5zom0XugD5qAvAdSyDkxxWFTklKZPZufrZNzZ4XfnKNpilpDa/douRKvC2AmyWtKHMfjtF5D+LdTYUgsyR5bsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(53546011)(186003)(83380400001)(31696002)(38100700002)(2616005)(86362001)(7416002)(2906002)(8936002)(6916009)(478600001)(41300700001)(6486002)(66946007)(6666004)(4326008)(6506007)(66556008)(26005)(66476007)(5660300002)(8676002)(316002)(6512007)(36756003)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVVvNnBwbkpSbmhxZWUxNTZDSVdlZDlkQjVENVJYQjVuOHdCdW1McldwblVi?=
 =?utf-8?B?QUVlZmVzME9RNzBZNE5kQ2s4Z0NUUC9lKzRwREdLS2JPRS9wdDlLRlpMdHE1?=
 =?utf-8?B?bWxLV2lSU20wU3FmdGptZ09hODFOTlc2dEJWaUdpTUI1enJQcmtaYXZGT1lQ?=
 =?utf-8?B?Nm0rNkRNcVgrcS83ak9xckpld1NtM2gveDNsQitSSGlCZmVmYkN5a1R5TEdl?=
 =?utf-8?B?QkMxY1lSc0Nzc2RQU1d1WmI3NUxvdXcwTGxEdGZkVkkxenIvTHpTN1JGR1Fu?=
 =?utf-8?B?bWJvY2JRQjhEQ0N2bDh0MU1zNVQ0UGJXUDBZRGN0VnhCRzJPYnpyYTQvMXNx?=
 =?utf-8?B?S0VmRmxJQnc1Z3BHd1RZdjBUUnQ5MldCZmo0aUliZlZOQW5RK01xak1vK1Zu?=
 =?utf-8?B?WnJwZDFkQllVUGl6STloeXJkOHo3Z0FRUzYvVHRaek9qRTJDOVNva1crcUQ2?=
 =?utf-8?B?Rk15Q1dnYnNucHozYlVnL1A2MUE5QUJNU3MrNks1WWpzNCttNURkYTM2SWZv?=
 =?utf-8?B?aEJSSzVrdzF6UkdINXlrUEFsVjdWa3czMEVYZEFKZTI4OUh4QU9WYlRRZ3cz?=
 =?utf-8?B?TWxkTHpxZWFPWDZURFQ2S3YvUzI3bFJZejRNZG1wTDZPTng3QmVVWkU3TXNv?=
 =?utf-8?B?Qis5MFd2emhScHRFcHd3S2ZIUmlUWENMUzdtSXFuejgvRWRjajZOVkQ0Nzh0?=
 =?utf-8?B?T09oVzRoUEV3KzZRNitzc1lFbVpKMUxiM0VqL201a2VuNWhrRFBKWDBlUjBk?=
 =?utf-8?B?ekN2Wmp6MmYzbjZvTHVGajJkcHNRSWlEK2FUUGdvVHlGcmQyNDE1YUFHNndo?=
 =?utf-8?B?QWo5M1BjTERoemV5RXdCS2NlZW53M3J6aEN2MUk0ckVDR0xzVlBiRHA0QjdR?=
 =?utf-8?B?U3pQbTNhMXU1K2tqTCsvenJXaFdoR3h6L01rSnN4WjRkdXQwMjh2UVVnc1M0?=
 =?utf-8?B?a0o4aUZUKzFDTytwMzV3R0JiU09YcG9Wb1JxU25TbzM3dEpSc2c2Ny90Rk00?=
 =?utf-8?B?bkpsOE1UVkQvNmlucjRxZ0RWY1pTWGJSSFVmeGswY01penY1bncvMVhlTm9Y?=
 =?utf-8?B?OWJnZWF1RlZQejdUWW5BdHhLMUVuQzU3amtjS01mNC9DbEI4cjg4a0VFZlNm?=
 =?utf-8?B?OGpGNTROZCthcHl0N09pejUzd0xFQTFPSmtpSk4weDgyVGgxMnNCUURTOExt?=
 =?utf-8?B?a2w5ZHpRc3NKTUpBSWlhdjVqV3V6c3FUQnlwRnVlb3lSUjRLaTlrYlo0YXNJ?=
 =?utf-8?B?bTh3RTNDT01NSWJPandXN1JjcEpWSWVGM2hoYmJyKzN3bXJsbDVzZENrM0ZG?=
 =?utf-8?B?MmNySjk2Y2lHV1FnclQ5ZHp2R3BnOFpTSm9HUUNyeDBuTVFUVllXU2Y4cmt6?=
 =?utf-8?B?dkI2bGVXbytEYmhTY0QrQTczWE1ENzhxSlZpVU5lR2ZEdlpIWktQdGVjYTF1?=
 =?utf-8?B?QU9hQ0t0Q0hjOUhyR1hDMi9mTjdlWEhGa0hMaThSRGI1YmYrQnpQbEdoUHFU?=
 =?utf-8?B?RkVHV2dQeTVRSEhOWVhWanpwUmN3bzlEUWtMYmI4NGYraUZPdHVVYjRXeHE4?=
 =?utf-8?B?OFN5bkJoSnFHQUE1Vld3dUZ3L1JJT1c2K3hQdThMMCtMNFhSa2Jaa2FIUVhh?=
 =?utf-8?B?VXhtY1NKK0FlZkRPcUE4K1kxM1VjL2pIYlBGVklzNGZ0MTFlb1RucFZiUHNk?=
 =?utf-8?B?QzdqVGlSMTlITDg2REUxbFY2NWNqU1hKTVpyNGp0UjJkSlpxZy90S2NMRkFH?=
 =?utf-8?B?M1QraGdqR0J1OXBoeFU2RVErMVJVc1Rxb1djRDlWWVB2MjVIWmo2S081OEFz?=
 =?utf-8?B?U1FxWTVvVXJMNCsxR1FEY01TRG9uMUNBZjZXZmtqTkEyeDJObk9YNlNRZDR5?=
 =?utf-8?B?TzdXM09MT2RjM1psY0ZoeWdBS3A3ZVhlalB3cktNWjc5UEZCWkF6dzZ0aEc2?=
 =?utf-8?B?Y0UrVlA0MXBLbzJXUVhyRHlLVTJQaHZGZzk5SnVUMm1ZdHlQdVA3RVF0WWpn?=
 =?utf-8?B?RllpRDUrSk8rRWg3S0dvdzl6aGM4YUJLMUtwaDBPK1RLSmE1bUhWUm9OTHNB?=
 =?utf-8?B?blB4TS94NTc0YVFGWXNWOEU0YUVNbGRqcmE2dzF2UWtSMkxOQ3IrdGtWcGUy?=
 =?utf-8?B?T25seURxTHBGR3c3c3dlc25KVU1wcHlDU2g4Z2JwWVVCdnhCMHVId1ByOVQ3?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8916f4e5-371d-42f7-fe2d-08dabacb4270
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 23:05:38.3893 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cjQhPAd03cnEzpBZs0hbBgNjFLARBgf9R+uAA8pxdBSq7UnHoUxDCF4H0zQ9r80Wdx9Hp7T7yiU9uPWTMtYh2UzzVvl4l5fGIrMjV8tYH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-30_16,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210300156
X-Proofpoint-GUID: epqE2Bnfy914LdWn-gLTqIUUheB9EdDJ
X-Proofpoint-ORIG-GUID: epqE2Bnfy914LdWn-gLTqIUUheB9EdDJ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH v3 12/19] block, nvme, scsi,
 dm: Add blk_status to pr_ops callouts
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/30/22 3:20 AM, Christoph Hellwig wrote:
> On Wed, Oct 26, 2022 at 06:19:38PM -0500, Mike Christie wrote:
>> To handle both cases and keep userspace compatibility, this patch adds a
>> blk_status_t arg to the pr_ops callouts. The lower levels will convert
>> their device specific error to the blk_status_t then the upper levels
>> can easily check that code without knowing the device type. Adding the
>> extra return value will then allow us to not break userspace which expects
>> a negative -Exyz error code if the command fails before it's sent to the
>> device or a device/driver specific value if the error is > 0.
> 
> I really hate this double error return.  What -E* statuses that matter
> can be returned without a BLK_STS_* equivalent that we couldn't convert
> to and from?

Hey,

I didn't fully understand the question. The specific issue I'm hitting is
that if a scsi/nvme device returns SAM_STAT_RESERVATION_CONFLICT/
NVME_SC_RESERVATION_CONFLICT then in lio I need to be able to detect that
and return SAM_STAT_RESERVATION_CONFLICT. So I only care about
-EBADE/BLK_STS_NEXUS right now. So are you asking about -EBADE?

Do you mean I could have sd_pr_out_command return -EBADE when it gets
a SAM_STAT_RESERVATION_CONFLICT (nvme would do the equivalent). Then in
lio do:

ret = ops->pr_register()
if (ret == -EBADE)
	return SAM_STAT_RESERVATION_CONFLICT;

The problem I hit is that in the ioctl code I then have to do:

@@ -269,7 +270,14 @@ static int blkdev_pr_register(struct block_device *bdev,
 
 	if (reg.flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
+	ret = ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
+	if (ret == -EBADE) {
+		if (bdev_is_nvme(bdev))
+			ret = NVME_SC_RESERVATION_CONFLICT;
+		else if (bdev_is_scsi(bdev)
+			ret = SAM_STAT_RESERVATION_CONFLICT;
+	}
+	return ret;
 }
 

or I could convert the scsi/nvme or code to always use BLK_STS errors.
In LIO I can easily check for BLK_STS_NEXUS like with the -EBADE example. In
the ioctl code then for common errors I can go from BLK_STS using the
blk_status_to_errno helper. However, for some scsi/nvme specific errors we
would want to do:

@@ -269,7 +270,36 @@ static int blkdev_pr_register(struct block_device *bdev,
 
 	if (reg.flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
+	ret = ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
+	switch (ret) {
+	/* there could be nvme/scsi helper functions for this which would
+	 * be the reverse of nvme_error_status/ */
+	case BLK_STS_NEXUS:
+		if (bdev_is_nvme(bdev))
+			ret = NVME_SC_RESERVATION_CONFLICT;
+		else if (bdev_is_scsi(bdev)
+			ret = SAM_STAT_RESERVATION_CONFLICT;
+		break;
+	case BLK_STS_TRANSPORT:
+		if (bdev_is_nvme(bdev))
+			ret = NVME_SC_HOST_PATH_ERROR;
+		else if (bdev_is_scsi(bdev)
+			ret = DID_TRANSPORT_FAILFAST or DID_TRANSPORT_MARGINAL;
+		break;
+	case BLK_STS_NOTSUPP:
+		if (bdev_is_nvme(bdev))
+			ret = NVME_SC_BAD_ATTRIBUTES or
+				NVME_SC_ONCS_NOT_SUPPORTED or
+				NVME_SC_INVALID_OPCODE or
+				NVME_SC_INVALID_FIELD or
+				NVME_SC_INVALID_NS
+		else if (bdev_is_scsi(bdev)
+			ret = We don't have a way to support this in SCSI yet
				because it would be in the sense/asc/ascq.
+		break;
+	default:
+		ret = blk_status_to_errno(ret);
+	}
+	return ret;
 }
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

