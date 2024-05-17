Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83EA387
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 00:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905659; cv=none; b=gsZ6EKauLFUa+k+vwKFUcKFQeE8xwOncsHyPV+O0p1xAHpsnL8l01HabacSDZxflznKk4U/7NHklPDBF+uTvknxFNLIyWxaK9KN2pY3vKuNGOF/DlJ4iTcOOTvGb1IvEI8gHAxTAqwinElzeW3UHjcPfd21LQIZuIrmrPzcdZL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905659; c=relaxed/simple;
	bh=8qFUR2iOKvNNFBqKCBKdFwMl9uNt7r1Sbz/DRwDBBSw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=ZPo9B5pGQkOFUYfEebP1+7D01Tz7AxKkNfz3QHtxFDxQSOJ4aAt/S0SEMRGcIslyVbLBEuo/Q8vEst7yyukPaBc8CjOEUenEVAga9zaQADz6Mlogpqe03DjGdrlssiuzkNi5MddxA6wSik+x1+0ou5JvhuA2LAgmW3c3Vc/rS3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id E2CA084;
	Thu, 16 May 2024 17:20:20 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id k_2nIwCVhlUB; Thu, 16 May 2024 17:20:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 9044440;
	Thu, 16 May 2024 17:20:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9044440
Date: Thu, 16 May 2024 17:18:17 -0700 (PDT)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: dm-devel@lists.linux.dev
cc: linux-block@vger.kernel.org
Subject: Kernel namespaces for device mapper targets and block devices?
Message-ID: <61c1fff7-b5ff-dfdd-62c1-506e055ae5e@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hello everyone,

Is there any work being done on namespaces for device-mapper targets, or 
for the block layer in general? 

For example, namespaces could make `dmsetup table` or `losetup -a` see 
only devices mapped in that name space. I found this article from to 2013, 
but it is quite old:
	https://lwn.net/Articles/564854/

If you know any more recent work on the topic that I would be interested. 
Thank you for help!

--
Eric Wheeler
