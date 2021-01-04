Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45A5C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:38:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24B9621919
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24B9621919
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609789117;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WUFbbgQacxLR3u4v2SsvAL6MpvEcJObqAbrTKsgG+BE=;
	b=ChP0HY4MlIs2avvVFy1tjPYi2InGaz5PN1WNshVbgb98dU3vfqk9CAAsxBmMs1QPmpclLa
	sOwOrnLhfSjU6bILPS+6nWS7dAy5/IbKOB7X3e84J6LN8PQqoK7ErNCNtQK7ocI+Dad0lI
	sn0NQAvYcJ9gqWXl9PiAH/evhz808JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-TjmMZHDwM0Kmsram-A1qZw-1; Mon, 04 Jan 2021 14:38:35 -0500
X-MC-Unique: TjmMZHDwM0Kmsram-A1qZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03AF3107ACE6;
	Mon,  4 Jan 2021 19:38:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D03DC277C3;
	Mon,  4 Jan 2021 19:38:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4394F180954D;
	Mon,  4 Jan 2021 19:38:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104JcRFg027413 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 14:38:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C8CC27086C; Mon,  4 Jan 2021 19:38:27 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CBC377710;
	Mon,  4 Jan 2021 19:38:24 +0000 (UTC)
Date: Mon, 4 Jan 2021 14:38:23 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Stephan =?iso-8859-1?Q?B=E4rwolf?= <stephan@matrixstorm.com>
Message-ID: <20210104193823.GA3482@redhat.com>
References: <fddbff8b-a7b5-ec89-9e60-d0b35940d117@matrixstorm.com>
MIME-Version: 1.0
In-Reply-To: <fddbff8b-a7b5-ec89-9e60-d0b35940d117@matrixstorm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-raid: set discard_granularity non-zero if possible
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16 2020 at  2:53pm -0500,
Stephan B=E4rwolf <stephan@matrixstorm.com> wrote:

> Hi
>=20
> I hope this address is the right place for this patch.
> It is supposed to fix the triggering of block/blklib.c:51 WARN_ON_ONCE(..=
) when using LVM2 raid1 with SSD-PVs.
> Since commit b35fd7422c2f8e04496f5a770bd4e1a205414b3f and without this pa=
tchthere are tons of printks logging "Error: discard_granularity is 0." to =
kmsg.
> Also there is no discard/TRIM happening anymore...
>=20
> This is a rough patch for WARNING-issue
>=20
> "block/blk-lib.c:51 __blkdev_issue_discard+0x1f6/0x250"
> [...] "Error: discard_granularity is 0." [...]
> introduced in commit b35fd7422c2f8e04496f5a770bd4e1a205414b3f
> ("block: check queue's limits.discard_granularity in __blkdev_issue_disca=
rd()")
>=20
> in conjunction with LVM2 raid1 volumes on discardable (SSD) backing.
> It seems until now, LVM-raid1 reported "discard_granularity" as 0,
> as well as "max_discard_sectors" as 0. (see "lsblk --discard").
>=20
> The idea here is to fix the issue by calculating "max_discard_sectors"
> as the minimum over all involved block devices. (We use the meta-data
> for this to work here.)
> For calculating the "discard_granularity" we would have to calculate the
> lcm (least common multiple) of all discard_granularities of all involved
> block devices and finally round up to next power of 2.
>=20
> However, since all "discard_granularity" are powers of 2, this algorithm
> will simplify to just determining the maximum and filtering for "0"-cases=
.
>=20
> Signed-off-by: Stephan Baerwolf <stephan@matrixstorm.com>
> ---
> drivers/md/dm-raid.c | 32 ++++++++++++++++++++++++++++++--
> 1 file changed, 30 insertions(+), 2 deletions(-)
>=20
>=20
>=20

> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 8d2b835d7a10..4c769fd93ced 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3734,8 +3734,36 @@ static void raid_io_hints(struct dm_target *ti, st=
ruct queue_limits *limits)
>  =09 * RAID0/4/5/6 don't and process large discard bios properly.
>  =09 */
>  =09if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
> -=09=09limits->discard_granularity =3D chunk_size_bytes;
> -=09=09limits->max_discard_sectors =3D rs->md.chunk_sectors;

The above should be: if (rs_is_raid0(rs) || rs_is_raid10(rs)) {

And this was previous;y fixed with commit e0910c8e4f87bb9 but later
reverted due to various late MD discard reverts at the end of the 5.10
release.

So all said, I think the the proper fix (without all sorts of
open-coding to get limits to properly stack) is to change
raid_io_hints()'s rs_is_raid1() call to rs_is_raid0().

I'll get a fix queued up.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

