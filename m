Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DF91EB39
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676105; cv=none; b=q6loc9i2c9VEHo2XEy23jW+zZ68V64hvcEKzXp1kOlhcvvC7lMcUnHzNsdi4EA2TZtbkq0hel8bNwcqSJduY1+IB6ww2lYVx373o/0kV94T3mC7OKgWept3J/aFGNjwEatOQCY+S7i9Xus59PsFAmV6zEHxOKrin4CMcwJlgGYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676105; c=relaxed/simple;
	bh=30I2qiGSTGMmtu2zAe2KIRjgD9INrZWgebXxUGcbbfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YXcXhIp0oEzyYrrmUcH6vRZ+QpslSiKn+F6dVV1uObcnLV/L03ocfr2Zwh5kMkkaC7LQs2Q+LWqyXb6WpkkXJPYQcB6CQE6txNHOLY8nO3aP7yCJdeJJhc5PhCHgEBjwxD2DV7oRD4fJYRcHbKCpUqF6Lhmw49lE7aefY9PyYrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mtzsu9GY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mtzsu9GY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749676103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lf9Vy6iZGkI/wdcCdiIdfTum0Rhn8sl9IkVuphESuls=;
	b=Mtzsu9GYlGu2UQcR10Z89aE/qfniv9evvGpG9ZBKtUgml/Bk1E59v5Vid6bl8iRUIfTkVA
	B9Oeugm6Q7o9z9MkAYgjsh//wumIjIMXPEpfu0en0kKyf/kyJywWXTFCGv23GmKUrq8790
	38A8eFWDap9W4dg2J9/QKXnZ8CAw6t8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-sR9DSUH7PlWPRH9-4sKsVA-1; Wed,
 11 Jun 2025 17:08:19 -0400
X-MC-Unique: sR9DSUH7PlWPRH9-4sKsVA-1
X-Mimecast-MFC-AGG-ID: sR9DSUH7PlWPRH9-4sKsVA_1749676098
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A66DF180047F;
	Wed, 11 Jun 2025 21:08:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35CE619560AF;
	Wed, 11 Jun 2025 21:08:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 55BL8GQ02750163
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Jun 2025 17:08:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 55BL8GKO2750162;
	Wed, 11 Jun 2025 17:08:16 -0400
Date: Wed, 11 Jun 2025 17:08:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-flakey: Fix corrupt_bio_byte setup checks
Message-ID: <aEnwQMM2Xmey2xLS@redhat.com>
References: <20250611191221.3011309-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250611191221.3011309-1-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XPWgCYzAHCv4H3p_Vwd8FhoHihnQ4s1SYb2Bv3Yc9cQ_1749676098
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 11, 2025 at 03:12:20PM -0400, Kent Overstreet wrote:
> Fix the error_reads mode - it's incompatible with corrupt_bio_byte, but
> that's only enabled if corrupt_bio_byte is nonzero.
> 
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@lists.linux.dev
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

