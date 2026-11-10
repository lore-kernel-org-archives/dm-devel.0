Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344893;
	b=1UXByyoXBNaJ3K7c/H7h/Gr3fnumMMPYbxB6GY3lEOwiphssW/6RRFe+C7pGuZtzN46B
	 wP0JuDlGwVnMOaTX528N91zHUWdsk+wvsumdzTUxQuK5vzBbq3T9fElLy499YiqSVQ6gJ
	 Kj9XrasA7zePviskOjbMKgIcgrDy0sEBRrNGfw6rLWpBDJmCiRd9uFEKrTL6ma2JSBvLG
	 HeeKaTVEZkElTmhM2lM5PZlCuLq4Nt5TdQT/SdU9BuaEuRC2WRgpf2IxHf3RiRB8X8oXu
	 01YRWeQ2dqCw/uu+OnLJ1T+MwJbA5VKlE7jwgQC/NQwrwJJBzBsn5u6rxsCsgIUN5MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344893;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-ID;
	bh=2/fapBQN00iQBiSSy0yeOKnavBIJ2GVEjp9If2cALik=;
	b=HvDmsUOlnFk8+IV8Kc9uC4yPNTm9C5cl65OOMf87NNDCSoZeTE8NHfMLBMLAnprJbIX6
	 kX3VhpV9AXha/CjjtkvMlDKVLIdmS4+L3oDWzMyqiiDbuB8yrHHhg+vZvxeClPFpTLiSY
	 MeVHf88oYKWt+FXDjfiZNB6mP7xom1DCAh4o6ANwl7RwxIeQeFMQUAN2yBt+zkCJdavYj
	 lN1Q+qXWlZMO/KPkrtm3TL67QCKxFtn51BE9pm+RzF3lmqlqBu3J9XUisvB5OWiely9CK
	 hieRR2nn4UE3YXjAPW/WZi2+3r28LHo8CarS8+FMy2nARzZirUxW+BuKkzA3fiURgXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="d92rL/dc";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974E606A320
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 21:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3974E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=d92rL/dc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794344892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2/fapBQN00iQBiSSy0yeOKnavBIJ2GVEjp9If2cALik=;
	b=d92rL/dcwXN4CRwAx2qrv5DS9icv1L9KJiOFV+qjMz4GM3bVLxej18vdQW7YFxa6TloOkp
	hT9wou/Bgjd36XiQQTIg1aI5SAN1xoEuWQHmD+6THHXBWmyMrP+ZkEyfEqZ5qSkTsFyO4P
	TSFsHnWvBLBW9Rey/wUkG/DoTpJOPU4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-fw5HSfRyPlezTepy97mBvQ-1; Tue,
 10 Nov 2026 16:08:10 -0500
X-MC-Unique: fw5HSfRyPlezTepy97mBvQ-1
X-Mimecast-MFC-AGG-ID: fw5HSfRyPlezTepy97mBvQ_1794344889
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 857761800352;
	Tue, 10 Nov 2026 21:08:08 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C72B1956089;
	Tue, 10 Nov 2026 21:08:05 +0000 (UTC)
Date: Tue, 10 Nov 2026 22:08:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?GB2312?Q?=D6=DC=CE=B0=BD=AD_=28Weijiang_Zhou=29?= <weijiang.zhou@unisoc.com>
cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Sami Tolvanen <samitolvanen@google.com>, 
    =?GB2312?Q?=BD=F0=BA=EC=D3=EE_=28Hongyu_Jin=29?= <hongyu.jin@unisoc.com>, 
    =?GB2312?Q?=CE=E2=CF=E9=C2=BB_=28Xianglu_Wu=29?= <Xianglu.Wu@unisoc.com>, 
    =?GB2312?Q?=CE=E2=D6=DC=BE=B5_=28Justin_Wu=29?= <Justin.Wu@unisoc.com>
Subject: Re: [RFC PATCH 1/2] dm-verity: don't decode FEC into a dm_bufio page
 that is already in the cache
In-Reply-To: <27b2dc50d3bb497ea3f3f84e7e4b271c@zeshmbx08.spreadtrum.com>
Message-ID: <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com> <27b2dc50d3bb497ea3f3f84e7e4b271c@zeshmbx08.spreadtrum.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KVH1vgytIvK2LhYW_LUC5hxvtMhJDkm8jwzGQtN7ilE_1794344889
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463801984-1275111830-1794344064=:1030469"
Content-ID: <617b1109-4e97-38c8-4195-f422c7065f86@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463801984-1275111830-1794344064=:1030469
Content-Type: text/plain; CHARSET=GB2312
Content-Transfer-Encoding: 8BIT
Content-ID: <5a8afbb2-6691-6743-fe91-41681df8407e@redhat.com>

Hi


On Tue, 10 Nov 2026, 周伟江 (Weijiang Zhou) wrote:

