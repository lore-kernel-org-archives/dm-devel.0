Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A813EB8FA6
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 03:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693970160;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=RoEl3eFWsnrGsTg8AqNdUfKfWKEWLm8wKNg+poT1Lvg=;
	b=W0zApfo/JUELADz3jtSVmnslGJ1b3cbhTdF13fXmUf125XWJIA8a53swi05T3m/nI+MaEn
	Z3TmGWWiV0o41qM6Zpjsb1jRqlkZzC/2Nmv01IEexsEL+ZpMwsEIgZxUsjckbphnuBKLrH
	AMj3kAixeiFlxk5QJbBxzRPhoDEpveA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-qQRMoz-eOF-Yeb9anzlNCA-1; Tue, 05 Sep 2023 23:15:58 -0400
X-MC-Unique: qQRMoz-eOF-Yeb9anzlNCA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C88A03810D48;
	Wed,  6 Sep 2023 03:15:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50682493110;
	Wed,  6 Sep 2023 03:15:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 02BCD194658C;
	Wed,  6 Sep 2023 03:15:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFE941946589
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 03:15:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 76DA0C03292; Wed,  6 Sep 2023 03:15:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F6CCC15BB8
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 03:15:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F60B856DED
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 03:15:54 +0000 (UTC)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-j7o1Qf3tPauJld9Zfxkq4A-1; Tue, 05 Sep 2023 23:15:52 -0400
X-MC-Unique: j7o1Qf3tPauJld9Zfxkq4A-1
Received: by mail-ej1-f71.google.com with SMTP id
 a640c23a62f3a-99c0bd2ca23so223252766b.2
 for <dm-devel@redhat.com>; Tue, 05 Sep 2023 20:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1693970151; x=1694574951;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=KFaQ3EwT0Fm+J+2by3c0B5wkyAzCZKSzWtp/r2XyFX4=;
 b=AqS+LaZ8fOL3PMH5Op8VYE+jqOGOGQTpEHc/KK1xmfMLnFled/Rn4e9dYLbmuBUxos
 13vdOH+RMZELN44krf5BzKvk+GFvFbg5Wl7zj5gF3uH7rJ2zyREvqVx2ioW05hx5WxIf
 vhyrhK2FGATNJnjRU5xEAzmEllbx4HH26MAid5pJ5mZJbQgs84LlzG+iTA4bPZXqDjmW
 SWEtlUE5AU5OtVJ+rL7WpBqz5q5spyDFHHGlUNnTwOrC6yaSi098izlzSBFXK0GTGktz
 oBzx4kWMHMyjIUgtmhGluN9eJgAqTxi3U76oxpmm7Nsq5nL/nrQrRkpWeicMYA+ox5Xk
 Artw==
X-Gm-Message-State: AOJu0Yw8sIv5hrfpQmgaYw8IxATTUBFigtS9+xRL2YBrZn1+4kUzkxnR
 RF2orIFGEJhf1mYIxXTd2UE0JumyMjKXspp0Lkb7It8Ai7Bd0OBZIDH4l7l0MYQ60N4sO06z/Nq
 uEnpr3h2phumdI+nIN5q7KLISTHejhQ==
X-Received: by 2002:a17:906:32d3:b0:9a6:5340:c335 with SMTP id
 k19-20020a17090632d300b009a65340c335mr1137060ejk.45.1693970151372; 
 Tue, 05 Sep 2023 20:15:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKhR2Ko0Se3npb7dyC3/F8C2G3pi60pQi+b7IMcOkP7wA2pzWeQY8vMKI2FVbW7/yz+iTL/5jqyH6OV8ZcqS8=
X-Received: by 2002:a17:906:32d3:b0:9a6:5340:c335 with SMTP id
 k19-20020a17090632d300b009a65340c335mr1137051ejk.45.1693970151067; Tue, 05
 Sep 2023 20:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221010144123.252329-1-luomeng@huaweicloud.com>
 <Y02zebNyn73/MN1d@redhat.com>
 <eb9e1d80-c62c-c62f-4fc2-5be21fc75472@huawei.com>
 <ZMqFVGX/ZbVABDJ6@redhat.com> <a508359-734b-35c9-a393-42c27870a1fa@redhat.com>
 <a8a3f458-d7d1-e5b6-d672-45c8a8c072ad@redhat.com>
 <31a54071-e583-34bb-dc50-a774ae40688a@huawei.com>
