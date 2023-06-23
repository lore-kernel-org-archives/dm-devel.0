Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9638EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971623;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=AHp1YN6uGwZqZnYu+8zQpCuzsBWP2t4b30vUv5PBxu4=;
	b=HVYSyWrSv/08zVR7oUdru3dTqzoRlvsZMWA0RTrLQBOjr1GoJzNAthr49IOw95M7QqY8nr
	Mb4qAKrJdzySSmx/TL1kzTkTxpE6JnQ2nHmnYEDfB20h6JtJQVWUzOgS8AaFxAwHbjMzK7
	KX37pkrVTzLQobbJZO0vY68CLZOXDBc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-n6qAJMtAPQqNY1JhpCUNJA-1; Mon, 10 Jul 2023 02:47:01 -0400
X-MC-Unique: n6qAJMtAPQqNY1JhpCUNJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 786501C31C59;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A0D9F66AD;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E039119451F5;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE2C11946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 14:18:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAA34F41C8; Fri, 23 Jun 2023 14:18:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C2851F5AC5
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 14:18:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB85185A7A5
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 14:18:28 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-foxSRwIuPmq9ghWGn1uq5A-1; Fri, 23 Jun 2023 10:18:26 -0400
X-MC-Unique: foxSRwIuPmq9ghWGn1uq5A-1
Received: by mail-lf1-f43.google.com with SMTP id
 2adb3069b0e04-4f87592eccfso844980e87.2
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 07:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687529904; x=1690121904;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=U03ByJLEXBVMFxhG8e0O73cGqPopBbGVt9AAt3CnnZM=;
 b=h78vhqabN0/I/bW198l55F8CJ6PoHtsGTIurXqTWUfIhC0/7Wuuzt5oQ+3ODF5W1et
 JBDTx1ah96ePeIcJwVHcoTJXjX3lv6JgDw8/GIgT8f726a/Bo4qB4Mw3YSSh3VqWMkfe
 zajDqylHB3rZdt8nIpGgkAjkw2HFbGAVPqpH2oDTsAc8arQx/yvW86j70XoLmUvW7A0o
 iaf6UyvIXBAwMsj74AFj3oW4MGbYr50SDWh1G6FGFhxbiYQU1xKaOEKdLy5YuPjEYNV6
 Vc6dsbp1RIP/qWddwAS4n5kxpefK/N1zu646V4qtOeqQ9zBuHi2dxhxLqa3LdF/5agXB
 ldZA==
X-Gm-Message-State: AC+VfDzw7tKPIBrHfCtH9Ryx7AymHfgunGgRLkALVOAEMkVBz3nNrnsD
 NN7A5FSgNdw2w4U+j/TSUUFXQYBuFrynAHCa7Kk=
X-Google-Smtp-Source: ACHHUZ5gD5e0fXJGAEuWY1GjpdaeAwxiN2MHag9P+QRePRiowthqZsR1lYoSq+npkE5Bp5epdKwCAQwNu+Xp8lfnykI=
X-Received: by 2002:ac2:4f13:0:b0:4f9:6b06:129e with SMTP id
 k19-20020ac24f13000000b004f96b06129emr3293665lfr.65.1687529904252; Fri, 23
 Jun 2023 07:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-6-zhengqi.arch@bytedance.com>
In-Reply-To: <20230622085335.77010-6-zhengqi.arch@bytedance.com>
From: Bobs_Email <robertharoldlee@gmail.com>
Date: Fri, 23 Jun 2023 07:18:11 -0700
Message-ID: <CADMFwCv+BsVM51nBNwMTAe5LbfSFGrjzkWEww-ZtGwrhAV+_4Q@mail.gmail.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 05/29] drm/panfrost: dynamically allocate the
 drm-panfrost shrinker
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev, david@fromorbit.com,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
 paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-nfs@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, vbabka@suse.cz,
 brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: multipart/mixed; boundary="===============8293426534811123851=="

--===============8293426534811123851==
Content-Type: multipart/alternative; boundary="0000000000007dacb305feccace6"

--0000000000007dacb305feccace6
Content-Type: text/plain; charset="UTF-8"

