Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD74115B99C
	for <dm-devel@lists.linux.dev>; Mon,  6 May 2024 21:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715029867; cv=none; b=Yaewq4awBmREV94h2V3aI1AzDUjV/LIx7Z0iHkbyNGiqLcE8Saj/GJ4R8kMFylDh6Z9Rg0XBWsZRHSDAfgRuZZ4pZ52DzvlzEaBjulBr8TIEBY715F24q2jxSi9fo40zqZ7tJp7Ka483+FtVV0vv6w8PDuIvwuvCKsgjSfrMdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715029867; c=relaxed/simple;
	bh=WGO5QO3dRKlfICitdweFGYAhS6YfziQiBFs8T7YQuUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9EdE2tTcT8Cp6hQOQLIDXfozYxQFjcg8Vxwhh2wmHffdF+qONEhMblPYWA8aC6AsIzkWkQW+tSeoG/Meu+fYuSGlocxwUelwBeQvaSLj5J60AD6C418+OFB9zQluVN/AgLTK5g4dht/weD3MY9Ps84l2W88+4hp3qCawINpAAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E814cy9a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E814cy9a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715029864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpuM7DdZ1dIVsrgmEZWd5kU26lRSp4glNuqdk/kl22U=;
	b=E814cy9aGK3kEq9qTRmlzte2bu1fa6/iQcUy4FAoCd3cHfa2GP7NPfOMqI3sUDCGF18zjz
	ejZqgGPnmZhbhpYD4WilgxkzKhBU1658DnL/9VFZ0N7AgoUGFVpOlo2ojpIy2qC5saH4Po
	rjwe+17QHzH3iMy6s0xsiaUy+n7iByY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-RUNP_kfqNUyH-DGcUyNMHw-1; Mon,
 06 May 2024 17:11:00 -0400
X-MC-Unique: RUNP_kfqNUyH-DGcUyNMHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C66A71C05153;
	Mon,  6 May 2024 21:10:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEF3CC13FA3;
	Mon,  6 May 2024 21:10:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 446LAxvH004709
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 May 2024 17:10:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 446LAxVh004708;
	Mon, 6 May 2024 17:10:59 -0400
Date: Mon, 6 May 2024 17:10:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Joel Colledge <joel.colledge@linbit.com>
Cc: Christian Loehle <christian.loehle@arm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] dm-delay: fix hung task introduced by kthread mode
Message-ID: <ZjlHY02it0wBL0TB@redhat.com>
References: <20240506072523.399767-1-joel.colledge@linbit.com>
 <20240506072523.399767-2-joel.colledge@linbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506072523.399767-2-joel.colledge@linbit.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Mon, May 06, 2024 at 09:25:23AM +0200, Joel Colledge wrote:
> If the worker thread is not woken due to a bio, then it is not woken at
> all. This causes the hung task check to trigger. This occurs, for
> instance, when no bios are submitted. Also when a delay of 0 is
> configured, delay_bio() returns without waking the worker.
> 
> Prevent the hung task check from triggering by creating the thread with
> kthread_run() instead of using kthread_create() directly.
> 
> Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
> Signed-off-by: Joel Colledge <joel.colledge@linbit.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

