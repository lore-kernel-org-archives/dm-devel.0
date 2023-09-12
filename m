Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB1AEE3F3F
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 22:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694559573;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MKhBz9b8QKMEcWj8Zmqs/7hmxSgciu56QaT6reHG3Gw=;
	b=co+UsLw20ac6RySXRZ4ptPmD9Z+/XODtX0am1dxOQK8JEgus9VG525TUn6zoDJNkcJye0A
	RHLmJ0EJDg1XAGpqSGbeWZ8Mgv6j5UFW9xIOSvAU1H7QA4wCHJujDlPn0O3uHhTnbYLg8O
	Uw8auiWjssERG6T4Prr57z8ZNrdymt8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-X6onXco_NDqlj4j17KC5lw-1; Tue, 12 Sep 2023 18:59:30 -0400
X-MC-Unique: X6onXco_NDqlj4j17KC5lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B36B0101FAA1;
	Tue, 12 Sep 2023 22:59:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B98140C2009;
	Tue, 12 Sep 2023 22:59:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E34F519465A8;
	Tue, 12 Sep 2023 22:59:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13ED8194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 22:59:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4EF040C6EBF; Tue, 12 Sep 2023 22:59:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBF6640C6EA8;
 Tue, 12 Sep 2023 22:59:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CMxCXY031036;
 Tue, 12 Sep 2023 17:59:12 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CMxCRH031035;
 Tue, 12 Sep 2023 17:59:12 -0500
Date: Tue, 12 Sep 2023 17:59:11 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912225911.GM7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-25-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-25-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 24/37] libmultipath: simplify
 get_free_id() assuming total ordering
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:33PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If we can assume that the bindings array is totally ordered for every
> prefix, which the previous patch guarantees, the search for a free ID can be
> simplified.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 87 ++++++++++----------------------------------
>  1 file changed, 19 insertions(+), 68 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index af6565b..66e34e3 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -356,83 +356,34 @@ int get_free_id(const Bindings *bindings, const char *prefix, const char *map_ww
>  {
>  	const struct binding *bdg;
>  	int i, id = 1;
> -	int biggest_id = 1;
> -	int smallest_bigger_id = INT_MAX;
>  
>  	vector_foreach_slot(bindings, bdg, i) {
>  		int curr_id = scan_devname(bdg->alias, prefix);
>  
> -		/*
> -		 * Find an unused index - explanation of the algorithm
> -		 *
> -		 * ID: 1 = mpatha, 2 = mpathb, ...
> -		 *
> -		 * We assume the bindings are unsorted. The only constraint
> -		 * is that no ID occurs more than once. IDs that occur in the
> -		 * bindings are called "used".
> -		 *
> -		 * We call the list 1,2,3,..., exactly in this order, the list
> -		 * of "expected" IDs. The variable "id" always holds the next
> -		 * "expected" ID, IOW the last "expected" ID encountered plus 1.
> -		 * Thus all IDs below "id" are known to be used. However, at the
> -		 * end of the loop, the value of "id" isn't necessarily unused.
> -		 *
> -		 * "smallest_bigger_id" is the smallest used ID that was
> -		 * encountered while it was larger than the next "expected" ID
> -		 * at that iteration. Let X be some used ID. If all IDs below X
> -		 * are used and encountered in the right sequence before X, "id"
> -		 * will be > X when the loop ends. Otherwise, X was encountered
> -		 * "out of order", the condition (X > id) holds when X is
> -		 * encountered, and "smallest_bigger_id" will be set to X; i.e.
> -		 * it will be less or equal than X when the loop ends.
> -		 *
> -		 * At the end of the loop, (id < smallest_bigger_id) means that
> -		 * the value of "id" had been encountered neither in order nor
> -		 * out of order, and is thus unused. (id >= smallest_bigger_id)
> -		 * means that "id"'s value is in use. In this case, we play safe
> -		 * and use "biggest_id + 1" as the next value to try.
> -		 *
> -		 * biggest_id is always > smallest_bigger_id, except in the
> -		 * "perfectly ordered" case.
> -		 */
> -		if (curr_id == id) {
> -			if (id < INT_MAX)
> -				id++;
> -			else {
> -				id = -1;
> -				break;
> -			}
> +		if (curr_id == -1)
> +			continue;
> +		if (id > curr_id) {
> +			condlog(0, "%s: ERROR: bindings are not sorted", __func__);
> +			return -1;
>  		}
> -		if (curr_id > biggest_id)
> -			biggest_id = curr_id;
> -
> -		if (curr_id > id && curr_id < smallest_bigger_id)
> -			smallest_bigger_id = curr_id;
> -	}
> -
> -	if (id >= smallest_bigger_id)
> -		id = biggest_id < INT_MAX ? biggest_id + 1 : -1;
> -
> -	if (id > 0) {
> -		while(id_already_taken(id, prefix, map_wwid)) {
> -			if (id == INT_MAX) {
> -				id = -1;
> -				break;
> -			}
> +		while (id < curr_id && id_already_taken(id, prefix, map_wwid))
>  			id++;
> -			if (id == smallest_bigger_id) {
> -				if (biggest_id == INT_MAX) {
> -					id = -1;
> -					break;
> -				}
> -				if (biggest_id >= smallest_bigger_id)
> -					id = biggest_id + 1;
> -			}
> -		}
> +		if (id < curr_id)
> +			return id;
> +		id++;
> +		if (id <= 0)
> +			break;
>  	}
>  
> -	if (id < 0)
> +	for (; id > 0; id++) {
> +		if (!id_already_taken(id, prefix, map_wwid))
> +			break;
> +	}
> +
> +	if (id <= 0) {
> +		id = -1;
>  		condlog(0, "no more available user_friendly_names");
> +	}
>  	return id;
>  }
>  
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

