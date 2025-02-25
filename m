Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE94A433CE
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740489583; cv=none; b=oWcQy6oKomVYfdjOv8Emhs2nf3MiXZpkP+Hac5lClqNiuG3AYXPQdxz8pa3oJCo1C6whZOlJ1oIfz3nWimduK6glPM4VNhxvBIk8ntrQ9U+RENXkauyyNlLn0xFDLNvISkfxvO+kCzr1Yc3mGChKZyazwS1pm66FfNdB2NTq2ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740489583; c=relaxed/simple;
	bh=0ggrhJSxPybcZa4f6wv/7IqH6z1Hvq938RslWCnM8BE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=o1j0jotDDhM3sxMT3GkU9coi1BPfpHCXpJX/SSrEFVzamY7nNJuxtVPaY+RZ1yGCOw6oHq9+Wb+aUAkoYSi1x7DPrWHsC2BupE1EKlViPyGjrgdGUbdyIeiT33V5ODvwEAivaaadRY9OzNgajhJzeNPAB4+paKiH2qZz//iQ2rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XUfakMdc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUfakMdc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740489580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3jmBNvKNRWpsHJ387b19G/5slHOu1mZmCFu8jLnghQ=;
	b=XUfakMdcI56VY9YlFfyAFjwHnQdA94OniAlZDRzu8nfQx8CXpk9RjCy2BseLm+HKCrkOk0
	fFkyjf5Vonevu2jVmQLhH1r0XtnCkr89/O06YAPu7rVuq0Qdo+uA15Gx/LWGMbmTxdnVTe
	VuBWXnVtffTHjYaClVOsKcRLGmmyX1E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-jQLgAjinOU64s_VTZxIUaA-1; Tue,
 25 Feb 2025 08:19:39 -0500
X-MC-Unique: jQLgAjinOU64s_VTZxIUaA-1
X-Mimecast-MFC-AGG-ID: jQLgAjinOU64s_VTZxIUaA_1740489578
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B94E1903080
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 13:19:38 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2951E1800359;
	Tue, 25 Feb 2025 13:19:36 +0000 (UTC)
Date: Tue, 25 Feb 2025 14:19:33 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Sakai <msakai@redhat.com>
cc: dm-devel@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>
Subject: Re: [PATCH v2] dm vdo indexer: reorder uds_request to reduce
 padding
In-Reply-To: <20250224213603.1353256-1-msakai@redhat.com>
Message-ID: <dd6ddfea-9745-a374-5d49-b2541af333f3@redhat.com>
References: <20250224213603.1353256-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xt0SuWr2zHnjKg3JY--mCTc6arbmS8NK9GYX1JUhqVA_1740489578
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Applied, thanks.

Mikulas


On Mon, 24 Feb 2025, Matthew Sakai wrote:

