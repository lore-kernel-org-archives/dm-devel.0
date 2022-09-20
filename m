Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC92C6FA8B
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 08:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663749247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=YRMwbY/krUKwPFA0yTr6Jp2Y/H+BCP0pmLJ0l3erMw4=;
	b=b+gWEv4y0qFC4SYSA066Rh58mEK/E1g9PKxusu9076JTdc/uHdxrROChUZHHkwYQSmm4d2
	8dmrF8WFbC/lMbnwDlC+jo9OJNBeKqck+hkQ+ZofDWqJosCW1uVzYAAS1Jpki+meiqk0JF
	1GozE70jy2s5y+FAPxQkOqutdNs+Mq8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-wRD-f0wQMt-Zzj9IzfRqUw-1; Wed, 21 Sep 2022 04:34:03 -0400
X-MC-Unique: wRD-f0wQMt-Zzj9IzfRqUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C54685530F;
	Wed, 21 Sep 2022 08:34:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09480111E3E4;
	Wed, 21 Sep 2022 08:33:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7DDBC1946A4F;
	Wed, 21 Sep 2022 08:33:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 847B71946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 21:49:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 28DD62166B29; Tue, 20 Sep 2022 21:49:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21E1D2166B26
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 21:49:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04875811E87
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 21:49:04 +0000 (UTC)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com
 [209.85.217.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330-Ca0X39e0PUC_vCJnzuKm2g-1; Tue, 20 Sep 2022 17:49:02 -0400
X-MC-Unique: Ca0X39e0PUC_vCJnzuKm2g-1
Received: by mail-vs1-f53.google.com with SMTP id q26so4678894vsr.7
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 14:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=xZRFtIc/g2m7iZsFBvMJ+o07FqK7dUHFb8Gf16uV9jI=;
 b=5moJwBqvsOlLOISytj8a86/evVUUHgWIAoJ+idVzLcIUKNxOlZwip4bDrHZZrNmmAe
 pGEo0jPWpZ8nMuXX4NDa4K4zmW0cRMX9bykTngEKTsp0/5vNgYkn7E2QHiy6S98P1DBV
 XMvq6rpS3+S2hoo93rtsO5YkgaO37kH2TSLkplivr9Cmm0nGmuX0lt7D3Ch34wEve4rU
 FL/y5K7XKMPP6XeyQ9O4H+0w2KfgSgk1KkDxCnypXNsUG0gim3tqYaaLvDsJigUmxzQH
 /kCgMW2z/AGuMNAq0DLQB5vud/mkvlMsoUVJ+2ZoYnfX19nIgjFR4fJyEW77AyLPPIil
 SJNQ==
X-Gm-Message-State: ACrzQf1/mflVY9Za49+WWNGBN8l7FPdGuLW02ckIN2a2KE5Pq59Bqn5y
 4TCNA0Jt6b0pHUk0RsqCgANEK7K50krBrnraOdml
X-Google-Smtp-Source: AMsMyM5040FJiNDCwJVgqW7ElbaDPw20C+QA7KFYMAVpGstoAs9IYbgAS5Xhq1MLoZ91KEoz1YcM5WQFJTWWxe/7X9k=
X-Received: by 2002:a05:6102:3f55:b0:390:c753:3565 with SMTP id
 l21-20020a0561023f5500b00390c7533565mr9339014vsv.13.1663710541540; Tue, 20
 Sep 2022 14:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
 <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
 <Yylvvm3zVgqpqDrm@infradead.org>
 <CAAKderPF5Z5QLxyEb80Y+90+eR0sfRmL-WfgXLp=eL=HxWSZ9g@mail.gmail.com>
 <YymkSDsFVVg1nbDP@infradead.org>
In-Reply-To: <YymkSDsFVVg1nbDP@infradead.org>
From: Daniil Lunev <dlunev@google.com>
Date: Wed, 21 Sep 2022 07:48:50 +1000
Message-ID: <CAAKderNcHpbBqWqqd5-WuKLRCQQUt7a_4D4ti4gy15+fKGK0vQ@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 21 Sep 2022 08:33:55 +0000
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7311609851029143322=="

--===============7311609851029143322==
Content-Type: multipart/alternative; boundary="000000000000d6ea9c05e922cb65"

--000000000000d6ea9c05e922cb65
Content-Type: text/plain; charset="UTF-8"

> There is no such thing as WRITE UNAVAILABLE in NVMe.
Apologize, that is WRITE UNCORRECTABLE. Chapter 3.2.7 of
NVM Express NVM Command Set Specification 1.0b

> That being siad you still haven't actually explained what problem
> you're even trying to solve.

The specific problem is the following:
* There is an thinpool over a physical device
* There are multiple logical volumes over the thin pool
* Each logical volume has an independent file system and an
  independent application running over it
* Each application is potentially allowed to consume the entirety
  of the disk space - there is no strict size limit for application
* Applications need to pre-allocate space sometime, for which
  they use fallocate. Once the operation succeeded, the application
  assumed the space is guaranteed to be there for it.
* Since filesystems on the volumes are independent, filesystem
  level enforcement of size constraints is impossible and the only
  common level is the thin pool, thus, each fallocate has to find its
  representation in thin pool one way or another - otherwise you
  may end up in the situation, where FS thinks it has allocated space
  but when it tries to actually write it, the thin pool is already
  exhausted.
* Hole-Punching fallocate will not reach the thin pool, so the only
  solution presently is zero-writing pre-allocate.
* Not all storage devices support zero-writing efficiently - apart
  from NVMe being or not being capable of doing efficient write
  zero - changing which is easier said than done, and would take
  years - there are also other types of storage devices that do not
  have WRITE ZERO capability in the first place or have it in a
  peculiar way. And adding custom WRITE ZERO to LVM would be
  arguably a much bigger hack.
* Thus, a provisioning block operation allows an interface specific
  operation that guarantees the presence of the block in the
  mapped space. LVM Thin-pool itself is the primary target for our
  use case but the argument is that this operation maps well to
  other interfaces which allow thinly provisioned units.

--Daniil

--000000000000d6ea9c05e922cb65
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"></div><div class=3D"gmail_quote"><div>&gt=
; There is no such thing as WRITE UNAVAILABLE in NVMe.</div><div>Apologize,=
 that is WRITE UNCORRECTABLE. Chapter 3.2.7 of</div><div>NVM Express NVM Co=
mmand Set Specification 1.0b<br></div><div><br></div><div>&gt; That being s=
iad you still haven&#39;t actually explained what problem</div><div>&gt; yo=
u&#39;re even trying to solve.=C2=A0</div></div><div><br></div>The specific=
 problem is the following:=C2=A0<div>* There is an thinpool=C2=A0over a phy=
sical device</div><div>* There are multiple logical volumes over the thin p=
ool</div><div>* Each logical volume has an independent file system and an</=
div><div>=C2=A0 independent=C2=A0application running over it</div><div>* Ea=
ch application is potentially allowed to consume the entirety</div><div>=C2=
=A0 of the disk space - there is no strict size limit for application</div>=
<div>* Applications need to pre-allocate space sometime, for which</div><di=
v>=C2=A0 they use fallocate. Once the operation succeeded, the application<=
/div><div>=C2=A0 assumed the space is guaranteed=C2=A0to be there for it.</=
div><div>* Since filesystems on the volumes are independent, filesystem</di=
v><div>=C2=A0 level enforcement of size constraints is impossible and the o=
nly</div><div>=C2=A0 common level is the thin pool, thus, each fallocate ha=
s to find its</div><div>=C2=A0 representation in thin pool one way or anoth=
er - otherwise you</div><div>=C2=A0 may end up in the situation, where FS t=
hinks it has allocated space</div><div>=C2=A0 but when it tries to actually=
 write it, the thin pool is already</div><div>=C2=A0 exhausted.</div><div>*=
 Hole-Punching fallocate will not reach the thin pool, so the only</div><di=
v>=C2=A0 solution presently is zero-writing pre-allocate.</div><div>* Not a=
ll storage devices support zero-writing efficiently - apart</div><div>=C2=
=A0 from NVMe being or not being capable of doing efficient write</div><div=
>=C2=A0 zero - changing which is easier said than done, and would take=C2=
=A0</div><div>=C2=A0 years - there are also other types of storage devices =
that do not</div><div>=C2=A0 have WRITE ZERO capability in the first place =
or have it in a</div><div>=C2=A0 peculiar way. And adding custom WRITE ZERO=
 to LVM would be</div><div>=C2=A0 arguably a much bigger hack.</div><div>* =
Thus, a provisioning block operation allows an interface specific</div><div=
>=C2=A0 operation that guarantees the presence of the block in the</div><di=
v>=C2=A0 mapped space. LVM Thin-pool itself is the primary target for our</=
div><div>=C2=A0 use case but the argument is that this operation maps well =
to</div><div>=C2=A0 other interfaces which allow thinly=C2=A0provisioned un=
its.</div><div><div><div><br clear=3D"all"><div>--Daniil</div></div></div><=
/div></div>

--000000000000d6ea9c05e922cb65--

--===============7311609851029143322==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7311609851029143322==--

