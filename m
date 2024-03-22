Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31B21E4A2
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711112339; cv=none; b=KQHojjRkIwhvFk2N4q5rtqJVNMLHVgVJVNyA1F18ZKh8qN7cQyfkoe4kiER1CVO0z+PBwT+NX1k9oZGp/KFL3UeklCyRbpQlmIf35DQVhGZxIJPeN5XIYhJJEgs4TTvpJvIXz+0upyc9xIJsIZmV7YMGYvkvhW3K7TGfFK5YxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711112339; c=relaxed/simple;
	bh=38LgJNkDgXfTIZZKm9uj5uxTJdhTxHsrdFk1Ysvy4k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=p0afdqo00ZbRo/13sQ6eOUOj1GH7Cm66OkQM5h3Nbs/gieTewoDsem5jYqJmOW2v0N2F9ratua2JMj+/eFDccWfJBGpGOET52lD6R63/rOBwCSoFXJxLKbVLCUfsNz6bFzcGZ8jKJ6wZRvpCMV2vra+kyQuK/aMurZllqyzl1hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aG5noZc5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aG5noZc5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711112336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gWakpAdAGLYkbcGxzqnTBJj/c/0cLk+wl9WKueJpqh8=;
	b=aG5noZc5dZhkZ9S3O4isx2sIo6PWiNKDTLS3xBYD3QwPeFAkim/E5gWG4alCWlSf9N5Sm5
	oESPVEAABkoLyVrij08BgsnSJLD+cH+MbxA3MGys9opGU0v8y1zExhitLBFB/HqMAmSCPF
	5dFb2139H1lkGiz149Tq9ql16ZDYx74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-oAXLXEwPNimnCzq-bxkpnA-1; Fri, 22 Mar 2024 08:58:55 -0400
X-MC-Unique: oAXLXEwPNimnCzq-bxkpnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 429C8185A784
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:58:55 +0000 (UTC)
Received: from fedora (unknown [10.72.116.114])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87087C017A1;
	Fri, 22 Mar 2024 12:58:52 +0000 (UTC)
Date: Fri, 22 Mar 2024 20:58:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-integrity: align the outgoing bio in integrity_recheck
Message-ID: <Zf2AhG0r8vcRMvLi@fedora>
References: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com>
 <ZfzhzMgdJJaOZwGA@fedora>
 <2ca5a02-de66-a4bb-b42f-45ea54f79de@redhat.com>
 <Zf1zfjuzb9be0Uwz@fedora>
 <f4149577-ac28-b4f2-1a89-37845c197677@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f4149577-ac28-b4f2-1a89-37845c197677@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 22, 2024 at 01:32:30PM +0100, Mikulas Patocka wrote:
> 
> 
> On Fri, 22 Mar 2024, Ming Lei wrote:
> 
> > If logical block becomes mismatched by reconfiguration, the whole DM stack can't work:
> > 
> > - at the beginning, DM is over NVMe(512 bs), DM & NVMe lbs is 512
> > - later, nvme is reconfigured and its lbs becomes 4k, but DM's lbs can't
> > be updated
> > - then unaligned IO is submitted to NVMe
> > 
> > So DM _never_ works with mis-matched logical block size because of
> > reconfigure, and same with MD.
> 
> It can work. If a filesystem has 4k block size and it is used on a block

Here 'work' means it supports any allowed block size, instead of 4KB only
or if balabala...

The DM device advertises its lbs as 512, application & FS should be
free to read/write 512 aligned data, right?


Thanks, 
Ming

