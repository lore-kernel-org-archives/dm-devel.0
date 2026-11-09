Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255579;
	b=Lor3o/gCUZbqVDT04nP9HrVeQvFUlbXTCHYjC9qLV/QINWuuF5aXg67aEzoluUdmaUGk
	 6krenMk1ACL7iSyyBZ5jcMR910X/s91IQSGFfSaqXaFZszZJX+kYIpkJOFJzzTOByJK7X
	 yj7Mks6gsYVXPTBYd8sum4QDC/9f2shfyLF/q8NZ71bWIVNA+Dow+T4BYXP2CphxDNFWJ
	 laXf2yZK8ZDbsNeNbOWBqbsjTt2O8wn3vYz2zo4qcjsOp2+ruD7r+PcfQjq03ge2XJ5ec
	 cHfO3xXceJp/0UMYWgRrid+5eXSXp4EKvj1NjM/sOyZJATzCDdEfx2CHzLOreSXMl3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255579;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:User-Agent:MIME-Version:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=uK2G0EmkiRXjdKWWa6uXa7gVZboyOyJeRXnb2sW6H8s=;
	b=vdr4MJ1ftnXwJY6kHD94d+33394S9bEf6t4wXtn6VuR6jPfT3VDA0oy1ukXB5vI0oZpF
	 obQu8NbCWwBflw9AwjE5h/yk1FTRuOaCmYsz+s8zDrqzby9nOVdVFJMFSC99w2tWx76eH
	 JVc9FBZmAMJHVH6Zjq7dKMawxZyiJdzRJRkUVE/XIRF5ihCj80Bz4xPE+EVxv8rVyCmiW
	 wPlkkYQg8ZpJC0H1s7aVXc6gsiQa/ArX7Hb9rA7uTPx4KmwasvdTKFt+vucFjiTjtCdrY
	 HgNg0BudHXA4RilDw9fIe/VobAUqco4zBujNZiZbSlE2KuyhZb2ditoli8tqTRqfzeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YmNvW+A0;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7B4606A31C
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 20:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF7B4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YmNvW+A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794255577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uK2G0EmkiRXjdKWWa6uXa7gVZboyOyJeRXnb2sW6H8s=;
	b=YmNvW+A0d9CryZ6SR6/d7c4ZewO7Ln7Yo2ept/QVKsRjxRGMjXOjNYAcvfWl2oyDwDinXh
	iymMf0oPNMcUe4/F1kUJDl2FRYu7+ygjiPGvnY0UxHytzf8KqWyiE15M1jx9J6O8ah6pKh
	jgAQUp0A54bUIzPk3XLyHdCA1iiTtYI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-uPmgm4oYNdKet9_f6U7kAQ-1; Mon, 09 Nov 2026 15:19:36 -0500
X-MC-Unique: uPmgm4oYNdKet9_f6U7kAQ-1
X-Mimecast-MFC-AGG-ID: uPmgm4oYNdKet9_f6U7kAQ_1794255576
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f32050e72so249931585a.1
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 12:19:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794255576; x=1794860376;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cr6YGRe9Ov6g/VRUB3PYrERXuhR5Chhj/ZhidIfJ8oc=;
        b=Mj8ElaY544vrTKGFTrjSeKhCCqEK31R4PrduXyTrLgn2n5wPjf7Lfbs2nIKZE6FAu9
         mWVnfF8LEnfvV3Bjs8OBP/YFKynfAR0shptoKf4z7tblwuchXumn4Kx+/zP9o2XZyhMT
         ECThla006XbfBjWE+FE+ewwRxXLVZTQDEymMS0UkFx+nedUAXiabGpbUfdK6novvk+Y9
         T+68+Bi2KnLKoJvT4ofbUDLiYHFFrP01M8UL1uEko3+pv2y4srT4806xBtKwOC6Vu0DH
         0/DUuJP9MVQ9Hrav8XGEhUbdt5RWnEhdCMkCa8Gh6mIKBoQjP/W2UCjOtAtH5KXYQdGU
         HiRQ==
X-Forwarded-Encrypted: i=1; AL+hErHjG+kGSpwzpRHSTMmmejImkEurD0B3xuhrnDHTVA9GAZEi6tOPjyahyUolpD+aVzqwSHAr4QOnmQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+WbnaCZ5HamYNx8UG/LLp2sY5c4+gKY4SbmmnrC51KH+3S8/nA
	yBwhYI2RMb73zvXrU+Uz2Zaj5093tlsVZS5kkacJcfP71TdY+DRjvwC6GJL/Rhn4gyZKPq63bpK
	i2vp5HMQMsLyyt2oQiW3TQkt36eqwfaabHPGXfunb1DCislI+5j3PFnUWjyzT
