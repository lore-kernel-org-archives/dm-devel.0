Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A3F3A8D0
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711489951; cv=none; b=kKQVozCsJ39FIzSHb4TpS0gdb3PTjQybXHjuM+JWnV8Vvm0gJydwGmTdGQqxSbxyuG1D5xRdO1Jl3s2uePTwtiZ7oRfDO7WTUfYJX0RT0wYqEMaNHBsl3ncYRy/UZ+0Bw6A8FSYDeEILsitY/mTC0he6jhy6XnH+kCwDNdsFEY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711489951; c=relaxed/simple;
	bh=OUQs/SCd0iHXvHmKqjTqdTFjXotZKAhgTrhhdNnIcDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dQOUFSAzuGnrzWTPXKBWEi0i8/wCmbk7KEXPLJuSiSkKimCW4WaZmYzmy45fXDFZOlPDYgEI37h6EvJisiQJ9K9Fad/kFZ4guRghiTPntTKE+sbZhu7uIf7ATmf4yvb4pQ2BQImnLRZqfXHq0xGPG+gTDTdSLOIHJ0UgskCUIhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gh7cPFIi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gh7cPFIi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711489948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uuJtTEFU+CUDFP3TZMW62LQF/PcaCZRx7Tg7CgmczJ0=;
	b=gh7cPFIiahKiu554ZQ8UGAxadYNyyP84JbfzHOWcQHzYw9tyeHMVssPwIKHqERgbzjAuc+
	e5bZJTbE3j8pSryF1zeU624CEwtsjBHmgtJiysZ6m8FKfPj5w1laVpTpirSU7LgY50BUqW
	3QLqMJEnheu5LW0RvLC/LZTq6UbLgDo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-KpxMgaGpOYezMyHdUhgMbA-1; Tue, 26 Mar 2024 17:52:26 -0400
X-MC-Unique: KpxMgaGpOYezMyHdUhgMbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7EB811E81;
	Tue, 26 Mar 2024 21:52:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB663400D29C;
	Tue, 26 Mar 2024 21:52:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QLqP3E1407039
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 17:52:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QLqP821407038;
	Tue, 26 Mar 2024 17:52:25 -0400
Date: Tue, 26 Mar 2024 17:52:25 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 01/11] 11-dm-mpath.rules: don't set MPATH_DEVICE_READY=0
 for suspended devices
Message-ID: <ZgNDmVxgiQcnQ2o1@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:51PM +0100, Martin Wilck wrote:
> MPATH_DEVICE_READY is an internal property, not to be consumed by
> later rules. It means that there are no usable paths. Being suspended
> is a different, independent property of a map.
> 
> Don't set MPATH_DEVICE_READY=0 for suspended devices.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index d9585ab..3f23108 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -100,7 +100,7 @@ ENV{MPATH_DEVICE_READY}=="0", \
>  # we have to postpone the activation until the next event.
>  ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
>  ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
> -ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
> +ENV{DM_SUSPENDED}=="1", GOTO="dont_activate"

I need to clarify this one.  I thought that the point of setting
ENV{MPATH_DEVICE_READY} to "0" here was that
ENV{.MPATH_DEVICE_READY_OLD} must be "0" and ENV{MPATH_DEVICE_READY}
must be "1" here, so we want to set DM_ACTIVATE. Unfortunately, the
device is suspended, so we want to postpone the activation till the next
event, like the command above this codeblock says.  To do that, we set
ENV{MPATH_DEVICE_READY} back to "0", so that on the next event,
ENV{.MPATH_DEVICE_READY_OLD} will be "0".

Is that not necessary for some reason? Perhaps because we're going to
get an actual DM generated event when we resume, so DM_ACTIVATE will
already be set when we get the next event where DM_SUSPENDED != "1".
If that's the case we should probably change the comment over this code
block. 

-Ben

>  
>  ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
>  LABEL="dont_activate"
> -- 
> 2.43.2

