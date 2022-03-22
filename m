Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAC7C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647961179;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3vUGbZgUxcMQl+JNlO4AwDHRJKPh5GcBiwjUASwFysw=;
	b=PqQJQa3FB72T8VtMJkbiKHKji+t+HOUPoUzVFc4iqbA88emnt29RB3VZ5A2HgF7/AAnEYq
	j5mQsW8obOJ0EpZhoWtHFcAlAW8J7UCPDWSPPVdhCSZWV0cDLnOlCQMANZ4WL2AV+ki6h/
	mNahaaYblRf2+J+/er2i8j4Kftf3aGI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-hh0zLOyEN6WvmKWSA_VjzA-1; Tue, 22 Mar 2022 10:59:36 -0400
X-MC-Unique: hh0zLOyEN6WvmKWSA_VjzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC9D7811E76;
	Tue, 22 Mar 2022 14:59:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEB9840357BD;
	Tue, 22 Mar 2022 14:59:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB0AD1940340;
	Tue, 22 Mar 2022 14:59:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BD7C1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 14:59:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5A945C27E80; Tue, 22 Mar 2022 14:59:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5706DC27E9C
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 14:59:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E8E618A6583
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 14:59:30 +0000 (UTC)
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-cHCy8fyLM0G2Gh-A70pm1A-1; Tue, 22 Mar 2022 10:59:28 -0400
X-MC-Unique: cHCy8fyLM0G2Gh-A70pm1A-1
Received: by mail-lj1-f197.google.com with SMTP id
 f12-20020a2e918c000000b002496651f1d6so5828285ljg.0
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 07:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=N+hZ74/zypV6ncASSn5GKFahI3u/kjGqIjP2NZSkAK4=;
 b=soVR4Gh/jLBRrPyaynSnGs9cFQVxjlB7FiBOLdGBH0BcjXZXO4HyoYCngTjllzlxor
 Bjuozn6ZCNTGBK3pSvOwM7mWzibPEDB2YoL2rSDn+MFmI1026C6JAjv565oa8ZFVGzNv
 AL0EmMsz6aY+7JEDdg+i3TWLXp8Lj5V0kuOneUqFP6+yWkfRKF8qaWmNSfbxfE8XT+Rk
 vNfQQ1hsJpk5+KG84iDeeISHLrSKJsNC3kYLZU6vISANlezMHAOAAMauxYwHt6slZCag
 FOYSmvcNCZmbvWc1KvJ4XwLNuSijiV/9iH8pDKsdF/agj3qRlsgHStS9MQIeCWacDTTH
 0yhA==
X-Gm-Message-State: AOAM533mfDj+pRtMRP50SCHobU2Ofx8ZmiB7h7CyltnfQqNSS9gToPYP
 s85RZ+iCfXOlt+122hbofCE+t42+0aJWVAYBxtB81yow1ZlSYdJYrHGlY9GlU5FQTuBwb6kYW3o
 FwxVvmLiNnwxw1TtRxeR1UzVz+oM7sLw=
X-Received: by 2002:a2e:9b03:0:b0:249:7ded:f634 with SMTP id
 u3-20020a2e9b03000000b002497dedf634mr10151170lji.98.1647961167314; 
 Tue, 22 Mar 2022 07:59:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZBQjQ3KMNhftCKNWNfC4IpzCkzcDJy1/RkZHTNExlREeiTXV9iJQ1SmiazqJq2gquz34QkXrv025JxJARWMc=
X-Received: by 2002:a2e:9b03:0:b0:249:7ded:f634 with SMTP id
 u3-20020a2e9b03000000b002497dedf634mr10151158lji.98.1647961167073; Tue, 22
 Mar 2022 07:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-7-mwilck@suse.com>
 <CAPt1nt4LU_pHJA2m9zWjPhn2i=WOaVnzgiKY+V5za=u2a6StUQ@mail.gmail.com>
 <e1064847c02559b157238ec104aa75b3568fd4f6.camel@suse.com>
In-Reply-To: <e1064847c02559b157238ec104aa75b3568fd4f6.camel@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 09:59:16 -0500
Message-ID: <CAPt1nt6_zuhjhKRCXisoRPOcwRZbeMG516AQ9g+6c4mCvWmWPw@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22, 2022 at 3:35 AM Martin Wilck <mwilck@suse.com> wrote:
>
> On Mon, 2022-03-21 at 19:28 -0500, Benjamin Marzinski wrote:
> > On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
> > >
> > > From: Martin Wilck <mwilck@suse.com>
> > >
> > > This callback is be used by multipathd to unblock pending
> > > reconfigure requests if a map is removed that multipathd is
> > > currently
> > > waiting for.
> > >
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/libmultipath.version | 3 ++-
> > >  libmultipath/structs_vec.c        | 6 ++++++
> > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/libmultipath/libmultipath.version
> > > b/libmultipath/libmultipath.version
> > > index 216f0ee..8132df7 100644
> > > --- a/libmultipath/libmultipath.version
> > > +++ b/libmultipath/libmultipath.version
> > > @@ -31,7 +31,7 @@
> > >   *   The new version inherits the previous ones.
> > >   */
> > >
> > > -LIBMULTIPATH_14.0.0 {
> > > +LIBMULTIPATH_14.1.0 {
> > >  global:
> > >         /* symbols referenced by multipath and multipathd */
> > >         add_foreign;
> > > @@ -164,6 +164,7 @@ global:
> > >         remember_wwid;
> > >         remove_map;
> > >         remove_map_by_alias;
> > > +       remove_map_callback;
> > >         remove_maps;
> > >         remove_wwid;
> > >         replace_wwids;
> > > diff --git a/libmultipath/structs_vec.c
> > > b/libmultipath/structs_vec.c
> > > index 6c23df8..a69f064 100644
> > > --- a/libmultipath/structs_vec.c
> > > +++ b/libmultipath/structs_vec.c
> > > @@ -336,11 +336,17 @@ void set_path_removed(struct path *pp)
> > >         pp->initialized = INIT_REMOVED;
> > >  }
> > >
> > > +void remove_map_callback(struct multipath *mpp
> > > __attribute__((unused)))
> > > +{
> > > +}
> > > +
> >
> > Does this work? I thought that unless you specifically declared the
> > symbol weak, the call in remove_map() would have already gotten
> > resolved to point to the existing remove_map_callback() when the
> > shared library was getting created.  Is it because the function is
> > empty? Am I just misunderstanding something?
>
> This works because I added the symbol to libmultipath.version,
> assigning it "global" visibility. To be consistent, we could do the
> same thing with get_multipath_config() et al., but I didn't want to
> change that just now.

So all of the exported symbols from libmultipath are weak? Good to know.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


> We (or actually, users and distro integrators) have to be somewhat
> careful with adding linker flags. As discussed e.g. in
> https://github.com/opensvc/multipath-tools/issues/26
> flags like "-Bsymbolic-functions" would mess this up, because this flag
> overrides the settings from our linker script. But declaring the symbol
> "weak" wouldn't protect against -Bsymbolic mess-up, either.
>
> I had a long discussion with our toolchain experts about this, which
> lead to the conclusion above. I am pretty positive about it.
> Feel free to ask the RH experts, too ;-)
>
> Regards
> Martin
>
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

