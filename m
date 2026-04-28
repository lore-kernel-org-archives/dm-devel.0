Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7209F1397
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777349085; cv=none; b=RWNulhgMc8Ubfc9lX7W4E0YgyUF8EXLAzJNMqQyjqMJRyfBnU/DGqEzpC6oqZ4ZjPoF2PaJxT7xVNeQPiLRS4wQu50pdRMVaNukwhBuhizftkbvZ9BDlGk/LGAXAW3+eeBUF8nwL3W6CArEj9XUHkv0y8fLUsJ/5jlfp60lfnHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777349085; c=relaxed/simple;
	bh=NRJOj6cHNJk6t3KP5r/Z/iaxyzr26yazcUupsaiBX1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=lBr8GK70+kF3LmNy7QG0YodB8SnKG/bQd3VTqrcvLZ0VKQXlAPRH28gs/aoneh9IMGqswgU1B/i8ORuqqW4WbV2q8Bu6jKkkskNiH3l22+K38VW4GAwk0X3XRZ7ets44ch6XtaB7Gl22FAyJNYwml/YtK81KV1KZzHB48qIfcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rm/WaTQu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rm/WaTQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777349083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqBU6FkF5AAgSpDNqW7OP3DMnNXZ7v5rr4S5LkfnM5g=;
	b=Rm/WaTQuc8Hjd3vew/tWNjBzsUK7tL3uex8luLIPL1sr+ZuYnJS5U0yR+IpN0TofaDXtZg
	xA+XG/EEg+O/IhMEZlviIqiKk/lDy5DOcF/DgWSx4vq2CP3KXi+Iw3r9Qzn6z/tWmrmHtx
	MvLuH4DXMgc71K6NS/AxxjTZkRFvFow=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-o8spN1qUPziPa6L58-Rgow-1; Tue,
 28 Apr 2026 00:04:37 -0400
X-MC-Unique: o8spN1qUPziPa6L58-Rgow-1
X-Mimecast-MFC-AGG-ID: o8spN1qUPziPa6L58-Rgow_1777349076
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE1321956059;
	Tue, 28 Apr 2026 04:04:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E17A180045E;
	Tue, 28 Apr 2026 04:04:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63S44YtW2754040
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Apr 2026 00:04:34 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63S44YSt2754039;
	Tue, 28 Apr 2026 00:04:34 -0400
Date: Tue, 28 Apr 2026 00:04:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 4/5] libmultipath: TUR checker: use runner threads
Message-ID: <afAx0kWxM4Ruxolh@redhat.com>
References: <20260423204446.472642-1-mwilck@suse.com>
 <20260423204446.472642-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260423204446.472642-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mzy2zBd-2ZjhwUw-5_I-49jJ3ItvAnB3ziWE-JOKrmA_1777349076
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 23, 2026 at 10:44:45PM +0200, Martin Wilck wrote:
> Use the generic runners to simplify the TUR checker code.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

This is a really nice cleanup.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

