Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26218C2B9F7
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3DDB61417
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3DDB61417
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-NwPK80AJO_yHRhsWcACruA-1; Wed, 26 May 2021 07:00:33 -0400
X-MC-Unique: NwPK80AJO_yHRhsWcACruA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4602D6D4E6;
	Wed, 26 May 2021 11:00:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12DC363BAF;
	Wed, 26 May 2021 11:00:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0CFD55354;
	Wed, 26 May 2021 11:00:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PKWLgC031604 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 16:32:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DD6E820FD559; Tue, 25 May 2021 20:32:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7E7420FD555
	for <dm-devel@redhat.com>; Tue, 25 May 2021 20:32:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9B9F10334B1
	for <dm-devel@redhat.com>; Tue, 25 May 2021 20:32:18 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-536-U1PfcyD-OsSNhNgZk9xuRg-1; Tue, 25 May 2021 16:32:15 -0400
X-MC-Unique: U1PfcyD-OsSNhNgZk9xuRg-1
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ5T7L179008; Tue, 25 May 2021 19:09:43 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 38q3q8xgf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:09:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ5Hg6009101; Tue, 25 May 2021 19:09:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by userp3030.oracle.com with ESMTP id 38pq2ugqps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:09:43 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Tue, 25 May 2021 19:09:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:09:41 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-4-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <a37cee38-7c61-fca8-11d7-1949a5681bfb@oracle.com>
Date: Tue, 25 May 2021 14:09:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-4-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA9PR13CA0018.namprd13.prod.outlook.com
	(2603:10b6:806:21::23) To SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SA9PR13CA0018.namprd13.prod.outlook.com (2603:10b6:806:21::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12
	via Frontend Transport; Tue, 25 May 2021 19:09:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63963789-5520-4228-f59e-08d91fb0a60e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4793394F4DAA811A61FEDCFFE6259@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: XBrInK3pc5DNIAXrT8ZJ86e9PICL8pvzNGcAGvym2DhFhUJv/CUyyGKXWPKCrG8BMEO1aLV0qUJY2lwzae/9tZanpmA7/nlaE+ECRb/QifWr4x5nuN5enfGQ88MUyhgeIz0Lb1zZ0bsPB0bn3jrJwosQzPX9h88Z9DeXVt8GmH3sxP9R0BhQh8ChVKmQnSQcjEn/H3yxaZVPGCqZ2vRaAZeEa/BR+bQzmA1WT1BOwF0cxcSRKVXVVtFwprp/E6nHR43z2YvC1tqI9ISPAtofpZTs05J8Yzqz/FdIYrKkpdbwhUGvwx0r8EL+yTJQ/rWHQtM7urlbi6nilz1+grB2CBvZPoioa4bndJ54LJhLH28wDdPpHjxDF17KxNGu4lruEPlsFcRc3aInKsf7DevIngp+zK7QfnyxuE1gVcQe1rzyW42AFSuSAEBF+TP16NWGBB0/z4UgrgyzGGL6nJUqUm305e/3Ibfaku2YBPeCdytH3YevgXMF2A786Z7Oi+Aw/z222ckJPci7L/d10rn7cAwJlWwJCE3wWoLiyxRpT9eiB3FSmIgASfL03htEFm00L1VcKRNxj2lPs6n8zN+zNogchocTYTLKfvY47SyFAMELgPpoQ9R1a7TVsBSOlp83XqbyIu+2ebsx+rti0vMdl593BW8J95TmQQ9r2t5btEXjc0kDZWSDeb8jYEsjTLPOCL9gKT1zrY8PwkbJTAcTcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(38100700002)(110136005)(31686004)(66946007)(16526019)(8936002)(36756003)(8676002)(86362001)(478600001)(66556008)(66476007)(83380400001)(31696002)(6486002)(956004)(53546011)(5660300002)(26005)(44832011)(316002)(16576012)(2616005)(186003)(36916002)(2906002)(21314003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RnBsSU9pMGJ3UWRQQjlwZnQvOUx0TU5JVzFqblJJb01jVVpRQU90TkhxNVFv?=
	=?utf-8?B?dktsS2paMjBHNnJxOERFSjZUSTJ5aFV6c3FwWHhZTXdZQmV6S0NaM2JvNmdE?=
	=?utf-8?B?WllHQTJmWVZsV2gvb0dENXFsc1I3WmJ0TzJiMVNvYU1FUndYYmNFZ1FZQ3dS?=
	=?utf-8?B?NVF5N211RmVYNHU0dGVvR01oSmxydzBSOW9TaXpROEVIV0FuVk15bEhoOEZG?=
	=?utf-8?B?VzRyZHFhWkpqWGJpc2FUb0xlODhPcHZibEFtRDg0Z1JjUDY3Vm1QczBrUVNI?=
	=?utf-8?B?VENHdXdERnFsejE0TEVYQy9GT0RjakZzdi9vQ25JWGY2cHJRWnAxUEo3ZEQ3?=
	=?utf-8?B?V0l6eFdDODlwTzFmaGQ1WnIzOUZuaFlaWHIwVXZWdWYxZ29LOWZ5bXU0MzJZ?=
	=?utf-8?B?VUxncVNHY1EzMGFmV3NsMzRDMjhtTXFPcUtVYjduS2hSQWhwU0hZN2F3UFB1?=
	=?utf-8?B?RU1JNVlkVXdzNFVsWUpWN2FBZEhPbDFqSEdnNWtpcmFkR2lXclhpbGlyL3FP?=
	=?utf-8?B?VG1kd3BNTWFyRFkydGxKcngya0VodnF3VVhaUzFHZ1E5TmdEZWMxY0hITEFj?=
	=?utf-8?B?Tmp3bzVnS2VtN2pQd3d2WStHVlBYM1pRL1JQamI2VHowekl4eUJaSjFRcGFx?=
	=?utf-8?B?TGIwbkdtdzI2WWI3aHk5c1pkZkR2M2JGdXBoYU1yWVJrb09aUDUrSTY3WWhm?=
	=?utf-8?B?OVBoUDhRM21WSXdUSThnMGRxa0VzcjBWaTBER201RWFqdmMvSldWNUlUdUxk?=
	=?utf-8?B?cm9PbGoxZUNoRzJkQnVGSWtPTHZPZ1J6Z0M2TUxWbmg5ZlpCSExWWkpPSGwz?=
	=?utf-8?B?T3hDamdvNnliemVDc3JBYkNEdnB0eTEzaTgvWEl3a2RlYWRsc29MODduOHJW?=
	=?utf-8?B?ZlhWdEt5WVF3YnJhZTRhbWtUYU5oWXBFNlFnaEQ1dDVFME1ZTHBhNU1qKzZv?=
	=?utf-8?B?R3FQWWEzMEMvSXEwMlBiZ3lLcC9ZSGhtcFk3bEVJRnF1QlZDV055aVJORk5r?=
	=?utf-8?B?NVQyWGYybU14UWd4SERqU0RodkczN1dXcWFkVXdtdEx6SnRkalRTODJCTnRn?=
	=?utf-8?B?R3FjemszTnF1dUt4Szd2MWgwL2JxdkRCeVpCaGViZ25GaFVDYjU1WHhoalVt?=
	=?utf-8?B?TTBHQjlYaGRFZnhYeFBRdE1acFhpQVNnU3cwamtRbHp0MGt3ZFF0NUt2Vzlv?=
	=?utf-8?B?TFphU0JScnBGb3F3RW9FczE3Z1IyZkdidlp2NExHRzc0V3NFT0VEU2NzUU1P?=
	=?utf-8?B?OTFlR2J1aG1scGY5aWNyRHZHYnNKTHpUY3hBaGdId3QyVnZiUEJrVU5iajNt?=
	=?utf-8?B?TzNzWDlQVU93OHZRSURvYVJqS1Z1MVlWeDVvck9JWEVpVFRZK3Z1YVFyMmpt?=
	=?utf-8?B?V0VTcGw1Q29HbW5iblRvQkl1U05CRWxQenFGSXdsYzY0YkxGeXZDaXVEYVJO?=
	=?utf-8?B?WUg3RjJwdFkxRDVkQ0RBRlhlSjFTQ3EvVUlybEhkbklzWTIwcEFrdFhGS2t6?=
	=?utf-8?B?TVVKTVJkVXdIeEJTV2VBOEQ2ZE5pTyszaFVXRTRHMmIxcytONkdVYjNpQ0lK?=
	=?utf-8?B?ZWNtN0V5V3NNejNGWXZGUmg4QXdMQ1ZXQzdnb09TQnZ1MlFLYWRYZ0pDSmU0?=
	=?utf-8?B?RTJOOVpudVYrb0ZrUnNYSUlZUDV4dkowT3prQjdjWGlkZ1lSbDRDcTltOVlC?=
	=?utf-8?B?dW9LT0NKVnV1Q2Z3QzlFaW8rK09tdWdkUmNtOHFHdGxlaEROUFFOeUZwcFM2?=
	=?utf-8?Q?qfg43BxVJR6bDzR15XI2/Y4iGPeonE/8GTHBCPn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63963789-5520-4228-f59e-08d91fb0a60e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:09:41.1028 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjkOAchTC6gBxI0ij27cvRHflmvHFbtBW1VRq+dG++5SREGUhAuYFmsnj1lIiKVtA+dj1X+InXPEbKEruuF+nqqSdzBjnXWHJ7B6d2ovYxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	malwarescore=0 spamscore=0
	adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
X-Proofpoint-GUID: OvK240Mh8iQE_iD62XDab22TiKVeBxYC
X-Proofpoint-ORIG-GUID: OvK240Mh8iQE_iD62XDab22TiKVeBxYC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxscore=0 clxscore=1015
	malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
	adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 26 May 2021 06:59:53 -0400
Subject: Re: [dm-devel] [PATCH v4 03/11] block: introduce
	BIO_ZONE_WRITE_LOCKED bio flag
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 5/24/21 9:25 PM, Damien Le Moal wrote:
> Introduce the BIO flag BIO_ZONE_WRITE_LOCKED to indicate that a BIO owns
> the write lock of the zone it is targeting. This is the counterpart of
> the struct request flag RQF_ZONE_WRITE_LOCKED.
> 
> This new BIO flag is reserved for now for zone write locking control
> for device mapper targets exposing a zoned block device. Since in this
> case, the lock flag must not be propagated to the struct request that
> will be used to process the BIO, a BIO private flag is used rather than
> changing the RQF_ZONE_WRITE_LOCKED request flag into a common REQ_XXX
> flag that could be used for both BIO and request. This avoids conflicts
> down the stack with the block IO scheduler zone write locking
> (in mq-deadline).
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   include/linux/blk_types.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index db026b6ec15a..e5cf12f102a2 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -304,6 +304,7 @@ enum {
>   	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
>   	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
>   	BIO_REMAPPED,
> +	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
>   	BIO_FLAG_LAST
>   };
>   
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

