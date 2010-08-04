From: Valdis.Kletnieks@vt.edu
Subject: Re: How to track down abysmal performance ata - raid1 -
	crypto - vg/lv - xfs
Date: Wed, 04 Aug 2010 16:33:06 -0400
Message-ID: <15446.1280953986@localhost>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1967100432796027674=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Wed, 04 Aug 2010 12:25:26 +0200."
	<20100804102526.GB13766@isilmar-3.linta.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1967100432796027674==
Content-Type: multipart/signed; boundary="==_Exmh_1280953986_3909P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1280953986_3909P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <15440.1280953986.1@localhost>

On Wed, 04 Aug 2010 12:25:26 +0200, Dominik Brodowski said:

> The "good" news: it also happens on my notebook, even though it has a
> different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
> more than happy to test out different kernel versions, patches etc.
> 
> /dev/sd*                17.7 MB/s       (100 %)
> /dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
> /dev/mapper/*_crypt      3.1 MB/s       ( 18 %)

Unfortunately, on my laptop with a similar config, I'm seeing this:

# dd if=/dev/sda bs=8k count=1000000 of=/dev/null
1000000+0 records in
1000000+0 records out
8192000000 bytes (8.2 GB) copied, 108.352 s, 75.6 MB/s
# dd if=/dev/sda2 bs=8k count=1000000 of=/dev/null
1000000+0 records in
1000000+0 records out
8192000000 bytes (8.2 GB) copied, 105.105 s, 77.9 MB/s
# dd if=/dev/mapper/vg_blackice-root bs=8k count=100000 of=/dev/null
100000+0 records in
100000+0 records out
819200000 bytes (819 MB) copied, 11.6469 s, 70.3 MB/s

The raw disk, the LUKS-encrypted partition that's got a LVM on it, and a
crypted LVM partition. The last run spikes both CPUs up to about 50%CPU each.
So whatever it is, it's somehow more subtle than that.  Maybe the fact that
in my case, it's disk, crypto, and LVM on the crypted partition, rather than
crypted filesystems on an LVM volume?


--==_Exmh_1280953986_3909P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWc6CcC3lWbTT17ARAiAuAKCfL5NTEQUgaL9kVy6x0SN/ryDfbgCg9vhS
WfKyIOBnRrmDh2eZQDebem0=
=iHTW
-----END PGP SIGNATURE-----

--==_Exmh_1280953986_3909P--


--===============1967100432796027674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1967100432796027674==--
