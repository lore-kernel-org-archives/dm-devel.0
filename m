Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D5192B7F
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001705; cv=none; b=OF1UN6sbkYbml2ElgOn9J/P3Tg/4bYBTvRofDcl/Cluqwtv6QfcMhe+q7x7xIlKAl15XpMJnAcThhvYwQ+zATCVprwPdraVLddrTzeWfowyHtLykcAQnB9m29+HKtZf+CgMwCSCr+8zuw3rAs88JofsShTEj2irYAvVBlVPmfrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001705; c=relaxed/simple;
	bh=qZ8NMHAIFxilLYbecIbwINZ+7tzF+vw3nTeBTfLz044=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=NJJxcoyQOW8qXO8b27liXy6cQo7Dsz9IgPiDaDvIXgb4qchdqGK5JZbiFNyhZmlngFZ5jO9GWU3Ixfx+qEB1fahPRvObQWs9ubWoATg4X2dHwPSjMLQpiYCQCEm2JRQu1gvI+2bBNe+WhMCTVpFV9I1Y6isXKIAkFHXFEBs04yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NZ/GeUHT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZ/GeUHT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731001701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T0T1kmIGd2e9HfA2r5NNi4wAPfzXgm/Ux7nFN0INrk4=;
	b=NZ/GeUHTGvnsjYvLd9uZj5lP5dT32e0d0bLsWGoZfPmQ+f424Bvxdh+CG50/naCokcLpmQ
	Fbqw20AJP+mWotH51d5yhEWAUSTuSqp1udqeql0rxp9hR+aeilnccY9gQdC1YOuH5g6iga
	OEM1uijekCQ1dA4XEPVO4+k3NFVnW9Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-yFctEabdOGy0E5LE9r1_4g-1; Thu,
 07 Nov 2024 12:48:17 -0500
X-MC-Unique: yFctEabdOGy0E5LE9r1_4g-1
X-Mimecast-MFC-AGG-ID: yFctEabdOGy0E5LE9r1_4g
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BB9D1953951;
	Thu,  7 Nov 2024 17:48:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0773196BC17;
	Thu,  7 Nov 2024 17:48:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A7HmEo6496839
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 7 Nov 2024 12:48:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A7HmEjG496838;
	Thu, 7 Nov 2024 12:48:14 -0500
Date: Thu, 7 Nov 2024 12:48:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
Message-ID: <Zyz9Xm-AAIBwSjqf@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
 <151dbbdc7bfcd4dd0668bf5d9289f725cf92da28.camel@suse.com>
 <ebbf8fe4ef7500d2ab1e6f73a041b8b0ba75e4a4.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ebbf8fe4ef7500d2ab1e6f73a041b8b0ba75e4a4.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QXT8nq-M7pt1Z55WK2FXgRfREudqiEUfaFSoi9LtqzI_1731001696
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2024 at 11:39:38PM +0100, Martin Wilck wrote:
> On Wed, 2024-11-06 at 17:52 +0100, Martin Wilck wrote:
> > 
> > For patch 1-6 of this series: 
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> The series breaks some unit tests. I can fix that.

Oops. I'm going to do some more work on this patchset, so I can fix it
myself.

-Ben

> 
> Martin
> 
> 

