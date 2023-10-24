Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26EDF9CE
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zj3pPBRA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119559;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qf06v0uPyEibN6HVL4g78GrmaDMN+Y6zqErrL4AHRpg=;
	b=Zj3pPBRApfwwtn/8suAzSdXeRzsb1nDLJ6aYZXGrOssmUE7JpYOzkm8/ejYjPl4wg62dNK
	OJsznrChj3TcPzmOXNJokaLCpOs1kTVSMwof+LYtFWacJKy7C8taBpz9B66NzZMJDJXFvC
	wUpyrFb+rnifqNcqUhBADQ6WKePQCpc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-H36s25oSNZOpGOnXbjYSkA-1; Mon, 23 Oct 2023 23:52:38 -0400
X-MC-Unique: H36s25oSNZOpGOnXbjYSkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18FA580F8F7
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11E5C8C0B
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C81171946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 250B61946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14B282166B28; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D1F32166B27
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEB3780F8F3
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:35 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-u_2MX3UxP6akvMf4xiOtfg-1; Mon, 23 Oct 2023 23:52:32 -0400
X-MC-Unique: u_2MX3UxP6akvMf4xiOtfg-1
Received: by mail-qv1-f44.google.com with SMTP id
 6a1803df08f44-66cfef11a25so22055776d6.3
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119551; x=1698724351;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=qf06v0uPyEibN6HVL4g78GrmaDMN+Y6zqErrL4AHRpg=;
 b=Tg599IpN6je3Mcpnx1W/uZEfahwIbah12nXBE8Tn1rn7dQvgkDZL7HUt3Rp8QulBLE
 NBGN8n/bc3j7E3RhxnLEg104KEOhk9e4Iq0rPSJc3shpbWR8sjUgwgaFuPhWLnWmTWR6
 igbnm7JAY0/ayj015o41TNuU+HYjdsqKrzVDsiMFxNqcODL6og0Mdh6XTPfQI2YKaQT5
 uGoTziz5nLd4NIJ77M0HnWCu7EZLpQlF+y+psGzuTEWN/F9nZIvmkkMW30stpoeLsHC+
 QVOMrYVBD5y6SruB0ozwaKP+HbGk+oXt+ClA12jYJeq4BtsCXklSl8ORC2uYYrR6A5CM
 dkTw==
X-Gm-Message-State: AOJu0YzP/lo24YAILbKthrLrbKZTjWSxbZ3wPAjv6bPj9cj8i9LAzGZS
 skWinNZRW80NOGF4GLG2uSOL
X-Google-Smtp-Source: AGHT+IGouATwOYXmK2YwrFbZyHQ9JLHk3FA04Mh6g6shppq2ZH5U7Zjd9ZU0vWlK7itlmdw9ByftTg==
X-Received: by 2002:a0c:aa11:0:b0:66d:63ff:80ab with SMTP id
 d17-20020a0caa11000000b0066d63ff80abmr7949580qvb.7.1698119551260; 
 Mon, 23 Oct 2023 20:52:31 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 lg8-20020a056214548800b0066d05ed3778sm3363056qvb.56.2023.10.23.20.52.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:30 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:30 -0400
Message-ID: <2121d9724f32ea5926574f9aba806b69.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 12/19] dm: add finalize hook to target_type
References: <1696457386-3010-13-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-13-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> This patch adds a target finalize hook.
> 
> The hook is triggered just before activating an inactive table of a
> mapped device. If it returns an error the __bind get cancelled.
> 
> The dm-verity target will use this hook to attach the dm-verity's
> roothash metadata to the block_device struct of the mapped device.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v10:
>   + Not present
> ---
>  drivers/md/dm.c               | 12 ++++++++++++
>  include/linux/device-mapper.h |  7 +++++++
>  2 files changed, 19 insertions(+)

We need an ACK and confirmation from Alasdair and/or Mike that this
is the right approach.

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 64a1f306c96c..3be9cc35306d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2239,6 +2239,18 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>  		goto out;
>  	}
>  
> +	for (unsigned int i = 0; i < t->num_targets; i++) {
> +		struct dm_target *ti = dm_table_get_target(t, i);
> +
> +		if (ti->type->finalize) {
> +			ret = ti->type->finalize(ti);
> +			if (ret) {
> +				old_map = ERR_PTR(ret);
> +				goto out;
> +			}
> +		}
> +	}
> +
>  	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
>  	rcu_assign_pointer(md->map, (void *)t);
>  	md->immutable_target_type = dm_table_get_immutable_target_type(t);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 69d0435c7ebb..4040e84a8ec7 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -160,6 +160,12 @@ typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
>   */
>  typedef size_t (*dm_dax_recovery_write_fn)(struct dm_target *ti, pgoff_t pgoff,
>  		void *addr, size_t bytes, struct iov_iter *i);
> +/*
> + * Returns:
> + *  < 0 : error
> + *  = 0 : success
> + */
> +typedef int (*dm_finalize_fn) (struct dm_target *target);
>  
>  void dm_error(const char *message);
>  
> @@ -209,6 +215,7 @@ struct target_type {
>  	dm_dax_direct_access_fn direct_access;
>  	dm_dax_zero_page_range_fn dax_zero_page_range;
>  	dm_dax_recovery_write_fn dax_recovery_write;
> +	dm_finalize_fn finalize;
>  
>  	/* For internal device-mapper use. */
>  	struct list_head list;
> -- 
> 2.25.1

--
paul-moore.com

