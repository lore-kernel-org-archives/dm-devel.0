Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3EF137C35
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730728821; cv=none; b=mHECuckr/AL7fS7hKMpMCU7PPaTSgdR6Ap/9KWVlAJtL8LgRAOAmJOVxwLmgiu85k5SFbmBGmFvNH4w8FWYCzwPLmrwsw5EkbY3tiqziUxtZAnVBZbzbfYGiP43mJVLOfUhmjkaCE0mAxtORe9M9MPhydGdTCatcJi5ahYetw6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730728821; c=relaxed/simple;
	bh=mktRYpcIlBfQiFXYcxcRMYiYhHNlIljGeDObaeJLPAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvaRMujcXHhKHzQhBI/DNn6kDlF67nYphOw6eEyKy+UxSPhrPx/ne8kN64x6Idbaa8Ct8hlQHTAgVjFxyUft0BoBiFKHbcf21tlZOPO8jdyQyHDMsGA4ogFk0GUgAxr57Gr1rbo2SooEh+M6PZDVDWJASpRPEQsAGZWMRDocM9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bWZKT3XG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bWZKT3XG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730728817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Upm+Q3rFIMsQC25oWRvBC9XuOZn4coVvdHARak1tCr4=;
	b=bWZKT3XG/yr6preXmNWhzi92BoQMWs22rfgRvAepAFWbDo1A79M8nXFoMLo49DvIq7fWit
	SbHjvgmtkSDeLtaaCi/YCONmJ0IdRsKXOZ9kSTWzUAPHopFDIpyNzJ9AoFIWnnSmiQX92a
	bfPd8d6b/DuBObDogxB6PwCOfxF/Ca4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-aOZ-LE3kMeWNEvTNm4AedQ-1; Mon,
 04 Nov 2024 09:00:13 -0500
X-MC-Unique: aOZ-LE3kMeWNEvTNm4AedQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 733491955EA2;
	Mon,  4 Nov 2024 14:00:12 +0000 (UTC)
Received: from [10.45.225.236] (unknown [10.45.225.236])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEA9C3000198;
	Mon,  4 Nov 2024 14:00:10 +0000 (UTC)
Message-ID: <3edf87cf-a698-4415-9fd0-b4f7eb40bd61@redhat.com>
Date: Mon, 4 Nov 2024 15:00:08 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] 11-dm-mpath.rules.in: set .DM_NOSCAN if
 MPATH_UNCHANGED is set
To: Martin Wilck <martin.wilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
References: <20241103224349.42582-1-mwilck@suse.com>
 <20241103224349.42582-6-mwilck@suse.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <20241103224349.42582-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 03. 11. 24 v 23:43 Martin Wilck napsal(a):
> When multipath reloads a device or fails or restores a path, the udev
> rules disable LVM scanning, but since .DM_NOSCAN isn't set, blkid is
> still run on the device. When multipath devices that are set to
> queue_if_no_path lose all their paths at close to the same time, udev


Hi


There is worth to be mentioned -   blkid has for a long time 'special' rule 
-built-in   for LVM (and some other devices i.e. crypt...)

So whenever lvm2  uses   LVM-uuid-suffix     with the '-suffix' in it's UUID - 
it's a private DM device which is never even opened by blkid. We would like to 
convert all remaining LV activations to use this logic for every 'private' 
device - since this logic is 'persistent' and survive even complete  removal 
od udevdb. However it takes some time and also the backward compatibility is 
complicating things a lot.

But all I say is - the relaing on any logic of  the udev flags is always kind 
of  problematic - and lvm2 does not depend on this fragile flagging too much.


Regards


Zdenk

