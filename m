Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B6EC433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF48821D1B
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF48821D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-qVhNJTLzPq2aEZ6sA4Zggg-1; Mon, 04 Jan 2021 14:03:53 -0500
X-MC-Unique: qVhNJTLzPq2aEZ6sA4Zggg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00629814507;
	Mon,  4 Jan 2021 19:03:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D62AF5C8AA;
	Mon,  4 Jan 2021 19:03:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD50F50038;
	Mon,  4 Jan 2021 19:03:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BKDFLjo024019 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 20 Dec 2020 08:15:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 343352026D15; Sun, 20 Dec 2020 13:15:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F0082026D49
	for <dm-devel@redhat.com>; Sun, 20 Dec 2020 13:15:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6112C800B3B
	for <dm-devel@redhat.com>; Sun, 20 Dec 2020 13:15:17 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1608470117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	dkim-signature; bh=9HU9z9Y7r3ZUwR0yt27B18xl9CsukwXhvZC0JP1u9Uw=;
	b=CyDrAIOw+CDw3d+9EQ1cem7FJFnv2/lzv+ICy6/59b6/ba2SUcs7h0+Sh1ich1FNjDtSvb
	POt9kYLG30zP0+M8VnqVPIycVpaAUOv8xll0v5jo75WH6lFN1zHGCgAVNBm++AIkZD8nnG
	HrtmKO8GH4r5v5EKOK/JgSY69xp2FgLs2ayOH/5w6ZkP3MZN6nTHOzMxPZbiPPv4uUH2Wc
	10HFjZDd699xGeJc368uG9EpCcRrtR1x0xEHlFPJf8t3sbxfyZYqyuVJB9jw0hhkJRXZsM
	UZsHwM9YdVpMIDf+87RsHZPezmjiU02hPBGUCpG8icteI4qKDkCLF7mWvmx4AA==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1608470117; a=rsa-sha256;
	cv=none;
	b=LrrBfj2gqyv/cssJvjidymQicsfZ8f9CdBZYKCgZb1oiUYjhnG3ash7fHJa/1GmjOzmq+i
	UtjDBDEpEktnVW1tw4XNnA/ozOSnuqHIgSRuNxjxo9cBh8X3+JlRZtbP5ea3y+MGwQMJ46
	n9iVg87aTdtkmYNFNXMoh4XBf5GLVlNCbaDSl/Vvd+HZOZzj6ukMjBldD5B/WupR1MG4dn
	6vjiadybamW3ryRviGV/0QsYXi6sS9XCDiy1/D3NrJhk+m/0UhqH1FUnqkQbAaU2LL8FXr
	5gJlfHMBQFsTFpAeo8LO6HmUFpQsqDxSmkN7Q9BQa6numtRgMKfcqUhdRZZcRA==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=mTAYb3ic;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.17.12 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
Received: from mout.web.de (mout.web.de [212.227.17.12]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-253-gcd4se6nNHuFUh8BOAzTWQ-1;
	Sun, 20 Dec 2020 08:15:12 -0500
X-MC-Unique: gcd4se6nNHuFUh8BOAzTWQ-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1608470110;
	bh=gvFT06xuZu102RzJsC1+KKOgg3n2umWs1voAz9Sh4uY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
	b=mTAYb3icIljk2LPNbfGBsJzFlZPlp5ra/T9PwJjXARSxVUy80NjeWovooODWeAaEO
	1e/8LVmXWNygckEAbiG9AKFBYhFwqvW5gNjTNoF7lMA6R47YKybWlAUtShgP9dLgC4
	7yfuveh9n1yMGMRd6+MXKYiey9p6kZxToNBO3m+E=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.172]) by smtp.web.de (mrweb106
	[213.165.67.124]) with ESMTPSA (Nemesis) id 1M2ggX-1kmq9d0Eed-004A7C;
	Sun, 20 Dec 2020 14:02:34 +0100
