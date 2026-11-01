Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793560223;
	b=pq32QtgFFHVuQFu1QcahOryluHWy9q4vB6lN+WNI1cc8shHXTaATTnE3X8XRVzO734jH
	 Vmv6HkzCZltdasUJ24Mkdif/4ylvymcYbVxB+Ofeh/LYqQ5+PxnWlKYkDYAKNJtJVTDVX
	 4VvTJ06gj16AK5AyhzFpR2vSAo6Wekjtz9UaMKJ5FbAM5sreTsT2Ox/dQmKucqH4Lb+dY
	 ZoPRbflwQqWyapAZb3iHPKQTGOb0T5Z0BqseClTvG2BKx8eBtgnjYxpNaYmFwy3Fke2es
	 wfnXj5RYGUKPkxjL/cY53dStyGKnTYEAJyApDYbr+DXo4M+8dVF4TYtzefZWHUeHNNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793560223;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Organization:In-Reply-To:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Language:Content-Type:
	 Content-Transfer-Encoding;
	bh=PyZs0AyYwTcyO/qGQurFs7U023N9VNDaniciBF4CFOA=;
	b=4H+//PoI9PV1cwPEieXFBZ6RXmWuNYRPFKgTNXLGR+VWRpDGzaZqFJXUF8/5f6/nF6re
	 FBz175oVna9noE1rvU9eT7O+GjTa1p5JDlF1rp8Kj0M7VXXCnkktPX2jCPSGD1YBiuhxS
	 QpeV5IQt/0ehGgY97L9gqBKHcQ/HDEQkURNc/qGzu2u8lwk+G1IdGQ+KISiUYFPvepYIK
	 FG02m7+rycBrJENgyVbVPFrUIYKd+h5tKzdGpex/i87p1lszMFD+BBA8wDALFTJPsjf5O
	 83g15oJQmbOzpRaalHKguYvQZLjGu8Evfa5IDarXAh0t6StlCJU4a08YOwRKxvv9HWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b+DSCSNq;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9E5606A325
	for <dm-devel@lists.linux.dev>; Sun,  1 Nov 2026 19:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C9E5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b+DSCSNq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793560222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PyZs0AyYwTcyO/qGQurFs7U023N9VNDaniciBF4CFOA=;
	b=b+DSCSNq2KnJ2vs+CIVy49S0YvzeVivHsCo6YSk3k059YZzQavqdCGpPscuzI7RhTrlRRG
	NhlzPY6bse+c5BXAYISZ5pyPtVOlMD3n2ogGGtbt0Qg5zpzODYx2Sv6oIMVsZh5xwmYJmf
	Kmj8i8I6Az/TMJa23tS66zAqTEzkl0I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-XblsmwFTMsmiQ9pWzswkXw-1; Sun, 01 Nov 2026 14:10:20 -0500
X-MC-Unique: XblsmwFTMsmiQ9pWzswkXw-1
X-Mimecast-MFC-AGG-ID: XblsmwFTMsmiQ9pWzswkXw_1793560220
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48b02d63407so1886392f8f.0
        for <dm-devel@lists.linux.dev>; Sun, 01 Nov 2026 11:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793560219; x=1794165019;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PyZs0AyYwTcyO/qGQurFs7U023N9VNDaniciBF4CFOA=;
        b=oOpbIDKtGJDo4rrU/5DfX7scEgrGQuwLp0ZU90wHZfl3XkVtBfLnVDzfkUWc0f+3/T
         2LUUn45DFa13bTB+phsM/eZfb58HrF086YgYUDjzqyWHB4bMPfbToQBixp8ZJ+UKPIcX
         FyfMpeB2lA42ZzBtpCaIk2dNcU3gUQQc8N6urZtbgizL+gDYAN7kd+6WW1AYidiNmOeN
         wEIcdl+5xR9SHM4h5WcO9dpL3eHNcskVX01tLKu9jwP2LTk2MOlg+hhVowk3zy+BsC/i
         EY3qFpHtoQaqTkKUy0KWuGNDznyqzO8Svic42bxgdBmDB4ywDMI8Q6dZQ2eQ7KGscNv4
         6HgQ==
