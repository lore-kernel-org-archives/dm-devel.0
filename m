Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E215E92FF1
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 06:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696575582;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=0KS0inKX6Qt44j3k785JVgTpvwYVg9HAWF0DqHrVe2E=;
	b=RH2X5Chckja2PTOQi/K94WQBwA4yzkwavUuDwy6NqQc8y++kGz5pIVxvAfqKRFPO/Jur2c
	GIix7Gi1zbWJd7m7Cj8K0G7rYEEXnCQ6mUoJCzpY+gB8rbck8EjdmCQr/ASh/TntcLjItu
	tzdutnXncyN3SezWAIG0mmJV3QJ5ksM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-paIk6NVmMFSVVS-jLkmSkA-1; Fri, 06 Oct 2023 02:59:29 -0400
X-MC-Unique: paIk6NVmMFSVVS-jLkmSkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 372541C05EB5;
	Fri,  6 Oct 2023 06:59:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA9E410EE859;
	Fri,  6 Oct 2023 06:59:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66E7A1946588;
	Fri,  6 Oct 2023 06:59:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBA2E194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 16:52:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD7B2C158BA; Thu,  5 Oct 2023 16:52:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A57F6C15BB8
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 16:52:36 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 836533C1477D
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 16:52:36 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-kUSOKLq4P3em_0XQucxO3A-1; Thu, 05 Oct 2023 12:52:33 -0400
X-MC-Unique: kUSOKLq4P3em_0XQucxO3A-1
Received: by mail-ed1-f41.google.com with SMTP id
 4fb4d7f45d1cf-533d31a8523so2240155a12.1
 for <dm-devel@redhat.com>; Thu, 05 Oct 2023 09:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696524752; x=1697129552;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=KgPjpEGZr/ya+b1nA2HCszMwvAMwNqInhlT0jMBJh64=;
 b=FaPfnkuxor3aHMFbxHn9qIOnaV40oLesf6fgwI5HemkbkN4IJ4rwYZ4wnD+SzR8BX/
 zVrkzTzU5O8vFhk7JKqK+jXPpnRKXmIyjLBWvBwJOqrE19MRWPd0eh9MMZvs4C6pAdT3
 vqwSi+fLz7aA9p3wwG7tZ+bCdAnNV62WPz4iLjiR5/kJHbm6ZoltvC8oJDXgTUWLwCtS
 0M98TSE3ANjzLTKJy+Y1PlSewudoZCfT5Q6XElk7D8gePl+XCM8bkpAf32rDEcpnRkyA
 OS/L1uqmv9fFYCBXaKy8aAlfxYEDngjXW128HZV5FqAACNolKOTlgwofSedGcC4gYXMQ
 eKXw==
X-Gm-Message-State: AOJu0YxHvB8AqHJwrCFSxfCHtLe3JGNMoKuIPRh4uBL43QmYxpecv15p
 tEj9ut+hBl3iarOHxvHm9g7qtpgdnO4dR+gyJ6eEwl9p9fXXMQ==
X-Google-Smtp-Source: AGHT+IHUdjSZPWJc/GtaQzDWd+qTxCU7FAzn248Y2q0eBBwUw2devV8AHVVO3jWYSfzXDGl6bctbQujvSIUMz9U8Ez8=
X-Received: by 2002:a17:906:30d2:b0:9ae:695f:f938 with SMTP id
 b18-20020a17090630d200b009ae695ff938mr5298058ejb.56.1696524751938; Thu, 05
 Oct 2023 09:52:31 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Tatu_Heikkil=C3=A4?= <tatu.heikkila@gmail.com>
Date: Thu, 5 Oct 2023 19:52:20 +0300
Message-ID: <CA+=rEQxtadQufFF4m1Ry3dy1BxoKZFXarKUTUqi+FK0XzyaBTQ@mail.gmail.com>
To: herbert@gondor.apana.org.au
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 06 Oct 2023 06:59:25 +0000
Subject: [dm-devel] (Bisected) Accessing opened Bitlocker partition leads to
 memory fault and kernel panic on Imac8, 1
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: multipart/mixed; boundary="===============2636068583275327903=="

--===============2636068583275327903==
Content-Type: multipart/alternative; boundary="0000000000003127080606faf360"

--0000000000003127080606faf360
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
I think you and the lists are right recipients, forgive me if not, I've
never reported kernel bugs before. Naively this seems a crypto issue and
Herbert Xu from crypto maintainers made the buggy commit, but it edits
drivers/md/dm_crypt.c maintained by dm-devel people per MAINTAINERS, so I'm
going by that.

At the center of the issue is my Imac8,1 and an external 2TB SSD with 5
partitions: an EFI+MBR portable Arch Linux install with LUKS encrypted ext4
/home, and a 1.7TB exFAT encrypted with Bitlocker.

