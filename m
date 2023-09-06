Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E54EEE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040159;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mQt4yjSo0OezzPsycda+m7m8EsLKtK9orxNQfdDQhX0=;
	b=AasjoxyS4vmnOPPSk2Qrj6PZD+Imr5jYNleKF/c12EXK8KAGKTJHYMPd+C6ZzMUzUNWGxt
	3sVoMq1JFpq51One+8qpSZyORMCsObDY3u/kjkz85hX8NAZLujsM1RYgHmk2SonuSoq06H
	rxBpFcFDHClE1p1nlymvd0DTyg0FriA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-o0dyYqTSM_-MxyrwmwiLJg-1; Wed, 06 Sep 2023 18:42:36 -0400
X-MC-Unique: o0dyYqTSM_-MxyrwmwiLJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4C1C181792A;
	Wed,  6 Sep 2023 22:42:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3F96C03292;
	Wed,  6 Sep 2023 22:42:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C31E194658D;
	Wed,  6 Sep 2023 22:42:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EF71194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:42:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C58D1121319; Wed,  6 Sep 2023 22:42:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 702161121318;
 Wed,  6 Sep 2023 22:42:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MgPSw028905;
 Wed, 6 Sep 2023 17:42:25 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MgOe2028904;
 Wed, 6 Sep 2023 17:42:24 -0500
Date: Wed, 6 Sep 2023 17:42:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224224.GM7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 02/21] libmultipath: add alias_already_taken()
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
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:15PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Factor out a trivial helper function.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: David Bond <dbond@suse.com>
> ---
>  libmultipath/alias.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> @@ -120,20 +137,9 @@ id_already_taken(int id, const char *prefix, const char *map_wwid)
>  		return 0;
>  
>  	alias = get_strbuf_str(&buf);
> -	if (dm_map_present(alias)) {
> -		char wwid[WWID_SIZE];
> -
> -		/* If both the name and the wwid match, then it's fine.*/
> -		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
> -		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)

Possibly this should return "false" to match the bool return type.
Otherwise, it looks fine.

-Ben

> -			return 0;
> -		condlog(3, "%s: alias '%s' already taken, but not in bindings file. reselecting alias", map_wwid, alias);
> -		return 1;
> -	}
> -	return 0;
> +	return alias_already_taken(alias, map_wwid);
>  }
>  
> -
>  /*
>   * Returns: 0   if matching entry in WWIDs file found
>   *         -1   if an error occurs
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

