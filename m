Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27AEC64E90
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 14:57:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0756F20719
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 14:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0756F20719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-MJ7fGejxPw6GJONmDyzBdg-1; Mon, 30 Nov 2020 09:57:02 -0500
X-MC-Unique: MJ7fGejxPw6GJONmDyzBdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C28CC18C8C06;
	Mon, 30 Nov 2020 14:56:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8196B60C64;
	Mon, 30 Nov 2020 14:56:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49F021809CA0;
	Mon, 30 Nov 2020 14:56:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUEq0Bm019061 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 09:52:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4DF361111A51; Mon, 30 Nov 2020 14:52:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48E4D1111A50
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:51:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE114858287
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:51:57 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-344-1IDdYRajMBa0WF4_vZ0Qww-1;
	Mon, 30 Nov 2020 09:51:53 -0500
X-MC-Unique: 1IDdYRajMBa0WF4_vZ0Qww-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C4A86736F; Mon, 30 Nov 2020 15:51:50 +0100 (CET)
Date: Mon, 30 Nov 2020 15:51:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Message-ID: <20201130145150.GA24694@lst.de>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-31-hch@lst.de>
	<20201130094421.GD11250@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201130094421.GD11250@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Chao Yu <yuchao0@huawei.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 30/45] block: remove the nr_sects field in
 struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 30, 2020 at 10:44:21AM +0100, Jan Kara wrote:
> I know I'm like a broken record about this but I still don't understand
> here... I'd expect the new code to be:
> 
> 	if (size == capacity ||
> 	    (disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
> 		return false;
> 	pr_info("%s: detected capacity change from %lld to %lld\n",
> 		disk->disk_name, size, capacity);
> +	if (!capacity || !size)
> +		return false;
> 	kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
> 	return true;
> 
> At least that would be equivalent to the original functionality of
> set_capacity_and_notify(). And if you indeed intend to change when
> "RESIZE=1" events are sent, then I'd expect an explanation in the changelog
> why this cannot break userspace (I remember we've already broken some udev
> rules in the past by generating unexpected events and we had to revert
> those changes in the partition code so I'm more careful now). The rest of
> the patch looks good to me.

I explained that I think the GENHD_FL_UP is the more useful one here in
reply to your last comment.   If the size changes to or from 0 during
runtime we probably do want an event.

But I'll add your hunk for now and we can discuss this separately.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

