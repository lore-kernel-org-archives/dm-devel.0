Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9FD3D980
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 22:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgtiWbBL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698358367;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FyK27xM5kbIwxsUoSw19E95taRzCJvDq3pVbOquRTi4=;
	b=HgtiWbBLCr2vxNlS9awGtHilvhRMjN7tF+v4BadwOhLDoZ5fCKSqDr0SSr9UGw6xldLKz3
	cmvFX9VHHG7Q395FrKYvoDM/ERBzBsEypubraa8is0rQkAxT1p60Pb5PKs/F+YyaULhwk+
	52d9DHPn9KrUQeBCBtbx0T2zKHj5Oww=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-kjX6eWf4NdSs3-Tr1kAfpA-1; Thu, 26 Oct 2023 18:12:40 -0400
X-MC-Unique: kjX6eWf4NdSs3-Tr1kAfpA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4A0F101A529
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 22:12:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D680492BFA
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 22:12:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40FCE1946595
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 22:12:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1281F194658C
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 Oct 2023 22:12:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C31692166B28; Thu, 26 Oct 2023 22:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB24C2166B26
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 22:12:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9738C88D588
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 22:12:39 +0000 (UTC)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com
 [209.85.167.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-oQnYUxoWNmyooiM_m0NW_Q-1; Thu, 26 Oct 2023 18:12:37 -0400
X-MC-Unique: oQnYUxoWNmyooiM_m0NW_Q-1
Received: by mail-oi1-f182.google.com with SMTP id
 5614622812f47-3b2b1ae4c21so941668b6e.0
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 15:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698358357; x=1698963157;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=FyK27xM5kbIwxsUoSw19E95taRzCJvDq3pVbOquRTi4=;
 b=Nf15aIL76lKLEtCyEZKm8gMBVisS5b/+ha1p7p26G3Tlp4p9NoXALqB9W7YlxDzzQS
 zCytr4R9lcirvYtrBJIQkkZCPXNqSNW1lWJrxByhmnzZC7vO89vvYZm7woaGFEwxTdOo
 DZPDc73jBaZR/mt7m5oh8259Jt9qIun4nKyE03Xg6Ea9+DyiVKIUR/LYH/RTR+FqvxHp
 Dfd29jXyhrruytQmjV11vrmDGSyuKVYVy39LL4/QAG8YhVEfAGxf0DaLdQICq1/n3Ln/
 QvjNpOJ85a6Vauwzlxn6Uv2pm6vPW3S1UDZGKyNu4llrY08ILsLda9KzxCk9Xlq3mGH/
 e77Q==
X-Gm-Message-State: AOJu0YzobBYkVQjEnltMDKMB/YI6SCMGkOkl/9QcCp5RUhps1JuBE2c6
 jYBzi9GNhOcdE0yQtXsSdfsY2D4nAwQafDH46Y9y
X-Google-Smtp-Source: AGHT+IH4B/F3jSVT6Nn8xcRQnsJ1uiLuOsG9IZM1z8u2NT76JtjnCTm3iCfolyAhImJmOOQWCLxEEJfWlt1eadUfIHE=
X-Received: by 2002:a05:6808:4d9:b0:3b2:e5f2:5a59 with SMTP id
 a25-20020a05680804d900b003b2e5f25a59mr797519oie.35.1698358356906; Thu, 26 Oct
 2023 15:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
 <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
 <616a6fd7-47b1-4b46-af23-46f9b1a3eedf@linux.microsoft.com>
In-Reply-To: <616a6fd7-47b1-4b46-af23-46f9b1a3eedf@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 26 Oct 2023 18:12:26 -0400
Message-ID: <CAHC9VhScdtqJeUTTUQVk4D70tTLz4TgU_aRTMRnHa0OARyubaw@mail.gmail.com>
Subject: Re: [PATCH RFC v11 5/19] ipe: introduce 'boot_verified' as a trust
 provider
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 26, 2023 at 5:33=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On 10/23/2023 8:52 PM, Paul Moore wrote:
> > On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> >>
> >> IPE is designed to provide system level trust guarantees, this usually
> >> implies that trust starts from bootup with a hardware root of trust,
> >> which validates the bootloader. After this, the bootloader verifies th=
e
> >> kernel and the initramfs.
> >>
> >> As there's no currently supported integrity method for initramfs, and
> >> it's typically already verified by the bootloader, introduce a propert=
y
> >> that causes the first superblock to have an execution to be "pinned",
> >> which is typically initramfs.
> >>
> >> When the "pinned" device is unmounted, it will be "unpinned" and
> >> `boot_verified` property will always evaluate to false afterward.
> >>
> >> We use a pointer with a spin_lock to "pin" the device instead of rcu
> >> because rcu synchronization may sleep, which is not allowed when
> >> unmounting a device.
> >>
> >> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> >> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ...
> >> ---
> >>   security/ipe/eval.c          | 72 ++++++++++++++++++++++++++++++++++=
+-
> >>   security/ipe/eval.h          |  2 +
> >>   security/ipe/hooks.c         | 12 ++++++
> >>   security/ipe/hooks.h         |  2 +
> >>   security/ipe/ipe.c           |  1 +
> >>   security/ipe/policy.h        |  2 +
> >>   security/ipe/policy_parser.c | 35 +++++++++++++++++-
> >>   7 files changed, 124 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> >> index 8a8bcc5c7d7f..bdac4abc0ddb 100644
> >> --- a/security/ipe/eval.c
> >> +++ b/security/ipe/eval.c
> >> @@ -9,6 +9,7 @@
> >>   #include <linux/file.h>
> >>   #include <linux/sched.h>
> >>   #include <linux/rcupdate.h>
> >> +#include <linux/spinlock.h>
> >>
> >>   #include "ipe.h"
> >>   #include "eval.h"
> >> @@ -16,6 +17,44 @@
> >>
> >>   struct ipe_policy __rcu *ipe_active_policy;
> >>
> >> +static const struct super_block *pinned_sb;
> >> +static DEFINE_SPINLOCK(pin_lock);
> >> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> >> +
> >> +/**
> >> + * pin_sb - Pin the underlying superblock of @f, marking it as truste=
d.
> >> + * @sb: Supplies a super_block structure to be pinned.
> >> + */
> >> +static void pin_sb(const struct super_block *sb)
> >> +{
> >> +    if (!sb)
> >> +            return;
> >> +    spin_lock(&pin_lock);
> >> +    if (!pinned_sb)
> >> +            pinned_sb =3D sb;
> >> +    spin_unlock(&pin_lock);
> >> +}
> >> +
> >> +/**
> >> + * from_pinned - Determine whether @sb is the pinned super_block.
> >> + * @sb: Supplies a super_block to check against the pinned super_bloc=
k.
> >> + *
> >> + * Return:
> >> + * * true   - @sb is the pinned super_block
> >> + * * false  - @sb is not the pinned super_block
> >> + */
> >> +static bool from_pinned(const struct super_block *sb)
> >> +{
> >> +    bool rv;
> >> +
> >> +    if (!sb)
> >> +            return false;
> >> +    spin_lock(&pin_lock);
> >> +    rv =3D !IS_ERR_OR_NULL(pinned_sb) && pinned_sb =3D=3D sb;
> >> +    spin_unlock(&pin_lock);
> >
> > It's okay for an initial version, but I still think you need to get
> > away from this spinlock in from_pinned() as quickly as possible.
> > Maybe I'm wrong, but this looks like a major source of lock contention.
> >
> > I understand the issue around RCU and the potential for matching on
> > a reused buffer/address, but if you modified IPE to have its own LSM
> > security blob in super_block::security you could mark the superblock
> > when it was mounted and do a lockless lookup here in from_pinned().
>
> Thank you for the suggestion. After some testing, I discovered that
> switching to RCU to pin the super block and using a security blob to
> mark a pinned super block works. This approach do avoid many spinlock
> operations. I'll incorporate these changes in the next version of the pat=
ch.

I probably wasn't as clear as I should have been, I was thinking of
doing away with the @pinned_sb global variable entirely, as well as
its associated lock problems and simply marking the initramfs/initrd
superblock when it was mounted.  I will admit that I haven't fully
thought about all the implementation details, but I think you could
leverage the security_sb_mount() hook to set a flag in IPE's
superblock metadata when the initramfs was mounted.

--
paul-moore.com

