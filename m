Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ED5C49361
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 12:24:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4A846613EB
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 12:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A846613EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-kzvriW5nMFGNyqRaXw2Jrg-1; Fri, 18 Jun 2021 08:24:39 -0400
X-MC-Unique: kzvriW5nMFGNyqRaXw2Jrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 547D0802B7E;
	Fri, 18 Jun 2021 12:24:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E25C2E146;
	Fri, 18 Jun 2021 12:24:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 950F81809C99;
	Fri, 18 Jun 2021 12:24:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15ICOWlB029837 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Jun 2021 08:24:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 92068B6B4C; Fri, 18 Jun 2021 12:24:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C5B3D7B10
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 12:24:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE13180B914
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 12:24:29 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-523-f43g9NQZP2iy3cmZAG8g1Q-1; Fri, 18 Jun 2021 08:24:27 -0400
X-MC-Unique: f43g9NQZP2iy3cmZAG8g1Q-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	15ICNkLF003088; Fri, 18 Jun 2021 12:24:27 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qssar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Jun 2021 12:24:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	15ICFR5L139815; Fri, 18 Jun 2021 12:24:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3030.oracle.com with ESMTP id 396wawpfqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Jun 2021 12:24:26 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15ICOQxc157142;
	Fri, 18 Jun 2021 12:24:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserp3030.oracle.com with ESMTP id 396wawpfqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Jun 2021 12:24:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15ICOO4t028332;
	Fri, 18 Jun 2021 12:24:24 GMT
Received: from kadam (/102.222.70.252) by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Fri, 18 Jun 2021 12:24:24 +0000
Date: Fri, 18 Jun 2021 15:24:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: damien.lemoal@wdc.com
Message-ID: <20210618122417.GZ1901@kadam>
References: <YMyP68Q7tNnn+ZpQ@mwanda>
MIME-Version: 1.0
In-Reply-To: <YMyP68Q7tNnn+ZpQ@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: gdbMXDQRA18e-CefEMYOgInjHUfIFVqu
X-Proofpoint-GUID: gdbMXDQRA18e-CefEMYOgInjHUfIFVqu
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [bug report] dm: introduce zone append emulation
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 18, 2021 at 03:22:03PM +0300, Dan Carpenter wrote:
> Hello Damien Le Moal,
> 
> The patch bb37d77239af: "dm: introduce zone append emulation" from
> May 26, 2021, leads to the following static checker warning:
> 
> 	drivers/md/dm-zone.c:207 dm_zone_revalidate_cb()
> 	error: kvmalloc() only makes sense with GFP_KERNEL
> 
> drivers/md/dm-zone.c
>    179  static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>    180                                   void *data)
>    181  {
>    182          struct mapped_device *md = data;
>    183          struct request_queue *q = md->queue;
>    184  
>    185          switch (zone->type) {
>    186          case BLK_ZONE_TYPE_CONVENTIONAL:
>    187                  if (!q->conv_zones_bitmap) {
>    188                          q->conv_zones_bitmap =
>    189                                  kcalloc(BITS_TO_LONGS(q->nr_zones),
>    190                                          sizeof(unsigned long), GFP_NOIO);
>    191                          if (!q->conv_zones_bitmap)
>    192                                  return -ENOMEM;
>    193                  }
>    194                  set_bit(idx, q->conv_zones_bitmap);
>    195                  break;
>    196          case BLK_ZONE_TYPE_SEQWRITE_REQ:
>    197          case BLK_ZONE_TYPE_SEQWRITE_PREF:
>    198                  if (!q->seq_zones_wlock) {
>    199                          q->seq_zones_wlock =
>    200                                  kcalloc(BITS_TO_LONGS(q->nr_zones),
>    201                                          sizeof(unsigned long), GFP_NOIO);
>    202                          if (!q->seq_zones_wlock)
>    203                                  return -ENOMEM;
>    204                  }
>    205                  if (!md->zwp_offset) {
>    206                          md->zwp_offset =
>    207                                  kvcalloc(q->nr_zones, sizeof(unsigned int),
>    208                                           GFP_NOIO);
> 
> kvcalloc() does not respect the GFP_NOIO flag.
> 

Ugh, what I meant was kvcalloc() with the GFP_NOIO flag is the same as
calling kcalloc(), it won't vmalloc() the memory.

regards,
dan carpenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

