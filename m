From: Phillip Susi <psusi@cfl.rr.com>
Subject: UUID homogenization
Date: Wed, 23 Mar 2011 21:59:59 -0400
Message-ID: <4D8AA59F.40700@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have noticed that LVM and dmraid use upper case prefixes to uuids (
LVM- and DMRAID- ) but multipath-tools uses lower case ( mpath- ).
Shouldn't they be the same?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2KpZ8ACgkQJ4UciIs+XuJeKACgpt0xY9K3XPUrtp7shsxgucIo
os0AnAnEyu4behUF7t6+tx+f0IzXe/3J
=GO7r
-----END PGP SIGNATURE-----
