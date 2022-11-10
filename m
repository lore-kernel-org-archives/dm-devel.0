Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4506AC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Nov 2022 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668103782;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FYdbojdGwD/vMACItIUxTPvH7elKfpBO62BJaFDiOsw=;
	b=Ot4QXeiF8bi3jCS7HWgCDXwkDOejC2tOd0w9cyBE164M5k/f1BIdRauWsuIskeB5hY69u/
	SKPiaSC6jnYekH9exw5FRdWJAu3xfNlxn+BGoZ6SPHweM8nQ6DGGMD3/wfuwTy0myeAjac
	wwKjSr+bjcqNy5XcY+78yRpDQ2ibnJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-f-IiPBF0PdGSaXUTD2i3Ww-1; Thu, 10 Nov 2022 13:09:39 -0500
X-MC-Unique: f-IiPBF0PdGSaXUTD2i3Ww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0783585A5A6;
	Thu, 10 Nov 2022 18:09:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3051A4EA61;
	Thu, 10 Nov 2022 18:09:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A71F1946589;
	Thu, 10 Nov 2022 18:09:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DF291946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Nov 2022 18:09:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C335FC1908A; Thu, 10 Nov 2022 18:09:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBD50C15BA8
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:09:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A1F086EB63
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:09:26 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-AHAxGxC1OaS35Upp5wDZNA-1; Thu, 10 Nov 2022 13:09:23 -0500
X-MC-Unique: AHAxGxC1OaS35Upp5wDZNA-1
Received: by mail-qk1-f199.google.com with SMTP id
 bl21-20020a05620a1a9500b006fa35db066aso2650827qkb.19
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 10:09:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oJpaUXZfUlB2zojhzgL365muYK2UmjxnzEXrvNOaW04=;
 b=PGuFNF/OQr8p6mLMvjbZTvSlEyidDu+LrDzVjkggouxfEFtKf+NmGuQb5Nt7++Y6vw
 Fanfr8CLeOuRDuT+k2zB6Gv8wJ2Z2LuMRCGNlBEzrfFAx5c+piw8rWaaLP/HdveLQNa7
 Bx5wjTJyTkWMGZEwCgrowqOrJWu02N+kbbvLUv5/ZGN62ldUJcHgUYYne3MgfE/3WaJJ
 1k8OWR9irQFL4lEUyzVh/GkJTjzsV1/dZbGivpg+G0mAdSeOh36kJmuBdJZG2eCf1oaq
 XVnBBx+wxA888amw90GuikXlFDKp6CeiaDV5S/r8WzeC3eApmxF9Ln1gZYucJK+Oy4Hn
 jF/A==
X-Gm-Message-State: ACrzQf0KkOUIn2CT8nf1e8sUL5zcW/dy2le7+WasmziaNzhZ6XUVmS5B
 IMKbGJDh+PXBBgg3fD1jbJjKz9Yrd2oOl//Geeu/J6PlHHmxBJI/SsAZmmliGB8akgYgs8HtEGP
 L8DUMKVBfwORHOA==
X-Received: by 2002:a37:5384:0:b0:6f7:ee90:1618 with SMTP id
 h126-20020a375384000000b006f7ee901618mr48790841qkb.117.1668103762792; 
 Thu, 10 Nov 2022 10:09:22 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5dnq6GgptC+o7e+KGZwxOthgltgisvv0Njbkvz3EcHiNSuQIJcpYvAVh8c8Ov6XGOUjvPMkQ==
X-Received: by 2002:a37:5384:0:b0:6f7:ee90:1618 with SMTP id
 h126-20020a375384000000b006f7ee901618mr48790823qkb.117.1668103762489; 
 Thu, 10 Nov 2022 10:09:22 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 cn3-20020a05622a248300b003a5430ee366sm11477709qtb.60.2022.11.10.10.09.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 10:09:21 -0800 (PST)
Date: Thu, 10 Nov 2022 13:09:20 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y20+UNI0KV2VjUSi@redhat.com>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-6-hch@lst.de>
 <9b5b4c2a-6566-2fb4-d3ae-4904f0889ea0@huaweicloud.com>
 <20221109082645.GA14093@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221109082645.GA14093@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 5/7] dm: track per-add_disk holder relations
 in DM
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 09 2022 at  3:26P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Nov 09, 2022 at 10:08:14AM +0800, Yu Kuai wrote:
> >> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> >> index 2917700b1e15c..7b0d6dc957549 100644
> >> --- a/drivers/md/dm.c
> >> +++ b/drivers/md/dm.c
> >> @@ -751,9 +751,16 @@ static struct table_device *open_table_device(struct mapped_device *md,
> >>   		goto out_free_td;
> >>   	}
> >>   -	r = bd_link_disk_holder(bdev, dm_disk(md));
> >> -	if (r)
> >> -		goto out_blkdev_put;
> >> +	/*
> >> +	 * We can be called before the dm disk is added.  In that case we can't
> >> +	 * register the holder relation here.  It will be done once add_disk was
> >> +	 * called.
> >> +	 */
> >> +	if (md->disk->slave_dir) {
> > If device_add_disk() or del_gendisk() can concurrent with this, It seems
> > to me that using 'slave_dir' is not safe.
> >
> > I'm not quite familiar with dm, can we guarantee that they can't
> > concurrent?
> 
> I assumed dm would not get itself into territory were creating /
> deleting the device could race with adding component devices, but
> digging deeper I can't find anything.  This could be done
> by holding table_devices_lock around add_disk/del_gendisk, but
> I'm not that familar with the dm code.
> 
> Mike, can you help out on this?

Maybe :/

Underlying component devices can certainly come and go at any
time. And there is no DM code that can, or should, prevent that. All
we can do is cope with unavailability of devices. But pretty sure that
isn't the question.

I'm unclear about the specific race in question:
if open_table_device() doesn't see slave_dir it is the first table
load. Otherwise, the DM device (and associated gendisk) shouldn't have
been torn down while a table is actively being loaded for it. But
_where_ the code lives, to ensure that, is also eluding me...

You could use a big lock (table_devices_lock) to disallow changes to
DM relations while loading the table. But I wouldn't think it needed
as long as the gendisk's lifecycle is protected vs table loads (or
other concurrent actions like table load vs dm device removal). Again,
more code inspection needed to page all this back into my head.

The concern for race aside:
I am concerned that your redundant bd_link_disk_holder() (first in
open_table_device and later in dm_setup_md_queue) will result in
dangling refcount (e.g. increase of 2 when it should only be by 1) --
given bd_link_disk_holder will gladly just bump its holder->refcnt if
bd_find_holder_disk() returns an existing holder. This would occur if
a DM table is already loaded (and DM device's gendisk exists) and a
new DM table is being loaded.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

