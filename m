From: Valdis.Kletnieks@vt.edu
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 12:50:17 -0400
Message-ID: <12774.1254502217@turing-police.cc.vt.edu>
References: <200910021255.27689.czoccolo@gmail.com>
	<20091002124921.GA4494@redhat.com>
	<4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	<1254497520.10392.11.camel@marge.simson.net>
	<20091002154020.GC4494@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2081582937=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Fri, 02 Oct 2009 11:40:20 EDT."
	<20091002154020.GC4494@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, Corrado Zoccolo <czoccolo@gmail.com>, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

--===============2081582937==
Content-Type: multipart/signed; boundary="==_Exmh_1254502217_3334P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1254502217_3334P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:

> In that case, Corrado's suggestion of refining it further and disabling idling
> for seeky process only on non-rotational media (SSD and hardware RAID), makes
> sense to me.

Umm... I got petabytes of hardware RAID across the hall that very definitely
*is* rotating.  Did you mean "SSD and disk systems with big honking caches
that cover up the rotation"?  Because "RAID" and "big honking caches" are
not *quite* the same thing, and I can just see that corner case coming out
to bite somebody on the ass...


--==_Exmh_1254502217_3334P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKxi9JcC3lWbTT17ARApP2AJ4i2rJ5d8WCfE9DU/OfTmNPSD1P/ACg1mVC
KmoukBpnPxlD7yD8IMZMXw0=
=qKY6
-----END PGP SIGNATURE-----

--==_Exmh_1254502217_3334P--


--===============2081582937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2081582937==--
