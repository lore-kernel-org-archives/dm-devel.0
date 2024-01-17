Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C9323762
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515424; cv=none; b=cS4KrAe5cnEILPtZJDa5pBM2KpSzGDA1o1V/MW1CO4UbUKSDT9W33TZFIeQ98sFuab8PWG/q0+zjjobH0AOG+akfY0RwrmqM2ObmUmOGCMyGqLpw756hXN/FObyJwadbx/Jl3JJJntD29HiwG1LOeaosPzjqOPqdLqODthEPDZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515424; c=relaxed/simple;
	bh=/Bwqt2zwkQo2RSJqt7glIplObBcQMf/piC86phvvbqY=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:Message-ID:MIME-Version:
	 Content-Type:X-Scanned-By; b=toNsBE20tfJbkV+udw6hJukjzXo2FhAd37ByI8rxJtrKKftMXEW3mf8ylO/zUQs0nONfoYAq3o5zKGrf165/Gv+/SMWb1DAWuqonVfQ0O1HnRK3MDVgmX222S9WGxiCXmPE5iK3wij1t45ScQdd3t2OapI4FCpFZrjQOzhFKQ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfcZ45Ei; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfcZ45Ei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=01qOeuTtwuT4QtrnMlATRFjFhlWBZPmNAkzB3btIlGQ=;
	b=dfcZ45EibNHxQ8lmLLA0XvL9C0tbPIykyesKCNwcAMqNTdN4zQYmj+hLjF8HinKTBGvM3E
	2ARSHYBp5u0ZZBIyiKM8Rfc6vk1lcGAxpV7U4QYnPZIjv76QPiTD2Sm0TuDP58dK3EbHWZ
	67/1IUq8fjwgqjb7KFP3N7DovfcugI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-WV5SPFb7MeqCa2ruMUcvLQ-1; Wed, 17 Jan 2024 13:16:58 -0500
X-MC-Unique: WV5SPFb7MeqCa2ruMUcvLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22602185A781;
	Wed, 17 Jan 2024 18:16:58 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12EF71BDB1;
	Wed, 17 Jan 2024 18:16:57 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D8FF630C039C; Wed, 17 Jan 2024 18:16:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id D25D13FB50;
	Wed, 17 Jan 2024 19:16:57 +0100 (CET)
Date: Wed, 17 Jan 2024 19:16:57 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/7] MD fixes for the LVM2 testsuite
Message-ID: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Hi

Here I'm sending MD patches that fix the LVM2 testsuite for the kernels 
6.7 and 6.8. The testsuite was broken in the 6.6 -> 6.7 window, there are 
multiple tests that deadlock.

I fixed some of the bugs. And I reverted some patches that claim to be 
fixing bugs but they break the testsuite.

I'd like to ask you - please, next time when you are going to commit 
something into the MD subsystem, download the LVM2 package from 
git://sourceware.org/git/lvm2.git and run the testsuite ("./configure && 
make && make check") to make sure that your bugfix doesn't introduce 
another bug. You can run a specific test with the "T" parameter - for 
example "make check T=shell/integrity-caching.sh"

Mikulas

