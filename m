Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634AD2459C6
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 05:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330509; cv=none; b=mdfuqC20vFY4bTvBGmvzl9JUZudLlaffTncoOKUPUrK+MVjZ/O/YxBbqcNPlEAJk226ifPX+37LZ9w43vZmALeUXXrnFPSwpa+fbnW3/IjM4YSHmx06zQojO/wO04EEyTACuvBAzK1uz3QaUlu9T3yiCYTT1iWxKsmQjsZZ/3Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330509; c=relaxed/simple;
	bh=OndJ0kNPi6MlbbgtRe34o7WtfF7G/4nOFYSliOj2aUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=OmyN+9Y6w+NJIuHL87y0p9uJrjbtI/cPTSCdYdFb5weTHJABELrXtuUFbU1u0U+0iVLaVzdFDmu2D42P0XCJRs2/DyWPUzWVoVGj7TTrVnZ4rv9Ebc8S6FhvtVeNfZWF9RwUl2nP896uEptX1UusjeN5K3KFTHcdpo50zV3pS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KMwkq+3n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KMwkq+3n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774330507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wQp4z7wciXARth+5EsJW2ay0GLJXPfRblQI3b4CQSsY=;
	b=KMwkq+3najStdqpwf+CKsiLgFOb8VdDKXHMRADkrF1mEry0l0pVCH0BO8dqj4gS5B2a5rO
	9MO8GCdplU4LGTZayfxOBKxbM5QeeBPKCAYCE7xKoVdghkT4pVmL1OerbDOgRiBhPYgwbW
	H9SO91j4yedHx3TMORL+vVy+SYQNrPc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-LGKTGVIBP2SzphNOjGfmzw-1; Tue,
 24 Mar 2026 01:35:05 -0400
X-MC-Unique: LGKTGVIBP2SzphNOjGfmzw-1
X-Mimecast-MFC-AGG-ID: LGKTGVIBP2SzphNOjGfmzw_1774330504
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 860621800359;
	Tue, 24 Mar 2026 05:35:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD8EE300019F;
	Tue, 24 Mar 2026 05:35:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62O5Z2i91047167
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 01:35:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62O5Z23O1047166;
	Tue, 24 Mar 2026 01:35:02 -0400
Date: Tue, 24 Mar 2026 01:35:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/4] multipathd: get_new_state: map PATH_TIMEOUT to
 PATH_DOWN
Message-ID: <acIihmVF_UcYZZH2@redhat.com>
References: <20260319221344.753790-1-mwilck@suse.com>
 <20260319221344.753790-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260319221344.753790-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G38jZ7ug1nGgO36Emvhh3D8IbUuC4Z-D4Uxg7tgfyfI_1774330504
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2026 at 11:13:41PM +0100, Martin Wilck wrote:
> We map PATH_TIMEOUT to PATH_DOWN in pathinfo(), but not in get_new_state().
> Do it there, too, to treat the states consistently.
> This avoids logging "checker timed out" twice in update_path_state(), even
> if log_checker_err is set to "once".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

