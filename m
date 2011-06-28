From: Jeff Cook <jeff@deserettechnology.com>
Subject: dm-crypt TRIM support
Date: Tue, 28 Jun 2011 14:52:02 -0600
Message-ID: <4E0A3EF2.4090608@deserettechnology.com>
Reply-To: jeff@deserettechnology.com,
        device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

After mounting a LUKS partition on my SSD, I get a message that the
discard mount option is ignored. In my research, I have seen many
conflicting reports on whether this functionality was available or not.
The last reliable mail I can find was from January and indicated that an
expected release of configurable discard support over dm-crypt in
2.6.39. Can anyone let me know if this target was reached, and if not,
where development on TRIM support for dm-crypt volumes currently stands?

Thanks
Jeff
- -- 
Jeff Cook
jeff@deserettechnology.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4KPvIACgkQNtecAl0ONJp9sACeJkZz4TED8FcxZmt+y6Rz8w6T
xpMAn3dI7b8H7I3m/1mmKOkdO3YXl7yI
=kPKG
-----END PGP SIGNATURE-----
