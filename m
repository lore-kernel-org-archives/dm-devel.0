Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA03B38A4
	for <dm-devel@lists.linux.dev>; Mon, 23 Mar 2026 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283118; cv=none; b=iEqBsIdZWBw1GcwLbZyW+sF0zaXz6sdW0scoZcjEa8cBF+k9EuCKJr1JMMG0c8SvrM528zmpbOzr10OKu2HNuJbzaYn3857XQoW48Dkn5+HT5C46n4IuGA/LGFS7L5rdnwKOvp17OYrPEwIg4TVUbfZAS3Z+mi+hXORUgTQrIkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283118; c=relaxed/simple;
	bh=EFkJD68Oq1eA6tfWtGSMgmF0+D3IsA8GPjwCCKO0lgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=THRkCKE62n+hjJeSoEG18Mpnsq+hPFOYRsj7Ffg07u9Gxn+fOnOX19FaQjVwFBR01c7NWPzByVbbfKqW8fYplJnBbNl2P0H/eZVmUPaKW+QW4qt7dqfv3cxjqb6Bn6yw9wl4iSpOA41F9mb7l0tsG/SxfipA8FWgysLfbAZVNl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWG61x/X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWG61x/X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774283116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=slAIW0dtKch4EgP848DAzcYNIaKirnAw7wYX/s5hQN8=;
	b=hWG61x/X2oXa8yw0pg2W4JEkBF+c5pMYKujDvBITqlgsFemMW2ckxuCjVyspwRepzOvw9N
	0Suoj9Yn4HBQFZBZpGuFJ2ORdUSrZKQqlweeWXklbkK/Pux3fcozOviD2tOJL02PctNzK6
	qcK8JRUBRiS6Ei71p2EYeWE+EYYgBZQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-YZNZETtRPaWjTGl26cMyWg-1; Mon,
 23 Mar 2026 12:25:10 -0400
X-MC-Unique: YZNZETtRPaWjTGl26cMyWg-1
X-Mimecast-MFC-AGG-ID: YZNZETtRPaWjTGl26cMyWg_1774283109
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D41E3195607B;
	Mon, 23 Mar 2026 16:25:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 602FA1955D71;
	Mon, 23 Mar 2026 16:25:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62NGP7711025265
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 12:25:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62NGP6Ph1025264;
	Mon, 23 Mar 2026 12:25:06 -0400
Date: Mon, 23 Mar 2026 12:25:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
Message-ID: <acFpYuaL-_9g90RI@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ASNDApxseOGS8whncHm2Qlr8BE3axN1jZBYN2jF7qnE_1774283109
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 09:57:15AM +0000, John Garry wrote:
> On 22/03/2026 17:37, Benjamin Marzinski wrote:
> > > I think that this work is a real regression possibility for
> > > dm-multipath, so we need to be careful.
> > At the risk of showing just how limited my SCSI knowledge is, I need to
> > ask, Is any of this actually necessary to get native scsi multipath
> > working with Implicit ALUA?
> > 
> > If the goal is to limit this to IMPLICT ALUA only, I was expecting that
> > you could just leave the scsi_dh_alua code completely alone. If native
> > scsi multipathing didn't disable the device handler, it seemed that this
> > would basically just work. With the device handler attached,
> 
> We only get the scsi_dh_activate() -> alua_activate() call from dm-mpath.c,
> and that callchain could not happen for native SCSI multipath. But, yes, we
> do the alua_rtpg_queue() call from a rescan, but we should be checking if
> the path is available first (and not rely on a rescan).
> 
> > when the
> > array updates the ALUA state, that should, at least I believe, trigger a
> > unit attention that will fire off a RTPG command. That should update the
> > sdev->access_state, which the multipath code could use to pick the
> > correct path. Right? What am I missing here?
> > Is this just a parallel
> > exercise to overhaul the ALUA code?
> 
> The SCSI community would rather not see more usage for device handlers.

I guess it depends on what you mean by using a device handler. I don't
think the Native SCSI multipath code would need to actively interface
with the device handler code to support IMPLICIT ALUA. IIUC, looking at
sdev->access_state should be enough to pick the correct path. If that's
right, then it doesn't really matter to the multipath code whether this
is getting updated in scsi_dh_alua.c or scsi_alua.c. So refactoring the
scsi ALUA handling code seems orthogonal to the adding IMPLICIT ALUA
support to the Native scsi multipathing code.

-Ben

> 
> How we then get ALUA support for native SCSI multipath is the question. My
> original series just really duplicated the scsi_dh_alua.c RTPG support for
> native SCSI multipath into a limited "core" driver. Hannes thinks that a
> core ALUA driver to also support DH would be better (IIUC), which I am
> attempting in this series. I will re-iterate that I would rather not touch
> scsi_dh_alua.c, unless the changes are simple and obvious(ly correct).
> 
> Thanks,
> John

