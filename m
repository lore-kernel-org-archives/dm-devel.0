Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85787C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 01:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649814206;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kxcpllgluNQtv+iIsn9LzfXcLXAGsBUx2tNoZ9Rs0go=;
	b=dP+nUI+2hHrqdNJLuIkhVC3r5j/6kV8WQpRSBow48xU+JPPBiEu53Wf33Q9DHQpSS0uJ6d
	J6QZqvvrbHjuM8sWCidzEEgJo56IPYXuQWuVyzebry4gnKbx7BzDDOpZMOZBfJFK4vTUNj
	ZqNGGwdxZYH2YtbWqKbwEpmjvoMKv7M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-gd1kuhHHOlWFhWbxQRGd8Q-1; Tue, 12 Apr 2022 21:43:23 -0400
X-MC-Unique: gd1kuhHHOlWFhWbxQRGd8Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ABA03802ACA;
	Wed, 13 Apr 2022 01:43:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAFD94229C1;
	Wed, 13 Apr 2022 01:43:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 70A971949763;
	Wed, 13 Apr 2022 01:43:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F60A1947BBE
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 01:43:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59CA940D2822; Wed, 13 Apr 2022 01:43:18 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE7AD40D2821;
 Wed, 13 Apr 2022 01:43:13 +0000 (UTC)
Date: Wed, 13 Apr 2022 09:43:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YlYqrC41lzT5c4gm@T590>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-4-ming.lei@redhat.com>
 <YlXhC1tHYYyCQxdI@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YlXhC1tHYYyCQxdI@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 3/8] dm: pass 'dm_io' instance to dm_io_acct
 directly
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12, 2022 at 04:28:59PM -0400, Mike Snitzer wrote:
> On Tue, Apr 12 2022 at  4:56P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > All the other 4 parameters are retrieved from the 'dm_io' instance, so
> > not necessary to pass all four to dm_io_acct().
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> Yeah, commit 0ab30b4079e103 ("dm: eliminate copying of dm_io fields in
> dm_io_dec_pending") could've gone further to do what you've done here
> in this patch.
> 
> But it stopped short because of the additional "games" associated with
> the late assignment of io->orig_bio that is in the dm-5.19 branch.

OK, I will rebase on dm-5.19, but IMO the idea of late assignment of
io->orig_bio isn't good, same with splitting one bio just for
accounting, things shouldn't be so tricky.


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

