Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B7DC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 12 Oct 2022 07:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665560009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=G0qjy1yiSUlPsANJ3M+TFy86ccW7Fc5GlRrEwcmqem0=;
	b=FJOcSxQzf6wbEP77PGHc/g7/UrYM8ugFWp5M/Pd9rNugVSVesmU4GJ2zYUHSPNGwLJLDKS
	Nhp1VQEGrTbpVgZBFGlEkBazdXMiHZb/VEWwXxDfFwkghSbgFn3IUGxF60VS+4sfLdlRkJ
	mQ/SjFzmVBhWl861qdy7vicQq5dXPxs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-IWUSGieRNeeud3ZwYibfug-1; Wed, 12 Oct 2022 03:33:25 -0400
X-MC-Unique: IWUSGieRNeeud3ZwYibfug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FB4F3C0F66C;
	Wed, 12 Oct 2022 07:33:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2733B4A927B;
	Wed, 12 Oct 2022 07:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BBC11946594;
	Wed, 12 Oct 2022 07:33:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35FE91946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Oct 2022 06:31:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 15B3240E2934; Wed, 12 Oct 2022 06:31:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D24440C206B
 for <dm-devel@redhat.com>; Wed, 12 Oct 2022 06:31:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD671811E7A
 for <dm-devel@redhat.com>; Wed, 12 Oct 2022 06:31:23 +0000 (UTC)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-Yq-QkqPTNouoonx4Y-hNaA-1; Wed, 12 Oct 2022 02:31:22 -0400
X-MC-Unique: Yq-QkqPTNouoonx4Y-hNaA-1
Received: by mail-pf1-f198.google.com with SMTP id
 q18-20020aa79832000000b00562d921e30aso5724952pfl.4
 for <dm-devel@redhat.com>; Tue, 11 Oct 2022 23:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=PRaNY7aRj+gsjZ58M2t5dmH7JLoO+bxwHZWTc/ptJl4=;
 b=EV6ro12KGwP0A/FBZU3yXLnyWp0Obbh92UpbCnqEmqn4TF5BZc+HPAtbQ/ozyoFPzd
 gBmaA+lx12lxH0awH65gU8b1nxpKAwZHbPC7ki9Hjj+2CPFPo9xIgptewF3F6AQHe3ki
 9e4LYO66oIHa/GpS4XmNeLOeDtfQEFiZrBdUNQYg8a/HlwUXuS+aWOgprnezZQMCkx4k
 ZO8/U5AuNlcmMSgvcMisYPKIGXpqnKrCcYOCzvJVrAW4EMxepeZR3O7i7TX5EASWEQD2
 f8FAuyCYoa1HoaNP/WH93nrE/7f1/6YHmQkKP+oX3Ry21sI6o1d4nrNEqjxqLGmVoGoq
 QAlw==
X-Gm-Message-State: ACrzQf3OR6NbuunsaBWu3Q2MZfxsnGqFw+WsH23pisWFL0CoUP26aqlB
 iO45qEXfS29mvLlQWjPIfmPs9gB8u6sCEnpEDpcKXMz0qSGUkYzY3v7xW31ENuMThPo8Ki+V8q9
 Ay1880bWaNIYKzF5m/KVaHXogdBjnzWo=
X-Received: by 2002:a17:902:7c05:b0:178:1f92:288e with SMTP id
 x5-20020a1709027c0500b001781f92288emr27923600pll.92.1665556281165; 
 Tue, 11 Oct 2022 23:31:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7+OLsTjImt0+xv3zCKUhLiSoz+SEs9ObfTN6yJBA/k71Feg9f1vcV48fupKKQs9AQvl6nOLjv4k6bpk62X1z0=
X-Received: by 2002:a17:902:7c05:b0:178:1f92:288e with SMTP id
 x5-20020a1709027c0500b001781f92288emr27923572pll.92.1665556280861; Tue, 11
 Oct 2022 23:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2210111505160.18298@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2210111505160.18298@file01.intranet.prod.int.rdu2.redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Wed, 12 Oct 2022 07:31:09 +0100
Message-ID: <CAJ0trDa8+TasExXYKASBd0ctJ2_ZmB7NbqRV9oadEhYNfGeGiA@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 12 Oct 2022 07:33:20 +0000
Subject: Re: [dm-devel] [PATCH 4/4 v2] persistent-data: reduce lock
 contention while walking the btree
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4626603863922456236=="

