Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7343713AA2A
	for <dm-devel@lists.linux.dev>; Thu, 15 Feb 2024 22:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708037143; cv=none; b=Jbp3yWGN9DId6jSpQuPs1iu2VP+SPVbBXr98XyJKowj2VcYKA7Aiit3dJNbsjoiCN240SiFapSDxYsae2MBvuSRqwfseZM2DmbgjriWjJpbn7IALdoyhbNhqHTrxvHTad+BWBxp6yBgIb/z6+SVpGyMtrbv61FN+96MtWK3CjSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708037143; c=relaxed/simple;
	bh=zCmlTndf4C9WYFNr5mqqhWZTZQzcRd/xR1bhG7r7FGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YOpYoJqf9sJyS9NKkGn7waJbRSNg3Xc4IaZzZtNmTFueYGqovAKm2SaLYjmNZMWFeQIEeYWZb4uDqg/6IXg7UWq5A3HfRu5htMT5XT1JlZ8KVhPbBH0/TyaO+SzFJrKC0rOsekKKMDgcQWYzO4TZPbXV+Ex7nQ2n+GCwVHjmcrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJ93ZH2J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJ93ZH2J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708037140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dSw+qIKFXIDGN5S25H70anC/6/OI0SmpsxzUkyDpRg=;
	b=FJ93ZH2J+/scnL74SpCrrjpfiYun2wqzVhXJJgR4jgvfc2kRMJcqoVhYqV1vMkpUU/HLJi
	zUljJ99MeP/A6HbaptOzgTBBOdgLQkpTyRRP3bgO9adnckrJV/U0kLcjQV9MnzNbk2TbdC
	0sX9vDY7GXD4TbCwJBzvyxoNDhKVhfo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-r0vCN5LkNaiLYX6KjGIbQg-1; Thu,
 15 Feb 2024 17:45:37 -0500
X-MC-Unique: r0vCN5LkNaiLYX6KjGIbQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A94C5285F995;
	Thu, 15 Feb 2024 22:45:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A25B440166C5;
	Thu, 15 Feb 2024 22:45:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41FMjaSG428256
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 17:45:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41FMjaNw428255;
	Thu, 15 Feb 2024 17:45:36 -0500
Date: Thu, 15 Feb 2024 17:45:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Peter Rajnoha <prajnoha@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        David Teigland <teigland@redhat.com>, linux-lvm@lists.linux.dev,
        dm-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>
Subject: Re: About DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN
Message-ID: <Zc6UEKsce2ppaP62@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <61638dc821c08cd97f6ac53150c5b0120f732deb.camel@suse.com>
 <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
 <9b1475e2fa5982dd508d58975b8e6eb58cad95e2.camel@suse.com>
 <f3e3db2b-8077-48b6-b507-4a9c4793affb@redhat.com>
 <8e7a574fffaded39825a01bf33482cea94507289.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8e7a574fffaded39825a01bf33482cea94507289.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Feb 12, 2024 at 03:16:27PM +0100, Martin Wilck wrote:
> On Mon, 2024-02-12 at 13:32 +0100, Peter Rajnoha wrote:
> > On 2/12/24 12:09, Martin Wilck wrote:
> > 
> > 
> > Right, underneath within DM/DM-subystem, we should be able to keep
> > and
> > restore those reasons for why it has been flagged with
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG till now and when the state is good
> > enough that we can drop it, we would do it transparently for higher
> > (non-dm and non-dm-subsystem) layers. So if there's a case that is
> > not
> > currently handled by 10-dm.rules or 11-dm-<subsystem>.rules, we can
> > fix
> > that there. If it's a generic rule that applies to all DM, not just
> > subystem, then yes, we can move that to 10-dm.rules (will have a look
> > at
> > your patch [1]).
> 
> I don't think that patch can be used as-is for DM. For multipath, I'm
> not aware of any situation where DM_UDEV_DISABLE_OTHER_RULES_FLAG would
> be set in the udev cookie, therefore DM_UDEV_DISABLE_OTHER_RULES_FLAG
> is essentially an alias for DM_SUSPENDED before 11-dm-mpath.rules
> changes it. That's not the case for other targets, in particular LVM.
> 
> > > 
> > > Well, IIUC the main reason that systemd couldn't use
> > > DM_UDEV_DISABLE_OTHER_RULES_FLAG was at least in part due to the
> > > fact
> > > that the multipath rules used it in a special way that was
> > > inconsistent
> > > with the rest of DM ;-)
> > 
> > 
> > Aha! Well, honestly, I don't remember the exact details and context
> > of
> > that fix, but I know we haven't found a better way...
> > 
> > > 
> > > I think there are 3 variants of "unusable":
> > > 
> > > a) temporarily unusable (just for this event), ignore this uevent
> > > and
> > > restore previous properties from db.
> > > b) unusable, avoid IO, don't scan, don't activate (this is how we
> > > use
> > > DM_UDEV_DISABLE_OTHER_RULES_FLAG). Upper layers will usually load
> > > saved
> > > properties from udev db in this case, too.
> > > c) like b), but also try to unmount / unconfigure if already used.
> > > This
> > > is SYSTEMD_READY=0. I don't think DM has a flag with these
> > > semantics at
> > > this time. I can imagine such a flag being set if a device was
> > > reloaded
> > > with an incompatible table, but that's rather a corner case.
> > > 
> > > It's an honorable goal to condense everything into a single
> > > variable
> > > for consumer rules, but I think it doesn't work if we want the
> > > upper
> > > layers to be able to distinguish these. We can merge a) and b) I
> > > think,
> > > because their meaning for upper layers is practically the same, if
> > > we
> > > get the saving and restoring right.
> > > 
> > 
> > The c) case - well, it's questionable what should be done in that
> > case,
> > because that means we have literally cut off the underlying device
> > while
> > it was still in use. Any further IO from higher layers will return IO
> > errors, will queue IOs or, in the worse case, issue IOs to a device
> > that
> > we don't want to anymore.
> > 
> > Anyway, if I understand correctly, we simply need to signal higher
> > layers either:
> > 
> >   A) device is unusable, forget it and clear all your current extra
> > records you have about this device (including removing any custom
> > symlinks for udev). That would also map to SYSTEMD_READY=0.
> > 
> >   B) device is unusable temporarily, restore any records you need,
> > wait
> > for the DM_UDEV_DISABLE_OTHER_RULES_FLAG=1 to drop to 0 (or being
> > unset).
> > 
> > What do you think about keeping a single
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG for this, just having a different
> > value, say "2" to denote the B case? Otherwise, we need 2 distinct
> > variables (which is harder for others to accept I bet).
> 
> Yes, that could work, if the save / restore is implemented cleanly.

