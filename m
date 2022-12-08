Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E4CC04FDE
	for <dm-devel@archiver.kernel.org>; Thu,  8 Dec 2022 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670519695;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=0DS4q0VnRfvhAn/W8CgLtaepcE/oxT1w0X9BY6fk+9Q=;
	b=W3cG8gfsss2Cxrg/yq/qVH3kvs6iXkrVeyLXnbvWGuAua2crQXWgDXGijOCUEJgXnn+S3d
	aQY6/gzNNgc8Q+izhoTtBgceuXJOqUwzmdqTVoHek5F1OBK6jU70WJ4g65LPGH71s3klnW
	LcGeErPGUrVlnpOrq1ze5V9r8LPNQS4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-Ird6GJMmNT-4yiwU38zOjA-1; Thu, 08 Dec 2022 12:14:50 -0500
X-MC-Unique: Ird6GJMmNT-4yiwU38zOjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CB593810D2D;
	Thu,  8 Dec 2022 17:14:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E550C40C6EC2;
	Thu,  8 Dec 2022 17:14:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52548194704B;
	Thu,  8 Dec 2022 17:14:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E5DF1946A41
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Dec 2022 16:53:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B7A01401C35; Thu,  8 Dec 2022 16:53:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 13E94140EBF5
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 16:53:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBC961C087AA
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 16:53:22 +0000 (UTC)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-4HDAUWsOMqmpSh2U25XNZQ-1; Thu, 08 Dec 2022 11:53:21 -0500
X-MC-Unique: 4HDAUWsOMqmpSh2U25XNZQ-1
Received: by mail-pj1-f71.google.com with SMTP id
 z4-20020a17090ab10400b002195a146546so4349273pjq.9
 for <dm-devel@redhat.com>; Thu, 08 Dec 2022 08:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=qJB360zHyUcy87sHi/i61uIsDvL5rAG8yxTJu83Q5tc=;
 b=c0Mzg/D8ttKZZ27lL0UvRil6lbYL5ySZuwLXOpKV6TyApAb4PHtPmVIcyQ/SbreiRi
 61TVvis5u5YaLkasFc5EWg7JuEZWacrZXWBt8RQ/icsMl48u47Q2mFfG+OPZibK5Gp1X
 EI6kuvXr4rkWzL7iZNyeZXPFAHkpaDlTyBlF4t/mT/lPFhOLwBvSa0aVpxC31AC6uZ1r
 zlJQSc/bytNnMCNTajp4Rx/gkm49JXeNKnwZGcMhNA/w0wYxzX2VtnZ/TNx890b/jtkT
 hMytuJf6yzF1slDfo5xPFHZJw/D0Png5zGoKzHBJEfySmwAS3bjwe8Pf0yowpUeZv0CU
 FZ2Q==
X-Gm-Message-State: ANoB5pkYyD5oTsncyU1yMEpkUWX0A/0/XtMV8wvKPDkirt+JPjmGy8fG
 mE27f2APMLgFW1H5yfL5hNTqGPpuzEd/C+yC9PZf8XiH3AjsEKOSgkQM6quaNWE9RgOnVVdHBR5
 RX+hNVcg8TxD7LEDHMH4i+kTLlR4JB8U=
X-Received: by 2002:a63:4742:0:b0:478:cd7d:3f55 with SMTP id
 w2-20020a634742000000b00478cd7d3f55mr12615304pgk.624.1670518400379; 
 Thu, 08 Dec 2022 08:53:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4bBKmuHohmEgR5LRdXgjAiKfTnGo3qgiULF3VSF1cfH43kup8tB0AkKaVJsdh4rg1MbUACHuaLzN1HSMzqAKQ=
X-Received: by 2002:a63:4742:0:b0:478:cd7d:3f55 with SMTP id
 w2-20020a634742000000b00478cd7d3f55mr12615297pgk.624.1670518400123; Thu, 08
 Dec 2022 08:53:20 -0800 (PST)
MIME-Version: 1.0
References: <20221208142802.1479048-1-chengzhihao1@huawei.com>
In-Reply-To: <20221208142802.1479048-1-chengzhihao1@huawei.com>
From: Joe Thornber <thornber@redhat.com>
Date: Thu, 8 Dec 2022 16:53:09 +0000
Message-ID: <CAJ0trDYX1vaY81JYuwxL417o1pzk_qo0X52h=LF-k=P=YUp19Q@mail.gmail.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 08 Dec 2022 17:14:29 +0000
Subject: Re: [dm-devel] [PATCH -next] dm thin: Use last transaction's
 pmd->root when commit failed
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
Cc: snitzer@redhat.com, yi.zhang@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com, Martin.Wilck@suse.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2625619848175312110=="

