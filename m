Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6E3C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16E5C610A6
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 16E5C610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-MpMARjM2OxOjalr511v82Q-1; Mon, 18 Oct 2021 03:35:11 -0400
X-MC-Unique: MpMARjM2OxOjalr511v82Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0469F9F934;
	Mon, 18 Oct 2021 07:35:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3B936911D;
	Mon, 18 Oct 2021 07:35:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D6BE1809C84;
	Mon, 18 Oct 2021 07:35:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FEILBt028873 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 10:18:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 543CE40CFD12; Fri, 15 Oct 2021 14:18:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DDF540CFD0D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 14:18:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 319F9811E8D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 14:18:21 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-195-HaaWdwDfNAuj96oTLOLmOg-1; Fri, 15 Oct 2021 10:18:19 -0400
X-MC-Unique: HaaWdwDfNAuj96oTLOLmOg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19FE6x2F007382; Fri, 15 Oct 2021 14:17:46 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bpfsys7j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Oct 2021 14:17:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19FEFN7u085970;
	Fri, 15 Oct 2021 14:17:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by userp3020.oracle.com with ESMTP id 3bkyvfsxtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Oct 2021 14:17:03 +0000
Received: from SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17)
	by SA1PR10MB5688.namprd10.prod.outlook.com (2603:10b6:806:23e::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.26;
	Fri, 15 Oct 2021 14:17:01 +0000
Received: from SA2PR10MB4665.namprd10.prod.outlook.com
	([fe80::c12a:cfad:520a:2c94]) by
	SA2PR10MB4665.namprd10.prod.outlook.com
	([fe80::c12a:cfad:520a:2c94%4]) with mapi id 15.20.4608.017;
	Fri, 15 Oct 2021 14:17:01 +0000
Message-ID: <2056d9b3-cf07-36fc-ad60-381e4a4e6d7b@oracle.com>
Date: Fri, 15 Oct 2021 09:16:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-28-hch@lst.de>
From: Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <20211015132643.1621913-28-hch@lst.de>
X-ClientProxiedBy: SA9PR13CA0057.namprd13.prod.outlook.com
	(2603:10b6:806:22::32) To SA2PR10MB4665.namprd10.prod.outlook.com
	(2603:10b6:806:fb::17)
MIME-Version: 1.0
Received: from [192.168.0.162] (68.201.65.98) by
	SA9PR13CA0057.namprd13.prod.outlook.com (2603:10b6:806:22::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10
	via Frontend Transport; Fri, 15 Oct 2021 14:16:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a68a63bc-24cc-410f-8bc4-08d98fe6746d
X-MS-TrafficTypeDiagnostic: SA1PR10MB5688:
X-Microsoft-Antispam-PRVS: <SA1PR10MB56885CB6F5EDE1A20067E35087B99@SA1PR10MB5688.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: bBokgl1OMZ93e4ybYzEg6jhEI5P7f8cPlN+bATmNuarlbwAw4+KQNMIC+jqSI7+70yPc2hu1XASftYIAzp5kaEC2s92WjCRB0dEYDW2Zffn/jLvuK5TPyHQjEaJdvj7a6LJMQVpPk/QRtHtjLOKxwuvXavs+tp7pSocYXdh6Lc0tBndyqARfMhIDMq8+QPsemopkf/PU6JfEEe0tRYYEPm6P96TSEsQkGYHN0SFkDhoz/kg7oEFVA+Ab4IE8/593oX5REcBwkZqO091yFbEWhjHUKhiKA+06AWLdaE+XuClLCCi7ZJkzBccOlkbpPoXY5YEetetfjjRDtVSLJfoJ3ivKm9IZR8wEVTexj0lPM3TeLgEm7s0nO3PuViQR4hNxMuYccGoTKyH9Al9OcN8QAiZQ+7Y21Lne0U4W8NUzUwa+B40JcgU4yXC0q+zE9b3dssRcq/2WYcbgtGYWnF/yRwtMmsQH3pJoWeRS5oY+dfV/AJJs9zY6Hcx6WuDfwaJuAyDAjktAmnGgoZ4le6Kzs4gzCgMBOf6b+GG1wkZmCqXOspuVUj3RYC0pl/ho4N67QJYR+zN7iAxplK9WUpjOHSLOvRnWub0wsnDHMJ1t/Yqse53n+zvAzikyxrfXoTcNlnRNyGXzHJvpeu2VN3OBxWCZORJtSJtQG1KcLsL6EYRmwiSHjLR7J18jq1i3ljtZh4Zbe/SQrUgquUkvptu3xtICpi7CabkoAV4/U9NPw/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SA2PR10MB4665.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66946007)(38100700002)(31696002)(44832011)(2906002)(36756003)(2616005)(16576012)(6486002)(66556008)(8936002)(66476007)(31686004)(8676002)(7416002)(5660300002)(956004)(110136005)(7406005)(26005)(316002)(54906003)(83380400001)(186003)(4326008)(508600001)(86362001)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2luS1NLaytZdTN5aEkzY0lyWitTM0ZQeE5HcEpIaytsbDJKczI0ajJrQjJV?=
	=?utf-8?B?ZG9wbThCQmxSekZ2VGZXNXY0bmdNSlB0M3BBUS9KSFE0bnZZamF2bjBsTzhx?=
	=?utf-8?B?RmkxQWxLRGluOVI0WDR4djF0RDZFWnpGTFpibTlkYUNxRHBuQXJiV093R0du?=
	=?utf-8?B?U0xrM1Vna3pSeS9lamt4Y0cyT2h5b3VUK1B0eEsxT2FIeUxDU3pLSFYvOEx4?=
	=?utf-8?B?QzhlZ010cDN4SHFzWlE0a1h1UXJMeGRmNUZFQllvSkcwbEIvMmQyeUtpNzJu?=
	=?utf-8?B?N1RLb0t6V3Rod2ovdHBPTEFlWGRlYUl1ZkJQTDRKeEVBRUdJMUFLSWxuUmFX?=
	=?utf-8?B?U21pMXhTTEpOV0JraTlBZ29PMnFBdDlNcjgzYjAvOUNkRE00emRGVVVLQnZ0?=
	=?utf-8?B?QXVaR0VPV2JTZnE1MGhyYjkyL1FGSlNqdklsTm5HeTd6L3hKV2RCaVhpL1RY?=
	=?utf-8?B?OWJGZDk2NDVTdlVmQ0lUVjcxdDg1WFFENGVZSElQdS9NWGFKVlZKbXJWMHkr?=
	=?utf-8?B?Q3g3V1NDalFySlhqc3FpeHUxME9qcHFzRmdpemFranRCUWQrbnNPa05PNlpQ?=
	=?utf-8?B?TDZnV2lVSFhRKzc0ZWxZNkNxcUpPSlNhaEZ1Wkt4YTFUM21uNWVJVmZLSnpw?=
	=?utf-8?B?b0UrY2tLQzMycloxTUxkM0ZRRmxuMGMyMHpHRVpjQjFSYkFaanpuQjJWOVFV?=
	=?utf-8?B?VHUyYmdzSjBYT1J5VC9TZHpIeENvSW9iNnAxaWg5STVUQWYyUGFtRng1aSts?=
	=?utf-8?B?VzFzSE1JdDQ0NWpMalBibkxlcGVlZ0prOGVRaWVnRlB0MkxsblVtZGdOQkhB?=
	=?utf-8?B?S1podU1OVUxqSUhPN3B1YjBOUlJWSTExSmdHUFpFOWRsR0NCeHRwd3FmK1Vh?=
	=?utf-8?B?RHhMSi9wam92emxzTWhxaGZoL0tyREJwZkF0ZnJTcjJlSlQ3S3RBQ24vRlpj?=
	=?utf-8?B?SEJHRVV5NXhMVVRoTzl0TzNmWUd4UHp5ZkExdkw1NzF0RmFLV2tVS3ppMGIr?=
	=?utf-8?B?eC9BYjhTZkI1UGR1dXRiYXYzVldqZzc4RVBybjFCdG4yVTMzVEtoaTFrQ0Rn?=
	=?utf-8?B?aEc2MVRMNmZKdFB4YXB5TmFpenBTWjVvYXBSWHkvbUY5NG5mNzRvelRySXpP?=
	=?utf-8?B?R3IwaWVENkFvL0RJaHF1dTNnSnNKemZmVGs4MHZSTWFnd3RjMXFXT1RINU84?=
	=?utf-8?B?c0lGUjdjYTBGTjRncnAyYUhhdXdjSk9nQUpDZTUzbEEvSHNPK3U2US92emJz?=
	=?utf-8?B?Unc3R2Q1Z0lCMUZadUFjTkNKRzNvRVBmSHF0TzByK1hzK1pvTW9OSVhtNzVJ?=
	=?utf-8?B?RmtCTDIvcldEZUxRVzdua3VzaGI4dWZwRkVqcTBlNGJsN0RTZGUrUjI5L3NE?=
	=?utf-8?B?K1dHL01NK3FCanFhUjJ2WXNIVk91Sk8vZ1dXdDNlK2owUGNWdDkyV0VRc0hR?=
	=?utf-8?B?VlQ0UkFqb3FzWjlCbWRpYXJ6WVNoRGFYTXFZL2JSaXRxTU56UzJ0N0RuVDBD?=
	=?utf-8?B?YWJaK1B5MjFwcDZ4NTY2bzZvT0ViVnVUVXNKY0txUUlob3RtMVJvcmErMy9l?=
	=?utf-8?B?aTlSVzNiMkVEVXprSmU1a3d2WmFZZm9reXh0Ym1BRE5mcTdnc1pMeS9hVCtm?=
	=?utf-8?B?Z0RtbzJBRlFvQTVEc2VqYTBLVkNOcENhZktNMm8xT09CVVc3R1ZENUgvY3h4?=
	=?utf-8?B?U0NFbVJGNWtWeHR3bU02alFZcFVkLzBNZzFjL1BieXY5YXJWV2NydTRnNXBF?=
	=?utf-8?Q?SL9q4IASgEJXnPU/oEClDG2+Wt1oTSdnu2zyD0G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68a63bc-24cc-410f-8bc4-08d98fe6746d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4665.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 14:17:01.1497 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCIK4X547/RT0fkwgewmVs2SS5HUYyhv/NqprpcA+dyb/QSB58dJwqI9yNN9oBbVZmFNRsl1275KtJxNIdbGLxe/cN/b9mwFUw69fl4/n1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5688
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10137
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	malwarescore=0
	adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110150088
X-Proofpoint-ORIG-GUID: yYGcjkkCYRt6EPBT5USWKbM7HCwwUtZM
X-Proofpoint-GUID: yYGcjkkCYRt6EPBT5USWKbM7HCwwUtZM
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Oct 2021 03:34:40 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 27/30] jfs: use sb_bdev_nr_blocks
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/15/21 8:26AM, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>   fs/jfs/resize.c | 3 +--
>   fs/jfs/super.c  | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
> index a42dbb0d3d28a..8b9a72ae5efa7 100644
> --- a/fs/jfs/resize.c
> +++ b/fs/jfs/resize.c
> @@ -86,8 +86,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>   		goto out;
>   	}
>   
> -	VolumeSize = i_size_read(sb->s_bdev->bd_inode) >> sb->s_blocksize_bits;
> -
> +	VolumeSize = sb_bdev_nr_blocks(sb);
>   	if (VolumeSize) {
>   		if (newLVSize > VolumeSize) {
>   			printk(KERN_WARNING "jfs_extendfs: invalid size\n");
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 9241caa161163..24cbc9946e01c 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -284,8 +284,7 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>   		}
>   		case Opt_resize_nosize:
>   		{
> -			*newLVSize = i_size_read(sb->s_bdev->bd_inode) >>
> -				sb->s_blocksize_bits;
> +			*newLVSize = sb_bdev_nr_blocks(sb);
>   			if (*newLVSize == 0)
>   				pr_err("JFS: Cannot determine volume size\n");
>   			break;
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

