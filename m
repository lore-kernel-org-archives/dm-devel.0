Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437351;
	b=ZPqJuGDpJ/ccfNvCjwFzSntpoTG3j8mSDKB4R7qE71B1R6f4gDgTRuC2KRRWJkl19lE8
	 ATUZuOhHEpjtrT6vuGKvtr4RdpDAY8ggsWEt5CDXfAtTqk74Cl6VMKzx/QIzXjaOU+UvU
	 ac3P5tf6xjmsgFhZc6J+HACeJt7NEF5vfl4Rq8MTvtMXkMQKkzaWg/d/YKGwmUtprTv7C
	 0Ice5ETr/FnI5VNGVJFqL8bNOf87Oc0clbrpu3tOVjPclMnCW/1IVsgW46za5p/otxCIw
	 u0+5pjyCAdoOZF2G6dguRVxUH3eON+epxmfOg7BvH1gcioegsj8Huo2Yb2FvpV1HLpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437351;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-ID;
	bh=dILnRP6xZJSP5ToPH2VAbSM+GwjL5HzfR1JP6IvWMxA=;
	b=AR1BQsKcW9mTbPEDPN9GaHJ+D0z6U5c/N1i+wxvi/j73pqcuNNQWntPNme8/Gjzsv3/2
	 OtXkKphbJwh9jZTv3R3BBCj9zrGbsTiDoIHEZWr7kCgVm0LeORkLNpEuF+GAnmePwDsNr
	 H2pLVRJysyimslbkl5GfdHq/sxWcfUxuHrngizZiwpGLVPnilZjTwW8dJ8WvK2nPCRKlF
	 VVrn4lReakfQVf43fAcdlgA/vjoNn7Q/IJC1bT7atETPdVJEFiJQg8Dy9KCqpNXagS97J
	 YIwUgU6ayvfpyzg+CfyqdmM3AX3tdyrjs3o04MLHnOsLNTpphHqDD5ossvN+0DgVdtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ic20LHky;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33213606AECB
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 22:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33213606AECB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ic20LHky
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794437350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dILnRP6xZJSP5ToPH2VAbSM+GwjL5HzfR1JP6IvWMxA=;
	b=Ic20LHkyBGl7V3xTFzm4VTfJLF4sIvsPUjp0C+zduo4azKmmVLZB0AI4XTdIIwJddTlZr+
	bZjHLFKm8iqrUKtr3hmmAJBGjil0jtCJXtZgek2oDFOARSQ1058bf/HPJqwfudYcREj5Al
	gM2N/j7o15MUfM/FRug9vzPag7d7u50=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-KkYq2CQvNHWCAhvXU0hNbA-1; Wed,
 11 Nov 2026 17:49:04 -0500
X-MC-Unique: KkYq2CQvNHWCAhvXU0hNbA-1
X-Mimecast-MFC-AGG-ID: KkYq2CQvNHWCAhvXU0hNbA_1794437343
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C25F1956095;
	Wed, 11 Nov 2026 22:49:03 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B455C30000E8;
	Wed, 11 Nov 2026 22:48:59 +0000 (UTC)
Date: Wed, 11 Nov 2026 23:48:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?GB2312?Q?=D6=DC=CE=B0=BD=AD_=28Weijiang_Zhou=29?= <weijiang.zhou@unisoc.com>
cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Sami Tolvanen <samitolvanen@google.com>, 
    =?GB2312?Q?=BD=F0=BA=EC=D3=EE_=28Hongyu_Jin=29?= <hongyu.jin@unisoc.com>, 
    =?GB2312?Q?=CE=E2=CF=E9=C2=BB_=28Xianglu_Wu=29?= <Xianglu.Wu@unisoc.com>, 
    =?GB2312?Q?=CE=E2=D6=DC=BE=B5_=28Justin_Wu=29?= <Justin.Wu@unisoc.com>, 
    "dhavale@google.com" <dhavale@google.com>, 
    "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [RFC PATCH 2/2] dm-verity: don't restart or panic on errors
 during system shutdown
In-Reply-To: <179436615561.34024.4719948965871294246@unisoc.com>
Message-ID: <a3dcb9a9-d722-729b-0e50-53629cb07847@redhat.com>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com> <9cc9b5c7460d4b0db002e7954b2eb893@zeshmbx08.spreadtrum.com> <5587e2d9-3286-b867-254a-035543e284cd@redhat.com> <179436615561.34024.4719948965871294246@unisoc.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ay2ELJdCK7JC-5ehzX2nxp5p1U407B4KRln5X2IlM9w_1794437343
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463801984-1409295983-1794426023=:1126394"
Content-ID: <f29e6b85-a5ac-06fa-68c9-c4ecddb8534c@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463801984-1409295983-1794426023=:1126394
Content-Type: text/plain; CHARSET=GB2312
Content-Transfer-Encoding: 8BIT
Content-ID: <5c16abd2-59f9-9579-37e9-d3722b99a21e@redhat.com>



