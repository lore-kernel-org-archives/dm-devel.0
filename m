Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A040C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:45:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9E09233FB
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9E09233FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608158728;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fwZ57Qr9dd5iZPaxFOMsBTCzGasmf1iuqErBfX+gK+s=;
	b=iBqdmqWCQ1kwfNC7vTaHzQJV8Qymbh5o8rbQgDZuHJMtybbO26vSfg6ZVASZfiXey7qhMG
	y9P5d+Kd0CDWdMTCoPfLNPNeRxkk+stw3PcVq3QJqrpSGBNgKocptL6kPtY17VXRHgxERD
	RpEVDAusHz5shhTI8t4wIzXBwVetypo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-eqwo2wEsO728q9MwvQFrvA-1; Wed, 16 Dec 2020 17:45:27 -0500
X-MC-Unique: eqwo2wEsO728q9MwvQFrvA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7408801817;
	Wed, 16 Dec 2020 22:45:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45C5960CCC;
	Wed, 16 Dec 2020 22:45:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8D684EBC6;
	Wed, 16 Dec 2020 22:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGMfM4D015675 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 17:41:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 18BAF1E5; Wed, 16 Dec 2020 22:41:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EC23722C0;
	Wed, 16 Dec 2020 22:41:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BGMfHSa026923; 
	Wed, 16 Dec 2020 16:41:17 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BGMfGLb026922;
	Wed, 16 Dec 2020 16:41:16 -0600
Date: Wed, 16 Dec 2020 16:41:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20201216224115.GP3103@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-23-mwilck@suse.com>
	<7af8e4c39c11eae413c92beef97c62b793a08aa6.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <7af8e4c39c11eae413c92beef97c62b793a08aa6.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 22/29] multipath: fix leaks in
	check_path_valid()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 16, 2020 at 06:34:05PM +0100, Martin Wilck wrote:
> On Fri, 2020-10-16 at 12:44 +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > There were two leaks in check_path_valid(): if path status was
> > successfully determined before calling store_pathvec(), free_path()
> > wasn't called. Also, if an error exit occured, neither cleanup
> > function was called.
> > 
> > This patch fixes both, at the cost of using "static" for the pp and
> > pathvec variables.
> 
> Looking at this again after 2 months, I think the on_exit() part of
> this patch is wrong. First, we can't use on_exit() on every platform,
> as e.g. musl libc doesn't have it. To replace this by the more portable
> atexit(), we'd need to declare the two variables "pp" and "pathvec"
> with file scope, which is very ugly. But more importantly, using static
> variables here causes check_path_valid() to be non-reentrant. While it
> doesn't have to be, it's still a coding pattern we haven't been using
> anywhere else, just to avoid a "memory leak" for an irregular exit,
> which isn't a real memory leak, actually.

A while ago, we had a conversation where we talked about not adding too
much complexity to deal with issues on shutdown, that will just go away
when multipathd stops. I still think that we shouldn't worry too much
about making sure we always free everything when it will automatically
get freed by the system anyway.

-Ben

> 
> One day we should remove the exit() calls somewhere deep down in our
> libraries, and deal with the respective errors cleanly.
> 
> @lixiaokeng, I hope this is ok for you, as you brought the issue up
> originally ("[QUESTION] memory leak in main (multipath)").
> 
> Regards
> Martin
> 
> > 
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  multipath/main.c | 55 +++++++++++++++++++++++++++++++++++++---------
> > --
> >  1 file changed, 43 insertions(+), 12 deletions(-)
> > 
> > diff --git a/multipath/main.c b/multipath/main.c
> > index 049a36f..9974993 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -93,7 +93,7 @@ void rcu_register_thread_memb(void) {}
> >  void rcu_unregister_thread_memb(void) {}
> >  
> >  static int
> > -filter_pathvec (vector pathvec, char * refwwid)
> > +filter_pathvec (vector pathvec, const char *refwwid)
> >  {
> >  	int i;
> >  	struct path * pp;
> > @@ -592,12 +592,37 @@ out:
> >  	return r;
> >  }
> >  
> > +static void cleanup_pathvec(__attribute__((unused)) int dummy, void
> > *arg)
> > +{
> > +	vector *ppv = arg;
> > +
> > +	if (ppv && *ppv) {
> > +		free_pathvec(*ppv, FREE_PATHS);
> > +		*ppv = NULL;
> > +	}
> > +}
> > +
> > +static void cleanup_path(__attribute__((unused)) int dummy, void
> > *arg)
> > +{
> > +	struct path **ppp = arg;
> > +
> > +	if (ppp && *ppp) {
> > +		free_path(*ppp);
> > +		*ppp = NULL;
> > +	}
> > +}
> > +
> >  static int
> >  check_path_valid(const char *name, struct config *conf, bool
> > is_uevent)
> >  {
> >  	int fd, r = PATH_IS_ERROR;
> > -	struct path *pp = NULL;
> > -	vector pathvec = NULL;
> > +	static struct path *pp = NULL;
> > +	static vector pathvec = NULL;
> > +	const char *wwid;
> > +
> > +	/* register these as exit handlers in case we exit irregularly
> > */
> > +	on_exit(cleanup_path, &pp);
> > +	on_exit(cleanup_pathvec, &pathvec);
> >  
> >  	pp = alloc_path();
> >  	if (!pp)
> > @@ -667,13 +692,17 @@ check_path_valid(const char *name, struct
> > config *conf, bool is_uevent)
> >  	if (store_path(pathvec, pp) != 0) {
> >  		free_path(pp);
> >  		goto fail;
> > +	} else {
> > +		/* make sure path isn't freed twice */
> > +		wwid = pp->wwid;
> > +		pp = NULL;
> >  	}
> >  
> >  	/* For find_multipaths = SMART, if there is more than one path
> >  	 * matching the refwwid, then the path is valid */
> >  	if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
> >  		goto fail;
> > -	filter_pathvec(pathvec, pp->wwid);
> > +	filter_pathvec(pathvec, wwid);
> >  	if (VECTOR_SIZE(pathvec) > 1)
> >  		r = PATH_IS_VALID;
> >  	else
> > @@ -681,21 +710,23 @@ check_path_valid(const char *name, struct
> > config *conf, bool is_uevent)
> >  
> >  out:
> >  	r = print_cmd_valid(r, pathvec, conf);
> > -	free_pathvec(pathvec, FREE_PATHS);
> >  	/*
> >  	 * multipath -u must exit with status 0, otherwise udev won't
> >  	 * import its output.
> >  	 */
> >  	if (!is_uevent && r == PATH_IS_NOT_VALID)
> > -		return RTVL_FAIL;
> > -	return RTVL_OK;
> > +		r = RTVL_FAIL;
> > +	else
> > +		r = RTVL_OK;
> > +	goto cleanup;
> >  
> >  fail:
> > -	if (pathvec)
> > -		free_pathvec(pathvec, FREE_PATHS);
> > -	else
> > -		free_path(pp);
> > -	return RTVL_FAIL;
> > +	r = RTVL_FAIL;
> > +
> > +cleanup:
> > +	cleanup_path(0, &pp);
> > +	cleanup_pathvec(0, &pathvec);
> > +	return r;
> >  }
> >  
> >  static int
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

