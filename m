Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549AAC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 10:17:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A87F660F21
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 10:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A87F660F21
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-vTSn70nWNnqUtb-br20WQw-1; Wed, 13 Oct 2021 06:17:09 -0400
X-MC-Unique: vTSn70nWNnqUtb-br20WQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B18010A8E04;
	Wed, 13 Oct 2021 10:17:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBBC51972D;
	Wed, 13 Oct 2021 10:17:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E2814E58F;
	Wed, 13 Oct 2021 10:17:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DADvkO019281 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 06:13:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 890E140CFD13; Wed, 13 Oct 2021 10:13:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A05A40CFD10
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 10:13:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D3BB800B36
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 10:13:56 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-585-1T9mhQtoMTS0EHYGya59pw-1; Wed, 13 Oct 2021 06:13:52 -0400
X-MC-Unique: 1T9mhQtoMTS0EHYGya59pw-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19D6vs4j004215; Wed, 13 Oct 2021 07:09:07 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbu9w2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 07:09:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D70pqH004137;
	Wed, 13 Oct 2021 07:09:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
	by aserp3020.oracle.com with ESMTP id 3bmae0a78c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 07:09:06 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
	by MN2PR10MB3789.namprd10.prod.outlook.com (2603:10b6:208:181::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25;
	Wed, 13 Oct 2021 07:09:03 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
	([fe80::49a5:5188:b83d:b6c9]) by
	MN2PR10MB4128.namprd10.prod.outlook.com
	([fe80::49a5:5188:b83d:b6c9%8]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 07:09:03 +0000
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-12-hch@lst.de>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <91d3eb0f-95a6-a528-9445-da5b32b69cba@oracle.com>
Date: Wed, 13 Oct 2021 15:08:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
In-Reply-To: <20211013051042.1065752-12-hch@lst.de>
X-ClientProxiedBy: SG2PR06CA0251.apcprd06.prod.outlook.com
	(2603:1096:4:ac::35) To MN2PR10MB4128.namprd10.prod.outlook.com
	(2603:10b6:208:1d2::24)
MIME-Version: 1.0
Received: from [192.168.10.100] (39.109.140.76) by
	SG2PR06CA0251.apcprd06.prod.outlook.com (2603:1096:4:ac::35)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15
	via Frontend Transport; Wed, 13 Oct 2021 07:08:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45d86e71-5291-4107-4b44-08d98e185671
X-MS-TrafficTypeDiagnostic: MN2PR10MB3789:
X-Microsoft-Antispam-PRVS: <MN2PR10MB37895D95B63A476486572068E5B79@MN2PR10MB3789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 0Trb+NRjs/D0qyKzzv/uIXYgF3w7kigFeXnDi+Js74czxJhJYLHXYGWYQ3jnVp7bXqXfIgoP2Vohy0trgB7n2dQcNJ6/Gp+DurAvFehcRzQktmw+HHE9ave/dnKDUr16sR1Nb0N0/HRka0aPRua6wZrHHD9M2HfjHhsqM77eMs0hqoag4VAr3TfkDckTkCosd2pTg+8phQY9gcUp5ACiElfrGI32FX74k/w+fsxHY7f5Yb+tht2POTRts20BmHkhitkT7Ky0xWkVnxbqa1hSvSAk2tLxr7fP8KeSSZP90iDm87eUlVFWiLkTKdhyHJakNTqt3kwQcUgdUKwbfwBAn48CLf57acz+Lbed3Ikcm9Zt3WEWKCybUv7MfLd8KdGY+R4ZcXn1lzRfvmRYdag/t1oi4hcU21N1AHp8dn1iHT2D7D4Xzgbk8WdFY/7Jc6n5G59f1eZk9YtY2NKp8pPYcUy/0kKi8Fcd7LMd/xySrqQW+ukKB9FWe4vOR+qdMucpZc60QshczZ8LxuolresC5pgbIyq8GHERdiiy0pZaEt3FnC3lf1eLlvqYu5u+IhrH/0GHJ6zT7jLxBqQW3mR0Yh/ZR0Q2leg1UwArVApXQH8vIpmgz99G0pwhPb8NKCI1Xcd2VhzsYkkXekmSUtcnU3p0I/DXW4MaWmIBjOX5fueDhRp2sZ+smciETjQGnCQLCiqCze5qjieSDPtvMZDg6oECPLhH2aZjcPeLlENgtaU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MN2PR10MB4128.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(53546011)(26005)(8676002)(7406005)(31686004)(186003)(508600001)(7416002)(6486002)(66946007)(66556008)(558084003)(44832011)(38100700002)(83380400001)(66476007)(31696002)(8936002)(2906002)(54906003)(36756003)(110136005)(956004)(2616005)(6666004)(86362001)(4326008)(16576012)(316002)(5660300002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SS9nVGh1TGRMT3NPQTduWDNVeGg4WmNTeTVZekhRdFdRU1pzZ2RpTE1jWFpD?=
	=?utf-8?B?WXZleGx2OHJseldraEpzWEVVWlRkWEZMY0J3N3JFcDJWWHozZzVQRVpValM0?=
	=?utf-8?B?TmhGTWEvOEZlTHFwMExCVzBVb2swQnY1aGo5TFd2WkpCSzhCUjV6b0U3d3Vh?=
	=?utf-8?B?dFFSM3VvdVRHc3ZpSjVpVFZuRnJTRWg2aE5zMEx2dFU1K0JucEtBQjFzM3Vr?=
	=?utf-8?B?RjVKdUYwYUFZT1N2bEdrVFNxNHJQMEZPSXJVR1EzQ05uWUlPSWtPNFk1dmI3?=
	=?utf-8?B?QmovbVExdmc0VTRhSzlwUVNaUm0xM3k0WkoyS28vNGloUXA4SDM1MWJESEJ3?=
	=?utf-8?B?Tnl6M0lrbnhLRG03SjRDWmdackJOZ010dkU1a29pUjNVR0grSlMxeEJSQmh6?=
	=?utf-8?B?T2ZmcytML1JHQjhWSkR5QTJZNVQxdzAxejZUQnJkcVpXWkpNU2h4VDZTNkUz?=
	=?utf-8?B?NWNPSEVvemVhMWttaStjQms2VFFOalFEV0x5dXY2R05OSGtobm9PMVVzZmM5?=
	=?utf-8?B?cHRqa21ZN1RzOXJwemtaRFpLZkh6dHZyTmZDVDgrMXJNSDZIZllkY1NQd0Uw?=
	=?utf-8?B?MXlkQ3FGUjg5YmZLMERTckcvVFBETE5mNmc0OFZkMWt6SWE2cG5KM0Y5RVk4?=
	=?utf-8?B?MVZLSzNPbGtDZ2xNR3lhZ0tOUUphbWZGaEwzOFdEeDZPVmc0alF6SGFzZUV0?=
	=?utf-8?B?Rm8xNGZMUXdpTU9WVno4L2pzb3BHUWovaTNvMnhRMmdsUFhhTnY4b05mMVpZ?=
	=?utf-8?B?YlNmSGEvZXlsYWM5YkYzQnQ2QXlPbGwvZ3pTcnEvWHVEWWZGeDFacEdGbitB?=
	=?utf-8?B?NTlTOVo4cXFYa25SS0pVbFZpdU83Ny9ldGYrWUMwRms3eEZra3pYTW9ZSGM2?=
	=?utf-8?B?bGhLUWZxM3RKdExIckRtcXh3dnZqSm5jTmVuRmlhUXY1S3FGVTVWbEpyYk9i?=
	=?utf-8?B?WXArN3YvcUZvVXFzWDJaeHBSZnRHbzlLQnlneGtXb3ZPTURoSTVGU3N0SHcy?=
	=?utf-8?B?UFlOb2FvWlkwQ1VTZzA5RjFua05USWNxdnk0cHNzU1JzODcvSS8wdndBSGpQ?=
	=?utf-8?B?a0l5aFlSeG8vMkd0RzhDYmJ2Vk0xTnFXcnZkNmtyTDZSMzVNdThqNW1Ha1dC?=
	=?utf-8?B?cHRPcHlLQ0V3Snk4Qk5tYnMxWEhMclI3YzZMRktqWDUvcTZSVG1tOWszM2Yy?=
	=?utf-8?B?Um5raVREY0Z5dnpFaW13UEVNMXhCVjZzeS83N0kyV3BzMU1Xc2x1MzIvL3dl?=
	=?utf-8?B?dXpXQmRUK1dFMGhFVVBzWVlHeFdTaUpMWjJ4M0hxV1BMVHZ1b0lLUFVKYlYx?=
	=?utf-8?B?REZPVmtWYnh6dkdvRUNXWEx0a05uQk54QWFHMy8xcmlVekRORUdnRFdHdkpI?=
	=?utf-8?B?SjZmVC92Z2NxMko0d04ybDM4VnFTOGh0Z0ROc1dXSlArOFJ3YjFEeVV1eTh5?=
	=?utf-8?B?Y3kxRVFGaDQ5cEJsc2xDeHA0NmNhOW1QRitLOE1HeHdOSFJ0eVhBVnVrSW96?=
	=?utf-8?B?ci9IOXBiWXRHeGVaR3JNb2swVVlEbkdodjFjZVdzTkl3c294QUtzL3BIaWhK?=
	=?utf-8?B?eHkzQjB0Nmp5NFdKck52bUNDWUtUWGE0YVNQNW1BLzJNV01HR29DaEd1UnU0?=
	=?utf-8?B?SnlTYkpNa2N2QndMbTNHeFpUK1dKZUc0ZDQxWUt5K0FvRXl4aXIvSzduWmc1?=
	=?utf-8?B?SDhnZVFvaTRzeUhXbFE2aGN3ejYvRkczK3lWbUcyUUVLZVZma09UZ2hxMFdS?=
	=?utf-8?Q?NP0SYwk4eCDxVsDv6c+e4glOqQEqJKurdkoP5G7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d86e71-5291-4107-4b44-08d98e185671
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 07:09:03.1495 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKgAprYL+E++mfjsCH0mz8gQNRJLzjWcYVa86B+8Rg55UpmCyDF8UUJHzNyZ92Ra+o2LwRbSN5mJnOCh0xNxbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3789
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	phishscore=0
	suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110130047
X-Proofpoint-ORIG-GUID: NlBrr-oEiOEEhnucGVA6sN4W_UqnzqbP
X-Proofpoint-GUID: NlBrr-oEiOEEhnucGVA6sN4W_UqnzqbP
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com,
	linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
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
Subject: Re: [dm-devel] [PATCH 11/29] btrfs: use bdev_nr_sectors instead of
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 13/10/2021 13:10, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

