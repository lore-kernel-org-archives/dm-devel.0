Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80AF5C7EE30
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=8u2kKaCmeh2f+f9Lulo91lphrIpJKFBj6KoI/KIfJvc=;
	b=GsJ8iUMponoSQFtPTXVAo0Lx4Qyf7YD2Qv2P3G3Qi1yM+Gyz32HYDhl29g+9PFI4iMDOeI
	z5RKnbQogNK6X8zmmmC+AK8MngeDE8x3n+44MQM+Jl69Bfj0mBGwspv3vzDgTCKgpUV1Q3
	hFZu1/xetPhQZtw7mQ1ymE7fkupcUOI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-AlDVFQVjOlaHJDMAVSpmYg-1; Mon, 27 Feb 2023 02:03:37 -0500
X-MC-Unique: AlDVFQVjOlaHJDMAVSpmYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B3883C025C9;
	Mon, 27 Feb 2023 07:03:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 386D41731B;
	Mon, 27 Feb 2023 07:03:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B61541946A71;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F3E719465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 21:37:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1FEC3C15BAE; Fri, 24 Feb 2023 21:37:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17D26C15BAD
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 21:37:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0A431C05AEA
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 21:37:58 +0000 (UTC)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-wMunGYAhPDOuBmNQdGj50Q-1; Fri, 24 Feb 2023 16:37:54 -0500
X-MC-Unique: wMunGYAhPDOuBmNQdGj50Q-1
Received: by mail-lf1-f48.google.com with SMTP id bp25so962936lfb.0;
 Fri, 24 Feb 2023 13:37:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=KLpSlG9jM0kD34jhPsY3nK7CFEAB85urXMqrQxSXZ3Q=;
 b=yP9pcYX+6lLw9cM0wv0ghcuygLWj55UwWxXLYgJHKtOxVp4/O4dh/vcGaJzxNnk+ja
 uwwIfnjjJzfcuGuijvko/AtcINDgx2mcGvKQEm7LymngBY0Ma6tXsqkHvTYUc18zfIxj
 ylLu4Yy8zoJl//2YgE7SKL5lhQRx5cLBfzCFDIFeIWFpsbgGZqj5AtyxbTug6h2Vn/q5
 yrolqohH+ujyfnLQon8H55eyymjmsH3ZkbgRUF1CcQZQ+ZKj8URFHZA5fIhieEAaGY43
 0rj8+UcBIkPONZx2/lame6XrFI77qrw+zSAbHdl5fsWyTisraEoJwTGFBK8lKi7K/Nrt
 OgUA==
X-Gm-Message-State: AO0yUKXUSi1ff2ern/m25OYknxdsRy/0+owWRW2QPhlq6OQGjYJarIP4
 V4BO1/m5j6Hdb8iH6VNGzJE5FZGa0jbrWx0Z9bg=
X-Google-Smtp-Source: AK7set9dH27W+wQyRNAbPV4p34ResvzqbI5RTlB3NtX/A2q3Dxytkr8v+zP90eDEw7l5p8Iomu1U2hRPpM330FGYsgw=
X-Received: by 2002:ac2:5989:0:b0:4d5:ca42:e43b with SMTP id
 w9-20020ac25989000000b004d5ca42e43bmr5432369lfn.4.1677274672622; Fri, 24 Feb
 2023 13:37:52 -0800 (PST)
MIME-Version: 1.0
References: <2896937.1676998541@warthog.procyon.org.uk>
 <96463a32a97dc40bc30c47ddcdf19a5803de32d8.camel@HansenPartnership.com>
In-Reply-To: <96463a32a97dc40bc30c47ddcdf19a5803de32d8.camel@HansenPartnership.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Feb 2023 16:37:39 -0500
Message-ID: <CAH2r5mtLFW3x46rTACqk0XsjdHq_UMG-bLgQJx0LtyF9DF9cwg@mail.gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: Re: [dm-devel] [LSF/MM/BPF TOPIC] Linux Security Summit cross-over?
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>,
 dm-devel@redhat.com, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 lsf-pc <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3141455894571117156=="

--===============3141455894571117156==
Content-Type: multipart/alternative; boundary="0000000000000d72bd05f578f17c"

--0000000000000d72bd05f578f17c
Content-Type: text/plain; charset="UTF-8"

I did one on network fs security at a security summit before that would
still be relevant to both

On Tue, Feb 21, 2023, 16:16 James Bottomley <
James.Bottomley@hansenpartnership.com> wrote:

