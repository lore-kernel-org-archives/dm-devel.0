Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE81F2512E3
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 12:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275915; cv=none; b=SUCHKF7U9ly2nRpD8iFZTH8GrlTJra3qmrRTIvCfOXKP47xcFW750StTHrLDBi/lKDsRjY9hRTCsKjewbulNb0BNUHJ1Wm4NDneOS60/LKQLBKwcywJJUSy3rzM9G1SEltsKY6lIZKcCX5IOt2NYVLQmrBfhdnrrt+q+TEosN/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275915; c=relaxed/simple;
	bh=jy+Zdkv39gDw0wvhqHgxL0nGBaHizhozLCUX2CYnk5A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VNN0CA7EN6fs3LLLd5gaR7XpI/2NVwj9GHBbWhqJAAnB5oen5+dmeAu6l/r4Z6ch+gMhay6fsrb1EME3S8MQPz2N2H954HoUjjzLwYOGojMU3wI23I7qSSui4mEjm2XzHSrKe7h3AekdWJFYw6oavXHQ6+jM88OWAeq7zHZEZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mfe@pengutronix.de>)
	id 1thp74-0002Yi-SO; Tue, 11 Feb 2025 13:11:38 +0100
Received: from pty.whiteo.stw.pengutronix.de ([2a0a:edc0:2:b01:1d::c5])
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <mfe@pengutronix.de>)
	id 1thp74-000PUs-15;
	Tue, 11 Feb 2025 13:11:38 +0100
Received: from mfe by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <mfe@pengutronix.de>)
	id 1thp74-0098c6-0l;
	Tue, 11 Feb 2025 13:11:38 +0100
Date: Tue, 11 Feb 2025 13:11:38 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: gmazyland@gmail.com, okozina@redhat.com, mpatocka@redhat.com,
	ebiggers@google.com, hare@suse.de, agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev, Lucas Stach <lst@pengutronix.de>
Subject: DM-Integrity journal replay behaviour
Message-ID: <20250211121138.kokiyvgh6ba3yujl@pengutronix.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@lists.linux.dev

Hi all,

as written in the subject we do see an odd dm-integrity behaviour during
the journal replay step.

First things first, a short introduction to our setup:
 - Linux v6.8
 - We do have a dm-integrity+dm-crypt setup to provide an authenticated
   encrypted ext4-based rw data partition.
 - The setup is done with a custom script [1] since we are making use of
   the kernel trusted-keys infrastructure which isn't supported by LUKS2
   at the moment.
 - The device has no power failsafe e.g. hard power-cuts can appear.
   Therefore we use the dm-integrity J(ournal) mode.
 - The storage backend is an eMMC with 512Byte block size.
 - We use the dm-integrity 4K block size option to reduce the
   tag/metadata overhead.

From time to time we do see "AEAD ERROR"s [2] while fsck tries to repair
the filesystem which of course abort the fsck run.
After a while within the rescue shell and a following reboot the fsck
run on the same file system doesn't trigger any "AEAD ERROR".

The dm-integrity table is added twice [1] since we gather the
provided_data_sectors information from the first call. I know that this
isn't optimal. The provided_data_sectors should be stored and not
gathered again but this shouldn't bother a system with a valid
dm-integrity superblock already written.

To debug the issue we uncommented the "#define DEBUG_PRINT" and noticed
that the replay is happening twice [2] albeit this should be a
synchronous operation and once the dm resume returned successfully the
replay should be done.

We also noticed that once we uncommented "#define DEBUG_PRINT" it was
harder to trigger the issue.

We also checked the eMMC bus to see if the CMD23 is sent correctly (with
the reliable write bit set) in case of a FUA request which is the case.
So now with the above knowledge we suspect the replay path to be not
synchronous, the dm resume is returning too early, while not all of the
writes kicked off by copy_from_journal having reached the storage.

Maybe you guys have some pointers we could follow or have an idea of
what may go wrong here.

Regards,
  Marco

8<-------------------------------------------------------------------------

[1] An extract of setup script

device_open() {
    local nblocks
    local table
    local imode
    local iname
    local name

    name="${1}"
    iname=$(device_integrity_name "${name}")
    device="${2}"
    key="${3}"
    # Use J(journal) as the default dm-integrity mode
    imode="${4:-J}"

    # We need to provide a minimal size of 8 blocks so the kernel can calculate the
    # provided_data_sectors size which we query to setup the table with the correct
    # size (https://docs.kernel.org/admin-guide/device-mapper/dm-integrity.html)

    # <start_sector> <size> <target name> <data_dev> <offset> <tag_size> <mode> [<#opt_params> <opt_params>]
    table="0 8 integrity ${device} ${LUKS_NBLOCKS} 28 ${imode} 2 block_size:4096 fix_padding"
    dmsetup create "${iname}" --table "${table}"

    # Query provided_data_sectors
    nblocks=$(dmsetup status "${iname}" | awk '{ print $5 }')
    dmsetup remove --retry "${iname}"

    table="0 ${nblocks} integrity ${device} ${LUKS_NBLOCKS} 28 ${imode} 2 block_size:4096 fix_padding"
    dmsetup create "${iname}" --table "${table}"

    # <start_sector> <size> <target name> <cipher> <key> <iv_offset> <device path> <offset> [<#opt_params> <opt_params>]
    table="0 ${nblocks} crypt capi:gcm(aes)-random ${key} 0 /dev/mapper/${iname} 0 2 integrity:28:aead sector_size:4096"
    dmsetup create "${name}" --table "${table}"
}

[2] Log output with debug enabled and AEAD errors

