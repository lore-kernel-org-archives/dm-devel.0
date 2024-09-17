Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B76D16087B
	for <dm-devel@lists.linux.dev>; Tue, 17 Sep 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726588747; cv=none; b=eQJsCpX1EONTR96rcxgMF4Zkd9iEVIgjzae1ZiVYnVYbcTA9UmbFEu6O0qP4fKn9kf5RRqhWw70dV5hoIQiimk8wtbEE/V7+IKsA/oyBkNV+oJVttKVldFarJIux+tNIUNCGEsDwkHi9wcrzysw+4H9Thk2oUpRqqEWpX7Z0jzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726588747; c=relaxed/simple;
	bh=ne9hzNbEIorOHHqko9xMx1BotteTuxvRx6Al7f8+rVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mGK6j4AVRli9wnlkXARp3q7ttR0RH7jV7vUaOfH9OK+s3qcwsPWGVCxPQSv1N5BFKWYKo0ZcYXoitI5iZxmcEiYHgQOkn+sLPEf4Fjcsfx8ZLW8eLCM8h7hcvY4VRlYGEBQfUq0OSMx2vwkttxho6YnrqFPW50oBSBM4eELomUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4XeAndM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4XeAndM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726588745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q6oylFwlMQBjyuE84d4sTMecbMmDpEYxuSBA/dDiRZ4=;
	b=X4XeAndMEr0q0r/9PcvwCFxfIUuPHVOsZvuRhFo+z71+vUNVA7RQM6xlLixLa+pEphUJwY
	GutIR+YlfTz9xOZbZl+Cf2zN9Cn1k4BuIFyUqNX2omOJ79rgYx+lBShfom8zRJp0kwBVtE
	T4SFKyLCZ/6V4sJ3gqxhtYsQ8p4QOZQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-dHg8eaMtMryKUqmh4lPnwg-1; Tue,
 17 Sep 2024 11:59:01 -0400
X-MC-Unique: dHg8eaMtMryKUqmh4lPnwg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DB4B1955D58;
	Tue, 17 Sep 2024 15:59:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E952C19560AA;
	Tue, 17 Sep 2024 15:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48HFwwmK959844
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 11:58:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48HFww6D959843;
	Tue, 17 Sep 2024 11:58:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH] multipathd: checker port_state before setting it.
Date: Tue, 17 Sep 2024 11:58:58 -0400
Message-ID: <20240917155858.959835-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If the rport port_state is already Marginal, trying to set it to
Marginal causes an error like the following:

multipathd[365376]: /sys/devices/pci0000:c0/0000:c0:01.1/0000:c4:00.0/host0/rport-0:0-5/fc_remote_ports/rport-0:0-5: failed to set port_state to marginal: Invalid argument

To avoid causing this confusing error message, check if the port_state
is already marginal before trying to set it.

Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/fpin_handlers.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index be087ca0..6b56f9b7 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -169,9 +169,14 @@ fpin_els_add_li_frame(struct fc_nl_event *fc_event)
 /*Sets the rport port_state to marginal*/
 static void fpin_set_rport_marginal(struct udev_device *rport_dev)
 {
+	char old_value[20]; /* match kernel show_fc_rport_port_state() size */
 	static const char marginal[] = "Marginal";
 	ssize_t ret;
 
+	ret = sysfs_attr_get_value(rport_dev, "port_state",
+				   old_value, sizeof(old_value));
+	if (ret == sizeof(marginal) - 1 && strcmp(old_value, marginal) == 0)
+		return;
 	ret = sysfs_attr_set_value(rport_dev, "port_state",
 				   marginal, sizeof(marginal) - 1);
 	if (ret != sizeof(marginal) - 1)
-- 
2.45.0