--===============2625619848175312110==
Content-Type: multipart/alternative; boundary="000000000000d4a37905ef53dfa0"

--000000000000d4a37905ef53dfa0
Content-Type: text/plain; charset="UTF-8"

Acked-by: Joe Thornber <ejt@redhat.com>

On Thu, Dec 8, 2022 at 2:07 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:

> Recently we found a softlock up problem in dm thin pool looking up btree
> caused by corrupted metadata:
>  Kernel panic - not syncing: softlockup: hung tasks
>  CPU: 7 PID: 2669225 Comm: kworker/u16:3
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>  Workqueue: dm-thin do_worker [dm_thin_pool]
>  Call Trace:
>    <IRQ>
>    dump_stack+0x9c/0xd3
>    panic+0x35d/0x6b9
>    watchdog_timer_fn.cold+0x16/0x25
>    __run_hrtimer+0xa2/0x2d0
>    </IRQ>
>    RIP: 0010:__relink_lru+0x102/0x220 [dm_bufio]
>    __bufio_new+0x11f/0x4f0 [dm_bufio]
>    new_read+0xa3/0x1e0 [dm_bufio]
>    dm_bm_read_lock+0x33/0xd0 [dm_persistent_data]
>    ro_step+0x63/0x100 [dm_persistent_data]
>    btree_lookup_raw.constprop.0+0x44/0x220 [dm_persistent_data]
>    dm_btree_lookup+0x16f/0x210 [dm_persistent_data]
>    dm_thin_find_block+0x12c/0x210 [dm_thin_pool]
>    __process_bio_read_only+0xc5/0x400 [dm_thin_pool]
>    process_thin_deferred_bios+0x1a4/0x4a0 [dm_thin_pool]
>    process_one_work+0x3c5/0x730
>
> Following process may generate a broken btree mixed with fresh and stale
> nodes, which could let dm thin trapped into an infinite loop while looking
> up data block:
>  Transaction 1: pmd->root = A, A->B->C   // One path in btree
>                 pmd->root = X, X->Y->Z   // Copy-up
>  Transaction 2: X,Z is updated on disk, Y is written failed.
>                 // Commit failed, dm thin becomes read-only.
>                 process_bio_read_only
>                  dm_thin_find_block
>                   __find_block
>                    dm_btree_lookup(pmd->root)
> The pmd->root points to a broken btree, Y may contain stale node pointing
> to any block, for example X, which lets dm thin trapped into a dead loop
> while looking up Z.
>
> Fix it by setting pmd->root in __open_metadata(), so that dm thin will use
> last transaction's pmd->root if commit failed.
>
> Fetch a reproducer in [Link].
>
> Linke: https://bugzilla.kernel.org/show_bug.cgi?id=216790
> Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  drivers/md/dm-thin-metadata.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 1a62226ac34e..26c42ee183ed 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -724,6 +724,15 @@ static int __open_metadata(struct dm_pool_metadata
> *pmd)
>                 goto bad_cleanup_data_sm;
>         }
>
> +       /*
> +        * For pool metadata opening process, root setting is redundant
> +        * because it will be set again in __begin_transaction(). But dm
> +        * pool aborting process really needs to get last transaction's
> +        * root in case accessing broken btree.
> +        */
> +       pmd->root = le64_to_cpu(disk_super->data_mapping_root);
> +       pmd->details_root = le64_to_cpu(disk_super->device_details_root);
> +
>         __setup_btree_details(pmd);
>         dm_bm_unlock(sblock);
>
> --
> 2.31.1
>
>

--000000000000d4a37905ef53dfa0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Acked-by: Joe Thornber &lt;<a href=3D"mailto:ejt@redhat.co=
m">ejt@redhat.com</a>&gt;</div><br><div class=3D"gmail_quote"><div dir=3D"l=
tr" class=3D"gmail_attr">On Thu, Dec 8, 2022 at 2:07 PM Zhihao Cheng &lt;<a=
 href=3D"mailto:chengzhihao1@huawei.com">chengzhihao1@huawei.com</a>&gt; wr=
ote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Recently we=
 found a softlock up problem in dm thin pool looking up btree<br>
