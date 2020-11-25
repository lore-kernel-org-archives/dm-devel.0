Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B8EC64E7A
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D9A82173E
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D9A82173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-GaYjExMbOD-ME5B7KKaGXQ-1; Thu, 26 Nov 2020 03:36:50 -0500
X-MC-Unique: GaYjExMbOD-ME5B7KKaGXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 575A6107464B;
	Thu, 26 Nov 2020 08:36:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AED45B4A0;
	Thu, 26 Nov 2020 08:36:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EC80550034;
	Thu, 26 Nov 2020 08:36:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APMijkx014987 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 17:44:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 438F380572; Wed, 25 Nov 2020 22:44:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DC2D10BDF
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 22:44:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE969100FBCC
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 22:44:42 +0000 (UTC)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
	[209.85.128.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-285-lVWjNjy7MC62aP3wYEQU6w-1; Wed, 25 Nov 2020 17:44:40 -0500
X-MC-Unique: lVWjNjy7MC62aP3wYEQU6w-1
Received: by mail-wm1-f67.google.com with SMTP id w24so256771wmi.0;
	Wed, 25 Nov 2020 14:44:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=mMrMdknFbsC77SFRvwwD3pm1cwl3V2MP65kzVJE6tY4=;
	b=SgqEni9iE22y9axrMOWmtr8BLfVwwx26poeHJy8KZdXd/UY995GW7SYA5FS59sUn+P
	tBFzNzBYBfDvUdPjN5Qduh5XQO4vNO4n1r32y8v9928LgXXv2iyZBbIn8OBu4S8DIv7C
	6oOScyxfpAbdRlcMIaSg4nJFiFoGJsw/8+hzG+FPR4nnI++USxvnktFSfBI6Jlwuuoh1
	G7xXrw/0EWdPtHHEKk0U52vZi+QnORoBMg+ZqOP7guW6Quj48FT1xipMNl5EFZ3Ahird
	G2rmrcduT+HFUj54/a+VTDJ0jVAGIuFfy5SHY3oHvRCKpfevucGr0vjmJCbOWaSt/vX/
	3NcA==
X-Gm-Message-State: AOAM5334NdLzbaSPQCx4Yv9RdE9LrAzbIE+BrMW8sVon7ibMuSyAcpcV
	SocpaJ6sIad35wnt+zviRtg=
X-Google-Smtp-Source: ABdhPJzVXPr1uOlB1vaw2cfl6zSoOiLq1F6oo5r6Yg/UanqxqpZONWe00UKvdrBaRFZ4o0pgYT/ByA==
X-Received: by 2002:a7b:cf0a:: with SMTP id l10mr6364382wmg.103.1606344279394; 
	Wed, 25 Nov 2020 14:44:39 -0800 (PST)
Received: from [192.168.1.122]
	(cpc92720-cmbg20-2-0-cust364.5-4.cable.virginm.net. [82.21.83.109])
	by smtp.gmail.com with ESMTPSA id
	h15sm6411655wrw.15.2020.11.25.14.44.35
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 25 Nov 2020 14:44:38 -0800 (PST)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>
References: <cover.1605896059.git.gustavoars@kernel.org>
	<20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011201129.B13FDB3C@keescook>
	<20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011220816.8B6591A@keescook>
	<9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
	<CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com>
	<1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
	<CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
	<fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
	<CANiq72k5tpDoDPmJ0ZWc1DGqm+81Gi-uEENAtvEs9v3SZcx6_Q@mail.gmail.com>
	<4993259d01a0064f8bb22770503490f9252f3659.camel@HansenPartnership.com>
	<CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <44005bde-f6d4-5eaa-39b8-1a5efeedb2d3@gmail.com>
Date: Wed, 25 Nov 2020 22:44:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
	Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 26 Nov 2020 03:35:50 -0500
Cc: alsa-devel@alsa-project.org, linux-atm-general@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
	linux-iio@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <natechancellor@gmail.com>,
	linux-ide@vger.kernel.org, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net, linux-afs@lists.infradead.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
	oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
	linux-security-module@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, linux-acpi@vger.kernel.org,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input <linux-input@vger.kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, selinux@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	linux-geode@lists.infradead.org, linux-can@vger.kernel.org,
	linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
	op-tee@lists.trustedfirmware.org, linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-hwmon@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	tipc-discussion@lists.sourceforge.net, Linux-MM <linux-mm@kvack.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	patches@opensource.cirrus.com, Joe Perches <joe@perches.com>,
	linux-integrity@vger.kernel.org, linux-hardening@vger.kernel.org
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

T24gMjUvMTEvMjAyMCAwMDozMiwgTWlndWVsIE9qZWRhIHdyb3RlOgo+IEkgaGF2ZSBzYWlkICph
dXRob3JpbmcqIGxpbmVzIG9mICp0aGlzKiBraW5kIHRha2VzIGEgbWludXRlIHBlciBsaW5lLgo+
IFNwZWNpZmljYWxseTogbGluZXMgZml4aW5nIHRoZSBmYWxsdGhyb3VnaCB3YXJuaW5nIG1lY2hh
bmljYWxseSBhbmQKPiByZXBlYXRlZGx5IHdoZXJlIHRoZSBjb21waWxlciB0ZWxscyB5b3UgdG8s
IGFuZCBkb2luZyBzbyBmdWxsLXRpbWUgZm9yCj4gYSBtb250aC4KPHNuaXA+Cj4gSXQgaXMgdXNl
ZnVsIHNpbmNlIGl0IG1ha2VzIGludGVudCBjbGVhci4KVG8gbWFrZSB0aGUgaW50ZW50IGNsZWFy
LCB5b3UgaGF2ZSB0byBmaXJzdCBiZSBjZXJ0YWluIHRoYXQgeW91CiB1bmRlcnN0YW5kIHRoZSBp
bnRlbnQ7IG90aGVyd2lzZSBieSBhZGRpbmcgZWl0aGVyIGEgYnJlYWsgb3IgYQogZmFsbHRocm91
Z2ggdG8gc3VwcHJlc3MgdGhlIHdhcm5pbmcgeW91IGFyZSBqdXN0IGRlc3Ryb3lpbmcgdGhlCiBp
bmZvcm1hdGlvbiB0aGF0ICJ0aGUgaW50ZW50IG9mIHRoaXMgY29kZSBpcyB1bmtub3duIi4KRmln
dXJpbmcgb3V0IHRoZSBpbnRlbnQgb2YgYSBwaWVjZSBvZiB1bmZhbWlsaWFyIGNvZGUgdGFrZXMg
bW9yZQogdGhhbiAxIG1pbnV0ZTsganVzdCBiZWNhdXNlCiAgICBjYXNlIGZvbzoKICAgICAgICB0
aGluZzsKICAgIGNhc2UgYmFyOgogICAgICAgIGJyZWFrOwogcHJvZHVjZXMgaWRlbnRpY2FsIGNv
ZGUgdG8KICAgIGNhc2UgZm9vOgogICAgICAgIHRoaW5nOwogICAgICAgIGJyZWFrOwogICAgY2Fz
ZSBiYXI6CiAgICAgICAgYnJlYWs7CiBkb2Vzbid0IG1lYW4gdGhhdCAqZWl0aGVyKiBpcyBjb3Jy
ZWN0IOKAlCBtYXliZSB0aGUgYXV0aG9yIG1lYW50CiB0byB3cml0ZQogICAgY2FzZSBmb286CiAg
ICAgICAgcmV0dXJuIHRoaW5nOwogICAgY2FzZSBiYXI6CiAgICAgICAgYnJlYWs7CiBhbmQgYnkg
aW5zZXJ0aW5nIHRoYXQgYnJlYWsgeW91J3ZlIGRlc3Ryb3llZCB0aGUgbWFya2VyIHRoYXQKIHdv
dWxkIGRpcmVjdCBzb21lb25lIHdobyBrbmV3IHdoYXQgdGhlIGNvZGUgd2FzIGFib3V0IHRvIGxv
b2sKIGF0IHRoYXQgcG9pbnQgaW4gdGhlIGNvZGUgYW5kIHNwb3QgdGhlIHByb2JsZW0uClRodXMs
IHlvdSAqYWx3YXlzKiBoYXZlIHRvIGxvb2sgYXQgbW9yZSB0aGFuIGp1c3QgdGhlIGltbWVkaWF0
ZQogbWVjaGFuaWNhbCBjb250ZXh0IG9mIHRoZSBjb2RlLCB0byBtYWtlIGEgcHJvcGVyIGp1ZGdl
bWVudCB0aGF0CiB5ZXMsIHRoaXMgd2FzIHRoZSBpbnRlbnQuICBJZiB5b3UgdGhpbmsgdGhhdCB0
aGF0IHNvcnQgb2YgdGhpbmcKIGNhbiBiZSBkb25lIGluIGFuICphdmVyYWdlKiB0aW1lIG9mIG9u
ZSBtaW51dGUsIHRoZW4gSSBob3BlIHlvdQogc3RheSBhd2F5IGZyb20gY29kZSBJJ20gcmVzcG9u
c2libGUgZm9yIQpPbmUgbWludXRlIHdvdWxkIGJlIGFuIG9wdGltaXN0aWMgdGFyZ2V0IGZvciBj
b2RlIHRoYXQsIGFzIHRoZQogbWFpbnRhaW5lciwgb25lIGlzIGFscmVhZHkgc29tZXdoYXQgZmFt
aWxpYXIgd2l0aC4gIEZvciBjb2RlCiB0aGF0IHlvdSdyZSBzZWVpbmcgZm9yIHRoZSBmaXJzdCB0
aW1lLCBhcyBpcyB1c3VhbGx5IHRoZSBjYXNlCiB3aXRoIHRoZSBwZW9wbGUgZG9pbmcgdGhlc2Ug
bWVjaGFuaWNhbCBmaXgtYS13YXJuaW5nIHBhdGNoZXMsCiBpdCdzIGNvbXBsZXRlbHkgdW5yZWFs
aXN0aWMuCgpBIHdhcm5pbmcgaXMgb25seSB1c2VmdWwgYmVjYXVzZSBpdCBtYWtlcyB5b3UgKnRo
aW5rKiBhYm91dCB0aGUKIGNvZGUuICBJZiB5b3Ugc3VwcHJlc3MgdGhlIHdhcm5pbmcgd2l0aG91
dCBkb2luZyB0aGF0IHRoaW5raW5nLAogdGhlbiB5b3UgbWFkZSB0aGUgd2FybmluZyB1c2VsZXNz
OyBhbmQgaWYgdGhlIHdhcm5pbmcgbWFkZSB5b3UKIHRoaW5rIGFib3V0IGNvZGUgdGhhdCBkaWRu
J3QgKm5lZWQqIGl0LCB0aGVuIHRoZSB3YXJuaW5nIHdhcwogdXNlbGVzcyBmcm9tIHRoZSBzdGFy
dC4KClNvIG1ha2UgeW91ciBtaW5kIHVwOiBkb2VzIENsYW5nJ3Mgc3RyaWN0ZXIgLVdpbXBsaWNp
dC1mYWxsdGhyb3VnaAogZmxhZyB1cCBjb2RlIHRoYXQgbmVlZHMgdGhvdWdodCAoaW4gd2hpY2gg
Y2FzZSB0aGUgZml4ZXMgdGFrZQogZWZmb3J0IGJvdGggdG8gYXV0aG9yIGFuZCB0byByZXZpZXcp
IG9yIGRvZXMgaXQgZmxhZyB1cCBjb2RlCiB0aGF0IGNhbiBiZSBtaW5kbGVzc2x5ICJmaXhlZCIg
KGluIHdoaWNoIGNhc2UgdGhlIHdhcm5pbmcgaXMKIHdvcnRobGVzcyk/ICBQcm9wb25lbnRzIGlu
IHRoaXMgdGhyZWFkIHNlZW0gdG8gYmUgdHJ5aW5nIHRvCiBoYXZlIGl0IGJvdGggd2F5cy4KCi1l
ZAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

