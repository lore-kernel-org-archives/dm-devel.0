Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43415C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 04:24:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8EB961178
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 04:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A8EB961178
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631766259;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Kc6L68ij1U1jLouffiRl3GsN0BEgc7/J4B8mSdY5juI=;
	b=B0ACJwSYtaX+pI/Qu7aoetSWKd2TCP+8OgYWPGJMHt12R7uG5cDDsYLIfds+hnxj8fBwAL
	PRLi3QsrFrdT02yzOYGTHMSfxKRfgH2rJ+F7Ykp3fMpA5umpjii0f2bt8xDFpmjR1XukTR
	XoxVk1UMfU27a2g9u0wP+yYz7nbhd30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-lAlNmGp5Oq-6ddhq4yCVIg-1; Thu, 16 Sep 2021 00:24:18 -0400
X-MC-Unique: lAlNmGp5Oq-6ddhq4yCVIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FB0A824FA6;
	Thu, 16 Sep 2021 04:24:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18F63100EBBF;
	Thu, 16 Sep 2021 04:24:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFFFF180142F;
	Thu, 16 Sep 2021 04:24:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G4OCCT004928 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 00:24:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0C943100EBBF; Thu, 16 Sep 2021 04:24:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27ED01000358;
	Thu, 16 Sep 2021 04:24:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G4O7wX007926; 
	Wed, 15 Sep 2021 23:24:07 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G4O7ZK007925;
	Wed, 15 Sep 2021 23:24:07 -0500
Date: Wed, 15 Sep 2021 23:24:06 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916042406.GT3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-35-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-35-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 34/35] multipathd: uxlsnr: drop client_lock
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:19PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The list of clients is never changed anywhere except in
> uxsock_listen(). No need to lock.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index c18b2c4..7b763b6 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -89,7 +89,6 @@ enum {
>  static __attribute__((unused)) char ___a[-(MIN_POLLS <= 0)];
>  
>  static LIST_HEAD(clients);
> -static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
>  static struct pollfd *polls;
>  static int notify_fd = -1;
>  static int idle_fd = -1;
> @@ -150,15 +149,13 @@ static void new_client(int ux_sock)
>  	c->is_root = _socket_client_is_root(c->fd);
>  
>  	/* put it in our linked list */
> -	pthread_mutex_lock(&client_lock);
>  	list_add_tail(&c->node, &clients);
> -	pthread_mutex_unlock(&client_lock);
>  }
>  
>  /*
>   * kill off a dead client
>   */
> -static void _dead_client(struct client *c)
> +static void dead_client(struct client *c)

There are also leading underscores and comments about the clients lock
for __get_soonest_timeout() and __need_lock(). We should probably remove
those as well.

-Ben

>  {
>  	int fd = c->fd;
>  	list_del_init(&c->node);
> @@ -170,14 +167,6 @@ static void _dead_client(struct client *c)
>  	close(fd);
>  }
>  
> -static void dead_client(struct client *c)
> -{
> -	pthread_cleanup_push(cleanup_mutex, &client_lock);
> -	pthread_mutex_lock(&client_lock);
> -	_dead_client(c);
> -	pthread_cleanup_pop(1);
> -}
> -
>  static void free_polls (void)
>  {
>  	if (polls)
> @@ -194,11 +183,9 @@ void uxsock_cleanup(void *arg)
>  	close(notify_fd);
>  	free(watch_config_dir);
>  
> -	pthread_mutex_lock(&client_lock);
>  	list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
> -		_dead_client(client_loop);
> +		dead_client(client_loop);
>  	}
> -	pthread_mutex_unlock(&client_lock);
>  
>  	cli_exit();
>  	free_polls();
> @@ -668,8 +655,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  		struct timespec __timeout, *timeout;
>  
>  		/* setup for a poll */
> -		pthread_mutex_lock(&client_lock);
> -		pthread_cleanup_push(cleanup_mutex, &client_lock);
>  		num_clients = 0;
>  		list_for_each_entry(c, &clients, node) {
>  			num_clients++;
> @@ -738,8 +723,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>                  n_pfds = i;
>  		timeout = __get_soonest_timeout(&__timeout);
>  
> -		pthread_cleanup_pop(1);
> -
>  		/* most of our life is spent in this call */
>  		poll_count = ppoll(polls, n_pfds, timeout, &mask);
>  
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

