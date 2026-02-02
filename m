Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7A9318BAB
	for <dm-devel@lists.linux.dev>; Mon,  2 Feb 2026 21:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770069341; cv=none; b=IIBAyXGXCXGtWksuJcgV8duvQguhSy8VDDIFm4/7vl0eAJLr7s6+jnlqjocmr/5VawvP9iGQCw1OwHycameVS3FFfX7utM838qEDIsaDhLRmwUl8GL95IatP3bYtu4N+rXog8PSJfsk4LB/vQgXRhtz2Dap1YHN6JBuG1fPZo8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770069341; c=relaxed/simple;
	bh=Cx1IN51Z//JEutchquIgAUYaMUt+mbViI6SVfgHPLE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=XMAaakkuSVwCWFb/Mzy6D+msH3t+V/wnnoSl3PkIlubIL4sG+SDDvSWVPJuVm9TFPdu+3SwBJgKR4YjmoXTceU3AF6pKszrYcNe2+G7HP/TufwcdxI1DMMAk60aZUSMnDLpxgMLcLRSYmQQ8wwCd+nFHqj7sPu5E+sDr0At24rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ffJexGD+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffJexGD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770069339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pxcu79A+IysGBiuPQAYXf8wB2Hl8Zigs5kpTRfD8xII=;
	b=ffJexGD+yRa6fdF4zQNNJyg5OrWJb9WAoyjWJ8k3roMd+0YccBcsmxmdM48WwW9CXa1yNt
	rUKTN2HMWJ8uRuGq+roqQu11VAPZdbkqVFG9qulvzHbYqikqaQ3ExyziureE709ZbxIHTP
	cdBYc81Lf4wBG51UVSJfUKP00EjZUno=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-g-iJvVKCMVSdrkLwdHrZ3w-1; Mon,
 02 Feb 2026 16:55:36 -0500
X-MC-Unique: g-iJvVKCMVSdrkLwdHrZ3w-1
X-Mimecast-MFC-AGG-ID: g-iJvVKCMVSdrkLwdHrZ3w_1770069335
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63DA81956094;
	Mon,  2 Feb 2026 21:55:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DEE419560B2;
	Mon,  2 Feb 2026 21:55:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 612LtX5R701498
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 2 Feb 2026 16:55:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 612LtXPA701497;
	Mon, 2 Feb 2026 16:55:33 -0500
Date: Mon, 2 Feb 2026 16:55:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH multipath-tools] libmpathpersist: fix
 mpath_persistent_reserve_out(3) synopsis
Message-ID: <aYEdVWDJde_lDvLo@redhat.com>
References: <20260202214007.429134-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260202214007.429134-1-stefanha@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -apxxWnTsh7VEMjGU86bVmqIYKBx9w2Euf_QW7YN8OY_1770069335
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 02, 2026 at 04:40:07PM -0500, Stefan Hajnoczi wrote:
> The argument list is copy-pasted from mpath_persistent_reserve_in(3)
> instead of mpath_persistent_reserve_out(3). Use the correct argument
> list from libmpathpersist/mpath_persist.h.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