--===============4626603863922456236==
Content-Type: multipart/alternative; boundary="000000000000797b8405ead08a9a"

--000000000000797b8405ead08a9a
Content-Type: text/plain; charset="UTF-8"

Thanks Mikulas,

I'll test this morning.

- Joe


On Tue, Oct 11, 2022 at 8:10 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
>
> Here I'm sending updated patch 4 that fixes hang on discard. We must not
> do the optimization in dm_btree_lookup_next.
>
> Mikulas
>
>
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> This patch reduces lock contention in btree walks. We modify the
> functions init_ro_wpin, exit_ro_spine and ro_step so that they use
> dm_bufio_lock_read/dm_bufio_get_unlocked/dm_bufio_unlock_read. If
> dm_bm_fast_get_block fails, we fallback to normal locking.
>
> When doing tests on pmem and fully provisioned thin volume, it improves
> thoughput from 286MiB/s to 442MiB/s.
>
> fio --ioengine=psync --iodepth=1 --rw=randrw --bs=4k --direct=1
> --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/vg/thin
> before:
> READ: bw=286MiB/s
> WRITE: bw=286MiB/s
> after:
> READ: bw=442MiB/s
> WRITE: bw=442MiB/s
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/persistent-data/dm-block-manager.c       |   32 +++++++++++++++
>  drivers/md/persistent-data/dm-block-manager.h       |    6 ++
>  drivers/md/persistent-data/dm-btree-internal.h      |    4 +
>  drivers/md/persistent-data/dm-btree-spine.c         |   41
> ++++++++++++++++++--
>  drivers/md/persistent-data/dm-btree.c               |    6 +-
>  drivers/md/persistent-data/dm-transaction-manager.c |   17 ++++++++
>  drivers/md/persistent-data/dm-transaction-manager.h |    6 ++
>  7 files changed, 104 insertions(+), 8 deletions(-)
>
> Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.c
> +++ linux-2.6/drivers/md/persistent-data/dm-block-manager.c
> @@ -601,6 +601,38 @@ void dm_bm_unlock(struct dm_block *b)
>  }
>  EXPORT_SYMBOL_GPL(dm_bm_unlock);
>
> +void dm_bm_fast_lock(struct dm_block_manager *bm)
> +{
> +       dm_bufio_lock_read(bm->bufio);
> +}
> +
> +void dm_bm_fast_unlock(struct dm_block_manager *bm)
> +{
> +       dm_bufio_unlock_read(bm->bufio);
> +}
> +
> +int dm_bm_fast_get_block(struct dm_block_manager *bm,
> +                        dm_block_t b, struct dm_block_validator *v,
> +                        struct dm_block **result)
> +{
> +       int r;
> +       struct buffer_aux *aux;
> +       void *p;
> +
> +       p = dm_bufio_get_unlocked(bm->bufio, b, (struct dm_buffer **)
> result);
> +       if (IS_ERR(p))
> +               return PTR_ERR(p);
> +       if (unlikely(!p))
> +               return -EWOULDBLOCK;
> +
> +       aux = dm_bufio_get_aux_data(to_buffer(*result));
> +       r = dm_bm_validate_buffer(bm, to_buffer(*result), aux, v);
> +       if (unlikely(r))
> +               return r;
> +
> +       return 0;
> +}
> +
>  int dm_bm_flush(struct dm_block_manager *bm)
>  {
>         if (dm_bm_is_read_only(bm))
> Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.h
> +++ linux-2.6/drivers/md/persistent-data/dm-block-manager.h
> @@ -96,6 +96,12 @@ int dm_bm_write_lock_zero(struct dm_bloc
>
>  void dm_bm_unlock(struct dm_block *b);
>
> +void dm_bm_fast_lock(struct dm_block_manager *bm);
> +void dm_bm_fast_unlock(struct dm_block_manager *bm);
> +int dm_bm_fast_get_block(struct dm_block_manager *bm,
> +                        dm_block_t b, struct dm_block_validator *v,
> +                        struct dm_block **result);
> +
>  /*
>   * It's a common idiom to have a superblock that should be committed last.
>   *
> Index: linux-2.6/drivers/md/persistent-data/dm-btree-internal.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-btree-internal.h
> +++ linux-2.6/drivers/md/persistent-data/dm-btree-internal.h
> @@ -64,9 +64,11 @@ struct ro_spine {
>         struct dm_btree_info *info;
>
>         struct dm_block *node;
> +       bool fast_locked;
> +       bool fast_lock_failed;
>  };
>
> -void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
> +void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info, bool
> disable_fast_access);
>  void exit_ro_spine(struct ro_spine *s);
>  int ro_step(struct ro_spine *s, dm_block_t new_child);
>  struct btree_node *ro_node(struct ro_spine *s);
> Index: linux-2.6/drivers/md/persistent-data/dm-btree-spine.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-btree-spine.c
> +++ linux-2.6/drivers/md/persistent-data/dm-btree-spine.c
> @@ -118,27 +118,60 @@ void unlock_block(struct dm_btree_info *
>         dm_tm_unlock(info->tm, b);
>  }
>
> +static void bn_fast_lock(struct dm_btree_info *info)
> +{
> +       dm_tm_fast_lock(info->tm);
> +}
> +
> +static void bn_fast_unlock(struct dm_btree_info *info)
> +{
> +       dm_tm_fast_unlock(info->tm);
> +}
> +
> +static int bn_fast_get_block(struct dm_btree_info *info, dm_block_t b,
> +                     struct dm_block **result)
> +{
> +       return dm_tm_fast_get_block(info->tm, b, &btree_node_validator,
> result);
> +}
> +
>  /*----------------------------------------------------------------*/
>
> -void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)
> +void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info, bool
> disable_fast_access)
>  {
>         s->info = info;
>         s->node = NULL;
> +       s->fast_locked = false;
> +       s->fast_lock_failed = disable_fast_access;
>  }
>
>  void exit_ro_spine(struct ro_spine *s)
>  {
> -       if (s->node)
> +       if (s->fast_locked)
> +               bn_fast_unlock(s->info);
> +       else if (s->node)
>                 unlock_block(s->info, s->node);
>  }
>
>  int ro_step(struct ro_spine *s, dm_block_t new_child)
>  {
>         if (s->node) {
> -               unlock_block(s->info, s->node);
> +               if (unlikely(!s->fast_locked))
> +                       unlock_block(s->info, s->node);
>                 s->node = NULL;
>         }
> -
> +       if (likely(!s->fast_lock_failed)) {
> +               int r;
> +               if (!s->fast_locked) {
> +                       bn_fast_lock(s->info);
> +                       s->fast_locked = true;
> +               }
> +               r = bn_fast_get_block(s->info, new_child, &s->node);
> +               if (likely(!r))
> +                       return 0;
> +               s->fast_lock_failed = true;
> +               s->fast_locked = false;
> +               bn_fast_unlock(s->info);
> +       }
>         return bn_read_lock(s->info, new_child, &s->node);
>  }
>
> Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.c
> +++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -348,6 +348,23 @@ void dm_tm_unlock(struct dm_transaction_
>  }
>  EXPORT_SYMBOL_GPL(dm_tm_unlock);
>
> +void dm_tm_fast_lock(struct dm_transaction_manager *tm)
> +{
> +       dm_bm_fast_lock(tm->is_clone ? tm->real->bm : tm->bm);
> +}
> +
> +void dm_tm_fast_unlock(struct dm_transaction_manager *tm)
> +{
> +       dm_bm_fast_unlock(tm->is_clone ? tm->real->bm : tm->bm);
> +}
> +
> +int dm_tm_fast_get_block(struct dm_transaction_manager *tm, dm_block_t b,
> +                        struct dm_block_validator *v,
> +                        struct dm_block **blk)
> +{
> +       return dm_bm_fast_get_block(tm->is_clone ? tm->real->bm : tm->bm,
> b, v, blk);
> +}
> +
>  void dm_tm_inc(struct dm_transaction_manager *tm, dm_block_t b)
>  {
>         /*
> Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.h
> +++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h
> @@ -96,6 +96,12 @@ int dm_tm_read_lock(struct dm_transactio
>
>  void dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b);
>
> +void dm_tm_fast_lock(struct dm_transaction_manager *tm);
> +void dm_tm_fast_unlock(struct dm_transaction_manager *tm);
> +int dm_tm_fast_get_block(struct dm_transaction_manager *tm, dm_block_t b,
> +                        struct dm_block_validator *v,
> +                        struct dm_block **blk);
> +
>  /*
>   * Functions for altering the reference count of a block directly.
>   */
> Index: linux-2.6/drivers/md/persistent-data/dm-btree.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/persistent-data/dm-btree.c
> +++ linux-2.6/drivers/md/persistent-data/dm-btree.c
> @@ -377,7 +377,7 @@ int dm_btree_lookup(struct dm_btree_info
>         __le64 internal_value_le;
>         struct ro_spine spine;
>
> -       init_ro_spine(&spine, info);
> +       init_ro_spine(&spine, info, false);
>         for (level = 0; level < info->levels; level++) {
>                 size_t size;
>                 void *value_p;
> @@ -472,7 +472,7 @@ int dm_btree_lookup_next(struct dm_btree
>         __le64 internal_value_le;
>         struct ro_spine spine;
>
> -       init_ro_spine(&spine, info);
> +       init_ro_spine(&spine, info, true);
>         for (level = 0; level < info->levels - 1u; level++) {
>                 r = btree_lookup_raw(&spine, root, keys[level],
>                                      lower_bound, rkey,
> @@ -1369,7 +1369,7 @@ static int dm_btree_find_key(struct dm_b
>         int r = 0, count = 0, level;
>         struct ro_spine spine;
>
> -       init_ro_spine(&spine, info);
> +       init_ro_spine(&spine, info, false);
>         for (level = 0; level < info->levels; level++) {
>                 r = find_key(&spine, root, find_highest, result_keys +
> level,
>                              level == info->levels - 1 ? NULL : &root);
>
>

--000000000000797b8405ead08a9a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Mikulas,<div><br></div><div>I&#39;ll test this morn=
ing.</div><div><br></div><div>- Joe</div><div><br></div></div><br><div clas=
s=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Oct 11, 202=
2 at 8:10 PM Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com">mpa=
tocka@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" =
style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pa=
dding-left:1ex">Hi<br>
<br>
Here I&#39;m sending updated patch 4 that fixes hang on discard. We must no=
t <br>
do the optimization in dm_btree_lookup_next.<br>
<br>
Mikulas<br>
<br>
<br>
From: Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com" target=3D"=
_blank">mpatocka@redhat.com</a>&gt;<br>
<br>
This patch reduces lock contention in btree walks. We modify the<br>
functions init_ro_wpin, exit_ro_spine and ro_step so that they use<br>
dm_bufio_lock_read/dm_bufio_get_unlocked/dm_bufio_unlock_read. If<br>
dm_bm_fast_get_block fails, we fallback to normal locking.<br>
<br>
When doing tests on pmem and fully provisioned thin volume, it improves<br>
thoughput from 286MiB/s to 442MiB/s.<br>
<br>
fio --ioengine=3Dpsync --iodepth=3D1 --rw=3Drandrw --bs=3D4k --direct=3D1 -=
-numjobs=3D12 --time_based --runtime=3D10 --group_reporting --name=3D/dev/v=
g/thin<br>
before:<br>
READ: bw=3D286MiB/s<br>
WRITE: bw=3D286MiB/s<br>
after:<br>
READ: bw=3D442MiB/s<br>
WRITE: bw=3D442MiB/s<br>
<br>
Signed-off-by: Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com" t=
arget=3D"_blank">mpatocka@redhat.com</a>&gt;<br>
<br>
---<br>
=C2=A0drivers/md/persistent-data/dm-block-manager.c=C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 =C2=A032 +++++++++++++++<br>
=C2=A0drivers/md/persistent-data/dm-block-manager.h=C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 =C2=A0 6 ++<br>
=C2=A0drivers/md/persistent-data/dm-btree-internal.h=C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 =C2=A0 4 +<br>
=C2=A0drivers/md/persistent-data/dm-btree-spine.c=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A041 ++++++++++++++++++--<br>
=C2=A0drivers/md/persistent-data/dm-btree.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 6 +-<br>
=C2=A0drivers/md/persistent-data/dm-transaction-manager.c |=C2=A0 =C2=A017 =
++++++++<br>
=C2=A0drivers/md/persistent-data/dm-transaction-manager.h |=C2=A0 =C2=A0 6 =
++<br>
=C2=A07 files changed, 104 insertions(+), 8 deletions(-)<br>
<br>
Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.c<br>
+++ linux-2.6/drivers/md/persistent-data/dm-block-manager.c<br>
@@ -601,6 +601,38 @@ void dm_bm_unlock(struct dm_block *b)<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bm_unlock);<br>
<br>
+void dm_bm_fast_lock(struct dm_block_manager *bm)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock_read(bm-&gt;bufio);<br>
+}<br>
+<br>
+void dm_bm_fast_unlock(struct dm_block_manager *bm)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock_read(bm-&gt;bufio);<br>
+}<br>
+<br>
+int dm_bm_fast_get_block(struct dm_block_manager *bm,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dm_block_t b, struct dm_block_validator *v,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct dm_block **result)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct buffer_aux *aux;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0void *p;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D dm_bufio_get_unlocked(bm-&gt;bufio, b, (s=
truct dm_buffer **) result);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(p))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(p);<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!p))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EWOULDBLOCK=
;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0aux =3D dm_bufio_get_aux_data(to_buffer(*result=
));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D dm_bm_validate_buffer(bm, to_buffer(*resu=
lt), aux, v);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(r))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br>
+<br>
=C2=A0int dm_bm_flush(struct dm_block_manager *bm)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_bm_is_read_only(bm))<br>
Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.h<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.h<br>
+++ linux-2.6/drivers/md/persistent-data/dm-block-manager.h<br>
@@ -96,6 +96,12 @@ int dm_bm_write_lock_zero(struct dm_bloc<br>
<br>
=C2=A0void dm_bm_unlock(struct dm_block *b);<br>
<br>
+void dm_bm_fast_lock(struct dm_block_manager *bm);<br>
+void dm_bm_fast_unlock(struct dm_block_manager *bm);<br>
+int dm_bm_fast_get_block(struct dm_block_manager *bm,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dm_block_t b, struct dm_block_validator *v,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct dm_block **result);<br>
+<br>
=C2=A0/*<br>
=C2=A0 * It&#39;s a common idiom to have a superblock that should be commit=
ted last.<br>
=C2=A0 *<br>
Index: linux-2.6/drivers/md/persistent-data/dm-btree-internal.h<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-internal.h<br>
+++ linux-2.6/drivers/md/persistent-data/dm-btree-internal.h<br>
@@ -64,9 +64,11 @@ struct ro_spine {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_btree_info *info;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_block *node;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool fast_locked;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool fast_lock_failed;<br>
=C2=A0};<br>
<br>
-void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);<br>
+void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info, bool di=
sable_fast_access);<br>
=C2=A0void exit_ro_spine(struct ro_spine *s);<br>
=C2=A0int ro_step(struct ro_spine *s, dm_block_t new_child);<br>
=C2=A0struct btree_node *ro_node(struct ro_spine *s);<br>
Index: linux-2.6/drivers/md/persistent-data/dm-btree-spine.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-spine.c<br>
+++ linux-2.6/drivers/md/persistent-data/dm-btree-spine.c<br>
@@ -118,27 +118,60 @@ void unlock_block(struct dm_btree_info *<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_tm_unlock(info-&gt;tm, b);<br>
=C2=A0}<br>
<br>
+static void bn_fast_lock(struct dm_btree_info *info)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_tm_fast_lock(info-&gt;tm);<br>
+}<br>
+<br>
+static void bn_fast_unlock(struct dm_btree_info *info)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_tm_fast_unlock(info-&gt;tm);<br>
+}<br>
+<br>
+static int bn_fast_get_block(struct dm_btree_info *info, dm_block_t b,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0struct dm_block **result)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return dm_tm_fast_get_block(info-&gt;tm, b, &am=
p;btree_node_validator, result);<br>
+}<br>
+<br>
=C2=A0/*----------------------------------------------------------------*/<=
br>
<br>
-void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)<br>
+void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info, bool di=
sable_fast_access)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 s-&gt;info =3D info;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 s-&gt;node =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0s-&gt;fast_locked =3D false;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0s-&gt;fast_lock_failed =3D disable_fast_access;=
<br>
=C2=A0}<br>
<br>
=C2=A0void exit_ro_spine(struct ro_spine *s)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (s-&gt;node)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (s-&gt;fast_locked)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bn_fast_unlock(s-&g=
t;info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else if (s-&gt;node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unlock_block(s-&gt;=
info, s-&gt;node);<br>
=C2=A0}<br>
<br>
=C2=A0int ro_step(struct ro_spine *s, dm_block_t new_child)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (s-&gt;node) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlock_block(s-&gt;=
info, s-&gt;node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!s-&gt=
;fast_locked))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0unlock_block(s-&gt;info, s-&gt;node);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 s-&gt;node =3D NULL=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!s-&gt;fast_lock_failed)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!s-&gt;fast_loc=
ked) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0bn_fast_lock(s-&gt;info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0s-&gt;fast_locked =3D true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D bn_fast_get_b=
lock(s-&gt;info, new_child, &amp;s-&gt;node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!r))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0s-&gt;fast_lock_fai=
led =3D true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0s-&gt;fast_locked =
=3D false;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bn_fast_unlock(s-&g=
t;info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return bn_read_lock(s-&gt;info, new_child, &amp=
;s-&gt;node);<br>
=C2=A0}<br>
<br>
Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.c<br>
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c<br>
@@ -348,6 +348,23 @@ void dm_tm_unlock(struct dm_transaction_<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_tm_unlock);<br>
<br>
+void dm_tm_fast_lock(struct dm_transaction_manager *tm)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bm_fast_lock(tm-&gt;is_clone ? tm-&gt;real-&=
gt;bm : tm-&gt;bm);<br>
+}<br>
+<br>
+void dm_tm_fast_unlock(struct dm_transaction_manager *tm)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bm_fast_unlock(tm-&gt;is_clone ? tm-&gt;real=
-&gt;bm : tm-&gt;bm);<br>
+}<br>
+<br>
+int dm_tm_fast_get_block(struct dm_transaction_manager *tm, dm_block_t b,<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct dm_block_validator *v,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct dm_block **blk)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return dm_bm_fast_get_block(tm-&gt;is_clone ? t=
m-&gt;real-&gt;bm : tm-&gt;bm, b, v, blk);<br>
+}<br>
+<br>
=C2=A0void dm_tm_inc(struct dm_transaction_manager *tm, dm_block_t b)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.h<br>
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h<br>
@@ -96,6 +96,12 @@ int dm_tm_read_lock(struct dm_transactio<br>
<br>
=C2=A0void dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block =
*b);<br>
<br>
+void dm_tm_fast_lock(struct dm_transaction_manager *tm);<br>
+void dm_tm_fast_unlock(struct dm_transaction_manager *tm);<br>
+int dm_tm_fast_get_block(struct dm_transaction_manager *tm, dm_block_t b,<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct dm_block_validator *v,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct dm_block **blk);<br>
+<br>
=C2=A0/*<br>
=C2=A0 * Functions for altering the reference count of a block directly.<br=
>
=C2=A0 */<br>
Index: linux-2.6/drivers/md/persistent-data/dm-btree.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree.c<br>
+++ linux-2.6/drivers/md/persistent-data/dm-btree.c<br>
@@ -377,7 +377,7 @@ int dm_btree_lookup(struct dm_btree_info<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __le64 internal_value_le;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ro_spine spine;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0init_ro_spine(&amp;spine, info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0init_ro_spine(&amp;spine, info, false);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (level =3D 0; level &lt; info-&gt;levels; l=
evel++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t size;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *value_p;<br>
@@ -472,7 +472,7 @@ int dm_btree_lookup_next(struct dm_btree<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __le64 internal_value_le;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ro_spine spine;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0init_ro_spine(&amp;spine, info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0init_ro_spine(&amp;spine, info, true);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (level =3D 0; level &lt; info-&gt;levels - =
1u; level++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D btree_lookup_=
raw(&amp;spine, root, keys[level],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lower_bound, rke=
y,<br>
@@ -1369,7 +1369,7 @@ static int dm_btree_find_key(struct dm_b<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0, count =3D 0, level;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ro_spine spine;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0init_ro_spine(&amp;spine, info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0init_ro_spine(&amp;spine, info, false);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (level =3D 0; level &lt; info-&gt;levels; l=
evel++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D find_key(&amp=
;spine, root, find_highest, result_keys + level,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0level =3D=3D info-&gt;levels - 1 ? NULL : &a=
mp;root);<br>
<br>
</blockquote></div>

--000000000000797b8405ead08a9a--

--===============4626603863922456236==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4626603863922456236==--

