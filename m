Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635424;
	b=HUjZCkGVJTMayMCIeMjulTf8lilS0aYjsj+/vM3qvl45RnNzpwTmASKu+OGHJxDwQJOE
	 qBAIFvYaFAtgwzAvk+x4+HCoPgmCSD8jQkla09NOptBOYvFsVUFObxRKPoEnYkcOYynqv
	 H6PCUgyi8Mbf5NlLjooNcEjsD13xnZGOZ6hfuB6vZGYIuW3G1BFggCEL0q8s4QWJKNmBc
	 2x3zDGb0jQyR40htWjrr7N89XFCLsU02CxFlmEgoJRHBV6oD2bAcEW6+/3SjuvkoWvvu1
	 TZsMHsqVHgZWovLe+ukURuIqeyrwBxb5YruUDip6j6BOrgyPeob2BXAkOGxBSjhT7FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635424;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Transfer-Encoding;
	bh=GcUWDnzDkVt7oeg7/27sTQCRhtqfS3EL+mXeYyoBPT4=;
	b=0v/uXiTwu44x/o8d1rTYHT9Y2/lyNSYNn1ShbtjqG6VNKWx2xvPZObXbbf6NK90xLB5O
	 r6MoEszXKq5lPgdh44vI8oDql3hwECVlGH2SSTEIT1Y3S674VKl7WQL5uE4q+/6qtM4QT
	 uJFyPqyZTiZbbiPD9IN7LFDPKy3d1cyaaGLH0LTrvs+w+WtAeDhcwL8AumBG5oHU6w4Qm
	 FESigrG8PyA5zhhvFxPRZlSyJIfAVVM6lDyMp+JlYOO1tGvEzTnaK5+jP2MUlExYxCcW7
	 qKvHqB9BwHiQgWPGlUi8C+Saem5yBR6LFuDFF6p2N05vblickCuVzA+L2B1ja/wSSGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eYKiQ2zY;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC948606A330
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 19:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC948606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eYKiQ2zY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795635422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcUWDnzDkVt7oeg7/27sTQCRhtqfS3EL+mXeYyoBPT4=;
	b=eYKiQ2zYYS/zLqLL5y+wQlg/148umyfE0epq0fTfa7kjnDH22DaIwwcqfn+zlHozEb+5UB
	gOD05zByB8R0+GjJ/wge2H3Kst1z/Zq+ARZ9GlyVLAGYdJL2iaokWkUrWOxENhLdcd1S5t
	sJczVDoJK4s/mmS9Ri4kgnBWjcoUgYs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-IxeNcT68Pg-rXdpJ5lx4Fg-1; Wed, 25 Nov 2026 19:37:01 +0000
X-MC-Unique: IxeNcT68Pg-rXdpJ5lx4Fg-1
X-Mimecast-MFC-AGG-ID: IxeNcT68Pg-rXdpJ5lx4Fg_1795635420
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ad00533aa8so23376131fa.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 11:37:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795635419; x=1796240219;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GcUWDnzDkVt7oeg7/27sTQCRhtqfS3EL+mXeYyoBPT4=;
        b=WbNgP0gdJulUsHUbRjCXKA+Y08JrpLjuhbXTcrV58DSLhKewF7Xod/QG1Cs9ha6AdN
         MgijOItvX/MLD+CFgXkDl+TA3rreT/aq3n6cCRzxnenwO8xx0xsm0rv/lVvVldJXYNe2
         dYL4Xr03KiICZnYDlMwAHpHJ8tqDZWrhqoWgxbysUPhlx5mG46M3qACwHP9QE4syUYeR
         AuoSV4pId99PmGMCTTrxwXQsUVtkq+fLx7IZMmJlUVaMTzoiPbIBhExpsDIHAzZcY4NE
         6nPfut9g769ITWXWqRjANrQIRRfFzvdP7kpUdPMthWs1bob60mWIjYa/3vMevXqdN0sy
         +RTQ==
