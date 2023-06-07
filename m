Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A327DC7EE29
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686140463;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+8iVasfHCyEWo6B+cxPkM6rJQDoclhuv+MhhLQlVGDU=;
	b=ZkBve9MJlhskJ1A3Cmv9LhUvSlUCNSgQwmBLNHlMTDv+rNd0jRXYs6Bwnl+nhbVR2Ng6Lk
	jPudfs/qEJiI6+GI/8H+u0nNIiWYzbz9Q+GsFIocj/3U+vfClaKKwR+EJxHRrhJXUn4cmB
	qU/M/ax/vQ++pR23BpVam5Elwl68ooo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-wH5VRhs3NFmDF-6Z0vyzGA-1; Wed, 07 Jun 2023 08:21:00 -0400
X-MC-Unique: wH5VRhs3NFmDF-6Z0vyzGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA415801585;
	Wed,  7 Jun 2023 12:20:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 983CC1121319;
	Wed,  7 Jun 2023 12:20:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8221F19451E5;
	Wed,  7 Jun 2023 12:20:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F230A19451C4
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 12:19:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1E7FC154D4; Wed,  7 Jun 2023 12:19:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA528C154D2
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:19:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF9E01C09A65
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:19:04 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-2cGXgKUbOhWvP6TC2Bsn6A-1; Wed,
 07 Jun 2023 08:19:03 -0400
X-MC-Unique: 2cGXgKUbOhWvP6TC2Bsn6A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 992EB219BF;
 Wed,  7 Jun 2023 12:19:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6987D13776;
 Wed,  7 Jun 2023 12:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ngODGbR1gGR3QAAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 07 Jun 2023 12:19:00 +0000
Message-ID: <30183892-dce6-6946-2f7a-1bc693a657a2@suse.de>
Date: Wed, 7 Jun 2023 14:19:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-9-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230606073950.225178-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 08/31] block: share code between
 disk_check_media_change and disk_force_media_change
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/6/23 09:39, Christoph Hellwig wrote:
> Factor the common logic between disk_check_media_change and
> disk_force_media_change into a helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/disk-events.c | 37 ++++++++++++++++---------------------
>   1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/block/disk-events.c b/block/disk-events.c
> index 8b1b63225738f8..06f325662b3494 100644
> --- a/block/disk-events.c
> +++ b/block/disk-events.c
> @@ -262,6 +262,18 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
>   	return pending;
>   }
>   
> +static bool __disk_check_media_change(struct gendisk *disk, unsigned int events)
> +{
> +	if (!(events & DISK_EVENT_MEDIA_CHANGE))
> +		return false;
> +
> +	if (__invalidate_device(disk->part0, true))
> +		pr_warn("VFS: busy inodes on changed media %s\n",
> +			disk->disk_name);
> +	set_bit(GD_NEED_PART_SCAN, &disk->state);
> +	return true;
> +}
> +
>   /**
>    * disk_check_media_change - check if a removable media has been changed
>    * @disk: gendisk to check
> @@ -274,18 +286,9 @@ static unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
>    */
>   bool disk_check_media_change(struct gendisk *disk)
>   {
> -	unsigned int events;
> -
> -	events = disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
> -				   DISK_EVENT_EJECT_REQUEST);
> -	if (!(events & DISK_EVENT_MEDIA_CHANGE))
> -		return false;
> -
> -	if (__invalidate_device(disk->part0, true))
> -		pr_warn("VFS: busy inodes on changed media %s\n",
> -			disk->disk_name);
> -	set_bit(GD_NEED_PART_SCAN, &disk->state);
> -	return true;
> +	return __disk_check_media_change(disk,
> +			disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
> +						DISK_EVENT_EJECT_REQUEST));

Can you move the call to disk_clear_events() out of the call to 
__disk_check_media_change()?
I find this pattern hard to read.

Cheers,

Hannes

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

