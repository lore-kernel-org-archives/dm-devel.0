Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92513C64E8A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 09:01:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CE20D2065E
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 09:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE20D2065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-alV3x6DEOTi6sf3sxOlilw-1; Thu, 03 Dec 2020 04:01:16 -0500
X-MC-Unique: alV3x6DEOTi6sf3sxOlilw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0C7A85818C;
	Thu,  3 Dec 2020 09:01:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 312EF5D6AC;
	Thu,  3 Dec 2020 09:01:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8763E180954D;
	Thu,  3 Dec 2020 09:01:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B38xJgt011678 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 03:59:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6EAABD7DF2; Thu,  3 Dec 2020 08:59:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67A2DD7DF5
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 08:59:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D11AE858284
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 08:59:16 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-GtogxpyNMTKGWEZD8vtafg-1; Thu, 03 Dec 2020 03:59:14 -0500
X-MC-Unique: GtogxpyNMTKGWEZD8vtafg-1
IronPort-SDR: A89q+U9d7gHLHlb2/gnpieIaA4/C7EafMMq9AmrPaq1m9JZ7CvDmuw2ZyzkPtAnuRsXGlwm9pl
	G9XJFtVG6FcKtZK9J61EtHnEv0tnTAVCiFOCXAQOs/TJJYDkHDsbf8ViRbwjtkVx+UOvuajO8V
	Y3HFwFmsLebYZ6QcU9QPYTcYSL/9ebasH1jgXCEUDiA6aTFku/Na8Brdy/8Dmwfp556RAa22xK
	WL0Ccr/nlUQzruyCOFYivb3CVnsbuT7QzMB9BGmpzuD9NMZPtNBpY1COHr4gsUvH+9cV3DMMOW
	Qpw=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; d="scan'208";a="158712209"
Received: from mail-cys01nam02lp2055.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.55])
	by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 16:59:12 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB6540.namprd04.prod.outlook.com (2603:10b6:610:64::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19;
	Thu, 3 Dec 2020 08:59:11 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022;
	Thu, 3 Dec 2020 08:59:11 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 3/5] block: remove the request_queue argument to the
	block_split tracepoint
Thread-Index: AQHWx0PymADY0+Bc+UC0df567qTLQg==
Date: Thu, 3 Dec 2020 08:59:11 +0000
Message-ID: <CH2PR04MB6522398D22B2B461B4037CDDE7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
	<20201130175854.982460-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 977b3004-bc52-48b1-475b-08d89769b3a5