X-Gm-Gg: AYBFou3jMlvq5F9GZWLC9oTDFxCbzsa0PPCzbTA47CHsZQeN2ApBtP7zxUTpGBFYGCa
	5nRvagNv5Xw5P0R/wC2+fJpU9ThxLtnC8M13CtEVt4fz8BijiId7Zast/kHmlKdeurRXRWpmuHF
	kuuuQzTp10+T1iDarcarMnpjRQScf/SGNUe7Aup/niVhiHlyyMONlmIdX7Mps9R4pYfB9zRZekT
	CLWP9p8A4LwT/B/GRfz4g0362HE6jdluMU1XQuXk/pQ27gRDoT5bYH0mqdByxPBCi7yC77dW6IJ
	7nISCufVaWViyuWTM4HmFbX28FCvkVMmmfIEzUSGu5GE32gKNPa9c2ve4NLexGA75dJAwogJ3Gr
	GvKG9Oy79U+byjEeWTbA0j68lQJyM5Nft1zqxz4L9/wXBczX34G0m/F8drNGQPBvbwfY12poF1X
	+UEvTFYyWyEM1CvVdrUwGj87ibs00JJlgX0L7SXSELb7NGyW6e1NOIULfJEWk974BcbexeHec=
X-Received: by 2002:a05:620a:4886:b0:946:2a0:a11b with SMTP id af79cd13be357-9479f32f250mr105891985a.35.1794255575620;
        Mon, 09 Nov 2026 12:19:35 -0800 (PST)
X-Received: by 2002:a05:620a:4886:b0:946:2a0:a11b with SMTP id af79cd13be357-9479f32f250mr105881985a.35.1794255574608;
        Mon, 09 Nov 2026 12:19:34 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7d10c4sm54455085a.32.2026.11.09.12.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 12:19:33 -0800 (PST)
Message-ID: <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: John Garry <john.garry@linux.dev>,
 james.bottomley@hansenpartnership.com, 	mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, 	dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
Date: Mon, 09 Nov 2026 15:19:32 -0500
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Rl7IcGXEp_y-cemvCMAMgMuG-LTR0PwFG3uTc971pmk_1794255576
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-11-08 at 20:47 +0000, John Garry wrote:
> NATIVE SCSI MULTIPATH:
>=20
> This series introduces native SCSI multipath support. It is intended
> as
> an alternative to dm-mpath.
>=20
> This support aims to provide a multipath-enabled SCSI block device/
> gendisk.
>=20
> For a SCSI device to support native multipath, either of the
> following
> conditions must be satisfied:
> a. unique ID in VPD page 83 and ALUA support and scsi_multipath
> modparam
> =C2=A0=C2=A0 enabled
> b. unique ID in VPD page 83 and scsi_multipath_always modparam
> enabled
>=20
> This series relies on reading sdev->access_state to get path
> information.
> This path information would be provided by ALUA. ALUA support which
> does
> not rely on device handlers has already been discussed at
> https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@o=
racle.com/
> and support will be added in the next phase.
>=20
> New classes of devices are added:
> - scsi_mpath_device
> - scsi_mpath_disk
>=20
> These are required since a multipath scsi_device has no common scsi
> host.
> An example of the sysfs files and directories for these new classes
> is as
> follows:
>=20
> $ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
> total 0
> -rw-r--r--=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096 Feb 25 11:59 iopolicy
> drwxr-xr-x=C2=A0=C2=A0=C2=A0 2 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11=
:59 multipath
> drwxr-xr-x=C2=A0=C2=A0=C2=A0 2 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11=
:59 power
> lrwxrwxrwx=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11=
:59 subsystem ->
> ../../../../class/scsi_mpath_device
> -rw-r--r--=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096 Feb 25 11:58 uevent
> -r--r--r--=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096 Feb 25 11:59 vpd_id
> $ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
> total 0
> lrwxrwxrwx=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11=
:59 8:0:0:0 ->
> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
> lrwxrwxrwx=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11=
:59 9:0:0:0 ->
> ../../../../platform/host9/session2/target9:0:0/9:0:0:0
> $ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
> naa.600140505200a986f0043c9afa1fd077
> $ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
> numa
> $
>=20
> $ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
> total 0
> drwxr-xr-x=C2=A0=C2=A0=C2=A0 2 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 12=
:00 power
> drwxr-xr-x=C2=A0=C2=A0 11 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11:58=
 sdc
