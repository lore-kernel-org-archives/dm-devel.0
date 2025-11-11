Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621334253B
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762876417; cv=none; b=cPbwlvIlTvu7/loWIu3GD6nr1884ynR/iuoyt8+aUZN4JU5xMLQQW15H3BR5V6x2li3BkuZ4f4u3K6z7Hk6rGEhXGMiVydrkOU9Bj+quKdBzUoDMDAbt+kgDkh0uwIGX9obM/NONS68E0cXzjJWFHBakq26v1UiJiWKGwJYPyR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762876417; c=relaxed/simple;
	bh=W3f/secwn/oocrXBaYKf8MgBV5ELr8my/UhmthsqhiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bBkVEzkvBlP5XBl+gKrvJn+nxOppFRsRSZ01VGuJZXFaz98NlFA4nqZGfWsTZWRrLuo0KoHCczNEIYudyBlQk2A1o3MpB1QhMKtoam1a8RgDBG85epDddGktSn2YgIQMruwl3+70QD9CYl6pbxLHvWSfkE9c8ZX4T15gCjVsKR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CHGol6q1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CHGol6q1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762876414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MDes0TnWO/EGMgtfAY0DVfeKZrwcFwr6HB8ye1ADkuA=;
	b=CHGol6q11q8IPEK1UbetTYtAEYLKU1N9DaESVfmIB8bNC0b5Rn4GbKtY68gGYtCJ3ziAgA
	NZop0GHa1XIwSdJAlxWsaaHWqlBras61VXjGWiPwecwT6jV2wRe9wLpF3bJwzc2xU7YIes
	5o2DqaowXk8ZyCJlbAMYplh4hejL5IA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-P_fl0TjdMUKikJ_h-p8NyQ-1; Tue,
 11 Nov 2025 10:53:32 -0500
X-MC-Unique: P_fl0TjdMUKikJ_h-p8NyQ-1
X-Mimecast-MFC-AGG-ID: P_fl0TjdMUKikJ_h-p8NyQ_1762876411
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03E84195608E;
	Tue, 11 Nov 2025 15:53:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AA8D30044E0;
	Tue, 11 Nov 2025 15:53:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5ABFrTQU619714
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 10:53:29 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5ABFrSOe619713;
	Tue, 11 Nov 2025 10:53:28 -0500
Date: Tue, 11 Nov 2025 10:53:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] libmultipath: remove buggy reinstate_paths function
Message-ID: <aRNb-KAUxZfe4q67@redhat.com>
References: <20250303195628.2998595-1-bmarzins@redhat.com>
 <a314cad2fc4f78fde0960ba204321fe182ce45d8.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a314cad2fc4f78fde0960ba204321fe182ce45d8.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dnYyuEE7sV7iXBdpWci8WVwC9-i_I_9lMNJwnG_OXcU_1762876411
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2025 at 11:30:29PM +0100, Martin Wilck wrote:
> On Mon, 2025-03-03 at 14:56 -0500, Benjamin Marzinski wrote:
> > The purpose of reinstate_paths() is to reinstate all the paths on a
> > multipath device that multipathd thinks are usable, similar to
> > sync_map_state(). However, reinstate_paths() doesn't work correctly.
> > For instance, it will always reinstate every path in enabled (as
> > opposed
> > to active or disabled) pathgroups. This is clearly wrong. It might be
> > badly written code to avoid enabling paths in PATH_GHOST in active
> > pathgroups, but that's just a guess and isn't necessary at any rate.
> > 
> > It's called in two places. The first is when multipath is run with
> > CMD_CREATE. The second is when domap() is run with a mpp->action of
> > ACT_SWITCHPG or ACT_SWITCHPG_RENAME. This case just exists to run
> > extra
> > reinstates for paths that are not in PATH_UP, on pathgroups that are
> > now
> > in the enabled state, instead of the active state. This is old code.
> > I'm
> > not sure if it ever made sense to do this, but it certainly doesn't
> > now.
> > 
> > Multipathd already will make sure that its path states are synced
> > with
> > the kernel states whenever either the paths get checked or a dm event
> > occurs. It makes sense to additionally sync with the kernel state
> > when a
> > multipath device is reloaded, like sync_map_state() currently does,
> > since the path's kernel state will start out of sync with
> > multipathd's
> > state.
> > 
> > However, if multipathd isn't running, I can see the benefit of being
> > able to reinstate paths by running "multipath". So if multipath is
> > run to create or reload multipath devices (CMD_CREATE), it will now
> > call
> > sync_map_state() with a flag to make it behave like reinstate_paths()
> > did (it will only reinstate paths, but never preemptively fail them).
> > I
> > thought about only doing this if check_daemon() said that multipathd
> > wasn't running, but perhaps people are relying on running multipath
> > to reinstate paths before the next scheduled checker run.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> PS: this doesn't look like "stable" material to me. Right?

Yeah. This is more of a cleanup than a bug fix.

-Ben