x-ms-traffictypediagnostic: CH2PR04MB6540:
x-microsoft-antispam-prvs: <CH2PR04MB6540FA81CDC0B009DC22E6E0E7F20@CH2PR04MB6540.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SAx+vaEfnngHDRW+DyIWeOpFYEeDPA1OGRCwVDgYz90Qsd3HQm96RgM27j7wBi+QJIiRCOuwAj5shFnEtN1h9eCIzh9IJWdn//Zlwz70uGKyfTw78pmm7H2BTyUnAgcsF6Ndj1QN/yaQyx+cxqkRg5LcMoDJHYxTm7hGY0UUitcA9t4/2iHhYpoQjBYqwymQ18beJp+JybPDwhNaZCMCEWwOcbFuZrReJ+tkVtLDnhupiegi37AMU4eammGsms9wqGz9z5T/BeLKoGkOBp2Ukkx5od3csI3s6ruwfoMk4fwLiECdTL/GYf2kU+g+slL6Sz015M96B4kq0fnxeHAPbA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(8676002)(33656002)(6506007)(9686003)(53546011)(52536014)(83380400001)(64756008)(55016002)(66946007)(66446008)(66476007)(5660300002)(66556008)(478600001)(91956017)(8936002)(186003)(7696005)(76116006)(86362001)(316002)(4326008)(26005)(71200400001)(54906003)(2906002)(110136005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NoAx3Q/6ksfnUTRpMxmJuQWQfz7yyyR9Unx/EppqPHvRnqucpAwont6iUxiv?=
	=?us-ascii?Q?8XGRGCcA3GeqHVl3Ye8hvubEwGY1kKbfv6QvFd3DmO01eTIuAip9VGUVQUgD?=
	=?us-ascii?Q?KdqM0z1E1Bs1jdBmxGc+OvHnF/PadRUzf/D4aRsLW7pghkbDzTnvAJ//gcKC?=
	=?us-ascii?Q?2TSWyPQSulPfTh4cCge4omw1UzOt01+UhX5XiUUn/LkaYFZ1hoMPrYR6MHJR?=
	=?us-ascii?Q?9eBbGpTYKV+YEg3SdqX6pwX60eDf0+uOtlj61EIvJGEN7PWBq1/C9j4GQJa8?=
	=?us-ascii?Q?YelgOqP6vhMwsXAW4o/SIpIeCYfRmqI9xgE8pIvk4+kVKQn13xOXsqrxoG7E?=
	=?us-ascii?Q?D4G4ZQS4DSci7bStAoC9XPq6eLGgwC4iRQ5fNfCLXBRZ6WImpTE+pLwX2xbt?=
	=?us-ascii?Q?6IzrZ2Wbkwj/e8gxYETQSvW34mslQw7OTyjgvaz4q8dSPn6b6l7ancX5rfL+?=
	=?us-ascii?Q?cmRSTW1blDlNjfN23y08FYOP1tmH8R+rwmuiPbfRxiC7KSyrS9RMRFMePpck?=
	=?us-ascii?Q?0RtkFAI3KDpURRoBNIkSZtiA7fHyPKoE5YLROn9sZSMuyNUzIrtHDZakEsEm?=
	=?us-ascii?Q?EKrp3GIaouoN8nDuiWH1zxzOc4JFDGjL96n9J3tRXvZ/xPnJHkX7mFgoMcyb?=
	=?us-ascii?Q?gSG3J0/JG0rJ5TIuQCP+SmvuQvMc3GwmSw6hSWZngROZGjD7gPVMVcv2QwS/?=
	=?us-ascii?Q?gtRYjfOFTZxoPpwBavVRsSKj573Lou1XU3YRVKdvcCs8jl5Fn8uUd2wCnOZY?=
	=?us-ascii?Q?z8bYEc5KwkiWFb+8mDUW9e84Dg6olT/caIPYgRbKDv0tKOexvuYz/nmRWdGp?=
	=?us-ascii?Q?oAR5HbUCj9z5hoAvstff3VQuXlFKwf/dUa65MJppCb9x9/+ls0a7NmXA7fTa?=
	=?us-ascii?Q?vVCkCxPG8ixz8j2Er7XuhQZQEzY6SZnxx9gA2I6iF5g30pwOYpmaU/E6my1Y?=
	=?us-ascii?Q?TEpSUZulm4BxTqL5+ow6O71uFMEtgut8Z7KaW5SChPPnkSK4VbUn1ZkZFmy3?=
	=?us-ascii?Q?zPLn?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977b3004-bc52-48b1-475b-08d89769b3a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 08:59:11.3014 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YTreMKDag7kuw35THM2ZtVCOMWUELMkeAVvqpPeAZy3CABanCFkdRgSijD6vrD1aiW5LzICnDMy2fdPR5o+2VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6540
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B38xJgt011678
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 3/5] block: remove the request_queue argument
 to the block_split tracepoint
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020/12/01 3:09, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-merge.c            |  2 +-
>  drivers/md/dm.c              |  2 +-
>  include/trace/events/block.h | 14 ++++++--------
>  kernel/trace/blktrace.c      |  5 ++---
>  4 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 1a46d5bbd399e3..4071daa88a5eaf 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -338,7 +338,7 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
>  		split->bi_opf |= REQ_NOMERGE;
>  
>  		bio_chain(split, *bio);
> -		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
> +		trace_block_split(split, (*bio)->bi_iter.bi_sector);
>  		submit_bio_noacct(*bio);
>  		*bio = split;
>  	}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ed7e836efbcdbc..9a5bd90779c7c4 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1612,7 +1612,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  				part_stat_unlock();
>  
>  				bio_chain(b, bio);
> -				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
> +				trace_block_split(b, bio->bi_iter.bi_sector);
>  				ret = submit_bio_noacct(bio);
>  				break;
>  			}
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 506c29dc7c76fd..b415e4cba84304 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -411,21 +411,19 @@ DEFINE_EVENT(block_unplug, block_unplug,
>  
>  /**
>   * block_split - split a single bio struct into two bio structs
> - * @q: queue containing the bio
>   * @bio: block operation being split
>   * @new_sector: The starting sector for the new bio
>   *
> - * The bio request @bio in request queue @q needs to be split into two
> - * bio requests. The newly created @bio request starts at
> - * @new_sector. This split may be required due to hardware limitation
> - * such as operation crossing device boundaries in a RAID system.
> + * The bio request @bio needs to be split into two bio requests.  The newly
> + * created @bio request starts at @new_sector. This split may be required due to
> + * hardware limitations such as operation crossing device boundaries in a RAID
> + * system.
>   */
>  TRACE_EVENT(block_split,
>  
> -	TP_PROTO(struct request_queue *q, struct bio *bio,
> -		 unsigned int new_sector),
> +	TP_PROTO(struct bio *bio, unsigned int new_sector),
>  
> -	TP_ARGS(q, bio, new_sector),
> +	TP_ARGS(bio, new_sector),
>  
>  	TP_STRUCT__entry(
>  		__field( dev_t,		dev				)
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 7ab88e00c15765..3ca6d62114f461 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -970,10 +970,9 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
>  	rcu_read_unlock();
>  }
>  
> -static void blk_add_trace_split(void *ignore,
> -				struct request_queue *q, struct bio *bio,
> -				unsigned int pdu)
> +static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
>  {
> +	struct request_queue *q = bio->bi_disk->queue;
>  	struct blk_trace *bt;
>  
>  	rcu_read_lock();
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

