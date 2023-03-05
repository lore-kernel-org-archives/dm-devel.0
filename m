Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEB9C678D4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 06:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678085343;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xrPM9zKVV/gC8r/tduBxV6J/iyX9kSwow+wd+W7rarM=;
	b=B+XUIchG68anutMIUgbDcSItwF4NMYP1JD3XNoVIzhr/XpUWjg6TF5iS6WFws0hE/BthtV
	6Pa9SQIbjhBHeNmhJ5Twf9WM5vxVFb0yBlW4YjUQF88O87Wu9SoQQ9c+IE7tXnC/86ucQL
	1s5gZyTuWh0mHCSQQdxo4cZN7SSm2Bo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-mRrOZkhiMoS9GVX_YMcv8g-1; Mon, 06 Mar 2023 01:49:00 -0500
X-MC-Unique: mRrOZkhiMoS9GVX_YMcv8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B97C1869B6F;
	Mon,  6 Mar 2023 06:48:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 996351121314;
	Mon,  6 Mar 2023 06:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87F41194658C;
	Mon,  6 Mar 2023 06:48:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 683A61946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 20:40:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45F4DC1602A; Sun,  5 Mar 2023 20:40:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E20DC16029
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 20:40:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 218D585A588
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 20:40:09 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com
 [66.111.4.27]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-NOiqmEkfNpuJhH8JU5fBfA-1; Sun, 05 Mar 2023 15:40:05 -0500
X-MC-Unique: NOiqmEkfNpuJhH8JU5fBfA-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.nyi.internal (Postfix) with ESMTP id 46AC75C0046;
 Sun,  5 Mar 2023 15:40:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
 by compute1.internal (MEProxy); Sun, 05 Mar 2023 15:40:05 -0500
X-ME-Sender: <xms:JP4EZFiQsQAjKE10Ly2MBHPOOWmMrX2Zm9nN7o61l3mxLYgNVb_V1w>
 <xme:JP4EZKChX3yWqjOmBnxWSvLxDYyuN6zPhfy15wQ3edBuvumFBat5PvBf_Amwvt_yK
 OHgZaxyltoQyDU>
X-ME-Received: <xmr:JP4EZFHpzZaLWxOUC-hCHrdwIuaLmgUifKE0YJEFBIl51cOH8QTqduX19Bs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddtgedgudeflecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvvefukfhrgggtsehttdertddttddvnecuhfhrohhmpeffvghmihcu
 ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
 hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpefhleetjeefvdegieevjedtteduieel
 feeileejleeuhfehleegudduleefuefhjeenucevlhhushhtvghrufhiiigvpedtnecurf
 grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
 rggsrdgtohhm
X-ME-Proxy: <xmx:Jf4EZKSJ2s44HSDlymYwMGNUhbJmAIIg-Kh6KDd8CagRdcAMysanzA>
 <xmx:Jf4EZCy3KcK_ZnWy4WfwfDFLqDj-PBo_ZIpPTaPdTv4hcPyl0g92Eg>
 <xmx:Jf4EZA4iy6v6FAfR9GoTly-CeqQyZmn-QUlO5TLdM3Eet1cp_tzbbw>
 <xmx:Jf4EZG97BNOSUajl13mpdo9IkYw1Vodv9ZZNpP6Iz31tfvM7QP1nVA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Mar 2023 15:40:04 -0500 (EST)
Date: Sun, 5 Mar 2023 15:40:02 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <ZAT+IoCfuZtRnnhm@itl-email>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 06 Mar 2023 06:48:55 +0000
Subject: [dm-devel] Thin pool CoW latency
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
Reply-To: CAJ0trDYAyHHh2crMAQuQPMt3FzFmii0nmLnsL5N-cdhfvWZnMg@mail.gmail.com
Cc: dm-devel@lists.ewheeler.net, "development,
 device-mapper" <dm-devel@redhat.com>,
 Qubes OS Development Mailing List <qubes-devel@googlegroups.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Like Eric, I am very concerned about CoW latency and throughput.  I
am almost certain that allocating new blocks and snapshot copy-on-write
are _the_ hot paths in Qubes OS.  In particular, I suspect that
workloads such as building an image in a throwaway VM or installing
packages onto a root volume that had just been shapshotted are dominated
by metadata operations, rather than by in-place updates.  I suspect that
frequently-snapshotted volumes will observe similar behavior in general.
- -- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmQE/iEACgkQsoi1X/+c
IsHLFxAAyWT4SlSueR15VxrwG07T9cEl7vnQwKHKWdzFBoWl0KhvyjLr52t0ip1J
HPmwTVaor+53E+0bLUlgqA7G56a6PwxWWAQ6CsHHdxQ1xo3Serigkhys2hmwRq+e
WPVrDSVRQLzOj/Qg6MsF2PPzdL5aNjK2QeHnWVcyXvfwZDhDCJKzz2iJC/ENjFNW
X2bD3wazu6A+aFsxjLHtf5wAa0+PhppcEhUZNSgQiC9SiT5DPFabLIIi7jgb0Nlg
v5GciAp1w0J+SUq2Wh4atrPR11Sj878AnJ872/Ku+pLseVu8h7N/60p8OwBm47Ak
GNZlgq7XF1lien/3eFq9mfJKGc97MxveEkiqI46ankVs+bDQOlUbXriMlINEeT8r
AzCar8pYx5W/xFb/gvYPnksATlOxLAaQ1jPZ1j0dIRaPtoOngtQ64TC5alRirGCK
uqQ7c1Soj7D3SjahrbQkoqcyODmRoC/55Pu8Klb2l96S91rSRtvca+EV05GNXmyN
eaArdGNuWPmzq6E8mQj3YrYnn18Z/x3WRr77xGVTAjUCGDPCE01+o/0G9P/+4cpv
olMs1/ludL/WzbBe9scp2JK442dGwE/pcBiWI34DmxbLZTb1baG4BEX6mbDdfnpk
SmIQv1RcHtbf16nvuhg+QVXnjAL5qQNiGVWxF9PTH8799wmcsdM=
=/KY9
-----END PGP SIGNATURE-----

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

