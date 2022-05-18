Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B094CC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 07:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652859693;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=+FVbKjD3jycvtQ2eq9NPuSByaQcTyiRWz3Q1k9q22dE=;
	b=bzKsjpX931QWLvaaFaqALkT/CgSHM8lL0c0hvK9/8Ha2R5IWlZy6pMmWowbnWhoDrSqg9/
	HU32rajwHLvWCL35NpQqHrEzgCxRlEqA//IgPtAd3ypdOS6j9e+Xqxl8QnlDcx++EcHbSo
	5t+3N5QVL9PC7fEB2Y8ckXd9vU91fng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-1Glz3nzQNyWqRUQGDzVMPg-1; Wed, 18 May 2022 03:41:28 -0400
X-MC-Unique: 1Glz3nzQNyWqRUQGDzVMPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67E4785A5BC;
	Wed, 18 May 2022 07:41:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0EA81400B18;
	Wed, 18 May 2022 07:41:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BFA3819259D3;
	Wed, 18 May 2022 07:41:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D1201947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 06:30:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45D13492CA6; Wed, 18 May 2022 06:30:42 +0000 (UTC)
Received: from localhost (unknown [10.39.192.212])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D72E6492C3B;
 Wed, 18 May 2022 06:30:41 +0000 (UTC)
Date: Wed, 18 May 2022 07:30:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Kirill Tkhai <kirill.tkhai@openvz.org>
Message-ID: <YoSSkOQaGL0sBNOI@stefanha-x1.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 18 May 2022 07:41:18 +0000
Subject: [dm-devel] Attaching qcow2 images to containers
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
Cc: Kevin Wolf <kwolf@redhat.com>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, qemu-devel@nongnu.org,
 Xie Yongji <xieyongji@bytedance.com>, hreitz@redhat.com, sgarzare@redhat.com
Content-Type: multipart/mixed; boundary="===============8837637723414676949=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7


--===============8837637723414676949==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VxVmuJGtHcUMbdkL"
Content-Disposition: inline


--VxVmuJGtHcUMbdkL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kirill,
I saw your "[PATCH 0/4] dm: Introduce dm-qcow2 driver to attach QCOW2
files as block device" patch series:
https://lore.kernel.org/linux-kernel/YkME5ZS2CpXuNmN6@infradead.org/T/

There has been recent work in vDPA (VIRTIO Data Path Acceleration) to
achieve similar functionality. The qemu-storage-daemon VDUSE export
attaches a virtio-blk device to the host kernel and QEMU's qcow2
implementation can be used:
https://patchew.org/QEMU/20220504074051.90-1-xieyongji@bytedance.com/

A container can then access this virtio-blk device (/dev/vda). Note that
the virtio-blk device is implemented in software using vDPA/VDUSE, there
is no virtio-pci device.

As a quick comparison with a dm-qcow2 target, this approach keeps the
qcow2 code in QEMU userspace and can take advantage of QEMU block layer
features (storage migration/mirroring/backup, snapshots, etc). On the
other hand, it's likely to be more heavyweight because bounce buffers
are required in VDUSE for security reasons, there is a separate
userspace process involved, and there's the virtio_blk.ko driver and an
emulated virtio-blk device involved.

Another similar feature that was recently added to QEMU is the
qemu-storage-daemon FUSE export:

  $ qemu-storage-daemon \
        --blockdev file,filename=test.img,node-name=drive0 \
	--export fuse,node-name=drive0,id=fuse0,mountpoint=/tmp/foo
  $ ls -alF /tmp/foo
  -r--------. 1 me me 10737418240 May 18 07:22 /tmp/foo

This exports a disk image as a file via FUSE. Programs can access it
like a regular file and qemu-storage-daemon will do the qcow2 I/O on the
underlying file.

I wanted to mention these options for exposing qcow2 disk images to
processes/containers on the host. Depending on your use cases they might
be interesting. Performance comparisons against VDUSE and FUSE exports
would be interesting since these new approaches seem to be replacing
qemu-nbd.

Can you share more about your use cases for the dm-qcow2 target? It
could be useful for everyone I've CCed to be aware of various efforts in
this area.

Thanks,
Stefan

--VxVmuJGtHcUMbdkL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKEkpAACgkQnKSrs4Gr
c8hBOggAjwLYdNLqHIo1rQgUfb93kau+ER5YddjUvSxG65CLZGYWeB86JOUfT+rR
hVi2bBGX1OkL1a66tWLK2Tcbakc6XfQXQ6JCbzJUoKCTI9gIA9i3ztjqrQEzoagn
liMWkk89XmdrLE8gsA7MOKHdFELKRiFds8JKU0Pny/VDJkOlYO/6gcqCw5fcXkrv
58PTohwKlOgOVdQ1wzlkFGRtTPtc5/JeFzJOIUs4i+GnqtjubKl4VfbjRiAoqTEj
uOO5gsJ9mdTHyWd1lugxiSqttqVVZZb6VEQvsnZUwFUoNkB/KHoILTcMWd9GWRn0
HNO2R2xD/zhG2j+x7dw6n7RBczgUdw==
=Wa4Q
-----END PGP SIGNATURE-----

--VxVmuJGtHcUMbdkL--

--===============8837637723414676949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8837637723414676949==--

