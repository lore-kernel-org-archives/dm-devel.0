Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B972AC2B9F7
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DDF86109E
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DDF86109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-lcOrfMdiMT-KCa_rHgn1_A-1; Wed, 26 May 2021 07:00:25 -0400
X-MC-Unique: lcOrfMdiMT-KCa_rHgn1_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 813DE8042AA;
	Wed, 26 May 2021 11:00:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 186E15E27F;
	Wed, 26 May 2021 11:00:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5B0855351;
	Wed, 26 May 2021 11:00:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PJHRnJ023812 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 15:17:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 512C41033C67; Tue, 25 May 2021 19:17:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B83E1033C64
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:17:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 573C618E0920
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:17:24 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-330-vA89HDHXNT69PXnxpvfU3Q-1; Tue, 25 May 2021 15:17:19 -0400
X-MC-Unique: vA89HDHXNT69PXnxpvfU3Q-1
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJFf9h146637; Tue, 25 May 2021 19:17:16 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38ptkp70qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:17:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJGEsA125357; Tue, 25 May 2021 19:17:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
	by userp3020.oracle.com with ESMTP id 38qbqshrbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:17:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SN6PR10MB2768.namprd10.prod.outlook.com (2603:10b6:805:4a::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Tue, 25 May 2021 19:17:14 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:17:14 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-10-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <ce4477cb-64b9-27e2-6f6c-3204fac8ed24@oracle.com>
Date: Tue, 25 May 2021 14:17:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-10-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN7PR04CA0080.namprd04.prod.outlook.com
	(2603:10b6:806:121::25) To SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SN7PR04CA0080.namprd04.prod.outlook.com (2603:10b6:806:121::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23
	via Frontend Transport; Tue, 25 May 2021 19:17:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26a4611-d332-48a6-f566-08d91fb1b3ea
X-MS-TrafficTypeDiagnostic: SN6PR10MB2768:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2768E4C546132CB2DBF3003BE6259@SN6PR10MB2768.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ZPeuy5K6rn80wnxQlD7bk7XYFXCSsgbAXerlt+fRatLNq7n8uR9tEAUNwLD4AM/4PZ2uWjKHEtI8svrCRzk/6hYC+n4qwgdUY+owOKdR2gcLr/ZaeIO7v6nJIa2OgXm6XlOokubou23Pyh7jBNzCWXU35/+cj1KC0PxGJYTRQ6zyY+KwZ+YmhAhF/5zaTGKD5YGuP9qLvltF536I1QoMLEG5WfE/87B0kF2xW6E/vHzMitBbDWR6EA+tyUnv4ALvsSmVxDb/Z2HW+Y0vMaYVwXnS55sLLI1+yuFvb9nSt5mFrBhT4wORCEMwJYCW60G/w/PT7TuExTczkv5esSisqLzQ+kb/XIDNAwVD/+yWMYy+T+91tb4X1IzXS3P5TtOw2dK6T08RZIVbhk4cRrHzuzu6CJaiaf8oiysIw27ol1BUoh/iroGRULk9eVtYPH9sn1ZhaDpPu8Osf9glzZj02R/O6NDZpGHXEnDhYmP62mBZbnPeSclXHFke4GdJkhHWHLhaFpVaOwnNWGRfNFxf+yxsdbnoObKMKm/5pkuaXHqVEb3P334nZ4M/JnOXNsGdKrGhnY3ZMzUmiNQJ8VqGZZ0Vf+Zc+aqgI+gZrAF7yhWPi3flMy6tpIzOANNH93WybrPpHW3yHAgaheBdFUEs+GOQBTHjY+qNRDTtLKWXiZm0LBQkCz6kF96dhss1lW2T
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(366004)(39860400002)(376002)(346002)(26005)(956004)(44832011)(2906002)(31696002)(16526019)(478600001)(8936002)(6486002)(186003)(2616005)(110136005)(36756003)(66476007)(31686004)(5660300002)(66556008)(83380400001)(66946007)(38100700002)(36916002)(86362001)(16576012)(316002)(8676002)(53546011)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MjF3RU4xNURpR2VLTXd6aEl6NnkvMkVRR2Z5L1BqK2RVYzdUbDI3Y0hmbzBX?=
	=?utf-8?B?OFowOGZUbzVoOFNFOU9OQ2ZUOVdoTVFxajY5WTVNWmt1MEF6T0dUR01reFkw?=
	=?utf-8?B?VVVDMWgzcytNUXdsU09qbDRhYVJRYlM5Y2lDZlhNM0NHT1VwenJXUXJqTmVZ?=
	=?utf-8?B?a21XUVhzUnZyaGp6OU96VUx2WHp3ekxNV0dmbEM2NW9ISEhnWEE4TksxUmFE?=
	=?utf-8?B?UHI5TDRLNWNrY0FEbTZZalplamZXWng2Y1dLYkYyd3NzRE1hNVRUbXdJQXBs?=
	=?utf-8?B?dzR1c2VZcEZFSmZPV3ZqN21UTWIyWk1oUVVET3B6RmpLY2hCcStoRWQ3cnV6?=
	=?utf-8?B?cEZjelhtVm45WmZRWVpaNW91eW1Da21EcnJmK1NKdDdFV0pKMmdMdUsxMmJ1?=
	=?utf-8?B?WmVsdWpVOXhHbFljREdHakdrcjhzVlhHVjNuSzhGWndacDV0SlFYb2NVR0VE?=
	=?utf-8?B?RmJ0VEY1bzE1MnAzTkJiTkIzWHBwc05sbVB2VlhaZDdvQjIwZmpJanNtV0hr?=
	=?utf-8?B?M1pFUnVzOVhHZTB3TzluZUNseEdtUWZMelNPSHZ4cDJIY3NLam54ajUxWlcr?=
	=?utf-8?B?eUk0bGt3VnErUXlIREJXYU5tMWRGSU1XbngrZEx1V3dNRFZiRUJ6d01KTjVx?=
	=?utf-8?B?cTJWbU1ndDB1RWtEazlCbmpTL29QbUoyS2s2TFEwZ0JOUm5hbDZVbVZrVzcv?=
	=?utf-8?B?QklHSUJ6M0lGT3hJdnZQUGNqS0s1dE1FSmxWcE42bG92NnQ2ZlkveFpZN0xV?=
	=?utf-8?B?anZyemFDTWdTQ2p1dm9lKy9IYlRETDlYZGIxT09VaFg2eHB0UGd3TS9jK21Y?=
	=?utf-8?B?V0tkSzRPZ1dZaExwSExYR3pjQWxPdHhCTDhsQi9NdzRlTFBBUTUvK1locXVJ?=
	=?utf-8?B?L2xhK3I4RDd1MG1iVE1Neit0RWpSQ0dVcmxCdlpiM3dZMEhTQVhsYlB4Uk9y?=
	=?utf-8?B?RktmZHYzbGNjRmlHV3BFWVJ6VFQ5S2VsNzFudVl4RnBSZ1VyaTJHOHZnQnNz?=
	=?utf-8?B?L0pRNThGcElHcjYvdVhmbEZXZldzQ0JIWjdtaHJpQm9UVWpXOEp4VlEwaU5j?=
	=?utf-8?B?Y1BPTnVOaW9zNkxyeTZ1WS9VejJjajgwelpjekpXNStFbXVhQjNBU1ZjMmNZ?=
	=?utf-8?B?ZkFEclRkRm42R2NmeHdycTZmVDlGKyt2VzkyR1NmQ3VEWWlubWJqVTVxZGdv?=
	=?utf-8?B?YUVTOUJuUVBqdmJ2NDcxTTBBQkRBQUZxMGdCYUx0UDhZeGFBYmlhZXRSQ1Jq?=
	=?utf-8?B?dXF6WE1iYXBpVnAxc1duZnBVa3JnUjVuV0M5M1pPbHVjbWMrVG9aS0kraFZh?=
	=?utf-8?B?anRZWFRydG1iTUxGQmFTVkx5clhYVUNoSDJRbVlxN0hYN0RhWlFEbDY1aEh2?=
	=?utf-8?B?dW94S1lUYXd0cGJDSHk2bmxtVmZFOGNySjhlNkRRQitlRnpQN0RTV3pFTitP?=
	=?utf-8?B?VDdFYUk5SEF3V3JlYTFEYXUxUDIxdWw3MXFqWjhIN0hXWmFCOTJ1VEViK2xC?=
	=?utf-8?B?ZHhnVzBkelVpckFITVg3NnlNR2FvZTBaSGVDYjVVMlp6S3RxTTBLWDF0MVI2?=
	=?utf-8?B?TWpUNElUenE4bUd6YlFMdUJWajBzbzJUSEFScE8yTTZQYjVCaHV5NVZQOXo5?=
	=?utf-8?B?QmYyMWFGUXVaWCtEQ204SzZObk4rSURaTDZOVnlWT1pUMXhaeFc4c2d1dFpM?=
	=?utf-8?B?WHFwZklkc0hwQTliNU15eWxJTXVleCt0TVU1NHJ4UkZDZ2FZMTNHbkZtVVVq?=
	=?utf-8?Q?8KrX3X5zZ/q2pEN92D/ReqxNJvQTnCsFedEEERy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26a4611-d332-48a6-f566-08d91fb1b3ea
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:17:13.8947 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlFRQl3S1V5CJmnCC8jPFtGACzracn4RgESKy0/Z0oESIZo9rgE0bzluf/Glsqkfd78cH74cBut/TjeBCm+fbvGmIYZkuDK9SHoB9SP4HOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2768
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 bulkscore=0
	mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250118
X-Proofpoint-GUID: pwnjXsAZZJFXtGQ8cXWscZ7ldAVMgRxr
X-Proofpoint-ORIG-GUID: pwnjXsAZZJFXtGQ8cXWscZ7ldAVMgRxr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
	mlxscore=0
	suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
	malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
	priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250118
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 26 May 2021 06:59:53 -0400
Subject: Re: [dm-devel] [PATCH v4 09/11] dm: rearrange core declarations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 5/24/21 9:25 PM, Damien Le Moal wrote:
> Move the definitions of struct dm_target_io, struct dm_io and of the
> bits of the flags field of struct mapped_device from dm.c to dm-core.h
> to make them usable from dm-zone.c.
> For the same reason, declare dec_pending() in dm-core.h after renaming
> it to dm_io_dec_pending(). And for symmetry of the function names,
> introduce the inline helper dm_io_inc_pending() instead of directly
> using atomic_inc() calls.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/md/dm-core.h | 52 ++++++++++++++++++++++++++++++++++++++
>   drivers/md/dm.c      | 59 ++++++--------------------------------------
>   2 files changed, 59 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 5953ff2bd260..cfabc1c91f9f 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -116,6 +116,19 @@ struct mapped_device {
>   	struct srcu_struct io_barrier;
>   };
>   
> +/*
> + * Bits for the flags field of struct mapped_device.
> + */
> +#define DMF_BLOCK_IO_FOR_SUSPEND 0
> +#define DMF_SUSPENDED 1
> +#define DMF_FROZEN 2
> +#define DMF_FREEING 3
> +#define DMF_DELETING 4
> +#define DMF_NOFLUSH_SUSPENDING 5
> +#define DMF_DEFERRED_REMOVE 6
> +#define DMF_SUSPENDED_INTERNALLY 7
> +#define DMF_POST_SUSPENDING 8
> +
>   void disable_discard(struct mapped_device *md);
>   void disable_write_same(struct mapped_device *md);
>   void disable_write_zeroes(struct mapped_device *md);
> @@ -173,6 +186,45 @@ struct dm_table {
>   #endif
>   };
>   
> +/*
> + * One of these is allocated per clone bio.
> + */
> +#define DM_TIO_MAGIC 7282014
> +struct dm_target_io {
> +	unsigned int magic;
> +	struct dm_io *io;
> +	struct dm_target *ti;
> +	unsigned int target_bio_nr;
> +	unsigned int *len_ptr;
> +	bool inside_dm_io;
> +	struct bio clone;
> +};
> +
> +/*
> + * One of these is allocated per original bio.
> + * It contains the first clone used for that original.
> + */
> +#define DM_IO_MAGIC 5191977
> +struct dm_io {
> +	unsigned int magic;
> +	struct mapped_device *md;
> +	blk_status_t status;
> +	atomic_t io_count;
> +	struct bio *orig_bio;
> +	unsigned long start_time;
> +	spinlock_t endio_lock;
> +	struct dm_stats_aux stats_aux;
> +	/* last member of dm_target_io is 'struct bio' */
> +	struct dm_target_io tio;
> +};
> +
> +static inline void dm_io_inc_pending(struct dm_io *io)
> +{
> +	atomic_inc(&io->io_count);
> +}
> +
> +void dm_io_dec_pending(struct dm_io *io, blk_status_t error);
> +
>   static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
>   {
>   	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4426019a89cc..563504163b74 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -74,38 +74,6 @@ struct clone_info {
>   	unsigned sector_count;
>   };
>   
> -/*
> - * One of these is allocated per clone bio.
> - */
> -#define DM_TIO_MAGIC 7282014
> -struct dm_target_io {
> -	unsigned magic;
> -	struct dm_io *io;
> -	struct dm_target *ti;
> -	unsigned target_bio_nr;
> -	unsigned *len_ptr;
> -	bool inside_dm_io;
> -	struct bio clone;
> -};
> -
> -/*
> - * One of these is allocated per original bio.
> - * It contains the first clone used for that original.
> - */
> -#define DM_IO_MAGIC 5191977
> -struct dm_io {
> -	unsigned magic;
> -	struct mapped_device *md;
> -	blk_status_t status;
> -	atomic_t io_count;
> -	struct bio *orig_bio;
> -	unsigned long start_time;
> -	spinlock_t endio_lock;
> -	struct dm_stats_aux stats_aux;
> -	/* last member of dm_target_io is 'struct bio' */
> -	struct dm_target_io tio;
> -};
> -
>   #define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
>   #define DM_IO_BIO_OFFSET \
>   	(offsetof(struct dm_target_io, clone) + offsetof(struct dm_io, tio))
> @@ -137,19 +105,6 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_nr);
>   
>   #define MINOR_ALLOCED ((void *)-1)
>   
> -/*
> - * Bits for the md->flags field.
> - */
> -#define DMF_BLOCK_IO_FOR_SUSPEND 0
> -#define DMF_SUSPENDED 1
> -#define DMF_FROZEN 2
> -#define DMF_FREEING 3
> -#define DMF_DELETING 4
> -#define DMF_NOFLUSH_SUSPENDING 5
> -#define DMF_DEFERRED_REMOVE 6
> -#define DMF_SUSPENDED_INTERNALLY 7
> -#define DMF_POST_SUSPENDING 8
> -
>   #define DM_NUMA_NODE NUMA_NO_NODE
>   static int dm_numa_node = DM_NUMA_NODE;
>   
> @@ -825,7 +780,7 @@ static int __noflush_suspending(struct mapped_device *md)
>    * Decrements the number of outstanding ios that a bio has been
>    * cloned into, completing the original io if necc.
>    */
> -static void dec_pending(struct dm_io *io, blk_status_t error)
> +void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
>   {
>   	unsigned long flags;
>   	blk_status_t io_error;
> @@ -978,7 +933,7 @@ static void clone_endio(struct bio *bio)
>   	}
>   
>   	free_tio(tio);
> -	dec_pending(io, error);
> +	dm_io_dec_pending(io, error);
>   }
>   
>   /*
> @@ -1247,7 +1202,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>   	 * anything, the target has assumed ownership of
>   	 * this io.
>   	 */
> -	atomic_inc(&io->io_count);
> +	dm_io_inc_pending(io);
>   	sector = clone->bi_iter.bi_sector;
>   
>   	if (unlikely(swap_bios_limit(ti, clone))) {
> @@ -1273,7 +1228,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>   			up(&md->swap_bios_semaphore);
>   		}
>   		free_tio(tio);
> -		dec_pending(io, BLK_STS_IOERR);
> +		dm_io_dec_pending(io, BLK_STS_IOERR);
>   		break;
>   	case DM_MAPIO_REQUEUE:
>   		if (unlikely(swap_bios_limit(ti, clone))) {
> @@ -1281,7 +1236,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>   			up(&md->swap_bios_semaphore);
>   		}
>   		free_tio(tio);
> -		dec_pending(io, BLK_STS_DM_REQUEUE);
> +		dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
>   		break;
>   	default:
>   		DMWARN("unimplemented target map return value: %d", r);
> @@ -1570,7 +1525,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>   
>   	if (bio->bi_opf & REQ_PREFLUSH) {
>   		error = __send_empty_flush(&ci);
> -		/* dec_pending submits any data associated with flush */
> +		/* dm_io_dec_pending submits any data associated with flush */
>   	} else if (op_is_zone_mgmt(bio_op(bio))) {
>   		ci.bio = bio;
>   		ci.sector_count = 0;
> @@ -1611,7 +1566,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>   	}
>   
>   	/* drop the extra reference count */
> -	dec_pending(ci.io, errno_to_blk_status(error));
> +	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
>   	return ret;
>   }
>   
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