> lrwxrwxrwx=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 11=
:58 subsystem ->
> ../../../../class/scsi_mpath_disk
> -rw-r--r--=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096 Feb 25 11:58 uevent
> $ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
> total 0
> lrwxrwxrwx=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 12=
:00 sdc:0 ->
> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:
> 0
> lrwxrwxrwx=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 Feb 25 12=
:00 sdc:1 ->
> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:
> 1
>=20
> $ ls -l /dev/sdc
> brw-rw----=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 disk=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8,=C2=A0 32 Feb 25 11:58 /dev/sdc
>=20
> The scsi_device and scsi_disk classes otherwise remain unmodified.
> However, the per-path block device is hidden in /dev/. Furthermore,
> multipathed block devices have a new naming scheme, sdX:Y, where
> X is the scsi multipath device index and Y is the path index.
>=20
> No multipath sg support is added. We still have a per-path sg device.
> Since the SCSI block device is multipath enabled, we can access
> multipathed scsi_ioctl() through that block device.
>=20
> For failover, we take the approach of cloning bio's and re-submitting
> them
> in full (for failover errors).
>=20
> LIBMULTIPATH:
>=20
> This series introduces also libmultipath. It is essentially a
> refactoring
> of NVME multipath support, so we can have a common library to also
> support
> native SCSI multipath.
>=20
> Much of the code is taken directly from the NVMe multipath code.
> However,
> NVMe specifics are removed. A template structure is provided so the
> driver
> -may provide callbacks for driver specifics, like ANA support for
> NVMe.
>=20
> Important new structures introduced include:
>=20
> - mpath_head
> These contain much of the multipath-specific functionality from
> nvme_ns_head, including a pointer to the gendisk structure and
> a path SRCU-based array.
>=20
> - mpath_device
> This is the per-path structure, and contains much the same
> multipath-specific functionality in nvme_ns
>=20
> libmultipath provides functionality for path management, path
> selection,
> data path, and failover handling.
>=20
> Full series also available at
> https://github.com/johnpgarry/linux/tree/scsi-multipath-v7.4-v9
>=20
> Differences to v8:
> - Rebase
> - Hardening changes advised by sashiko, including "Clear cmd->flags"
> =C2=A0 change
>=20
> Differences to v7:
> - rebase
> - simplify scsi_mpath_clone_end_io() (sashiko)
> - rename bio_list_add_clone() -> bio_list_add_master()
> - rework checks in mpath_alloc_disk_head() (sashiko)
>=20
> John Garry (29):
> =C2=A0 scsi: core: Clear cmd->flags for terminal queuing error
> =C2=A0 libmultipath: Add initial framework
> =C2=A0 libmultipath: Add basic gendisk support
> =C2=A0 libmultipath: Add path selection support
> =C2=A0 libmultipath: Add bio handling
> =C2=A0 libmultipath: Add support for mpath_device management
> =C2=A0 libmultipath: Add delayed removal support
> =C2=A0 libmultipath: Add sysfs helpers
> =C2=A0 libmultipath: Add support for block device IOCTL
> =C2=A0 libmultipath: Add mpath_bdev_getgeo()
> =C2=A0 libmultipath: Add mpath_bdev_get_unique_id()
> =C2=A0 scsi-multipath: introduce basic SCSI device support
> =C2=A0 scsi-multipath: introduce scsi_device head structure
> =C2=A0 scsi-multipath: provide sysfs link from to scsi_device
> =C2=A0 scsi-multipath: support iopolicy
> =C2=A0 scsi-multipath: clone each bio
> =C2=A0 scsi-multipath: clear path when device is blocked
> =C2=A0 scsi-multipath: revalidate paths upon device unblock
> =C2=A0 scsi-multipath: failover handling
> =C2=A0 scsi-multipath: provide callbacks for path state
> =C2=A0 scsi-multipath: add scsi_mpath_{start,end}_request()
> =C2=A0 scsi-multipath: update request for terminal request queuing error
> =C2=A0 scsi-multipath: add delayed disk removal support
> =C2=A0 scsi: sd: add multipath disk class
> =C2=A0 scsi: sd: add multipath disk attr groups
> =C2=A0 scsi: sd: support multipath disk
> =C2=A0 scsi: sd: add mpath_dev file
> =C2=A0 scsi: sd: add mpath_numa_nodes dev attribute
> =C2=A0 scsi: sd: add mpath_queue_depth dev attribute
>=20
> =C2=A0drivers/scsi/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 10 +
> =C2=A0drivers/scsi/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> =C2=A0drivers/scsi/scsi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 8 +-
> =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
 20 +-
