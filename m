Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A29C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jul 2022 08:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658131531;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=wIyadIJsvwXRReCE2J0kt1ZOjxCOjzs0Eb2TfbmTqcA=;
	b=DhTkQsEceThwnQr+c8nk2PD1qcKKOX4zYleG5Z663kRigkjnaAJKAhfrH2bG0Z1Rj9ZhZx
	GL4jpIPmB1WH9tZprEAFEOsuL//rwBWS71Q1QHzEi4yhhad9kjY6HrejhoCsaH+DzrQDCD
	ZTpa9osJCXbbgwjC6NA6UOnC6qPWtIU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-IOjmYC_8PlGcA_XV-_vQHw-1; Mon, 18 Jul 2022 04:05:21 -0400
X-MC-Unique: IOjmYC_8PlGcA_XV-_vQHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CA483C0D84D;
	Mon, 18 Jul 2022 08:05:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8052166B2B;
	Mon, 18 Jul 2022 08:05:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 836EC1947055;
	Mon, 18 Jul 2022 08:05:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C78C1947041
 for <dm-devel@listman.corp.redhat.com>; Sat, 16 Jul 2022 19:51:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F321A492CA2; Sat, 16 Jul 2022 19:50:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB8D6492C3B
 for <dm-devel@redhat.com>; Sat, 16 Jul 2022 19:50:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEE391C00AC1
 for <dm-devel@redhat.com>; Sat, 16 Jul 2022 19:50:59 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
 [66.111.4.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-8MEJi83rMseMP-Pnocl70g-1; Sat, 16 Jul 2022 15:50:51 -0400
X-MC-Unique: 8MEJi83rMseMP-Pnocl70g-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.nyi.internal (Postfix) with ESMTP id 8E9115C0094
 for <dm-devel@redhat.com>; Sat, 16 Jul 2022 15:45:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Sat, 16 Jul 2022 15:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:content-type:date:date:from:from
 :in-reply-to:message-id:mime-version:reply-to:sender:subject
 :subject:to:to; s=fm3; t=1658000727; x=1658087127; bh=RdojeZcN4N
 z187k1LeVRsaTEESi3Z1qr7T5FdPwMsbY=; b=XjEA6aF8neFUveUu9Rl18DxNIY
 6QouIpw4t1GTP33MHYYib820UGaqxxPoqAnK+oqLPd0VPBKyOGFjF3TZN8z1hee3
 +bzE+JC950MBJ3KIIxavx4H+vVnf7Uj+jR7+uDDPlzltvCKnNumhJcUbGNcHl/b/
 GemIIBJjvxwkEdBQYfsaBA4ttDUTYe2QKJEhSXxsJJKKJ5zVyyolknhIIy1VB1+U
 yhpodV4oboFP2b4RwXXO5DBoCERL8lLjMsWoXZ7MjluBLx3q3PCR1jSgCzpJD+LT
 phvGfObd2hESxcjYciF2nO0Aa1UTMHf/DqBMPpTZfCb9J91UlnAAL6JZUoAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:message-id:mime-version
 :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
 :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1658000727; x=
 1658087127; bh=RdojeZcN4Nz187k1LeVRsaTEESi3Z1qr7T5FdPwMsbY=; b=O
 DxZGGTqgptwMmHzDmSxN5HN0KtVAEnxUFaRnQoM3vAWdFvB3opBRbJwaBPBbIcJR
 zg3pRZdhL0DMxACfLUBsT/XDRgOvBJJ0VmnitsUA6XiMw2ncGzvGtTOjcpMkDfSD
 FkZzoT/5Jyv6Sd+w02Vhn7Gp1yONGdXbQcGCGTLmLsYTCfu+Ulpc6LPoI1lYemSH
 EmsyITgbZiHFoB1L/G1t+wEiTiuKXJ5LZq+lCzlG7+wvJs24Q715kIIJBFq/EV/T
 Zjws+wtA5wedkSZ5BNB0e7dKEyhRY9SH2IzBCKFO2urpBFMvkVkB5XAum+yxkmfa
 HM9WQLIKz2NuO+w+W/oOw==
X-ME-Sender: <xms:VxXTYj8JEhy1mxruntFgAkdyquj2WTe2LnGc6wCtZgSzZRzrqqpoDg>
 <xme:VxXTYvulBpjgRcE6lgX_EqKUKcNw2KlNo0idC80rFAlAfPvC55cZn9lqrN3wEW8pF
 GDOMW3g6x9De_A>
X-ME-Received: <xmr:VxXTYhCGuFjoiV37sODbz1O1XqplYXw4JlbSVq3Dakxiy_bdEqRWElGzpPr9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekfedgudegfecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggusehgtderre
 dttddvnecuhfhrohhmpeffvghmihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihes
 ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpe
 dujefgjeeggeelhfevkeeltdekvdeuhfetiefffefhkeehhfevhefhkefgudegkeenucev
 lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesih
 hnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:VxXTYvfgpkrUr_5GOkl5EtBH1uKlDt8ybIeIkSCIJ0Xi8RSbJKBxZg>
 <xmx:VxXTYoN3I4k8DXiOhmFTsLSA8VaBmhsNSgT-LWt_mNpHEvZfV3mWaw>
 <xmx:VxXTYhkxJIl8lEYhDXKaBuPuB97CAVYTLNjWEs5KAuQnYt4ql5-Gxg>
 <xmx:VxXTYua8fNX6XXuchIJtnIc5S-IlYmk-bhMhlESRuFZHJobjBIiN8w>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <dm-devel@redhat.com>; Sat, 16 Jul 2022 15:45:27 -0400 (EDT)
Date: Sat, 16 Jul 2022 15:45:05 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: dm-devel@redhat.com
Message-ID: <YtMVVQeGVDsCeo4i@itl-email>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 18 Jul 2022 08:05:17 +0000
Subject: [dm-devel] Kernel panic in dm-thin
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
Content-Type: multipart/mixed; boundary="===============1594947023580961996=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6


--===============1594947023580961996==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="apn7++4ZSYzst/jO"
Content-Disposition: inline


--apn7++4ZSYzst/jO
Content-Type: multipart/mixed; protected-headers=v1;
	boundary="Q1Z4htoPME4tipf5"
Content-Disposition: inline
Date: Sat, 16 Jul 2022 15:45:05 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: dm-devel@redhat.com
Subject: Kernel panic in dm-thin


--Q1Z4htoPME4tipf5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I got this kernel panic earlier today.  It appears to be related to
dm-thin.  In case it matters, I have a bunch of VMs that use mounts with
the 'discard' option set, so there was likely a LOT of discard activity.

I worked around the problem by disabling the feature with lvchange, but
it obviously should still be fixed.  Panic message and stack trace
attached.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--Q1Z4htoPME4tipf5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="panic.txt"
Content-Transfer-Encoding: quoted-printable

<1>[13053.503343] BUG: kernel NULL pointer dereference, address: 0000000000=
000014
<1>[13053.503353] #PF: supervisor read access in kernel mode
<1>[13053.503357] #PF: error_code(0x0000) - not-present page
<6>[13053.503362] PGD 0 P4D 0=20
<4>[13053.503365] Oops: 0000 [#1] SMP NOPTI
<4>[13053.503370] CPU: 3 PID: 50805 Comm: kworker/u8:3 Tainted: G        W =
        5.15.52-1.fc32.qubes.x86_64 #1
<4>[13053.503377] Hardware name: LENOVO 20HHCTO1WW/20HHCTO1WW, BIOS N1UET43=
W (1.17 ) 12/13/2017
<4>[13053.503383] Workqueue: dm-thin do_worker [dm_thin_pool]
<4>[13053.503392] RIP: e030:__blkdev_issue_discard+0x165/0x2a0
<4>[13053.503400] Code: 14 48 c7 c2 e0 d8 66 83 31 f6 e8 e6 1e ff ff 49 89 =
c6 4d 85 ff 74 13 4c 89 ff 48 89 c6 e8 f3 03 ff ff 4c 89 ff e8 ab 75 ff ff =
<41> 0f b7 46 14 4d 89 66 20 89 c1 80 e5 f7 66 41 89 4e 14 4d 39 6e
<4>[13053.503412] RSP: e02b:ffffc90042e2fb40 EFLAGS: 00010246
<4>[13053.503416] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 00000000=
000000c8
<4>[13053.503422] RDX: 0000000000000001 RSI: 0000000000000200 RDI: ffffffff=
8366d8f8
<4>[13053.503427] RBP: 0000000000000200 R08: 0000000000000200 R09: 00000000=
0000073c
<4>[13053.503434] R10: ffffffff812a97e8 R11: 000000000000000b R12: 00000000=
2c7de000
<4>[13053.503439] R13: ffff888004482580 R14: 0000000000000000 R15: 00000000=
00000000
<4>[13053.503450] FS:  0000000000000000(0000) GS:ffff88807d380000(0000) knl=
GS:0000000000000000
<4>[13053.503456] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[13053.503460] CR2: 0000000000000014 CR3: 00000000146a2000 CR4: 00000000=
00050660
<4>[13053.503469] Call Trace:
<4>[13053.503472]  <TASK>
<4>[13053.503476]  passdown_double_checking_shared_status.constprop.0+0x11b=
/0x140 [dm_thin_pool]
<4>[13053.503485]  process_prepared_discard_passdown_pt1+0xc4/0x190 [dm_thi=
n_pool]
<4>[13053.503494]  break_up_discard_bio+0x152/0x270 [dm_thin_pool]
<4>[13053.503501]  process_discard_cell_passdown+0x37/0x50 [dm_thin_pool]
<4>[13053.503508]  process_discard_bio+0xf3/0x160 [dm_thin_pool]
<4>[13053.503514]  process_thin_deferred_bios+0x15d/0x240 [dm_thin_pool]
<4>[13053.503522]  process_deferred_bios+0x2d/0x1d0 [dm_thin_pool]
<4>[13053.503529]  do_worker+0xcc/0x130 [dm_thin_pool]
<4>[13053.503535]  process_one_work+0x1f1/0x390
<4>[13053.503540]  worker_thread+0x4c/0x310
<4>[13053.503543]  ? process_one_work+0x390/0x390
<4>[13053.503547]  kthread+0x127/0x150
<4>[13053.503552]  ? set_kthread_struct+0x40/0x40
<4>[13053.503557]  ret_from_fork+0x22/0x30
<4>[13053.503563]  </TASK>
<4>[13053.503565] Modules linked in: loop intel_rapl_msr ee1004 iTCO_wdt in=
tel_pmc_bxt mei_hdcp iTCO_vendor_support intel_rapl_common snd_hda_codec_hd=
mi intel_powerclamp snd_ctl_led snd_hda_codec_realtek snd_hda_codec_generic=
 snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_co=
re snd_hwdep snd_seq pcspkr joydev snd_seq_device think_lmi intel_wmi_thund=
erbolt firmware_attributes_class wmi_bmof snd_pcm i2c_i801 i2c_smbus vfat t=
hinkpad_acpi fat mei_me platform_profile mei snd_timer ledtrig_audio idma64=
 rfkill intel_pch_thermal snd soundcore xenfs fuse ip_tables dm_thin_pool d=
m_persistent_data dm_bio_prison dm_crypt trusted asn1_encoder crct10dif_pcl=
mul crc32_pclmul crc32c_intel ghash_clmulni_intel serio_raw i915 nouveau nv=
me drm_ttm_helper mxm_wmi i2c_algo_bit ttm drm_kms_helper nvme_core cec drm=
 wmi i2c_hid_acpi video i2c_hid pinctrl_sunrisepoint xen_acpi_processor xen=
_privcmd xen_pciback xen_blkback xen_gntalloc xen_gntdev xen_evtchn
<4>[13053.503645] CR2: 0000000000000014
<4>[13053.503649] ---[ end trace f86fa19611542bfa ]---
<4>[13053.772527] RIP: e030:__blkdev_issue_discard+0x165/0x2a0
<4>[13053.772545] Code: 14 48 c7 c2 e0 d8 66 83 31 f6 e8 e6 1e ff ff 49 89 =
c6 4d 85 ff 74 13 4c 89 ff 48 89 c6 e8 f3 03 ff ff 4c 89 ff e8 ab 75 ff ff =
<41> 0f b7 46 14 4d 89 66 20 89 c1 80 e5 f7 66 41 89 4e 14 4d 39 6e
<4>[13053.772556] RSP: e02b:ffffc90042e2fb40 EFLAGS: 00010246
<4>[13053.772561] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 00000000=
000000c8
<4>[13053.772567] RDX: 0000000000000001 RSI: 0000000000000200 RDI: ffffffff=
8366d8f8
<4>[13053.772572] RBP: 0000000000000200 R08: 0000000000000200 R09: 00000000=
0000073c
<4>[13053.772577] R10: ffffffff812a97e8 R11: 000000000000000b R12: 00000000=
2c7de000
<4>[13053.772582] R13: ffff888004482580 R14: 0000000000000000 R15: 00000000=
00000000
<4>[13053.772593] FS:  0000000000000000(0000) GS:ffff88807d380000(0000) knl=
GS:0000000000000000
<4>[13053.772599] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[13053.772604] CR2: 0000000000000014 CR3: 00000000146a2000 CR4: 00000000=
00050660
<0>[13053.772625] Kernel panic - not syncing: Fatal exception
<0>[13053.772635] Kernel Offset: disabled

--Q1Z4htoPME4tipf5--

--apn7++4ZSYzst/jO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmLTFVUACgkQsoi1X/+c
IsG3iRAAmkSXxqoNmac4YNDmi3et7jcl14RJQnJXsWh9LSoqWXdHWkOYzBlBimXE
wI40M43n4gfkMBJCMuONQ1gtkIhVGtIKU2hWYlq/85gPR87WT2wq46STxjgIyfDv
Ce7Yma9eLdGgO1rK7ZUdZEn/7i+jTrILiBJeIMOPweK1tSj4oUchXD0QPW4pDHbs
akyIETPfu2gHtAmnrLbzv5roaKcrbeoV+7ExxhMkwR43aOV+0xP6+Nd6qnm70qCx
GXBm3Or4UZRtHCnGuln/6UgqP/rqCUFnbwwWwrghE1pTRH0I4gOGI73E/MhT32bY
vZK+hWGXQ7mNjC8BdyrCZYp4uZnUxMVTpgWIaWkJsa/tx/jNLWlcXuMeZfb6bjfL
NPdAQBYc/rfKa7TBx6NOnYn4T7GW8dcFBOGzmO9fS8I7m3tHFljqV7shmla9YwrA
V6W54Y8LwBG/+l2aJqgCHVtPrkIaDGPO+kcLuQcAo22OkZ/Zxe86esRhyrEBx6n6
Y0qhzetZ25fK2VVsE+uMeoC1p/hLANG9t0S6a06t6MxksXEJw+EEnhryziRptBz4
lh8i0CzSGYdkWaR7P94Ys7ZFsJlZpI6JRYfBkBF8BeSVjQQAAJr4MG+Hec8CRQM6
ui+rLcKm0YHTP/jJjr7CbPj52RK0D3XT08JYbggoyJdg61+kIs4=
=RpgJ
-----END PGP SIGNATURE-----

--apn7++4ZSYzst/jO--


--===============1594947023580961996==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1594947023580961996==--

