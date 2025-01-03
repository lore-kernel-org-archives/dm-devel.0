Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3A71FBCB5
	for <dm-devel@lists.linux.dev>; Fri,  3 Jan 2025 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735921576; cv=none; b=mVaG1KgD2fVKW658FwLNWhfBPBJZUfOQm/qjmeG6+mgvyWBM5eY9plTii14/97WQKYHRa9i5lCbodbuneTBfDiolhTt5Jxp4M2y83SnLnp5FNTi9mWzSn86uBovFLuJ+zyD14h7hnAQ01UZpg0oyc/+pSIHX/JLjs8MChTQnmOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735921576; c=relaxed/simple;
	bh=Q3w2dL/c0bmN+PhHzf0legAJ8tIT85/iB+H0N1YmgnY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CmNW3qHEfKFLamZkf8SBrk2Fc9fzthxFEd5uaKVOgkGR8S2QVRHXDXIVugb9kyWO3M6jliEyXIep2cyW4eMlaNX+TzIdbEN2T/8maCp9sqA+lvNalVfROL0QqecJM0HdF5QThJQJuSF3NNoXROhIdWUaiPdai68aWn9VhohMw5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h1rHbC6T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1rHbC6T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735921573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BxyR2TWPRX70PM14Fh5D3B0xcHWgh50t9/PWS3/mk98=;
	b=h1rHbC6TtFcrjFTIPVY7C+QzupUn4ZI49qRqgGAB6khoZDacNejDT9rlpfjwyPkBwmNnwD
	b+55ZC07YeUQDnPqHgpyR1J6ejlr/RcH47HSNjK61XrsNt2l5mw0MY4vy1dEFcmze9nNyv
	E2M9cTE0ulEo0hL/j2S1Bbo13YWzZ8Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-vladBGe6MPa6jL5bke46uQ-1; Fri,
 03 Jan 2025 11:26:09 -0500
X-MC-Unique: vladBGe6MPa6jL5bke46uQ-1
X-Mimecast-MFC-AGG-ID: vladBGe6MPa6jL5bke46uQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9B2A1955F45;
	Fri,  3 Jan 2025 16:26:07 +0000 (UTC)
Received: from [10.45.224.27] (unknown [10.45.224.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04F873000197;
	Fri,  3 Jan 2025 16:26:04 +0000 (UTC)
Date: Fri, 3 Jan 2025 17:25:59 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, Yu Kuai <yukuai1@huaweicloud.com>, 
    lkml <linux-kernel@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [discussion] proposal to bypass zero data for dm-crypt
In-Reply-To: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
Message-ID: <3181bbd4-40df-eecf-c9b2-45b09018b8af@redhat.com>
References: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Milan, what do you think about this from a cryptographic point of view? 
Does it make sense to add an option that would detect zero data and skip 
decryption in this case?

Mikulas

On Sat, 21 Dec 2024, Yu Kuai wrote:

> Background
> 
> We provide virtual machines for customers to use, which include an important
> feature: in the initial state, the disks in the virtual machine do not occupy
> actual storage space, and the data read by users is all zeros until the user
> writes data for the first time. This can save a large amount of storage.
> 
> Problem
> 
> However, after introducing dm-crypt, this feature has failed. Because we
> expect the data read by users in the initial state to be zero, we have to
> write all zeros from dm-crypt.
> 
> Hence we'd like to propose to bypass zero data for dm-crypt, for
> example:
> 
> before:
> zero data -> encrypted zero data
> decrypted zero data -> zero data
> others
> 
> after:
> zero data -> zero data
> decrypted zero data -> encrypted zero data
> others(doesn't change)
> 
> We'd like to hear from the community for suggestions first, before we
> start. :)
> 
> Thanks,
> Kuai
> 