What if we never read DM_UDEV_DISABLE_OTHER_RULES_FLAG from the
database. Instead how about, if DM_UDEV_DISABLE_OTHER_RULES_FLAG is set
by "dmsetup udevflags", we save it as something like DM_IGNORE_DEVICE.
Otherwise, if it's a spurious event, we read DM_IGNORE_DEVICE from the
database. After "dm_flags_done", if DM_IGNORE_DEVICE is set, we set
DM_UDEV_DISABLE_OTHER_RULES_FLAG. This leaves the other rules free to
mess with DM_UDEV_DISABLE_OTHER_RULES_FLAG all they want.

> > 
> > > > The DM_NOSCAN was actually just a helper and a more human
> > > > readable
> > > > name
> > > > for "DM_SUSBYSTEM_UDEV_FLAG0" within LVM subsystem *only* at
> > > > first.
> > > > It is used during LV initialization - the wiping/zeroing of the
> > > > LV
> > > > before it is pronounced as usable - that's why, when it is set,
> > > > we
> > > > signal to "others" the DM_UDEV_DISABLE_OTHER_RULES_FLAG based on
> > > > this
> > > > flag. However, since we have the 13-dm-disk.rules which manages
> > > > the
> > > > blkid call for DM devices (and which is ours - owned by DM), we
> > > > need
> > > > to
> > > > signal these rules to avoid calling blkid (as it could see
> > > > uninitiliazed/stale data). In this case, we import any previous
> > > > scan
> > > > results from udev db. It's not like "completely ignore and skip
> > > > rules
> > > > for this event".
> > > 
> > > I'm not sure if I understand what you mean with "completely ignore
> > > and
> > > skip". Upper-level rules usually can't "completely ignore" an
> > > uevent if
> > > they need to preserve any udev properties across the current event.
> > > If
> > > the device is unusable in the weaker "don't try IO" sense, the
> > > upper
> > > rules must import existing properties from the db, just like 13-dm-
> > > disk.rules, lest the properties be forgotten by udev. IMO this
> > > weaker
> > > semantics (corresponding to b) above) is what matters most for
> > > upper
> > > level rules.
> > 
> > I didn't consider that there might be extra records to keep around
> > for
> > anything else than blkid (13-dm-disk.rules) and DM/DM subsys (10-dm
> > and
> > 11-dm-subsystem.rules). But you're probably right here -
> > differentiating
> > the A) and B) from above could be beneficial for some layers above.
> > If
> > nothing else, then at least the systemd's SYSTEMD_READY case in
> > 99-systemd.rules.
> > 
> > If we could still keep the single DM_UDEV_DISABLE_OTHER_RULES_FLAG
> > for
> > others to check, I'd really like to have only that one, not adding
> > more.
> 
> I'm fine with that, but changes to higher-level rules will be necessary
> either way, be it only that they refrain from accessing those variables
> that we don't want them to access.
> 
> I the longer term, I suggest that properties that we don't want higher
> layers to access be marked as such [*]. For example, DM_NOSCAN could be
> replaced by __DM_NOSCAN, following the widely respected convention that
> symbols starting with underscores should be left alone. DM_SUSPENDED
> could actually be replaced by .DM_SUSPENDED, which would correctly
> reflect the fact that it's never restored from the udev db (as
> properties starting with "." aren't saved to the db).
> 
> Thanks,
> Martin
> 
> [*] I think the suggestive names of DM_NOSCAN and DM_SUSPENDED have
> have contibuted to their adoption by 3rd parties. Sometimes it's better
> to use non-intuitive variable names like DM_UDEV_SUBSYSTEM_FLAG0 :-)

