Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AB01B87C0
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756151775; cv=none; b=ZKX1kanhVJIAjkYX+knOJoP6owrsr68Lf5xfnBDW8iAYG1uDY//zYtmwmgELhMDTjA++kGwPj3tW+t82U/n3qRhDs56upkxrohJU8t5yisFT8UmkAmo3eZAZpSZ6WZOYmYZvgNpyV18nTSmlgCShiZeN0SDCUi56MannmhNIh7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756151775; c=relaxed/simple;
	bh=ciuRy9MTxTjq0LlXggj0YCRE5SSxYQDdPdEj+0jceXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=to1+nLdcKJlrW1GWcAJjBrggKk9hd/UhUur/1P3bXrUQOG4hfk7ffZb4Wr7mYsiBVzipbGCATdQaLQrb/zADA8UVZ/HhNR6/zjT5ROfwrpmtX+c3VoHHlMOrmf938lj1kM3vfOYCxd9HeQeo6QzO4N4M3F8xHgjQCj1xBetJ1pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TDeETIdg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TDeETIdg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756151771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNFV/B1n+79cEJpL/K6sYYid8+75GM7OljIw1+W7GtA=;
	b=TDeETIdgQU90gzSEgHdc+VSV4KMyOllCARG6A6ii8ZwMT/9UfD5+XygL4qqJf0w2Tp9mcb
	7P4K3cs2zvnzcWScuKLp7CLEWs/UvKxXWmyVCG+E5gH85ZnKr6wQZLRPzM8xbSZ65d5/ME
	3Fttwqc1J/s0SPYkqatP5d43bG2tfPc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-0L7VoO5sP0SF3KYKxuR47A-1; Mon,
 25 Aug 2025 15:56:10 -0400
X-MC-Unique: 0L7VoO5sP0SF3KYKxuR47A-1
X-Mimecast-MFC-AGG-ID: 0L7VoO5sP0SF3KYKxuR47A_1756151769
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C622B180044F;
	Mon, 25 Aug 2025 19:56:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3540B1955F24;
	Mon, 25 Aug 2025 19:56:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57PJu668221678
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:56:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57PJu6w0221677;
	Mon, 25 Aug 2025 15:56:06 -0400
Date: Mon, 25 Aug 2025 15:56:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 00/15] Improve mpathpersist's unavailable path handling
Message-ID: <aKy_1vEm47lEDEGa@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
 <592b5f59-cc88-4315-8a67-95421cdb3545@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <592b5f59-cc88-4315-8a67-95421cdb3545@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3ZCWjLjNqwjZCN2V0kVXGGNLmu8Jf5mtFyT5R1W_-lc_1756151769
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Aug 25, 2025 at 08:38:38AM +0200, Hannes Reinecke wrote:
> On 7/10/25 20:10, Benjamin Marzinski wrote:
> > A problem that mpathpersist has with making SCSI Persistent Resevations
> > to a multipath device work like they do to individual SCSI devices is
> > that some of the paths to a multipath device might be down or missing
> > when the mpathpersist commands are run. Multipath handles registering a
> > new key pretty well. If paths are unavailable at the time of the
> > command, the key is registered when they later become available.  But if
> > the multipath device is also holding a reservation on one of its paths,
> > things get trickier.
> > 
> > If a persistent reservation is being held by an unsuable path of a
> > multipath device (the path can either be down or completely removed),
> > libmpathpersist can't change it just by forwarding the regular
> > persistent reservation commands. This can cause problems both for the
> > RELEASE command and the REGISTER and REGISTER AND IGNORE commands if
> > they are used to change from one key to another. If the path holding the
> > reservation is unavailable, the reservation won't be released or have
> > its key changed, as expected. I wish the problem of having a reservation
> > key changed while it is holding the reservation was simply a theoretical
> > one, but there are enterprise users of multipath that need this
> > capability.
> > 
> > This patchset deals with both of these problems. libmpathpersist always
> > had code to handle releasing a reservation held by an unavailable path,
> > but the existing method is broken. It relies on poorly supported
> > optional features of SCSI Persistent Reservations: the READ FULL STATUS
> > command and specifying Initiator Ports with the REGISTER command
> > (SIP_C). Also, fixing its current issues would additionally require
> > supporting the All Target Ports option (ATP_C). This existing workaround
> > has been redesigned to use the PREEMPT command instead. Key changes
> > where the path holding the reservation is unavailable were not
> > previously handled by libmpathpersist. This patchset also handles them
> > using the PREEMPT command.
> > 
> I wish we had a testcase for all of that. Persistent reservation
> handling is tricky at the best of times, but throwing in multipathing
> it really gets into the arcane knowledge area.
> Ben, do you have something which we could turn into some blktest
> scenarios?

It wouldn't be hard to use the LIO target to setup these scenarios, and
verify that mpathpersist is handling them. The bigger issue is that I'm
still occassionally running into new ones. I've got a couple more
patches to send to deal with them, but what this actually wants (and
what I plan to write after I think I've handled all the issues) is a
test that will write to the devices while randomly failing and restoring
paths and doing various PR commands, both to check that commands succeed
and fail when expected given the state of the devices when they were
run, and that we don't end up with active paths that either don't have
reservations when they should, or do have them when they shouldn't.

I can look at adding something like that to blktest.

-Ben

> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

