Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FD81B043F
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 23:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743119498; cv=none; b=dN971JwLwJ6xQzChotyb2ks+jDazofIeasVDS3RvTlZ/OFI5z/hbyy5lHwzjfE5h9t6Oa0vNeq3+yb9x6gK7Qku6+trqEVc8M77u4xV+Bs3I+jnYRRgnRtu+NG94IQNuQGlTf12TJT3zz1i2BQRlh5cOm8AS+6DEXGT8qLsw91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743119498; c=relaxed/simple;
	bh=DQZ69/qUYubJ2yTP02FZXrnbLz5WhNe9fbbPunIhHHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZCvJa2AbnkMv80FWys+eX0cI31E/W9B1wkvLw7I56BKXOkO54P8lFKRLwA54kh3dR+wwgHrOOnVC6PzYXRrvuYqFsMA+csTRxQM8qeRmLjOkqKt+InaSvqw0KhdkhZdt23AA+RUFR97Z+jEzXDuSOKyXsauDlRGulHhvXwdCVU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QoPmy5da; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QoPmy5da"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743119494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9KwnooAmN46DY+VYDhWvvgsW7YXuA0OOZnYRtG6vn1I=;
	b=QoPmy5daTfj5Ql4BvTvwN5hV1nL7NFFBYQP/cqZZm3tkZ6rF4A7r9v1Rl4K5FayMbm+VEX
	OR+BNWD36jNlpKxi8CsWaMy8oGpn0P+7/mrqZGyiXNFy9PDGCeEMz6SugSkuiMUVdRgpKS
	G3VbBfdxArArocqgVrYsh0QjDGonVtY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-fCobGMRyOf6PXeASd_Y1tg-1; Thu,
 27 Mar 2025 19:51:29 -0400
X-MC-Unique: fCobGMRyOf6PXeASd_Y1tg-1
X-Mimecast-MFC-AGG-ID: fCobGMRyOf6PXeASd_Y1tg_1743119488
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 359A21944F0A;
	Thu, 27 Mar 2025 23:51:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB3081956095;
	Thu, 27 Mar 2025 23:51:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52RNpQXO2664409
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Mar 2025 19:51:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52RNpPEv2664408;
	Thu, 27 Mar 2025 19:51:25 -0400
Date: Thu, 27 Mar 2025 19:51:25 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/3] multipathd: monitor new multipath dev even if we
 can't update it
Message-ID: <Z-XkfUIhidQymNhf@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
 <20250324205504.2523493-2-bmarzins@redhat.com>
 <99b1d67f46298eed77b2d77ec396a1b0727481d0.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <99b1d67f46298eed77b2d77ec396a1b0727481d0.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 19bAzJHlp_2sWzEgOPH_fErD6_dR45Zalvem39rh7Ok_1743119488
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 25, 2025 at 11:33:12PM +0100, Martin Wilck wrote:
> On Mon, 2025-03-24 at 16:55 -0400, Benjamin Marzinski wrote:
> > If a multipath device was created by the multipath command,
> > multipathd
> > might not agree with how the device was created. ev_add_map() can
> > reload
> > the device with a different table by calling add_map_without_path() -
> > >
> > update_map(). If this reloading of the map failed, multipathd was
> > simply
> > ignoring the multipath device, even though it still existed.
> > 
> > One way that reloading can fail is if a path that multipathd already
> > has
> > initialized goes offline. If a multipath device is created by the
> > multipath command while the path is offline, it will not use the
> > offline
> > path, since multipath won't be able to get the necessary pathinfo.
> > However, multipathd will already have the pathinfo for the path, and
> > may
> > not even know that it's offline, since the path is an orphan. When it
> > tries to reload the device, it will include the offline path, and the
> > reload will fail.
> 
> Am I understanding correctly that during the reload, bdev_open() failed
> in the kernel because the path was offline?

Yep. It's failing in sd_open() -> scsi_block_when_processing_errors()
see the comment here:
https://github.com/torvalds/linux/blob/5c2a430e85994f4873ea5ec42091baa1153bc731/drivers/scsi/sd.c#L1523
 
> I was thinking about my recent tests [1] where I'd come to the
> conclusion that reload failure is hardly possible. While I'd realized
> that "trying to add a path device that was not previously mapped" might
> fail, I didn't think of the scenario you describe here.
> 
> [1] https://lore.kernel.org/dm-devel/ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com/
> 
> > 
> > Instead of ignoring the device if it can't reload it, multipathd
> > should
> > just montior it as it is. When the path device is no longer offline,
> > it
> > can be added back to the multipath device by calling
> > "multipathd reconfigure" or "multipathd add path <path>".
> 
> 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>

