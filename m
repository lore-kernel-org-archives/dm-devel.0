Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1BC17D9
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 01:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705454357; cv=none; b=iBrdDLpE5QYlx1Syuf/eszLyKRP9aU7XnWvZhaxnqDN1EhXjXbPrKx5Jd96DsF2OGarQt/nIShhMgdl8Ft6izOCH0UDdrB0JXfdc3xh3Rxb6UXvbTxlKX+pK7cCfUgWm+yu7btTVctg9iFyF2yUv/Sj5WogUI2y0vRdHq7i1x1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705454357; c=relaxed/simple;
	bh=RhQes8m29rwtwWomHm0uG8YLsKHGiQX4uX0J0qc5LrA=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-Originator:
	 Content-Transfer-Encoding:Content-Type; b=IoqthoYnUNjAJMq3r7nNJ17k6pCB0AwAFKW6HVD+wBax0smpKdEK19rkPKFAWirecKmTEJZ0oDcCCLm99zq/pUP4sXTfLFdWMiWvNieafWKx+B5OcCsqzXtd+TS193TVyPrGXbZnWDeWoDtGf8sk6g/b8hf6J55ICdOj7IbxUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hlGpJBO7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hlGpJBO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705454354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=asEXM+z+LZgbu/RIzDwydwJw1S3YMIHKs9Nc0fAD5Mw=;
	b=hlGpJBO7rnEnpgI/HbsPIzXEvFWH3SNdCG+Cbhr5I4VanP/qtvPDFrOwazPs7tkhgMw2P6
	OmmJnNILTW2CAcYJfEOinUtL2RPrDBz30RMyHGlGm9VrXKy+Z3viqa7yKNfVQxmrwLeXFg
	qHMQET2W2ybuhkmXqskxRedKDlUvzkA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-Gh1EZbgSPL29GAzkmdjkqA-1; Tue,
 16 Jan 2024 20:19:13 -0500
X-MC-Unique: Gh1EZbgSPL29GAzkmdjkqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ADDA38143A1;
	Wed, 17 Jan 2024 01:19:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F309D2166B32;
	Wed, 17 Jan 2024 01:19:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40H1JCsX018721
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 20:19:12 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40H1JChn018720;
	Tue, 16 Jan 2024 20:19:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: device-mapper development <dm-devel@lists.linux.dev>
Cc: Martin Wilck <Martin.Wilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v2 0/2] Fix auto resize code
Date: Tue, 16 Jan 2024 20:19:10 -0500
Message-ID: <20240117011912.18710-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Fix two bugs in my auto-resize feature.

changes from v1 (based on suggestions from Martin Wilck):
0002: Explicitly set the default values of auto_resize

Benjamin Marzinski (2):
  multipathd: fix null pointer dereference in uev_update_path
  multipathd: fix auto-resize configuration

 libmultipath/config.c  | 1 +
 libmultipath/structs.h | 1 -
 multipathd/main.c      | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.0

