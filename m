Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07417236A87
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737058963; cv=none; b=QtHN53Rn9mtybe9zwTjjldvwZYz+6eV/7KqJfQtttimcvlMEUc60K+AaabPUcvwsQKuo6JjHxQKfHqqxRyIc5NzlslO834eb8K4LsYgZkOFefTKErIM/H+ydkG5Oo1cHxqoqJE/k+N7FNIz+BBMGrNLV/2ZDArpOYSw17RYl7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737058963; c=relaxed/simple;
	bh=+qw+YGG/MDwB1O40aNxrX58/QCWxNzPAx9SZMRvnj5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=jk11KNNG0tnpfDJaeItBAzOwShlLyJtVbSJWk/AAbTHAQKRxcR5raDLFkwgp1b9YBw4HTlUcZmycnIPtwWU+IsB4OODGPTAWgCupr4W2lNYcndWSLV6xC6zyyugFT8C+TDyUdj6xRfIS/YykKwxkSjPbyHT4Oc4vXFOvFqWihnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XHawY69l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XHawY69l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737058961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gYIDq1g2Dtzi+K2G3oGPDw17U9IRn6nDIiHo2ZySnJk=;
	b=XHawY69l4JpDMj2IyvLfR/acvwVHz3RSqrp7Ky2MfDhsS/9HFJd6pmOarxKLAf6sLkxl+l
	cuAQQnlwXdrYr+PnEPwn8q2jPaw8rCILlL7XGp4zyai1JUuewCix3Pv1YwMQF9syY2YMAQ
	1YdYJqRIBHIzzCwyFTjQ5XWez+r2xpE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-f_j5eUcnMXe9luFibKgXMQ-1; Thu,
 16 Jan 2025 15:22:38 -0500
X-MC-Unique: f_j5eUcnMXe9luFibKgXMQ-1
X-Mimecast-MFC-AGG-ID: f_j5eUcnMXe9luFibKgXMQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16A5719560B1;
	Thu, 16 Jan 2025 20:22:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95EED19560A3;
	Thu, 16 Jan 2025 20:22:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50GKMZfH2753971
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 15:22:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50GKMYHR2753970;
	Thu, 16 Jan 2025 15:22:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/2] multipath: set rport port_state on NVMe FPIN events
Date: Thu, 16 Jan 2025 15:22:32 -0500
Message-ID: <20250116202234.2753960-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FXw7LJpeP2luJUETl1kDug184QQP4ts-GXqTgjZN_b8_1737058957
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When multipathd handles link integrity FPIN events, it sets the rport
associated with the effected SCSI paths to Marginal. These patches make
it do the same thing for NVMe paths.

Changes in v2:
- commit message change to add more detail
- multipathd now stops looking as soon as it finds the matching rport.

Benjamin Marzinski (2):
  libmultipath: export udev pthread cleanup functions
  multipathd: set rport port_state to marginal for NVMe devices

 libmultipath/discovery.c          |  4 +-
 libmultipath/discovery.h          |  2 +
 libmultipath/libmultipath.version |  6 +++
 multipathd/fpin_handlers.c        | 79 ++++++++++++++++++++++++++++---
 4 files changed, 83 insertions(+), 8 deletions(-)

-- 
2.46.2

