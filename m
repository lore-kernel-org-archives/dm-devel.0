Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06B026D4DD
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633466; cv=none; b=tG2TfR9WRAGVYMQYhecwLqXoUiclehakX/shzqeGsnNxNr2JpbijoaAoXoFIJRD4DjewBOOPh19py6J4n2Lci1Tsc4RK0JBidzTAAk8PByZOSdlE8TCHAMSQ9xVdMwRrtm5Sdm58HRmtKupFHwRBk72WZ+7hmrO4FhyhAV9xVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633466; c=relaxed/simple;
	bh=sZztMf0inSFs7KKOe3+fxEIbJ39FY7q3qlZz7rMehCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=g/RejjZxTVg6LpLJLbySzN9kh9nq+OqogfuSXZ6O0Vl1fi8kISyqYhDy1DUIYqIkyeOA76X0+ddQbc1IvA+m00ngWpxzOx8Xsb0VXfUCkMs/Z7QPLUqsmSiaN7VL3PxLlEVn1d2Tkefzu3NoNnR1FFYAZUjt0drHVIgfV3gDZ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QmnoQxZk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QmnoQxZk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778633464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhSevhuOFI2rPrtAh2gFortxSelUHX4RzeAcu4JBndA=;
	b=QmnoQxZkZzHClzsTeeqzAC9yov+XkT9lEyG/q0spy/AULuiWQ3Szty6R1Fz1OINL89dplw
	IlWZq+f/21I+avXyQKmPEbPwMKr692AlpZuOBke7X6VpidoxbIDrtkzPzmuhZdsAWbSrSA
	U1sUMJKjy4VEKarO5S8CBCPPzoa/FdY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-c4JoZbBJPcmdmZMUqTWOWg-1; Tue,
 12 May 2026 20:51:01 -0400
X-MC-Unique: c4JoZbBJPcmdmZMUqTWOWg-1
X-Mimecast-MFC-AGG-ID: c4JoZbBJPcmdmZMUqTWOWg_1778633460
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 880E1195608B;
	Wed, 13 May 2026 00:51:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ACC21953947;
	Wed, 13 May 2026 00:51:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0oxs93331865
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:50:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0oxBO3331864;
	Tue, 12 May 2026 20:50:59 -0400
Date: Tue, 12 May 2026 20:50:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/18] libmpathutil: runner: use shared_ptr
Message-ID: <agPK8lr3Qax3plG5@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9zywAkqxmZ3brQHHMKL6IyCB3X8v8_agKGR6vSPao3o_1778633460
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:22PM +0200, Martin Wilck wrote:
> Use shared_ptr to track the runner_context refcount.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

