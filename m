Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7B288B8
	for <dm-devel@lists.linux.dev>; Mon, 27 Jul 2026 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168580; cv=none; b=ZKivHp7zuUQVhm33wMjYoQBU2veUOb/F5WPLWcCbPRk979DXWuEDPruCGceNRGa9O6ze9BIomG+lsRS0R19sFE7L3FIpKdEhHgRz4x26UyNS1QPx9bCndS5bvEGEuw9vvadveu1VA5jDhqAkezEOzAPGSUhrkzhMFCvavlycqmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168580; c=relaxed/simple;
	bh=p46QF4q3YzA0a+QVJNYR0+y4ebsQbmmll0sMz2idgC0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Rd0ntJCUDwz8zikFG9oidl+sGpPm5Go/fRA1Z4YuYsEYBWOf/YXAVpu2ZJQOUGMmp8siF6UY0N7Z36Nbyo8wsIykbqrYRN25Kk1DrYTBD+pnzxXGwBqmr9k/MWJ4O4a6trG2girK2vUCwaqYN5GnXsuUb27Odijo7Pp7WqtcxIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=In14r1Nu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="In14r1Nu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785168578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSfRXRIbpqN7bdv7KoAVPTERQMpHVCEfoQKdU9y9kiE=;
	b=In14r1Nuc0NGr78gLaDq/iqIss4dB0sLfEEKMfo6kztddzPdBL2F7RQUj+MzpLTzz8z/mi
	lQkOwBEVw6fpogVTl9FhJeydR/ngJJf2DLKKeNPnON/dPZmFN/7IGP3iQKu/s0D8SpLzJX
	kk/k0Drd08CSnjuedy7KdBiBrGhsvr8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-zmip40KzPy-jTsATyJUDfw-1; Mon,
 27 Jul 2026 12:09:32 -0400
X-MC-Unique: zmip40KzPy-jTsATyJUDfw-1
X-Mimecast-MFC-AGG-ID: zmip40KzPy-jTsATyJUDfw_1785168571
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B48B18009C6;
	Mon, 27 Jul 2026 16:09:30 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D34AB30010CC;
	Mon, 27 Jul 2026 16:09:27 +0000 (UTC)
Date: Mon, 27 Jul 2026 18:09:20 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shukai Ni <shukai.ni@kuleuven.be>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    gmazyland@gmail.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: Re: [PATCH 1/1] dm-integrity: replace forgeable discard filler with
 a keyed sector marker
In-Reply-To: <20260727134841.1109615-2-shukai.ni@kuleuven.be>
Message-ID: <4ab87b60-6d97-9507-8a8a-7a273021e8de@redhat.com>
References: <20260727134841.1109615-1-shukai.ni@kuleuven.be> <20260727134841.1109615-2-shukai.ni@kuleuven.be>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: vb7HSJVPghURGPpTwFDvMBgpr4BL6EJPE7QpYGWxUrs_1785168571
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 27 Jul 2026, Shukai Ni wrote:

> The discard-block check in dm_integrity_rw_tag() treats a stored tag
> of all 0xf6 bytes (DISCARD_FILLER) as proof a block was discarded and
> skips HMAC verification. allow_discards is only accepted in
> dm-integrity's standalone mode. An attacker with raw write access to
> the backing device, but without the integrity key, can stamp any block
> with an all-0xf6 tag and have it served as authentic.
> 
> Replace the constant filler with a keyed checksum of (salt || sector)
> and no block payload, computed by integrity_discard_checksum().
> 
> Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
> Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Shukai Ni <shukai.ni@kuleuven.be>

Hi

This breaks backward compatibility for existing volumes. I would add a new 
option "allow_discards_keyed" that enables this functionality (and store 
this option also as a flag in the superblock, so that it can't be turned 
off).

Mikulas