> On Tue, 2023-02-21 at 16:55 +0000, David Howells wrote:
> >
> > Since the first day of the LSS is the same as the final day of LSF
> > and in the same venue, are there any filesystem + security subjects
> > that would merit a common session?
>
>
> I've got one:  Cryptographic material handling.
>
> Subtitle could be: making keyrings more usable.
>
> The broad problem is that the use of encryption within the kernel is
> growing (from the old dm-crypt to the newer fscrypt and beyond) yet
> pretty much all of our cryptographic key material handling violates the
> principle of least privilege.  The latest one (which I happened to
> notice being interested in TPMs) is the systemd tpm2 cryptenroll.  The
> specific violation is that key unwrapping should occur as close as
> possible to use: when the kernel uses a key, it should be the kernel
> unwrapping it not unwrapping in user space and handing the unwrapped
> key down to the kernel because that gives a way.  We got here because
> in most of the old uses, the key is derived from a passphrase and the
> kernel can't prompt the user, so pieces of user space have to gather
> the precursor cryptographic material anyway.  However, we're moving
> towards using cryptographic devices (like the TPM, key fobs and the
> like) to store keys we really should be passing the wrapped key into
> the kernel and letting it do the unwrap to preserve least privilege.
> dm-crypt has some support for using kernel based TPM keys (the trusted
> key subsystem), but this isn't propagated into systemd-cryptenroll and
> pretty much none of the other encryption systems make any attempt to
> use keyrings for unwrap handling, even if they use keyrings to store
> cryptographic material.
>
> Part of the reason seems to be that the keyrings subsystem itself is
> hard to use as a generic "unwrapper" since the consumer of the keys has
> to know exactly the key type to consume the protected payload.  We
> could possibly fix this by adding a payload accessor function so the
> keyring consumer could access a payload from any key type and thus
> benefit from in-kernel unwrapping, but there are likely a host of other
> issues that need to be solved.  So what I'd really like to discuss is:
>
> Given the security need for a generic in-kernel unwrapper, should we
> make keyrings do this and if so, how?
>
> Regards,
>
> James
>
>
>
>

--0000000000000d72bd05f578f17c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">I did one on network fs security at a security summit bef=
ore that would still be relevant to both</div><br><div class=3D"gmail_quote=
"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Feb 21, 2023, 16:16 James B=
ottomley &lt;<a href=3D"mailto:James.Bottomley@hansenpartnership.com">James=
.Bottomley@hansenpartnership.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Tue, 2023-02-21 at 16:55 +0000, David Howells wrote:<br>
&gt; <br>
&gt; Since the first day of the LSS is the same as the final day of LSF<br>
&gt; and in the same venue, are there any filesystem + security subjects<br=
>
&gt; that would merit a common session?<br>
<br>
<br>
I&#39;ve got one:=C2=A0 Cryptographic material handling.<br>
<br>
Subtitle could be: making keyrings more usable.<br>
<br>
The broad problem is that the use of encryption within the kernel is<br>
growing (from the old dm-crypt to the newer fscrypt and beyond) yet<br>
pretty much all of our cryptographic key material handling violates the<br>
principle of least privilege.=C2=A0 The latest one (which I happened to<br>
notice being interested in TPMs) is the systemd tpm2 cryptenroll.=C2=A0 The=
<br>
specific violation is that key unwrapping should occur as close as<br>
possible to use: when the kernel uses a key, it should be the kernel<br>
unwrapping it not unwrapping in user space and handing the unwrapped<br>
key down to the kernel because that gives a way.=C2=A0 We got here because<=
br>
in most of the old uses, the key is derived from a passphrase and the<br>
kernel can&#39;t prompt the user, so pieces of user space have to gather<br=
>
the precursor cryptographic material anyway.=C2=A0 However, we&#39;re movin=
g<br>
towards using cryptographic devices (like the TPM, key fobs and the<br>
like) to store keys we really should be passing the wrapped key into<br>
the kernel and letting it do the unwrap to preserve least privilege. <br>
dm-crypt has some support for using kernel based TPM keys (the trusted<br>
key subsystem), but this isn&#39;t propagated into systemd-cryptenroll and<=
br>
pretty much none of the other encryption systems make any attempt to<br>
use keyrings for unwrap handling, even if they use keyrings to store<br>
cryptographic material.<br>
<br>
Part of the reason seems to be that the keyrings subsystem itself is<br>
hard to use as a generic &quot;unwrapper&quot; since the consumer of the ke=
ys has<br>
to know exactly the key type to consume the protected payload.=C2=A0 We<br>
could possibly fix this by adding a payload accessor function so the<br>
keyring consumer could access a payload from any key type and thus<br>
benefit from in-kernel unwrapping, but there are likely a host of other<br>
issues that need to be solved.=C2=A0 So what I&#39;d really like to discuss=
 is:<br>
<br>
Given the security need for a generic in-kernel unwrapper, should we<br>
make keyrings do this and if so, how?<br>
<br>
Regards,<br>
<br>
James<br>
<br>
<br>
<br>
</blockquote></div>

--0000000000000d72bd05f578f17c--

--===============3141455894571117156==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3141455894571117156==--

