Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA56C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647908952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z1wSZM2p1FG/keYFUlqPY8qZOmAF+BUTD/6PwxLke7k=;
	b=fZF2RHQPiSyVZwnrvhlRTg9t1a9xLBdU3pcD86X2gkEpPoy3IU81hiaAH5XsYqpFqcW5Ju
	/3uZCfGJi8/vNW7B8Cjy7YEV+b2yB+lq1+ux4mQ9AQJEMeOFBF+13K29J6kCrrWZ+49ecv
	ejLyHugzn+9FC8WGPfLRzdst2Qulsew=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-Jqr9IxUKPqiU8Jfn3zTYMg-1; Mon, 21 Mar 2022 20:29:08 -0400
X-MC-Unique: Jqr9IxUKPqiU8Jfn3zTYMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7C8E3C11A09;
	Tue, 22 Mar 2022 00:29:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E770C07F5B;
	Tue, 22 Mar 2022 00:29:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F3CF71947BBE;
	Tue, 22 Mar 2022 00:29:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63FE01947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:29:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1913746A0CC; Tue, 22 Mar 2022 00:29:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1561E469A59
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:29:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F165F802803
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:29:04 +0000 (UTC)
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-akSXSQniNM-2ziRIVByg5A-1; Mon, 21 Mar 2022 20:29:03 -0400
X-MC-Unique: akSXSQniNM-2ziRIVByg5A-1
Received: by mail-lj1-f197.google.com with SMTP id
 q5-20020a2e9145000000b002497bf0eaa1so2737094ljg.5
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=H7zEvUYN7sZ6SVf+fktNZreSIO26prPM0mATwlujUkQ=;
 b=gwJJGarzFnldF7JIuuVSDWL32IYmC9ENffNBA9ghMW59FbIUJm4m2yiCAeTLpVxg5X
 AuUPeeKUa0CLq+9+wj9penPkJ3B01QkzvZtqI8XxqJKwdLZcPVQfh2wIxi4AAhKOEjQH
 uGBA6BOB6lTz7y4R+6V81PT8GT1Bj3huIrE++MGrZFexccrA0oUv0Pj6n4axRsoDwLhI
 cDpVCKCh288nRtA3KDiROsjc6orlf23bOQJUVrLRIVptaT04PSwP0TgwOFZSwNGO4kW7
 vpDq6GMyj36qd52LTUAbrkD1d4c9F6RtK7ZJUobaOHCfUdZ039XGL9HhKRpzJ0KgJWZ1
 svfg==
X-Gm-Message-State: AOAM532EcqWH91ukUsnBtk0XRigutFhhdnpKuf1eyttAhNpp8gUmoDPC
 uQOy/LBi9CSuhzV9giL7QzyDQIj3O9imn7h9FXdJPUPilY067S5MAd/f42TZZFVU35C6tEw/fwX
 uUyRwP81bLHs4tHEcKfMrlDbQXeGbHbA=
X-Received: by 2002:a2e:a58d:0:b0:247:eb93:e747 with SMTP id
 m13-20020a2ea58d000000b00247eb93e747mr16679757ljp.153.1647908942047; 
 Mon, 21 Mar 2022 17:29:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHNC8iC7nHp3Az7Q6Xs4thKCvMs3+L9H2AfnPPh4B8JqykdObZkCTuQnHKJvUeLSeAFknMxjifaZGdgF74xw0=
X-Received: by 2002:a2e:a58d:0:b0:247:eb93:e747 with SMTP id
 m13-20020a2ea58d000000b00247eb93e747mr16679747ljp.153.1647908941881; Mon, 21
 Mar 2022 17:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-7-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-7-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:28:50 -0500
Message-ID: <CAPt1nt4LU_pHJA2m9zWjPhn2i=WOaVnzgiKY+V5za=u2a6StUQ@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 06/11] libmultipath: add callback for
 remove_map()
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
>
> From: Martin Wilck <mwilck@suse.com>
>
> This callback is be used by multipathd to unblock pending
> reconfigure requests if a map is removed that multipathd is currently
> waiting for.
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/libmultipath.version | 3 ++-
>  libmultipath/structs_vec.c        | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 216f0ee..8132df7 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -31,7 +31,7 @@
>   *   The new version inherits the previous ones.
>   */
>
> -LIBMULTIPATH_14.0.0 {
> +LIBMULTIPATH_14.1.0 {
>  global:
>         /* symbols referenced by multipath and multipathd */
>         add_foreign;
> @@ -164,6 +164,7 @@ global:
>         remember_wwid;
>         remove_map;
>         remove_map_by_alias;
> +       remove_map_callback;
>         remove_maps;
>         remove_wwid;
>         replace_wwids;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 6c23df8..a69f064 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -336,11 +336,17 @@ void set_path_removed(struct path *pp)
>         pp->initialized = INIT_REMOVED;
>  }
>
> +void remove_map_callback(struct multipath *mpp __attribute__((unused)))
> +{
> +}
> +

Does this work? I thought that unless you specifically declared the
symbol weak, the call in remove_map() would have already gotten
resolved to point to the existing remove_map_callback() when the
shared library was getting created.  Is it because the function is
empty? Am I just misunderstanding something?

-Ben

>  void
>  remove_map(struct multipath *mpp, vector pathvec, vector mpvec)
>  {
>         int i;
>
> +       remove_map_callback(mpp);
> +
>         free_pathvec(mpp->paths, KEEP_PATHS);
>         free_pgvec(mpp->pg, KEEP_PATHS);
>         mpp->paths = mpp->pg = NULL;
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

