Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE3DEB64DC
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971630;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jpn7MqdpV3p0E8OBRhRCMqdDNNokITGh1M9jS2C351M=;
	b=CoDa5VS8cDrPGcQ4S0UEADG3IlvnmlznZWLCQDk2tmFHF6kT8fSCDgOrXhWgjgSH8AIGY5
	rCuEGMmKS/deKVTFOr6Fotq3vy/187SadxIQC//6aG3CPMYlYp9aOXNZXP3kvv7ucpugXX
	ULfu1kOr+1cVLOQLOimDolKM/ay/fnY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-emcZPHy2OG-cVDugCqES9w-1; Mon, 10 Jul 2023 02:47:07 -0400
X-MC-Unique: emcZPHy2OG-cVDugCqES9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B5DF1C31C5F;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54D05C51488;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECC1219451FF;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6AFAA1949754
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 05:26:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56CB714682FB; Fri, 23 Jun 2023 05:26:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E89E1400C35
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 05:26:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33F2B3C1CAF3
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 05:26:10 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-F9JTYVP-N6u11yVCkF6EvA-1; Fri, 23 Jun 2023 01:26:03 -0400
X-MC-Unique: F9JTYVP-N6u11yVCkF6EvA-1
Received: by mail-pl1-f170.google.com with SMTP id
 d9443c01a7336-1b512309c86so2230575ad.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 22:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687497961; x=1690089961;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=I74A3FzNlMiWSwenHJ0qW6K9Kk3RrnXa52gDQFbNI94=;
 b=USpldR5VlnMfHouii+yPGCfEW4nMGZqmEtlHrz8ZCuC/VS7EBkFYxh4PxaQi95Q7G7
 XDsidqzI3WxVmWS3ymyDoRmpuQVxxn7Q/TXq5lp91IMPmNTrEfCtZn8Zq+3KLlQrT/UM
 CeJh7rouhTi6TKmYL3Cv5FAn72ap5/vPhC9XnUbSx055e0a8tPQCgdmOwXck7vw8NiKz
 hetSHWoq2tyauMs9faUH2cY9VsoZK4DegDQKHWm5JE/bO0uqMMdy7yTb9RmWh6UbB49b
 kJ+9TweouLm3PsMPlqe9Q8GGcoph+Pc+rgOePDy6rJM/8n96m8S136eQRrM9R+Khzk6J
 5kMg==
X-Gm-Message-State: AC+VfDxHxLErS6fEPVf/Ri+6J/ds4FtuLHaq+mAQ4oo2dbEDGGf8xFy0
 wOssqKaArSAna7xv8OWS9RX/6w==
X-Google-Smtp-Source: ACHHUZ5sPbLx4vVXAJjIGembGjCJJyMTydKicDo1snyQX4c1P9pglVj/z3vqORh1yZ2I9l32bGJbWQ==
X-Received: by 2002:a17:902:ecc6:b0:1ae:8fa:cd4c with SMTP id
 a6-20020a170902ecc600b001ae08facd4cmr41235916plh.7.1687497961344; 
 Thu, 22 Jun 2023 22:26:01 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:3383:b451:fa2:1538])
 by smtp.gmail.com with ESMTPSA id
 c1-20020a170902d48100b00192aa53a7d5sm6288753plg.8.2023.06.22.22.25.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 22:26:00 -0700 (PDT)
Date: Fri, 23 Jun 2023 14:25:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Message-ID: <20230623052554.GA11471@google.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-30-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
In-Reply-To: <20230622085335.77010-30-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 29/29] mm: shrinker: move shrinker-related
 code into a separate file
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On (23/06/22 16:53), Qi Zheng wrote:
> +/*
> + * Remove one
> + */
> +void unregister_shrinker(struct shrinker *shrinker)
> +{
> +	struct dentry *debugfs_entry;
> +	int debugfs_id;
> +
> +	if (!(shrinker->flags & SHRINKER_REGISTERED))
> +		return;
> +
> +	shrinker_put(shrinker);
> +	wait_for_completion(&shrinker->completion_wait);
> +
> +	mutex_lock(&shrinker_mutex);
> +	list_del_rcu(&shrinker->list);

Should this function wait for RCU grace period(s) before it goes
touching shrinker fields?

> +	shrinker->flags &= ~SHRINKER_REGISTERED;
> +	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
> +		unregister_memcg_shrinker(shrinker);
> +	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
> +	mutex_unlock(&shrinker_mutex);
> +
> +	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
> +
> +	kfree(shrinker->nr_deferred);
> +	shrinker->nr_deferred = NULL;
> +}
> +EXPORT_SYMBOL(unregister_shrinker);

[..]

> +void shrinker_free(struct shrinker *shrinker)
> +{
> +	kfree(shrinker);
> +}
> +EXPORT_SYMBOL(shrinker_free);
> +
> +void unregister_and_free_shrinker(struct shrinker *shrinker)
> +{
> +	unregister_shrinker(shrinker);
> +	kfree_rcu(shrinker, rcu);
> +}

Seems like this

	unregister_shrinker();
	shrinker_free();

is not exact equivalent of this

	unregister_and_free_shrinker();

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

