Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7E223A8
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721160043; cv=none; b=VcPTVxXV1brL6Mf7qnFWCPfte16enY18vcd1iw+dNBkGDUTB0l3NuTd/12H7CDjnE8aJ2SG+3zppTnXuLvuB7eg7H2nVM82FUTr6l3/EBmrqJHe07A8xc4kzgFj0ZvIEjsGod/m3KNk+3Bi264duX3+Wjz7KWKRCiYAuAlsS9+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721160043; c=relaxed/simple;
	bh=uj0dygupuvrgRbbIMvYf15938dvkjxKf47Y9VNb0+X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rDddn8Fr2MaRhM0OKjHLDBxDBx/zK0IrxM1V2q/Px8kOe3B+0a4wExhxQybubZXfd55jQRsKMqy14QaX9wofEOk+gqX4L5ocvJnPVODRFklwX50YYAUH6+WYsnvYems+HZsRUSnCZTxyi6I5+1dNmatVB25i52drp4EK7l6ETMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZUX+D4WG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZUX+D4WG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721160040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tPMWfy002bJC16ylQcnaBb+fkooRNTmwZgvwdqqvrwk=;
	b=ZUX+D4WGlJMG8zwIsiHhcqULPLH8MXM5g2qtpXTUR0V3nD5Ni72M1JBlhq1/WOacg5sbSj
	t5B7dEaI7aPMVjvSiKh4jmdams8YmQ1FsFsS9ahK5wAD2xrovq9tT8cCmSpi+Mug1NkV/J
	RWJjEDbVm7MjeygkIqEuzWzkHec+Hvs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-iZ6ejwBROB6VUb2keamPkQ-1; Tue,
 16 Jul 2024 16:00:37 -0400
X-MC-Unique: iZ6ejwBROB6VUb2keamPkQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AE8F1955D4C;
	Tue, 16 Jul 2024 20:00:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E1811955D42;
	Tue, 16 Jul 2024 20:00:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GK0YRZ2129142
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 16:00:34 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GK0Y9t2129141;
	Tue, 16 Jul 2024 16:00:34 -0400
Date: Tue, 16 Jul 2024 16:00:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 22/22] multipathd: clean up the correct wwid in
 check_path_wwid_change
Message-ID: <ZpbRYljSROAwW1IO@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-23-bmarzins@redhat.com>
 <fab74ceeb25ded98f57fbfa59b6afbb9731b8502.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fab74ceeb25ded98f57fbfa59b6afbb9731b8502.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2024 at 11:22:06PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> > After check_path_wwid_change() grabbed a new copy of the wwid, it was
> > stripping trailing whitespace off of pp->wwid, instead of the copy it
> > just got.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> I'd suggest adding:
> 4660cff ("multipathd: add recheck_wwid option to verify the path wwid")

Sure.

> 

