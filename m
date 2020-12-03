Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C15C64E7B
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 08:48:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D74E22084C
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 08:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D74E22084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-jvhqVqJ3PX-DLn4ZzUK4pw-1; Thu, 03 Dec 2020 03:48:11 -0500
X-MC-Unique: jvhqVqJ3PX-DLn4ZzUK4pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5805456B59;
	Thu,  3 Dec 2020 08:48:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E183C1001901;
	Thu,  3 Dec 2020 08:48:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 537DE180954D;
	Thu,  3 Dec 2020 08:48:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B38m37L010771 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 03:48:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F2762166B29; Thu,  3 Dec 2020 08:48:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08F012166B27
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 08:48:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA2D4103B800
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 08:48:00 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-337-Jt9f2V64NZS0r3Bo6Rfsog-1; Thu, 03 Dec 2020 03:47:57 -0500
X-MC-Unique: Jt9f2V64NZS0r3Bo6Rfsog-1
IronPort-SDR: PhWxSbg07Ya8IZgduBxMx2OxM/Vmk5CNziQoNqtFxF0akgnPs/dFogyT3aQRRHbIYBjgW8haoX
	AJXywH21NFaEsF7qWcG75o3CDPHSUe7HAHKSop5xLNBXSav4spJow0gLrFgA9ifK4XP1lbFoJQ
	4M8Ci1BcRjzPJsgIyPyjLdTnaH9y4TUR1OVyxyUT9kf9IPhxyBS7TMO0+6r/hWCqDKs89cYRSB
	Dd6eMpT3v/8UJJM2DV+MMjmUPp7TLY8/okkWOThPddhYmTEphtnVE7Knox7dhfGkY5VQ7reysf
	IE4=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; d="scan'208";a="155443909"
