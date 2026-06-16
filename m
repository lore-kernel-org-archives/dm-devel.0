Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3240F32C302
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781647773; cv=none; b=GbDBnwurSjaSzly4C6xxUpqbPe1cdpkuJycVKlIz2WWUy+zJm1tkGx3S0nR6gwLu1rWx0yQeWNLwvnXh5vZNKXJbzmJ2Q3xv4tJUDkY4UdPjmWTm5cz5cp9Acc/TVE3EQHyR7WlCqQJ0Wx3D6DzkYTy5hQC7vlslJocJbD9yOC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781647773; c=relaxed/simple;
	bh=u7Acz4/EmlGMZP0ENguuzbniRP2Rd6xM5BUbVOlguhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZeuxNLP/J/Psy18tt0CunYu6oC3bINn/2Z2f/N0Y+91orsocVos3qZyrmzKqPpfOLjKC/PcCpQebjMgaR+ttbpbQpdSw3nxkVe1MyiU0JHA8hhIAyck+PcXS88xUBl3kQ2mw9+v+2SYXkf7OEN4TvGhTSODjrooWsOpqPNKhQ5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOXelE4g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOXelE4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781647771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gkYW+y5kSw11T2KfT58b2R96LEZS+Dw2HJRMvyrOgRs=;
	b=GOXelE4g+xwSfkB4JcsaIrA2T3YqeADBkUQMXZ117/TrkUCsQZPjDudVq2ZjEiEtFLIyF6
	gXboT2jydycSgl2x6IbjQDVV0iKuUX++EarKbtlXO+Ngy+L5V1sIFick+pVyg3fzWyYm9I
	eoFNk8/zbq6xoyYbDmeaDzf1Qt/d1s0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-CREJDNqENkOhTYYDb0iD8A-1; Tue,
 16 Jun 2026 18:09:27 -0400
X-MC-Unique: CREJDNqENkOhTYYDb0iD8A-1
X-Mimecast-MFC-AGG-ID: CREJDNqENkOhTYYDb0iD8A_1781647766
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C5B31800663;
	Tue, 16 Jun 2026 22:09:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DF76180034F;
	Tue, 16 Jun 2026 22:09:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65GM9O7B841777
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 18:09:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65GM9OXP841776;
	Tue, 16 Jun 2026 18:09:24 -0400
Date: Tue, 16 Jun 2026 18:09:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 0/8] multipath-tools: clean up man pages
Message-ID: <ajHJlIzjFQdYJBX3@redhat.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260616122909.244619-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mhJhYz2QbHqNN7voB8HZE8JrFdU_EBeSOOYeTL5Xdg8_1781647766
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 02:28:56PM +0200, Xose Vazquez Perez wrote:
> It performs general cleanups, updates, and formatting fixes
> across the man pages, incorporating feedback from Martin and Ben.
> 
> Please let me know if further adjustments are needed.
> 
> 
> v2:
>    - Merge "clean up man pages" and "clean up man pages II" series into
>       one batch (requested by Martin).
> 
>    - (5/8) fix typo, s/group/groups (spotted by Martin).
> 
>    - (7/8) fix copy-paste typo and delete <n>, changing "\IBmpath<n>\fR"
>       to "\fImpath\fR" (spotted by Martin).
> 
> 
> Xose Vazquez Perez (8):
>   multipath-tools: delete obsolete information from multipath.conf.5
>   multipath-tools: remove explicit width from .TP macros in multipath.conf.5
>   multipath-tools: remove explicit widths from macros in the remaining man pages
>   multipath-tools: remove syntax check comments from man pages
>   multipath-tools: clarify path selector descriptions in multipath.conf.5
>   multipath-tools: specify file paths using variables and add FILES section in multipath.conf.5
>   multipath-tools: clarify user_friendly_names prefix behavior in multipath.conf.5
>   multipath-tools: fix mandoc errors/warnings in man pages
> 
>  kpartx/kpartx.8                               |   4 -
>  libmpathpersist/mpath_persistent_reserve_in.3 |   9 +-
>  .../mpath_persistent_reserve_out.3            |   9 +-
>  mpathpersist/mpathpersist.8.in                |   8 +-
>  multipath/multipath.8.in                      |  10 +-
>  multipath/multipath.conf.5.in                 | 216 ++++++++----------
>  multipathd/multipathc.8                       |   6 +-
>  multipathd/multipathd.8.in                    |  14 +-
>  8 files changed, 102 insertions(+), 174 deletions(-)
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Notwithstanding my nitpick in patch 5,
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> -- 
> 2.54.0

