Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA23C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 07:38:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B4026120B
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 07:38:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B4026120B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-HJUQd1-OMiixVwA-iAiywA-1; Mon, 12 Apr 2021 03:38:14 -0400
X-MC-Unique: HJUQd1-OMiixVwA-iAiywA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB3848030A0;
	Mon, 12 Apr 2021 07:38:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95A4F5D6DC;
	Mon, 12 Apr 2021 07:38:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3CCA85534C;
	Mon, 12 Apr 2021 07:38:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13A0ME6t014129 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 20:22:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E287219DB4B; Sat, 10 Apr 2021 00:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37AD1219DB4A
	for <dm-devel@redhat.com>; Sat, 10 Apr 2021 00:22:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0E0F85A5A8
	for <dm-devel@redhat.com>; Sat, 10 Apr 2021 00:22:11 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-309-y36dUC4aPQ6Vhge01DucSw-1; Fri, 09 Apr 2021 20:22:07 -0400
X-MC-Unique: y36dUC4aPQ6Vhge01DucSw-1
Received: from MW4PR03CA0100.namprd03.prod.outlook.com (2603:10b6:303:b7::15)
	by MN2PR12MB3760.namprd12.prod.outlook.com (2603:10b6:208:158::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16;
	Sat, 10 Apr 2021 00:22:05 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
	(2603:10b6:303:b7::4) by MW4PR03CA0100.outlook.office365.com
	(2603:10b6:303:b7::15) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via
	Frontend Transport; Sat, 10 Apr 2021 00:22:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
	smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
	header.d=none; redhat.com; dmarc=pass action=none header.from=nvidia.com
Received: from mail.nvidia.com (216.228.112.34) by
	CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with
	Microsoft SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 00:22:05 +0000
Received: from [172.27.0.23] (172.20.145.6) by HQMAIL107.nvidia.com
	(172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Sat, 10 Apr 2021 00:22:00 +0000
To: SelvaKumar S <selvakuma.s1@samsung.com>, <linux-nvme@lists.infradead.org>
References: <CGME20210219124555epcas5p1334e7c4d64ada5dc4a2ca0feb48c1d44@epcas5p1.samsung.com>
	<20210219124517.79359-1-selvakuma.s1@samsung.com>
From: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <b56a18a0-facc-edb3-c809-7436f1b1c15a@nvidia.com>
Date: Sat, 10 Apr 2021 03:21:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210219124517.79359-1-selvakuma.s1@samsung.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
	HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c6b6fc5-c84c-4c8b-760e-08d8fbb6abc0
X-MS-TrafficTypeDiagnostic: MN2PR12MB3760:
X-Microsoft-Antispam-PRVS: <MN2PR12MB376038DB67663D780AAF3F98DE729@MN2PR12MB3760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: IXIQ1Y9S2hrdwTPcTmnwVJrmz4tqrXFi2Kw9wCdqwQR+01ULjcjNJQ9wc5N3ISPaNPEYKFBVOptWkvQW3jnR42W0pj4+y7KmJQpv7AMNA51brNY7InQKkTugB0lW/Fr/rOJBbwO1RU5tyYTtb5vX/Ywuo8w1/qQZVFK+fb/FtxIqp7KIAoMaLuoHTPpET3O0ghIycGMME0kx5U+JrU8s1NsMVB4a5QsTgMmaxBVcQ+HozMFnGB2Gk4QJZFjh8oS0Yp9HO7MExX/U4xifhgC3p1xeHY6rQTgQkuVnV8sVsOqnns0dRH8hryCMc+dTZ19fu+Z6oSrvwm6i2kuomVgY2p+VdLEula9LCa7ggaFS0RsdjccxG51PsUST24XHgQDnZhB1kmAxjXJNuklX5DHWTzhfQhUlGHgFDswt6bEde72Mp6fKeBQj5L5QzNtdsXMeMFHllf/oZtX0PIKViVwMJAGkQpaqh0DAD2WRsie1yQnmlUGDrjvUCx5k2VmlT9WWQBm02YtZO8GQeK0kJ0x123mJay7SmEUDmj7zw6xrmwJKjfZIEeb1w6mImTWCAG/7bRGHqKKOQrjD5IPzGu/r8M1McglVB0bulE4PiFww9/0Jw366rhCEgTxQ1Bokroc3W6bhDlNH4fd8SmzHoscTDto9eyNi5Pf3eLBO6+zkqvqKM5gmwHXtD1go4eP13uuVkSykqw6t8yQ05hD4NBCWkZkXa4DT/8vzPiWKrYTUOeGtCfy+s1bCPtLTD7Bxvv/QA/skONlPsI+kc1xLeC6mzFIFOVT+YrQ4JG0an2Lf+DcXkUzrMOIPGe7QRN8FNoLbrk44gOa5yE63BVaJj4EOtA==
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com;
	CAT:NONE;
	SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(36756003)(2616005)(82740400003)(16526019)(6666004)(478600001)(82310400003)(966005)(31686004)(186003)(2906002)(26005)(36860700001)(70206006)(110136005)(356005)(70586007)(31696002)(54906003)(53546011)(83380400001)(7416002)(7636003)(5660300002)(16576012)(8676002)(47076005)(336012)(8936002)(4326008)(86362001)(316002)(36906005)(426003)(43740500002)(43620500001)(15398625002);
	DIR:OUT; SFP:1101
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 00:22:05.6022 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c6b6fc5-c84c-4c8b-760e-08d8fbb6abc0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;
	Ip=[216.228.112.34]; Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3760
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 12 Apr 2021 03:36:19 -0400
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, kch@kernel.org, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, hch@lst.de,
	linux-block@vger.kernel.org, kbusch@kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com, joshiiitr@gmail.com,
	linux-fsdevel@vger.kernel.org, javier.gonz@samsung.com,
	nj.shetty@samsung.com
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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


On 2/19/2021 2:45 PM, SelvaKumar S wrote:
> This patchset tries to add support for TP4065a ("Simple Copy Command"),
> v2020.05.04 ("Ratified")
>
> The Specification can be found in following link.
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
>
> Simple copy command is a copy offloading operation and is  used to copy
> multiple contiguous ranges (source_ranges) of LBA's to a single destination
> LBA within the device reducing traffic between host and device.
>
> This implementation doesn't add native copy offload support for stacked
> devices rather copy offload is done through emulation. Possible use
> cases are F2FS gc and BTRFS relocation/balance.
>
> *blkdev_issue_copy* takes source bdev, no of sources, array of source
> ranges (in sectors), destination bdev and destination offset(in sectors).
> If both source and destination block devices are same and copy_offload = 1,
> then copy is done through native copy offloading. Copy emulation is used
> in other cases.
>
> As SCSI XCOPY can take two different block devices and no of source range is
> equal to 1, this interface can be extended in future to support SCSI XCOPY.

Any idea why this TP wasn't designed for copy offload between 2 
different namespaces in the same controller ?

And a simple copy will be the case where the src_nsid == dst_nsid ?

Also why there are multiple source ranges and only one dst range ? We 
could add a bit to indicate if this range is src or dst..


>
> For devices supporting native simple copy, attach the control information
> as payload to the bio and submit to the device. For devices without native
> copy support, copy emulation is done by reading each source range into memory
> and writing it to the destination. Caller can choose not to try
> emulation if copy offload is not supported by setting
> BLKDEV_COPY_NOEMULATION flag.
>
> Following limits are added to queue limits and are exposed in sysfs
> to userspace
> 	- *copy_offload* controls copy_offload. set 0 to disable copy
> 		offload, 1 to enable native copy offloading support.
> 	- *max_copy_sectors* limits the sum of all source_range length
> 	- *max_copy_nr_ranges* limits the number of source ranges
> 	- *max_copy_range_sectors* limit the maximum number of sectors
> 		that can constitute a single source range.
>
> 	max_copy_sectors = 0 indicates the device doesn't support copy
> offloading.
>
> 	*copy offload* sysfs entry is configurable and can be used toggle
> between emulation and native support depending upon the usecase.
>
> Changes from v4
>
> 1. Extend dm-kcopyd to leverage copy-offload, while copying within the
> same device. The other approach was to have copy-emulation by moving
> dm-kcopyd to block layer. But it also required moving core dm-io infra,
> causing a massive churn across multiple dm-targets.
>
> 2. Remove export in bio_map_kern()
> 3. Change copy_offload sysfs to accept 0 or else
> 4. Rename copy support flag to QUEUE_FLAG_SIMPLE_COPY
> 5. Rename payload entries, add source bdev field to be used while
> partition remapping, remove copy_size
> 6. Change the blkdev_issue_copy() interface to accept destination and
> source values in sector rather in bytes
> 7. Add payload to bio using bio_map_kern() for copy_offload case
> 8. Add check to return error if one of the source range length is 0
> 9. Add BLKDEV_COPY_NOEMULATION flag to allow user to not try copy
> emulation incase of copy offload is not supported. Caller can his use
> his existing copying logic to complete the io.
> 10. Bug fix copy checks and reduce size of rcu_lock()
>
> Planned for next:
> - adding blktests
> - handling larger (than device limits) copy
> - decide on ioctl interface (man-page etc.)
>
> Changes from v3
>
> 1. gfp_flag fixes.
> 2. Export bio_map_kern() and use it to allocate and add pages to bio.
> 3. Move copy offload, reading to buf, writing from buf to separate functions.
> 4. Send read bio of copy offload by chaining them and submit asynchronously.
> 5. Add gendisk->part0 and part->bd_start_sect changes to blk_check_copy().
> 6. Move single source range limit check to blk_check_copy()
> 7. Rename __blkdev_issue_copy() to blkdev_issue_copy and remove old helper.
> 8. Change blkdev_issue_copy() interface generic to accepts destination bdev
> 	to support XCOPY as well.
> 9. Add invalidate_kernel_vmap_range() after reading data for vmalloc'ed memory.
> 10. Fix buf allocoation logic to allocate buffer for the total size of copy.
> 11. Reword patch commit description.
>
> Changes from v2
>
> 1. Add emulation support for devices not supporting copy.
> 2. Add *copy_offload* sysfs entry to enable and disable copy_offload
> 	in devices supporting simple copy.
> 3. Remove simple copy support for stacked devices.
>
> Changes from v1:
>
> 1. Fix memory leak in __blkdev_issue_copy
> 2. Unmark blk_check_copy inline
> 3. Fix line break in blk_check_copy_eod
> 4. Remove p checks and made code more readable
> 5. Don't use bio_set_op_attrs and remove op and set
>     bi_opf directly
> 6. Use struct_size to calculate total_size
> 7. Fix partition remap of copy destination
> 8. Remove mcl,mssrl,msrc from nvme_ns
> 9. Initialize copy queue limits to 0 in nvme_config_copy
> 10. Remove return in QUEUE_FLAG_COPY check
> 11. Remove unused OCFS
>
> SelvaKumar S (4):
>    block: make bio_map_kern() non static
>    block: add simple copy support
>    nvme: add simple copy support
>    dm kcopyd: add simple copy offload support
>
>   block/blk-core.c          | 102 +++++++++++++++--
>   block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
>   block/blk-map.c           |   2 +-
>   block/blk-merge.c         |   2 +
>   block/blk-settings.c      |  10 ++
>   block/blk-sysfs.c         |  47 ++++++++
>   block/blk-zoned.c         |   1 +
>   block/bounce.c            |   1 +
>   block/ioctl.c             |  33 ++++++
>   drivers/md/dm-kcopyd.c    |  49 ++++++++-
>   drivers/nvme/host/core.c  |  87 +++++++++++++++
>   include/linux/bio.h       |   1 +
>   include/linux/blk_types.h |  14 +++
>   include/linux/blkdev.h    |  17 +++
>   include/linux/nvme.h      |  43 +++++++-
>   include/uapi/linux/fs.h   |  13 +++
>   16 files changed, 627 insertions(+), 18 deletions(-)
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

