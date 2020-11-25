Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76B4C56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0613520B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0613520B80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-wNPl4whPPKaJT60zOyMwmg-1; Thu, 26 Nov 2020 03:36:43 -0500
X-MC-Unique: wNPl4whPPKaJT60zOyMwmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C67D39A23D;
	Thu, 26 Nov 2020 08:36:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACCDD189B4;
	Thu, 26 Nov 2020 08:36:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86AD350031;
	Thu, 26 Nov 2020 08:36:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APN2obW016188 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 18:02:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 630911004160; Wed, 25 Nov 2020 23:02:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F08D1004C76
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 23:02:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8BA3103B808
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 23:02:47 +0000 (UTC)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
	[209.85.221.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-535-ZAyohjYAMUmPhiZnBjG1xQ-1; Wed, 25 Nov 2020 18:02:45 -0500
X-MC-Unique: ZAyohjYAMUmPhiZnBjG1xQ-1
Received: by mail-wr1-f66.google.com with SMTP id r3so108818wrt.2;
	Wed, 25 Nov 2020 15:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=ha42UWMtlXOL8kfvC1XpFKttY73p7G2gxviD5bIo2Ac=;
	b=d08v9Rodz1zF2un1uwrZ7F0kxweMXZp9hJ/SxuIWxBNAOlUGRCeRSCuFJ0198ZR982
	EW+N8nZ3QPOm0WIhnxQx7Oye/l5XZLafncFigGBlnHy16VUx0sxGGZeMO8mCjEL88u/j
	4skurT3p+ahf1DqGzUpQ8ZvuuGC3DweJB0llEVGzvmLvmqKLBLIr6QmDwLeWypVYW/Pf
	fcbfbNf0RGGVbi6PQXdY4Ivcii1PNAuH69VIMFKc9FltxOGmyj15q9Bqjkf+M+WNv6wD
	/fqBiveAnRTYO84nD9gXztYi6ccXmihvMb+FGyqdkdQT/oZn4DkhPQxhkUKptwep6oPu
	wC3w==
X-Gm-Message-State: AOAM532yGtcxs0bSqig1L3MFFjag4FkGWyUcRZRNO9GHsNyc3wL2+FyE
	yEmSFIKhUyw7UQA794KZlNs=
X-Google-Smtp-Source: ABdhPJzir63ZhkohioP0Ktx42tkGcEWW5m4eKxg+CUjAscHddZDwqHZSdjbm/E0JNHFBggGwkKFODQ==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr180470wrs.235.1606345364309; 
	Wed, 25 Nov 2020 15:02:44 -0800 (PST)
Received: from [192.168.1.122]
	(cpc92720-cmbg20-2-0-cust364.5-4.cable.virginm.net. [82.21.83.109])
	by smtp.gmail.com with ESMTPSA id
	u129sm5552667wme.9.2020.11.25.15.02.41
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 25 Nov 2020 15:02:43 -0800 (PST)
To: Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>
References: <cover.1605896059.git.gustavoars@kernel.org>
	<20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011201129.B13FDB3C@keescook>
	<20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011220816.8B6591A@keescook>
	<CAKwvOdntVfXj2WRR5n6Kw7BfG7FdKpTeHeh5nPu5AzwVMhOHTg@mail.gmail.com>
	<202011241324.B3439A2@keescook>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <99a9ffd7-6356-b81d-6e08-7ed74b6fb82c@gmail.com>
Date: Wed, 25 Nov 2020 23:02:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
	Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <202011241324.B3439A2@keescook>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 26 Nov 2020 03:35:50 -0500
Cc: alsa-devel@alsa-project.org, linux-atm-general@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
	linux-iio@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
	linux-fbdev@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Nathan Chancellor <natechancellor@gmail.com>,
	linux-ide@vger.kernel.org, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net, linux-afs@lists.infradead.org,
	usb-storage@lists.one-eyed-alien.net,
	target-devel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
	oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
	linux-security-module@vger.kernel.org,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, linux-acpi@vger.kernel.org,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, linux-ext4@vger.kernel.org,
	linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org,
	selinux@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, linux-geode@lists.infradead.org,
	linux-can@vger.kernel.org, linux-block@vger.kernel.org,
	linux-gpio@vger.kernel.org, op-tee@lists.trustedfirmware.org,
	linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-hwmon@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	tipc-discussion@lists.sourceforge.net,
	Linux Memory Management List <linux-mm@kvack.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	linux-sctp@vger.kernel.org, linux-usb@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
	<linux-crypto@vger.kernel.org>, patches@opensource.cirrus.com,
	Joe Perches <joe@perches.com>, linux-integrity@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 000/141] Fix fall-through warnings for Clang
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjQvMTEvMjAyMCAyMToyNSwgS2VlcyBDb29rIHdyb3RlOgo+IEkgc3RpbGwgdGhpbmsgdGhp
cyBpc24ndCByaWdodCAtLSBpdCdzIGEgY2FzZSBzdGF0ZW1lbnQgdGhhdCBydW5zIG9mZgo+IHRo
ZSBlbmQgd2l0aG91dCBhbiBleHBsaWNpdCBmbG93IGNvbnRyb2wgZGV0ZXJtaW5hdGlvbi4KClBy
b3ZlcyB0b28gbXVjaCDigJQgZm9yIGluc3RhbmNlCiAgICBjYXNlIGZvbzoKICAgIGNhc2UgYmFy
OgogICAgICAgIHRoaW5nOwogICAgICAgIGJyZWFrOwogZG9lc24ndCByZXF1aXJlIGEgZmFsbHRo
cm91Z2g7IGFmdGVyIGNhc2UgZm9vOiwgYW5kIGFmYWlrCiBuby1vbmUgaXMgc3VnZ2VzdGluZyBp
dCBzaG91bGQuICBZZXQgaXQsIHRvbywgaXMgImEgY2FzZQogc3RhdGVtZW50IHRoYXQgcnVucyBv
ZmYgdGhlIGVuZCB3aXRob3V0IGFuIGV4cGxpY2l0IGZsb3cKIGNvbnRyb2wgZGV0ZXJtaW5hdGlv
biIuCgotZWQKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

