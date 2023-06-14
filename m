Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32009EB64D8
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686755535;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Gi8vETQKrpsdwWlmgtS5G9sVIJK8h9FqJKl5qJZQYHE=;
	b=LoV2Sxoc0RMmJXwg2d7aUhQXC8sO3x9FiEZjLinHaUYWHnF/5jJ4fh36+MEIl6JxSmN2NN
	JZWOc4JkY8bz6zmNJZHTj646kth5vto9sOmu72Kdrwxr4KUK2oVs9XMYcQochT3ECHEW89
	ycQdaQGaFcpjXwmDAmN4O85wfN3LTtI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-vHR8QM1hNu6UvhG8koTz3A-1; Wed, 14 Jun 2023 11:12:11 -0400
X-MC-Unique: vHR8QM1hNu6UvhG8koTz3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B6C63811F36;
	Wed, 14 Jun 2023 15:12:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57A139E9F;
	Wed, 14 Jun 2023 15:12:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2578C19459F1;
	Wed, 14 Jun 2023 15:12:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E5B09194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 15:12:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C373940C20F6; Wed, 14 Jun 2023 15:12:03 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B559E40C20F4;
 Wed, 14 Jun 2023 15:12:03 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id A0A8130C2C07; Wed, 14 Jun 2023 15:12:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 9CF993FB7D; Wed, 14 Jun 2023 17:12:03 +0200 (CEST)
Date: Wed, 14 Jun 2023 17:12:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
In-Reply-To: <91f1ebed-fe93-4cd8-906a-2681313e98f5@moroto.mountain>
Message-ID: <6937f8a2-0b0-8ce0-8914-1eac5aa854c1@redhat.com>
References: <91f1ebed-fe93-4cd8-906a-2681313e98f5@moroto.mountain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [bug report] dm flakey: clone pages on write bio
 before corrupting them
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
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I don't get it what the problem is. This seems like a false positive.



On Wed, 14 Jun 2023, Dan Carpenter wrote:

> Hello Mikulas Patocka,
> 
> The patch 90ed93c305a0: "dm flakey: clone pages on write bio before
> corrupting them" from May 1, 2023, leads to the following Smatch
> static checker warning:
> 
> 	drivers/md/dm.c:1157 clone_endio()
> 	warn: passing freed memory 'ti'
> 
> drivers/md/dm.c
>     1105 static void clone_endio(struct bio *bio)
>     1106 {
>     1107         blk_status_t error = bio->bi_status;
>     1108         struct dm_target_io *tio = clone_to_tio(bio);
>     1109         struct dm_target *ti = tio->ti;
>     1110         dm_endio_fn endio = ti->type->end_io;
>     1111         struct dm_io *io = tio->io;
>     1112         struct mapped_device *md = io->md;
>     1113 
>     1114         if (unlikely(error == BLK_STS_TARGET)) {
>     1115                 if (bio_op(bio) == REQ_OP_DISCARD &&
>     1116                     !bdev_max_discard_sectors(bio->bi_bdev))
>     1117                         disable_discard(md);
>     1118                 else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
>     1119                          !bdev_write_zeroes_sectors(bio->bi_bdev))
>     1120                         disable_write_zeroes(md);
>     1121         }
>     1122 
>     1123         if (static_branch_unlikely(&zoned_enabled) &&
>     1124             unlikely(bdev_is_zoned(bio->bi_bdev)))
>     1125                 dm_zone_endio(io, bio);
>     1126 
>     1127         if (endio) {
>     1128                 int r = endio(ti, bio, &error);
>
> clone_endio() from drivers/md/dm-flakey.c frees "ti".  (Yes, I get
> that "flakey" in the filename means it is supposed to crash but
> presumably not in this way).

Here we call "endio", not "clone_endio". "endio" points to "flakey_end_io" 
and it doesn't free the "ti" structure. It possibly corrupts the read data 
and always return DM_ENDIO_DONE.

clone_endio() in dm-flakey.c calls bio_endio(), bio_endio() calls 
bi_endio, bi_endio points to clone_endio() in dm.c and clone_endio() in 
dm.c decrements the reference count and when the count goes to 0, "ti" may 
be freed.

There are two clone_endio functions, one in dm.c and one in dm-flakey.c. 
Perhaps the static analysis tool mixed them up.

>     1129 
>     1130                 switch (r) {
>     1131                 case DM_ENDIO_REQUEUE:
>     1132                         if (static_branch_unlikely(&zoned_enabled)) {
>     1133                                 /*
>     1134                                  * Requeuing writes to a sequential zone of a zoned
>     1135                                  * target will break the sequential write pattern:
>     1136                                  * fail such IO.
>     1137                                  */
>     1138                                 if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>     1139                                         error = BLK_STS_IOERR;
>     1140                                 else
>     1141                                         error = BLK_STS_DM_REQUEUE;
>     1142                         } else
>     1143                                 error = BLK_STS_DM_REQUEUE;
>     1144                         fallthrough;
>     1145                 case DM_ENDIO_DONE:
>     1146                         break;
>     1147                 case DM_ENDIO_INCOMPLETE:
>     1148                         /* The target will handle the io */
>     1149                         return;
>     1150                 default:
>     1151                         DMCRIT("unimplemented target endio return value: %d", r);
>     1152                         BUG();
>     1153                 }
>     1154         }
>     1155 
>     1156         if (static_branch_unlikely(&swap_bios_enabled) &&
> --> 1157             unlikely(swap_bios_limit(ti, bio)))
> 
> Use after free.

There is a reference on the "io" structure held at this point, so "ti" 
cannot be freed here. We will drop the reference later with 
dm_io_dec_pending().

>     1158                 up(&md->swap_bios_semaphore);
>     1159 
>     1160         free_tio(bio);
>     1161         dm_io_dec_pending(io, error);

When we drop the last reference with "dm_io_dec_pending", "ti" may be 
freed. But "dm_io_dec_pending" is the last statement in this function, so 
this should be safe.

dm_io_dec_pending calls __dm_io_dec_pending, there it goes to 
dm_io_complete and __dm_io_complete, there it decrements the in-use 
counter with this_cpu_dec - at this point, "ti" may be freed. But the code 
at this point doesn't access the "ti" variable at all.

Mikulas

>     1162 }
> 
> regards,
> dan carpenter
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

