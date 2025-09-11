Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F66311C2E
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608555; cv=none; b=keP9hcjXvp4/uaCCK89tiFjW95tZRWUG2neOufLmZd3R/6C10DZOG6MniQZPTbhQPBZDRnHor6E+/CesFLT9G8Fm4zyaTzhuR3W3oR+UZCl/5SUxwcze3xCCCrrFTDp1SWhUaM32DgcKvtUyCdezmHQLlg6xAy9Gnej29+ikEEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608555; c=relaxed/simple;
	bh=bJ8KA+O/+5qAo2YGpOWpyY/msJRGTePeRVIv1Eo33ak=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=F28pWveD6k166bf2rb/4uHq0VWmvKbpsGw5oHY4uusjg27dVxhPZyJey/WmXGe5EWTio5IPW+w3G+snGYhHQyVvUNq24ohyxfm3Meef2TRs7tkRV+MZTt8nsjFmgjHCUsJoFYkgX9+75rgqQV7mmhNZRZSF/GYYw7MQ84xt8CTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSa31zfP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSa31zfP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757608553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAaRGWepragC9rD4BJ19fVGzQAtVK7qlP4TZw4gIQKU=;
	b=JSa31zfP0CeTu1HGIcfZCYcYcFwWj067Wi7L0aJoeb5EjVUzCAV8zA5Rj0MyPhe1h9C4kK
	aczWThJARomkKhP6DINBb4XfzhvbDFymPk3uWDEIVuclgACndF0kWBHffUqhn0Hsh+eVUb
	UItpCox3OVbZ7iCBPkVqzGRfXLtMihw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-0hc6gZABPo2NkWLG9EPafQ-1; Thu,
 11 Sep 2025 12:35:50 -0400
X-MC-Unique: 0hc6gZABPo2NkWLG9EPafQ-1
X-Mimecast-MFC-AGG-ID: 0hc6gZABPo2NkWLG9EPafQ_1757608549
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D58911944DC4;
	Thu, 11 Sep 2025 16:35:48 +0000 (UTC)
Received: from [10.44.32.12] (unknown [10.44.32.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 249F530002C6;
	Thu, 11 Sep 2025 16:35:46 +0000 (UTC)
Date: Thu, 11 Sep 2025 18:35:44 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
In-Reply-To: <20250910172742.187645-1-bvanassche@acm.org>
Message-ID: <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UNSEpmJQNhSG2OqzVg8qnHdlalDAA03wgRkztPIapvE_1757608549
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 10 Sep 2025, Bart Van Assche wrote:

> The dm core splits REQ_PREFLUSH bios that have data into two bios.
> First, a REQ_PREFLUSH bio with no data is submitted to all underlying
> dm devices. Next, the REQ_PREFLUSH flag is cleared and the same bio is
> resubmitted. This approach is essential if there are multiple underlying
> devices to provide correct REQ_PREFLUSH semantics.
> 
> Splitting a bio into an empty flush bio and a non-flush data bio is
> not necessary if there is only a single underlying device. Hence this
> patch that does not split REQ_PREFLUSH bios if there is only one
> underlying device.
> 
> This patch preserves the order of REQ_PREFLUSH writes if there is only
> one underlying device and if one or more write bios have been queued
> past the REQ_PREFLUSH bio before the REQ_PREFLUSH bio is processed.
> 
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> 
> Changes compared to v1:
>  - Made the patch description more detailed.
>  - Removed the reference to write pipelining from the patch description.

Hi

I think that the problem here is that not all targets handle a PREFLUSH 
bio with data (for example, dm-integrity doesn't handle it correctly; it 
assumes that the PREFLUSH bio is empty).

I suggest that the logic should be changed to test that 
"t->flush_bypasses_map == true" (that will rule out targets that don't 
support flush optimization) and "dm_table_get_devices returns just one 
device" - if both of these conditions are true, you can send the PREFLUSH 
bio with data to the one device that dm_table_get_devices returned.

It will also optimize the case when you have multiple dm-linear targets 
with just one underlying device.

Mikulas

