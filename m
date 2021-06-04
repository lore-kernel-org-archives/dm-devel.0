Return-Path: <SRS0=RkM6=LB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC40C47082
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 06:44:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D1BD611C0
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 06:44:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D1BD611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-V3myF0eoMECMsIpDV0jugg-1; Mon, 07 Jun 2021 02:44:00 -0400
X-MC-Unique: V3myF0eoMECMsIpDV0jugg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 118DF501E1;
	Mon,  7 Jun 2021 06:43:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D2295B4A4;
	Mon,  7 Jun 2021 06:43:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F35B51800BB8;
	Mon,  7 Jun 2021 06:43:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 154GJLv6012666 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Jun 2021 12:19:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5AF40215ADDC; Fri,  4 Jun 2021 16:19:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55CA4215ADDA
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 16:19:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AAC08564EE
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 16:19:17 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-96-QEjkwi0TP--4hgACOYGnkQ-1; Fri, 04 Jun 2021 12:19:13 -0400
X-MC-Unique: QEjkwi0TP--4hgACOYGnkQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	154Fwio4026278; Fri, 4 Jun 2021 15:58:44 GMT
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 38y0j7gf19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Jun 2021 15:58:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 154Fwg6h009450;
	Fri, 4 Jun 2021 15:58:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
	by aserp3030.oracle.com with ESMTP id 38ubnft1gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Jun 2021 15:58:42 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
	by SJ0PR10MB4573.namprd10.prod.outlook.com (2603:10b6:a03:2ac::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24;
	Fri, 4 Jun 2021 15:58:40 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
	([fe80::8111:d8f1:c262:808d]) by
	BYAPR10MB2999.namprd10.prod.outlook.com
	([fe80::8111:d8f1:c262:808d%6]) with mapi id 15.20.4173.027;
	Fri, 4 Jun 2021 15:58:40 +0000
Date: Fri, 4 Jun 2021 11:58:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@lst.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, jgross@suse.com
Message-ID: <YLpNqiw0LMkYWUyN@0xbeefdead.lan>
References: <20210602065345.355274-1-hch@lst.de>
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
X-Originating-IP: [130.44.160.152]
X-ClientProxiedBy: MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6)
	To BYAPR10MB2999.namprd10.prod.outlook.com
	(2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 0xbeefdead.lan (130.44.160.152) by
	MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15
	via Frontend Transport; Fri, 4 Jun 2021 15:58:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dde9b11-53fa-45a5-e4e3-08d927719ed5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB457380B60E35ADDCFC95A572893B9@SJ0PR10MB4573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: DHBK1Bd4R0yQf0mbwstUwD7rwPUJpZ9OBXQW78ziXe78KyDV/ay9WxxaENfloeMsvna7ISGWXvd4tGUMEE0hAFJq07vfks3neO5X6BhHhSb03cYDUSZQHXrCquEk5/GydvhOOwJftznFM9p1AJkBu13MtYY7t2/t5i7zm5RMU2KnsH/Uy61Wb7pGr9LfEk5gMIkYWiQijXJz+wDDDH5ZuYuLAl4J0ImmQrPMFSyYuO9OXefsEzSvWPDUhTx2FEbG5DluUitc+JkgRUIVVOyv6oZtmslmx2fEGZ0JH45HZ4yXtoT6ANXJwUndJMqaVwL+NLR5bd/TJjVXjkExroJxC4HW8uy8wLPcnt3WhJhQH4N4lp83G61x7DJHAjxIMHVK/hQtyWrnxDx9SzznUZSxFaGQ4gEWh0NldxkFkjK5Wo2f1ZyCVM2pMEksXUvDJu8jvdpWKvtu72LkdZtNF0d5JLlci6rFbhqGbxSPZta8qUs11ZtiwV577linlXpQy9wl3ZHN6gUpfiOKAU6e9N9/7OwoazJb/xgIbpGCT4hcSSDGE4vXb7tMiPqUFx99nSz5EyohhphRzO5Qp54uBzTdbYYHvurlhAKFZSC2uLQvNrIPOGq2X93TowBkmaVPmGub6LFR8OOOv1TuKZtCkA51M3bogdaVBrVnBelcQEx4rdw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR10MB2999.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(7416002)(7406005)(66946007)(83380400001)(8936002)(7696005)(52116002)(6506007)(8676002)(956004)(2906002)(86362001)(8886007)(66556008)(5660300002)(54906003)(110136005)(36756003)(55016002)(9686003)(66476007)(38100700002)(26005)(316002)(16526019)(186003)(4326008)(478600001)(38350700002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gdpQmfl8El8DPe05/ff+wLw1/KXLxBUk84KmbBsgJrrdeHieFn5LEuqnWl++?=
	=?us-ascii?Q?+UjNgTjJDG0Oy6mts17gW1+WMWYc5sUjhoAGzfgwfT7Pzy2441s4sE3MvxSX?=
	=?us-ascii?Q?SRhf4Ec4wl4gNcjirY4ZZx9nyHsKiuVqsZIiIgvOZV6JtJ/wEtmJxOuFg8nP?=
	=?us-ascii?Q?uKjCrwrGeC3048DWWWWuHEDcmJ6ZiYL6rsQKzrsK0nqgY5Rxqs6sQE3dQNq4?=
	=?us-ascii?Q?CfCfYZsdey83ES59nAWpWzHfBPV3sAkiuolib1v8KFoFh4m19r203lwOpa59?=
	=?us-ascii?Q?SySyMhX/1zZ61W8f+1VN6FTD6szZX2+vTot42u9xJ9dDh0U3eNAxd2iYZn0f?=
	=?us-ascii?Q?FnywpHXicqp7wJ4XxEvvbHwQjO+qRq86gUvS750ntuWPrrC2vv5+b6RZzuES?=
	=?us-ascii?Q?UcXB6tmXaG0UH6hWSpBKxi4Qu+znSclq9GPbpnNHb6uGZthjISahfQtta6L8?=
	=?us-ascii?Q?QENMEq/n3Y8O4nxltdvopsJg4mtGH7XLAIw1TfFd6NGnkMGv+e8uEULBYnah?=
	=?us-ascii?Q?sKsuSSKxj9HW9YLP46ZjPemhaoeHbI0bMhjtc8tA5iddmW0Qp0D1sou4oBx1?=
	=?us-ascii?Q?+NWx0/dEti/pL1xCxKtWgaprT2A+vvp2lNH/Zp9EdpD7pqwSsffeQGQGYkmO?=
	=?us-ascii?Q?JCogfOFRqp8ieYxSSlI7BY6O5f4vs0fr+pOs/di4TE/EuWhelL8x8D4VFENg?=
	=?us-ascii?Q?C10k7BLZfSLJXmQkDkwCUju3JpwBTu20ZSobHfpvuiGl7BhkQAfiy8EJMLmD?=
	=?us-ascii?Q?YBoD5fLwHNzfpBW0nr5lCjOi5onruP7ZRKk/3ddsKzuFkx2PjQDOaEprB8od?=
	=?us-ascii?Q?uLw/m7j6Z7YgqwkScdMQliPMFlaMnWQlKN5/c0leXZ3TayPv8hxil1UBekgP?=
	=?us-ascii?Q?Kpp5KY5GxCcyAZW2yfB8Y4ikwdiKii5dj+yOqOBxN/6JyV2pvazcS9Xsq9Dj?=
	=?us-ascii?Q?Y1DsNtmdsClAPVchPB15A2Yp5/fLM2u7cgMhr8thEdLIV5cUr5UwtEJfUi1L?=
	=?us-ascii?Q?a7P8IQ2zF8beqpIVhRJuUz+bgGvmluPArexdyi8MmDeVuKICYzY1ZylKnltR?=
	=?us-ascii?Q?KS+uaVVX48VeH3aI1YK8YVpLFxAFhM5jGoahx7249NVuqHQitDHE/F3P2Kw9?=
	=?us-ascii?Q?P9TIMyUxY0U6UDewE1YgwVRFm6ucT69PcDuUPD/MDYRo6lQAkknDIWsZIohy?=
	=?us-ascii?Q?aHLmwizL1c8bkLjOlhcRtz0fGX76iiZhkvd7mxf0PIgWOyisyqwjfn8xHlDy?=
	=?us-ascii?Q?lya6vxtBHvC7VyelPVIM4UREFQMtr43M9AGA4WFzaF5J8kQ/Jx+YMPS6tsQ2?=
	=?us-ascii?Q?K//cbST/UVancc9qupZ1eFle?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dde9b11-53fa-45a5-e4e3-08d927719ed5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 15:58:40.2289 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8PHQ2bjx/5Yak8THiDXWmeuwC57H+V+YorWNg11QCDMPAuKEJyQpKJy+Bs2B5GcI9L15xw+he/zXw8ra7OaWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 phishscore=0
	spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2106040115
X-Proofpoint-ORIG-GUID: rc9IytYinERt57ZWbGC4hfNK-9DkWPUs
X-Proofpoint-GUID: rc9IytYinERt57ZWbGC4hfNK-9DkWPUs
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
X-Mailman-Approved-At: Mon, 07 Jun 2021 02:43:50 -0400
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Alex Dubov <oakad@yahoo.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Geoff Levand <geoff@infradead.org>,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] simplify gendisk and request_queue allocation for
 blk-mq based drivers
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 02, 2021 at 09:53:15AM +0300, Christoph Hellwig wrote:
> Hi all,

Hi!

You wouldn't have a nice git repo to pull so one can test it easily?

Thank you!

Cc-ing Boris/Juergen - pls see below xen.
> 
> this series is the scond part of cleaning up lifetimes and allocation of
> the gendisk and request_queue structure.  It adds a new interface to
> allocate the disk and queue together for blk based drivers, and uses that
> in all drivers that do not have any caveats in their gendisk and
> request_queue lifetime rules.
> 
> Diffstat:
>  block/blk-mq.c                      |   91 +++++++++++++++-------------------
>  block/blk.h                         |    1 
>  block/elevator.c                    |    2 
>  drivers/block/amiflop.c             |   16 +-----
>  drivers/block/aoe/aoeblk.c          |   33 ++++--------
>  drivers/block/aoe/aoedev.c          |    3 -
>  drivers/block/ataflop.c             |   16 +-----
>  drivers/block/floppy.c              |   20 +------
>  drivers/block/loop.c                |   19 ++-----
>  drivers/block/nbd.c                 |   53 +++++++------------
>  drivers/block/null_blk/main.c       |   11 +---
>  drivers/block/paride/pcd.c          |   19 +++----
>  drivers/block/paride/pd.c           |   30 ++++-------
>  drivers/block/paride/pf.c           |   18 ++----
>  drivers/block/ps3disk.c             |   36 +++++--------
>  drivers/block/rbd.c                 |   52 ++++++-------------
>  drivers/block/rnbd/rnbd-clt.c       |   35 +++----------
>  drivers/block/sunvdc.c              |   47 ++++-------------
>  drivers/block/swim.c                |   34 +++++-------
>  drivers/block/swim3.c               |   33 +++++-------
>  drivers/block/sx8.c                 |   23 ++------
>  drivers/block/virtio_blk.c          |   26 ++-------
>  drivers/block/xen-blkfront.c        |   96 ++++++++++++++----------------------
>  drivers/block/z2ram.c               |   15 +----
>  drivers/cdrom/gdrom.c               |   45 +++++++---------
>  drivers/md/dm-rq.c                  |    9 +--
>  drivers/memstick/core/ms_block.c    |   25 +++------
>  drivers/memstick/core/mspro_block.c |   26 ++++-----
>  drivers/mtd/mtd_blkdevs.c           |   48 ++++++++----------
>  drivers/mtd/ubi/block.c             |   68 ++++++++++---------------
>  drivers/s390/block/scm_blk.c        |   21 ++-----
>  include/linux/blk-mq.h              |   24 ++++++---
>  include/linux/elevator.h            |    1 
>  33 files changed, 386 insertions(+), 610 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