On Wed, 11 Nov 2026, 周伟江 (Weijiang Zhou) wrote:

> Hi Mikulas,
> 
> thanks for the review, and sorry about the TABs.  They were not lost while
> composing: the message left my client intact, and the rich-text path of our
> corporate mail setup re-encoded the text part on the way out, dropped every
> TAB and reflowed the long lines.
> 
> I have moved to a submission path that hands the MIME to the server byte for
> byte, and checked the round trip through a mailbox first.  The patch below is
> the same patch, unchanged - no code was touched since your review, only the
> whitespace is back.
> 
> Thanks,
> Weijiang

Hi

This email has deleted TABs too.

I applied the patch manually, no need to resend it.

Mikulas

> Commit 252bd1256396 ("dm verity: skip verity work if I/O error when system
> is shutting down") stopped I/O errors during shutdown from triggering a
> restart, since devices may legitimately be gone by then. Errors that reach
> verity_handle_err(), e.g. through a failed hash block read followed by a
> failed FEC attempt, are not covered and still call kernel_restart() or
> panic().
> 
> During a reboot that is both wrong (nothing is corrupt) and harmful: it
> races with the reboot already in progress and replaces its reason with
> "dm-verity device corrupted", which bootloaders such as Android's treat as
> a verity failure and switch the device to EIO mode.
> 
> Apply the same shutdown check in verity_handle_err(). Corruption is still
> logged, recorded in hash_failed and reported via uevent, and the I/O still
> fails.
> 
> Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
> Signed-off-by: weijiang.zhou <weijiang.zhou@unisoc.com>
> ---
>  drivers/md/dm-verity-target.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 42ee24d823e3..756f1202490b 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -169,6 +169,15 @@ static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
>  *offset = idx << (v->hash_dev_block_bits - v->hash_per_block_bits);
>  }
> 
> +/*
> + * Skip verity work in response to I/O error when system is shutting down.
> + */
> +static inline bool verity_is_system_shutting_down(void)
> +{
> +return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
> +|| system_state == SYSTEM_RESTART;
> +}
> +
>  /*
>   * Handle verification errors.
>   */
> @@ -216,6 +225,15 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
>  if (v->mode == DM_VERITY_MODE_LOGGING)
>  return 0;
> 
> +/*
> + * Devices may already be quiesced (e.g. UFS set offline by its
> + * shutdown hook), so a failure here does not imply corruption.  Fail
> + * the I/O but do not restart or panic, which would also override the
> + * reboot reason of the shutdown already in progress.
> + */
> +if (verity_is_system_shutting_down())
> +return 1;
> +
>  if (v->mode == DM_VERITY_MODE_RESTART)
>  kernel_restart("dm-verity device corrupted");
> 
> @@ -598,15 +616,6 @@ static int verity_verify_io(struct dm_verity_io *io)
>  return r;
>  }
> 
> -/*
> - * Skip verity work in response to I/O error when system is shutting down.
> - */
> -static inline bool verity_is_system_shutting_down(void)
> -{
> -return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
> -|| system_state == SYSTEM_RESTART;
> -}
> -
>  static void restart_io_error(struct work_struct *w)
>  {
>  kernel_restart("dm-verity device has I/O error");
> --
> 2.43.0
> ________________________________
>  This email (including its attachments) is intended only for the person or entity to which it is addressed and may contain information that is privileged, confidential or otherwise protected from disclosure. Unauthorized use, dissemination, distribution or copying of this email or the information herein or taking any action in reliance on the contents of this email or the information herein, by anyone other than the intended recipient, or an employee or agent responsible for delivering the message to the intended recipient, is strictly prohibited. If you are not the intended recipient, please do not read, copy, use or disclose any part of this e-mail to others. Please notify the sender immediately and permanently delete this e-mail and any attachments if you received it in error. Internet communications cannot be guaranteed to be timely, secure, error-free or virus-free. The sender does not accept liability for any errors or omissions.
> 本邮件及其附件具有保密性质，受法律保护不得泄露，仅发送给本邮件所指特定收件人。严禁非经授权使用、宣传、发布或复制本邮件或其内容。若非该特定收件人，请勿阅读、复制、 使用或披露本邮件的任何内容。若误收本邮件，请从系统中永久性删除本邮件及所有附件，并以回复邮件的方式即刻告知发件人。无法保证互联网通信及时、安全、无误或防毒。发件人对任何错漏均不承担责任。
> 

---1463801984-1409295983-1794426023=:1126394--