Received: from mail-bn3nam04lp2052.outbound.protection.outlook.com (HELO
	NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.52])
	by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 16:46:52 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB6854.namprd04.prod.outlook.com (2603:10b6:610:99::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23;
	Thu, 3 Dec 2020 08:46:51 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022;
	Thu, 3 Dec 2020 08:46:51 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
	tracepoint
Thread-Index: AQHWyVDXj30DQJqHH0qTV+zbakU7rg==
Date: Thu, 3 Dec 2020 08:46:51 +0000
Message-ID: <CH2PR04MB652225D9AF153543AE4DF758E7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
	<20201130175854.982460-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1083e06a-8894-4d48-d418-08d89767fa65
x-ms-traffictypediagnostic: CH2PR04MB6854:
x-microsoft-antispam-prvs: <CH2PR04MB68548BE747B81B18B29A5E9AE7F20@CH2PR04MB6854.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: DbfboezJhFzjcs+esFjS8Iy0oZXcPCMkmUGplS/KmcEzHNCcjqTBzaJ64YDTtV4bAIkUFmPPio+Zw/Wxy3qtf9o/Uwc/mWV+8uiASkgYtNKtlPcYCkL17nw3SaellhSAjc4DF7jqr3BE3Swx/WSnjS97Et4IHi8TntfpY1WCqAE7vCHFPR4olncvLywxMKxH5PMCnyAlHQNbxVMYVhX5P6tJ/Guc68WyL627pVQ5z8h8gVwU5CGKcwfsAL/kbobpwLjJE2h7i0JyAaC5fSgpll5VcN/E/gwp0AE7eXQiZJBYNOv5C749Wz/AuSapMbb0CECZzQ3KZSMNeI7f6M8AWA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(7696005)(5660300002)(9686003)(6506007)(4326008)(71200400001)(86362001)(53546011)(52536014)(8936002)(66556008)(55016002)(76116006)(64756008)(66946007)(2906002)(8676002)(316002)(110136005)(83380400001)(33656002)(54906003)(186003)(66476007)(26005)(91956017)(66446008)(478600001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hGlm8Z0IQHDnoZ3/236XV6xh96wfyhzTFFwISD61+ZzdJW+m6sj5jKlt2rwk?=
	=?us-ascii?Q?8Nm4szpvaojgLXPXPZuUDcYk8bBOqQpY2FfvFAuB0cXln5d/VhMXOG95/yKE?=
	=?us-ascii?Q?uUNWBdw9jLtTOq/rw34cyh4AqX+hMbIT502qWVMgaZuE4g3tMXwtDe2IOP9x?=
	=?us-ascii?Q?hMESp1We3dcPvnEMNw1fAkt9+LTXtFdPmhr1PBm19OxyMtu7KJF/Uzt4+AFX?=
	=?us-ascii?Q?UW8/BUOr96XevkvUFHVQxHnXYsAEqvTapk9z7yEeEgRKbxgHOST8nndulgid?=
	=?us-ascii?Q?W8dQd0N0GOX9zeaLZEVRAaMA6Nnl9dl0l+yAbBa9+UJeWpwwTNRhyf6mmdL7?=
	=?us-ascii?Q?iO7umMswuVn3ymEEC3bbK8NIwwhiprT/XRiFOFnuSAQ0RZxIA/qUOeCIl+ZG?=
	=?us-ascii?Q?Icl4oZz4VqBv2WwwM8sIIrll1a0qD9AGF3msfmuccBqB3dgEO7OZoaPtus/3?=
	=?us-ascii?Q?3n1oWF+Lu7sAu7dWciNAfmN0RSYgTacOp/GxiAfQfBNI5ctFpCX3XcR1kg+s?=
	=?us-ascii?Q?UDcKpf3qeg9WPndT7nzKgzsgF7S3Kof9Qp50KTTDMUwQONHxduwO/EpiwLm5?=
	=?us-ascii?Q?TDxWteVXJ8NFZv6rviPCKXDnCHDFFBjF26vIEWXsvh8c47z34ih0kouiKdmX?=
	=?us-ascii?Q?NWo5UGY8S7Sx0AZ4fIhxF8qPlb6sTYRGUNDdimxyqOU7/MF1qW1c+hMhUZNb?=
	=?us-ascii?Q?EqHNdv3Fkno/1vAs/1a4v3mpGlQtsCZnRxfCzl8vVhUIHS0cDbSRLsGLMXPm?=
	=?us-ascii?Q?290CGZYdZioGCYg+6Y3+wLYDjfSfEYe2fcaWJp4j3VNLNcQVl/kkY96AU81P?=
	=?us-ascii?Q?/UlMmCo6sBm2Yfh0n1ZH8zQmGdxIqDYajD+pZj7m8Oga73rnaTA+ohuoq1T+?=
	=?us-ascii?Q?CZ+KdpzIDssEAKJfXkLMn428CBUwO/nLUwnhQnczHThIRnxbImtVfjZ1jvJa?=
	=?us-ascii?Q?GEGuqMTsiE6FJcF8oAPDRChpHgECFG+ae2Ghk+OfecGHak1fE9+FpGCqBo1j?=
	=?us-ascii?Q?cj0N?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1083e06a-8894-4d48-d418-08d89767fa65
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 08:46:51.0282 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXG++VDluB0rTxnvtpZeV6at3DAQGt+37adKcB/SENE9hNaw808pgGQZY018d0nYzYTPCY5YG4eekNlzbMvCKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6854
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B38m37L010771
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
 tracepoint
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020/12/01 3:03, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Even if it is just repeating the patch title, a commit message would be nice.
You could also mention when the last use of this tracepoint was removed.

> ---
>  include/trace/events/block.h | 18 ------------------
>  kernel/trace/blktrace.c      | 22 ----------------------
>  2 files changed, 40 deletions(-)
> 
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 34d64ca306b1c7..76459cf750e14d 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -441,24 +441,6 @@ DEFINE_EVENT(block_get_rq, block_getrq,
>  	TP_ARGS(q, bio, rw)
>  );
>  
> -/**
> - * block_sleeprq - waiting to get a free request entry in queue for block IO operation
> - * @q: queue for operation
> - * @bio: pending block IO operation (can be %NULL)
> - * @rw: low bit indicates a read (%0) or a write (%1)
> - *
> - * In the case where a request struct cannot be provided for queue @q
> - * the process needs to wait for an request struct to become
> - * available.  This tracepoint event is generated each time the
> - * process goes to sleep waiting for request struct become available.
> - */
> -DEFINE_EVENT(block_get_rq, block_sleeprq,
> -
> -	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
> -
> -	TP_ARGS(q, bio, rw)
> -);
> -
>  /**
>   * block_plug - keep operations requests in request queue
>   * @q: request queue to plug
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index a482a37848bff7..ced589df304b57 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -959,25 +959,6 @@ static void blk_add_trace_getrq(void *ignore,
>  	}
>  }
>  
> -
> -static void blk_add_trace_sleeprq(void *ignore,
> -				  struct request_queue *q,
> -				  struct bio *bio, int rw)
> -{
> -	if (bio)
> -		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
> -	else {
> -		struct blk_trace *bt;
> -
> -		rcu_read_lock();
> -		bt = rcu_dereference(q->blk_trace);
> -		if (bt)
> -			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
> -					0, 0, NULL, 0);
> -		rcu_read_unlock();
> -	}
> -}
> -
>  static void blk_add_trace_plug(void *ignore, struct request_queue *q)
>  {
>  	struct blk_trace *bt;
> @@ -1164,8 +1145,6 @@ static void blk_register_tracepoints(void)
>  	WARN_ON(ret);
>  	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
>  	WARN_ON(ret);
> -	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
> -	WARN_ON(ret);
>  	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
>  	WARN_ON(ret);
>  	ret = register_trace_block_unplug(blk_add_trace_unplug, NULL);
> @@ -1185,7 +1164,6 @@ static void blk_unregister_tracepoints(void)
>  	unregister_trace_block_split(blk_add_trace_split, NULL);
>  	unregister_trace_block_unplug(blk_add_trace_unplug, NULL);
>  	unregister_trace_block_plug(blk_add_trace_plug, NULL);
> -	unregister_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
>  	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
>  	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
>  	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
> 

Otherwise, looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

