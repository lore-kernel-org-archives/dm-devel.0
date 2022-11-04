Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC94C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667575112;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xqbV7+v9g1fr96ojFevFxoUz463c9ugOLxxabFxLhNo=;
	b=JTutaPQ1DyKOgcxvOxarxenT2foz1Ru5e2Kf54nF2r+doCWLHg8QpStxG13kiJzSFqCTMz
	+7pyyecDVFn09//byqrdJnfug8EfDjsTVOHxz1ebRjQBIu4bXhmg/gm9d0CjoSBvTH6f5U
	R5ua3Pj51lhBjr+EURCbv65xY/plBLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-2HMdSG0ZOYaSpkOoV8BcmA-1; Fri, 04 Nov 2022 11:18:28 -0400
X-MC-Unique: 2HMdSG0ZOYaSpkOoV8BcmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B15FF857F8F;
	Fri,  4 Nov 2022 15:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26F034A9254;
	Fri,  4 Nov 2022 15:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00F2B1946587;
	Fri,  4 Nov 2022 15:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 771EC1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 15:18:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 554A02166B48; Fri,  4 Nov 2022 15:18:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DEF22166B26
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 15:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26D71101A528
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 15:18:24 +0000 (UTC)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-7s2jM0eZP0GjfyesxSeiHQ-1; Fri, 04 Nov 2022 11:18:23 -0400
X-MC-Unique: 7s2jM0eZP0GjfyesxSeiHQ-1
Received: by mail-pf1-f200.google.com with SMTP id
 z19-20020a056a001d9300b0056df4b6f421so2604657pfw.4
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 08:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=/3Emx964qE4HALN/piAaGa3Aj8/+sF9ota+IP7QVzDA=;
 b=D6P20brR2v4ZoKY12CKXTCPY3SaT4XSnAZ5QW4diIeHJ78nE6CYfJwL8GRwx9CBKs4
 jBzuQA8aAn2peBApw4ACTO2utKYv0p441Qok6NQkJy8zJBqFFY3PKx1Zc3QIKF16X2Jv
 RM9Lu40ZrXJtiiPAMXoLIa5RHRKKKP2mzU9uF5lSElKp5Bggc4JlkpJj7VcqzTNLY0DE
 H8l9Bcgvg9phE371HZ4nOD6fLMxdsfpBO8LXwz76Nk3FphTgFbJ39z5bsD/RZraMWFG7
 rSqE6rGOd4HW/h15ssGM+zWbIFYMLOEP1UKAAN4NnmMlGkMjEYL+5oQF4oENVCI6D43W
 5HFQ==
X-Gm-Message-State: ACrzQf2BKa0Sx7AKFOVrKXHz5P2xRO2itTryL9ZiJaN/fZ4KvBxBlysf
 f6NSOjBX3F21l6rh6NYDWmMWUJTacK5GjyFzXgNE2ZI/Y8opVgKv3lm4ZoTZbUiOitu7Brw6tZQ
 aMfnG6OERpH8XYzecTQGA95hzKxC5Wn8=
X-Received: by 2002:a17:902:da82:b0:186:ee5a:47c7 with SMTP id
 j2-20020a170902da8200b00186ee5a47c7mr36394694plx.82.1667575101847; 
 Fri, 04 Nov 2022 08:18:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5bL8EYaAoAE9Jtgs/T/s7qCSO5P84GoMtpgEPZ9/i9XWkv3n+6iLAc50+11huhaYdtpC3GKVnQwvLzzzafgxg=
X-Received: by 2002:a17:902:da82:b0:186:ee5a:47c7 with SMTP id
 j2-20020a170902da8200b00186ee5a47c7mr36394671plx.82.1667575101527; Fri, 04
 Nov 2022 08:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
 <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
 <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
In-Reply-To: <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 4 Nov 2022 23:18:10 +0800
Message-ID: <CALTww2-q0xbMSf2FW9TBkSOeoHuOffQvFyJN5MbLGtx=AF3q1w@mail.gmail.com>
To: Zdenek Kabelac <zkabelac@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Guoqing Jiang <guoqing.jiang@linux.dev>,
 Heming Zhao <heming.zhao@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 4, 2022 at 7:10 PM Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
> Dne 04. 11. 22 v 2:23 Guoqing Jiang napsal(a):
> >
> >
> > On 11/3/22 10:46 PM, Heming Zhao wrote:
> >> On 11/3/22 11:47 AM, Guoqing Jiang wrote:
> >>> Hi,
> >>>
> >>> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
> >>>> Hi
> >>>>
> >>>> There's a crash in the test shell/lvchange-rebuild-raid.sh when running
> >>>> the lvm testsuite. It can be reproduced by running "make check_local
> >>>> T=shell/lvchange-rebuild-raid.sh" in a loop.
> >>>
> >>> I have problem to run the cmd (not sure what I missed), it would be better if
> >>> the relevant cmds are extracted from the script then I can reproduce it with
> >>> those cmds directly.
> >>>
> >>> [root@localhost lvm2]# git log | head -1
> >>> commit 36a923926c2c27c1a8a5ac262387d2a4d3e620f8
> >>> [root@localhost lvm2]# make check_local T=shell/lvchange-rebuild-raid.sh
> >>> make -C libdm device-mapper
> >>> [...]
> >>> make -C daemons
> >>> make[1]: Nothing to be done for 'all'.
> >>> make -C test check_local
> >>> VERBOSE=0 ./lib/runner \
> >>>          --testdir . --outdir results \
> >>>          --flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh
> >>> --skip @
> >>> running 1 tests
> >>> ###      running: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0
> >>> | [ 0:00] lib/inittest: line 133:
> >>> /tmp/LVMTEST317948.iCoLwmDhZW/dev/testnull: Permission denied
> >>> | [ 0:00] Filesystem does support devices in
> >>> /tmp/LVMTEST317948.iCoLwmDhZW/dev (mounted with nodev?)
> >>
> >> I didn't read other mails in this thread, only for above issue.
> >> If you use opensuse, systemd service tmp.mount uses nodev option to mount
> >> tmpfs on /tmp.
> >> From my experience, there are two methods to fix(work around):
> >> 1. systemctl disable tmp.mount && systemctl mask tmp.mount && reboot
> >> 2. mv /usr/lib/systemd/system/tmp.mount /root/ && reboot
> >
> > I am using centos similar system, I can try leap later. Appreciate for the
> > tips, Heming.
>
>
> You can always redirect default /tmp dir to some other place/filesystem that
> allows you to create /dev nodes. Eventually for 'brave men'  you can let lvm2
> test suite to play directly with your /dev dir.  Normally nothing bad should
> happen, but we tend to prefer more controled '/dev' managed for a test.
>
> Here are two envvars to play with:
>
>
> make check_local T=shell/lvchange-rebuild-raid.sh LVM_TEST_DIR=/myhomefsdir
> LVM_TEST_DEVDIR=/dev
>
> LVM_TEST_DIR for setting of dir where test creates all its files
>
> LVM_TEST_DEVDIR  you can explicitly tell to keep using system's /dev
> (instead of dir created within tmpdir)

Hi Zdenek

I tried this command and the test was skipped. Does it need to add
more options for
the command?

make check_local T=shell/lvchange-rebuild-raid.sh
LVM_TEST_DIR=/root/test  LVM_TEST_DEVDIR=/dev

VERBOSE=0 ./lib/runner \
--testdir . --outdir results \
--flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh --skip @
running 1 tests
###      skipped: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0

### 1 tests: 0 passed, 1 skipped, 0 timed out, 0 warned, 0 failed

Regards
Xiao

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

