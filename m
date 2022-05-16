Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8B9C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 22:02:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-_FikipgWM8iV19HTHC-BaA-1; Mon, 16 May 2022 18:02:53 -0400
X-MC-Unique: _FikipgWM8iV19HTHC-BaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02F6D85A5BE;
	Mon, 16 May 2022 22:02:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB663154D8CF;
	Mon, 16 May 2022 22:02:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FE0D1947059;
	Mon, 16 May 2022 22:02:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D70611947055
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 22:02:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96B8D154D8D8; Mon, 16 May 2022 22:02:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92CC0154D8CF
 for <dm-devel@redhat.com>; Mon, 16 May 2022 22:02:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C561C0F685
 for <dm-devel@redhat.com>; Mon, 16 May 2022 22:02:48 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-1dmQyOm1NPWmnV9nfFS5nQ-1; Mon, 16 May 2022 18:02:46 -0400
X-MC-Unique: 1dmQyOm1NPWmnV9nfFS5nQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 795551F939;
 Mon, 16 May 2022 22:02:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 102A313ADC;
 Mon, 16 May 2022 22:02:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id w1/AAgXKgmLnQAAAMHmgww
 (envelope-from <dsterba@suse.cz>); Mon, 16 May 2022 22:02:45 +0000
Date: Mon, 16 May 2022 23:58:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220516215826.GZ18596@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Pankaj Raghav <p.raghav@samsung.com>,
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 pankydev8@gmail.com, dsterba@suse.com, hch@lst.de,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, jiangbo.365@bytedance.com,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999@eucas1p2.samsung.com>
 <20220516165416.171196-6-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220516165416.171196-6-p.raghav@samsung.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 05/13] btrfs: zoned: Cache superblock
 location in btrfs_zoned_device_info
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
Cc: axboe@kernel.dk, pankydev8@gmail.com, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com,
 hch@lst.de, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 16, 2022 at 06:54:08PM +0200, Pankaj Raghav wrote:
> Instead of calculating the superblock location every time, cache the
> superblock zone location in btrfs_zoned_device_info struct and use it to
> locate the zone index.
> 
> The functions such as btrfs_sb_log_location_bdev() and
> btrfs_reset_sb_log_zones() which work directly on block_device shall
> continue to use the sb_zone_number because btrfs_zoned_device_info
> struct might not have been initialized at that point.
> 
> This patch will enable non power-of-2 zoned devices to not perform
> division to lookup superblock and its mirror location.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/btrfs/zoned.c | 13 +++++++++----
>  fs/btrfs/zoned.h |  1 +
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 06f22c021..e8c7cebb2 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -511,6 +511,11 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>  			   max_active_zones - nactive);
>  	}
>  
> +	/* Cache the sb zone number */
> +	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
> +		zone_info->sb_zone_location[i] =
> +			sb_zone_number(zone_info->zone_size_shift, i);
> +	}

I don't think we need to cache the value right now, it's not in any hot
path and call to bdev_zone_no is relatively cheap (only dereferencing a
few pointers, all in-memory values).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