X-Gm-Message-State: APuU4Z+HfyFj7pUk9CkgTfkhrlH6Ebaollsn3fyOnxDwL1Vwnskn2eza
	ZsfPI1+ArjDFi+PRmLK/pNFPg3IQ25njmovPFfbhAkgqvI0xTYjWRxXVamkHAyAb43+YVhYH+yG
	cnWp79TCeg3vKJYm5PixWV+b6YtDAu+uVVMHfwfevNbdaJRWSXRuSlHAi6sKp6w1DTwke
X-Gm-Gg: AYBFou1w9S+k6Zd/ulOZU1iFiqf3Gtyt+Nl9FPZ9MuI9Rk9BS6ScMaTh/CeTXO6t9c3
	DBr6IKlf0mU6nz1oX+f+9YaXz3vi38rMWhvtZTzOq0MZ5WiCVKf1m75NJWnVkzmHF6YEchZnuWr
	bWVZCTUCKXeoUAkiXZ9CA0NBG5ENyRrqieIDFiOpC0GwbYMcX/5NvFPYSiBRlEZ5/8Q82WzS9OS
	0+sl0t0VN8SsmvxtSrxw9UnDreQN8ml2ahNox9w5k6VqgZopcoLt4nxezOdtSEWHMY40OsV8aeO
	SMMriV2T23zTeQgx9uu+eaAUScC+1E4p0akvF6KOuhu1ysYyXCprxUgDKkVdZB2mCwaSc/9oEmF
	/d/hHNwUbh2Zta6BuDgDKTvJURU6jRPshFybUCkMPfdENxSDf/Q==
X-Received: by 2002:a05:6000:2dc3:b0:48e:68da:1c5c with SMTP id ffacd0b85a97d-48e6e2f83aamr17988525f8f.16.1793560219390;
        Sun, 01 Nov 2026 11:10:19 -0800 (PST)
X-Received: by 2002:a05:6000:2dc3:b0:48e:68da:1c5c with SMTP id ffacd0b85a97d-48e6e2f83aamr17988473f8f.16.1793560218780;
        Sun, 01 Nov 2026 11:10:18 -0800 (PST)
