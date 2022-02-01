Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92986C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 11:12:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-tK3eHCJlMfqYZLHYkbtfSw-1; Tue, 01 Feb 2022 06:12:00 -0500
X-MC-Unique: tK3eHCJlMfqYZLHYkbtfSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8E7E189DF42;
	Tue,  1 Feb 2022 11:11:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BEDD66E3A;
	Tue,  1 Feb 2022 11:11:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F22174BB7C;
	Tue,  1 Feb 2022 11:11:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211BBo85029214 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 06:11:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A0983401E3D; Tue,  1 Feb 2022 11:11:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D327401E77
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 11:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81FAD85A5AA
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 11:11:50 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-635-BBcf0_QTPZOFWHuToLd_tw-1; Tue, 01 Feb 2022 06:11:47 -0500
X-MC-Unique: BBcf0_QTPZOFWHuToLd_tw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 635C61F383;
	Tue,  1 Feb 2022 11:11:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0640413D62;
	Tue,  1 Feb 2022 11:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +A38OnAV+WF8JwAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 01 Feb 2022 11:11:44 +0000
Message-ID: <5eda612b861cf911319087c4c5af8bb6815e1928.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>
Date: Tue, 01 Feb 2022 12:11:44 +0100
In-Reply-To: <20220201105507.rq7rll4qjhxonzu6@alatyr-rpi.brq.redhat.com>
References: <a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
	<712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
	<20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
	<3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
	<20220201105507.rq7rll4qjhxonzu6@alatyr-rpi.brq.redhat.com>
User-Agent: Evolution 3.42.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 211BBo85029214
X-loop: dm-devel@redhat.com
Cc: Franck Bui <fbui@suse.de>, lvm-devel@redhat.com, dm-devel@redhat.com,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-02-01 at 11:55 +0100, Peter Rajnoha wrote:
>=20
> Thing is, we only restore DM_* values in 10-dm.rules, but we need to
> do
> the same for blkid values. That would be a patch like this on top of
> yours:

Right. For those devices I'm mainly concerned about, this is done in
11-dm-mpath.rules and 11-dm-parts.rules (both part of multipath-tools).

https://github.com/opensvc/multipath-tools/blob/master/multipath/11-dm-mpat=
h.rules
https://github.com/opensvc/multipath-tools/blob/master/kpartx/dm-parts.rule=
s

If you want the same functionality for generic dm devices, you need
these import statements in the generic code as well.

I should have added the imports right away, I might have been causing
less confusion. But I thought I'd cause less potential for regressions
this way, as all the SYMLINK+=3D... rules first test whether the related
properties are non-empty.

>=20
> =A0udev/13-dm-disk.rules.in | 14 ++++++++++++--
> =A01 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
> index 5cc08121e..9b1a0b562 100644
> --- a/udev/13-dm-disk.rules.in
> +++ b/udev/13-dm-disk.rules.in
> @@ -17,12 +17,22 @@ ENV{DM_UDEV_DISABLE_DISK_RULES_FLAG}=3D=3D"1",
> GOTO=3D"dm_end"
> =A0SYMLINK+=3D"disk/by-id/dm-name-$env{DM_NAME}"
> =A0ENV{DM_UUID}=3D=3D"?*", SYMLINK+=3D"disk/by-id/dm-uuid-$env{DM_UUID}"
> =A0
> -ENV{DM_SUSPENDED}=3D=3D"1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=3D=3D"1",
> GOTO=3D"dm_link"
> -ENV{DM_NOSCAN}=3D=3D"1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=3D=3D"1",
> GOTO=3D"dm_link"
> +ENV{DM_SUSPENDED}=3D=3D"1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=3D=3D"1",
> GOTO=3D"dm_blkid_restore"
> +ENV{DM_NOSCAN}=3D=3D"1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=3D=3D"1",
> GOTO=3D"dm_blkid_restore"
> =A0ENV{DM_SUSPENDED}=3D=3D"1", GOTO=3D"dm_end"
> =A0ENV{DM_NOSCAN}=3D=3D"1", GOTO=3D"dm_watch"
> =A0
> =A0(BLKID_RULE)
> +GOTO=3D"dm_link"
> +
> +LABEL=3D"dm_blkid_restore"
> +IMPORT{db}=3D"ID_FS_USAGE"
> +IMPORT{db}=3D"ID_FS_UUID_ENC"
> +IMPORT{db}=3D"ID_FS_LABEL_ENC"
> +IMPORT{db}=3D"ID_PART_ENTRY_UUID"
> +IMPORT{db}=3D"ID_PART_ENTRY_SCHEME"
> +IMPORT{db}=3D"ID_PART_ENTRY_NAME"
> +IMPORT{db}=3D"ID_PART_GPT_AUTO_ROOT"

This looks ok. The list of variables is a little different in the
multipath rules files. Anyway, the only properties that matter are
those for which we're going to create symlinks for.=20

In general, the approach of doing this here is somewhat fragile - when
udev's blkid changes, the list of determined / required device
properties might change as well. It'd be optimal to move this logic
into udev proper, into the generic rules that handle storage device
naming (60-persistent-storage.rules). Then all we'd need to do in the
dm rules would be to set a flag telling udev that blkid shouldn't be
called because it might hang, and perhaps another one to tell that it's
OK to import the properties from the db instead.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

