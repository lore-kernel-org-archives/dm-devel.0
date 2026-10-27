Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793075359;
	b=pUf8ma7PRtQGlPlghlhJsUrltdMs0OaA8d0atyiYdj7GUvlAZndNwgt4BbNtnL2z7mpq
	 hjBsyJgSRiJFM2xT3oShMOTZV2jFRXC4EAm+JWhxWczTdo+ol/d+w3fEaPxwwdUe6AhBX
	 z0WSH4tutY+HxRURbbdqq/14/uvr2eK+2h7aNTQIIpLfP5n7kmkmYCieAw0X9nE+csYcT
	 9Lq1qi1enKvEhRz4dJysDhB+r9yHKjA2zSaCVvttko0NBjCbIoDjfbR242ledvD1MLTOU
	 k38poSZ5o/OSguq3yx3H81fnhbgAMjfDxiqLLjRakh0t68C5wFFZ4I7FkdLyQWM4EUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793075359;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=VlobbRuHN45Vr5mUHK1mAFbA/JiN83944a10oHOii8o=;
	b=yTb83rv/DzKzeMWg4v/msWys6uQMIqp9KRMBg3Qlof91kVTbBEsdNusn+msvyNxzfeiL
	 U5R7iHnhTKcGehpczPHPk3P5Me7DXMl5OvSlEuc7T6pGaE2KvfuwTmryorGy3EDQ+2ml+
	 isMaSppAh3KJy8xAXENBNRiiKICRCfPxFP00bhRHZNf5SatBl4erHAWzm7NXDXYZK/4fj
	 4fzmxu9HqPxBfMkRPoYr/jw7Gn1CC7X8zFMEhnWj9AO80cdRofu9jn0oDfpALN8ytXEG0
	 F7HM1Hi/whYOhsOxaA00PH/bXIMCzDV/eB8zxLe72mDR6vPcVTJi73od3bjC2wwuGgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="N7+1Wuz/";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D1A606A31A
	for <dm-devel@lists.linux.dev>; Tue, 27 Oct 2026 04:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98D1A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=N7+1Wuz/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793075357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VlobbRuHN45Vr5mUHK1mAFbA/JiN83944a10oHOii8o=;
	b=N7+1Wuz/jPM94ZEKATWzOZNzcCQhVXn0KgpWz4PAlviG4aXo7+vrvgbY/vL+w/IIwJr5rB
	GxMTmYZATdaE4GnpB5mtYfk47y6V9mkD7hxWmi+EP98nebsJqZ6+boiIWdyrU8oJXyF68x
	zaj9rdfSR28amLp0By1is4bKNnN/SxA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-bmVcQIz5NNOllgz5vBgNyA-1; Tue,
 27 Oct 2026 00:29:13 -0400
X-MC-Unique: bmVcQIz5NNOllgz5vBgNyA-1
X-Mimecast-MFC-AGG-ID: bmVcQIz5NNOllgz5vBgNyA_1793075352
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91BF31800635;
	Tue, 27 Oct 2026 04:29:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AFFD1800642;
	Tue, 27 Oct 2026 04:29:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69R4T9vU280352
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 00:29:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69R4T909280351;
	Tue, 27 Oct 2026 00:29:09 -0400
Date: Tue, 27 Oct 2026 00:29:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <auAolai41BgrCBK2@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
 <20261021231959.69270-1-brian@purestorage.com>
 <20261021231959.69270-2-brian@purestorage.com>
 <179270025923.152861.15521453184442767016.b4-review@b4>
 <atqpOBViqKWLZ7Q3@redhat.com>
 <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
 <atvweCfhjWkT9i-U@redhat.com>
 <c52f077ad82585f1f02d5b9cc9c3f640e9fcc031.camel@suse.com>
 <20261026180444.31357-1-brian@purestorage.com>
 <ef9e022a6ca2ed35a2a3239dc019cc5860c20986.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <ef9e022a6ca2ed35a2a3239dc019cc5860c20986.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uVcJ76EpIkXTTqgmpijInVjJaZ6LoRH8E1evysiLPn0_1793075352
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 26, 2026 at 11:23:09PM +0100, Martin Wilck wrote:
> On Mon, 2026-10-26 at 11:04 -0700, Brian Bunker wrote:
> > On Mon, 2026-10-26 at 10:26 +0100, Martin Wilck wrote:
> > > On Fri, 2026-10-23 at 19:40 -0400, Benjamin Marzinski wrote:
> > > > 
> > > > I do still waver a bit on whether or not we could leave
> > > > force_readonly
> > > > set on failed reloads. Once a device turns read-only, it should
> > > > stay
> > > > that way until we get another uevent, at which point we will call
> > > > needs_ro_update() again. Perhaps we just need to make sure that
> > > > we
> > > > clear
> > > > force_readonly when needs_ro_update() returns false.
> > > 
> > > AFAICS, this is exactly what Brian's v4 patch does. No?
> > 
> > Mostly, yes. v4 sets force_readonly back in dm_addmap_reload() when a
> > reload fails, so the next reload tries read-only again.
> > 
> > needs_ro_update() doesn't clear it on every false return, though. It
> > clears it in the dmi.read_only == ro case only when both the map and
> > the uevent are read-write and none of the map's paths is read-only.
> > If
> > a path is still read-only, the flag stays set, so a map whose read-
> > only
> > reload failed keeps retrying instead of staying read-write.
> 
> Which is correct. If the map is read-write but there are ro paths, we
> need to retry.
> 
> There are two other cases where needs_ro_update() returns false:
> 
> 1. ro == 1 && dmi.read_only == 1
>    I don't see how force_readonly could be one in this case.
>    But maybe we should just reset it anyway, just to be sure.
> 2. ro == 0 && dmi.read_only == 1 && map_has_ro_path()
>    Same here, read_only is already set, no need to force it,
>    but resetting force_read_only wouldn't hurt.
> 
> > About dm_addmap_create(): agreed that the flag isn't needed for
> > correctness there, since a new map opens all paths fresh and a
> > read-write create fails with EROFS anyway. It only saves that first
> > attempt. Create still clears the flag, so that a value set by
> > ev_add_path() can't carry over to a later reload. I can drop the
> > read-only shortcut in create if you'd prefer.
> 
> I am uncertain about this. If we know in advance that trying to set up
> the map read-write will fail, how much sense does it make to try? It's
> just a minimal simplification of our code.

Also, looking at it now, I'm kind of dubious about 430f8f89
("multipath-tools: update mpp->force_readonly in ev_add_path"), but it
does appear that there was an issue where multipath over NVMe should not
attempt to create the device read-write, if it had read-only paths. My
problem with the patch is that if that's true, I don't see why a regular
reload wouldn't just cause the device to switch to read-write again.
But I agree with Martin. There's much to be gained by pulling out the
dm_addmap_create() code.  
 
> > Uday Shankar, who did 430f8f89, also suggested dropping
> > force_readonly
> > altogether, 
> > and tracking the ro state per path in sysfs_pathinfo()
> > sounds like the right direction to me. But it changes behavior: every
> > reload, not just the one done for a DISK_RO uevent, would follow the
> > paths' ro state, and so would "multipath -r", since
> > dm_addmap_reload()
> > is in libmultipath. So I'd rather do it as a separate series on top
> > of
> > this fix, and keep this one small enough to backport.
> 
> Sounds good to me, even if it may mean that this particular patch
> will be short-lived.
> 
> Regards
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)

