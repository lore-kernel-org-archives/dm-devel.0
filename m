Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED10C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 15:58:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-AMxYvn6MPdSnp8GFXWSFug-1; Fri, 28 Jan 2022 10:58:17 -0500
X-MC-Unique: AMxYvn6MPdSnp8GFXWSFug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDF93839A46;
	Fri, 28 Jan 2022 15:58:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC75F7CD60;
	Fri, 28 Jan 2022 15:58:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 62E4E4BB7C;
	Fri, 28 Jan 2022 15:58:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SFw4QV025929 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 10:58:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8E6734328D9; Fri, 28 Jan 2022 15:58:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A7D24292D2
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7161118162C0
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:04 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-480-HZBAhapONnObyENrjQoDIA-1; Fri, 28 Jan 2022 10:58:00 -0500
X-MC-Unique: HZBAhapONnObyENrjQoDIA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B318F2114E;
	Fri, 28 Jan 2022 15:57:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 55D9C134CD;
	Fri, 28 Jan 2022 15:57:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id bMXlEoYS9GF9VwAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 28 Jan 2022 15:57:58 +0000
Message-ID: <a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Zdenek Kabelac
	<zkabelac@redhat.com>, David Teigland <teigland@redhat.com>, Peter Rajnoha
	<prajnoha@redhat.com>
Date: Fri, 28 Jan 2022 16:57:57 +0100
In-Reply-To: <10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20SFw4QV025929
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>,
	Franck Bui <fbui@suse.de>, lvm-devel@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-01-28 at 16:33 +0100, Zdenek Kabelac wrote:
> Dne 28. 01. 22 v 14:42 mwilck@suse.com=A0napsal(a):
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > If a dm device is suspended, we can't run blkid on it. But earlier
> > rules (e.g. 11-dm-parts.rules) might have imported previously
> > scanned
> > properties from the udev db, in particular if the device had been
> > correctly
> > set up beforehand (DM_UDEV_PRIMARY_SOURCE_FLAG=3D=3D1). Symlinks for
> > existing
> > ID_FS_xyz properties must be preserved in this case. Otherwise
> > lower-priority
> > devices (such as multipath components) might take over the symlink
> > temporarily.
> >=20
> > Likewise, we should't stop watching a temporarily suspended, but
> > previously
> > correctly configured dm device.
>=20
>=20
> I'm a bit confused here what is the purpose of this patch.
>=20
> blkid is supposed to scan 'every' disk it's told to scan -=A0 if device
> is=20
> suspend - blkid shall fait till it's resumed.

Here we're talking about a device that had been successfully scanned
before (during initramfs processing). In my case it was a partition-on-
multipath device (linear mapping on top of multipath mapping) hosting a
btrfs file system with multiple subvolumes. The problem occurs when the
coldplug "add" event is processed after switching to the real root, and
if the device is in suspended state for whatever reason when that
happens. If the SYMLINK+=3D directive for the /dev/disk/by-uuid link for
the device is skipped in the udev rules, udev will notice and remove
the symlink (which means in the case of multipath: assign it to a
component SCSI device instead).

systemd, however, thinks that the /dev/disk/by-uuid device is ready for
processing and tries to mount it while the symlink wrongly points to
the SCSI device. That fails (the SCSI device is mapped by multipath),
and thus booting fails. See a log excerpt below.=20

> Suspend operation itself is meant to be quick - and process
> suspending any=20
> device should be doing it rather 'quickly'=A0 (aka reload DM table)
>=20
> So now - how do you get 'suspended' devices that are blocking blkid ?

It's a race condition. It probably happens while multipathd is
reloading a map (*), suspending it during the table reload. The device
will be resumed a few fractions of a second later (so yes, it's
"quick"), but then it's too late - systemd will already have tried to
mount it, and failed. When emergency mode is reached, all looks fine,
because the device has been resumed and the correct symlink has been
restored by udev while processing the associated CHANGE event.

I can actually see that some of the subvolumes are mounted successfully
and some are not. It all depends on the timing, which device mount(2)
actually accesses when it follows the by-uuid symlink.



