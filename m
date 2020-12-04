Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E88C4361B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A617123120
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A617123120
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=privacyrequired.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-iEuZRCwOO-mrkDkL0nVbZw-1; Mon, 07 Dec 2020 05:00:17 -0500
X-MC-Unique: iEuZRCwOO-mrkDkL0nVbZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 073E26416D;
	Mon,  7 Dec 2020 09:59:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D77381A7C1;
	Mon,  7 Dec 2020 09:59:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A2F0E180954D;
	Mon,  7 Dec 2020 09:59:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4HCBmJ014078 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 12:12:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11E5C2166B31; Fri,  4 Dec 2020 17:12:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CBF32166B2C
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 17:12:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8926F108C0A1
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 17:12:08 +0000 (UTC)
Received: from latitanza.investici.org (latitanza.investici.org
	[82.94.249.234]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-568-b5nMIGdHNhiV-nMLz9he-g-1; Fri, 04 Dec 2020 12:12:06 -0500
X-MC-Unique: b5nMIGdHNhiV-nMLz9he-g-1
Received: from mx3.investici.org (unknown [127.0.0.1])
	by latitanza.investici.org (Postfix) with ESMTP id 4CnfF12X1nz8shk;
	Fri,  4 Dec 2020 17:04:05 +0000 (UTC)
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234])
	(Authenticated sender: laniel_francis@privacyrequired.com) by
	localhost (Postfix) with ESMTPSA id 4CnfDy1SRgz8sfb; 
	Fri,  4 Dec 2020 17:04:02 +0000 (UTC)
From: laniel_francis@privacyrequired.com
To: Russell King <linux@armlinux.org.uk>, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	bcm-kernel-feedback-list@broadcom.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Bin Liu <b-liu@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jessica Yu <jeyu@kernel.org>
Date: Fri,  4 Dec 2020 18:03:06 +0100
Message-Id: <20201204170319.20383-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B4HCBmJ014078
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Dec 2020 04:59:37 -0500
Cc: linux-efi@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
	Francis Laniel <laniel_francis@privacyrequired.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [dm-devel] [RFC PATCH v1 00/12] Replace strstarts() by
	str_has_prefix()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Francis Laniel <laniel_francis@privacyrequired.com>

Hi.


First, I hope you are fine and the same for your relatives.

In this patch set, I replaced all calls to strstarts() by calls to
str_has_prefix().
Indeed, the kernel has two functions to test if a string begins with an other:
1. strstarts() which returns a bool, so 1 if the string begins with the prefix,
0 otherwise.
2. str_has_prefix() which returns the length of the prefix or 0.

str_has_prefix() was introduced later than strstarts(), in commit 495d714ad140
which also stated that str_has_prefix() should replace strstarts().
This is what this patch set does.

Concerning the patches, the modifications cover different areas of the kernel.
I compiled all of them and they compile smoothly.
Unfortunately, I did not test all of them, so here are the status of the patches
regarding test:
1. Tested with qemu-system-arm using insmod.
2. I do not have access to a bcm47xx MIPS CPU an qemu-system-mips does not
emulate this board.
3. Tested with qemu-system-x86_64 calling
crypto_alloc_skcipher("essiv(authenc(hmac(sha256),cbc(aes)),sha256)", 0, 0)
through LKDTM.
4. Tested with qemu-system-x86_64 using crypsetup.
5. I do not have access to a renesas board and I lack some context to test it
with qemu-system-arm.
6. I do not have access to an OMAP board and I lack some context to test it with
qemu-system-arm.
7. I did not find how to boot from the EFI_STUB with qemu. If you know how to
do, I would be happy to try running this code.
8. I ran qemu-system-x86_64 with a floppy disk attached but impossible to go
through this module code...
9. I do not have access to a bcm63xx MIPS CPU an qemu-system-mips does not
emulate this board.
10. Tested with qemu-system-x86_64 using insmod.
11. I do not have access to an AM335x or DA8xx platforms and I lack some context
to test it with qemu-system-arm.

If you see a way to improve the patches or if I did something wrong with the
mail do not hesitate to ask.


Best regards.

Francis Laniel (12):
  arm: Replace strstarts() by str_has_prefix().
  mips: Replace strstarts() by str_has_prefix().
  crypto: Replace strstarts() by str_has_prefix().
  device-mapper: Replace strstarts() by str_has_prefix().
  renesas: Replace strstarts() by str_has_prefix().
  omap: Replace strstarts() by str_has_prefix().
  efi: Replace strstarts() by str_has_prefix().
  ide: Replace strstarts() by str_has_prefix().
  mips: Replace strstarts() by str_has_prefix().
  module: Replace strstarts() by str_has_prefix().
  musb: Replace strstarts() by str_has_prefix().
  string.h: Remove strstarts().

 arch/arm/kernel/module.c                      | 12 +++++------
 arch/mips/bcm47xx/board.c                     |  4 ++--
 arch/mips/bcm63xx/boards/board_bcm963xx.c     |  2 +-
 crypto/essiv.c                                |  2 +-
 .../firmware/efi/libstub/efi-stub-helper.c    |  2 +-
 drivers/firmware/efi/libstub/gop.c            | 10 +++++-----
 drivers/gpu/drm/omapdrm/dss/base.c            |  2 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c        |  2 +-
 drivers/ide/ide-floppy.c                      |  4 ++--
 drivers/md/dm-crypt.c                         |  4 ++--
 drivers/usb/musb/musb_cppi41.c                |  4 ++--
 drivers/usb/musb/musb_debugfs.c               | 20 +++++++++----------
 include/linux/string.h                        | 10 ----------
 kernel/module.c                               |  6 +++---
 14 files changed, 37 insertions(+), 47 deletions(-)

-- 
2.20.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

