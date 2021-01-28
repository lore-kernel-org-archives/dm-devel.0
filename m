Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0848C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:37:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59F1964E27
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59F1964E27
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-B3YMMoERNzalOZRzIn0rpg-1; Fri, 29 Jan 2021 04:37:24 -0500
X-MC-Unique: B3YMMoERNzalOZRzIn0rpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E92971005513;
	Fri, 29 Jan 2021 09:37:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B17715D740;
	Fri, 29 Jan 2021 09:37:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 74DF41809CA1;
	Fri, 29 Jan 2021 09:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SDuMDs020283 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 08:56:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 09B2E1020445; Thu, 28 Jan 2021 13:56:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0477C1000DBC
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 13:56:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D278800B3B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 13:56:19 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-553-Oq0xJ05fP1C6Lhb2_LCang-1; Thu, 28 Jan 2021 08:56:15 -0500
X-MC-Unique: Oq0xJ05fP1C6Lhb2_LCang-1
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SCYAiu192248; Thu, 28 Jan 2021 12:43:16 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by userp2130.oracle.com with ESMTP id 368b7r3xs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 12:43:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SCbobd047153; Thu, 28 Jan 2021 12:43:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by aserp3030.oracle.com with ESMTP id 368wcqmysx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 12:43:15 +0000
Received: from CH2PR10MB4118.namprd10.prod.outlook.com (2603:10b6:610:a4::8)
	by CH2PR10MB3941.namprd10.prod.outlook.com (2603:10b6:610:4::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Thu, 28 Jan 2021 12:43:11 +0000
Received: from CH2PR10MB4118.namprd10.prod.outlook.com
	([fe80::2cd3:dc36:f8d4:ea2a]) by
	CH2PR10MB4118.namprd10.prod.outlook.com
	([fe80::2cd3:dc36:f8d4:ea2a%8]) with mapi id 15.20.3784.019;
	Thu, 28 Jan 2021 12:43:11 +0000
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, xen-devel@lists.xenproject.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Message-ID: <8d3f7e70-1c7a-567a-0e60-97bac846bf13@oracle.com>
Date: Thu, 28 Jan 2021 06:43:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.1
In-Reply-To: <20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
X-Originating-IP: [68.201.65.98]
X-ClientProxiedBy: SN4PR0501CA0077.namprd05.prod.outlook.com
	(2603:10b6:803:22::15) To CH2PR10MB4118.namprd10.prod.outlook.com
	(2603:10b6:610:a4::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.190] (68.201.65.98) by
	SN4PR0501CA0077.namprd05.prod.outlook.com
	(2603:10b6:803:22::15) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.3825.8 via Frontend Transport;
	Thu, 28 Jan 2021 12:43:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e01d42d-3bc2-4bab-28da-08d8c38a4555
X-MS-TrafficTypeDiagnostic: CH2PR10MB3941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB39411E0FD376FAA86E74219987BA9@CH2PR10MB3941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: pJ5ccHGdfMIuYnzx8aq0wBe7CGK5hELGkFwmW+UbSGKkOVpfgd4YBi0vrc+er51UtFKESCZAyt1Tp5H5X6cEG9b1EeQrBf4RSEyzl3baouUCAYXgXHVFR0/RrNoIj7y0HIIMRk7rAHMY0vw04eZ0KN1Rg0nSmRbIXxfIzHm/+llfg5vXr7mz+bpOE+7sfq/1lFfhHLxDCXXWejvvBjnCeOxXqgBDiOXdG5T5s0+D4oxdxJZFuttUOavuECY7bCePtreJrvjchJOPXhU1BoOiRU4gVcpEp8gkj+VeGWMkfFRlm0cCmZbfS3BfDuXDIT7v3vdL8Q9W39+CtghNyBZ4KaMGtxayQFhOQ6Po0F1ZVyaiiuZ85rlA4rjv24EJRBq6/z02CElTZrxJeLOHNl1EFko6t5wnFfQCXczxRrfrpdXumXasRKoJ/+16Gw0rrPZY85eRY7PEoxjxU7PLkD4+F17RBlIaAnKfg+aLMDxGkkoSN9BOBtMlkavxKTCf8ofiLHhjadTYZo2E3Uz0awpIg+XtnZwMJu+yQJg5YabAYiD3ogLMFP/9xSg9wyCqCxIWb2px3qKIgj4zJ8SqXI+ievvKAKlegmf0tVnNgoQvfibMDk1NTpx5Py49FzNeNngt
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR10MB4118.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(396003)(136003)(39860400002)(366004)(376002)(7366002)(6486002)(36756003)(2616005)(66556008)(83380400001)(2906002)(921005)(16526019)(5660300002)(8676002)(66476007)(7406005)(478600001)(7416002)(86362001)(186003)(6666004)(316002)(16576012)(31696002)(66946007)(8936002)(53546011)(956004)(4326008)(26005)(31686004)(44832011)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Vm4rTktBWm5uc09iM3FnVVBkdjNUVHBpdWs5Q0ZDTkk5R0E3ODRnYUZMMktU?=
	=?utf-8?B?RG56Y1hFZjFxaXJGM1N2TnlIN0ZCOFJCa2FKYmpJMEZDTGJIcU81MkkvWUN5?=
	=?utf-8?B?TFd0TUV5cERHM1RvKytObUVJd0NXSmpZa1NRZk5iRGhldTRMSlVvajhDTlhR?=
	=?utf-8?B?T0txelh4S3RUTDRrN20rSjFIZzBwdk1OOFRtMHBOUTdjMUhHby9mcWVJWFBm?=
	=?utf-8?B?bndkYzh1dWM1NVZXRk9pTEFmbG9Mcnl2N1h1YzhDVTVSdWdjczNKMFk1LzM5?=
	=?utf-8?B?STBkVWthUEIzamRkOTlvS0xNUHdFNFhkbVRxQXEvKzdEODZhdmlMSDRjbU9T?=
	=?utf-8?B?aENkbks2SEo1ZzNJanV3Z2pHVW1pUFF6eXdlRVkyTVBrRE42a2FjbWIwWkpl?=
	=?utf-8?B?TDdURFBoVFVSMnh4U0VLcjFTTUJrM2JXbXBSY3J3T3pQb3E0eHFTSWdZcXNX?=
	=?utf-8?B?cm9INjZLZG9QQ0dJR2JXZS9LNUtGeVZhTDlmTXV3SHVlczBrbldTWHFGdjhI?=
	=?utf-8?B?YlFTR2pCalVGQWo0aTUxblpoR1h3RjZKd3J3R2FCZDlNc0RVSUdtUFMyODht?=
	=?utf-8?B?Qi9pd1NrdlJoL243S2U1eUsyVEtJZ3FYckRmMFRmUllPcW1leFZnSnVEY2R3?=
	=?utf-8?B?Z2hDdUx4R3FyRjJqVEZ2WkRBWWJOdy9iY3JsUXFtSzhBYmhOZlp1MEZmMW1J?=
	=?utf-8?B?RU1udXJkREFRS0lFMUU0dlNRazZ4Vmw5UGlrTnExV3RKdzBodnZseFFKQTVz?=
	=?utf-8?B?Uy9FdkhyUjJtVU85aklWcXkzd0g4a0FMYllNR01TUFl5dkQ3ZkpJdUJDMksx?=
	=?utf-8?B?VjMvUWVUVnFpNzd0ZE1PZEtMaElncUlFYjYvNFBQZ3hVeXBrVDNVOXhORTA3?=
	=?utf-8?B?azNUa1FVUXZzTXZxQWIxeXUvdjlvbHRrR3ZTbEpwRUZpOVc5ZUZvWWVjWGFM?=
	=?utf-8?B?dGh5MTFxYVdobnA3dDZtckhsallCWHU1SXBwYkxXNHFNb2dLR3BMQ3BEWEFt?=
	=?utf-8?B?K2tRNnZ0eU9EZHF3TmVycGZzY0RSWHJibHlOcnYvamJCZEZmSzk0cnN1NXRR?=
	=?utf-8?B?RjBrd0I1eGVTSWlUb3RPbjNVUnhLMGxqeko1Vk41emRZMWxjRlZmNE5yRkxD?=
	=?utf-8?B?Ri9ITS8vQ3c4dDVYbnlHbU8zU0RqS09wK0NXaFRaWnkxd3JDL2thTSttS1lv?=
	=?utf-8?B?VnR3MlVIdjRlSy85QTdCS1FhekYvbnZyTjZlZTJtcU85NmtER3o5S0RDV3JL?=
	=?utf-8?B?cTJiTEFPUlJDWksyeS81NzVueSt5QmdieUYwVHd2bGRZZzdUYlB4QzhLNUtQ?=
	=?utf-8?B?Rjk0eGVMVGV0aFF4WS8zUG8xbGQ2NG9jUzZzbWNYTXBvRTZsUDVRSTV5ZXB6?=
	=?utf-8?B?VTRKOTgvaTZIb0dDR2pPQzNnM3V6Z3kvMUd3azhpYnRoTFdhbEg0N2hlb21t?=
	=?utf-8?Q?xgW5/je/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e01d42d-3bc2-4bab-28da-08d8c38a4555
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4118.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 12:43:11.2780 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFBedDYhghl7XP3cZN2/McX0JwxYw4Cu7FZ5NDxZqDAklfqhu0dMXnszrFIG3H4zPpJnTe1yGk1iM6Mt6c63XUXi/NVyG5gbxkRVEUnPYnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 suspectscore=0
	phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 phishscore=0
	adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
	bulkscore=0
	priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280064
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
X-Mailman-Approved-At: Fri, 29 Jan 2021 04:33:26 -0500
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
	tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org,
	joseph.qi@linux.alibaba.com, pavel@ucw.cz,
	alex.shi@linux.alibaba.com, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, mark@fasheh.com,
	osandov@fb.com, ebiggers@kernel.org, ngupta@vflare.org,
	len.brown@intel.com, konrad.wilk@oracle.com, ming.lei@redhat.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	jaegeuk@kernel.org, konishi.ryusuke@gmail.com,
	bvanassche@acm.org, axboe@kernel.dk, damien.lemoal@wdc.com,
	jth@kernel.org, tytso@mit.edu, akpm@linux-foundation.org,
	martin.petersen@oracle.com, rjw@rjwysocki.net,
	philipp.reisner@linbit.com, minchan@kernel.org, tj@kernel.org,
	lars.ellenberg@linbit.com, roger.pau@citrix.com,
	asml.silence@gmail.com, jlbec@evilplan.org
Subject: Re: [dm-devel] [RFC PATCH 19/34] fs/jfs/jfs_logmgr.c: use bio_new
	in lbmRead
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

You probably don't need 4 patches to fs/jfs/. These can be combined into 
a single patch.

Dave

On 1/28/21 1:11 AM, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   fs/jfs/jfs_logmgr.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 9330eff210e0..4481f3e33a3f 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -1979,17 +1979,14 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
>   
>   	bp->l_flag |= lbmREAD;
>   
> -	bio = bio_alloc(GFP_NOFS, 1);
> -
> -	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
> -	bio_set_dev(bio, log->bdev);
> +	bio = bio_new(log->bdev, bp->l_blkno << (log->l2bsize - 9),
> +			REQ_OP_READ, 0, 1, GFP_NOFS);
>   
>   	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
>   	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
>   
>   	bio->bi_end_io = lbmIODone;
>   	bio->bi_private = bp;
> -	bio->bi_opf = REQ_OP_READ;
>   	/*check if journaling to disk has been disabled*/
>   	if (log->no_integrity) {
>   		bio->bi_iter.bi_size = 0;
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

