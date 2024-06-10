Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20DA14B978
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718043145; cv=none; b=WUQJqDfq7CF+/zzfNNvTJUFgzq9OhOhjTsX8tZyyAQC/lJ48YNDLdsenERjpDsbcWfqH/s3WfFUp4W68WB0VVoAwiNRhqkKDwlNQUgKDDaphp8KxbC+V7iRTakNZdENqH+i7n541fTQx2o5AAOyXu0H1IWcaXdw8CCV0aWFaBx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718043145; c=relaxed/simple;
	bh=Yz6mvzmZQk/n+4U8DiaqWskmTygh5Qeu7CQPPVEUwaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Mxwv3dRWK6Izi4SlJ9iWsaX/n8v5j1dDt3GuHRxuM7yCNoXc/I5dL0NJMpEJ+l/BTRI6TiORyVOSAJddIw5wJbqjnou/aAdNjs07Up5Jd4dTq8tVPwx/SqDVeccBUm+0xrDpXZt1bdXsoYXJla/WmVMA94o6Bd1h+4UQS8/9N84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OMn1Zfch; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMn1Zfch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718043142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fqNYuUqzAoWW3qERQEv/HP188IqWrnYU9Ao4+Zs2fbM=;
	b=OMn1ZfchptC3d/neiwp3jVCTIPboMiMfKCgQ9GKZUqbqfaDUyYzaCmCO0CLoUMyC5OMgB5
	+z99Yt2qYOk3fNUkSesoSVZ6NrcTNDnGPX5Xh8OxlfY3GGozNHzHxDyGF4ZXkZvvPR47hX
	o/coghXRTcs03gqIOMQI7CZXpPMvG9Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-dAv8-BMJN5iob_lNjcmPUw-1; Mon,
 10 Jun 2024 14:12:21 -0400
X-MC-Unique: dAv8-BMJN5iob_lNjcmPUw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6691119560B4;
	Mon, 10 Jun 2024 18:12:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F36C31956089;
	Mon, 10 Jun 2024 18:12:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45AICIWM802730
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 14:12:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45AICION802729;
	Mon, 10 Jun 2024 14:12:18 -0400
Date: Mon, 10 Jun 2024 14:12:18 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/2] dm: mpath dm_get_device fix
Message-ID: <ZmdCAlEPN8Lmd5XQ@redhat.com>
References: <20240517004129.139615-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240517004129.139615-1-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2024 at 08:41:27PM -0400, Benjamin Marzinski wrote:

ping.

> dm-mpath shouldn't be calling dm_get_device() in multipath_message().
> If you run:
> 
> # dmsetup message <mpath_dev> 0 "fail_path <device_not_in_multipath>"
> 
> the dm_get_device() call in multipath_message() will add that incorrect
> device to the devices list, fail to find a matching pgpath, and then
> remove it.  multipath shouldn't be messing with the devices table
> outside of its constructor and destructor.
> 
> To fix it, this patchset factors out a helper function from
> dm_get_device() to turn the device path string into a dev_t.
> multipath_message() calls that helper function and uses the dev_t to
> find the correct pgpath instead.
> 
> Benjamin Marzinski (2):
>   dm: factor out helper function from dm_get_device
>   dm mpath: don't call dm_get_device in multipath_message
> 
>  drivers/md/dm-mpath.c         | 11 ++++-------
>  drivers/md/dm-table.c         | 33 ++++++++++++++++++++++++---------
>  include/linux/device-mapper.h |  5 +++++
>  3 files changed, 33 insertions(+), 16 deletions(-)
> 
> -- 
> 2.45.0
> 