Please remove Bob Lee from this email group.
He is deceased


On Thu, Jun 22, 2023, 1:56 AM Qi Zheng <zhengqi.arch@bytedance.com> wrote:

> In preparation for implementing lockless slab shrink,
> we need to dynamically allocate the drm-panfrost shrinker,
> so that it can be freed asynchronously using kfree_rcu().
> Then it doesn't need to wait for RCU read-side critical
> section when releasing the struct panfrost_device.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_device.h    |  2 +-
>  .../gpu/drm/panfrost/panfrost_gem_shrinker.c  | 24 ++++++++++---------
>  2 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h
> b/drivers/gpu/drm/panfrost/panfrost_device.h
> index b0126b9fbadc..e667e5689353 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
> @@ -118,7 +118,7 @@ struct panfrost_device {
>
>         struct mutex shrinker_lock;
>         struct list_head shrinker_list;
> -       struct shrinker shrinker;
> +       struct shrinker *shrinker;
>
>         struct panfrost_devfreq pfdevfreq;
>  };
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> index bf0170782f25..2a5513eb9e1f 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> @@ -18,8 +18,7 @@
>  static unsigned long
>  panfrost_gem_shrinker_count(struct shrinker *shrinker, struct
> shrink_control *sc)
>  {
> -       struct panfrost_device *pfdev =
> -               container_of(shrinker, struct panfrost_device, shrinker);
> +       struct panfrost_device *pfdev = shrinker->private_data;
>         struct drm_gem_shmem_object *shmem;
>         unsigned long count = 0;
>
> @@ -65,8 +64,7 @@ static bool panfrost_gem_purge(struct drm_gem_object
> *obj)
>  static unsigned long
>  panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct
> shrink_control *sc)
>  {
> -       struct panfrost_device *pfdev =
> -               container_of(shrinker, struct panfrost_device, shrinker);
> +       struct panfrost_device *pfdev = shrinker->private_data;
>         struct drm_gem_shmem_object *shmem, *tmp;
>         unsigned long freed = 0;
>
> @@ -100,10 +98,15 @@ panfrost_gem_shrinker_scan(struct shrinker *shrinker,
> struct shrink_control *sc)
>  void panfrost_gem_shrinker_init(struct drm_device *dev)
>  {
>         struct panfrost_device *pfdev = dev->dev_private;
> -       pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
> -       pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
> -       pfdev->shrinker.seeks = DEFAULT_SEEKS;
> -       WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
> +
> +       pfdev->shrinker =
> shrinker_alloc_and_init(panfrost_gem_shrinker_count,
> +
>  panfrost_gem_shrinker_scan, 0,
> +                                                 DEFAULT_SEEKS, 0, pfdev);
> +       if (pfdev->shrinker &&
> +           register_shrinker(pfdev->shrinker, "drm-panfrost")) {
> +               shrinker_free(pfdev->shrinker);
> +               WARN_ON(1);
> +       }
>  }
>
>  /**
> @@ -116,7 +119,6 @@ void panfrost_gem_shrinker_cleanup(struct drm_device
> *dev)
>  {
>         struct panfrost_device *pfdev = dev->dev_private;
>
> -       if (pfdev->shrinker.nr_deferred) {
> -               unregister_shrinker(&pfdev->shrinker);
> -       }
> +       if (pfdev->shrinker->nr_deferred)
> +               unregister_and_free_shrinker(pfdev->shrinker);
>  }
> --
> 2.30.2
>
>

--0000000000007dacb305feccace6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Please remove Bob Lee from this email group.<div dir=3D"a=
uto">He is deceased</div><div dir=3D"auto"><br></div></div><br><div class=
=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Jun 22, 2023=
, 1:56 AM Qi Zheng &lt;<a href=3D"mailto:zhengqi.arch@bytedance.com">zhengq=
i.arch@bytedance.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>In preparation for implementing lockless slab shrink,<br>
we need to dynamically allocate the drm-panfrost shrinker,<br>
so that it can be freed asynchronously using kfree_rcu().<br>
Then it doesn&#39;t need to wait for RCU read-side critical<br>
section when releasing the struct panfrost_device.<br>
<br>
Signed-off-by: Qi Zheng &lt;<a href=3D"mailto:zhengqi.arch@bytedance.com" t=
arget=3D"_blank" rel=3D"noreferrer">zhengqi.arch@bytedance.com</a>&gt;<br>
---<br>
=C2=A0drivers/gpu/drm/panfrost/panfrost_device.h=C2=A0 =C2=A0 |=C2=A0 2 +-<=
br>
=C2=A0.../gpu/drm/panfrost/panfrost_gem_shrinker.c=C2=A0 | 24 ++++++++++---=
------<br>
=C2=A02 files changed, 14 insertions(+), 12 deletions(-)<br>
<br>
diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/p=
anfrost/panfrost_device.h<br>
index b0126b9fbadc..e667e5689353 100644<br>
--- a/drivers/gpu/drm/panfrost/panfrost_device.h<br>
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h<br>
@@ -118,7 +118,7 @@ struct panfrost_device {<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mutex shrinker_lock;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct list_head shrinker_list;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct shrinker shrinker;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct shrinker *shrinker;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct panfrost_devfreq pfdevfreq;<br>
=C2=A0};<br>
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu=
/drm/panfrost/panfrost_gem_shrinker.c<br>
index bf0170782f25..2a5513eb9e1f 100644<br>
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c<br>
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c<br>
@@ -18,8 +18,7 @@<br>
=C2=A0static unsigned long<br>
=C2=A0panfrost_gem_shrinker_count(struct shrinker *shrinker, struct shrink_=
control *sc)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct panfrost_device *pfdev =3D<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0container_of(shrink=
er, struct panfrost_device, shrinker);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct panfrost_device *pfdev =3D shrinker-&gt;=
private_data;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct drm_gem_shmem_object *shmem;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long count =3D 0;<br>
<br>
@@ -65,8 +64,7 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj=
)<br>
=C2=A0static unsigned long<br>
=C2=A0panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_c=
ontrol *sc)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct panfrost_device *pfdev =3D<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0container_of(shrink=
er, struct panfrost_device, shrinker);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct panfrost_device *pfdev =3D shrinker-&gt;=
private_data;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct drm_gem_shmem_object *shmem, *tmp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long freed =3D 0;<br>
<br>
@@ -100,10 +98,15 @@ panfrost_gem_shrinker_scan(struct shrinker *shrinker, =
struct shrink_control *sc)<br>
=C2=A0void panfrost_gem_shrinker_init(struct drm_device *dev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct panfrost_device *pfdev =3D dev-&gt;dev_p=
rivate;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pfdev-&gt;shrinker.count_objects =3D panfrost_g=
em_shrinker_count;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pfdev-&gt;shrinker.scan_objects =3D panfrost_ge=
m_shrinker_scan;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pfdev-&gt;shrinker.seeks =3D DEFAULT_SEEKS;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ON(register_shrinker(&amp;pfdev-&gt;shrink=
er, &quot;drm-panfrost&quot;));<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pfdev-&gt;shrinker =3D shrinker_alloc_and_init(=
panfrost_gem_shrinker_count,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0panfrost_gem_shrinker_scan, 0,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0DEFAULT_SEEKS, 0, pfdev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pfdev-&gt;shrinker &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0register_shrinker(pfdev-&gt;shrin=
ker, &quot;drm-panfrost&quot;)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker_free(pfdev=
-&gt;shrinker);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ON(1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0}<br>
<br>
=C2=A0/**<br>
@@ -116,7 +119,6 @@ void panfrost_gem_shrinker_cleanup(struct drm_device *d=
ev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct panfrost_device *pfdev =3D dev-&gt;dev_p=
rivate;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pfdev-&gt;shrinker.nr_deferred) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unregister_shrinker=
(&amp;pfdev-&gt;shrinker);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pfdev-&gt;shrinker-&gt;nr_deferred)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unregister_and_free=
_shrinker(pfdev-&gt;shrinker);<br>
=C2=A0}<br>
-- <br>
2.30.2<br>
<br>
</blockquote></div>

--0000000000007dacb305feccace6--

--===============8293426534811123851==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8293426534811123851==--

