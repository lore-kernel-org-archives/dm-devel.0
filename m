Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B578C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B0ED761152
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B0ED761152
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-K8ncuE42N-eyqHf4JqGGJw-1; Thu, 14 Oct 2021 03:53:32 -0400
X-MC-Unique: K8ncuE42N-eyqHf4JqGGJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7136918D6A2E;
	Thu, 14 Oct 2021 07:53:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5585C100238C;
	Thu, 14 Oct 2021 07:53:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2438F4E9E2;
	Thu, 14 Oct 2021 07:53:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DEcwg8021141 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 10:38:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7BDEF118637F; Wed, 13 Oct 2021 14:38:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7576A1000D92
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 14:38:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BABCC106655B
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 14:38:55 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-416-E7V12MskP3ux0JkZyXAvhQ-1; Wed, 13 Oct 2021 10:38:51 -0400
X-MC-Unique: E7V12MskP3ux0JkZyXAvhQ-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19DE4vsc030833; Wed, 13 Oct 2021 14:14:06 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbucb63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 14:14:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DEBAjf123132;
	Wed, 13 Oct 2021 14:14:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
	by userp3030.oracle.com with ESMTP id 3bkyvaum8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 14:14:04 +0000
Received: from SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17)
	by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20;
	Wed, 13 Oct 2021 14:14:00 +0000
