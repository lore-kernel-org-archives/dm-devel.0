Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0182019644B
	for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727098029; cv=none; b=CEEjs/XZuSfTvmpPgcU4FSxoa/lxY5kVAl57wXWKFAUHYxTldfj7/82NRY0ygnrYjlhUGO/gfhw14BVOx+0OBtaVxq8FR0rj2aAuZ1W5dMD8/Y85kVz7IstjtLVvizPVUxxprfzMwh1glZHnFxVH6/NUeweYl1zba0a24rHHcmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727098029; c=relaxed/simple;
	bh=dI2jexkoav3yhz6acugRW9+a907CmM5inGbCMhqpRXo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IctJ74irWAakE3rUfNSbkQ5hoZuy4ZkEzTDuiRlSptEMpozVY3QLqkUjl6PjRlyl2TxZ3gDqqbJJEWyZC5CJq7/lOzpXxmnbovz6lSVA6NnS8+Y61gn09S1q2PsBzraYq/ktSxA5z8dwzDMAADFSeghuKlimgnH+13NB93hLQdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FXuZGyHF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXuZGyHF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727098025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uxrw8H9RJR3IFfbc3l75F3IOlJFRvDC/cWL5VOkjHL0=;
	b=FXuZGyHFXWZGQZ0HbsglXTDVO+Mq5OFRruEBp41NEOP9UOV/sbjgADJHQSiiG3IWcBslAt
	wXLeF5jo0+NvCYQWNBLx+YeXkqg4m7qnggZNPXdLJe/2yddNX9MLzTKD1stQXXCZlGn5k1
	dA700CgdvO63fLTZYfVR5+kcV532hdk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-BHMPsk0nOumgYKwG6ROz5A-1; Mon,
 23 Sep 2024 09:27:02 -0400
X-MC-Unique: BHMPsk0nOumgYKwG6ROz5A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58DC718FFA5C;
	Mon, 23 Sep 2024 13:27:00 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC39619560AA;
	Mon, 23 Sep 2024 13:26:58 +0000 (UTC)
Date: Mon, 23 Sep 2024 15:26:56 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dipendra Khadka <kdipendra88@gmail.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return error code for failure input for sscanf in
 parse_cblock_range()
In-Reply-To: <20240922164702.49615-1-kdipendra88@gmail.com>
Message-ID: <5c258e04-10b4-749d-6f15-94a432ab652e@redhat.com>
References: <20240922164702.49615-1-kdipendra88@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi

I skimmed through the sscanf source code and it seems that it can't return 
a negative value at all.

I think, this should be:
	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
	if (r != 2)
		return -EINVAL;

Mikulas

On Sun, 22 Sep 2024, Dipendra Khadka wrote:

> Smatch reported following:
> '''
> drivers/md/dm-cache-target.c:3204 parse_cblock_range() warn: sscanf doesn't return error codes
> drivers/md/dm-cache-target.c:3217 parse_cblock_range() warn: sscanf doesn't return error codes
> '''
> 
> Since, the only negative value that is returned by sscanf is -1.
> Returning -ENVAL when sscanf returns -1.
> 
> Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
> ---
>  drivers/md/dm-cache-target.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 17f0fab1e254..c35d65e310d6 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -3200,8 +3200,8 @@ static int parse_cblock_range(struct cache *cache, const char *str,
>  	 * Try and parse form (ii) first.
>  	 */
>  	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> -	if (r < 0)
> -		return r;
> +	if (r == -1)
> +		return -EINVAL;
>  
>  	if (r == 2) {
>  		result->begin = to_cblock(b);
> @@ -3213,8 +3213,8 @@ static int parse_cblock_range(struct cache *cache, const char *str,
>  	 * That didn't work, try form (i).
>  	 */
>  	r = sscanf(str, "%llu%c", &b, &dummy);
> -	if (r < 0)
> -		return r;
> +	if (r == -1)
> +		return -EINVAL;
>  
>  	if (r == 1) {
>  		result->begin = to_cblock(b);
> -- 
> 2.43.0
> 

