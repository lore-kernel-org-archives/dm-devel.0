Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EA61E25EB
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755537583; cv=none; b=pebnm6fOfK/e+XT0blJpq1mrK7C4qQDvfHHCsWcDzLhOWcIocWbNESy6WSm6O6VLdMGr0ifkg/Gttl0p43/iknHWlxWXqLyDf9hMZ3DA++Ca7461TMhkyzXuB6DTmBdace7pBmJLFYKqshWzqCeGMAISuLpg0uYgcCXZjgm3CRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755537583; c=relaxed/simple;
	bh=BmbAOz7cmoc2ddxNFdfrV1OQGuUVaXKxjL3Td1cKna8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mMfN8SsrYACn6ofV2SJK/4x3A3YoahqG3fOpb2BnYN00din2kg+M7x9S1wB3NR9ZJfUwEphWpjtY2pwe1ZNT8QfDGXLicEccj+NtkKZUinG6A68qpBOBGu8JwzWJXtTz2RY9dGptPWfkQE1DISB8zog24b9iHN39+D3UBOdMNWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y25H/Amo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y25H/Amo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755537580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s4cLqgPs3PdWxusCTUTcUN1vxjIknzWxhjUelatBew0=;
	b=Y25H/Amofly+ETWhR2XyC2poMtGALP7GV6yjlzm19EK0sv2ugIvDer32eqhVHLngktOjCt
	sVTGbYVeysKJI9q4s04mq+9OOX5RPk0yUT0ghzMby0HPYdzID0JGmsmWEjqqPk8KAbhiRO
	RY9XbN38VeztzJDeize/LDgCeZEEM00=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-XcKgwc_7OkuX_BGq_bSy8g-1; Mon,
 18 Aug 2025 13:19:37 -0400
X-MC-Unique: XcKgwc_7OkuX_BGq_bSy8g-1
X-Mimecast-MFC-AGG-ID: XcKgwc_7OkuX_BGq_bSy8g_1755537576
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 853681954B19;
	Mon, 18 Aug 2025 17:19:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 027F419560AB;
	Mon, 18 Aug 2025 17:19:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57IHJYLk1191986
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 13:19:34 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57IHJYwo1191985;
	Mon, 18 Aug 2025 13:19:34 -0400
Date: Mon, 18 Aug 2025 13:19:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Alex Kalenyuk <akalenyu@redhat.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com
Subject: Re: [PATCH] Take undef enum into account for correct array index
 comparison
Message-ID: <aKNgpm9XllLUyEiJ@redhat.com>
References: <20250817194923.307911-1-akalenyu@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250817194923.307911-1-akalenyu@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n9RYJR9QU6tyr7mVtc0sw_vqZRsjh5j4Wl_ACmILHCI_1755537576
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2025 at 10:49:23PM +0300, Alex Kalenyuk wrote:
> Previously this would compare to the wrong index
> since the enum has an additional UNDEF entry

Are you actually seeing multipath getting misconfigured here, because
the code doesn't look wrong to me.  We didn't and the "undef" elements
because we don't want to accept "undef" as a valid value from the config
file.

This code is admittedly a little confusing.  We aren't looping from 0 to
the last value, we are looping from FIND_MULTIPATHS_OFF or FLUSH_NEVER
(which have the value of 1). The way the loop works, we won't even check
the config text against the array elements you added. We intentionally
only set elements in those arrays at the values we want to start
checking at: FIND_MULTIPATHS_OFF and FLUSH_NEVER. As long as the text in
the optvals array is correct for the value we are using as its index, if
we match the config text with the optvals text, 'i' must be equal to the
value we want (since the value we want is array index of the matching
text).

If you are seeing a configuration issue, we do want to hear about it.
I'm not saying there isn't a bug, but unless I'm missing something, I
don't think that this is it. Also multipath's configuration priority
isn't always super intuitive, so sometimes it is working as designed,
but not you might intuitively expect.

-Ben

> 
> Signed-off-by: Alex Kalenyuk <akalenyu@redhat.com>
> ---
>  libmultipath/dict.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index a06a6138..2e820b2e 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -550,6 +550,7 @@ static int snprint_def_partition_delim(struct config *conf, struct strbuf *buff,
>  }
>  
>  static const char * const find_multipaths_optvals[] = {
> +	[FIND_MULTIPATHS_UNDEF] = "undef",
>  	[FIND_MULTIPATHS_OFF] = "off",
>  	[FIND_MULTIPATHS_ON] = "on",
>  	[FIND_MULTIPATHS_STRICT] = "strict",
> @@ -793,6 +794,7 @@ declare_def_snprint(allow_usb_devices, print_yes_no)
>  
>  
>  static const char * const flush_on_last_del_optvals[] = {
> +	[FLUSH_UNDEF] = "undef",
>  	[FLUSH_NEVER] = "never",
>  	[FLUSH_ALWAYS] = "always",
>  	[FLUSH_UNUSED] = "unused",
> -- 
> 2.50.1

