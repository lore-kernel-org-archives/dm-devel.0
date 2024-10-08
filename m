Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B53212644
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728412179; cv=none; b=ta2GV58IhLhRM+lFQlhrwp7Xf1MNt+kD4WmLfMqlmFo3rCMsQzEw4mXuQQ2rLfZb3jrAEkYGgmssatV5h23NAxvtTyapmgfbRi1RhpCMvQnUkDnNOCZVQFAQAZQdA3UwAGJIwNW8B4QsZ7GuPRm+GqB62jZG4Iw04tE8zUzUPVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728412179; c=relaxed/simple;
	bh=v0uOE4C/O2f1AaFV6smX8aen3hR/qPjTEf6nc9ovWwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sZZzvGoQzs7xig9Omrsj4xSRwOWNteqS+2HDwK6VmqKXB5S0S9UxeEPEoGfcJRfsRsGmWWZQk14iYHDYs20yS3Y7zspbKWcf14pUg0xvPFt1/X8Z163ZJeN3iuHGd9agdkN7G+IaK9giRU+CWbJC5RUHECypZJtId8EZBIqRAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClgeeeZN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClgeeeZN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728412176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdmMGOVLgIbCsK0jPTzuzhA+02H2cieN28bYSBF2KYA=;
	b=ClgeeeZNjKMpL+mzMwAwNpxxKzgxaXZTc4dgNXwqNFlc13qU2n4twaB0YimKXVqiaprlSO
	WG42s8NVT35ada66wzTe0FxyB/1YcVEsuzlUAfbRIirbFdnsyV0HzDUOl+Ukka8M5SV3ft
	8yJLuOH8TXBROn8CmYjCsVhofgzHxAI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-lTi_6Yu9OgSr9ZrnRUdPjg-1; Tue,
 08 Oct 2024 14:29:35 -0400
X-MC-Unique: lTi_6Yu9OgSr9ZrnRUdPjg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E610519560A5;
	Tue,  8 Oct 2024 18:29:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86C19300019E;
	Tue,  8 Oct 2024 18:29:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 498ITWNo2368356
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 14:29:32 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 498ITWm22368355;
	Tue, 8 Oct 2024 14:29:32 -0400
Date: Tue, 8 Oct 2024 14:29:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 10/22] multipathd: split check_path into two functions
Message-ID: <ZwV6CzqfL9yktuaZ@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-11-bmarzins@redhat.com>
 <2c6e8aab3bbd2938b8b88cdccc170b04b6c469f8.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2c6e8aab3bbd2938b8b88cdccc170b04b6c469f8.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 03, 2024 at 10:23:57PM +0200, Martin Wilck wrote:
> On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> > Split out the code that updates a path's state and sets up the next
> > check time into its own function, update_path().
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 31 ++++++++++++++++++++++---------
> >  1 file changed, 22 insertions(+), 9 deletions(-)
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 9319751e..8bfb166d 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2390,6 +2390,7 @@ sync_mpp(struct vectors * vecs, struct
> > multipath *mpp, unsigned int ticks)
> >  }
> >  
> >  enum check_path_return {
> > +	CHECK_PATH_STARTED,
> >  	CHECK_PATH_CHECKED,
> >  	CHECK_PATH_SKIPPED,
> >  	CHECK_PATH_REMOVED,
> > @@ -2629,13 +2630,10 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  }
> >  
> >  static int
> > -check_path (struct vectors * vecs, struct path * pp, unsigned int
> > ticks,
> > -	    time_t start_secs)
> > +check_path (struct path * pp, unsigned int ticks)
> >  {
> > -	int r;
> > -	unsigned int adjust_int, checkint, max_checkint;
> > +	unsigned int checkint;
> >  	struct config *conf;
> > -	time_t next_idx, goal_idx;
> >  
> >  	if (pp->initialized == INIT_REMOVED)
> >  		return CHECK_PATH_SKIPPED;
> > @@ -2647,8 +2645,6 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks,
> >  
> >  	conf = get_multipath_config();
> >  	checkint = conf->checkint;
> > -	max_checkint = conf->max_checkint;
> > -	adjust_int = conf->adjust_int;
> >  	put_multipath_config(conf);
> >  
> 
> After this change, we set only checking in this RCU critical section,
> and checkint is only used in the if clause below. Perhaps move the
> critical section into the if block?

Makes sense. Sure.

-Ben
 
> Martin
> 

