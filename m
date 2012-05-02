From: Phillip Susi <psusi@ubuntu.com>
Subject: dmraid incompatible with multipath-tools?
Date: Tue, 01 May 2012 23:16:08 -0400
Message-ID: <4FA0A6F8.6030600@ubuntu.com>
Reply-To: "ATARAID \(eg, Promise Fasttrak,
	Highpoint 370\) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: ataraid-list@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

A user recently filed this bug report against ubuntu 12.04:

https://bugs.launchpad.net/ubuntu/+source/dmraid/+bug/992975

I believe this is the result of my patch fixing the testing support, and testing being enabled by default.  With testing enabled, it looks like dmraid is finding the physical disks both on the normal scsi devnode, and again on the dm devnode created by multipath-tools.

Why does multipath-tools create a dm mapping for each physical disk by default?  It seems like this is likely to cause other problems as well.  I suppose that configuring dmraid with --disable-testing would resolve this issue ( and it probably should be disabled by default if it doesn't play well with multipath-tools ), but I'd like to understand multipath-tools better first and try to find a better solution.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPoKb4AAoJEJrBOlT6nu75NGwIAMi+yoaiupVV3pKPYe9TVwoz
RoeU9NRrY5DObqwOo8LlQqXCEMBGle84WhBf1c23vBESolw0kLN1a1Pb1hbvCWxa
S0KYwlSRR7xg3cGIaRgS2aX5pvI5YwqrSQQEvgCBZ9S+J7cN2qugRhX/+GjtJRJa
ITqkSNjAjp9IoO8vH4RPSdmsieVTKvdjL9vGmJGEnvpOBqCjJ2NjwWNhgMvlhbm7
n+DFkCy3GLKzmJGuMTHcQodmEuoOSSi4xMI6YvJDCe/D6OLlnlLxjRwqQhkLOq0N
s5PnaoQIgp8z+3I5kyvBQ+kz4EOl1cZAWie8YcpUD2mWJCFRLdLOmiGmwD02UNk=
=edhj
-----END PGP SIGNATURE-----
