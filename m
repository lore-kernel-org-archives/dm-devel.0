Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C71FD1
	for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 02:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707531427; cv=none; b=XEAhaSI6dBPEzDmm+d3zy1KNoXPSAv8q4odBj2PGZPApUUIpYHSSF4a3bDcPCwL+MQFraCbXovqv09yU7FHVwkltZKpqVapmISO63PQ2qWYyIsIRTmpRlMsLk5adexdzMG2weucp510fd7f4wh/HcaCMPAla754mKQ4FBTOzBqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707531427; c=relaxed/simple;
	bh=iVY6HMOtvTckMQKJdUIoq1h9nUpHIc2mWuu87dwAXcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=cGWfUK3Z1Gmf/EzzWqPp06/rv/R9k0QsBSwLFUsNm/BjrvnbUNR9UuhAc8f4m/ATmJwPVIhSMl85TZ5k6purIva7ZEXwg4iqGmCeayetEQdtJs+oMFoloDwb3L+XD10xO19pAo0PzDcBV1AD8g3ENG2cR1n3+O/02p425vRXFis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzW4VjVM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzW4VjVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707531424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fSK3eVZfuPhZtL5TTV+MUpq6Sb/at30Mhu6CEbZhCJA=;
	b=IzW4VjVMXU7y9I7PQJX5OFGgQCFLFyXawA79NMwu3aP7TQiod9Ql95a173ulExwMd2YsTv
	UQefrgMId2Lwaj0hYQaWvJPILIPKkRhh3+FGZsG1eqqC8Ipy+P65yx4e3ExyjNYmLJ60e7
	H23zSAfOCoWY1beLql7nOwjB6EJ9tiU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-mVqBH8C0OwqcQCoyF0GLIw-1; Fri,
 09 Feb 2024 21:17:02 -0500
X-MC-Unique: mVqBH8C0OwqcQCoyF0GLIw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B61BA29AC031;
	Sat, 10 Feb 2024 02:17:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE554492BE2;
	Sat, 10 Feb 2024 02:17:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41A2H1RI352523
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 21:17:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41A2H1tO352522;
	Fri, 9 Feb 2024 21:17:01 -0500
Date: Fri, 9 Feb 2024 21:17:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH v2 4/7] 11-dm-mpath.rules: don't save
 DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD
Message-ID: <ZcbcnWHA4OzbnVhj@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240209232735.9791-1-mwilck@suse.com>
 <20240209232735.9791-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240209232735.9791-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 10, 2024 at 12:27:32AM +0100, Martin Wilck wrote:
> The current rules overwrite DM_UDEV_DISABLE_OTHER_RULES_FLAG and save its
> value in DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD if MPATH_DEVICE_READY changes
> from 1 to 0, and restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from
> DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD when MPATH_DEVICE_READY changes back from
> 0 to 1.
> 
> This is wrong for multiple reasons. For "spurious" events, 10-dm.rules will
> read DM_UDEV_DISABLE_OTHER_RULES_FLAG from the udev db and obtain the value
> saved by 11-dm-mpath.rules rather than it's own saved value, which confuses
> the logic in 10-dm.rules. 10-dm.rules sets the flag if either DISK_RO==1 or
> DM_SUSPENDED==1, and never clears it (it can only be cleared by a new genuine
> libdm event that doesn't have DM_UDEV_DISABLE_OTHER_RULES_FLAG set, while the
> device is not suspended). lvm commands may set the flag, too, but AFAICS this
> is only done for certain types of logical volumes, not for multipath maps.
> 
> If a previously suspended device is resumed, DM_UDEV_DISABLE_OTHER_RULES_FLAG
> would be cleared, and it would be wrong for 11-dm-mpath.rules to overwrite it
> with a previuosly saved value. Likewise, if a uevent arrives for a suspended
> map, and MPATH_DEVICE_READY happens to switch from 0 to 1, it would be wrong
> to clear DM_UDEV_DISABLE_OTHER_RULES_FLAG by setting it to a previously saved
> value.
> 
> We need to set DM_UDEV_DISABLE_OTHER_RULES_FLAG=1 to prevent follow-up rules
> from attempting I/O on the device. But don't try to save and restore
> DM_UDEV_DISABLE_OTHER_RULES_FLAG between uevents. Rather, reset
> DM_UDEV_DISABLE_OTHER_RULES_FLAG to the value we got from 10-dm.rules in a
> late rule. I chose "z0" for this rule's prefix to make sure it needs to run
> very late (after 99-systemd.rules, for example) while still allowing some
> reasonable space after it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Is z0-dm-mpath-last.rules the right way to name this?  I'm a little
worried that something will expect a two-digit beginning to udev rules
files, and a name like 99-z0-dm-mpath-last.rules would be more
appropriate (if even longer). In a perfect world we'd be able to get all
all the rules to use .DM_UDEV_DISABLE_OTHER_RULES_FLAG which was
initialized to DM_UDEV_DISABLE_OTHER_RULES_FLAG in 10-dm.rules, so we
had a non-saved flag to play with.

But assuming that z0-dm-mpath-last.rules is o.k., everything else looks
fine, so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipath/11-dm-mpath.rules.in   | 19 +++++++++----------
>  multipath/Makefile               |  2 ++
>  multipath/z0-dm-mpath-late.rules |  4 ++++
>  3 files changed, 15 insertions(+), 10 deletions(-)
>  create mode 100644 multipath/z0-dm-mpath-late.rules
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 54d01a6..e31107b 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -2,7 +2,6 @@ ACTION!="add|change", GOTO="mpath_end"
>  ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
>  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  
> -IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
>  IMPORT{db}="MPATH_DEVICE_READY"
>  
>  # Coldplug event while device is suspended (e.g. during a reload)
> @@ -79,16 +78,16 @@ LABEL="force_activation"
>  # We'd like to avoid this, especially within udev processing.
>  ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
>  
> -# Also skip all foreign rules if no path is available.
> -# Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
> -# and restore it back once we have at least one path available.
> -ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1", \
> -	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="", \
> -	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
> -ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +# Skip all foreign rules if no path is available.
> +# Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
> +# to upper layers. The original value will be restored in a late
> +# udev rule.
> +ENV{MPATH_DEVICE_READY}=="0", \
> +	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
> +	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +# If the device comes back online, set DM_ACTIVATION so that
> +# upper layers do a rescan.
>  ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
> -	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}", \
> -	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="", \
>  	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
>  
>  # The code to check multipath state ends here. We need to set
> diff --git a/multipath/Makefile b/multipath/Makefile
> index f8c1f5e..2f2569c 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -26,6 +26,7 @@ install:
>  	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
> +	$(Q)$(INSTALL_PROGRAM) -m 644 z0-dm-mpath-late.rules $(DESTDIR)$(udevrulesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
> @@ -46,6 +47,7 @@ endif
>  uninstall:
>  	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC)
>  	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
> +	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/z0-dm-mpath-late.rules
>  	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
>  	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
>  	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
> diff --git a/multipath/z0-dm-mpath-late.rules b/multipath/z0-dm-mpath-late.rules
> new file mode 100644
> index 0000000..8574b1a
> --- /dev/null
> +++ b/multipath/z0-dm-mpath-late.rules
> @@ -0,0 +1,4 @@
> +# If DM_UDEV_DISABLE_OTHER_RULES_FLAG was modified in 11-dm-mpath.rules,
> +# restore it here, lest a temporary value be saved in the udev db
> +ACTION=="add|change", ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}=="?*", \
> +    ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}"
> -- 
> 2.43.0

