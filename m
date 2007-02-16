From: Dan Smith <danms@us.ibm.com>
Subject: Re: [BUG?] register_blkdev: failed to get major for
	device mapper
Date: Fri, 16 Feb 2007 08:16:44 -0800
Message-ID: <m3bqju6psj.fsf@guaranine.beaverton.ibm.com>
References: <200702161437.34063.eike-kernel@sf-tec.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200702161437.34063.eike-kernel@sf-tec.de> (Rolf Eike Beer's
	message of "Fri, 16 Feb 2007 14:37:28 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

RB> The error message is quoted in subject.

I was seeing this behavior a couple days ago.  I had been ignoring the
warnings about using the known-broken gcc 4.1.0; updating to 4.1.1
fixed it for me.

- --=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF1djxwtEf7b4GJVQRAlUAAKCHIuPS5dRCXxiw5yHEMleGZlV3wQCeM8Xu
Z8T/nOT2L9Pe0O3ItMBu9pY=3D
=3Dgn5n
-----END PGP SIGNATURE-----
