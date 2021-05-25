Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC6EC47088
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B50B2613F5
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B50B2613F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622026808;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=NgbiI1rtkg+DDgKXd/GkG3skd7ud38LgcHAxlXDixME=;
	b=e+pmCQdY+JO5yxockh2xnBIlgnfX+tV1nlszmycAkglGpzdbj/Ype98Rcu9JvP7IW+9V16
	sqp/Ps2f96v8ZfjIDAPfCrmnfqlyelVOfDfE/R9BB6O6NvTvt5G78TX5x32t5RbeRhJjb1
	7guH9kmMucEplwd4WJiSKvydb4bEopw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-oJquPvKUNHi16CP5Fdh9xA-1; Wed, 26 May 2021 07:00:04 -0400
X-MC-Unique: oJquPvKUNHi16CP5Fdh9xA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 131146D4E0;
	Wed, 26 May 2021 11:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C21875D767;
	Wed, 26 May 2021 10:59:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7970C55342;
	Wed, 26 May 2021 10:59:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P9wiEQ032219 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 05:58:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 31108114B2E4; Tue, 25 May 2021 09:58:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C79F114B2E3
	for <dm-devel@redhat.com>; Tue, 25 May 2021 09:58:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CF308339A2
	for <dm-devel@redhat.com>; Tue, 25 May 2021 09:58:40 +0000 (UTC)
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
	[209.85.222.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-280-fbdT-CjoMbmlIZuFsITAcw-1; Tue, 25 May 2021 05:58:38 -0400
X-MC-Unique: fbdT-CjoMbmlIZuFsITAcw-1
Received: by mail-ua1-f70.google.com with SMTP id
	f15-20020a9f2bcf0000b02901f8fe91b89cso12783675uaj.0
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=OwtdFImRXeDxRcAH5oQ4rqvvLYinzcs+2HBtNfGHdUE=;
	b=JpJd9QKrT/c0KHlaGn4bkTy0IW3M9nLtwuZmOKYoItL5/tv5J7qzDdJdYv5p1pyrrD
	zrm/zofskGcBRAqpI4yt0jn/pOxhXzQUaNgwG8u9fFFleKFh5t05ZLN7KpuMMpvn9mJq
	6sUIydrJZaPP7JEGva+Awb/ALRksffSxgHJfz/W693fGmf8SdNojVClT271Rk84VCtK8
	IBsrROmdWrWNwrifV5ACJKikzVMS4fp2kyrFZAoBbBHYKzaQfS5/U87XVImzKVl1KG8J
	Cfheu+0PKNzkl86ym0Bm3S4ESHHvhTlktgxMfruyLMvUUJ04jBZksqRWv2cQPXPDKCmj
	Tn2g==
X-Gm-Message-State: AOAM533kzrPvwPnOxhZ4aS/a+xHX8oZbQ1T0wIbRgEI2iejmyH43qM0F
	IjAWBUnavBPKfSQl/lvTnU61jFPLhYGeArSBmQHMk1qyXvks52u4jSLQ8z/jILV4oxFujtTOmOc
	Wq4F0R9ZWz/RkBlYzZsJUUKbngK1SbOc=
X-Received: by 2002:ab0:6d8c:: with SMTP id m12mr12705335uah.49.1621936717622; 
	Tue, 25 May 2021 02:58:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrvkaScjifKqQ2lPAc45GVkQCCmwYlAsSeHeeafc33YaxaWwDlnjrnzcGfftzJDtsv0oH38MrYA3c9gpBN0z4=
X-Received: by 2002:ab0:6d8c:: with SMTP id m12mr12705328uah.49.1621936717453; 
	Tue, 25 May 2021 02:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210521105236.43860-1-colin.king@canonical.com>
In-Reply-To: <20210521105236.43860-1-colin.king@canonical.com>
From: Edward Thornber <thornber@redhat.com>
Date: Tue, 25 May 2021 10:58:26 +0100
Message-ID: <CAJ0trDabA+spvnLbQWEhJ-5ok6d_M921aVc-9Wj=MBMyxmUQUg@mail.gmail.com>
To: Colin King <colin.king@canonical.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 26 May 2021 06:59:53 -0400
Cc: Mike Snitzer <snitzer@redhat.com>, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org, "development,
	device-mapper" <dm-devel@redhat.com>,
	Joe Thornber <ejt@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH][next] dm btree: Fix potential read of array
 with negative index i
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7395260071426307960=="

