Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3B4C04FEC
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695236739;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f2OACdHLf6NpWaCAOq/dYsHnx0amRgIgQGFN1YCrTYo=;
	b=hRTdPPfo0VR4IU5TUjLgZqgacgq2cCp/m1X3qjVoVZeFQgBjU9qa84qQbRe3s99RyWbNkj
	YAh1TzCOH9jtvSBwxq/vXsEO8vi967OEDa8SEgK/deki6DRAYNhu7C5wh0ZDecS6wpnp92
	s+eS4m7EY+nPEAHAFCjvmBMhDkrW6Xw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-82CSlUULM3mlFDC9P581wA-1; Wed, 20 Sep 2023 15:05:35 -0400
X-MC-Unique: 82CSlUULM3mlFDC9P581wA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7923814582;
	Wed, 20 Sep 2023 19:05:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AB0F40C6EC1;
	Wed, 20 Sep 2023 19:05:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 32B7E1946594;
	Wed, 20 Sep 2023 19:05:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 860F51946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 18:56:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4D9EC15BB8; Wed, 20 Sep 2023 18:56:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE0FDC154CA
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 18:56:41 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A7CB1C0171F
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 18:56:41 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-wx-5nk-6MUa1knvly3PWlA-1; Wed, 20 Sep 2023 14:56:39 -0400
X-MC-Unique: wx-5nk-6MUa1knvly3PWlA-1
Received: from localhost (unknown [46.242.14.200])
 by mail.ispras.ru (Postfix) with ESMTPSA id 32A5E40F1DFB;
 Wed, 20 Sep 2023 18:56:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 32A5E40F1DFB
Date: Wed, 20 Sep 2023 21:56:36 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <i62wc7w6akvi6g3sg4ji6hughqlj4aiagug2paebv5w3fa7e55@oimtmdzjcfdp>
References: <20230920105119.21276-1-pchelkin@ispras.ru>
 <c7818967-1fea-45da-9713-20de4bcb1c44@suse.de>
 <vdtvo2av3upya6mugjyiqo2hfnn6q4dpofoku6rvrtgmycgbrp@scpcnu3ta7ch>
 <ZQsxvY12z+/yYcR6@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZQsxvY12z+/yYcR6@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ispras.ru
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 23/09/20 01:54PM, Mike Snitzer wrote:
> On Wed, Sep 20 2023 at 10:35P -0400,
> Fedor Pchelkin <pchelkin@ispras.ru> wrote:
> 
> > On 23/09/20 04:06PM, Hannes Reinecke wrote:
> > > On 9/20/23 12:51, Fedor Pchelkin wrote:
> > > > Commit 4dba12881f88 ("dm zoned: support arbitrary number of devices")
> > > > made the pointers to additional zoned devices to be stored in a
> > > > dynamically allocated dmz->ddev array. However, this array is not freed.
> > > > 
> > > > Free it when cleaning up zoned device information inside
> > > > dmz_put_zoned_device(). Assigning NULL to dmz->ddev elements doesn't make
> > > > sense there as they are not supposed to be reused later and the whole dmz
> > > > target structure is being cleaned anyway.
> > > > 
> > > > Found by Linux Verification Center (linuxtesting.org).
> > > > 
> > > > Fixes: 4dba12881f88 ("dm zoned: support arbitrary number of devices")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> > > > ---
> > > >   drivers/md/dm-zoned-target.c | 8 +++-----
> > > >   1 file changed, 3 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> > > > index ad8e670a2f9b..e25cd9db6275 100644
> > > > --- a/drivers/md/dm-zoned-target.c
> > > > +++ b/drivers/md/dm-zoned-target.c
> > > > @@ -753,12 +753,10 @@ static void dmz_put_zoned_device(struct dm_target *ti)
> > > >   	struct dmz_target *dmz = ti->private;
> > > >   	int i;
> > > > -	for (i = 0; i < dmz->nr_ddevs; i++) {
> > > > -		if (dmz->ddev[i]) {
> > > > +	for (i = 0; i < dmz->nr_ddevs; i++)
> > > > +		if (dmz->ddev[i])
> > > >   			dm_put_device(ti, dmz->ddev[i]);
> > > > -			dmz->ddev[i] = NULL;
> > > > -		}
> > > > -	}
> > > > +	kfree(dmz->ddev);
> > > >   }
> > > >   static int dmz_fixup_devices(struct dm_target *ti)
> > > 
> > > Hmm. I'm not that happy with it; dmz_put_zoned_device() is using dm_target
> > > as an argument, whereas all of the functions surrounding the call sites is
> > > using the dmz_target directly.
> > > 
> > > Mind to modify the function to use 'struct dmz_target' as an argument?
> > 
> > dm_target is required inside dmz_put_zoned_device() for dm_put_device()
> > calls. I can't see a way for referencing it via dmz_target. Do you mean
> > passing additional second argument like
> >   dmz_put_zoned_device(struct dmz_target *dmz, struct dm_target *ti) ?
> 
> No, what you did is fine.  Not sure what Hannes is saying given only
> passing dm_target has symmetry with dm_get_zoned_device (and
> dmz_fixup_devices).
> 
> > BTW, I also think it can be renamed to dmz_put_zoned_devices().
> 
> I've renamed like you suggested and added a newline to
> dmz_put_zoned_devices() and staged this fix in linux-next for
> upstream inclusion before 6.6 final releases.
> 

Okay, thanks.

> Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

