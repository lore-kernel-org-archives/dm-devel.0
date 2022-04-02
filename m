Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20F9C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 03:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648871049;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v3xnPkhDd5qVdibsNDGqqdH0sT2QHNqz0HIhQ+RczeU=;
	b=VYVysZqszyLJn8dUSuokLZWJa6Aa4pPQjpgKqB0dFx9uVezz9R7EKqL+aZ56wrARF4VrMG
	uZ3B/bXFQWQRnwKr8nZNtbeUdWZjzixWUKeRRMGut/4ol+Htr6QOjC2TS1rwew3YyYAvNy
	rMlPeDg+HkKGVnqwRWO7O6VYsrY6uRU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-6rKcHLwTO8CoVw6FpTS1eA-1; Fri, 01 Apr 2022 23:44:07 -0400
X-MC-Unique: 6rKcHLwTO8CoVw6FpTS1eA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34DEC2800F6F;
	Sat,  2 Apr 2022 03:44:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23EE9C4C7C5;
	Sat,  2 Apr 2022 03:44:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5FCE1949761;
	Sat,  2 Apr 2022 03:44:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 44F521947BBE
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 03:44:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53D184010144; Sat,  2 Apr 2022 03:44:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4427840CF8F2;
 Sat,  2 Apr 2022 03:44:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2323i1h7015933;
 Fri, 1 Apr 2022 22:44:01 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2323i0BD015932;
 Fri, 1 Apr 2022 22:44:00 -0500
Date: Fri, 1 Apr 2022 22:44:00 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220402034400.GV24684@octiron.msp.redhat.com>
References: <20220330221510.22578-1-mwilck@suse.com>
 <20220330221510.22578-13-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220330221510.22578-13-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 12/14] libmultipath: uevent_filter(): filter
 previously merged events
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
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 On Thu, Mar 31, 2022 at 12:15:08AM +0200, mwilck@suse.com wrote:
> With the new list-appending logic, it can happen that previously
> merged events can now be filtered. Do it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/uevent.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index eb900ec..809c74c 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -305,7 +305,7 @@ static void uevent_delete_from_list(struct uevent *to_delete,
>  	 * for the anchor), "old_tail" must be moved. It can happen that
>  	 * "old_tail" ends up pointing at the anchor.
>  	 */
> -	if (*old_tail == &to_delete->node)
> +	if (old_tail && *old_tail == &to_delete->node)
>  		*old_tail = to_delete->node.prev;
>  
>  	list_del_init(&to_delete->node);
> @@ -360,6 +360,20 @@ uevent_filter(struct uevent *later, struct uevent_filter_state *st)
>  		 * filter unnessary earlier uevents
>  		 * by the later uevent
>  		 */
> +		if (!list_empty(&earlier->merge_node)) {
> +			struct uevent *mn, *t;
> +
> +			list_for_each_entry_reverse_safe(mn, t, &earlier->merge_node, node) {
> +				if (uevent_can_filter(mn, later)) {
> +					condlog(4, "uevent: \"%s %s\" (merged into \"%s %s\") filtered by \"%s %s\"",
> +						mn->action, mn->kernel,
> +						earlier->action, earlier->kernel,
> +						later->action, later->kernel);
> +					uevent_delete_from_list(mn, &t, NULL);

Just like with 05/14, you could just use a much simpler delete function
here, since moving old_tail and merged nodes is unnecessary. I guess I
don't care that much, if you'd rather just have one function, so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> +					st->filtered++;
> +				}
> +			}
> +		}
>  		if (uevent_can_filter(earlier, later)) {
>  			condlog(3, "uevent: %s-%s has filtered by uevent: %s-%s",
>  				earlier->kernel, earlier->action,
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

