Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304F25A32B
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740396843; cv=none; b=n2Yznl+eYH3SZFfbEBgYdRH+h9Fd5Dva0IfYt9c5Ifkq3qIMGUJPrMVybs89dPsLqg1bJvYb+ZMsx9KzB5BFKNil/PDPlHov1cDXeVgzUfUWklZ89AZ80BX5kdKXw5UEZHvXuKLm3B5+bpRreHxQ//rw1FOht0+wNzm77IDLQ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740396843; c=relaxed/simple;
	bh=bp4uaaBC4meBSJVsWeWntpVgr1Y/cRxGDDCc1a5wLUQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nuAqrDEY+9TNGY/1+ThWiVMw2qCUI94LKGCuhQwj/COI87fuCO1rQV5Ypa9qs4O18NCpP2AwkYSrsvbPML6mD6KYczRN591c0odXY2ypo4HlNw1vbyqX73shMLjU36MI182qPG8CDTu3/JR5SVDfpydeHGNS2yXPyI1/XjDcFVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JfaMH2HC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfaMH2HC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740396839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4JSj2VPq2tLwqSR9Ob1jBRYIH43Q/zJEDjGXdQYNoAM=;
	b=JfaMH2HCVvYcXRvMgAQsMETIXuvpY8SgKViNbJzg6XzwYO9ync68Io4ynJePX1A8BMLoTo
	Q7EDjBwqP7Yqme3t+ryogK2SPJandCv7b0g4lwZ7Keyfx1DIooQLbk/wVKeYhqpI8dm2wa
	IkUXs6LZBGslMjan/INjS7LVSjL6PII=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-ieTZKqmjNVmLzJEYdfQZbA-1; Mon,
 24 Feb 2025 06:33:58 -0500
X-MC-Unique: ieTZKqmjNVmLzJEYdfQZbA-1
X-Mimecast-MFC-AGG-ID: ieTZKqmjNVmLzJEYdfQZbA_1740396837
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6B451800264
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 11:33:57 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 720371800352;
	Mon, 24 Feb 2025 11:33:56 +0000 (UTC)
Date: Mon, 24 Feb 2025 12:33:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Sakai <msakai@redhat.com>
cc: dm-devel@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>
Subject: Re: [PATCH] dm vdo indexer: reorder uds_request to reduce padding
In-Reply-To: <20250220233310.1342059-1-msakai@redhat.com>
Message-ID: <90acf9f1-3133-e8b3-650f-f0c669cd2a43@redhat.com>
References: <20250220233310.1342059-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bw4JwbdfRuGP0jiPiTZ0VUv1bKl3iBAlHmVimMq3XzY_1740396837
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 20 Feb 2025, Matthew Sakai wrote:

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

Hi

This patch doesn't apply due to conflicts. Please resend this patch 
against 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
branch remotes/origin/for-next

I accepted the other 3 patches.

Mikulas

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
>  /* Compute the number of bytes needed to store an index. */
> -- 
> 2.45.2
> 
> 

