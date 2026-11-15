Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794772249;
	b=ecXZ/LeuLU3Z5XER39tuz7oqS+8d4MKMDKcZRUlA7dVWkqxBqE+HcUSE/TyI4zGhAAJc
	 NzqyXD+dzz0mVObFD5grlm2IsQnE3cgSWgqEqcPi2BH8ewWjwwtgubwF4725N2PVPv6j8
	 d4yzG2OScMjxvyg3eGzwtlfGOIJlR3GCHj8QpkOreZosp27OueoUztAHNjaU4eJpgzNd9
	 boWoQqm3VR/9ngogFubHZ9BLkspy9XRfqUUr+MslsrpAaIN/p/uzP0pefRCIkqNzmQHw4
	 LZgTgVGkZvGJPnOtArDP/86M2BuJHjFnCZbpLieQBKykkf7XToCWZCBeVLJCBa8LbFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794772249;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:User-Agent:MIME-Version:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
	b=2MHLa/qspV5mmPG5EhACtQiSywfumtZkVnUlfWar2Jd0PsV9tS8e7JmzGubV/Dii0v2J
	 yQmiGyrX1Ypy/CD8qXO7Igp5KYqLbPSc4JqfuFOjS1q6ptOGfeYgV8QQ6pkzNxplW8jbv
	 qvd2KCEZHJy9/EBAxIayXUaiDYmErPwBrK84fJzAWehLGZxEwI3dsBdQGzqTmzFw50vcH
	 +UKgmT6yJzsF0l6B2+sicbdPI5xJhaVOkWyARqfqSEU5oHo4En/Jq3ve3snkckR+nfSdN
	 dI2fjbJf8dn0lf/EopHb2zhIl0y6jzrZhAdz0Z9ou7zF70jR77yO+nsvseKF5HvAphw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="bLdjSll/";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631D606A330
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 19:50:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D631D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bLdjSll/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794772247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
	b=bLdjSll/l9yjo7E4PUxXY+GVNoYMDwmVUpaj+61iO1rmW6oGhbfP0+S52SiRpN77tLNAUL
	sd6LiI01JUZJQ8X+tykgKl6sNocVD6n001KyP5glU5eYNMK7abtYuGiu/qv7Q28LR9SCuM
	uxNU+DfrtHdSjtYtJz8TATKQxyXlF3E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-e6AktsK7NiCzCyldV2UCuw-1; Sun, 15 Nov 2026 14:50:46 -0500
X-MC-Unique: e6AktsK7NiCzCyldV2UCuw-1
X-Mimecast-MFC-AGG-ID: e6AktsK7NiCzCyldV2UCuw_1794772246
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5363fa3d3e4so55177821cf.0
        for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 11:50:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794772246; x=1795377046;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
        b=JccGFMl4TqAAPfTWHpj6DTI4N/4ye5b0tWmPvyR/HGmeHD3dXeOH6HSXFJae/HqpkR
         ZpKDJyf/O8nJ4xfvLORNeFWbXKCe3QksLklQD2shf3+ZrP+BgOUfpUEX6/SIQJA/woCf
         CnbA3w8WzJvK10PzYVjP+4SpumX11sqo04FrswtIHRKiSteNfPr//mNiurWUopGrA/FU
         x3iEpMElX2rJePdCOecPxbd4vlw668RTttpJFtdoxYzEaxnk3/Pr/sMsyCeGwh0omN0+
         T2pdMdbkJch7MBJ/dIrzSgmGq6Pp/9VPIqgAdE/BxgtZdqZJk7KLP/mKntjyEsYGlt47
         33aA==
X-Forwarded-Encrypted: i=1; AL+hErG7XiqhFy7d9h7Dh33zMgvd9TSQp5B1CrYAjDGZsMT0zwlT7EmaHF8rNZ/4+NwuJ1nC3Li7b2kE4w==@lists.linux.dev
X-Gm-Message-State: APuU4Z/VrdB7StBLZ6Jpux+f14MkrYCdijGuPUmg1CNtsWp54DviqD2g
	rYU8lX/DAp7KzoldT+niQ70MeZJQBrQZqKvpd/pbpEMlPhwDY4xKfc/lfbNBOlmk+8vuFIPPr5l
	HBbzP7D3gPTBglnNebvH4XL442TVaLoO9KUiT8bQ+n8ZNwKmMwoFqNBHK9C8r
X-Gm-Gg: AYBFou07U93Yccqk5fMFhkqXlUmLBCZeMH0TUjp72sw6HrmsrMVCNu3N1ON42X8mJd+
	7mbHrdmDh2jifX/t7GU4tK6uSTSjll1dBJfg1WHAYqQ6m+URmvOicPwEqzwiWEt5tG6cX8Zv4Va
	ZehTquU+aBdaTQ4dSMMIz3rBp8hmcu8VMouw+2Q+mfmbNTG1qoP9PqbUny2DHy1y6G9TX0Pcbz8
	xzjapRxfnN5d4UGfbpv6IEN19mDAUwbLtncO/REtA4QFCEX679jfNnfPgFceZhUjEttMd0AyxaW
	Z0ZYOZPnOpxE8mFuN3WoWFu/nGMEWGLwA82MAj3ml5Nkcf7Mtor3Va29DMDIlcv1zv9RIfKdPC/
	1Ex6xTrWKrvY1wl8DOodG7ZLqluNtguA0vSopKZSmLVxv/xNgVeUnR1qZCDvf1Lv290W661eDEr
	D4x9pqv7oKEocVA93sAqnptLFQAsydahxYk2Me8IKLtl5dmZ1cpp1DYz2X1DLVMbT24oPkYQ==
