Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D941C2D0E4
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 12:45:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A17BE22245
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 12:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A17BE22245
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532--onp2JtPOzKAeQ15BM3bpg-1; Fri, 27 Nov 2020 07:45:53 -0500
X-MC-Unique: -onp2JtPOzKAeQ15BM3bpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2114A805EF8;
	Fri, 27 Nov 2020 12:45:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7AA56085D;
	Fri, 27 Nov 2020 12:45:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ECD814A7C6;
	Fri, 27 Nov 2020 12:45:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ARCjj0N015568 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 07:45:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0DFA22166B2A; Fri, 27 Nov 2020 12:45:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08ECC2166B28
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 12:45:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7F058007DF
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 12:45:42 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-196-8WzGRZZnNzqUaos0bR50Dg-1;
	Fri, 27 Nov 2020 07:45:40 -0500
X-MC-Unique: 8WzGRZZnNzqUaos0bR50Dg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 280CAABD7;
	Fri, 27 Nov 2020 12:45:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 4AC6D1E1318; Fri, 27 Nov 2020 13:45:37 +0100 (CET)
Date: Fri, 27 Nov 2020 13:45:37 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201127124537.GC27162@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-38-hch@lst.de>
	<20201126182219.GC422@quack2.suse.cz>
	<20201127094842.GA15984@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201127094842.GA15984@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Chao Yu <yuchao0@huawei.com>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 37/44] block: switch partition lookup to use
 struct block_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri 27-11-20 10:48:42, Christoph Hellwig wrote:
> On Thu, Nov 26, 2020 at 07:22:19PM +0100, Jan Kara wrote:
> > On Thu 26-11-20 14:04:15, Christoph Hellwig wrote:
> > >  struct hd_struct *disk_get_part(struct gendisk *disk, int partno)
> > >  {
> > > -	struct hd_struct *part;
> > > +	struct block_device *part;
> > >  
> > >  	rcu_read_lock();
> > >  	part = __disk_get_part(disk, partno);
> > > -	if (part)
> > > -		get_device(part_to_dev(part));
> > > -	rcu_read_unlock();
> > > +	if (!part) {
> > > +		rcu_read_unlock();
> > > +		return NULL;
> > > +	}
> > >  
> > > -	return part;
> > > +	get_device(part_to_dev(part->bd_part));
> > > +	rcu_read_unlock();
> > > +	return part->bd_part;
> > >  }
> > 
> > This is not directly related to this particular patch but I'm wondering:
> > What prevents say del_gendisk() from racing with disk_get_part(), so that
> > delete_partition() is called just after we fetched 'part' pointer and the
> > last 'part' kobject ref is dropped before disk_get_part() calls
> > get_device()? I don't see anything preventing that and so we'd hand out
> > 'part' that is soon to be freed (after RCU grace period expires).
> 
> At this point the hd_struct is already allocated together with the
> block_device, and thus only freed after the last block_device reference
> goes away plus the inode freeing RCU grace period.  So the device model
> ref to part is indeed gone, but that simply does not matter any more.

Well, but once device model ref to part is gone, we're going to free the
bdev inode ref as well. Thus there's nothing which pins the bdev containing
hd_struct?

But now as I'm thinking about it you later switch the device model reference
to just pure inode reference and use igrab() which will reliably return
NULL if the inode is on it's way to be destroyed so probably we are safe in
the final state.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

