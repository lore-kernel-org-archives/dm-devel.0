Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9AE14036B
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715983454; cv=none; b=OggeoiFucpH7T9uOmbUKOMNKjJaRboHWjI8KuvjPiWDiszXgathT6AOWKb2db+UYIYvOIxQzDoFB+kTr6l004Pww5ehn7H9jnxlJXQEhb61yyXWR585e2xnyi80bTeJtqkqRrSbXDltxRddu34aNVswHL435CHWQAGhn+z3DaCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715983454; c=relaxed/simple;
	bh=tLzf0r1wzgRXBsIAho3wA6/DqrgoucfCmH5ujph6g/k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W4PPb7vhWi0kfMrkc1UGSPBHqV42KNCSVGxxW53dJ32Ux7NW8q0szcDYgRUzm3jFeCSctHiWmmTduRP6e129eW04Wwi5jPKF5xGWefTmdkfUmn6RK5XtrQMjAce9+RiGtkK2tpCmO1EPTq5skRG+RUH5N+ZE/eVoL7u3W9lTleI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id E993A85;
	Fri, 17 May 2024 15:04:12 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JIw5-MjrG2Qt; Fri, 17 May 2024 15:04:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 84A9148;
	Fri, 17 May 2024 15:04:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 84A9148
Date: Fri, 17 May 2024 15:04:08 -0700 (PDT)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Hannes Reinecke <hare@suse.de>
cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: Kernel namespaces for device mapper targets and block devices?
In-Reply-To: <a3d8bab5-9293-4765-b202-d2bbecaa1f63@suse.de>
Message-ID: <f55c2eb7-eb6d-3f95-b2c8-a28e9447e570@ewheeler.net>
References: <61c1fff7-b5ff-dfdd-62c1-506e055ae5e@ewheeler.net> <a3d8bab5-9293-4765-b202-d2bbecaa1f63@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1780651719-1715983448=:9489"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1780651719-1715983448=:9489
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 17 May 2024, Hannes Reinecke wrote:

> On 5/17/24 02:18, Eric Wheeler wrote:
> > Hello everyone,
> > 
> > Is there any work being done on namespaces for device-mapper targets, or
> > for the block layer in general?
> > 
> > For example, namespaces could make `dmsetup table` or `losetup -a` see
> > only devices mapped in that name space. I found this article from to 2013,
> > but it is quite old:
> >  https://lwn.net/Articles/564854/
> > 
> > If you know any more recent work on the topic that I would be interested.
> > Thank you for help!
> > 
> It is on my to-do list.
> We sure should work on that one.

How you envision hooking namespaces into the block layer?


--
Eric Wheeler


> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
> 
> 
> 
--8323328-1780651719-1715983448=:9489--
