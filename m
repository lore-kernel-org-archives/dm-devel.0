Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77171272E67
	for <dm-devel@lists.linux.dev>; Thu, 14 Aug 2025 20:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755205149; cv=none; b=PxJe+aNFidJeOVNiw9OU0VmxQUcC2DmO++w26dyKUF1gpj6nHBYchFZPwmngwkORP63JJVoBLVYvVBtFWXR8AviQWALe/wAGGHONeKWSP5L7IB0ZXn4PKBnNiGtcevL/9iajwHmwbsxFq92YRrrTHHFV4owZ5QZGTkATV7an1kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755205149; c=relaxed/simple;
	bh=vUEjOT2oAvMrHH/5E5yOrn6zRDyYZecoXypDPzk8pCU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QKUKzsSMH4Mpj8pqSPvs0LPFFAz7KuYm0vvr66osQdjEgJLlgsZh/75rW5whU/Ah8CXa4vE+6gLTpu2DOovrZZHyUYnVPxr9j0sj9n7xX2bMWGm7Iaaa5c2aHCza9Hsso74Ckf8awPIJRCgIIWl+gkwB8MwcOK2BkQBx/bDAqyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iLv8giee; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iLv8giee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755205146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=62fIvaVv+LOEwPbTWPpV74TqporuXyFYSP1o1HSRqcE=;
	b=iLv8gieejLK0Yko115uUFZIOUb5Wy/03YLqO80UEYG/OFre2hTPN8MttYNRlwjZyuQa0GK
	jKNuQNQ3WhcgIp9Ewh2/msMPPvj6v1i29DYEkhc1gT5WP33DzNV03cFdUqlD6K6lQdjFFe
	zxl2T+m4OTidRxPzkk7IKK1DO6BsRuU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-_pN5ggWuOA-CmN8nXY7LLQ-1; Thu,
 14 Aug 2025 16:59:03 -0400
X-MC-Unique: _pN5ggWuOA-CmN8nXY7LLQ-1
X-Mimecast-MFC-AGG-ID: _pN5ggWuOA-CmN8nXY7LLQ_1755205142
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 140E51800345;
	Thu, 14 Aug 2025 20:59:02 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 402E6180047F;
	Thu, 14 Aug 2025 20:58:59 +0000 (UTC)
Date: Thu, 14 Aug 2025 22:58:54 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    cengku@gmail.com
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v5_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <20250812082452.2041767-1-dongsheng.yang@linux.dev>
Message-ID: <95c4ed1c-6dd6-93e7-af22-ffc27c824b95@redhat.com>
References: <20250812082452.2041767-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eS9Frvd9ixoUvz3Ldg8NJ9MqhfJQ_KMCXG1mpJ_O32w_1755205142
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 12 Aug 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 	This is V5 for dm-pcache, please consider merging.

Hi

I merged it to the device mapper git.

(there was a problem with the include file linux/pfn_t.h and the type 
pfn_t not being present on Linux 6.17-rc1, but I fixed it)

Mikulas