X-Gm-Message-State: APuU4Z8DGgSTgW5s2HoyCV0AJ+NoOoKadxTEPvWF4Z8CN4CKr8UgaGIr
	kCo8pKz9Ilg1skvIJRI85qtoqvYacq4wxOrl+j55/iIjajV+pyiARmwzZaSt4vAaMq+UxQqKv4G
	uSuLhD1QfXAnYFzBIe+047An1EZiBsUYKtd45tEQ3oN6vVaz6eZKs3zNr/c8ZbCdG0LI6d+TQM9
	N/8+QrtPqkMttT1Vl3ZdpIM8dlG3nUDXpZJhsAKE8D/HcLCaw=
X-Gm-Gg: AZFdTZfkeJdcw6b17/cleU1SgnPQ4RmGgO6WgQSMiFl+tpWCth/GVBUU6jVnVNj5Z5L
	3dafSurqBvccVx0VdMAFrFKJWyrJNVerQhlfEEFhY9C0DgBZCVt9gaEuST0wZk+Yk3srDk7a3LK
	g0IWmbFboAsB6AIUOwIYZq2FbgGlJ919XsnHF7BRSeHDbdPwzZjzSP9UZuCtxGfCNNXu+2od8FX
	eXV+UJwLKY9ctawsXBzZDcn2F32z/+Y6/viuKkFMytvvv4PlpgK9XjNuBL113nXmGl3T7cMuZf9
	y+lIFWww
X-Received: by 2002:a05:651c:a184:b0:3ab:1207:bd2f with SMTP id 38308e7fff4ca-3ae7f9da258mr64723431fa.11.1795635419453;
        Wed, 25 Nov 2026 11:36:59 -0800 (PST)
X-Received: by 2002:a05:651c:a184:b0:3ab:1207:bd2f with SMTP id
 38308e7fff4ca-3ae7f9da258mr64723371fa.11.1795635419081; Wed, 25 Nov 2026
 11:36:59 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev> <20261119-bug-dm-thin-rcu-gp-v3-3-c80ecc475e1e@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-3-c80ecc475e1e@linux.dev>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 26 Nov 2026 03:36:46 +0800
X-Gm-Features: Aa3M54ryKxKVSmorfBxjLDQtyNoAMSUrA6jEU7od1eZdQjmBhLAxQmPD6h-MRb4
Message-ID: <CALjSBEt-KJ5a_vE9PJu=O1WyBY-Lu=L707opvOTL7411EZGrBQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] dm thin: free thins with kfree_rcu() instead of
 waiting in thin_dtr()
To: dm-devel@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org, 
	Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L2Mv2jyDRWr559nrV9ACo46Z20c6gTP-loBiuhOQPl8_1795635420
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 8:24=E2=80=AFPM Qiliang Yuan <qiliang.yuan@linux.de=
v> wrote:
>
> thin_dtr() takes the thin off pool->active_thins once its last
> reference is dropped and then waits for a grace period, so that
> requeue_bios() and error_retry_list_with_code(), which walk the list
> under rcu_read_lock(), are done with the thin before it is freed.
>
> Removing a thin device thus waits for a full grace period in thin_dtr(),
> although those readers only need the memory of the thin to stay around.

For the record, this holds only because both bio lists of the thin are
empty when thin_dtr() runs: the thin is suspended, inactive, or no
longer open.

Without the grace period, the two ref-less readers (requeue_bios() and
error_retry_list_with_code()) can still be working on the thin after
thin_dtr() returns. They access only tc->lock, deferred_bio_list and
retry_on_resume_list inside their RCU read-side critical section, so
kfree_rcu() keeps everything they touch valid.

The empty bio lists are what make this safe. With both lists empty,
error_retry_list_with_code() ends no bio, so it never reaches the
target or the mapped device, both of which dm core may free right
after thin_dtr() returns. Thus, kfree_rcu() is enough.


> Free the thin with kfree_rcu() instead of waiting for the grace period.
>
> Removing 100 thin devices of an idle pool with dmsetup remove takes per
> device (mean of five rounds, min-max of the rounds in parentheses). The
> queue freeze in del_gendisk() waits for a grace period of its own, which
> the one in thin_dtr() used to overlap, so only part of it is saved:
>
>   before (ms)        after (ms)         change
>   17.2 (17.0-17.4)   13.7 (13.2-14.4)     -20%
>
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

