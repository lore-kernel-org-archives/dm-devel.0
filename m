Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1298ECAAD5
	for <dm-devel@archiver.kernel.org>; Thu,  8 Sep 2022 07:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662622377;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WYDoXhKLmvFXbWnX1uc3cmSe9AtxJyJ7IXQzoDIM3L8=;
	b=cr/QKi7YYENev8ItQD1V/g45Jasd8DUWMAYp7DPUa1/kRPNIpS5IaOzEfm7PzYYany8bW7
	auymOij+svZ2mCbSAK0UrVS8X8Qqj3z4d80pbjhFxaEJJbJ1bOG/J/ljkUzTe5H6Si72uf
	7AQJVl1Yi8PTg0vbwT5uYMc+6otZ+sQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-On4C9EBrOhiqQKBWRZ6diQ-1; Thu, 08 Sep 2022 03:32:54 -0400
X-MC-Unique: On4C9EBrOhiqQKBWRZ6diQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44D903C11A02;
	Thu,  8 Sep 2022 07:32:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 097FB40B40C9;
	Thu,  8 Sep 2022 07:32:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EAFB81946A48;
	Thu,  8 Sep 2022 07:32:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 100311946A40
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Sep 2022 20:45:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5276403162; Wed,  7 Sep 2022 20:45:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1718492C3B
 for <dm-devel@redhat.com>; Wed,  7 Sep 2022 20:45:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C875A29AA3B1
 for <dm-devel@redhat.com>; Wed,  7 Sep 2022 20:45:40 +0000 (UTC)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com
 [209.85.218.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-277-EBX3Np4cNX2XXbuh_OaKVQ-1; Wed, 07 Sep 2022 16:45:37 -0400
X-MC-Unique: EBX3Np4cNX2XXbuh_OaKVQ-1
Received: by mail-ej1-f45.google.com with SMTP id bj12so33028314ejb.13
 for <dm-devel@redhat.com>; Wed, 07 Sep 2022 13:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=DdrorN8aXBAdiS3MQc998BdyvYtD7repapkoq0D0eU8=;
 b=PM5LaENt3iZMbHPawCL0WYaLGIr2hbACSYJl+EMJtms0KiBzT091icWn5EzsQEI9/z
 tOpsZRMOe9fHP073zJRZJRmXXWXzh5/ieiztuuKUpox3BtzcHpON5lZYyYlMXolAN3Mz
 7bnqNv+WWxa6ecM1Sk693NRVOxha08rVkZEFslDemT3J1PFmSJAoUgrwLKMGLKGivJVA
 3MlKPuTtU+AZZhKWsG2fuEAoVOLyZ+IyVhQhm6hGTUmQjzTohQfC/1TwFkH7SzvonqOt
 WFhCsXOmmy+daVmHFpmTFY7L155Nw0EP7SmshlM1Jbd85vSWlSRj4PW+UsT3su7Nqwx3
 xz/g==
X-Gm-Message-State: ACgBeo30XJf1nCf+I8kTZsuxfrQa9VrUuI3jbpNDgfpcaeoQe2xoThPZ
 AEeT4YSWPNuqJKsbuls9q2CBuXg+bvhBQnTBFGbXtT4JCOY=
X-Google-Smtp-Source: AA6agR7glr3HucH/VZYjAUKr/udgssJHsGTtsTHekQOvZu/bzF4bOvxYZj2rAX15RMN86ZNXydD1dStdQNu08HWuSQo=
X-Received: by 2002:a17:907:7605:b0:73d:cdf7:d8e0 with SMTP id
 jx5-20020a170907760500b0073dcdf7d8e0mr3617692ejc.430.1662583536042; Wed, 07
 Sep 2022 13:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
In-Reply-To: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Wed, 7 Sep 2022 13:45:24 -0700
Message-ID: <CAG9=OMPAP-BS=vqr3FmPn-antqJJKjkQc3Q0GGJRmbHkUaYmTw@mail.gmail.com>
To: Matthias Kaehlcke <mka@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Thu, 08 Sep 2022 07:32:48 +0000
Subject: Re: [dm-devel] [PATCH] dm: verity-loadpin: Only trust verity
 targets with enforcement
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
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Douglas Anderson <dianders@chromium.org>,
 linux-security-module@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reviewed-by: Sarthak Kukreti <sarthakkukreti@chromium.org>

On Wed, Sep 7, 2022 at 1:31 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> Verity targets can be configured to ignore corrupted data blocks.
> LoadPin must only trust verity targets that are configured to
> perform some kind of enforcement when data corruption is detected,
> like returning an error, restarting the system or triggering a
> panic.
>
> Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
> Reported-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>
>  drivers/md/dm-verity-loadpin.c |  8 ++++++++
>  drivers/md/dm-verity-target.c  | 16 ++++++++++++++++
>  drivers/md/dm-verity.h         |  1 +
>  3 files changed, 25 insertions(+)
>
> diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> index 387ec43aef72..4f78cc55c251 100644
> --- a/drivers/md/dm-verity-loadpin.c
> +++ b/drivers/md/dm-verity-loadpin.c
> @@ -14,6 +14,7 @@ LIST_HEAD(dm_verity_loadpin_trusted_root_digests);
>
>  static bool is_trusted_verity_target(struct dm_target *ti)
>  {
> +       int verity_mode;
>         u8 *root_digest;
>         unsigned int digest_size;
>         struct dm_verity_loadpin_trusted_root_digest *trd;
> @@ -22,6 +23,13 @@ static bool is_trusted_verity_target(struct dm_target *ti)
>         if (!dm_is_verity_target(ti))
>                 return false;
>
> +       verity_mode = dm_verity_get_mode(ti);
> +
> +       if ((verity_mode != DM_VERITY_MODE_EIO) &&
> +           (verity_mode != DM_VERITY_MODE_RESTART) &&
> +           (verity_mode != DM_VERITY_MODE_PANIC))
> +               return false;
> +
>         if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
>                 return false;
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 94b6cb599db4..8a00cc42e498 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1446,6 +1446,22 @@ bool dm_is_verity_target(struct dm_target *ti)
>         return ti->type->module == THIS_MODULE;
>  }
>
> +/*
> + * Get the verity mode (error behavior) of a verity target.
> + *
> + * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
> + * target.
> + */
> +int dm_verity_get_mode(struct dm_target *ti)

nit: It might be cleaner to combine the mode check above into this
function; eg. dm_verity_is_enforcing_mode(struct dm_target *ti).

> +{
> +       struct dm_verity *v = ti->private;
> +
> +       if (!dm_is_verity_target(ti))
> +               return -EINVAL;
> +
> +       return v->mode;
> +}
> +
>  /*
>   * Get the root digest of a verity target.
>   *
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 45455de1b4bc..98f306ec6a33 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -134,6 +134,7 @@ extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
>                                  sector_t block, u8 *digest, bool *is_zero);
>
>  extern bool dm_is_verity_target(struct dm_target *ti);
> +extern int dm_verity_get_mode(struct dm_target *ti);
>  extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
>                                      unsigned int *digest_size);
>
> --
> 2.37.2.789.g6183377224-goog
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

