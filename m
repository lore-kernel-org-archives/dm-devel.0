Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC32CCA485
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178896;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AboTauQiPA/JYxSD7fIUQ1qrcSnZa1yU/NnavPmbgg4=;
	b=QPZ5UXquIZYhUpZzfqwQ6P7whjYp6DRTYKxdb6Q6YvE/DbuN8RvNp0hAs+lEF1g9+hhS0c
	MXS+OvRrRzQDigVXTs1QkjLEoUEcvLt2MjXmzfiqveNeDJ9wqBuU83TIe7/2slCREu6hfY
	Zp6K4rEsLMTSA3mal6tli9DL41UzX8o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-eOoefn2INOGsBzpDQI2QMw-1; Thu, 07 Jul 2022 03:28:13 -0400
X-MC-Unique: eOoefn2INOGsBzpDQI2QMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B404F1034ADA;
	Thu,  7 Jul 2022 07:28:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1FA52026D64;
	Thu,  7 Jul 2022 07:28:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E1231947072;
	Thu,  7 Jul 2022 07:28:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B9771947040
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Jul 2022 03:26:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DE6840334D; Sun,  3 Jul 2022 03:26:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59DCD416362
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 03:26:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 424AC185A7A4
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 03:26:27 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-8bRWMlGgNaaN_TFJ8xfEvw-1; Sat, 02 Jul 2022 23:26:23 -0400
X-MC-Unique: 8bRWMlGgNaaN_TFJ8xfEvw-1
Received: by mail-pj1-f47.google.com with SMTP id o15so1751576pjh.1;
 Sat, 02 Jul 2022 20:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/LE3/OvnxwC10hHaqp2JoOJSN7rfZOpUu2WCyCiyCz4=;
 b=MEFGQXGnnk6W6ABy966ZS2Bdq7xbyyF+Fgz2L4ZmNsv8keeVdZsj6y8mllSXXvKaXe
 GCZRJJO2g5fZTd1JunEBzy2AuMANWqHqXWrw4oBhn1OfhoqSSwX3gib2DlzT2qhoyPyu
 UC21QkMYCZTTdgIs1132JQAzxeuuRAkmIcdr8Q5ZYqKN9OkJyqNTzkr9w9aarHztG0X5
 +20wnmo42NVpAaLruE6vOaPHCbyev+yWlmE9nt/TpCM9CBOvs3XPYS/jEer0nrP/3Cu2
 coHumVsWs5J6vYJ3rR86RLmGwg15N6pgO2nJ6ikEnxCzfOenx4ayofH4M91ae+gB3EOG
 x0NA==
X-Gm-Message-State: AJIora9drBvSWjArLfIvcRXcJNOyvxECtne0A2pTfjsJyZ5KaJHLQAh9
 dQNQG7q/d548NpGz9UJxD8A=
X-Google-Smtp-Source: AGRyM1v/qGK0NX2/G7uiSvuhmywhBxQ+rRzGPCB7tQOWN8p4Gfx3qW4Qvkfllc0ImMReMYjkXPk5jA==
X-Received: by 2002:a17:903:2c6:b0:16a:276a:ad81 with SMTP id
 s6-20020a17090302c600b0016a276aad81mr29074812plk.65.1656818782428; 
 Sat, 02 Jul 2022 20:26:22 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-33.three.co.id. [116.206.28.33])
 by smtp.gmail.com with ESMTPSA id
 u17-20020a170902e81100b0016a0db8c5b4sm1866809plg.156.2022.07.02.20.26.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Jul 2022 20:26:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id EA78810390C; Sun,  3 Jul 2022 10:26:16 +0700 (WIB)
Date: Sun, 3 Jul 2022 10:26:16 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Message-ID: <YsEMWDYCdjxiUZ1P@debian.me>
References: <cover.1656759988.git.mchehab@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1656759988.git.mchehab@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 00/12] Fix several documentation build
 warnings with Sphinx 2.4.4
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
Cc: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
 Gwendal Grignou <gwendal@chromium.org>, kvm@vger.kernel.org,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-pci@vger.kernel.org,
 Brendan Higgins <brendanhiggins@google.com>, alsa-devel@alsa-project.org,
 Jaroslav Kysela <perex@perex.cz>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-kselftest@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Takashi Iwai <tiwai@suse.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-tegra@vger.kernel.org, kunit-dev@googlegroups.com,
 linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Eric Dumazet <edumazet@google.com>, Dipen Patel <dipenp@nvidia.com>,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 02, 2022 at 12:07:32PM +0100, Mauro Carvalho Chehab wrote:
> This series is against next-20220701. It fixes several warnings
> that are currently produced while building html docs.
> 
> Each patch in this series is independent from the others, as
> each one touches a different file.
> 
> Mauro Carvalho Chehab (12):
>   docs: ext4: blockmap.rst: fix a broken table
>   docs: tegra194-hte.rst: don't include gpiolib.c twice
>   docs: device-mapper: add a blank line at writecache.rst
>   docs: PCI: pci-vntb-function.rst: Properly include ascii artwork
>   docs: PCI: pci-vntb-howto.rst: fix a title markup
>   docs: virt: kvm: fix a title markup at api.rst
>   docs: ABI: sysfs-bus-nvdimm
>   kunit: test.h: fix a kernel-doc markup
>   net: mac80211: fix a kernel-doc markup
>   docs: alsa: alsa-driver-api.rst: remove a kernel-doc file
>   docs: arm: index.rst: add google/chromebook-boot-flow
>   docs: leds: index.rst: add leds-qcom-lpg to it
> 

Hi Mauro,

Thanks for cleaning up these warning above. However, I have already
submitted some of these cleanups (pending reviews or integration):

[1]: https://lore.kernel.org/linux-doc/20220702042350.23187-1-bagasdotme@gmail.com/
[2]: https://lore.kernel.org/linux-doc/20220612000125.9777-1-bagasdotme@gmail.com/
[3]: https://lore.kernel.org/linux-doc/20220627095151.19339-1-bagasdotme@gmail.com/
[4]: https://lore.kernel.org/linux-doc/20220627082928.11239-1-bagasdotme@gmail.com/

There's still a warning left:

Documentation/ABI/testing/sysfs-bus-iio-sx9324:2: WARNING: Unexpected indentation.

But I think the Date: field that triggered the warning above looks OK.

Regardless of that, the build successed.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