X-Received: by 2002:ac8:5a0f:0:b0:533:2ef6:d98a with SMTP id d75a77b69052e-55ac7b5ad89mr149141111cf.29.1794772245976;
        Sun, 15 Nov 2026 11:50:45 -0800 (PST)
X-Received: by 2002:ac8:5a0f:0:b0:533:2ef6:d98a with SMTP id d75a77b69052e-55ac7b5ad89mr149140871cf.29.1794772245494;
        Sun, 15 Nov 2026 11:50:45 -0800 (PST)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55c3b7a4adbsm42557101cf.19.2026.11.15.11.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 11:50:44 -0800 (PST)
Message-ID: <fdda7a0e1caab6dda5177bdcf2ccaed4f4f63a24.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: John Garry <john.garry@linux.dev>,
 james.bottomley@hansenpartnership.com, 	mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, 	dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
Date: Sun, 15 Nov 2026 14:50:43 -0500
In-Reply-To: <01eac6bf-8df7-4e7a-8cc6-93e013750bce@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
	 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
	 <01eac6bf-8df7-4e7a-8cc6-93e013750bce@linux.dev>
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
X-Mimecast-MFC-PROC-ID: JpG4lmM71WoJrtMlqBqEf-4jSPZBs_8OEeTd6djafVs_1794772246
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-11-15 at 18:59 +0000, John Garry wrote:
> On 11/9/26 20:19, Laurence Oberman wrote:
> > 2. ANO paths are ranked the same as AO paths
> >=20
> > With the ALUA state corrected (by writing "activate" to dh_state,
> > or
> > with the fix above), I/O still went to active/non-optimized paths.
> > scsi_multipath_sdev_init() sets mpath_device->access_state to
> > MPATH_STATE_OPTIMIZED and nothing updates it, while
> > __mpath_find_path(), mpath_round_robin_path() and
> > mpath_queue_depth_path() rank paths by that field. Only
> > scsi_mpath_is_optimized()/is_disabled() read sdev->access_state.
> >=20
> > With numa, the first path in dev_list wins for every node, and
> > dev_list order follows sd probe completion, so for about a third of
> > the LUNs the current path was an ANO path. Example, LUN sdn, reads
> > completed per path for a 2000 x 1M O_DIRECT dd (:0/:3 AO, :1/:2 ANO
> > at the time):
> >=20
> > =C2=A0=C2=A0 sdn:0 0sdn:1 2000sdn:2 0sdn:3 0
> >=20
> > Every read went through the non-owning controller. From the code,
> > for
> > these LUNs the numa recheck of is_optimized() fails on every I/O
> > and
> > __mpath_find_path() picks the same ANO path again.
> >=20
> > With the change below (a template callback so the selectors use the
> > live state), plus the scsi_dh_alua fix, all 30 LUNs pick an AO
> > current path at boot, and on LUN sdl (:0/:2 AO, :1/:3 ANO):
> >=20
> > =C2=A0=C2=A0 numa=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2000=
=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=
=A0 0
> > =C2=A0=C2=A0 round-robin=C2=A0 1000=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 100=
0=C2=A0=C2=A0=C2=A0=C2=A0 0
> > =C2=A0=C2=A0 queue-depth 18039=C2=A0=C2=A0=C2=A0=C2=A0 0 13961=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 (8 parallel dd, 64k)
> >=20
> > No I/O reached the ANO paths under any policy. This is a test patch
> > to
> > show the problem, not a polished change - feel free to fold it in
> > or
> > do it differently.
>=20
>=20
> JFYI, the work which I did for ALUA support a while ago is here:
> #
> https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.3-v7-alu
> a/
>=20
> I don't think that I shared this previously.
>=20
> I do notice that it would conflict with your work to do some=20
> centralising of the ALUA RTPG support.
>=20
> About the NUMA iopolicy - apart from issues in this series with not=20
> checking optimised/access_state properly - it does seem less than=20
> optimal to we only favour one device per NUMA node (when all in same=20
> optimized + enabled state). NVMe multipath support does the same. I=20
> suppose that this iopolicy relies on us having one device/path per
> NUMA=20
> node.
>=20
> Thanks,
> John
>=20
Hi John,

Thanks for the pointer, I had a look. Keeping mpath_device.access_state
in sync from the RTPG result in scsi_mpath_update_access_state() is a
cleaner way to address the ranking problem I reported, so I'm fine to
go with your approach and drop my test patch.

> I do notice that it would conflict with your work to do some
> centralising of the ALUA RTPG support.

Understood. My scsi_dh_alua patch is only the handler_data ordering
fix in alua_bus_attach(), so I'm happy to rebase or rework it on top of
your core ALUA changes if that helps.

When you have the ALUA support rebased onto v9 or v10, I'm happy to
test it on the P2000 G3 setup (dual controller, 30 LUNs, 4 paths each)
and confirm the AO/ANO path selection.

> About the NUMA iopolicy - apart from issues in this series with not
> checking optimised/access_state properly - it does seem less than
> optimal to we only favour one device per NUMA node (when all in same
> optimized + enabled state). NVMe multipath support does the same. I
> suppose that this iopolicy relies on us having one device/path per
> NUMA node.

Agreed. On FC/iSCSI hosts it's common to have several AO paths per LUN
at the same NUMA distance (all paths here report numa_nodes=3D0-1), so
round-robin or queue-depth may be the better default for SCSI. Your
call.

Thanks,
Laurence

