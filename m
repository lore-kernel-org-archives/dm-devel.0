Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793076744;
	b=cIwN3WfDo0EmS9j61q08oo0tusbcftqtc6ie4/yxIVj0edSyyakKdnAes3sXxqjCHD0J
	 E1bXe1XprIez6QwWnNj2n5/hWq3+gQZFQoO93clVat2/Y0jqqypmuPT/jzO2QaRZ0hJl0
	 HgYNug/0ZMKoY/wylMlAaxBPes6Y77u0Mv6typN6FapoWEAjO+3rrQfDX9Awg2wuh+t1e
	 TDMlHkGm6XvyTqu3zrd+pziLRZXes9YS6UjHlT+fpx7ddwveJKIibQvtVUfPTLaPfbiTv
	 C65r6ajUgGUYHiukx+g7/JKxuslZlrpInOrk9XTtf2lZyB6v9UVWVi4zQOw0c9ecO/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793076744;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=kpJ5jBlZESD1WBMqeYU8uEOy+DHO7NY6LRZ9zaW/x0s=;
	b=c7Zy1efLsxCTZWIm3dAyA/W+IVAOT4MyeFczWC6YkVo7x9g6z/K9dALImhzrLe07TbJ+
	 Z9X7ud0KcE5PUWj1F9xB4jQFiTi2E2sqX45URSlsAse06nb3++ZvEniccVihp86RD+vO6
	 8BVVB2RQCq/C4og7FHYMQvrZLR+V7G7ci1i5OXCSw8L7zn/cLbbbGysDE1sWrtzpRwssc
	 vewJJS+RtfCRRtFv/f3kNAgOnOetiK6IHb3qFXfjrNMUl2VI1WLJ8he0huKR7rPkDZODo
	 47yKeSUIaIR8B7NL/18xhqBJAcW2G+T5UA3kcEXmtYKBTDhJGihabjpX0WodaexPZWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="c8A/rH5W";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76C7606A31A
	for <dm-devel@lists.linux.dev>; Tue, 27 Oct 2026 04:52:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A76C7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c8A/rH5W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793076742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kpJ5jBlZESD1WBMqeYU8uEOy+DHO7NY6LRZ9zaW/x0s=;
	b=c8A/rH5WhbJK2QHfVxvkjVduci7EB5+KnRmoaUP/GAKEX6stXPiugVEMtdffQj8v80ijpb
	yQtxFMoEsohy6dwTgb2K0k4imRk+mkhAhIUEMB7LaOoXAG4DEHlHMxDm/yMnyAfhxt1JNw
	Fg/+YSMRVG4j5a9FgHBm1PeJUmCQNT4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-FoHDkL52N_i1mc5sJsfLcA-1; Tue,
 27 Oct 2026 00:52:20 -0400
X-MC-Unique: FoHDkL52N_i1mc5sJsfLcA-1
X-Mimecast-MFC-AGG-ID: FoHDkL52N_i1mc5sJsfLcA_1793076739
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C0511955BCC;
	Tue, 27 Oct 2026 04:52:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8927180057F;
	Tue, 27 Oct 2026 04:52:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69R4qHgb281033
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 00:52:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69R4qHxL281032;
	Tue, 27 Oct 2026 00:52:17 -0400
Date: Tue, 27 Oct 2026 00:52:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <auAuAQ-JR4WveD2D@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
 <20261021231959.69270-1-brian@purestorage.com>
 <20261021231959.69270-2-brian@purestorage.com>
 <179270025923.152861.15521453184442767016.b4-review@b4>
 <atqpOBViqKWLZ7Q3@redhat.com>
 <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
 <atvweCfhjWkT9i-U@redhat.com>
 <5bb12dded4b0686d4246274a467d6adf6044cb18.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <5bb12dded4b0686d4246274a467d6adf6044cb18.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R48iZAwUZqfyWiTNVgWqSJiVqYex4RVHf50ksEbbndg_1793076739
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 26, 2026 at 11:20:35PM +0100, Martin Wilck wrote:
> On Fri, 2026-10-23 at 19:40 -0400, Benjamin Marzinski wrote:
> > 
> > To solve this, whenever multipath detects that a device has switched
> > to
> > read-only, it forces a read-only table reload, so that all the path
> > devices get re-opened read-only (since their requested mode doesn't
> > match their current mode).
> 
> I am sorry, I guess I am just looking in the wrong place. But the way I
> read the code in dm_get_device() [1], the kernel will re-open a device
> only if the mode is upgraded, i.e. switched from ro to rw.
> 
> [1] https://elixir.bootlin.com/linux/v7.3/source/drivers/md/dm-table.c#L398
> 
> I don't see how a switch from rw to ro would cause a device to be
> reopened.

That only happens if find_device() already found that device in THIS
table (it's called with t->devices). For instance, the dm-delay table
can list the same device three times. Instead of opening the device 3
times, you just open it once.  Additionally, if you have already opened
the device in the current table in a mode that includes the capabilites
of the mode you need in a future call to dm_get_device() it will just
use the existing open. If you need more capabilites, you will upgrade
the open.

What matters in the multipath case is if the device isn't found in the
existing table. In that case you call dm_get_table_device(), which
calls find_table_device(). This looks for a device in the
md->table_devices list, which includes devices from all tables. But in
this case, the mode must match exactly
https://elixir.bootlin.com/linux/v7.3/source/drivers/md/dm.c#L807

Thinking about it now, I'm actually not sure if that upgrading from
dm_get_device() is a good thing. If a target asks to open multiple
copies of the same device with different modes, and dm gives it one open
that has a union of all the modes, it seems like we've dropped some
safety guardrails. I'm not sure off the top of my head if there actually
is a target that does this.

-Ben

> 
> Thanks
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)

