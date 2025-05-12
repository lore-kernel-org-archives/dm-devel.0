Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245A255227
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056080; cv=none; b=sAjRe8643jEVXikOq8GCbdUEY3/hUOVKRfjIupRIw57kOerA2kVsjRUjFBhk6c48oU57s3Vn5wBthuzmXQzHz+66TMXIb8PanxBqN2XgWv4a/9VdVBO1Gp6ppxKM9CEof22r9HzSWSprjHZIHd6NhstIJ+cNyRDw2+pXJrteqFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056080; c=relaxed/simple;
	bh=Nl2F08/8WQ+ffGyrqcnI0bdqvXZIy+A5o/03/Nn6Bj4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=C1koCHKGYs6OBnNYf5MhzOD91NK1V2pHAvEERrBHx5AMtotKyv3EyTmw4/OCfqKHndQxezILQTlDJNU93wAt9bgyvGgUMfJZK14Hn/GRclcmgKq/EPFN3almGEbKAhZf5sWrY3XIXvjnOEhXXUFxSCNvsKq5cI3dm+sDDGme+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NM1ore0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NM1ore0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747056077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EtFIZos0JqMF/7UbE2bWwHzO0kbBrp+t9Q2IfwA7m5s=;
	b=NM1ore0YLlPQxHjWR6TA8ldIZ9vKIRj7SDFPVAfJUVhY6V1ZmdpQ3GqvkXKbtxvhwH3v3y
	tbBkfa7mmsgtM6dMccOug7UmOUoRnDL5qCwMDtZOAieCJBy0/E6RcwVwovG7M5fdiK0fzy
	2hoV9FSG6D61zeBz1QdvuAcKHzk//6U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-esPKA_uuO9iOOkDygTFvsg-1; Mon,
 12 May 2025 09:21:14 -0400
X-MC-Unique: esPKA_uuO9iOOkDygTFvsg-1
X-Mimecast-MFC-AGG-ID: esPKA_uuO9iOOkDygTFvsg_1747056073
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E93011955D79;
	Mon, 12 May 2025 13:21:12 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E3B419560A3;
	Mon, 12 May 2025 13:21:10 +0000 (UTC)
Date: Mon, 12 May 2025 15:21:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Malte_Schr=F6der?= <malte.schroeder@tnxip.de>
cc: Bart Van Assche <bvanassche@acm.org>, bmarzins@redhat.com, 
    dm-devel@lists.linux.dev
Subject: Re: LVM RAID1 regression in 6.15-rc5, bisected
In-Reply-To: <c09e5298-4824-4b0c-8fc8-0be33975da17@acm.org>
Message-ID: <4a159e7a-4d0d-181a-9853-8ec952b68172@redhat.com>
References: <fc8148d9-4b9f-4c13-9924-2f9b0eced194@tnxip.de> <c09e5298-4824-4b0c-8fc8-0be33975da17@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HvBgky5SSYs_RuML9df5mmcSVwN3QAkvb81Dk76MXa8_1747056073
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-811534987-1747055841=:2446783"
Content-ID: <743836db-3b6d-941b-9ea7-a6c3b4872069@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-811534987-1747055841=:2446783
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <464687b4-49f1-06e3-ac15-dd9ae9fbfa5d@redhat.com>



On Wed, 7 May 2025, Bart Van Assche wrote:

> On 5/7/25 3:40 AM, Malte Schröder wrote:
> > kernel 6.15-rc5 fails to access lvs which use mirroring (lvcreate -m1).
> > Last working release is -rc4. Reverting
> > 5a2a6c428190f945c5cbf5791f72dbea83e97f66 fixes the issue.
> 
> From commit f1aff4bc199cb92c055668caed65505e3b4d2656 in Linus' master
> branch:
> 
> Fixes: 5a2a6c428190 ("dm: always update the array size in realloc_argv on
> success")
> 
> Bart.

Hi

Malte. do you see some kernel crashes in the log? The commit 
5a2a6c428190f945c5cbf5791f72dbea83e97f66 could cause crashes, however I 
don't see how could it cause misbehavior (it is reading beyond the end of 
the allocated memory).

How many device mapper devices are there in total?

Does the commit f1aff4bc199cb92c055668caed65505e3b4d2656 fix it for you?

Mikulas
---1463811712-811534987-1747055841=:2446783--

