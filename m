Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E5155723
	for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715788410; cv=none; b=uEmrE0kpwpNqHxkSBC0HC4zyiOsYvL1VykL9IptjuBfrCeOGzFHlOtbHVt0RTQG/fObH4+ANgIWdJrtwoPm3aZG/XwNdF4d44mFyS/XPxeonmZRcUXSHDtw2i55OZxN1vzrXtNLmWmrNj3iRA002iGVv1xjrQ2Y4FErVMeByaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715788410; c=relaxed/simple;
	bh=PLICOs1NTYI+yPAKQECK43RBujzuz7MJ5XPyRmFGsL8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ToeZ1VGsdXP62h4pDoP8C3MpLo5T5gT5jOFLVPP1wkK4fk1JyDWRYT4XoAllRMhihv3+4debgDlmPWm21jg8jS2Wqy5E1uNcxYPt0sLkSpGX1JwO+wneE6bmVKzuE8EKpBr0lhlFi0xgyGIGwI0fnGDhdZ54iKEWnsBK8uJ55uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYHDqIMk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYHDqIMk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715788408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=28b8BtOd3FrksYzqOgmA847TC7BJTLOfSgpR3BHW3uA=;
	b=FYHDqIMkR2T6Xay6s8VUuMjrnN8kMe7HZOMA0vTucM7pbp8OFF4vftIWrmd0qJRkZEIG1c
	7KHN3Hq979sSBDgNkiJbasihrOG8ypltYHjzA2UQXOlZmi1ddkNS7aq24c+iZlYFP+XmfL
	iZ2u9Tb2OtgL/Cs7R4WDY1e4wv93wkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-hEgnx29nPa2-5mEBYZ7jcQ-1; Wed, 15 May 2024 11:53:24 -0400
X-MC-Unique: hEgnx29nPa2-5mEBYZ7jcQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 106BD8058CA;
	Wed, 15 May 2024 15:53:24 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6B6D51BF;
	Wed, 15 May 2024 15:53:23 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D153C30C1C33; Wed, 15 May 2024 15:53:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id CE1FA3FB52;
	Wed, 15 May 2024 17:53:23 +0200 (CEST)
Date: Wed, 15 May 2024 17:53:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Yang Yang <yang.yang@vivo.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] dm: support retrieving struct dm_target from struct
 dm_dev
In-Reply-To: <ZkTXzG1yrPmW64Z6@redhat.com>
Message-ID: <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com>
References: <20240514090445.2847-1-yang.yang@vivo.com> <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5



On Wed, 15 May 2024, Benjamin Marzinski wrote:

> On Tue, May 14, 2024 at 05:04:42PM +0800, Yang Yang wrote:
> > Add a list to the struct dm_dev structure to store the associated
> > targets, while also allowing differentiation between different target
> > types.
> 
> I still think this is more complex than it needs to be. If devices that
> support flush_pass_around can guarantee that:
> 
> 1. They will send a flush bio to all of their table devices
> 2. They are fine with another target sending the flush bio to their
>    table devices
> 
> Then I don't see why we need the table devices to keep track of all the
> different target types that are using them. Am I missing something here?
> 
> If we don't need to worry about sending a flush bio to a target of each
> type that is using a table device, then all we need to do is call
> __send_empty_flush_bios() for enough targets to cover all the table
> devices. This seems a lot easier to track. We just need another flag in
> dm_target, something like sends_pass_around_flush.
> 
> When a target calls dm_get_device(), if it adds a new table device to
> t->devices, then it's the first target in this table to use that device.
> If flush_pass_around is set for this target, then it also sets
> sends_pass_around_flush. In __send_empty_flush() if the table has
> flush_pass_around set, when you iterate through the devices, you only
> call __send_empty_flush_bios() for the ones with sends_pass_around_flush
> set.
> 
> Or am I overlooking something?
> 
> -Ben

Yes, I agree that it is complex.

I reworked the patch, I'm testing it now and I'll send it when it passes 
the tests.

Mikulas

