Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6D2836AF
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 20:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765227033; cv=none; b=VV2uPxMfssFdiOG+oL0zY7zqcTd05D3jCBxRMIChVesWZH1ikyBBYveDewqfWHx8U+IC2czISpKkgAPsFZ515+nUoxHFndcFQLPcgNg7kGzxVqf809d2zyVn5IUozr6VdqJHBD4HFtalySsf5BHbtWizaf4k5SoyhSXaZNkFejs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765227033; c=relaxed/simple;
	bh=wAcpN5h7rtAz2VErwYAiFovK20w0n2Am1VYazi56kSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VyJnqhC+DSDAqQkauGPLYcNeifFkYF+YwQBsfJNAFml7UFIK6rhnbr4p++jaxJT2ffR9NlbvXjuWo24amFAyPL0wCbxckGBg7xBsL6druunRKhxkXIZJB5jRoI7EbHu5QGPa/OvkkJMH398Lt0Cg8t3aDkKi4hebe8Noyh4rW+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eeixR3eR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eeixR3eR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765227030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXdSxUuVNvAnTj2HpQBWbpmM8ZL5VN5oP+Ey1YThz28=;
	b=eeixR3eRQVHD+VQBhZvn4aYAnu1171zZhXtHgWubpAlEzeOFJiX11Xvg8mlhrYVp8vuhK/
	X4cPYel2gqEQBgPK/Ly0kMjVj5VORXal8R5FNHGE47qItOfJVGntSBFwQf1Id5VkKWW7Nz
	kpFJCpSRDzJK7zTluaNYCoZY8CsBPj8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-RqQjNhj-OcieaS8QoIgECg-1; Mon,
 08 Dec 2025 15:50:27 -0500
X-MC-Unique: RqQjNhj-OcieaS8QoIgECg-1
X-Mimecast-MFC-AGG-ID: RqQjNhj-OcieaS8QoIgECg_1765227026
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B5BE18001D7;
	Mon,  8 Dec 2025 20:50:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7826F1800451;
	Mon,  8 Dec 2025 20:50:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B8KoOM61709593
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Dec 2025 15:50:24 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B8KoNZk1709592;
	Mon, 8 Dec 2025 15:50:23 -0500
Date: Mon, 8 Dec 2025 15:50:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 4/4] libmpathpersist: fix code for skipping multipathd
 path registration
Message-ID: <aTc6DyGc8DWjhtxY@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
 <20251202030213.1432964-5-bmarzins@redhat.com>
 <44ac6212bf407913ed7bd6fff15dda195c7d9135.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <44ac6212bf407913ed7bd6fff15dda195c7d9135.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aXRs0fl5pQygMkk4kJ3FyRhCvufRFryqY9_7By6CvyM_1765227026
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 08, 2025 at 03:46:56PM +0100, Martin Wilck wrote:
> On Mon, 2025-12-01 at 22:02 -0500, Benjamin Marzinski wrote:
> > When libmpathpersist notifies multipathd that a key has been
> > registered,
> > cli_setprstatus() calls pr_register_active_paths() with a flag to let
> > it
> > know that the paths are likely already registered, and it can skip
> > re-registering them, as long as the number of active paths matches
> > the
> > number of registered keys. This shortcut can fail, causing multipathd
> > to
> > not register needed paths, if either a path becomes usable and
> > another
> > becomes unusable while libmpathpersist is running or if there already
> > were registered keys for I_T Nexus's that don't correspond to path
> > devices.
> > 
> > To make this shortcut work in cases like that, this commit adds a new
> > multipathd command "setprstatus map <map> pathlist <pathlist>", where
> > <pathlist> is a quoted, comma separated list of scsi path devices.
> > libmpathpersist will send out the list of paths it registered the key
> > on. pr_register_active_paths() will skip calling
> > mpath_pr_event_handle()
> > for paths on that list.
> > 
> > In order to deal with the possiblity of a preempt occuring while
> > libmpathpersist was running, the code still needs to check that it
> > has
> > the expected number of keys.
> > 
> > Fixes: f7d6cd17 ("multipathd: Fix race while registering PR key")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c |  6 +--
> >  libmpathpersist/mpath_updatepr.c    | 48 +++++++++++++++++------
> >  libmpathpersist/mpathpr.h           |  4 +-
> >  multipathd/callbacks.c              |  1 +
> >  multipathd/cli.c                    |  1 +
> >  multipathd/cli.h                    |  2 +
> >  multipathd/cli_handlers.c           | 39 ++++++++++++++++--
> >  multipathd/main.c                   | 61 +++++++++++++++++++--------
> > --
> >  multipathd/main.h                   |  3 +-
> >  multipathd/multipathd.8.in          |  6 +++
> >  10 files changed, 132 insertions(+), 39 deletions(-)
> 
> I may be missing something, but this is quite a lot of additional
> complexity just for the shortcut. Have you considered just not taking
> the shortcut in the first place?

Yep. But that means that whenever you register a multipath device with
mpathpersist, multipathd will (almost always pointlessly) re-register
all the paths, just to make sure it doesn't hit these super rare corner
cases. So this added complexity keeps multipathd from running unnecesary
scsi PR commands, and should be quicker. All multipathd does is break
the new cli message up into pathnames, and then has
pr_register_active_paths() check the paths against the pathanames, and
skip them if they match and the number of keys is as big as expected
(and it needs to check the number of keys regardless of whether it uses
the shortcut).

I thought briefly about pulling all the path registration work into
multipathd, but it ends up making multipathd even more complex than this
shortcut, while not saving much complexity from libmpathpersist. If we
wanted to make multipathd handle all of libmpathpersists work, that
would be a different story, but I'm still not sold on the idea of doing
that.

That being said, we can drop a chunk of code if we just force
multipathd to automatically reregister the paths. So if you think that
the reduced work is not worth the added complexity, I'm o.k. with
pulling the shortcut out completely.

-Ben
 
> Martin

