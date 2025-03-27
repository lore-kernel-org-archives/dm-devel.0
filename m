Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862231C7019
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 19:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104356; cv=none; b=flvMlfP/BEDyIfi9VSZvW/5fuvdJI4286Q9jY+VYXkEk0/mHiveo8fVRmkKsiww+P+4sO/caW4bom+tRgbxesQmtAd5AjDcj3bHMeP8Cb54Jg6KFaLjY+j1wppEyfG1O4ezPAyMyzAInpjIBNr+itclOTnZPMgn8YdTWLrDkMyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104356; c=relaxed/simple;
	bh=jbUrWmJOOivjK++FyJY4ffvi/bIChxtLEJWEMdlKwhs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rnEnbrWm16opzy7qksGePwF1kFcIc0Qa+kC4wAg/goI8AfLeUoW7CZ53wJ2Cwp7tshTNAg7bsv+7Dpy6hNDvb/3CYoY7YJ8hbv89F32HAMISLeHzdna+dtynf8D9Y0E0qvFKeu9D7HWh4OJ1691Dz/B3bFRCt8Q0PSTZ01J+Q9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JkzDSGdM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JkzDSGdM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743104353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=skwapfZN6+QPDu20TdIsdgn/96cVcHrFRu6X5oAD1NM=;
	b=JkzDSGdMKOpMxYd3hiQqhY3TTfj5Yp8K6MC7zHO7jzx5B9ujaOdRITBDE8iE6Jev4E/H8d
	KXhNbmI41/cVrWoiul7dyYbVjAa9AIAKx6vVXz5DUP73tZTUGRGb020g3d1WLM4IWWXu5Z
	zu8HeOSWgA0676Mo4DtwN1Q3N29gtcQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-WIHScWMkNi2ZIUPsRfeGVQ-1; Thu,
 27 Mar 2025 15:39:08 -0400
X-MC-Unique: WIHScWMkNi2ZIUPsRfeGVQ-1
X-Mimecast-MFC-AGG-ID: WIHScWMkNi2ZIUPsRfeGVQ_1743104347
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D65F180AF4C;
	Thu, 27 Mar 2025 19:39:07 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BFED1801747;
	Thu, 27 Mar 2025 19:39:04 +0000 (UTC)
Date: Thu, 27 Mar 2025 20:39:00 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com, 
    dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <a5553d19-d773-b004-e848-6cd2f2839d6f@redhat.com>
Message-ID: <21f64cbe-20a7-ffd8-b665-b03d37284d0e@redhat.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com> <20250326013049.1292617-1-weilongping@oppo.com> <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com> <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com> <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com> <20250326204845.GB6625@sol.localdomain> <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com> <20250327170524.GF1425@sol.localdomain> <6421ae31-5b4a-f35a-724c-1970ec3ab06b@redhat.com> <20250327173510.GA3371050@google.com>
 <a5553d19-d773-b004-e848-6cd2f2839d6f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yw572AabrpJOd3Ch_3q3v8cqfZ9-huY-qPlPO13wid8_1743104347
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 27 Mar 2025, Mikulas Patocka wrote:

> There is also a bug that prefetch may race with suspend, sending I/Os even 
> when the dm-verity device is suspended - but that is fixable by adding 
> flush_workqueue to the postsuspend hook.
> 
> Mikulas

flush_workqueue won't make it - it seems that I'll have to add a new 
function dm_bufio_quisce that will wait until all prefetches terminate and 
use this function in the postsuspend hook of targets that do prefetch.

Mikulas

