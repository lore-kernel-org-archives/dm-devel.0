Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDC3C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  6 May 2022 10:05:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-UFnMeMLJPcK7yzpQlUKvGQ-1; Fri, 06 May 2022 06:05:16 -0400
X-MC-Unique: UFnMeMLJPcK7yzpQlUKvGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49A6F2999B43;
	Fri,  6 May 2022 10:05:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4DA8400F75F;
	Fri,  6 May 2022 10:05:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90FA71947057;
	Fri,  6 May 2022 10:05:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4FF1C1947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 10:05:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3BF5714609DD; Fri,  6 May 2022 10:05:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 37FDB1460E56
 for <dm-devel@redhat.com>; Fri,  6 May 2022 10:05:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 201E38039D7
 for <dm-devel@redhat.com>; Fri,  6 May 2022 10:05:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-FQVf0XL0MW61gg2xNpsoQg-1; Fri, 06 May 2022 06:05:09 -0400
X-MC-Unique: FQVf0XL0MW61gg2xNpsoQg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 091F51F8BD;
 Fri,  6 May 2022 10:05:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6321513A1B;
 Fri,  6 May 2022 10:05:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id uw3nFtPydGJYbwAAMHmgww
 (envelope-from <dsterba@suse.cz>); Fri, 06 May 2022 10:05:07 +0000
Date: Fri, 6 May 2022 12:00:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220506100054.GZ18596@suse.cz>
Mail-Followup-To: dsterba@suse.cz, Pankaj Raghav <p.raghav@samsung.com>,
 jaegeuk@kernel.org, hare@suse.de, dsterba@suse.com, axboe@kernel.dk,
 hch@lst.de, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 bvanassche@acm.org, linux-fsdevel@vger.kernel.org,
 matias.bjorling@wdc.com, Jens Axboe <axboe@fb.com>,
 gost.dev@samsung.com, jonathan.derrick@linux.dev,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-kernel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alasdair Kergon <agk@redhat.com>,
 linux-block@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Keith Busch <kbusch@kernel.org>, linux-btrfs@vger.kernel.org
References: <CGME20220506081106eucas1p181e83ef352eb8bfb1752bee0cf84020f@eucas1p1.samsung.com>
 <20220506081105.29134-1-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220506081105.29134-1-p.raghav@samsung.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v3 00/11] support non power of 2 zoned devices
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com, hch@lst.de,
 Alasdair Kergon <agk@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 bvanassche@acm.org, gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 jonathan.derrick@linux.dev, Chaitanya Kulkarni <kch@nvidia.com>,
 snitzer@kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Jens Axboe <axboe@fb.com>, dsterba@suse.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, linux-fsdevel@vger.kernel.org,
 Johannes Thumshirn <jth@kernel.org>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 06, 2022 at 10:10:54AM +0200, Pankaj Raghav wrote:
> - Open issue:
> * btrfs superblock location for zoned devices is expected to be in 0,
>   512GB(mirror) and 4TB(mirror) in the device. Zoned devices with po2
>   zone size will naturally align with these superblock location but non
>   po2 devices will not align with 512GB and 4TB offset.
> 
>   The current approach for npo2 devices is to place the superblock mirror
>   zones near   512GB and 4TB that is **aligned to the zone size**.

I don't like that, the offsets have been chosen so the values are fixed
and also future proof in case the zone size increases significantly. The
natural alignment of the pow2 zones makes it fairly trivial.

If I understand correctly what you suggest, it would mean that if zone
is eg. 5G and starts at 510G then the superblock should start at 510G,
right? And with another device that has 7G zone size the nearest
multiple is 511G. And so on.

That makes it all less predictable, depending on the physical device
constraints that are affecting the logical data structures of the
filesystem. We tried to avoid that with pow2, the only thing that
depends on the device is that the range from the super block offsets is
always 2 zones.

I really want to keep the offsets for all zoned devices the same and
adapt the code that's handling the writes. This is possible with the
non-pow2 too, the first write is set to the expected offset, leaving the
beginning of the zone unused.

>   This
>   is of no issue for normal operation as we keep track where the superblock
>   mirror are placed but this can cause an issue with recovery tools for
>   zoned devices as they expect mirror superblock to be in 512GB and 4TB.

Yeah the tools need to be updated, btrfs-progs and suite of blk* in
util-linux.

>   Note that ATM, recovery tools such as `btrfs check` does not work for
>   image dumps for zoned devices even for po2 zone sizes.

I thought this worked, but if you find something that does not please
report that to Johannes or Naohiro.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

