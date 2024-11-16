Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411AA15E97
	for <dm-devel@lists.linux.dev>; Sat, 16 Nov 2024 21:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792669; cv=none; b=uc6aMSc+9c0j0nCh+GP3rupDETmgVEQn4tYfXEjY1NIdnFyKdCZRAW9pk3y6qQLGGuQNptPksUlLlcVoCdHWcon4wPyO9uU0JcFKdypFhIPBAB8scLIFTx5YnsMx6gVmYKQDtxfKZiMpLHmbie/paa3o8DuDBO9fLvkcW4HJuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792669; c=relaxed/simple;
	bh=ley5OibroH2pxq/FwpNmAVI91MWYRG2y/hv0UYXKCfA=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=vAHnw/9ADKg+YRC46ZvtfEnHwMz8hgCh+Rd8ZyyVgHooWvO4pZKp3lA+pATqR3rdeHmJjsh7jGjNvFzYy6q+m29z/GvBWFDRARXFcu410Z4ZrqF8JOMIPW43FxhN07JhiC21qMj6Bh88hhZvHvaFAxQVO4gPGkhgdsWhWU5CMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=ui4fSTcY; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="ui4fSTcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1731792655; x=1732051855;
	bh=yKTQHHSUGLsmsLs1QWSFYfwAyWzMcIXTRFPmGn3Vnfw=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=ui4fSTcYNrg+b84okqADIFB49QY3dPw4ywoDZlrLCaKjMnQc4M8jH7Pfo7EZX9t0Q
	 SqUyz+hpYam1JFQ9DX9awdDGgLLS+cHovsJrZIPvAWDKv3FmIEc5RDM98sibFbOgjB
	 m2E6BYXpidpK/YAFIpvnyW/wQjiHDHugQ4SWlpHQ2H4dvQcfbNnz8NeoUS5c1eIivp
	 9k5jrJYVj19SgSS0IiAsmjhKLikLrZfVg308uw0AxnQOr4cF5C2BhnPNuKwBEK32Ry
	 wwfHUFOW0e3CVSfi3g/P9CDRH0huraBDO2GARysYyVnvtAnrgDFWjTWZSDJcMKaLk7
	 CIAH5PmRDSRIw==
Date: Sat, 16 Nov 2024 21:30:51 +0000
To: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
From: dap581 <dap581@protonmail.com>
Subject: kernel 6.12-rc7 device-mapper inconsistency
Message-ID: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com>
Feedback-ID: 43237694:user:proton
X-Pm-Message-ID: deecaca1a72d5b3b332471832931267552dd1b2d
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,
Starting with kernel 6.11.x series up to current 6.12-rc7
when I unlock my encrypted hdd (storage, not root) with cryptsetup:

cryptsetup luksOpen /dev/sda1 hdd5 -d keyfile_hdd5

it triggers an alignment inconsistency:
In dmesg log, I read:
----
[  105.841278] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
[  105.841292] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
[  105.841601] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
[  105.841607] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
----

Also, starting with Linux >6.11.x up to current 6.12-rc7, "lsblk -t" return=
s different values than before in OPT-IO & RA column.

----
With kernel >6.11.x
With device closed:
NAME         ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  =
  RA WSAME
sda                  0   4096 16776704    4096     512    1 bfq       256 3=
2764    0B
=E2=94=94=E2=94=80sda1               0   4096 16776704    4096     4096    =
1 bfq       256 32764    0B
After luksOpen:
sda                  0   4096 16776704    4096     512    1 bfq       256 3=
2764    0B
=E2=94=94=E2=94=80sda1               0   4096 16776704    4096     512    1=
 bfq       256 32764    0B
  =E2=94=94=E2=94=80hdd5            -1   4096        0    4096    4096    1=
               32764    0B


I tried to track down when this started exactly, to do so, I compiled kerne=
l:
6.7.12, 6.8.12, 6.9.9, 6.10.14
and none of them returns this device-mapper inconsistency.
lsblk -t with kernel 6.10.14 and earlier:
NAME         ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA=
 WSAME
sda                  0   4096      0    4096     512    1 bfq       256 128=
    0B
=E2=94=94=E2=94=80sda1               0   4096      0    4096     512    1 b=
fq       256 128    0B
  =E2=94=94=E2=94=80hdd5             0   4096      0    4096    4096    1  =
             128    0B

So far, I have been able to locate this commit (part of Linux 6.11.x)
a23634644afc2f7c1bac98776440a1f3b161819e (block: take io_opt and io_min int=
o account for max_sectors )
that seems to trigger the change in lsblk output and introduces opt-io & ra=
 value
but as a casual user, I can't say for sure, I'm not a developer either.
On the other hand, if I compile a kernel using one or two commit before a23=
634644afc2f7c1bac98776440a1f3b161819e then the lsblk -t output is not chang=
ed and no "device-mapper inconsistency" appears so it seems at least relate=
d somehow.
By the way, after enteting my password (or using keyfile) cryptsetup return=
s no error and the filesystem (btrfs) mounts correctly.

Let me know if you need other info.
See also: https://gitlab.com/cryptsetup/cryptsetup/-/issues/919

System used: Gentoo

The HDD is connected to an SAS HBA (Dell Perc H310 with IT firmware)
Actually, there are also 4 other HDD (same brand, model, capacity, same con=
figuration used) connected to it and they all show the exact same message "=
device-mapper inconsistency" as soon as there are unlocked.

gdisk -l /dev/sda
----
Disk /dev/sda: 5860533168 sectors, 2.7 TiB
Model: WDC WD30EZRX-00D
Sector size (logical/physical): 512/4096 bytes
Disk identifier (GUID): 4D31A7E7-A2A6-4A5A-8FE1-8368581B78DC
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2924 sectors (1.4 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      5860532224   2.7 TiB     8300  Linux filesystem
----

luksDump /dev/sda1
----
LUKS header information
Version:       2
Epoch:         5
Metadata area: 16384 [bytes]
Keyslots area: 16744448 [bytes]
UUID:           d1ff1c64-a294-4287-ab33-215327716e96
Label:         hdd5
Subsystem:     (no subsystem)
Flags:       (no flags)

Data segments:
  0: crypt
offset: 16777216 [bytes]
length: (whole device)
cipher: serpent-xts-plain64
sector: 4096 [bytes]
----

