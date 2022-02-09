Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38ACEC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 07:53:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-faRk9jCoPDizB9JIIAS_Xw-1; Wed, 09 Feb 2022 02:53:47 -0500
X-MC-Unique: faRk9jCoPDizB9JIIAS_Xw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5AA83DD20;
	Wed,  9 Feb 2022 07:53:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6611362D71;
	Wed,  9 Feb 2022 07:53:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96FF24BB7C;
	Wed,  9 Feb 2022 07:53:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2197oVZx014370 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 02:50:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B7B8E401E59; Wed,  9 Feb 2022 07:50:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1EA4401E58
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 07:50:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95D543C01B81
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 07:50:31 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-594--5DlYBkfNqi0k3ovlg1vpg-1; Wed, 09 Feb 2022 02:50:28 -0500
X-MC-Unique: -5DlYBkfNqi0k3ovlg1vpg-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	2193kZ2C007536; Wed, 9 Feb 2022 07:50:03 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e368tw4bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Feb 2022 07:50:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2197l5Q7058601;
	Wed, 9 Feb 2022 07:50:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
	by userp3020.oracle.com with ESMTP id 3e1jpsaytu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Feb 2022 07:50:01 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
	(2603:10b6:301:2d::28) by DS7PR10MB5149.namprd10.prod.outlook.com
	(2603:10b6:5:3a7::13) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Wed, 9 Feb 2022 07:49:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
	([fe80::e5a5:8f49:7ec4:b7b8]) by
	MWHPR1001MB2365.namprd10.prod.outlook.com
	([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018;
	Wed, 9 Feb 2022 07:49:58 +0000
Date: Wed, 9 Feb 2022 10:48:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@lists.01.org, Nitesh Shetty <nj.shetty@samsung.com>,
	mpatocka@redhat.com
Message-ID: <202202090703.U5riBMIn-lkp@intel.com>
In-Reply-To: <20220207141348.4235-4-nj.shetty@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0038.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::26)
	To MWHPR1001MB2365.namprd10.prod.outlook.com
	(2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 108b7a0f-6174-44ad-11f6-08d9eba0c46b
X-MS-TrafficTypeDiagnostic: DS7PR10MB5149:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5149A424EFD26ACFACEED7798E2E9@DS7PR10MB5149.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ofe8/xT3ve24a8k+HC/PuVOqTV6P4AcepG3RXjMnjwMQNGvKkOba4nhwUrlMteeheigFD33DbhJ7hQYhftaBZhWOgv4pj1iJEbHEG9d8STAUBpda1NEw2nE4Wqp2rHPyGkqnHDDOLVCgEno2yOXjcpnIhUXnUIPwe+rJQVp9SoWFSRmiH7W2Cwb+w9ODpybs5DYpBrkOdmsY8Z2NYcHHsoTW7Q8cDPqEz35/SZ9d8XT1qFgh0pCGRRo3lbAAxWOqoevadSAQUd6/q8TnFpDqSOEicw/lMkajhCCnSm57LLmW/Tt87nF01l/xEMshs7blxme1nmF72CM5fEK3icZD4FXUmldXcRknDSPvztopJ9J6rEamgEd790t0AeYOn7R4QqCn3Rl0nabjvprtGy1J2EU7bl+h2j7PI+uzUlNSA4SREXpGKFEo+AE0rjGCoIwh4pf3Vb6uXQ3i1U9BYz2VAcT6r4J8gjyDnXuGIM78/SHIerQsCPVegqvUylFRm41Wrbw9pVBK5qYGi4EQ33qyR62MccmfnLnC3tkLr5tPxLyHkTJYFWYYG00dx3uAJfC0ODdD9noK9iwo71+aJbJm1V2Pw2/CjvPmBv5FPDI7KOomBV6MD4SPBoDVXngzJBe52HxCTiYJ318PMZcc+tRAw4H7My6CwWRopVpSwwGQB8ci0AvwkQkhaCmch4nVrEHBXBlDv2ihYUHjt+kSYtkm9/bw8Pmnki7Rj0yw4s3QWUVxkAARLnMsbFRN3P0Wtr0u3sa/SQ1COQWUjRaiQBFm8cpvf5y+DHThQ9KsoONYnaeuh4FBZ18o2DiZp0Qc2zLmKsBo6Vup5KTY9g2EV7lLlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MWHPR1001MB2365.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(8936002)(8676002)(66946007)(4326008)(2906002)(66556008)(66476007)(6666004)(6512007)(6506007)(1076003)(52116002)(186003)(38350700002)(36756003)(9686003)(38100700002)(7416002)(316002)(508600001)(7406005)(44832011)(6486002)(966005)(86362001)(83380400001)(26005)(5660300002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qn2SKiX4ff8/ryIyyGsAmU8btwVNyfzYOoUm3CVEYURCiHvpx4sjiFybfn4+?=
	=?us-ascii?Q?XPXEO6kvlOwztShStFE+lAQRR5Yo24yEX6Y/B/d7EbcMPfuKfZYfWxCWhwSU?=
	=?us-ascii?Q?7Uku5h/vIbX+diJO+RlqFzxBVizPGLwMwUmP1uuGKgFlU2K5GboMLBUM0+3Z?=
	=?us-ascii?Q?GLe+Iad51yMGYPAz46neKstPVRXppIiqg4D/AhkUdnTXnBLgJt1qrWxAUTAA?=
	=?us-ascii?Q?PwoT47Hx+2SLib80xS7W3azovFM9aCBHdC17d+6kyrnGceeNBCRTOg/gWaaX?=
	=?us-ascii?Q?Qzqbk2DwqzFquwwhzCMWotuwqXvVhkbQT4WrzQ0IrFkkel1+i9oobRbQn2Fk?=
	=?us-ascii?Q?uWl93Z3upTvUO/8eRsMZNYKT5EIDffHolWyHWi/Mv8CRg1gOC59KhUGyp03l?=
	=?us-ascii?Q?xZ/uL6tJ7kAx+L9SLW0sPoMyQaTI80/RMssBI+Kw3jAGykiH3f/Xbrp7f7/k?=
	=?us-ascii?Q?TpS3v/qHfnLtlyaxbwGBde4zE9YAVAOnci4JuyjJm3sR/rve44l7EE6NrUTP?=
	=?us-ascii?Q?wfy7aKr6x33Akgb095jTBg/XYNFQHNhvAJOSScKw3pzZPjbR3/baZEo78NlS?=
	=?us-ascii?Q?N6h2b9AcRz5Z4EyUDn1qYwzFwt0jN//ktFdjoCQCgmHrxx1M3F5uGEFCkOWG?=
	=?us-ascii?Q?3Lhpq9VClPnjaWmfUkZ1MA7cB+1WhjX+vMoka3yP+/IdHtBIRjk9SJWzI2xZ?=
	=?us-ascii?Q?XeqVGQu/6S/tSfGg6y/TAAt31ADf6aX+SDG9hIXVytdgIQot6AwGiabd+X4h?=
	=?us-ascii?Q?dKHKXvzxM/CPh3Ko/u1AuO7LgzjBIL6hc5ZloBqkO+8fqRsGMuGMGds65tJP?=
	=?us-ascii?Q?ITOOZdM40hB0+8wi80ML/c6RCkztC5L7KJ+eCVNntMMbkO1jJ9ZpO4hraVm3?=
	=?us-ascii?Q?mzuAe9xjv1BEO55IpRWZeqYFhA8y4+bK7Bb/CQAtJJ/83ecOtWf5W4EkSHAS?=
	=?us-ascii?Q?ZJ3oYOf4SiVdo76GDUxj6KNbT6N3uYI6+lhlFcbxd2u1XtZiBVHg7OSpEc2w?=
	=?us-ascii?Q?erqc8SzPwoOo9yA3zYr606jCx9I7pDcxdufrm2NRiOCkEPzPkAfFchsHsY49?=
	=?us-ascii?Q?WEzlZF67lHKNf6HJEiGmtcgRV3257C8XeN9+bH9Jk6B4n7xLPZag8rndGJuG?=
	=?us-ascii?Q?ybajJVwcLVfDr5+2G6KqtFAX6Lv1oB4Nk5qCbQudZZ+ddEbmkX1/8+NrlOoB?=
	=?us-ascii?Q?B91I80/bnHCIvrgGzmEzfOIPWtktlAk8jwETTgW8idCB33KJsVe0GlLfmso2?=
	=?us-ascii?Q?m3mXBp+yEpVhIt1Kobh/QgymBqK4j27iMqYBYiaonHUemTW2lzcLi6GHNmHw?=
	=?us-ascii?Q?x+LauMWRRucr7bJZPhTdA6GjFMKiOlRe605eSvqrrCFExsu+7DDg05O/BkP9?=
	=?us-ascii?Q?I0muVc3qe7abfr0cO1r+kIS87PEgh+WhdhcUn9lJW74+JKU5GK7issNfT1LQ?=
	=?us-ascii?Q?ySljYYYipkx9JeEnpRhJHXYR7BN6Ub/QlfA4F3jiFXu8kD22YauQMCnKzmyZ?=
	=?us-ascii?Q?1J7imkNJSSfo3kssW4qQjYaMmQGxxx4tFFklY0MDNuxdxobE4nv7sDyN33ZE?=
	=?us-ascii?Q?2eAl22PIRT8G44B3J23EXR/saG+7yN8mhT3/C8OgzaZGAcZUdGpQ3wWSSNjk?=
	=?us-ascii?Q?FxYDZUHcPFUCTL2BQisMlC7VJReVmijXky+L3Czaa2V8EMWmCA3x/OmtFwBo?=
	=?us-ascii?Q?x2R7RA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108b7a0f-6174-44ad-11f6-08d9eba0c46b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 07:49:58.4780 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXLUeWCrH40a8GyJAC0B8sJmDvvKyOzQ/e/q7jrkxZ88wDNC6Z0jWnnVqHxAIu8SIM4s9EdiglR+bkt+e9yTVQTfr+8jZQ7uZQcSwEWEFe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5149
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252
	signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 bulkscore=0
	malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202090052
X-Proofpoint-ORIG-GUID: XYOaZ5K02SYUt3ZMxeLa-jELX3i6JA9E
X-Proofpoint-GUID: XYOaZ5K02SYUt3ZMxeLa-jELX3i6JA9E
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	lkp@intel.com, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, SelvaKumar S <selvakuma.s1@samsung.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	tytso@mit.edu, Frederick.Knight@netapp.com, bvanassche@acm.org,
	axboe@kernel.dk, kbuild-all@lists.01.org, joshi.k@samsung.com,
	martin.petersen@oracle.com, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 03/10] block: Add copy offload support
	infrastructure
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

Hi Nitesh,

url:    https://github.com/0day-ci/linux/commits/Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: i386-randconfig-m021-20220207 (https://download.01.org/0day-ci/archive/20220209/202202090703.U5riBMIn-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
block/blk-lib.c:272 blk_copy_offload() warn: possible memory leak of 'ctx'

vim +/ctx +272 block/blk-lib.c

12a9801a7301f1 Nitesh Shetty 2022-02-07  185  int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
12a9801a7301f1 Nitesh Shetty 2022-02-07  186  		struct range_entry *rlist, struct block_device *dst_bdev, gfp_t gfp_mask)
12a9801a7301f1 Nitesh Shetty 2022-02-07  187  {
12a9801a7301f1 Nitesh Shetty 2022-02-07  188  	struct request_queue *sq = bdev_get_queue(src_bdev);
12a9801a7301f1 Nitesh Shetty 2022-02-07  189  	struct request_queue *dq = bdev_get_queue(dst_bdev);
12a9801a7301f1 Nitesh Shetty 2022-02-07  190  	struct bio *read_bio, *write_bio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  191  	struct copy_ctx *ctx;
12a9801a7301f1 Nitesh Shetty 2022-02-07  192  	struct cio *cio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  193  	struct page *token;
12a9801a7301f1 Nitesh Shetty 2022-02-07  194  	sector_t src_blk, copy_len, dst_blk;
12a9801a7301f1 Nitesh Shetty 2022-02-07  195  	sector_t remaining, max_copy_len = LONG_MAX;
12a9801a7301f1 Nitesh Shetty 2022-02-07  196  	int ri = 0, ret = 0;
12a9801a7301f1 Nitesh Shetty 2022-02-07  197  
12a9801a7301f1 Nitesh Shetty 2022-02-07  198  	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
12a9801a7301f1 Nitesh Shetty 2022-02-07  199  	if (!cio)
12a9801a7301f1 Nitesh Shetty 2022-02-07  200  		return -ENOMEM;
12a9801a7301f1 Nitesh Shetty 2022-02-07  201  	atomic_set(&cio->refcount, 0);
12a9801a7301f1 Nitesh Shetty 2022-02-07  202  	cio->rlist = rlist;
12a9801a7301f1 Nitesh Shetty 2022-02-07  203  
12a9801a7301f1 Nitesh Shetty 2022-02-07  204  	max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_sectors,
12a9801a7301f1 Nitesh Shetty 2022-02-07  205  			(sector_t)dq->limits.max_copy_sectors);
12a9801a7301f1 Nitesh Shetty 2022-02-07  206  	max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_range_sectors,
12a9801a7301f1 Nitesh Shetty 2022-02-07  207  			(sector_t)dq->limits.max_copy_range_sectors) << SECTOR_SHIFT;
12a9801a7301f1 Nitesh Shetty 2022-02-07  208  
12a9801a7301f1 Nitesh Shetty 2022-02-07  209  	for (ri = 0; ri < nr_srcs; ri++) {
12a9801a7301f1 Nitesh Shetty 2022-02-07  210  		cio->rlist[ri].comp_len = rlist[ri].len;
12a9801a7301f1 Nitesh Shetty 2022-02-07  211  		for (remaining = rlist[ri].len, src_blk = rlist[ri].src, dst_blk = rlist[ri].dst;
12a9801a7301f1 Nitesh Shetty 2022-02-07  212  			remaining > 0;
12a9801a7301f1 Nitesh Shetty 2022-02-07  213  			remaining -= copy_len, src_blk += copy_len, dst_blk += copy_len) {
12a9801a7301f1 Nitesh Shetty 2022-02-07  214  			copy_len = min(remaining, max_copy_len);
12a9801a7301f1 Nitesh Shetty 2022-02-07  215  
12a9801a7301f1 Nitesh Shetty 2022-02-07  216  			token = alloc_page(gfp_mask);
12a9801a7301f1 Nitesh Shetty 2022-02-07  217  			if (unlikely(!token)) {
12a9801a7301f1 Nitesh Shetty 2022-02-07  218  				ret = -ENOMEM;
12a9801a7301f1 Nitesh Shetty 2022-02-07  219  				goto err_token;
12a9801a7301f1 Nitesh Shetty 2022-02-07  220  			}
12a9801a7301f1 Nitesh Shetty 2022-02-07  221  
12a9801a7301f1 Nitesh Shetty 2022-02-07  222  			read_bio = bio_alloc(src_bdev, 1, REQ_OP_READ | REQ_COPY | REQ_NOMERGE,
12a9801a7301f1 Nitesh Shetty 2022-02-07  223  					gfp_mask);
12a9801a7301f1 Nitesh Shetty 2022-02-07  224  			if (!read_bio) {
12a9801a7301f1 Nitesh Shetty 2022-02-07  225  				ret = -ENOMEM;
12a9801a7301f1 Nitesh Shetty 2022-02-07  226  				goto err_read_bio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  227  			}
12a9801a7301f1 Nitesh Shetty 2022-02-07  228  			read_bio->bi_iter.bi_sector = src_blk >> SECTOR_SHIFT;
12a9801a7301f1 Nitesh Shetty 2022-02-07  229  			read_bio->bi_iter.bi_size = copy_len;
12a9801a7301f1 Nitesh Shetty 2022-02-07  230  			__bio_add_page(read_bio, token, PAGE_SIZE, 0);
12a9801a7301f1 Nitesh Shetty 2022-02-07  231  			ret = submit_bio_wait(read_bio);
12a9801a7301f1 Nitesh Shetty 2022-02-07  232  			if (ret) {
12a9801a7301f1 Nitesh Shetty 2022-02-07  233  				bio_put(read_bio);
12a9801a7301f1 Nitesh Shetty 2022-02-07  234  				goto err_read_bio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  235  			}
12a9801a7301f1 Nitesh Shetty 2022-02-07  236  			bio_put(read_bio);
12a9801a7301f1 Nitesh Shetty 2022-02-07  237  			ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
12a9801a7301f1 Nitesh Shetty 2022-02-07  238  			if (!ctx) {
12a9801a7301f1 Nitesh Shetty 2022-02-07  239  				ret = -ENOMEM;
12a9801a7301f1 Nitesh Shetty 2022-02-07  240  				goto err_read_bio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  241  			}
12a9801a7301f1 Nitesh Shetty 2022-02-07  242  			ctx->cio = cio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  243  			ctx->range_idx = ri;
12a9801a7301f1 Nitesh Shetty 2022-02-07  244  			ctx->start_sec = rlist[ri].src;
12a9801a7301f1 Nitesh Shetty 2022-02-07  245  
12a9801a7301f1 Nitesh Shetty 2022-02-07  246  			write_bio = bio_alloc(dst_bdev, 1, REQ_OP_WRITE | REQ_COPY | REQ_NOMERGE,
12a9801a7301f1 Nitesh Shetty 2022-02-07  247  					gfp_mask);
12a9801a7301f1 Nitesh Shetty 2022-02-07  248  			if (!write_bio) {

Please call kfree(ctx) before the goto.

12a9801a7301f1 Nitesh Shetty 2022-02-07  249  				ret = -ENOMEM;
12a9801a7301f1 Nitesh Shetty 2022-02-07  250  				goto err_read_bio;
12a9801a7301f1 Nitesh Shetty 2022-02-07  251  			}
12a9801a7301f1 Nitesh Shetty 2022-02-07  252  
12a9801a7301f1 Nitesh Shetty 2022-02-07  253  			write_bio->bi_iter.bi_sector = dst_blk >> SECTOR_SHIFT;
12a9801a7301f1 Nitesh Shetty 2022-02-07  254  			write_bio->bi_iter.bi_size = copy_len;
12a9801a7301f1 Nitesh Shetty 2022-02-07  255  			__bio_add_page(write_bio, token, PAGE_SIZE, 0);
12a9801a7301f1 Nitesh Shetty 2022-02-07  256  			write_bio->bi_end_io = bio_copy_end_io;
12a9801a7301f1 Nitesh Shetty 2022-02-07  257  			write_bio->bi_private = ctx;
12a9801a7301f1 Nitesh Shetty 2022-02-07  258  			atomic_inc(&cio->refcount);
12a9801a7301f1 Nitesh Shetty 2022-02-07  259  			submit_bio(write_bio);
12a9801a7301f1 Nitesh Shetty 2022-02-07  260  		}
12a9801a7301f1 Nitesh Shetty 2022-02-07  261  	}
12a9801a7301f1 Nitesh Shetty 2022-02-07  262  
12a9801a7301f1 Nitesh Shetty 2022-02-07  263  	/* Wait for completion of all IO's*/
12a9801a7301f1 Nitesh Shetty 2022-02-07  264  	return cio_await_completion(cio);
12a9801a7301f1 Nitesh Shetty 2022-02-07  265  
12a9801a7301f1 Nitesh Shetty 2022-02-07  266  err_read_bio:
12a9801a7301f1 Nitesh Shetty 2022-02-07  267  	__free_page(token);
12a9801a7301f1 Nitesh Shetty 2022-02-07  268  err_token:
12a9801a7301f1 Nitesh Shetty 2022-02-07  269  	rlist[ri].comp_len = min_t(sector_t, rlist[ri].comp_len, (rlist[ri].len - remaining));
12a9801a7301f1 Nitesh Shetty 2022-02-07  270  
12a9801a7301f1 Nitesh Shetty 2022-02-07  271  	cio->io_err = ret;
12a9801a7301f1 Nitesh Shetty 2022-02-07 @272  	return cio_await_completion(cio);
12a9801a7301f1 Nitesh Shetty 2022-02-07  273  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

