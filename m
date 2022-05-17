Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B7CC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 11:55:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-L6HfKb5DOtaeHxwj9-dTTQ-1; Tue, 17 May 2022 07:55:48 -0400
X-MC-Unique: L6HfKb5DOtaeHxwj9-dTTQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E42633C02B75;
	Tue, 17 May 2022 11:55:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B2E9400F75D;
	Tue, 17 May 2022 11:55:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 95549194705F;
	Tue, 17 May 2022 11:55:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8895A1947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 11:55:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 529C340CF8F5; Tue, 17 May 2022 11:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D36540CF8F0
 for <dm-devel@redhat.com>; Tue, 17 May 2022 11:55:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D963899EC5
 for <dm-devel@redhat.com>; Tue, 17 May 2022 11:55:43 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-GOh4QbhdNzaqHwuBl7ZE3w-1; Tue, 17 May 2022 07:55:41 -0400
X-MC-Unique: GOh4QbhdNzaqHwuBl7ZE3w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 1FA761F8F7;
 Tue, 17 May 2022 11:55:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7A1D13305;
 Tue, 17 May 2022 11:55:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id nQDZKzuNg2JOAwAAMHmgww
 (envelope-from <dsterba@suse.cz>); Tue, 17 May 2022 11:55:39 +0000
Date: Tue, 17 May 2022 13:51:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20220517115121.GA18596@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Pankaj Raghav <p.raghav@samsung.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "dsterba@suse.com" <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9@eucas1p1.samsung.com>
 <20220516165416.171196-7-p.raghav@samsung.com>
 <PH0PR04MB741673F9764EFCA93F1932809BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <PH0PR04MB741673F9764EFCA93F1932809BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v4 06/13] btrfs: zoned: Make sb_zone_number
 function non power of 2 compatible
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>, "dsterba@suse.com" <dsterba@suse.com>,
 "hch@lst.de" <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
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

On Tue, May 17, 2022 at 06:53:40AM +0000, Johannes Thumshirn wrote:
> On 16/05/2022 18:54, Pankaj Raghav wrote:
> >  	/* Cache the sb zone number */
> >  	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
> >  		zone_info->sb_zone_location[i] =
> > -			sb_zone_number(zone_info->zone_size_shift, i);
> > +			sb_zone_number(bdev, i);
> 
> I think this easily fits on one line now, doesn't it? But given David's
> statement, it'll probably can go away anyways.

I agree that the formatting can be adjusted, but I'm never sure if I
should point it out during the phase of functional changes so it's fixed
in the next iteration as well, or not to point it out to avoid fixups
that would go away anyway. I think I've seen more, a styling pass will
be done anyway once we're close to the final version..

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