Mounting the LUKS partition works fine on all my 4 computers (Imac8,1,
Imac12,2, two generic Intels; Fedora's GNOME gvfs volume monitor often
crashes on mount using this drive), and mounting the Bitlocker partition
works on all other computers, but my Imac8,1. On my other computers, I can
boot into the portable install which automounts the Bitlocker partition
fine. However, on my Imac8,1, regardless if I boot into the external
drive's portable Arch Linux install, or use the Imac's own internal Debian
testing install, any post-6.4 kernel reliably panics (50+ times so far,
100% of the time) when accessing the unlocked Bitlocker volume:

# cryptsetup open /dev/sdb5 --type bitlk crucial
Enter passphrase for /dev/sdb5:
# mount /dev/mapper/crucial temp [kernel immediately panics if I try to
tab-complete the mount point, making the shell also access the decrypted
device I assume, or try to run the command]

I originally ran into this when mounting using XFCE's Thunar
implementation. Using it, the mount fails with "Operation was cancelled"
and the system crashes within a minute.

Git bisect lead me to:
# first bad commit: [e3023094dffb41540330fb0c74cd3a019cd525c2] dm crypt:
Avoid using MAX_CIPHER_BLOCKSIZE

If I git revert e3023094dffb41540330fb0c74cd3a019cd525c2 on current Linus'
git master, the issue goes away. So I'm personally not all that affected
anymore (if I'm ready to compile my kernels from now on), and I understand
that you have no clear way to reproduce this as it seems strongly bound to
hardware, but seems like this could point to a potentially serious security
issue since it involves both crypto and undefined behaviour.

Kdump dmesg logs (the error output is not completely consistent between
panics) & .config can be found in a dummy Bugzilla report
https://bugzilla.kernel.org/show_bug.cgi?id=3D217982

Please let me know if I can help you in any way. I don't mind using this as
a gateway to learn more about kernel debugging etc.

Best regards,
Tatu Heikkil=C3=A4

--0000000000003127080606faf360
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello,</div><div>I think you and the lists are right =
recipients, forgive me if not, I&#39;ve never reported kernel bugs before. =
Naively this seems a crypto issue and Herbert Xu from crypto maintainers ma=
de the buggy commit, but it edits drivers/md/dm_crypt.c maintained by dm-de=
vel people per MAINTAINERS, so I&#39;m going by that.<br></div><div><br></d=
iv><div>At the center of the issue is my Imac8,1 and an external 2TB SSD wi=
th 5 partitions: an EFI+MBR portable Arch Linux install with LUKS encrypted=
 ext4 /home, and a 1.7TB exFAT encrypted with Bitlocker.=C2=A0</div><div><b=
r></div><div>Mounting the LUKS partition works fine on all my 4 computers (=
Imac8,1, Imac12,2, two generic Intels; Fedora&#39;s GNOME gvfs volume monit=
or often crashes on mount using this drive), and mounting the Bitlocker par=
tition works on all other computers, but my Imac8,1. On my other computers,=
 I can boot into the portable install which automounts the Bitlocker partit=
ion fine. However, on my Imac8,1, regardless if I boot into the external dr=
ive&#39;s portable Arch Linux install, or use the Imac&#39;s own internal D=
ebian testing install, any post-6.4 kernel reliably panics (50+ times so fa=
r, 100% of the time) when accessing the unlocked Bitlocker volume:</div><di=
v><br></div><div># cryptsetup open /dev/sdb5 --type bitlk crucial</div><div=
>Enter passphrase for /dev/sdb5: </div><div># mount /dev/mapper/crucial tem=
p [kernel immediately panics if I try to tab-complete the mount point, maki=
ng the shell also access the decrypted device I assume, or try to run the c=
ommand]</div><div><br></div><div>I originally ran into this when mounting u=
sing XFCE&#39;s Thunar implementation. Using it, the mount fails with &quot=
;Operation was cancelled&quot; and the system crashes within a minute.<br><=
/div><div><br></div><div>Git bisect lead me to:<br></div><div># first bad c=
ommit: [e3023094dffb41540330fb0c74cd3a019cd525c2] dm crypt: Avoid using MAX=
_CIPHER_BLOCKSIZE</div><div><br></div><div>If I git revert e3023094dffb4154=
0330fb0c74cd3a019cd525c2 on current Linus&#39; git master, the issue goes a=
way. So I&#39;m personally not all that affected anymore (if I&#39;m ready =
to compile my kernels from now on), and I understand that you have no clear=
 way to reproduce this as it seems strongly bound to hardware, but seems li=
ke this could point to a potentially serious security issue since it involv=
es both crypto and undefined behaviour.</div><div><br></div><div>Kdump dmes=
g logs (the error output is not completely consistent between panics) &amp;=
 .config can be found in a dummy Bugzilla report <a href=3D"https://bugzill=
a.kernel.org/show_bug.cgi?id=3D217982">https://bugzilla.kernel.org/show_bug=
.cgi?id=3D217982</a><br></div><div><br></div><div>Please let me know if I c=
an help you in any way. I don&#39;t mind using this as a gateway to learn m=
ore about kernel debugging etc.</div><div><br></div><div>Best regards,</div=
><div>Tatu Heikkil=C3=A4<br></div><div><br></div></div>

--0000000000003127080606faf360--

--===============2636068583275327903==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2636068583275327903==--