caused by corrupted metadata:<br>
=C2=A0Kernel panic - not syncing: softlockup: hung tasks<br>
=C2=A0CPU: 7 PID: 2669225 Comm: kworker/u16:3<br>
=C2=A0Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)<br>
=C2=A0Workqueue: dm-thin do_worker [dm_thin_pool]<br>
=C2=A0Call Trace:<br>
=C2=A0 =C2=A0&lt;IRQ&gt;<br>
=C2=A0 =C2=A0dump_stack+0x9c/0xd3<br>
=C2=A0 =C2=A0panic+0x35d/0x6b9<br>
=C2=A0 =C2=A0watchdog_timer_fn.cold+0x16/0x25<br>
=C2=A0 =C2=A0__run_hrtimer+0xa2/0x2d0<br>
=C2=A0 =C2=A0&lt;/IRQ&gt;<br>
=C2=A0 =C2=A0RIP: 0010:__relink_lru+0x102/0x220 [dm_bufio]<br>
=C2=A0 =C2=A0__bufio_new+0x11f/0x4f0 [dm_bufio]<br>
=C2=A0 =C2=A0new_read+0xa3/0x1e0 [dm_bufio]<br>
=C2=A0 =C2=A0dm_bm_read_lock+0x33/0xd0 [dm_persistent_data]<br>
=C2=A0 =C2=A0ro_step+0x63/0x100 [dm_persistent_data]<br>
=C2=A0 =C2=A0btree_lookup_raw.constprop.0+0x44/0x220 [dm_persistent_data]<b=
r>
=C2=A0 =C2=A0dm_btree_lookup+0x16f/0x210 [dm_persistent_data]<br>
=C2=A0 =C2=A0dm_thin_find_block+0x12c/0x210 [dm_thin_pool]<br>
=C2=A0 =C2=A0__process_bio_read_only+0xc5/0x400 [dm_thin_pool]<br>
=C2=A0 =C2=A0process_thin_deferred_bios+0x1a4/0x4a0 [dm_thin_pool]<br>
=C2=A0 =C2=A0process_one_work+0x3c5/0x730<br>
<br>
Following process may generate a broken btree mixed with fresh and stale<br=
>
nodes, which could let dm thin trapped into an infinite loop while looking<=
br>
up data block:<br>
=C2=A0Transaction 1: pmd-&gt;root =3D A, A-&gt;B-&gt;C=C2=A0 =C2=A0// One p=
ath in btree<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pmd-&gt;root =3D X,=
 X-&gt;Y-&gt;Z=C2=A0 =C2=A0// Copy-up<br>
=C2=A0Transaction 2: X,Z is updated on disk, Y is written failed.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // Commit failed, d=
m thin becomes read-only.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 process_bio_read_on=
ly<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_thin_find_=
block<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __find_block=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_btr=
ee_lookup(pmd-&gt;root)<br>
The pmd-&gt;root points to a broken btree, Y may contain stale node pointin=
g<br>
to any block, for example X, which lets dm thin trapped into a dead loop<br=
>
while looking up Z.<br>
<br>
Fix it by setting pmd-&gt;root in __open_metadata(), so that dm thin will u=
se<br>
last transaction&#39;s pmd-&gt;root if commit failed.<br>
<br>
Fetch a reproducer in [Link].<br>
<br>
Linke: <a href=3D"https://bugzilla.kernel.org/show_bug.cgi?id=3D216790" rel=
=3D"noreferrer" target=3D"_blank">https://bugzilla.kernel.org/show_bug.cgi?=
id=3D216790</a><br>
Fixes: 991d9fa02da0 (&quot;dm: add thin provisioning target&quot;)<br>
Signed-off-by: Zhihao Cheng &lt;<a href=3D"mailto:chengzhihao1@huawei.com" =
target=3D"_blank">chengzhihao1@huawei.com</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-thin-metadata.c | 9 +++++++++<br>
=C2=A01 file changed, 9 insertions(+)<br>
<br>
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c<=
br>
index 1a62226ac34e..26c42ee183ed 100644<br>
--- a/drivers/md/dm-thin-metadata.c<br>
+++ b/drivers/md/dm-thin-metadata.c<br>
@@ -724,6 +724,15 @@ static int __open_metadata(struct dm_pool_metadata *pm=
d)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad_cleanup_da=
ta_sm;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * For pool metadata opening process, root sett=
ing is redundant<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * because it will be set again in __begin_tran=
saction(). But dm<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * pool aborting process really needs to get la=
st transaction&#39;s<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * root in case accessing broken btree.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pmd-&gt;root =3D le64_to_cpu(disk_super-&gt;dat=
a_mapping_root);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pmd-&gt;details_root =3D le64_to_cpu(disk_super=
-&gt;device_details_root);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __setup_btree_details(pmd);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bm_unlock(sblock);<br>
<br>
-- <br>
2.31.1<br>
<br>
</blockquote></div>

--000000000000d4a37905ef53dfa0--

--===============2625619848175312110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2625619848175312110==--

