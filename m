Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D75BC04AB8
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695232508;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lVel72euKv2YmKQRi4SW4JnxGTjGuVJVeDsg0Ay1i/A=;
	b=hcn1T84IBXriucI6IU93pe3VjkGV7uxq/nrzdAwv01pmppmjlx8IdZNZykYYm6qLqPnWvu
	0F8f5hn56SdnGptsvaAmrPTYX9bixo/FxuZm+z9uRH8kGjiXc44u7kX5HwYN7gh8qfcsvi
	6IewD1l1Bxjz/9xckLnUq3+LGZGhUOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-Y4aM5nWPMC-5Gy50FiW-Cg-1; Wed, 20 Sep 2023 13:55:04 -0400
X-MC-Unique: Y4aM5nWPMC-5Gy50FiW-Cg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DFDB8039C8;
	Wed, 20 Sep 2023 17:54:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 273DE40C2070;
	Wed, 20 Sep 2023 17:54:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2608D1946594;
	Wed, 20 Sep 2023 17:54:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF25E194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 17:54:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 766462156701; Wed, 20 Sep 2023 17:54:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F10A2156A27
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 17:54:11 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C48A800883
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 17:54:11 +0000 (UTC)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com
 [209.85.222.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-t4x4ccudPlOxYwXFgIbzgQ-1; Wed, 20 Sep 2023 13:54:08 -0400
X-MC-Unique: t4x4ccudPlOxYwXFgIbzgQ-1
Received: by mail-qk1-f181.google.com with SMTP id
 af79cd13be357-76f08e302a1so1595685a.1
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 10:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695232448; x=1695837248;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=sMUjbe6jAZJm7ZNBEI2GzRHbQh/3nvCFD3HmyB44o2Y=;
 b=T/bolu8AmNvswZQLSZoe+C3/hFtJpXvIV3SazZhrdylyeGpD+UMwLh4EHXII7SfR8w
 8Oe5CirRMHeSwCmHesiK8MIHCwuNRrwkYiVpWVzYiCj+mGFKJKFt2LJgm4IE9MJaPwhr
 BLihUMkuPpqNrACpj63gRCrnRrtAkOkWOuOdZwhV0k2dt3tGzGx4rg2jgEGNhW5CD4H8
 t1YHRm9+TDc/jdiWCSj6GDWp28dYKrQWRi5gpsMYrlMr9/t9MaBP/zuTEpaqvbPWrkuu
 D87s9mNYcyhJsA2zknPBOcLYdSz02LAzcKfCdzqM6P/ubj9Un9A/SPXsaSbhiL0BZpZB
 +woA==
X-Gm-Message-State: AOJu0YxbIJK+5SyJW/WTMXc+WKV5O/arM/wl2f6JsZQiNXM2c+RIahTh
 cJbzFB2lelpOPkSqsEeq4mBy+XA=
X-Google-Smtp-Source: AGHT+IEak9SOm9Pps/WpGIUms89fzDOBjAMtv3am2s1xZcN9i58NixmmmksMVtNi4wnk9/5qJ6K1AQ==
X-Received: by 2002:a05:620a:3890:b0:76f:19fd:5058 with SMTP id
 qp16-20020a05620a389000b0076f19fd5058mr2422766qkn.78.1695232447730; 
 Wed, 20 Sep 2023 10:54:07 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 d21-20020a05620a159500b007710052789dsm4986047qkk.94.2023.09.20.10.54.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Sep 2023 10:54:07 -0700 (PDT)
Date: Wed, 20 Sep 2023 13:54:05 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Message-ID: <ZQsxvY12z+/yYcR6@redhat.com>
References: <20230920105119.21276-1-pchelkin@ispras.ru>
 <c7818967-1fea-45da-9713-20de4bcb1c44@suse.de>
 <vdtvo2av3upya6mugjyiqo2hfnn6q4dpofoku6rvrtgmycgbrp@scpcnu3ta7ch>
MIME-Version: 1.0
In-Reply-To: <vdtvo2av3upya6mugjyiqo2hfnn6q4dpofoku6rvrtgmycgbrp@scpcnu3ta7ch>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm-zoned: free dmz->ddev array in
 dmz_put_zoned_device
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
Cc: lvc-project@linuxtesting.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
 Alexey Khoroshilov <khoroshilov@ispras.ru>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 20 2023 at 10:35P -0400,
Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> On 23/09/20 04:06PM, Hannes Reinecke wrote:
> > On 9/20/23 12:51, Fedor Pchelkin wrote:
> > > Commit 4dba12881f88 ("dm zoned: support arbitrary number of devices")
> > > made the pointers to additional zoned devices to be stored in a
> > > dynamically allocated dmz->ddev array. However, this array is not freed.
> > > 
> > > Free it when cleaning up zoned device information inside
> > > dmz_put_zoned_device(). Assigning NULL to dmz->ddev elements doesn't make
> > > sense there as they are not supposed to be reused later and the whole dmz
> > > target structure is being cleaned anyway.
> > > 
> > > Found by Linux Verification Center (linuxtesting.org).
> > > 
> > > Fixes: 4dba12881f88 ("dm zoned: support arbitrary number of devices")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> > > ---
> > >   drivers/md/dm-zoned-target.c | 8 +++-----
> > >   1 file changed, 3 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> > > index ad8e670a2f9b..e25cd9db6275 100644
> > > --- a/drivers/md/dm-zoned-target.c
> > > +++ b/drivers/md/dm-zoned-target.c
> > > @@ -753,12 +753,10 @@ static void dmz_put_zoned_device(struct dm_target *ti)
> > >   	struct dmz_target *dmz = ti->private;
> > >   	int i;
> > > -	for (i = 0; i < dmz->nr_ddevs; i++) {
> > > -		if (dmz->ddev[i]) {
> > > +	for (i = 0; i < dmz->nr_ddevs; i++)
> > > +		if (dmz->ddev[i])
> > >   			dm_put_device(ti, dmz->ddev[i]);
> > > -			dmz->ddev[i] = NULL;
> > > -		}
> > > -	}
> > > +	kfree(dmz->ddev);
> > >   }
> > >   static int dmz_fixup_devices(struct dm_target *ti)
> > 
> > Hmm. I'm not that happy with it; dmz_put_zoned_device() is using dm_target
> > as an argument, whereas all of the functions surrounding the call sites is
> > using the dmz_target directly.
> > 
> > Mind to modify the function to use 'struct dmz_target' as an argument?
> 
> dm_target is required inside dmz_put_zoned_device() for dm_put_device()
> calls. I can't see a way for referencing it via dmz_target. Do you mean
> passing additional second argument like
>   dmz_put_zoned_device(struct dmz_target *dmz, struct dm_target *ti) ?

No, what you did is fine.  Not sure what Hannes is saying given only
passing dm_target has symmetry with dm_get_zoned_device (and
dmz_fixup_devices).

> BTW, I also think it can be renamed to dmz_put_zoned_devices().

I've renamed like you suggested and added a newline to
dmz_put_zoned_devices() and staged this fix in linux-next for
upstream inclusion before 6.6 final releases.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

