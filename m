Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8764657C93
	for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732212063; cv=none; b=TObluWwh6p6MdP5lrYBiEMH4XQZjuZ5mAsQDaVATa0M35759VsRUZUs9gO5Sp0PPqnZKZR1vGRFW1AAQv+j8aeaZJp1r82MamMPuPG3iH6poMEOyrpI/3W2WsDn48OxtfxdUqxWk6q9WoXAC0e09BlVVif0QBTJupV2tV6JmcMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732212063; c=relaxed/simple;
	bh=A0ChHaSdbuEA8y6M8Pkm8GA5J8jlCHMPaLsJdznMZOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=W3MF9SOfOrrsC/Q/Ms41A7W7uvMvC/XbmrPirjhdjuJ4M788rzHMMZVH9GkCe3xQwSbcYtwn1CMLomOf4jV4ANHe0tsca9GwQlGsl+fdxLVRjwNIni5w6R/8n0OgtNpUT2wJJ7OedGNavG4LFX22aq3mcUL82jPNVvRpDOiTvfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KA9lYLfc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KA9lYLfc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732212060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3J4hDQQfOT2YMcICrOFbqZNwR47FtWwbCEgZmaLLPsY=;
	b=KA9lYLfcInViPGsWOQ//Qx1tRtWebEAo+Pdnuvys/a7qrLt4l7huLEH+a7y07D5o8zHsS0
	PKvkKkjtfZ9Qv5PkdFh2cHD6hM2uxTh0FDD+HENJDKxgQuShwhwxDgn6Ku+sbkWpAy9PCA
	rxPqcce4LK5FMeUUMurKy3S5ihRKgkc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-nv10PJQFPBCdzIpTfO64dg-1; Thu,
 21 Nov 2024 13:00:56 -0500
X-MC-Unique: nv10PJQFPBCdzIpTfO64dg-1
X-Mimecast-MFC-AGG-ID: nv10PJQFPBCdzIpTfO64dg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48E791956096;
	Thu, 21 Nov 2024 18:00:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E04AE1955F3E;
	Thu, 21 Nov 2024 18:00:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4ALI0rob706902
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 21 Nov 2024 13:00:53 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4ALI0ruV706901;
	Thu, 21 Nov 2024 13:00:53 -0500
Date: Thu, 21 Nov 2024 13:00:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/6] libmultipath: signal device with no table in
 libmp_mapinfo
Message-ID: <Zz91VZ3r2GUZinVj@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
 <20241115232256.627933-2-bmarzins@redhat.com>
 <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
 <Zzz2E-UC1m8rezOH@redhat.com>
 <b74031fd331a5825b45d4c44a5567cc7d5d96bbf.camel@suse.com>
 <Zz5bxCZfCDsgMtOm@redhat.com>
 <f0bc411082a622f2cad3368be1cdc210db1fdc7a.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f0bc411082a622f2cad3368be1cdc210db1fdc7a.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A4RJaXcj4VJ7nzmSqgJLZkFgGJ5ufeQe2yuNS7e3ad4_1732212055
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 21, 2024 at 09:57:28AM +0100, Martin Wilck wrote:
> On Wed, 2024-11-20 at 16:59 -0500, Benjamin Marzinski wrote:
> > 
> > How would you feel about adding a parameter to do_foreach_partmaps()
> > to
> > say whether or not it should remove empty partmaps (or possibly just
> > checking if the partmap_func is remove_partmaps).  Your argument
> > makes
> > sense when you are removing a device. But what about functions like
> > dm_cancel_remove_partmaps() and dm_rename_partmaps()? I'm not sure
> > that
> > these should automatically empty (a possibly being created) partition
> > devices.
> 
> We're moving far into corner case land here :-) 
> 
> I think we should keep it as simple as possible. For me, that means
> that an empty partition map (with UUID matching the current mpath map)
> should be treated like any other partition map with matching UUID, no
> matter what the current operation is.
> 
> There will be some situations where the outcome will be suboptimal. By
> keeping it simple, we'll at least be able to understand the outcome.

That's reasonable. I misunderstood your suggestion as asking to always
remove empty partition devices in do_foreach_partmaps(). We'd need to
make sure all the partmap_func()s work with empty devices. But that
shouldn't be too bad.

-Ben 
 
> Martin

