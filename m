Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938E323AE83
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753977907; cv=none; b=SjEoE8smTRI+tNFc6Dsz1uFxPfthEFH8Ii2QJLBb9iNgddT8IXoojF9eWnVxcqiPEib9Ak/ETsz3fwXlythVmbf9fQ8X1FYmQtrveXtiz1PYFBLxMHxTjxORA170ixI2Q3s7ckBCKMwHOj/XduhA/NG8z4CaMZ5hlVAhLtUPa1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753977907; c=relaxed/simple;
	bh=Nc8SWZTAq/UpWPkTfmwHadwssmBRLEUoZ+XZI0u6YBo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e0jR7VaIskccl1OfAr9aCC5DjIA750f8akNKuVwbpK8CJytW+XxrhFzX28Kwq9gv45mKM6Jx/WFFEXbyATQNGde+pfmq6ygOlcOePyc+vrH96xJFYnpcBtmw1xfBTtnfz0ARX6erHCcBfXldrQAE+HvW05QDjOq+SW/cnnxzjqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtMXjyf3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtMXjyf3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753977904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eenJY43nVvSwgrWRGp1MKP/+Tdz8QfA1JfKS9B0ELyk=;
	b=WtMXjyf3ajVuxm53MUr77eMNmPc/stm9V022i/7iKkFmnkd8qhzdoT9Cnx4fUw/3NPPZT4
	Eq1WIqUhGUN5O/Ku65oFEPeJN6AG+gCUk0vd6jkGEGAvOtmwVoHG0zN1bbUUpDVLsim4Gu
	0Dy6ZAtzFqZbccYs1Bxy4EqTeqFoR/A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-McPU3v2kPP2oaRm-GaichA-1; Thu,
 31 Jul 2025 12:05:02 -0400
X-MC-Unique: McPU3v2kPP2oaRm-GaichA-1
X-Mimecast-MFC-AGG-ID: McPU3v2kPP2oaRm-GaichA_1753977901
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 913241956094;
	Thu, 31 Jul 2025 16:05:01 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 808E91800B6D;
	Thu, 31 Jul 2025 16:04:59 +0000 (UTC)
Date: Thu, 31 Jul 2025 18:04:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
In-Reply-To: <72f54b80-2e66-4692-a635-0882e9d11631@oppo.com>
Message-ID: <99a2ab74-55f3-5609-c887-e6c2d5df6228@redhat.com>
References: <20250730061718.1966686-1-weilongping@oppo.com> <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com> <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com> <f66ace1c-3112-a3c9-5c43-efdbbf82d765@redhat.com> <72f54b80-2e66-4692-a635-0882e9d11631@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 86_-EFzd0QgY_wOpg5zScdeFSij0gNvI2QBfQjzM3gw_1753977901
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 30 Jul 2025, LongPing Wei wrote:

> Hi, Mikulas
> 
> For example:
> 
> F2FS/EXT4
> ----
> dm-thin
> ----
> dm-thin-pool
> ----
> pool data
> 
> 1. There is a block of testfile in F2FS/EXT4.
> 2. The offset of this block is n.
> 3. The position in the dm-thin device is m.
> 4. The position in the pool data is x.
> 
> The IV is only be affectted by offset in file and the ino of this file.
> 
> Even if we change m by defrag or change x by COW, IV won't changed.
> 
> The upper layer will only read the decrypted blocks with the same key and
> continous IV in one bio.
> 
> If the upper layer read the full chunk with mixed blocks for GC purpose, key
> and IV won't be passed in. Then the upper layer just get the encrypted blocks.
> 
> LongPing Wei

Yes - so if the IV is calculated from inode and offset, it seems safe to 
support it on dm-thin. So, I accepted the patch (and increased the target 
version).

BTW. what happens if someone uses FALLOC_FL_COLLAPSE_RANGE or 
FALLOC_FL_INSERT_RANGE on a file with inline encryption? That changes file 
offsets of existing data, so it should be disallowed when using inline 
encryption - but I don't see a test for this in the functions 
ext4_collapse_range and ext4_insert_range.

Mikulas