> =C2=A0drivers/scsi/scsi_multipath.c | 691 +++++++++++++++++++++++++
> =C2=A0drivers/scsi/scsi_scan.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 4 +
> =C2=A0drivers/scsi/scsi_sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 10 +
> =C2=A0drivers/scsi/sd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 611 +++++++++++++++++++++-
> =C2=A0drivers/scsi/sd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0include/linux/multipath.h=C2=A0=C2=A0=C2=A0=C2=A0 | 156 ++++++
> =C2=A0include/scsi/scsi_cmnd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 9 +-
> =C2=A0include/scsi/scsi_device.h=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0include/scsi/scsi_driver.h=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 4 +
> =C2=A0include/scsi/scsi_host.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 4 +
> =C2=A0include/scsi/scsi_multipath.h | 129 +++++
> =C2=A0lib/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 6 +
> =C2=A0lib/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0lib/multipath.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 948
> ++++++++++++++++++++++++++++++++++
> =C2=A018 files changed, 2592 insertions(+), 26 deletions(-)
> =C2=A0create mode 100644 drivers/scsi/scsi_multipath.c
> =C2=A0create mode 100644 include/linux/multipath.h
> =C2=A0create mode 100644 include/scsi/scsi_multipath.h
> =C2=A0create mode 100644 lib/multipath.c
>=20
>=20
>=20
On 08/11/2026 20:47, John Garry wrote:
> This series relies on reading sdev->access_state to get path
information.
> This path information would be provided by ALUA. ALUA support which
does
> not rely on device handlers has already been discussed at
>
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@ora=
cle.com/
> and support will be added in the next phase.

Hi John,

I have been testing v9 (your scsi-multipath-v7.4-v9 branch, on
7.4-rc1) on real hardware and found two problems with ALUA arrays,
one in scsi_dh_alua and one in the series itself.

Setup:
- HP P2000 G3 FC array, implicit ALUA, two port groups (one per
  controller)
- 2 FC HBAs, 2 target ports each, 30 LUNs with 4 paths per LUN
- scsi_mod.multipath=3Don, dm-multipath not in use
- Under dm-multipath, the same LUNs show port group 1 at prio 50
  (active/optimized) and port group 0 at prio 10
  (active/non-optimized)

1. sdev->access_state is wrong after boot (scsi_dh_alua, not this
   series)

After boot, every path read active/optimized in
/sys/class/scsi_device/H:C:T:L/device/access_state, while sg_rtpg
reports port group 0 as active/non-optimized. No
"alua: port group XX state ..." message was logged at all.

