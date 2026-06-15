Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069863D6688
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781512507; cv=none; b=XzZGmBINs6alWOfx/brXv+XE3CKBm77onUM52rJn/XSxCGHbXkduzyNtFNO3lB9vlyEYXoazSPN2Xu482r6CxAV9MvOwr05FhSYVZ6pYeOuN9yc+k5LkBU7rBmhq3NVb4U8KNuW4LNPdez1QrocKCOmTbMk585dNRW1NJCOQDRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781512507; c=relaxed/simple;
	bh=/3ixvILgJFwO8+8meaKS6WP8gQg66LRPMNx0uUTAgXc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nKNVQjuNNPyHd1NCCoPyGOHgYeEP+gMUGb3G3490iVvfKf3/BuJ99NErZxPuaT5ht99/UCoq3pZlVRQqD/AF4IpnMnKkikW4NH4YQnAgGECNPHwEG59PaP1eFKBSxDB7vATdtsRx8UMFHt73v6kYsXLKks86NN2D9wQfDJDETNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E2Rh89wT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E2Rh89wT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781512500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RK56bcfdzhUEzf86OpRCPFqK3g4YOUqB23+/OdLDJKY=;
	b=E2Rh89wTwPOHokwNErZcrc4Pc1uVzCqfoofro+/ZALMOws4r2rQ7IM3mfvPcbVSWY9xOpn
	H/MEGE2Tsj0gcuP75D7+qR8W4oQvre2bvnCcOhaEsfdZOwjaq+qDP8nVhu5K/BUaOtvJNl
	Ci+rGv+65bnkr0MebU40GkXuL6HhJ/4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-nFRNU-sSOziTbxqBdoEUUg-1; Mon,
 15 Jun 2026 04:34:57 -0400
X-MC-Unique: nFRNU-sSOziTbxqBdoEUUg-1
X-Mimecast-MFC-AGG-ID: nFRNU-sSOziTbxqBdoEUUg_1781512496
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00E0819560BA;
	Mon, 15 Jun 2026 08:34:56 +0000 (UTC)
Received: from [10.44.32.53] (unknown [10.44.32.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8E4330001A1;
	Mon, 15 Jun 2026 08:34:53 +0000 (UTC)
Date: Mon, 15 Jun 2026 10:34:46 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
cc: Eric Biggers <ebiggers@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
In-Reply-To: <13febc50-41b2-479c-97f3-f3eecc648871@oss.qualcomm.com>
Message-ID: <5a1403ea-bec3-f414-c322-5c19edee5bf0@redhat.com>
References: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com> <13febc50-41b2-479c-97f3-f3eecc648871@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: jFNglRRDdf5PtfeXIYWRdXDuw6iU_QZIwXsJnlFZ6tQ_1781512496
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 15 Jun 2026, Linlin Zhang wrote:

> Hi Milan, Eric and Mikulas,
> 
> Do you have a chance to help review this patch?
> 
> I'm appreciated if you can help give some comments or accept and help merge this patch.
> 
> Thanks,
> Linlin

Hi

I already accepted this patch, I will send it to Linus in this merge 
window.

Mikulas

> On 5/25/2026 8:13 PM, Linlin Zhang wrote:
> > dm-inlinecrypt currently assumes that all keys are raw software keys.
> > That does not work for platforms where inline encryption expects
> > hardware-wrapped key material managed by secure firmware/hardware.
> > 
> > This series adds support for hardware-wrapped keys in dm-inlinecrypt by
> > introducing an optional <key_type> target argument. The flag lets
> > dm-inlinecrypt select the proper blk-crypto key type at key
> > initialization time:
> > 
> > - 1: BLK_CRYPTO_KEY_TYPE_RAW
> > - 2: BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> > 
> > With this change, dm-inlinecrypt can support both raw and wrapped key
> > deployment models without hardcoding one key ownership model.
> > The series also:
> > - updates target argument parsing to include the new required flag
> > - propagates the wrapped/raw state in target status output
> > - updates dm-inlinecrypt documentation and examples accordingly
> > Linlin Zhang (1):
> >   dm-inlinecrypt: add support for hardware-wrapped keys
> > 
> >  .../device-mapper/dm-inlinecrypt.rst          | 20 +++---
> >  drivers/md/dm-inlinecrypt.c                   | 63 ++++++++++++-------
> >  2 files changed, 54 insertions(+), 29 deletions(-)
> > 
> 

