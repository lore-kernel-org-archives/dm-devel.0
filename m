Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794263080;
	b=sXbHUgqyX6xhgcIKyo8RxG0Q400XMM3VuCv807BHwolBxoDtQboa6YhSx9/vXoDHNt8g
	 EsV2xuNIW1fBSk1Y+xqdMwJ2w/Q5KUqFHcZxeBnFJHmHUGW3vBUjgJMO4+MgY0V0VDCJk
	 UjWTZWh63vVuk6w7QD38pXAS7zYnvq8JHbGM0t3aJLAwtU7bUMvkbyYvZnt8HUcbODrUo
	 uE3gOPeKGaTUzbHsWI3kzfMw8adU6+l+7uZBzFFrCExC0mf6zqW/Ti5ADtgiA/WyW4BPt
	 4wY4rcVqY6SoNxYtrMubw7dtcbZfQ92nLlQsvD7Bhp5G4rZbOC4KaC/8WVdbvictRqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794263080;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=7tPKQqP/VMOLPU/uQJd69AuBwr3eSp55T3DEMn/sbAk=;
	b=1yuOzUWEprn7yieBLzf4UH1eyhh9stfACaDvnHk2680o6o+OJ6prTKNUZQxWZTFGF5zA
	 khfsALiKwSB7xJ+wHes4LlZ44BTobcZK1jWzPpdDFN4I2+ejT43wt8nP8bMJ3JjMiTWNf
	 740HAwrGyD2k8O0srFkB/h8OPZSTmP/g/AgC/puGlVoA3c0XlvfneiZ5d3JFDRhhoNDZt
	 Y9K8c4Gy0yCCWyXwSYwV0vMM/NKjjpkB7lZzIcmebZJMMPnC5R5k3HAcgDeI/Ynzpjzcr
	 T2lXhCpbiF/sBMEeoFY1CFNVBd6KPhzg0DeyD8tsMxIk/nwfDNoy8oAeW/MlqT9X+Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JkFrx0DX;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1906C606A31C
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 22:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1906C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JkFrx0DX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794263079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7tPKQqP/VMOLPU/uQJd69AuBwr3eSp55T3DEMn/sbAk=;
	b=JkFrx0DXhGEFQRq3UG6L61715qtWS9/Fvz3T+xVVH2VpEcIrVH8C2IosgR7Ol8oM+SlT+m
	3KY3gBPLRTRvA0De5nMvqwF7Hh7kca5SCtWOZrjPe6uMRxoDM3jwRn+lWpeUCkMk6yvSOO
	LyaqLqxc0Z8mPbaq8VWKN3U4pJqPqXs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-sKXScFhLMzWYAgyfLYze4A-1; Mon,
 09 Nov 2026 17:24:35 -0500
X-MC-Unique: sKXScFhLMzWYAgyfLYze4A-1
X-Mimecast-MFC-AGG-ID: sKXScFhLMzWYAgyfLYze4A_1794263074
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AF08180047A;
	Mon,  9 Nov 2026 22:24:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80CE41956086;
	Mon,  9 Nov 2026 22:24:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6A9MOWrP637820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 9 Nov 2026 17:24:32 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6A9MOV2l637815;
	Mon, 9 Nov 2026 17:24:31 -0500
Date: Mon, 9 Nov 2026 17:24:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com, christophe.varoqui@opensvc.com
Subject: Re: [PATCH v3 1/1] multipathd: check re-added paths' WWIDs against
 sysfs
Message-ID: <avJIHyW4teKMrmM_@redhat.com>
References: <20261109185556.27139-1-brian@purestorage.com>
 <20261109185556.27139-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261109185556.27139-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ploa6nVQZvWIrQQMwkn8J54nJqJIr-lDQVLS-Xq_mBM_1794263074
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 09, 2026 at 10:55:55AM -0800, Brian Bunker wrote:
> multipathd takes a path's WWID from udev. When a change uevent reports
> a different WWID, uev_update_path() removes the path from its map and
> re-adds it through uev_add_path(), which places it in whatever map owns
> the new WWID. If the udev value is wrong, or the uevent is stale by the
> time it is processed, the path goes into the map of a different LUN and
> I/O for one LUN is silently sent to another.
> 
> Before such a re-add puts the path into a map, compare its WWID with
> one built from the VPD page 0x83 data the kernel caches in sysfs. If
> they differ, leave the path out of the map: orphan it, clear its WWID
> and mark it INIT_MISSING_UDEV, so the checker retriggers udev and the
> path is re-added from fresh data. This reads no data from the device,
> so it can't hang. The check only runs for paths where
> can_recheck_wwid() is true, where the udev WWID and the one built from
> sysfs come from the same designator selection.
> 
> To tell re-adds from ordinary adds, turn the need_do_map argument of
> uev_add_path() and ev_add_path() into enum path_add_mode, with a new
> PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and is passed only
> for the re-add at the end of uev_update_path(). Ordinary adds are
> unchanged.
> 
> Add get_sysfs_wwid() to libmultipath. It shares get_vpd_uid() and the
> WWID clean-up in get_uid() with the existing sysfs fallback, so both
> build the WWID the same way.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>

I'm interested in seeing if this resolves Martin's issues, but as
far as I'm concerned:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

