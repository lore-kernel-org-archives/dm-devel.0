From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 23:29:17 -0500
Message-ID: <24653.1261110557@localhost>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain>
            <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261110557_3855P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754312AbZLREaS@vger.kernel.org>
In-Reply-To: Your message of "Thu, 17 Dec 2009 18:29:25 EST."
             <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--==_Exmh_1261110557_3855P
Content-Type: text/plain; charset=us-ascii

On Thu, 17 Dec 2009 18:29:25 EST, Mikulas Patocka said:

> There is no need to make a script for it. The script isn't so smart to 
> tell what is understandable and what is nto.

Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
continuation line, it's probably in its rights to whinge. 

grep -r -P '^\t{7}(?!(.*,$|.*\);$))' . | more

produces a whole lot of "this can't end well" output. My favorite so far:

fs/reisersfs/do_balan.c, lines 460-477 (note: 3 leading tabs elided)

				leaf_paste_entries(&bi,
						   n +
						   item_pos
						   -
						   ret_val,
						   l_pos_in_item,
						   1,
						   (struct
						    reiserfs_de_head
						    *)
						   body,
						   body
						   +
						   DEH_SIZE,
						   tb->
						   insert_size
						   [0]
				    );

Yes, that used to be 24 more columns to the right.  Gaak.


--==_Exmh_1261110557_3855P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLKwUdcC3lWbTT17ARAneDAKCbUY9j6dpFbsi7TTin/t1rd0B2OgCgyRV2
elcRq2QVY9OQCTNq0p0lEpU=
=JH5A
-----END PGP SIGNATURE-----

--==_Exmh_1261110557_3855P--
