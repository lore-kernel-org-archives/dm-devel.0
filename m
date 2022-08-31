Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBAE0ECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 31 Aug 2022 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661970985;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aX5d8bFgov1Y0VYc1Wk/RIJA//jC7cWqZfLf/NLsI3Q=;
	b=SaBtrhdrhJzvt/9c56Cxqx4RWVcT/HpVno6dDVdw/bt5KL9hPTAFHdnIoSKt2PxGJzpFWL
	/eoznWHCWqO2x83tsxw1AV4/xd2pLSVIsVOD0J7bv15QUK576YXyVcVGeEY2S8os2Wv2NE
	olbakNk68JTfosFfvMhh3deANR43zN8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-7WstzE3kNL2gtVDcS1BquA-1; Wed, 31 Aug 2022 14:36:24 -0400
X-MC-Unique: 7WstzE3kNL2gtVDcS1BquA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8798E85A5B9;
	Wed, 31 Aug 2022 18:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CAE1240D282E;
	Wed, 31 Aug 2022 18:36:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 707C31946A56;
	Wed, 31 Aug 2022 18:36:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 444591946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 Aug 2022 17:59:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31E312026D64; Wed, 31 Aug 2022 17:59:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 188112026D4C;
 Wed, 31 Aug 2022 17:59:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27VHxbC4022228;
 Wed, 31 Aug 2022 12:59:37 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27VHxV44022223;
 Wed, 31 Aug 2022 12:59:31 -0500
Date: Wed, 31 Aug 2022 12:59:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220831175931.GK31105@octiron.msp.redhat.com>
References: <20220830192713.19778-1-mwilck@suse.com>
 <20220830192713.19778-13-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220830192713.19778-13-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v4 12/12] multipathd: fix use-after-free in
 handle_path_wwid_change()
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 30, 2022 at 09:27:13PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Found by coverity (defect #380536).
> 
> Fixes: b4eb57e ("libmultipath, multipathd: log failure setting sysfs attributes")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 66177cd..2d0a7bc 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -951,10 +951,12 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
>  	struct udev_device *udd;
>  	static const char add[] = "add";
>  	ssize_t ret;
> +	char dev[FILE_NAME_SIZE];
>  
>  	if (!pp || !pp->udev)
>  		return;
>  
> +	strlcpy(dev, pp->dev, sizeof(dev));
>  	udd = udev_device_ref(pp->udev);
>  	if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) && pp->mpp) {
>  		pp->dmstate = PSTATE_FAILED;
> @@ -965,8 +967,7 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
>  	udev_device_unref(udd);
>  	if (ret != sizeof(add) - 1)
>  		log_sysfs_attr_set_value(1, ret,
> -					 "%s: failed to trigger add event",
> -					 pp->dev);
> +					 "%s: failed to trigger add event", dev);
>  }
>  
>  bool
> -- 
> 2.37.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