Date: Sun, 20 Dec 2020 14:02:22 +0100
From: Lukas Straub <lukasstraub2@web.de>
To: dm-devel <dm-devel@redhat.com>
Message-ID: <20201220140222.2f341344@gecko.fritz.box>
MIME-Version: 1.0
X-Provags-ID: V03:K1:YG0sfjgXUUabhIZAsw64543VMPSP10dUBkBRrZKJhUgsi1IuRgW
	B7feyWPn6lnfsNoitvA/Zc5jiWJDDGmULHaWe7PNMsZvf4TGJoewMlEY3AAEzqarGbMWawf
	2xO30r6OKgMQ20GjVgZPJDcUeoituVe0WBVpDpmautou9tOrbhW3RNUnjLfY8+2fFLv05Sj
	ylTpiyPj+An7pJPwtx/FA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Id4hJNQzpGY=:eDZ+GHWs/mAFpX2k5+50+u
	rhyYw86CfKp4i3kWsI2LxqywcjS75n5Qr84KUQFNKWNanlsvdotklBQMRKuh8tr3ZRBk5ZnMv
	kAV9GuALv/7YOin3CDzY5GyMxrdiuFMzv84m+m1jfmyVG8KROGb6mv7mJf+/AcBZskPzuUaYV
	PPoJHWnZGMu2Um8xDt84ikWA+4jNmibGdhA5WmBMQ9CGzRNgAo/jGEL0I4hl6vCg1P7V2s3VC
	e0C6YfmGgh7oxzc4Bo0xUIYEEeNiKXlPLbuaK25sT8LGhBRTIDy56q0h13n/O1wd0GuucJtj8
	9iAHVO/8iX8/Yy2PZh0G9NxS/FqfYQtyEJ2Ann3HsA1PyLWp0srUof/REEXA4x/Z4dMGEp8sy
	u8eX1aaLlNDy3f6GPqcgUIjpS7dmpKbI50LFVr3CemEc4Md+74yAybK6Mup9NWqGkjhYvXvgS
	XLIj/xulYLnWoINbGb9qy+hWCqJiXK/ItOd3MuTlKBadnDC/m1t3kAU0rr1vhtgfmqnF9TJIr
	9yWh0dImnzawcSkF70dseJ/836o3OzhYhM5/XCfZoXQevtqsNrnVkeFvgL/ve1uA1OvdI7QPf
	yYclzqOmojdYIfBaIwGh5L7/DWqo6RHeNb18iu2Qk+xqnZ+kieblldcDVhfwT7U4OMCtflr1K
	NvbIDOAsOAm5j1+EszIyJIQwlHKKCmZg0ImogIFhGxH9yzgL+gN1Aiq80+UD9AvFnb8e/hWGB
	KaQlU2Fdd/oPpZ7W46gUeRrfGf3HBznbcBpTwBCOtNkNz8bVaIxBfNpaoLxZyBG2hIXY/AphF
	CIeYvEpEoCJLZnI4cc6Ps9LznVMehDe2quUXpDBVyB7u//ZZYYwUMSvzTC6F+kHlXVScWxJEg
	P1pmUxXAXyCA4nUTZ3Kg==
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=mTAYb3ic;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.17.12 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
X-Mimecast-Spam-Score: -1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] dm-integrity: Fix flush with external metadata
	device
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
Content-Type: multipart/mixed; boundary="===============0457783469154905444=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

--===============0457783469154905444==
Content-Type: multipart/signed; boundary="Sig_/yp.L9S+2r30U8pOFk7XwZtc";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/yp.L9S+2r30U8pOFk7XwZtc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

With an external metadata device, flush requests aren't passed down
to the data device.

Fix this by issuing flush in the right places: In integrity_commit
when not in journal mode, in do_journal_write after writing the
contents of the journal to the disk and in dm_integrity_postsuspend.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 drivers/md/dm-integrity.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 5a7a1b90e671..a26ed65869f6 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2196,6 +2196,8 @@ static void integrity_commit(struct work_struct *w)
 =09if (unlikely(ic->mode !=3D 'J')) {
 =09=09spin_unlock_irq(&ic->endio_wait.lock);
 =09=09dm_integrity_flush_buffers(ic);
+=09=09if (ic->meta_dev)
+=09=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
 =09=09goto release_flush_bios;
 =09}
=20
@@ -2410,6 +2412,9 @@ static void do_journal_write(struct dm_integrity_c *i=
c, unsigned write_start,
 =09wait_for_completion_io(&comp.comp);
=20
 =09dm_integrity_flush_buffers(ic);
+=09if (ic->meta_dev)
+=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
+
 }
=20
 static void integrity_writer(struct work_struct *w)
@@ -2949,6 +2954,9 @@ static void dm_integrity_postsuspend(struct dm_target=
 *ti)
 #endif
 =09}
=20
+=09if (ic->meta_dev)
+=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
+
 =09BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
=20
 =09ic->journal_uptodate =3D true;
--=20
2.20.1

--Sig_/yp.L9S+2r30U8pOFk7XwZtc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl/fS14ACgkQNasLKJxd
slh2ww/9Ela4bNfODXTPwtRXKqaZAjepKYsAN3yum0STlU+vt37gl+SQ+3PI9CWV
KBwOwJbu/K3yhw9R0TZX2BpRQB6+vaclyc8/T6gvTpnsJq54Zz1vYxUYSarW2emd
ISVAzz+LynFaxHrvpT8BO9H4krTHMO8gAYWp6dmq/9ORhJipLclVk+fInAAQyiBl
aGragqj4Y/D4hTukbHfIMpTliqaPmVIWWCrCrBrCqwq39a7un3i8WbeuDg+vSQ2l
eBmsJLH23/rTlVUAyatUVwuiMO2e0wWEHieBXapqUvQNzaJdGL+SKmeCivp5a44J
LoZ58Hus70Dqj5ijFnuf3jZIHTA//22UNNi6u72eWJiz7FRyR3xihNOBTTDGohca
90F4mwTTUFCctvzSY1ZXTrLMw8yDoQGINlQ9idmQtdJa/7NKMv3zFETD6SU9jfvF
u6MbVsltc9bwfYtkxIAjOExKTQYO+xrhnjZxdt0JB1HJohJYr9DTssYnJz/u/KMl
4dmqzAgYTSdSchVGWZkYqMUyTSob3YaeLAScKy0hF5cEF2Z9zMSTvZxVnQ+kEK7t
AgEuK6Pj6iCuhHiuiEGlHU3lLDokwDzszgT5uMIpephg2WE8QSN+zAT9NZXQOowy
9KDNevew6NG3GIXhuvHtvCxgXcr34eG1l858ZYdpaGsdzFKrhzM=
=Sg7k
-----END PGP SIGNATURE-----

--Sig_/yp.L9S+2r30U8pOFk7XwZtc--


--===============0457783469154905444==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0457783469154905444==--

