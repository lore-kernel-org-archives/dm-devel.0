Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63506C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:47:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C58F86101E
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C58F86101E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-jy3vIc7BOICRUEID9Fr_0w-1; Mon, 19 Apr 2021 06:47:24 -0400
X-MC-Unique: jy3vIc7BOICRUEID9Fr_0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 414AC5B364;
	Mon, 19 Apr 2021 10:47:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DCF35C3DF;
	Mon, 19 Apr 2021 10:47:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E56CC1806D19;
	Mon, 19 Apr 2021 10:47:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GGXfYt014914 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 12:33:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E6B0202146A; Fri, 16 Apr 2021 16:33:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2855020FD3D1
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 16:33:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18331100DE77
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 16:33:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-249-1LEw5uBZO9C26IC9S8JXjQ-1;
	Fri, 16 Apr 2021 12:33:36 -0400
X-MC-Unique: 1LEw5uBZO9C26IC9S8JXjQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1C135B1E8;
	Fri, 16 Apr 2021 16:19:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
	id 22C74DA790; Fri, 16 Apr 2021 18:17:21 +0200 (CEST)
Date: Fri, 16 Apr 2021 18:17:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Damien Le Moal <damien.lemoal@wdc.com>
Message-ID: <20210416161720.GA7604@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Damien Le Moal <damien.lemoal@wdc.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-4-damien.lemoal@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20210416030528.757513-4-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 19 Apr 2021 06:46:06 -0400
Cc: Jens Axboe <axboe@kernel.dk>, Naohiro Aota <naohiro.aota@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	David Sterba <dsterba@suse.com>, dm-devel@redhat.com,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 3/4] btrfs: zoned: fail mount if the device
 does not support zone append
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: dsterba@suse.cz
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 16, 2021 at 12:05:27PM +0900, Damien Le Moal wrote:
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> For zoned btrfs, zone append is mandatory to write to a sequential write
> only zone, otherwise parallel writes to the same zone could result in
> unaligned write errors.
> 
> If a zoned block device does not support zone append (e.g. a dm-crypt
> zoned device using a non-NULL IV cypher), fail to mount.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Added to misc-next, thanks. I'll queue it for 5.13, it's not an urgent
fix for 5.12 release but i'll tag it as stable so it'll apear in 5.12.x
later.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

