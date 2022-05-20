Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2731DC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 17:23:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-ZbD7VQpfMkyJFwTZ9kozmw-1; Fri, 20 May 2022 13:23:00 -0400
X-MC-Unique: ZbD7VQpfMkyJFwTZ9kozmw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87DA3185A7BA;
	Fri, 20 May 2022 17:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CC3D40D2820;
	Fri, 20 May 2022 17:22:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A5921947052;
	Fri, 20 May 2022 17:22:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DCE1194704C
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 17:22:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64B5F2166B2F; Fri, 20 May 2022 17:22:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 606E42166B25
 for <dm-devel@redhat.com>; Fri, 20 May 2022 17:22:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4501B811E76
 for <dm-devel@redhat.com>; Fri, 20 May 2022 17:22:54 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-jHS9urNyMhGtqw4mTtNAXg-1; Fri, 20 May 2022 13:22:52 -0400
X-MC-Unique: jHS9urNyMhGtqw4mTtNAXg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 050A01F899;
 Fri, 20 May 2022 17:22:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 83B7A13AF4;
 Fri, 20 May 2022 17:22:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 53QXH2rOh2KIPwAAMHmgww
 (envelope-from <dsterba@suse.cz>); Fri, 20 May 2022 17:22:50 +0000
Date: Fri, 20 May 2022 19:18:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220520171830.GR18596@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Pankaj Raghav <p.raghav@samsung.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
 Hannes Reinecke <hare@suse.de>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Luis Chamberlain <mcgrof@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "dsterba@suse.com" <dsterba@suse.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Keith Busch <kbusch@kernel.org>,
 Adam Manzanares <a.manzanares@samsung.com>
References: <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
 <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
 <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
 <be429864-09cb-e3fb-2afe-46a3453c4d73@opensource.wdc.com>
 <aee22e8a-b89b-378c-3d5b-238c1215b01d@samsung.com>
MIME-Version: 1.0
In-Reply-To: <aee22e8a-b89b-378c-3d5b-238c1215b01d@samsung.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: Mike Snitzer <snitzer@redhat.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dsterba@suse.com" <dsterba@suse.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Adam Manzanares <a.manzanares@samsung.com>, Christoph Hellwig <hch@lst.de>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Keith Busch <kbusch@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 "axboe@kernel.dk" <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 20, 2022 at 11:30:09AM +0200, Pankaj Raghav wrote:
> On 5/20/22 08:41, Damien Le Moal wrote:
> >> Note that for F2FS there is no blocker. Jaegeuk picked the initial
> >> patches, and he agreed to add native support.
> > 
> > And until that is done, f2fs will not work with these new !po2 devices...
> > Having the new dm will avoid that support fragmentation which I personally
> > really dislike. With the new dm, we can keep support for *all* zoned block
> > devices, albeit needing a different setup depending on the device. That is
> > not nice at all but at least there is a way to make things work continuously.
> 
> I see that many people in the community feel it is better to target the
> dm layer for the initial support of npo2 devices. I can give it a shot
> and maintain a native out-of-tree support for FSs for npo2 devices and
> merge it upstream as we see fit later.

Some of the changes from your patchset are cleanups or abstracting the
alignment and zone calculations, so this can be merged to minimize the
out of tree code.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

