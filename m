Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B467F514
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HuKfC4Gg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119556;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GnPZt7wTu5bHl+yZIdMyk9dSEtxPVy94lr+8pKkfEn4=;
	b=HuKfC4Gg904qWbW3iSmBv75PM1Y2PMSrw14bftPSvQKmAoMaa2vmD5GRD/rIarz+wxd7dc
	yIV379K9XUzjP8D6XqthKPInnx16CN9UdHoGtU1z4XqRy0iBciKGM8dBATSGXxBzBzyUyB
	Lh4ES+ohOIO6aMjV3Wlim+N23er8CD8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-DPR9q69QMw6d_zAphWY85g-1; Mon,
 23 Oct 2023 23:52:35 -0400
X-MC-Unique: DPR9q69QMw6d_zAphWY85g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F25B61C05198
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EAAC61121318
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B89211946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D4CE5194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AFA60492BE1; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A820F492BD9
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 842323C0F42A
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
 [209.85.222.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-viYbBMYdPZC9FZGHs1dzdw-1; Mon, 23 Oct 2023 23:52:26 -0400
X-MC-Unique: viYbBMYdPZC9FZGHs1dzdw-1
Received: by mail-qk1-f182.google.com with SMTP id
 af79cd13be357-7741b18a06aso313386585a.1
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119546; x=1698724346;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=GnPZt7wTu5bHl+yZIdMyk9dSEtxPVy94lr+8pKkfEn4=;
 b=oAhozPHVdi268wCU/9k0DSen7ReH49nqY8qCIG9FEe4Tc5jHRHm4c3JKf3PyZDXsC9
 mC8HMFuLfhtNEDvqms093Se+pOhlB6rfzSFMLwwOLLk8quftjMfplKjEk0YFxm0KqJtK
 9SOu/HIXSZcfx4zEBCIeoBo1kBskuLn82k6MEXw5YecUeASSZT/kOJXDFcmjoj4t7h/z
 70cXR2e39qUquIQI5m4a0XoC7untCYSnu740TzaKpCYadP113WeOb9fLuOYk4rMKnxkm
 S6f+PNN/ViVeHwnANU0JAUTLUKxErI5t0gVOSoXHMppXkB8VBjgrIqeZ0TVqI8d3O62Q
 pmhA==
X-Gm-Message-State: AOJu0YzNgkxV1H+Hpq7tEzEu+z6R+c02AoXBKaYip5lQaOgkH6sAffqC
 tekMMyDXoQBrOlGCZNBB2FAi
X-Google-Smtp-Source: AGHT+IFvSV+EXgEeBKXX2Mm2c4Pu+xlgfjLQsVDGRnKVVxJUbzV3yBw9uUXEzF2i2rsqjzOaeFEfJQ==
X-Received: by 2002:a05:620a:4049:b0:778:9232:a564 with SMTP id
 i9-20020a05620a404900b007789232a564mr13553158qko.47.1698119546060; 
 Mon, 23 Oct 2023 20:52:26 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 w12-20020ae9e50c000000b0077407e3d68asm3162408qkf.111.2023.10.23.20.52.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:25 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:25 -0400
Message-ID: <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 5/19] ipe: introduce 'boot_verified' as a trust
 provider
References: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
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
> IPE is designed to provide system level trust guarantees, this usually
> implies that trust starts from bootup with a hardware root of trust,
> which validates the bootloader. After this, the bootloader verifies the
> kernel and the initramfs.
> 
> As there's no currently supported integrity method for initramfs, and
> it's typically already verified by the bootloader, introduce a property
> that causes the first superblock to have an execution to be "pinned",
> which is typically initramfs.
> 
> When the "pinned" device is unmounted, it will be "unpinned" and
> `boot_verified` property will always evaluate to false afterward.
> 
> We use a pointer with a spin_lock to "pin" the device instead of rcu
> because rcu synchronization may sleep, which is not allowed when
> unmounting a device.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   +No Changes
> 
> v3:
>   + Remove useless caching system
>   + Move ipe_load_properties to this match
>   + Minor changes from checkpatch --strict warnings
> 
> v4:
>   + Remove comments from headers that was missed previously.
>   + Grammatical corrections.
> 
> v5:
>   + No significant changes
> 
> v6:
>   + No changes
> 
> v7:
>   + Reword and refactor patch 04/12 to [09/16], based on changes in the underlying system.
>   + Add common audit function for boolean values
>   + Use common audit function as implementation.
> 
> v8:
>   + No changes
> 
> v9:
>   + No changes
> 
> v10:
>   + Replace struct file with struct super_block
> 
> v11:
>   + Fix code style issues
> ---
>  security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
>  security/ipe/eval.h          |  2 +
>  security/ipe/hooks.c         | 12 ++++++
>  security/ipe/hooks.h         |  2 +
>  security/ipe/ipe.c           |  1 +
>  security/ipe/policy.h        |  2 +
>  security/ipe/policy_parser.c | 35 +++++++++++++++++-
>  7 files changed, 124 insertions(+), 2 deletions(-)
> 
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 8a8bcc5c7d7f..bdac4abc0ddb 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -9,6 +9,7 @@
>  #include <linux/file.h>
>  #include <linux/sched.h>
>  #include <linux/rcupdate.h>
> +#include <linux/spinlock.h>
>  
>  #include "ipe.h"
>  #include "eval.h"
> @@ -16,6 +17,44 @@
>  
>  struct ipe_policy __rcu *ipe_active_policy;
>  
> +static const struct super_block *pinned_sb;
> +static DEFINE_SPINLOCK(pin_lock);
> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> +
> +/**
> + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
> + * @sb: Supplies a super_block structure to be pinned.
> + */
> +static void pin_sb(const struct super_block *sb)
> +{
> +	if (!sb)
> +		return;
> +	spin_lock(&pin_lock);
> +	if (!pinned_sb)
> +		pinned_sb = sb;
> +	spin_unlock(&pin_lock);
> +}
> +
> +/**
> + * from_pinned - Determine whether @sb is the pinned super_block.
> + * @sb: Supplies a super_block to check against the pinned super_block.
> + *
> + * Return:
> + * * true	- @sb is the pinned super_block
> + * * false	- @sb is not the pinned super_block
> + */
> +static bool from_pinned(const struct super_block *sb)
> +{
> +	bool rv;
> +
> +	if (!sb)
> +		return false;
> +	spin_lock(&pin_lock);
> +	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == sb;
> +	spin_unlock(&pin_lock);

It's okay for an initial version, but I still think you need to get
away from this spinlock in from_pinned() as quickly as possible.
Maybe I'm wrong, but this looks like a major source of lock contention.

I understand the issue around RCU and the potential for matching on
a reused buffer/address, but if you modified IPE to have its own LSM
security blob in super_block::security you could mark the superblock
when it was mounted and do a lockless lookup here in from_pinned().

> +	return rv;
> +}

--
paul-moore.com

