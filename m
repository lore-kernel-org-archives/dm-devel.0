Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2DFC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 11:26:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-NXofr3n-Ml6Rfyq5AJJP1A-1; Wed, 18 May 2022 07:26:08 -0400
X-MC-Unique: NXofr3n-Ml6Rfyq5AJJP1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0CB9101A52C;
	Wed, 18 May 2022 11:26:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 13F677AD5;
	Wed, 18 May 2022 11:26:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC7241947B8F;
	Wed, 18 May 2022 11:26:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EFEC1947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 11:26:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8580E1410DD5; Wed, 18 May 2022 11:26:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 81B9D1410DD9
 for <dm-devel@redhat.com>; Wed, 18 May 2022 11:26:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69A0D86B8A2
 for <dm-devel@redhat.com>; Wed, 18 May 2022 11:26:02 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-MZxB06oAOgG6Dq-vd5Ofcw-1; Wed, 18 May 2022 07:26:00 -0400
X-MC-Unique: MZxB06oAOgG6Dq-vd5Ofcw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 543261F921;
 Wed, 18 May 2022 11:25:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0BAF13A6D;
 Wed, 18 May 2022 11:25:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 38XzOcbXhGL8TgAAMHmgww
 (envelope-from <dsterba@suse.cz>); Wed, 18 May 2022 11:25:58 +0000
Date: Wed, 18 May 2022 13:21:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220518112140.GI18596@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Pankaj Raghav <p.raghav@samsung.com>,
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 pankydev8@gmail.com, dsterba@suse.com, hch@lst.de,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, jiangbo.365@bytedance.com,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165428eucas1p1374b5f9592db3ca6a6551aff975537ce@eucas1p1.samsung.com>
 <20220516165416.171196-8-p.raghav@samsung.com>
 <20220517123008.GC18596@twin.jikos.cz>
 <2b169f03-11d6-9989-84cb-821d67eb6cae@samsung.com>
MIME-Version: 1.0
In-Reply-To: <2b169f03-11d6-9989-84cb-821d67eb6cae@samsung.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 07/13] btrfs: zoned: use generic btrfs
 zone helpers to support npo2 zoned devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Reply-To: dsterba@suse.cz
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, pankydev8@gmail.com,
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, dsterba@suse.cz,
 linux-nvme@lists.infradead.org, jiangbo.365@bytedance.com,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com,
 hch@lst.de, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 18, 2022 at 11:40:22AM +0200, Pankaj Raghav wrote:
> On 2022-05-17 14:30, David Sterba wrote:
> > On Mon, May 16, 2022 at 06:54:10PM +0200, Pankaj Raghav wrote:
> >> @@ -1108,14 +1101,14 @@ int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
> >>  int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size)
> >>  {
> >>  	struct btrfs_zoned_device_info *zinfo = device->zone_info;
> >> -	const u8 shift = zinfo->zone_size_shift;
> >> -	unsigned long begin = start >> shift;
> >> -	unsigned long end = (start + size) >> shift;
> >> +	unsigned long begin = bdev_zone_no(device->bdev, start >> SECTOR_SHIFT);
> >> +	unsigned long end =
> >> +		bdev_zone_no(device->bdev, (start + size) >> SECTOR_SHIFT);
> > 
> > There are unsinged long types here though I'd rather see u64, better for
> > a separate patch. Fixed width types are cleaner here and in the zoned
> > code as there's always some conversion to/from sectors.
> > 
> Ok. I will probably send a separate patch to convert them to fix width
> types. Is it ok if I do it as a separate patch instead of including it
> in this series?

Yes, it's a cleanup for later, not directly introduced or affecting this
patchset. I've checked zoned.c, in btrfs_ensure_empty_zones it's the
only instance so it's not some widespread problem.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