> lvm2 has implemented some sort of 'optional' hack to avoid scanning
> suspended=20
> devices - but this shouldn't be normally needed - unless your system
> is flawed=20
> with some set of suspended devices (maybe from some crashed lvm
> command).

I'm not sure what "hack" you're talking about. 13-dm-disk.rules always
skips calling "blkid" for suspended devices. And that's correct.
The point is not to "forget" valid symlinks because scanning is
skipped.

Regards
Martin

(*) If a dm device is encountered in such a transient suspended state,
it is very difficult to figure out why / by which process it was
suspended, in particular during boot (tell me if you know a good trick
to figure it out). But multipathd is a likely candidate.

Sample boot log:

> [  127.532674] localhost systemd-udevd[1080]: dm-13: Updating old device =
symlink '/dev/disk/by-uuid/e40d3005-ab2f-4845-bd83-be5fd09e62a0', which is =
no longer belonging to this device.
> [  127.532784] localhost systemd-udevd[1080]: dm-13: Found 'b8:18' claimi=
ng '/run/udev/links/disk\x2fby-uuid\x2fe40d3005-ab2f-4845-bd83-be5fd09e62a0=
'
> [  127.533079] localhost systemd-udevd[1080]: sdb2: Device claims priorit=
y 0 for '/run/udev/links/disk\x2fby-uuid\x2fe40d3005-ab2f-4845-bd83-be5fd09=
e62a0'
> [  127.533150] localhost systemd-udevd[1080]: dm-13: Found 'b8:146' claim=
ing '/run/udev/links/disk\x2fby-uuid\x2fe40d3005-ab2f-4845-bd83-be5fd09e62a=
0'
> [  127.533397] localhost systemd-udevd[1080]: dm-13: Found 'b8:82' claimi=
ng '/run/udev/links/disk\x2fby-uuid\x2fe40d3005-ab2f-4845-bd83-be5fd09e62a0=
'
> [  127.533678] localhost systemd-udevd[1080]: dm-13: Atomically replace '=
/dev/disk/by-uuid/e40d3005-ab2f-4845-bd83-be5fd09e62a0'
> [  127.535494] localhost systemd[1]: srv.mount: About to execute /usr/bin=
/mount /dev/disk/by-uuid/e40d3005-ab2f-4845-bd83-be5fd09e62a0 /srv -t btrfs=
 -o subvol=3D/@/srv
> [  127.535845] localhost systemd[1]: srv.mount: Forked /usr/bin/mount as =
1343
> [  127.535992] localhost systemd[1]: srv.mount: Changed dead -> mounting
> [  127.536278] localhost systemd[1343]: srv.mount: Executing: /usr/bin/mo=
unt /dev/disk/by-uuid/e40d3005-ab2f-4845-bd83-be5fd09e62a0 /srv -t btrfs -o=
 subvol=3D/@/srv
> [  127.657542] localhost mount[1343]: mount: /srv: /dev/sdb2 already moun=
ted or mount point busy.
> [  127.888332] localhost systemd[1]: srv.mount: Failed to read oom_kill f=
ield of memory.events cgroup attribute: No such file or directory
> [  127.888532] localhost systemd[1]: srv.mount: Child 1343 belongs to srv=
.mount.
> [  127.888779] localhost systemd[1]: srv.mount: Mount process exited, cod=
e=3Dexited, status=3D32/n/a
> [  127.888961] localhost systemd[1]: srv.mount: Failed with result 'exit-=
code'.
> [  127.889200] localhost systemd[1]: srv.mount: Changed mounting -> faile=
d
> [  127.890046] localhost systemd[1]: srv.mount: Job 180 srv.mount/start f=
inished, result=3Dfailed
> [  127.890283] localhost systemd[1]: Failed to mount /srv.
> [  127.918072] localhost systemd[1]: srv.mount: Unit entered failed state=
.

Note the message "Updating old device symlink '/dev/disk/by-
uuid/e40d3005-ab2f-4845-bd83-be5fd09e62a0', which is no longer
belonging to this device"), which is where the trouble starts.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