Received: from SA2PR10MB4665.namprd10.prod.outlook.com
	([fe80::c12a:cfad:520a:2c94]) by
	SA2PR10MB4665.namprd10.prod.outlook.com
	([fe80::c12a:cfad:520a:2c94%3]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 14:14:00 +0000
Message-ID: <b9fdcc41-2ec5-d628-968b-0aea1091cf9a@oracle.com>
Date: Wed, 13 Oct 2021 09:13:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-17-hch@lst.de>
From: Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <20211013051042.1065752-17-hch@lst.de>
X-ClientProxiedBy: SA9PR13CA0100.namprd13.prod.outlook.com
	(2603:10b6:806:24::15) To SA2PR10MB4665.namprd10.prod.outlook.com
	(2603:10b6:806:fb::17)
MIME-Version: 1.0
Received: from [192.168.0.162] (68.201.65.98) by
	SA9PR13CA0100.namprd13.prod.outlook.com (2603:10b6:806:24::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4
	via Frontend Transport; Wed, 13 Oct 2021 14:13:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c789bfcb-a9be-437a-6e35-08d98e53b3f6
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB44258ADAB49BE6B7C1C2B81587B79@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: GSFKs9mAIZOjozFTzNqn2LYSdfRXcOtW6xP06hxFZ+OLz44tu5eGd56IOMqImxAE35p8Neg8AA3VpdTtOmqgRRoEWBUjzOI1GzCIJpSVbhJN94Delybrca5Tj9Vkj/a1vpJCfQZTx9ONx+SSi0wU6LnH45D/t/SBC19QMfd2U6hNSBNxBrYn3GKBCIJSmEttyhVIWKT0zkkCd7ibjUPSH5HFUtP8mtvu5nG9zNU9/IpqEWvE8NiA6Yg7xr9lb1ccXnRpDNvq/9h/ltDFENPKj/3YMGfzksIx8Tp5tFEDUKx75SOBSD34oGDpatIWciCPxVPKqh5uxXt2BKmLk9iD5xabHITJqippc32HYmA6FKphCbDHot4zBYUegeFQYZ7+1s/sMF52HX5SbVdU8GnVmthjzqSCOmt3IQHDIwXcrciowT6b1j/zPsX2YMBHOhj7yr0bWHqBgoWdwB2he/b5Ro1cXAtDyo5B29K+lp0QwDqFcJ8bDB6VEAVObV1OouD9Q4KTk1yK15E5E0c2/532svQxNP0sOMPQoWEHy0yDDnnW/qCKZ3O5wR4I3hgKqE3m1TOs8pOOeIPng8gz3X9I5/H/zEjaXHJcmKapvAd26DYy5MrpSvXb1KBwDrPGLGrhTI6orLgWJWuGTz1pxqVjr771mcCYLwOWe5ZaK++Tiw14Inv/G8vDhEhEMzYKy+up/iApY8iCFuqejrgEkSLkzrJKH9Eo47OeP+l97eQBy+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SA2PR10MB4665.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(186003)(8936002)(956004)(38100700002)(5660300002)(2616005)(2906002)(66946007)(508600001)(66556008)(66476007)(31696002)(110136005)(31686004)(26005)(36756003)(54906003)(6486002)(86362001)(16576012)(7406005)(8676002)(316002)(7416002)(44832011)(83380400001)(4326008)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVEzdEVTUXJEV2hEVDZYNjQ0YXBVSEJiQ1pYZDNGVnR0cnk4NmtaODAzOXgw?=
	=?utf-8?B?Vmx0Y0ZKV2xJbHllOHFYdzZSM2Q0akc4ZmZxa25mc09URWtrKzRyeEROSEpa?=
	=?utf-8?B?TFNZTnU1VEhyTlNNUEUreDhQZ1g1UHl3N1UrMlBvTitkNEhPMlRZbFRJek9i?=
	=?utf-8?B?SHFMT3o3T0RrSWM3MUVLSWRleEF2RGpsWlhEbUVldi90RTlONzVRdlJYK2hr?=
	=?utf-8?B?L3hiYjlLUzQ3OHNwVnZLTjNLdXUxR3I1Q1ZQRlJHeWJUMUdybytEWGRuU3Zx?=
	=?utf-8?B?bWxOdFFIN3M2K1QrYkFzdk5PbGRadDQxRE5JTy81RTVpaEY2OE4wVjFIMjJM?=
	=?utf-8?B?dG1Jb0xNOGRMcFIrNUVMaW4zREMwOTRPWU56YjNGY2NvM3FrS2JzbTZwYk4w?=
	=?utf-8?B?ZlFCSTZ4Z043TG8yNGE3WGhqanhmZ3Rqb2hYbk9rUk1Dd2hWMmhic2owbVdk?=
	=?utf-8?B?UCtFUENxbWdYS3hPY01rOXhHamZ5b0Q3Nm93NkRDUDZyOXF6VFJhVkxFNHZX?=
	=?utf-8?B?c1hZM2VSbm9DNmY4NUlRc1hiWGFrUkF3OXVWNmhmRy9ZNGpoQkM2THhOeXNS?=
	=?utf-8?B?M3phcmUwQ1A0cWNnUzBzcXhNd1RFaFl1aWo1THZVTDdEK3ZhTDR3b1dOSDlD?=
	=?utf-8?B?cnJpTDZseHJIbDlXdVE3QllnQzdBdzF3N1REcWZTL0ZrcktKUnZsVzBuSmxv?=
	=?utf-8?B?V1g1emdwZXd0WUZGWXdZS25HTjdoamMxYUFMWWNBQmtTRGQrSmU1UCtnTWNB?=
	=?utf-8?B?TUNGWk9STjVBVk1yemRsS2YwMzMwOVlqOVMzSmNzSVhhcmlsa1pLQ1RjcDA2?=
	=?utf-8?B?OTNRb3JybVpWOVl3NThnSC8xQnNjRXc4cFptWDVGUDFDc0pTcHZNYlVjOGxU?=
	=?utf-8?B?ck11YWk4YU1uaEtuYzhhWU9uTWlGNHNJK2NCbUdRNHRkekwxek9RQ2pzTXZk?=
	=?utf-8?B?ZVZVbzh1eXJPQUhBNno5Y3daaTRtdVYvTFNaUklTU1ZtOEFNMXM5Ty80UkFM?=
	=?utf-8?B?b3ZVZmhLbk5vSlV1Uy84Y1lZdGlnL2hDRGhpRFJmbitrRzduWjJUZXhsVWx2?=
	=?utf-8?B?WXVZYnN6UUFvSk9DemtjM0w2Vk9WdUZUVDlxRktjNkQ3cnVTekFoMExZRFJR?=
	=?utf-8?B?VmhwbkYrUXZqNGI0MDE1Mm9COGtmZ1FHNnJxU0lLbkZ4MzljNklDK0FUaEk3?=
	=?utf-8?B?TWpTdWE5dHRtOWNNNy9yMjZ6cVVDbnpSb0JlY3M4Y1RkWW42NlRWR0E1SjFa?=
	=?utf-8?B?RVZ4cFRVWTl6cWZpb0tYVjJ4eE5nbjB6cFVVYlpacy9saVFQbWx3YzlqRzc2?=
	=?utf-8?B?OE5lQ292eGw0dVJYd0lnVFU0dXdiUDJLc1ptd05ESmZMT2trYWxFM1BEREdE?=
	=?utf-8?B?Y2htQTZTeUs1cG9LZVBIdEVkSDdFZE1BNTVkSW1IV01lQU5GRGNBenlwU2Zk?=
	=?utf-8?B?ZWdVTHVyeitybVU2QlhFVC83SVZLMEZmampOclNtSlYwYmlGYkNuY2dXMWZZ?=
	=?utf-8?B?YTZtRVlJK2JIOVVzK2VVRkd2Qll4U0NjNW1LTnYzNlc2UEVKb0R4dmlSRE4w?=
	=?utf-8?B?OW50dGpQRkFSblJ4eHlhdGNnOW9uUUx4UnZwb2VKdGRHelJ5T2NUbU5XWXU1?=
	=?utf-8?B?enU3WVR5dEl3SnpNSE0yZUxHQ200MmMzdCtaQU9Da1A1SHpad09zWHV5a2Vm?=
	=?utf-8?B?L2lDdlpiZEl5dFo0QkgzUEs1OUxib0pvME1HZDNtVDFkbTBOb1BqTHhxZW1K?=
	=?utf-8?Q?VI18e6RseJEkIpxqv3v/kKFWYkcbHH6XLkDS6+k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c789bfcb-a9be-437a-6e35-08d98e53b3f6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4665.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:14:00.4497 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oemYySOM6+n6GAH7CbntjzwlNKDkc12H/mzkMjBkvra40/0815D1QHXR/U9EynaUM+/M9IZZ45v4wMQn/VgiOjVw6FnCGu0r2AZR6uDQweo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 bulkscore=0
	malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110130097
X-Proofpoint-ORIG-GUID: Cxu06FmlAK2C1-boAQ76mTgZwMKZZ5Ud
X-Proofpoint-GUID: Cxu06FmlAK2C1-boAQ76mTgZwMKZZ5Ud
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
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: jfs-discussion@lists.sourceforge.net, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com,
	linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 16/29] jfs: use bdev_nr_sectors instead of
	open coding it
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/13/21 12:10AM, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>   fs/jfs/resize.c | 2 +-
>   fs/jfs/super.c  | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
> index bde787c354fcc..51a8b22e71030 100644
> --- a/fs/jfs/resize.c
> +++ b/fs/jfs/resize.c
> @@ -199,7 +199,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>   	txQuiesce(sb);
>   
>   	/* Reset size of direct inode */
> -	sbi->direct_inode->i_size =  i_size_read(sb->s_bdev->bd_inode);
> +	sbi->direct_inode->i_size = bdev_nr_sectors(sb->s_bdev) << SECTOR_SHIFT;
>   
>   	if (sbi->mntflag & JFS_INLINELOG) {
>   		/*
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 9030aeaf0f886..992870160903d 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -551,7 +551,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>   		ret = -ENOMEM;
>   		goto out_unload;
>   	}
> -	inode->i_size = i_size_read(sb->s_bdev->bd_inode);
> +	inode->i_size = bdev_nr_sectors(sb->s_bdev) << SECTOR_SHIFT;
>   	inode->i_mapping->a_ops = &jfs_metapage_aops;
>   	inode_fake_hash(inode);
>   	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

