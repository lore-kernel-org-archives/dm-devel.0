From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 1/2] Add userspace device-mapper target
Date: Mon, 19 Feb 2007 07:16:29 -0800
Message-ID: <m3odnq5gaa.fsf@guaranine.beaverton.ibm.com>
References: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
	<20070209004800A.fujita.tomonori@lab.ntt.co.jp>
	<m31wl0k3rn.fsf@guaranine.beaverton.ibm.com>
	<20070209081137X.fujita.tomonori@lab.ntt.co.jp>
	<m3k5yrgwdg.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3k5yrgwdg.fsf@guaranine.beaverton.ibm.com> (Dan Smith's message
	of "Fri, 09 Feb 2007 07:54:03 -0800")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

DS> I'll take a stab at making this change and will post it when I
DS> have something working...

I've got a hacked-up version running that allows userspace to provide
a pointer to a buffer to be written after the original bio completes.
This seems to work pretty well, but I haven't added support to the
library or my cow application, so I'm not sure how the performance
differs.

There is something that needs to be resolved, however.  Currently,
bio_map_user() assumes it is being run in process context.  Since we
defer to a kthread for all ring buffer processing, we can't easily
construct the extra bios.  So, there are two paths forward that I can
think of:

1. Redesign how we process messages going to the kernel.  Userspace
   could mark them as "tentatively ready" and then do the write()
   which just goes through and constructs extra bios and marks them
   "ready".  This seems undesirable to me, because we're increasing
   the amount of time that userspace is blocked in the kernel.

2. Add a bio_map_user_from() call to the kernel, which behaves just
   like bio_map_user(), but takes a struct task struct pointer to the
   process to map from, thus allowing the kthread to construct the
   bios asynchronously.  I have a patch cooked up to do this, but I'm
   worried that it might be rather controversial.

Thoughts?

- --=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF2b9PwtEf7b4GJVQRAv7vAJ4uU18Bnm0SSZl+ey6Np2NAf5uDagCdHzRY
0P/AK4VG1H99apotu11toow=3D
=3Dj1Yp
-----END PGP SIGNATURE-----