In-Reply-To: <31a54071-e583-34bb-dc50-a774ae40688a@huawei.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 5 Sep 2023 23:15:38 -0400
Message-ID: <CAH6w=azG2gR=AR-NjY5Zh8+h9p=dPQf7w+y2_1ER6x2GBoWOpw@mail.gmail.com>
To: Li Lingfeng <lilingfeng3@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [dm-devel resend] dm mpath: fix UAF in
 multipath_message()
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
Cc: Mike Snitzer <snitzer@kernel.org>, "development,
 device-mapper" <dm-devel@redhat.com>, Luo Meng <luomeng@huaweicloud.com>,
 ejt <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Luo Meng <luomeng12@huawei.com>, "yukuai \(C\)" <yukuai3@huawei.com>,
 agk <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5647169504002620231=="

--===============5647169504002620231==
Content-Type: multipart/alternative; boundary="0000000000001d67840604a82939"

--0000000000001d67840604a82939
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please reply to Mikulas's updated patch with your Reviewed-by: and possibly
Tested-by:

Thanks,
Mike

On Tue, Sep 5, 2023, 10:16 PM Li Lingfeng <lilingfeng3@huawei.com> wrote:

> Hi
>
> Thanks to Mikulas for the patch. I have test the patch and it can fix
> the problem.
> Can this patch be applied to mainline?
>
> Thanks.
>
> =E5=9C=A8 2023/8/9 18:44, Mikulas Patocka =E5=86=99=E9=81=93:
> >
> > On Tue, 8 Aug 2023, Mikulas Patocka wrote:
> >
> >> On Wed, 2 Aug 2023, Mike Snitzer wrote:
> >>
> >>> [Cc'ing Mikulas so he can take a look at this too.]
> >> Hi
> >>
> >> I suggest this patch (but it's only compile-tested, so please run some
> >> testsuite on it).
> >>
> >> Mikulas
> > I self-nack that patch - it doesn't work if there are multiple targets
> > calling dm_table_set_devices_mutex in the same table. This is not an
> issue
> > for multipath, but it will be a problem if other targets use this
> > functionality.
> >
> > Here I'm sending a better patch that doesn't need any modification to t=
he
> > targets at all.
> >
> > Mikulas
> >
> >
> >
> > From: Mikulas Patocka <mpatocka at redhat.com>
> > Subject: [PATCH] dm: fix a race condition in retrieve_deps
> >
> > There's a race condition in the multipath target when retrieve_deps rac=
es
> > with multipath_message calling dm_get_device and dm_put_device.
> > retrieve_deps walks the list of open devices without holding any lock b=
ut
> > multipath may add or remove devices to the list while it is running. Th=
e
> > end result may be memory corruption or use-after-free memory access.
> >
> > Fix this bug by introducing a new rw semaphore "devices_lock". We grab
> > devices_lock for read in retrieve_deps and we grab it for write in
> > dm_get_device and dm_put_device.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> >
> > ---
> >   drivers/md/dm-core.h  |    1 +
> >   drivers/md/dm-ioctl.c |    7 ++++++-
> >   drivers/md/dm-table.c |   32 ++++++++++++++++++++++++--------
> >   3 files changed, 31 insertions(+), 9 deletions(-)
> >
> > Index: linux-2.6/drivers/md/dm-core.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/drivers/md/dm-core.h
> > +++ linux-2.6/drivers/md/dm-core.h
> > @@ -214,6 +214,7 @@ struct dm_table {
> >
> >       /* a list of devices used by this table */
> >       struct list_head devices;
> > +     struct rw_semaphore devices_lock;
> >
> >       /* events get handed up using this callback */
> >       void (*event_fn)(void *data);
> > Index: linux-2.6/drivers/md/dm-ioctl.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/drivers/md/dm-ioctl.c
> > +++ linux-2.6/drivers/md/dm-ioctl.c
> > @@ -1630,6 +1630,8 @@ static void retrieve_deps(struct dm_tabl
> >       struct dm_dev_internal *dd;
> >       struct dm_target_deps *deps;
> >
> > +     down_read(&table->devices_lock);
> > +
> >       deps =3D get_result_buffer(param, param_size, &len);
> >
> >       /*
> > @@ -1644,7 +1646,7 @@ static void retrieve_deps(struct dm_tabl
> >       needed =3D struct_size(deps, dev, count);
> >       if (len < needed) {
> >               param->flags |=3D DM_BUFFER_FULL_FLAG;
> > -             return;
> > +             goto out;
> >       }
> >
> >       /*
> > @@ -1656,6 +1658,9 @@ static void retrieve_deps(struct dm_tabl
> >               deps->dev[count++] =3D
> huge_encode_dev(dd->dm_dev->bdev->bd_dev);
> >
> >       param->data_size =3D param->data_start + needed;
> > +
> > +out:
> > +     up_read(&table->devices_lock);
> >   }
> >
> >   static int table_deps(struct file *filp, struct dm_ioctl *param,
> size_t param_size)
> > Index: linux-2.6/drivers/md/dm-table.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/drivers/md/dm-table.c
> > +++ linux-2.6/drivers/md/dm-table.c
> > @@ -135,6 +135,7 @@ int dm_table_create(struct dm_table **re
> >               return -ENOMEM;
> >
> >       INIT_LIST_HEAD(&t->devices);
> > +     init_rwsem(&t->devices_lock);
> >
> >       if (!num_targets)
> >               num_targets =3D KEYS_PER_NODE;
> > @@ -359,16 +360,20 @@ int __ref dm_get_device(struct dm_target
> >       if (dev =3D=3D disk_devt(t->md->disk))
> >               return -EINVAL;
> >
> > +     down_write(&t->devices_lock);
> > +
> >       dd =3D find_device(&t->devices, dev);
> >       if (!dd) {
> >               dd =3D kmalloc(sizeof(*dd), GFP_KERNEL);
> > -             if (!dd)
> > -                     return -ENOMEM;
> > +             if (!dd) {
> > +                     r =3D -ENOMEM;
> > +                     goto unlock_ret_r;
> > +             }
> >
> >               r =3D dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
> >               if (r) {
> >                       kfree(dd);
> > -                     return r;
> > +                     goto unlock_ret_r;
> >               }
> >
> >               refcount_set(&dd->count, 1);
> > @@ -378,12 +383,17 @@ int __ref dm_get_device(struct dm_target
> >       } else if (dd->dm_dev->mode !=3D (mode | dd->dm_dev->mode)) {
> >               r =3D upgrade_mode(dd, mode, t->md);
> >               if (r)
> > -                     return r;
> > +                     goto unlock_ret_r;
> >       }
> >       refcount_inc(&dd->count);
> >   out:
> > +     up_write(&t->devices_lock);
> >       *result =3D dd->dm_dev;
> >       return 0;
> > +
> > +unlock_ret_r:
> > +     up_write(&t->devices_lock);
> > +     return r;
> >   }
> >   EXPORT_SYMBOL(dm_get_device);
> >
> > @@ -419,9 +429,12 @@ static int dm_set_device_limits(struct d
> >   void dm_put_device(struct dm_target *ti, struct dm_dev *d)
> >   {
> >       int found =3D 0;
> > -     struct list_head *devices =3D &ti->table->devices;
> > +     struct dm_table *t =3D ti->table;
> > +     struct list_head *devices =3D &t->devices;
> >       struct dm_dev_internal *dd;
> >
> > +     down_write(&t->devices_lock);
> > +
> >       list_for_each_entry(dd, devices, list) {
> >               if (dd->dm_dev =3D=3D d) {
> >                       found =3D 1;
> > @@ -430,14 +443,17 @@ void dm_put_device(struct dm_target *ti,
> >       }
> >       if (!found) {
> >               DMERR("%s: device %s not in table devices list",
> > -                   dm_device_name(ti->table->md), d->name);
> > -             return;
> > +                   dm_device_name(t->md), d->name);
> > +             goto unlock_ret;
> >       }
> >       if (refcount_dec_and_test(&dd->count)) {
> > -             dm_put_table_device(ti->table->md, d);
> > +             dm_put_table_device(t->md, d);
> >               list_del(&dd->list);
> >               kfree(dd);
> >       }
> > +
> > +unlock_ret:
> > +     up_write(&t->devices_lock);
> >   }
> >   EXPORT_SYMBOL(dm_put_device);
> >
> >
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>

--0000000000001d67840604a82939
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Please reply to Mikulas&#39;s updated patch with your Rev=
iewed-by: and possibly Tested-by:<div dir=3D"auto"><br></div><div dir=3D"au=
to">Thanks,</div><div dir=3D"auto">Mike</div></div><br><div class=3D"gmail_=
quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Sep 5, 2023, 10:16 PM =
Li Lingfeng &lt;<a href=3D"mailto:lilingfeng3@huawei.com">lilingfeng3@huawe=
i.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi<br>
<br>
Thanks to Mikulas for the patch. I have test the patch and it can fix <br>
the problem.<br>
Can this patch be applied to mainline?<br>
<br>
Thanks.<br>
<br>
=E5=9C=A8 2023/8/9 18:44, Mikulas Patocka =E5=86=99=E9=81=93:<br>
&gt;<br>
&gt; On Tue, 8 Aug 2023, Mikulas Patocka wrote:<br>
&gt;<br>
&gt;&gt; On Wed, 2 Aug 2023, Mike Snitzer wrote:<br>
&gt;&gt;<br>
&gt;&gt;&gt; [Cc&#39;ing Mikulas so he can take a look at this too.]<br>
&gt;&gt; Hi<br>
&gt;&gt;<br>
&gt;&gt; I suggest this patch (but it&#39;s only compile-tested, so please =
run some<br>
&gt;&gt; testsuite on it).<br>
&gt;&gt;<br>
&gt;&gt; Mikulas<br>
&gt; I self-nack that patch - it doesn&#39;t work if there are multiple tar=
gets<br>
&gt; calling dm_table_set_devices_mutex in the same table. This is not an i=
ssue<br>
&gt; for multipath, but it will be a problem if other targets use this<br>
&gt; functionality.<br>
&gt;<br>
&gt; Here I&#39;m sending a better patch that doesn&#39;t need any modifica=
tion to the<br>
&gt; targets at all.<br>
&gt;<br>
&gt; Mikulas<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; From: Mikulas Patocka &lt;mpatocka at <a href=3D"http://redhat.com" re=
l=3D"noreferrer noreferrer" target=3D"_blank">redhat.com</a>&gt;<br>
&gt; Subject: [PATCH] dm: fix a race condition in retrieve_deps<br>
&gt;<br>
&gt; There&#39;s a race condition in the multipath target when retrieve_dep=
s races<br>
&gt; with multipath_message calling dm_get_device and dm_put_device.<br>
&gt; retrieve_deps walks the list of open devices without holding any lock =
but<br>
&gt; multipath may add or remove devices to the list while it is running. T=
he<br>
&gt; end result may be memory corruption or use-after-free memory access.<b=
r>
&gt;<br>
&gt; Fix this bug by introducing a new rw semaphore &quot;devices_lock&quot=
;. We grab<br>
&gt; devices_lock for read in retrieve_deps and we grab it for write in<br>
&gt; dm_get_device and dm_put_device.<br>
&gt;<br>
&gt; Signed-off-by: Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.c=
om" target=3D"_blank" rel=3D"noreferrer">mpatocka@redhat.com</a>&gt;<br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank" rel=3D=
"noreferrer">stable@vger.kernel.org</a><br>
&gt;<br>
&gt; ---<br>
&gt;=C2=A0 =C2=A0drivers/md/dm-core.h=C2=A0 |=C2=A0 =C2=A0 1 +<br>
&gt;=C2=A0 =C2=A0drivers/md/dm-ioctl.c |=C2=A0 =C2=A0 7 ++++++-<br>
&gt;=C2=A0 =C2=A0drivers/md/dm-table.c |=C2=A0 =C2=A032 +++++++++++++++++++=
+++++--------<br>
&gt;=C2=A0 =C2=A03 files changed, 31 insertions(+), 9 deletions(-)<br>
&gt;<br>
&gt; Index: linux-2.6/drivers/md/dm-core.h<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; --- linux-2.6.orig/drivers/md/dm-core.h<br>
&gt; +++ linux-2.6/drivers/md/dm-core.h<br>
&gt; @@ -214,6 +214,7 @@ struct dm_table {<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* a list of devices used by this table */<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head devices;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct rw_semaphore devices_lock;<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* events get handed up using this callback =
*/<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0void (*event_fn)(void *data);<br>
&gt; Index: linux-2.6/drivers/md/dm-ioctl.c<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; --- linux-2.6.orig/drivers/md/dm-ioctl.c<br>
&gt; +++ linux-2.6/drivers/md/dm-ioctl.c<br>
&gt; @@ -1630,6 +1630,8 @@ static void retrieve_deps(struct dm_tabl<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_dev_internal *dd;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_target_deps *deps;<br>
&gt;=C2=A0 =C2=A0<br>
&gt; +=C2=A0 =C2=A0 =C2=A0down_read(&amp;table-&gt;devices_lock);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0deps =3D get_result_buffer(param, param_size=
, &amp;len);<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; @@ -1644,7 +1646,7 @@ static void retrieve_deps(struct dm_tabl<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0needed =3D struct_size(deps, dev, count);<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (len &lt; needed) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0param-&gt;flags =
|=3D DM_BUFFER_FULL_FLAG;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; @@ -1656,6 +1658,9 @@ static void retrieve_deps(struct dm_tabl<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0deps-&gt;dev[cou=
nt++] =3D huge_encode_dev(dd-&gt;dm_dev-&gt;bdev-&gt;bd_dev);<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0param-&gt;data_size =3D param-&gt;data_start=
 + needed;<br>
&gt; +<br>
&gt; +out:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0up_read(&amp;table-&gt;devices_lock);<br>
&gt;=C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0static int table_deps(struct file *filp, struct dm_ioctl *=
param, size_t param_size)<br>
&gt; Index: linux-2.6/drivers/md/dm-table.c<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; --- linux-2.6.orig/drivers/md/dm-table.c<br>
&gt; +++ linux-2.6/drivers/md/dm-table.c<br>
&gt; @@ -135,6 +135,7 @@ int dm_table_create(struct dm_table **re<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<=
br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&amp;t-&gt;devices);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0init_rwsem(&amp;t-&gt;devices_lock);<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!num_targets)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0num_targets =3D =
KEYS_PER_NODE;<br>
&gt; @@ -359,16 +360,20 @@ int __ref dm_get_device(struct dm_target<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (dev =3D=3D disk_devt(t-&gt;md-&gt;disk))=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<=
br>
&gt;=C2=A0 =C2=A0<br>
&gt; +=C2=A0 =C2=A0 =C2=A0down_write(&amp;t-&gt;devices_lock);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dd =3D find_device(&amp;t-&gt;devices, dev);=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dd) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd =3D kmalloc(s=
izeof(*dd), GFP_KERNEL);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dd)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -ENOMEM;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dd) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0r =3D -ENOMEM;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto unlock_ret_r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D dm_get_tab=
le_device(t-&gt;md, dev, mode, &amp;dd-&gt;dm_dev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0kfree(dd);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto unlock_ret_r;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0refcount_set(&am=
p;dd-&gt;count, 1);<br>
&gt; @@ -378,12 +383,17 @@ int __ref dm_get_device(struct dm_target<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (dd-&gt;dm_dev-&gt;mode !=3D (mode=
 | dd-&gt;dm_dev-&gt;mode)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D upgrade_mo=
de(dd, mode, t-&gt;md);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto unlock_ret_r;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0refcount_inc(&amp;dd-&gt;count);<br>
&gt;=C2=A0 =C2=A0out:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0up_write(&amp;t-&gt;devices_lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*result =3D dd-&gt;dm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +<br>
&gt; +unlock_ret_r:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0up_write(&amp;t-&gt;devices_lock);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return r;<br>
&gt;=C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0EXPORT_SYMBOL(dm_get_device);<br>
&gt;=C2=A0 =C2=A0<br>
&gt; @@ -419,9 +429,12 @@ static int dm_set_device_limits(struct d<br>
&gt;=C2=A0 =C2=A0void dm_put_device(struct dm_target *ti, struct dm_dev *d)=
<br>
&gt;=C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int found =3D 0;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct list_head *devices =3D &amp;ti-&gt;table-&=
gt;devices;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct dm_table *t =3D ti-&gt;table;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct list_head *devices =3D &amp;t-&gt;devices;=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_dev_internal *dd;<br>
&gt;=C2=A0 =C2=A0<br>
&gt; +=C2=A0 =C2=A0 =C2=A0down_write(&amp;t-&gt;devices_lock);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry(dd, devices, list) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dd-&gt;dm_de=
v =3D=3D d) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0found =3D 1;<br>
&gt; @@ -430,14 +443,17 @@ void dm_put_device(struct dm_target *ti,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!found) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DMERR(&quot;%s: =
device %s not in table devices list&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
dm_device_name(ti-&gt;table-&gt;md), d-&gt;name);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
dm_device_name(t-&gt;md), d-&gt;name);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unlock_ret;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (refcount_dec_and_test(&amp;dd-&gt;count)=
) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_put_table_device(t=
i-&gt;table-&gt;md, d);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_put_table_device(t=
-&gt;md, d);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;dd=
-&gt;list);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(dd);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +unlock_ret:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0up_write(&amp;t-&gt;devices_lock);<br>
&gt;=C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0EXPORT_SYMBOL(dm_put_device);<br>
&gt;=C2=A0 =C2=A0<br>
&gt;<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank" rel=3D"noreferrer"=
>dm-devel@redhat.com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=3D"nor=
eferrer noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/li=
stinfo/dm-devel</a><br>
</blockquote></div>

--0000000000001d67840604a82939--

--===============5647169504002620231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5647169504002620231==--

