Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8554FC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660061916;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9wgMcF80nQW/smE9PQe8PGWbBndaDhEwzaWnGMsIFh8=;
	b=dIsIF2UVsZ7UruKiuKHHy/BFmy17yr8vJik7w6iGUbBMJiNgQ2Y+m3w/uuN3lHEeQ5oyme
	U8neoQzoDgpwX2SEg+zJSZx7sVGrkWmQVewzTlhQL7k2a/lmUd6sDsArWQPBGSjfqKCHSI
	hHJhmjJG22sIXrFmvL1bOoYqbQe9TfQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-nEDFqWmnNzCNo5AptiGjYw-1; Tue, 09 Aug 2022 12:18:34 -0400
X-MC-Unique: nEDFqWmnNzCNo5AptiGjYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAC2C1C0337D;
	Tue,  9 Aug 2022 16:18:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5ED940CF8EB;
	Tue,  9 Aug 2022 16:18:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88FC01946A4C;
	Tue,  9 Aug 2022 16:18:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F8581946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 16:18:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4A26492CA4; Tue,  9 Aug 2022 16:18:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEEC1492C3B
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 16:18:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C246419705B9
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 16:18:25 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-BEcvATZTMBWQ7iNho-DYvQ-1; Tue, 09 Aug 2022 12:18:23 -0400
X-MC-Unique: BEcvATZTMBWQ7iNho-DYvQ-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279Efkkg021088;
 Tue, 9 Aug 2022 16:18:10 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69pxct-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 16:18:10 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 279FSlZ4014034; Tue, 9 Aug 2022 16:18:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser92twd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 16:18:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4296.namprd10.prod.outlook.com (2603:10b6:610:7a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Tue, 9 Aug 2022 16:18:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 16:18:07 +0000
Message-ID: <9c8acdfb-6c0f-2188-9d7b-b0a792fab85a@oracle.com>
Date: Tue, 9 Aug 2022 11:18:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <de98be35-c5e9-742c-5d9d-fecefaf3c667@nvidia.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <de98be35-c5e9-742c-5d9d-fecefaf3c667@nvidia.com>
X-ClientProxiedBy: CH0PR03CA0449.namprd03.prod.outlook.com
 (2603:10b6:610:10e::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11161ea3-7bd3-41b2-fff0-08da7a22be6d
X-MS-TrafficTypeDiagnostic: CH2PR10MB4296:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: lUUnvgKVsex6ojD9AvFY1Six9AGZWLHN3Qatq5q+BKfhPxgthd8Fql5gki3YfZAK9+von7cUg2kh7ZskRz8cUvZXCXjvW1/uxRw0gqWhNb16Ah5Y6YVGg5VSjC63HhTm39rA9H8HHK4ABkIAXn/Xk8ciMx8XfmdOJKt3MKzTbPyM+qAXmtF5Q/LMUpurnmKOp+ZdVYy+ZHrfDRi6jWZDUOEPDfKb7o2wW/rlZSMAW6f9SJWE69YalYqrgpnsuzwrzKH2Iou9SuPhmqIu9FyjYY80HUUzrNT2zEIF0i82hGCn7VZlB6hgaXE5WFa/phcAQ0fgA5eHF/YIcy6jBi2uGykpdnpln35Hj/bxPFMHdp69ZrG80PqRSjRC67sfI9+n7ySSVhh0M6tjPO80FamqA/hbFp9TqXl/N3j9FDoszZR5GnNG2IsoEjLnxQV5WobyvrYH72eroNDVn8RTDjmx9MGPH/Sk23IPYpae+S7dtugDUacWungqsyAslffLJeYO/Nj44+5rvK/TdqH21KDGTZUK3rNJiLKu4KlMS1YDj12XofvM/aHh3U86kxsV3xejux8H3901CvtMtifNOQoCHGylpSFtEUtpDkQ1VhNFmcUUIo/YM3GExer25S6jvI2LfYQ/WubgxF+TiRcPumquZ63HidVX0Bge0kcWtfz6CFWMoQlFr6ZM739M8Cpp/Fkk9lA4Q7NuI9hkEo/pSI8SYeMprIa+btK9Crse+qktvatwHyBksANqurTEy5Ru4XIwD/8AG1p98b1+jEHpim2NLpKX+ovUnMpBpGj0QCe2tJ+ZJKohjDXmWRa/AFyOWHuo
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(39860400002)(366004)(346002)(396003)(7416002)(4744005)(5660300002)(2906002)(6916009)(36756003)(478600001)(6486002)(316002)(54906003)(8936002)(31686004)(66946007)(53546011)(38100700002)(86362001)(26005)(31696002)(6506007)(2616005)(6512007)(8676002)(66476007)(4326008)(66556008)(41300700001)(186003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aktPbkY1KzBoS3REZVpqb0k0d3FRZi9VRy8rSWgyUHJpMVNyZTUxcENqaFFK?=
 =?utf-8?B?VG9kdWovN2NvanNmT0Q1R0hGVDVndWVSV2pmNmU5NEdlOThRWlpqbmJ6STZj?=
 =?utf-8?B?Qm8yeEU3MDVseDBDSHMyOE93c1B4bDQyYUFyanJuQnAwOTNEckdnbis5VCsy?=
 =?utf-8?B?WTdDdzlJLytJdUd2cDNEdlBFK2ZKazc3YTlUT1BhS0w3bllBanVaa1FrNWQ1?=
 =?utf-8?B?WjI2Mk5nVnN3Y0hqZzMydmVlM1lub3VUUUxNa2JaalJaQ1FNcXF5SUtuMVhr?=
 =?utf-8?B?cmZSMm8waHZTQ3FYTWRNOHNhU0J4THJJYWpuUFV4bFRYMWx5c3l6OEFhR0Jx?=
 =?utf-8?B?UXdxbFhNMGhJREhoSi9nUVRWSnppV1lwa3d1TnBKYUdIMU56SUFmQjhTem9K?=
 =?utf-8?B?OExVTHhaMktEMUZKV2Q4STVyK0s0OUZNWFZOc3BzTjg5RllpaklIcjB4cTY0?=
 =?utf-8?B?ekx4YkczMm8wZWgzWlBUQk5RREYva0QwR1dicGo1UVNYNWJ3MGIvaGhaanFG?=
 =?utf-8?B?SzV1Y1kvNjNuamR2TTdkZ2ZCV0M0QWVXWitGSHVMUXZxY2FySlZDa3RiTVhk?=
 =?utf-8?B?cUY4Sjl2ME83ZXJxT3VRTHpIMldkWUtVTXAvclVFaHBrQlovTXpQZUtvNHFJ?=
 =?utf-8?B?M2JmVFZOY1Y4UmtBVmtVMHJ2TW5xbVNCVVkzRXkycVhKQ21iakJSVUI0YW11?=
 =?utf-8?B?MTluZTVwdFloWlhPd1A3RDFQY2RDeHROOFNmdGEzV2hybEVhazRNL2FIQlpR?=
 =?utf-8?B?dW1NNE4yY29RaVNHbHZzSjVKd0lTZHAyVzdjZExmZjd2K1RLU2hqQ1hwY1h5?=
 =?utf-8?B?OFFDcTVEb2tLejQvd1JKL2FCMFpMK2I4L0pIb3A4SW1hWXdKR1c3c1VnaFpC?=
 =?utf-8?B?TmszNzh6bkVLK0V2WTdSQTBJUW13STlndWxXN1BMNjVMWVlHS2lmVndNWnpu?=
 =?utf-8?B?NFVnUCtOZm5Mek5QZ0hIYy9DdXFSTm1TNDRrWENMUnRnelFjZDlILzFSSFR0?=
 =?utf-8?B?cTdPeXJ5eDZHQlZSUDNnUm53akFIcDdhYkpZdW9QdGhlWk9rcGkwdUhBZGlS?=
 =?utf-8?B?SjNpdlpoMk5sMko0eFo0UldqQ2ljYzl3Q2F0NElrV05vSmFWRGtjM05zeUVB?=
 =?utf-8?B?OHROS0lmenVsL3E3K3ZLTGhIU0JubnZxMjBHRmJwNjFmQjFZM3FTMEFFc214?=
 =?utf-8?B?Q2o1V3RmMXJyVlFXVk03aTdMU2tzYVR3TVdMck80dFVIVzA2Y3dwYzRCbi9O?=
 =?utf-8?B?SGhjeDI5VkFwZXlEZGh2bVZ1QU16TUg3NmJ3MFpqdDRUZFFJYlRqdGVEMDdK?=
 =?utf-8?B?ZDJJTWFLNXFQZzZiS1V0cmVhN1RNRDROSkFrVGRuNzlxeVZIZnFiM0w0UFpS?=
 =?utf-8?B?QTB3cmtoUzlvZ29yNTFTK3QzWE8yMWZGTXA1ZmdSSlJDSVBZY3cyQnpLcC9j?=
 =?utf-8?B?RVBGa0FGQjVUczlWZ0lHNGZVTyt3UWp5Rm9VUnZqQ3VySnBRbjdnOUpqbDJK?=
 =?utf-8?B?UG5sV01SdFR3aEtqaU9CcXZ2M0x4RmR0dDFsYWszZE1ndHF3WEFZajJ3d2JL?=
 =?utf-8?B?a2lCMStrY2FHcHRCV3FxbjVmVk01cHZkaG9aYldVY0ZadmJvL2owblRLd3h3?=
 =?utf-8?B?SnVBdjd0UnBrMkdZVlN3SzFrRjFGclVnc0QyTXFKNmNDNXFoNUVYanBhSlMx?=
 =?utf-8?B?SVhRanBHQXArTTN3dDBPeGp3VWRtNDVWQytCdHIrT3dUQngvMUV2ZlYzZHd6?=
 =?utf-8?B?OFdYTk1KdTVzZlA0bzdRcVNSUW5JR243UnJDNzVwOC9SR0RQZUV6TE1YQzNY?=
 =?utf-8?B?c3NPWFY3YWRUTlRndGJRSGhBZE4vc2hrWDRVbVZYbm9zMG9kTXlpRVJ2eDFP?=
 =?utf-8?B?SlF2Zk9GUjcyVlRsRVl0bDZ2bDlaMDZuOTY4T200MDhYMzFYVEtsbGoyZXpH?=
 =?utf-8?B?bFFSdzdtU3h1ckZnRDJZdjcvdTlFaHk1RzFUbDh2UExpZzRVOVkrS3V6TUt1?=
 =?utf-8?B?VVR2c1g2QkR0VVZOWTRrOWxsV1k4Z2tzS3pEVFEwMlV5QTkrQTdYZlFKMzRQ?=
 =?utf-8?B?OFEwSml5dHFvRGd6bS9KMGtKL1E1SUl3VURmMG1zdU1PNU9Wa3RJa29yYmRh?=
 =?utf-8?B?eFA4cEVKcWlqbFJvRGJMQlNsY1Z3N3BEYVF5WW5KTnQ4NW43TmlsQytQSVBT?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11161ea3-7bd3-41b2-fff0-08da7a22be6d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 16:18:07.0578 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBs1tYkJT1/3gwl3bN5NNtnwR2zDT7wdkEwnWTXRymxiVpIne35C+OdPs20YZ6GFfDyhigWnK02NygA+h3exTSS3Jb30lDsFwW+dp36+Byg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090067
X-Proofpoint-ORIG-GUID: gmno0zMYmuXow5UhkRZzJDsimkFxuPne
X-Proofpoint-GUID: gmno0zMYmuXow5UhkRZzJDsimkFxuPne
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 09/20] nvme: Add helper to execute
 Reservation Report
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/9/22 5:55 AM, Chaitanya Kulkarni wrote:
> On 8/8/22 17:04, Mike Christie wrote:
>> This adds a helper to execute the Reservation Report. The next patches
>> will then convert call it and convert that info to read_keys and
>> read_reservation.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/nvme/host/core.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
> 
> from the comments I've received in the past, please add a function
> in the patch where it is actually using it.
> 

For your comment and Christoph's comment I'll merge patch 8 - 11 together
so the helpers and users are together.


> Also, please consider if we can move pr code into its separate file
> if others are okay with it as host/core.c file is getting bigger.
> 

Ok.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