> From: Ken Raeburn <raeburn@redhat.com>
> 
> Reorder fields and make uds_request_type and uds_zone_message packed,
> to squeeze out some space. Use struct_group so the request reset code
> no longer needs to care about field order.
> 
> On x86_64 this reduces the struct size from 144 to 120, which saves 48
> kB (about 12%) per VDO hash zone.
> 
> Signed-off-by: Ken Raeburn <raeburn@redhat.com>
> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> ---
>  drivers/md/dm-vdo/indexer/index-session.c |  6 +--
>  drivers/md/dm-vdo/indexer/indexer.h       | 53 +++++++++++------------
>  2 files changed, 27 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
> index aee0914d604a..aa575a24e0b2 100644
> --- a/drivers/md/dm-vdo/indexer/index-session.c
> +++ b/drivers/md/dm-vdo/indexer/index-session.c
> @@ -100,7 +100,6 @@ static int get_index_session(struct uds_index_session *index_session)
>  
>  int uds_launch_request(struct uds_request *request)
>  {
> -	size_t internal_size;
>  	int result;
>  
>  	if (request->callback == NULL) {
> @@ -121,10 +120,7 @@ int uds_launch_request(struct uds_request *request)
>  	}
>  
>  	/* Reset all internal fields before processing. */
> -	internal_size =
> -		sizeof(struct uds_request) - offsetof(struct uds_request, zone_number);
> -	// FIXME should be using struct_group for this instead
> -	memset((char *) request + sizeof(*request) - internal_size, 0, internal_size);
> +	memset(&request->internal, 0, sizeof(request->internal));
>  
>  	result = get_index_session(request->session);
>  	if (result != UDS_SUCCESS)
> diff --git a/drivers/md/dm-vdo/indexer/indexer.h b/drivers/md/dm-vdo/indexer/indexer.h
> index 3744aaf625b0..d765f24328eb 100644
> --- a/drivers/md/dm-vdo/indexer/indexer.h
> +++ b/drivers/md/dm-vdo/indexer/indexer.h
> @@ -8,6 +8,7 @@
>  
>  #include <linux/mutex.h>
>  #include <linux/sched.h>
> +#include <linux/stddef.h>
>  #include <linux/types.h>
>  #include <linux/wait.h>
>  
> @@ -73,7 +74,7 @@ enum uds_request_type {
>  	/* Remove any mapping for a name. */
>  	UDS_DELETE,
>  
> -};
> +} __packed;
>  
>  enum uds_open_index_type {
>  	/* Create a new index. */
> @@ -226,7 +227,7 @@ struct uds_zone_message {
>  	enum uds_zone_message_type type;
>  	/* The virtual chapter number to which the message applies */
>  	u64 virtual_chapter;
> -};
> +} __packed;
>  
>  struct uds_index_session;
>  struct uds_index;
> @@ -253,34 +254,32 @@ struct uds_request {
>  
>  	/* The existing data associated with the request name, if any */
>  	struct uds_record_data old_metadata;
> -	/* Either UDS_SUCCESS or an error code for the request */
> -	int status;
>  	/* True if the record name had an existing entry in the index */
>  	bool found;
> +	/* Either UDS_SUCCESS or an error code for the request */
> +	int status;
>  
> -	/*
> -	 * The remaining fields are used internally and should not be altered by clients. The index
> -	 * relies on zone_number being the first field in this section.
> -	 */
> -
> -	/* The number of the zone which will process this request*/
> -	unsigned int zone_number;
> -	/* A link for adding a request to a lock-free queue */
> -	struct funnel_queue_entry queue_link;
> -	/* A link for adding a request to a standard linked list */
> -	struct uds_request *next_request;
> -	/* A pointer to the index processing this request */
> -	struct uds_index *index;
> -	/* Control message for coordinating between zones */
> -	struct uds_zone_message zone_message;
> -	/* If true, process request immediately by waking the worker thread */
> -	bool unbatched;
> -	/* If true, continue this request before processing newer requests */
> -	bool requeued;
> -	/* The virtual chapter containing the record name, if known */
> -	u64 virtual_chapter;
> -	/* The region of the index containing the record name */
> -	enum uds_index_region location;
> +	/* The remaining fields are used internally and should not be altered by clients. */
> +	struct_group(internal,
> +		     /* The virtual chapter containing the record name, if known */
> +		     u64 virtual_chapter;
> +		     /* The region of the index containing the record name */
> +		     enum uds_index_region location;
> +		     /* If true, process request immediately by waking the worker thread */
> +		     bool unbatched;
> +		     /* If true, continue this request before processing newer requests */
> +		     bool requeued;
> +		     /* Control message for coordinating between zones */
> +		     struct uds_zone_message zone_message;
> +		     /* The number of the zone which will process this request*/
> +		     unsigned int zone_number;
> +		     /* A link for adding a request to a lock-free queue */
> +		     struct funnel_queue_entry queue_link;
> +		     /* A link for adding a request to a standard linked list */
> +		     struct uds_request *next_request;
> +		     /* A pointer to the index processing this request */
> +		     struct uds_index *index;
> +		     );
>  };
>  
>  /* A session is required for most index operations. */
> -- 
> 2.45.2
> 
> 