Starting Open Encrypted Data Partition...
[    7.442251] initialized:
[    7.444823]  integrity_tag_size 28
[    7.448225]  journal_entry_size 104
[    7.451748]  journal_entries_per_sector 4
[    7.455835]  journal_section_entries 32
[    7.459688]  journal_section_sectors 264
[    7.463625]  journal_sections 364
[    7.466952]  journal_entries 11648
[    7.470364]  log2_interleave_sectors 15
[    7.474212]  data_device_sectors 0xbbe7d8
[    7.478234]  initial_sectors 0x17768
[    7.481822]  metadata_run 0xe0
[    7.484889]  log2_metadata_run -1
[    7.488205]  provided_data_sectors 0xb8acb0 (12102832)
[    7.493359]  log2_buffer_sectors 5
[    7.496772]  bits_in_journal 393609216
[    7.508810] commit id 0: 1111111111111111
[    7.512870] commit id 1: 2222222222222222
[    7.516906] commit id 2: 3333333333333333
[    7.520928] commit id 3: 4444444444444444
[    7.525094] audit: type=1338 audit(1651167748.872:6): module=integrity op=ctr ppid=376 pid=385 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="dmsetup" exe="/usr/sbin/dmsetup" dev=254:1 error_msg='success' res=1
[    7.526073] resume
[    7.548779] audit: type=1300 audit(1651167748.872:6): arch=c00000b7 syscall=29 success=yes exit=0 a0=3 a1=c138fd09 a2=aaaacf45ae30 a3=4 items=6 ppid=376 pid=385 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="dmsetup" exe="/usr/sbin/dmsetup" key=(null)
[    7.550795] reading journal
[    7.578004] audit: type=1307 audit(1651167748.872:6): cwd="/"
[    7.586583] audit: type=1302 audit(1651167748.872:6): item=0 name=(null) inode=2049 dev=00:07 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
[    7.604268] audit: type=1302 audit(1651167748.872:6): item=1 name=(null) inode=979 dev=00:07 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
[    7.621863] audit: type=1302 audit(1651167748.872:6): item=2 name=(null) inode=19 dev=00:07 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
[    7.842076] decrypted journal: 78 82 45 00 00 00 00 00 45 32 db 64 40 8d 05 6c 33 c9 dc 5e 3b 04 5a dc 1e 63 47 57 10 bf 30 2f e2 1a a4 2d a1 43 a2 8a 57 7d 48 ee 34 00 60 84 99 b0 19 82 c9 84 28 46 8d 4e a8 8b 5a ef 73 d3
[    7.879692] first unused commit seq 3 [0,1,1,0]
[    7.901013] replaying 364 sections, starting at 143, commit seq 2
[    7.968093] continuing from section 143, commit seq 2
[    7.973513] testing recalc: 8
[    8.079583] initialized:
[    8.082163]  integrity_tag_size 28
[    8.085602]  journal_entry_size 104
[    8.089111]  journal_entries_per_sector 4
[    8.093131]  journal_section_entries 32
[    8.096980]  journal_section_sectors 264
[    8.100913]  journal_sections 364
[    8.104227]  journal_entries 11648
[    8.107642]  log2_interleave_sectors 15
[    8.111488]  data_device_sectors 0xbbe7d8
[    8.115509]  initial_sectors 0x17768
[    8.119097]  metadata_run 0xe0
[    8.122163]  log2_metadata_run -1
[    8.125489]  provided_data_sectors 0xb8acb0 (12102832)
[    8.130639]  log2_buffer_sectors 5
[    8.134053]  bits_in_journal 393609216
[    8.145999] commit id 0: 1111111111111111
[    8.150064] commit id 1: 2222222222222222
[    8.154122] commit id 2: 3333333333333333
[    8.158147] commit id 3: 4444444444444444
[    8.163332] resume
[    8.165429] reading journal
[    8.426420] decrypted journal: 78 82 45 00 00 00 00 00 45 32 db 64 40 8d 05 6c 33 c9 dc 5e 3b 04 5a dc 1e 63 47 57 10 bf 30 2f e2 1a a4 2d a1 43 a2 8a 57 7d 48 ee 34 00 60 84 99 b0 19 82 c9 84 28 46 8d 4e a8 8b 5a ef 73 d3
[    8.464025] first unused commit seq 3 [0,1,1,0]
[    8.485283] replaying 364 sections, starting at 143, commit seq 2
[    8.555334] continuing from section 143, commit seq 2
[    8.560754] testing recalc: 8
[  OK  ] Found device /dev/mapper/data.
[  OK  ] Finished Open Encrypted Data Partition.
         Starting Make File System on /dev/mapper/data...
[  OK  ] Finished Make File System on /dev/mapper/data.
         Starting File System Check on /dev/mapper/data...
[   10.030908] trusted_key: device-mapper: crypt: dm-1: INTEGRITY AEAD ERROR, sector 4556320
[   10.677424] trusted_key: device-mapper: crypt: dm-1: INTEGRITY AEAD ERROR, sector 4556320
[   10.685697] Buffer I/O error on dev dm-2, logical block 569540, async page read
[   10.685852] kauditd_printk_skb: 28 callbacks suppressed
[   10.685858] audit: type=1339 audit(1651167752.120:11): module=crypt op=integrity-aead dev=254:1 sector=4556320 res=0
[   10.693586] trusted_key: device-mapper: crypt: dm-1: INTEGRITY AEAD ERROR, sector 4556320
[   10.717037] Buffer I/O error on dev dm-2, logical block 569540, async page read
[   10.717172] audit: type=1339 audit(1651167752.148:12): module=crypt op=integrity-aead dev=254:1 sector=4556320 res=0