Since 50759b881e1d ("scsi: device_handler: alua: Call
scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
queues an RTPG if sdev->handler_data is set, but alua_bus_attach()
sets handler_data after alua_initialize() has tried to queue the
initial RTPG. That RTPG is dropped, and access_state stays at its
zeroed default (active/optimized) until something calls
scsi_dh_activate(). dm-multipath hides this through pg_init; native
multipath never calls activate, so the series sees every path as
optimized.

I have sent a separate fix for this to linux-scsi:
https://lore.kernel.org/linux-scsi/20261109201120.1067815-1-loberman@redhat=
.com/
It is independent of your series, but without it, native multipath
on ALUA arrays has no correct path state.

2. ANO paths are ranked the same as AO paths

With the ALUA state corrected (by writing "activate" to dh_state, or
with the fix above), I/O still went to active/non-optimized paths.
scsi_multipath_sdev_init() sets mpath_device->access_state to
MPATH_STATE_OPTIMIZED and nothing updates it, while
__mpath_find_path(), mpath_round_robin_path() and
mpath_queue_depth_path() rank paths by that field. Only
scsi_mpath_is_optimized()/is_disabled() read sdev->access_state.

With numa, the first path in dev_list wins for every node, and
dev_list order follows sd probe completion, so for about a third of
the LUNs the current path was an ANO path. Example, LUN sdn, reads
completed per path for a 2000 x 1M O_DIRECT dd (:0/:3 AO, :1/:2 ANO
at the time):

  sdn:0 0   sdn:1 2000   sdn:2 0   sdn:3 0

Every read went through the non-owning controller. From the code, for
these LUNs the numa recheck of is_optimized() fails on every I/O and
__mpath_find_path() picks the same ANO path again.

With the change below (a template callback so the selectors use the
live state), plus the scsi_dh_alua fix, all 30 LUNs pick an AO
current path at boot, and on LUN sdl (:0/:2 AO, :1/:3 ANO):

  numa         2000     0     0     0
  round-robin  1000     0  1000     0
  queue-depth 18039     0 13961     0   (8 parallel dd, 64k)

No I/O reached the ANO paths under any policy. This is a test patch to
show the problem, not a polished change - feel free to fold it in or
do it differently.

3. Smaller points

- numa with equal NUMA distance uses one path per LUN, so with two AO
  paths through two HBAs, half the optimized bandwidth is idle (sdl:2
  above under numa). That matches NVMe, but users coming from
  dm-multipath service-time will notice. Would round-robin or
  queue-depth be a better default for SCSI?

- There are no Documentation/ABI entries for the new sysfs attributes
  (scsi_mpath_device vpd_id/iopolicy/multipath, delayed_removal_secs,
  mpath_dev, mpath_numa_nodes, mpath_queue_depth), and the
  scsi_mod.multipath and multipath_iopolicy parameters are not in
  kernel-parameters.txt. I have a draft ABI file if useful.

- There is no userspace tool yet to show heads, paths and ALUA state
  (the equivalent of multipath -ll or nvme list-subsys). I used a
  small sysfs script for this testing. Ben, is native SCSI multipath
  support in multipath-tools planned?

- CONFIG_SCSI_MULTIPATH/CONFIG_LIBMULTIPATH are only enabled in your
  branch's x86_64_defconfig, so building from a distro config leaves
  them off, and scsi_mod.multipath=3D is silently ignored. Maybe worth a
  note in the cover letter.

I have not tested failover or path loss yet; I will follow up with
that and a Tested-by once done.

Thanks,
Laurence

-- >8 --
From: Laurence Oberman <loberman@redhat.com>
Subject: [PATCH TEST] libmultipath/scsi-multipath: rank paths by live
ALUA access state

mpath_device->access_state is set to MPATH_STATE_OPTIMIZED in
scsi_multipath_sdev_init() and never updated, so the path selectors
rank active/non-optimized paths equal to active/optimized ones.

Add an optional mpath_head_template.access_state() callback, used by
the selectors in place of the cached field when provided, and
implement it for SCSI by mapping the live sdev->access_state.

No change notification is needed: numa rechecks is_optimized() per
I/O and re-runs __mpath_find_path() when the current path is no
longer optimized; round-robin and queue-depth walk the list per I/O.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
diff --git a/drivers/scsi/scsi_multipath.c
b/drivers/scsi/scsi_multipath.c
index 58b0be88a..bdae08ecd 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -330,6 +330,23 @@ static bool scsi_mpath_is_optimized(struct
mpath_device *mpath_device)
 =09return access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL;
 }