--===============7395260071426307960==
Content-Type: multipart/alternative; boundary="000000000000e46e1905c324917d"

--000000000000e46e1905c324917d
Content-Type: text/plain; charset="UTF-8"

ack

On Fri, May 21, 2021 at 11:52 AM Colin King <colin.king@canonical.com>
wrote:

> From: Colin Ian King <colin.king@canonical.com>
>
> The call to lower_bound can return -1 if the key is not found
> with the bsearch, leading to a negative index access into
> array node->keys[]. Ensure this cannot occur by checking for
> a negative index before reading from the array.
>
> Addresses-Coverity: ("Negative array index read")
> Fixes: d69e2e7e28bd ("dm btree: improve btree residency")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/persistent-data/dm-btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/persistent-data/dm-btree.c
> b/drivers/md/persistent-data/dm-btree.c
> index b8d21b6e2953..266deaea5eea 100644
> --- a/drivers/md/persistent-data/dm-btree.c
> +++ b/drivers/md/persistent-data/dm-btree.c
> @@ -1048,7 +1048,7 @@ static bool contains_key(struct btree_node *node,
> uint64_t key)
>  {
>         int i = lower_bound(node, key);
>
> -       if (le64_to_cpu(node->keys[i]) == key)
> +       if (i >= 0 && le64_to_cpu(node->keys[i]) == key)
>                 return true;
>
>         return false;
> --
> 2.31.1
>
>

--000000000000e46e1905c324917d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">ack</div><br><div class=3D"gmail_quote"><div dir=3D"ltr" c=
lass=3D"gmail_attr">On Fri, May 21, 2021 at 11:52 AM Colin King &lt;<a href=
=3D"mailto:colin.king@canonical.com">colin.king@canonical.com</a>&gt; wrote=
:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">From: Colin Ia=
n King &lt;<a href=3D"mailto:colin.king@canonical.com" target=3D"_blank">co=
lin.king@canonical.com</a>&gt;<br>
<br>
The call to lower_bound can return -1 if the key is not found<br>
with the bsearch, leading to a negative index access into<br>
array node-&gt;keys[]. Ensure this cannot occur by checking for<br>
a negative index before reading from the array.<br>
<br>
Addresses-Coverity: (&quot;Negative array index read&quot;)<br>
Fixes: d69e2e7e28bd (&quot;dm btree: improve btree residency&quot;)<br>
Signed-off-by: Colin Ian King &lt;<a href=3D"mailto:colin.king@canonical.co=
m" target=3D"_blank">colin.king@canonical.com</a>&gt;<br>
---<br>
=C2=A0drivers/md/persistent-data/dm-btree.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-=
data/dm-btree.c<br>
index b8d21b6e2953..266deaea5eea 100644<br>
--- a/drivers/md/persistent-data/dm-btree.c<br>
+++ b/drivers/md/persistent-data/dm-btree.c<br>
@@ -1048,7 +1048,7 @@ static bool contains_key(struct btree_node *node, uin=
t64_t key)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i =3D lower_bound(node, key);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (le64_to_cpu(node-&gt;keys[i]) =3D=3D key)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (i &gt;=3D 0 &amp;&amp; le64_to_cpu(node-&gt=
;keys[i]) =3D=3D key)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;<br>
-- <br>
2.31.1<br>
<br>
</blockquote></div>

--000000000000e46e1905c324917d--

--===============7395260071426307960==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============7395260071426307960==--

