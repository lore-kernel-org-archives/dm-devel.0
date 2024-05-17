Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD4579CC
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715956398; cv=none; b=Y/UeVJv/KpJyha1uX5Efd66HxpEkmBFjdyvHJBYxrtqNrQbNvSvZzPEcKmE+5LJqMBIf5D2hnxCEvDM79zvTfx5NqcR/NPGmZFSJKkZfZbrhh1a3L0GCy6B9Z03VyUxef3yoIkJUA0BIposViMe+rvGzM66t3uBAVDfOAQBZxPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715956398; c=relaxed/simple;
	bh=V93XLAiIxz56pOFhKRk2dq+FLKZDcnpird74nR4nZdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X86qLtXnMoTrAzPRTrK+XWG7IXYRqSvTp+yKu2cSf+17XqmGMpbQ8B0yjyoWp+vRG8FBJieV4gtbaMVz6qrhUxK7Sy6nXlVfvC+gQ13GYzY4OePcEB/mkHgPQlD4rqYrmBMzBsNbkIHtLCUYWnEu9ui6dKU7hoZLzFakFkcll5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cD8G3wAe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cD8G3wAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715956395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qXRpht3Oiyb6WnCO2PLJaNfFB/1BTZbbiqXWPvuMhk8=;
	b=cD8G3wAebGGzPBWtO5rICY44gfV0adUu5DRHtyDNTtJvTq43WQSrITfsLyxnmFqKh0ZOaC
	1L/Burqp2JZm37H9gmjotP2j9fZrngVbULEWJxk1JiUmfYj6Io3/eNjxvbgt4JdyOaZnCC
	I3AImNZ8MhXq3VmeyHfd1yMP68kovb0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-f_iC8IrFOze2TXNajTJl6Q-1; Fri,
 17 May 2024 10:33:11 -0400
X-MC-Unique: f_iC8IrFOze2TXNajTJl6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 004D23802130;
	Fri, 17 May 2024 14:33:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9F5F2026D68;
	Fri, 17 May 2024 14:33:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44HEXAqY146578
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 10:33:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44HEXA7Y146577;
	Fri, 17 May 2024 10:33:10 -0400
Date: Fri, 17 May 2024 10:33:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: YangYang <yang.yang@vivo.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] dm: support retrieving struct dm_target from struct
 dm_dev
Message-ID: <Zkdqpl5SN3RV0smg@redhat.com>
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com>
 <ZkTXzG1yrPmW64Z6@redhat.com>
 <80ddcd90-2e1c-4fbf-a45a-b1b5ff4d60fb@vivo.com>
 <ZkYmZaGWPtGIwedG@redhat.com>
 <8f49b95e-88df-48b8-9311-8a15414d8107@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f49b95e-88df-48b8-9311-8a15414d8107@vivo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, May 17, 2024 at 03:48:49PM +0800, YangYang wrote:
> On 2024/5/16 23:29, Benjamin Marzinski wrote:
> > On Thu, May 16, 2024 at 09:55:53AM +0800, YangYang wrote:
> > > On 2024/5/15 23:42, Benjamin Marzinski wrote:
> > > > On Tue, May 14, 2024 at 05:04:42PM +0800, Yang Yang wrote:

> > > 
> > > If I understand correctly, you are suggesting to iterate through all the
> > > targets, handling those with sends_pass_around_flush set, and skipping
> > > those where sends_pass_around_flush is not set. I believe this approach
> > > may result in some CPU wastage.
> > > 
> > >    for i in {0..1023}; do
> > >      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
> > >    done | sudo dmsetup create example
> > > 
> > > In this specific scenario, a single iteration of the loop is all that
> > > is needed.
> > 
> > It's just one iteration of the loop either way. You either loop through
> > the targets or the devices.  It's true that if you have lots of targets
> > all mapped to the same device, you would waste time looping through all
> > the targets instead of looping through the devices.  But if you only had
> > one striped target mapped to lots of devices, you would waste time
> > looping through all of the devices instead of looping through the
> > targets.
> 
> Yes, I get your point. This patchset may make things even worse for
> the striped target.
> I am just curious, in what scenario is the "dm-strip" target mapped to
> a large number of underlying devices from the same block device.
> 

I don't think anyone in the real world does create dm-stripe devices with a
huge number of stripe table devices. My point was that it didn't seem
obvious me that looping through the targets was a significant problem
compared to looping through the devices.

At any rate, Mikulas's patch already does this optimally, even for
targets like dm-stripe, so it doesn't really matter now.

-Ben

