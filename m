Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D4E3DCDB2
	for <dm-devel@lists.linux.dev>; Mon, 23 Mar 2026 19:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295160; cv=none; b=S0XXraTKoIGNA9PkKyWshhZg4dUCTQrNCpVDFzokxlLHUFPMNPK14kD27xDVhCgYOG4J7hQJz297o+JEyI3pW8ybmaKiseidjWu7sh8Xx7+dbky8dnunKXKKaDWa9UL+Pev21W6VpA/V38Fyn4Ex2wGIUi61wnnZXpjcNg+xPRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295160; c=relaxed/simple;
	bh=yjJKhFsfu6zdzUHv4xxWJgqFVw++AUAHNen9S7A7HmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fcxGyjE9yu4aajlN2ObmB0Z3FO+maN+UIgTclzNFq5mbqZkNzUZwBrdSpYnjmISlSjud9+7dinyEXIIujcyjugwxz5YzWh4u/ZUy4IyQ7SMm9RxSFGgrd2aYhWpHqYiHA+QpHegTM0x9R5G6TSiZQGabg5V4/x9MES1kpI88OSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gW52Uivp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gW52Uivp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774295157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X/IKSK8kMs3MboB4i6HV3lnolk5JrqaUwVXJREh7Khk=;
	b=gW52Uivp2Kso9y/0YBA/NcEtpEo1KTDYiov1JMEioA0ndPAyu/iEMvekyPfRqaojOMBsq1
	xyaxNxkO2VqTFIwBSb3ORozJlQ9IeorTaJbBBcSuRnDPx7q7RPNiR0NZWL4x0MdctBLglM
	460i0Q5NM35O7qpou+4XWPfDhx1QxAA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-pYu_ncTtPdSMugDrFG1elQ-1; Mon,
 23 Mar 2026 15:45:52 -0400
X-MC-Unique: pYu_ncTtPdSMugDrFG1elQ-1
X-Mimecast-MFC-AGG-ID: pYu_ncTtPdSMugDrFG1elQ_1774295151
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71CBB195604F;
	Mon, 23 Mar 2026 19:45:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9E73300019F;
	Mon, 23 Mar 2026 19:45:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62NJjm861031030
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 15:45:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62NJjmlV1031029;
	Mon, 23 Mar 2026 15:45:48 -0400
Date: Mon, 23 Mar 2026 15:45:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
Message-ID: <acGYbD6X55eA-ynl@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 2nSHNjCbpVVAMxcYx0xm11d-2V36h66uTTN2z53-FbY_1774295151
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 06:04:54PM +0000, John Garry wrote:
> On 23/03/2026 16:25, Benjamin Marzinski wrote:
> > > > If the goal is to limit this to IMPLICT ALUA only, I was expecting that
> > > > you could just leave the scsi_dh_alua code completely alone. If native
> > > > scsi multipathing didn't disable the device handler, it seemed that this
> > > > would basically just work. With the device handler attached,
> > > We only get the scsi_dh_activate() -> alua_activate() call from dm-mpath.c,
> > > and that callchain could not happen for native SCSI multipath. But, yes, we
> > > do the alua_rtpg_queue() call from a rescan, but we should be checking if
> > > the path is available first (and not rely on a rescan).
> > > 
> > > > when the
> > > > array updates the ALUA state, that should, at least I believe, trigger a
> > > > unit attention that will fire off a RTPG command. That should update the
> > > > sdev->access_state, which the multipath code could use to pick the
> > > > correct path. Right? What am I missing here?
> > > > Is this just a parallel
> > > > exercise to overhaul the ALUA code?
> > > The SCSI community would rather not see more usage for device handlers.
> > I guess it depends on what you mean by using a device handler.
> 
> My meaning is anything in drivers/scsi/device_handler
> 
> > I don't
> > think the Native SCSI multipath code would need to actively interface
> > with the device handler code to support IMPLICIT ALUA. IIUC, looking at
> > sdev->access_state should be enough to pick the correct path.
> 
> We also have the functionality from alua_check_sense() to consider.

But the multipath code won't call that directly. Right now, the scsi
device handler will, at least for every scsi device except ones using
the Native Multipath code. My point is that this would just work, except
that the Native Multipath code goes out of its way to break it, by
disabling device handlers, and I don't really see the point of disabling
something that every other scsi device, multipathed or not, has enabled.
It's not like leaving it enabled makes it any harder to move the
implicit ALUA support from the device handler to the generic scsi code,
if that's the goal, since the Native Multipath code doesn't care who is
issuing those rtpgs and updating the state.

I guess this is more of a question for Hannes. Is the goal to turn off
automatic device handler attachment in general, and go back to making
dm-multipath attach device handlers to the scsi devices it is using? If
not, then I don't see any reason to have the Native Multipath code
disable it. If it allowed device handlers to get attached, these two
developement efforts (native scsi multipath and refactoring the alua
support) could go on in parallel.

Or am I missing something here?
-Ben

> 
> > If that's
> > right, then it doesn't really matter to the multipath code whether this
> > is getting updated in scsi_dh_alua.c or scsi_alua.c.
> > So refactoring the> scsi ALUA handling code seems orthogonal to the adding
> IMPLICIT ALUA
> > support to the Native scsi multipathing code.
> 
> DH support is considered legacy. As I understand, DH was originally added
> for early explicit ALUA support and other DH-related standards, and explicit
> ALUA is considered flawed. So that is why Martin/Hannes doesn't want to see
> more users (for DH). This is my understanding.
> 
> Now I a need to try to separate out the ALUA parts we need from
> scsi_dh_alua.c into SCSI core code. I'll talk to Martin about this approach
> again.
> 
> Thanks,
> John

