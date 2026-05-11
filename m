Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBF437EFF4
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 20:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778530001; cv=none; b=STun63C7iKZeGfocSfTgpmjc7sog++8skFmqmozIPudtYHFbYi6wSIq5Eaj9x/jduF/PoW2hcs5bS1YLEIatikbLuTEWi1UmMq4Ou5MS20iuPaWu2Vsuf/x2iG7xSpK1HPZu4UpalgXi8ZzdGrXszC3CgWVhgAs6o5AEZfQn7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778530001; c=relaxed/simple;
	bh=e+uyrSAyF3tnN3hOKl5BWN22SnTWPnIBx7LAq3jd3kY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=imHUNsdOKCtjdEsKuf3U9IC8lvttVl0a4ULypPcgJmLEV4S+jJVPSlD7lCDRT013qtycoX0LRvdhyxFohpgdQ7P341Xw9Ylb6b1aFseGZfTWAMgg/qIoRn+e6OzoPk293O6aLByzhUD/gLCr93DNDJLPyyiw1/1qmaeIsOKNpQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UjTTStlr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UjTTStlr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778529999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mFkmGgilGaFKPVMjMTEf9xQ1pXgzG8iLoFT7E/b2ATI=;
	b=UjTTStlrVocXC+8CS76joZOv9MdNoNmPTUqd9/7XhhIZZtz/Ql8VaQVt2TKEdTEfZ/PsUa
	20Ch3JWENVITZBqSZxvkv8aV7Hq2ZRx8CoYI5lT/+fzczGv24LoAwajZPzutYxla8FlrRr
	0omovHge/JALeLVeabFW6Y4Mf5+Of+k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-9Je_LTsjMWGETvNqGPVY7A-1; Mon,
 11 May 2026 16:06:36 -0400
X-MC-Unique: 9Je_LTsjMWGETvNqGPVY7A-1
X-Mimecast-MFC-AGG-ID: 9Je_LTsjMWGETvNqGPVY7A_1778529995
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 286C81956062;
	Mon, 11 May 2026 20:06:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C801B1800465;
	Mon, 11 May 2026 20:06:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64BK6XcS3287312
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 16:06:33 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64BK6XBC3287311;
	Mon, 11 May 2026 16:06:33 -0400
Date: Mon, 11 May 2026 16:06:33 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-ioctl: report an error if a device has no table
Message-ID: <agI2yeVYTatsCPdk@redhat.com>
References: <53175a7e-b60f-c081-d5a9-cb3827bfda70@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <53175a7e-b60f-c081-d5a9-cb3827bfda70@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5PxwuAXaqXoYwlmM_Le-hzhcieBdMU9oZy_ddBIuF14_1778529995
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 11, 2026 at 01:04:16PM +0200, Mikulas Patocka wrote:
> When we send a message to a device that has no table, the return code was
> not set. The code would return "2", which is not considered a valid return value.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