=20
+static enum mpath_access_state scsi_mpath_access_state(
+=09=09=09struct mpath_device *mpath_device)
+{
+=09struct scsi_mpath_device *scsi_mpath_dev =3D
+=09=09=09=09to_scsi_mpath_device(mpath_device);
+=09struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
+
+=09switch (READ_ONCE(sdev->access_state) &
SCSI_ACCESS_STATE_MASK) {
+=09case SCSI_ACCESS_STATE_OPTIMAL:
+=09=09return MPATH_STATE_OPTIMIZED;
+=09case SCSI_ACCESS_STATE_ACTIVE:
+=09=09return MPATH_STATE_NONOPTIMIZED;
+=09default:
+=09=09return MPATH_STATE_OTHER;
+=09}
+}
+
 static bool scsi_mpath_available_path(struct mpath_device
*mpath_device)
 {
 =09struct scsi_mpath_device *scsi_mpath_dev =3D
@@ -374,6 +391,7 @@ static struct mpath_head_template smpdt =3D {
 =09.remove_head =3D scsi_mpath_remove_head_work,
 =09.is_disabled =3D scsi_mpath_is_disabled,
 =09.is_optimized =3D scsi_mpath_is_optimized,
+=09.access_state =3D scsi_mpath_access_state,
 =09.available_path =3D scsi_mpath_available_path,
 =09.clone_bio =3D scsi_mpath_clone_bio,
 };
diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 7a3708ff3..b47785804 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -39,6 +39,7 @@ struct mpath_head_template {
 =09void (*remove_head)(struct mpath_head *);
 =09bool (*is_disabled)(struct mpath_device *);
 =09bool (*is_optimized)(struct mpath_device *);
+=09enum mpath_access_state (*access_state)(struct mpath_device
*);
 =09struct bio *(*clone_bio)(struct bio *);
 =09const struct attribute_group **device_groups;
 };
diff --git a/lib/multipath.c b/lib/multipath.c
index b03080afb..3ddb7296a 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -142,6 +142,19 @@ static bool mpath_path_is_disabled(struct
mpath_head *mpath_head,
 =09return mpath_head->mpdt->is_disabled(mpath_device);
 }
=20
+/*
+ * Use the driver's live view of the path access state if it provides
one,
+ * otherwise fall back to the cached mpath_device->access_state.
+ */
+static enum mpath_access_state mpath_path_access_state(
+=09=09=09struct mpath_head *mpath_head,
+=09=09=09struct mpath_device *mpath_device)
+{
+=09if (mpath_head->mpdt->access_state)
+=09=09return mpath_head->mpdt->access_state(mpath_device);
+=09return mpath_device->access_state;
+}
+
 static struct mpath_device *__mpath_find_path(struct mpath_head
*mpath_head,
 =09=09=09=09=09int node)
 {
@@ -161,7 +174,7 @@ static struct mpath_device
*__mpath_find_path(struct mpath_head *mpath_head,
 =09=09else
 =09=09=09distance =3D LOCAL_DISTANCE;
=20
-=09=09switch(mpath_device->access_state) {
+=09=09switch (mpath_path_access_state(mpath_head,
mpath_device)) {
 =09=09case MPATH_STATE_OPTIMIZED:
 =09=09    if (distance < found_distance) {
 =09=09=09    found_distance =3D distance;
@@ -206,7 +219,7 @@ static struct mpath_device *mpath_round_robin_path(
 {
 =09struct mpath_device *mpath_device, *found =3D NULL;
 =09int node =3D numa_node_id();
-=09enum mpath_access_state access_state_old;
+=09enum mpath_access_state access_state_old, state;
 =09struct mpath_device *old =3D
 =09=09=09srcu_dereference(mpath_head-
>current_path[node],
 =09=09=09=09&mpath_head->srcu);
@@ -226,11 +239,12 @@ static struct mpath_device
*mpath_round_robin_path(
=20
 =09=09if (mpath_path_is_disabled(mpath_head, mpath_device))
 =09=09=09continue;
-=09=09if (mpath_device->access_state =3D=3D
MPATH_STATE_OPTIMIZED) {
+=09=09state =3D mpath_path_access_state(mpath_head,
mpath_device);
+=09=09if (state =3D=3D MPATH_STATE_OPTIMIZED) {
 =09=09=09found =3D mpath_device;
 =09=09=09goto out;
 =09=09}
-=09=09if (mpath_device->access_state =3D=3D
MPATH_STATE_NONOPTIMIZED)
+=09=09if (state =3D=3D MPATH_STATE_NONOPTIMIZED)
 =09=09=09found =3D mpath_device;
 =09}
=20
@@ -240,7 +254,7 @@ static struct mpath_device *mpath_round_robin_path(
 =09 *  - no other optimized path found and current is optimized,
 =09 *  - no other usable path found and current is usable.
 =09 */
-=09access_state_old =3D old->access_state;
+=09access_state_old =3D mpath_path_access_state(mpath_head, old);
 =09if (!mpath_path_is_disabled(mpath_head, old) &&
 =09    (access_state_old =3D=3D MPATH_STATE_OPTIMIZED ||
 =09    (!found && access_state_old =3D=3D MPATH_STATE_NONOPTIMIZED)))
@@ -270,7 +284,7 @@ static struct mpath_device *mpath_queue_depth_path(
=20
 =09=09depth =3D atomic_read(mpath_device->nr_active);
=20
-=09=09switch (mpath_device->access_state) {
+=09=09switch (mpath_path_access_state(mpath_head,
mpath_device)) {
 =09=09case MPATH_STATE_OPTIMIZED:
 =09=09=09if (depth < min_depth_opt) {
 =09=09=09=09min_depth_opt =3D depth;

