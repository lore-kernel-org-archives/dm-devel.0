From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@sysophe.eu>
Subject: [Regression, Bisected] dm-crypt IO failures with active slub_debug
 in 4.12 and later
Date: Thu, 2 Nov 2017 21:39:03 +0100
Message-ID: <20171102213903.1baa4a10@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Between 4.11 and 4.12 I stopped being able to boot my system with root
partition encrypted with dm-crypt (issue still present in 4.14-rc7).
The system was able to open the dm-crypt device and read-only mount the
XFS root partition on it.
Later read-write remounting though caused XFS to shutdown the filesystem
on IO error.

Some reports found online indicated a possible coincidence with stack
protection or the like as well as use of slub_debug, the latter causing
the IO errors to surface for me (I have slub_debug=3DZP on my kernel
cmdline).

I finally got time to go and bisect in order to find the triggering
patch. Bisect log:

# good: [a351e9b9fc24e982ec2f0e76379a49826036da12] Linux 4.11
git bisect good a351e9b9fc24e982ec2f0e76379a49826036da12
# bad: [6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c] Linux 4.12
git bisect bad 6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c
# bad: [2bd80401743568ced7d303b008ae5298ce77e695] Merge tag 'gpio-v4.12-1' =
of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
git bisect bad 2bd80401743568ced7d303b008ae5298ce77e695
# good: [8d65b08debc7e62b2c6032d7fe7389d895b92cbc] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/davem/net-next
git bisect good 8d65b08debc7e62b2c6032d7fe7389d895b92cbc
# good: [8b03d1ed2c43a2ba5ef3381322ee4515b97381bf] Merge branch 'linux-4.12=
' of git://github.com/skeggsb/linux into drm-next
git bisect good 8b03d1ed2c43a2ba5ef3381322ee4515b97381bf
# bad: [e897f267c51812bfecec45771a2d835c1a2bdacf] Merge tag 'backlight-next=
-4.12' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight
git bisect bad e897f267c51812bfecec45771a2d835c1a2bdacf
# good: [46f0537b1ecf672052007c97f102a7e6bf0791e4] Merge branch 'stable-4.1=
2' of git://git.infradead.org/users/pcmoore/audit
git bisect good 46f0537b1ecf672052007c97f102a7e6bf0791e4
# good: [20d5c84bef067b7e804a163e2abca16c47125bad] Merge remote-tracking br=
anches 'asoc/topic/wm8960', 'asoc/topic/wm8978' and 'asoc/topic/zte-tdm' in=
to asoc-next
git bisect good 20d5c84bef067b7e804a163e2abca16c47125bad
# bad: [7b66f13207e60e7c550af730986e77e38a0c69a3] Merge tag 'for-4.12/dm-po=
st-merge-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-m=
apper/linux-dm
git bisect bad 7b66f13207e60e7c550af730986e77e38a0c69a3
# good: [dd7a8f5dee81ffb1794df1103f07c63fd4f1d766] md/raid5: make chunk_ali=
gned_read() split bios more cleanly.
git bisect good dd7a8f5dee81ffb1794df1103f07c63fd4f1d766
# bad: [6625d903253eb6f003849823e22d7b8de5bfb5b2] dm integrity: use hex2bin=
 instead of open-coded variant
git bisect bad 6625d903253eb6f003849823e22d7b8de5bfb5b2
# bad: [449b668ce0b9069fcaafa6344c7f10fa2ba9632e] dm cache: set/clear the c=
ache core's dirty_bitset when loading mappings
git bisect bad 449b668ce0b9069fcaafa6344c7f10fa2ba9632e
# good: [33d2f09fcb357fd1861c4959d1d3505492bf91f8] dm crypt: introduce new =
format of cipher with "capi:" prefix
git bisect good 33d2f09fcb357fd1861c4959d1d3505492bf91f8
# bad: [ff3af92b4461be773337111daea80bb91b2cd545] dm crypt: use shifts inst=
ead of sector_div
git bisect bad ff3af92b4461be773337111daea80bb91b2cd545
# bad: [1aa0efd4210df1c57764b77040a6615bc9b3ac0f] dm integrity: factor out =
create_journal() from dm_integrity_ctr()
git bisect bad 1aa0efd4210df1c57764b77040a6615bc9b3ac0f
# bad: [8f0009a225171cc1b76a6b443de5137b26e1374b] dm crypt: optionally supp=
ort larger encryption sector size
git bisect bad 8f0009a225171cc1b76a6b443de5137b26e1374b
# first bad commit: [8f0009a225171cc1b76a6b443de5137b26e1374b] dm crypt: op=
tionally support larger encryption sector size

In order to test on 4.12 I had to revert the following commits,
the first two having been applied on top of bad commit:
  583fe7474c05ee5523e14ef791ea59604cd846dc (dm crypt: fix large block integ=
rity support)
  ff3af92b4461be773337111daea80bb91b2cd545 (dm crypt: use shifts instead of=
 sector_div)
  8f0009a225171cc1b76a6b443de5137b26e1374b (dm crypt: optionally support la=
rger encryption sector size)

=46rom looking at 8f0009a225171cc1b76a6b443de5137b26e1374b I can't spot
direct cause though I assume there might be a mismatch in memory
allocation versus access sizes as a consequence of support for larger
encryption sector size (someplace 512 byte versus page size access
tripping on memory poison?).

Bruno