> Commit 51ba14fb368e ("dm-verity: do forward error correction on metadata
> I/O errors") handles a failed hash block read by allocating the block with
> dm_bufio_new() and decoding into it with verity_fec_decode().
> 
> dm_bufio_new() inserts the buffer into the v->bufio cache immediately, with
> no B_READING state and no read_error, i.e. indistinguishable from a
> successfully read block that merely has not been hash-verified yet. Its
> contents are whatever the allocator returned (all zeroes with init_on_alloc),
> and no I/O is ever submitted for it.

I don't see why this should be a problem.

If the device returns random data, FEC is supposed to correct it.

If the device returns an I/O error and we create a buffer with random 
data, this is similar to the case where the device returned random data - 
and FEC should also correct it. It doesn't matter whether the random data 
came from the device or from uninitialized kernel memory.

So, it seems to me that this patch is just papering over the problem.

> FEC then reads every other block of the RS codeword and, for blocks on the
> data device, calls verity_hash_for_block() on them to decide whether they
> are erasures. That walks the hash tree through the same v->bufio. If one of
> those data blocks is covered by the hash block being recovered (or by a
> descendant of it, when it is an upper level block), the nested

This is the real problem that should be fixed. Correcting a block 
shouldn't depend on the content of the block being corrected.

> verity_verify_level() gets the placeholder from the cache, hashes the
> uninitialized contents, sees a mismatch, cannot recurse into FEC again
> (fio->level != 0) and calls verity_handle_err(). With restart_on_corruption
> that reboots the machine on a single transient read error, although the
> media is intact.
> 
> Whether this happens is purely a function of the geometry. With 4K blocks,
> sha256 and roots=2, 251 of the 1786 level-0 hash blocks, all level-1 blocks
> and the root block have a codeword data block underneath them, so an I/O
> error on any of those reliably produces "metadata block N is corrupted".
> It was observed on Android devices where a hash read failed with -EIO while
> UFS was already offline during reboot.
> 
> Decode into a private buffer instead and only copy out the wanted digest on
> success. The recovered block is not cached, so a later access will read and,
> if needed, recover it again; that is only a cost on devices that are already
> failing reads.
> 
> Fixes: 51ba14fb368e ("dm-verity: do forward error correction on metadata I/O errors")
> Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
> Signed-off-by: weijiang.zhou <weijiang.zhou@unisoc.com>
> ---
>  drivers/md/dm-verity-target.c | 28 +++++++++++++++++++---------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 08a58a0b5e49..42ee24d823e3 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -266,22 +266,29 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  }
> 
>  if (IS_ERR(data)) {
> +u8 *fec_buf;
> +
>  if (skip_unverified)
>  return 1;
>  r = PTR_ERR(data);
> -data = dm_bufio_new(v->bufio, hash_block, &buf);
> -if (IS_ERR(data))
> +/*
> + * Recover the hash block into a private buffer.  It must not be
> + * made visible in v->bufio before it has been recovered: FEC
> + * verifies the other blocks of the RS codeword through
> + * verity_hash_for_block(), which may need this very hash block
> + * and would then hash an uninitialized buffer, reporting
> + * spurious corruption.
> + */
> +fec_buf = kmalloc(1 << v->hash_dev_block_bits, GFP_NOIO);
> +if (!fec_buf)
>  return r;
>  if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
> -      want_digest, hash_block, data) == 0) {
> -aux = dm_bufio_get_aux_data(buf);
> -aux->hash_verified = 1;
> -goto release_ok;
> -} else {
> -dm_bufio_release(buf);
> -dm_bufio_forget(v->bufio, hash_block);
> -return r;
> +      want_digest, hash_block, fec_buf) == 0) {
> +memcpy(want_digest, fec_buf + offset, v->digest_size);
> +r = 0;
>  }
> +kfree(fec_buf);
> +return r;
>  }
> 
>  aux = dm_bufio_get_aux_data(buf);
> @@ -323,7 +330,6 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  }
>  }
> 
> -release_ok:
>  data += offset;
>  memcpy(want_digest, data, v->digest_size);
>  r = 0;
> --
> 2.43.0

Your mailing software deleted tabs from the patch. Please, fix it.

Mikulas

> ________________________________
>  This email (including its attachments) is intended only for the person or entity to which it is addressed and may contain information that is privileged, confidential or otherwise protected from disclosure. Unauthorized use, dissemination, distribution or copying of this email or the information herein or taking any action in reliance on the contents of this email or the information herein, by anyone other than the intended recipient, or an employee or agent responsible for delivering the message to the intended recipient, is strictly prohibited. If you are not the intended recipient, please do not read, copy, use or disclose any part of this e-mail to others. Please notify the sender immediately and permanently delete this e-mail and any attachments if you received it in error. Internet communications cannot be guaranteed to be timely, secure, error-free or virus-free. The sender does not accept liability for any errors or omissions.
> 本邮件及其附件具有保密性质，受法律保护不得泄露，仅发送给本邮件所指特定收件人。严禁非经授权使用、宣传、发布或复制本邮件或其内容。若非该特定收件人，请勿阅读、复制、 使用或披露本邮件的任何内容。若误收本邮件，请从系统中永久性删除本邮件及所有附件，并以回复邮件的方式即刻告知发件人。无法保证互联网通信及时、安全、无误或防毒。发件人对任何错漏均不承担责任。
> 

---1463801984-1275111830-1794344064=:1030469--