Received: from [192.168.0.99] ([212.20.115.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba24f6sm16037130f8f.51.2026.11.01.11.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 11:10:18 -0800 (PST)
Message-ID: <2179facd-fe1e-42eb-8416-38d534e8b0dc@redhat.com>
Date: Sun, 1 Nov 2026 20:10:17 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Parent transid failures in extent/dev/free-space trees after lost
 writes; open_ctree -5, restore works - advice before repair?
To: Aaron Bohenick <bohenick@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dm-devel@lists.linux.dev
References: <CAAhqjAK5mOJrgZqG-ZrgKt12Dm4AFJeapiFbBNpRv+qUns_d-A@mail.gmail.com>
 <CAAhqjALj6mq=wx43sshav-uOxei2nXeMu4nfmQmu_az7Nbig=g@mail.gmail.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: RedHat
In-Reply-To: <CAAhqjALj6mq=wx43sshav-uOxei2nXeMu4nfmQmu_az7Nbig=g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lQHsrPLfyw59WFfUxKh473iMDDiO3-ZTi0laJGZW8J8_1793560220
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs-CZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 01. 11. 26 v 18:50 Aaron Bohenick napsal(a):
> Hi,
> 
> Follow-up to my report below, with new findings that change the
> question. Cc'ing dm-devel because this now looks like a dm-cache
> (lvmcache) issue underneath Btrfs. Everything below was read-only; the
> origin LV and the cache SSD are both blockdev --setro and nothing has
> been written to either. The NAS vendor's (TerraMaster) support is also
> involved.
> 
> Short version: the detached cache SSD holds the current, checksum-valid
> copy of every Btrfs metadata block that is stale on the origin, but the
> cache metadata marks every cached block clean (0 dirty), so a forced
> uncache dropped them.
> 
> How the cache was detached
> --------------------------
> LVM metadata history on the origin PV (vg0 on md RAID6), times EDT:
> - seqno 23, 2026-10-29 21:31:53: "lvconvert --uncache -y --force vg0/lv0"
> - seqno 24, 2026-10-29 21:31:55: "vgreduce vg0 --removemissing"
> The cache PV (an md RAID1 on one NVMe) was not assembled after a vendor
> OS update/restart, and the vendor OS forced the uncache. Cache mode in
> the LVM metadata: writethrough.
> 
> Cache metadata (cache_check passes on an image of the cmeta LV)
> ---------------------------------------------------------------
> block_size=2048 sectors (1 MiB), nr_cache_blocks=953640, policy=smq,
> hint_width=4; 953634 mappings, 0 dirty.
> 
> Damaged Btrfs blocks: origin copy vs cached copy
> ------------------------------------------------
> 64 KiB nodes read from the origin LV and from the cdata area on the SSD
> (cache block N at cdata + N MiB). crc32c and bytenr checked for every
> copy. Format gen/owner; both DUP copies agree unless noted.
> 
> logical wanted origin cached
> 26935296 917953 910413/3 (copy0) 917953/3
> 13608045117440 918517 879195/7 918517/8
> 15797806039040 917945 917909/2 917945/4 (dev tree)
> 12777307766784 918507 610497/258 918507/2 (extent tree)
> 12777308094464 918507 608008/258 918507/2 (extent tree)
> 12777309929472 918507 917901/7 lvl 1 918507/2 lvl 0
> 13607943929856 918513 604537/260 918513/258
> 13608042430464 918517 610816/258 918517/260 lvl 2 (subvol root)
> 
> Every cached copy has a valid checksum and exactly the generation Btrfs
> expects. The origin copies are valid but much older blocks from other
> trees. All 20 damaged copies (10 blocks x DUP) are inside cached origin
> blocks, while overall only 51.4% of metadata blocks (23181/45056) and
> 5.8% of data blocks were cached. The cache also holds blocks from the
> final transaction (918517), so it was in use until the end.
> 
> So for some hot metadata blocks, writes stopped reaching the origin
> (some since around generation 604537, weeks to months earlier) while
> reads were served from the cache, and the cache never considered those
> blocks dirty.
> 
> Questions
> ---------
> 1. For dm-cache: is there a known way a writethrough cache can end up
>     with cached blocks that are newer than the origin but marked clean?
>     (Kernel 6.12.63+ on a TerraMaster F4-424 Pro, TOS 7.0.1341.)
> 2. Safest recovery: re-create the cache mapping by hand (origin lv0,
>     cmeta, cdata, block size 2048, smq) over dm-snapshot overlays and
>     test a read-only Btrfs mount; or copy the cached metadata blocks onto
>     the origin after testing on an overlay? Anything to watch for, e.g.
>     policy hints, or LVM auto-cleaning the outdated cache PV's metadata
>     if its md/GPT labels are restored (they are currently erased, so LVM
>     cannot see it)?
> 3. For Btrfs: if the cached versions are put back, is a full
>     btrfs check --readonly plus scrub enough to trust the filesystem, or
>     should I still plan to copy everything off and recreate it?
> 
> I can provide the cache_dump, the comparison script and output, the
> LVM metadata text from both PVs and the 97 MiB cmeta/LVM image.
> 


Hi Aaron,

On Q1: I do not know of a kernel release that fixed this, because I cannot
find a dm-cache writethrough bug with this shape. The only dm-cache
coherency fixes after 6.12 are the passthrough-mode series from Ming-Hung
Tsai (Feb 2026, v7.1, no Cc: stable, so not in 6.12.63), and they have the
opposite signature: passthrough maps writes to the origin and invalidates
the cache entry, so those bugs make the cache return stale data while the
origin stays correct. Your data has the cache correct and the origin
stale.

The writethrough path does not obviously allow your state either. A write
that hits a clean block goes to origin and cache in parallel with
bio_chain(), so the bio does not complete until both are done and an
origin error propagates. A dirty block is cleared only after a successful
copy to the origin. A write miss goes to the origin and is not cached. A
clean mapped block should therefore always match the origin. That leaves
two candidates: the origin lost an acknowledged write below dm, or the
table was not actually writethrough while it ran. The second is easy to
rule out from /etc/lvm/archive if the NAS still has it.

Related, and important for reading your dump: the dirty bitset is written
by sync_metadata(), and the clean-shutdown flag is only set if all the
metadata writes in that pass succeeded. On load, if that flag is clear,
the kernel ignores the bitset and marks every mapping dirty
(__load_mapping(): "bool dirty = true; if (cmd->clean_when_opened) dirty
= ..."). So "0 dirty" means nothing unless the metadata was cleanly shut
down. If it was not, the kernel considered all 953634 blocks dirty.

On Q2: use the offline tools; no dm-cache target and no LVM. Work only on
a copy (you already have the 97 MiB cmeta image):

   dd if=<cmeta> of=cmeta.img bs=1M
   cache_check cmeta.img
   cache_check --clear-needs-check-flag cmeta.img     # copy only
   cache_writeback --metadata-device cmeta.img \
       --fast-device <cdata> --origin-device <origin snapshot> \
       --no-metadata-update --list-failed-blocks

cache_writeback writes only dirty blocks and cannot run on a live cache.
If the metadata was not cleanly shut down it should treat every mapping as
dirty and write the whole cache back, about 930 GiB; that makes the origin
an exact copy of the cache state, and blocks that were already identical
are a no-op. If it writes nothing, the metadata was clean; then select the
blocks yourself:

   cache_dump cmeta.img > cache.xml
   # <mapping cache_block="N" origin_block="M" dirty="false"/>
   # set dirty="true" on the blocks you want, then:
   cache_restore -i cache.xml -o cmeta-fixed.img
   cache_writeback ... --metadata-device cmeta-fixed.img

Write to a snapshot of the origin so the real one stays untouched, and
size the COW for up to 930 GiB. cdata is only read, so it needs no copy.
Do not re-activate the cache target: activation commits to cmeta and, on
an unclean metadata, starts writing back on its own schedule.

On Q3: no, btrfs check --readonly plus scrub is not sufficient. Your
damage is "valid checksum, stale content", which checksums cannot detect:
scrub compares data against metadata checksums, and those match the stale
block. Only generation/transid and tree-structure checks catch it, and
only for blocks that are visited. Plan to copy out and recreate, or keep a
full pre-repair image and diff against it later.

Also, "all 20 damaged copies are in cached blocks, while only 51.4% of
metadata blocks were cached" is a selection effect: you found the damage
by comparing origin against cdata, so only cached blocks can show it, and
hot tree roots are exactly what a cache holds.

What would settle it, in order of value:

1. Kernel log from the last healthy boot through the failed boots:
    journalctl -k -b -1 and -b, /var/log/kern.log, /var/log/messages.
    Look for "md/raid", "md0", "resync", "recovery", "faulty", "removed",
    "re-added", "md: marking", "I/O error", "blk_update_request"; and for
    "dm_cache" / "device-mapper: cache": "switching cache to read-only
    mode", "switching cache to fail mode", "metadata operation ...
    failed". md logs loudly, dm-cache is silent on the healthy path, so
    absence of cache errors proves nothing.

2. md facts: mdadm --detail, mdadm --examine on every member (event
    counts), chunk size, and which serial sits in which slot. If one
    member has a lower event count or appears in a kick/re-add, stop there.

3. /etc/lvm/archive and /etc/lvm/backup from the NAS: the only reliable
    way to see whether the cache mode was ever changed to writeback, and
    when the cache PV last received a metadata update.

4. pvck --dump metadata on the cache PV: its VG seqno versus the origin
    PV's seqno tells you when LVM last wrote that PV, independently of the
    metadata text you already have.

5. cache_dump and cache_check output, and whether the cmeta superblock
    clean-shutdown flag is set.

6. uname -a, /proc/version, and the TOS kernel source or patch set. A
    vendor 6.12.63 with out-of-tree patches is the one gap I cannot reason
    about from upstream.

7. The physical-offset test, which needs only the images you already have:
    compute the RAID6 chunk-to-member mapping (mdadm --detail gives the
    chunk size and layout) for the 10 stale 64 KiB blocks. If they land on
    one member, or on one contiguous region of it, that is md, not
    dm-cache.

If the pre-reinstall logs are gone, say so early: then the md history is
unrecoverable and the block-offset test plus the LVM archive are what is
left.

Keep the cache PV invisible to LVM throughout (device filter, do not
import the VG): a stray pvcreate, vgreduce or lvconvert --repair can
rewrite exactly the metadata you are depending on.

Thanks,

Zdenek

