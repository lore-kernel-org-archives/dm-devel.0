From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Tue, 12 Sep 2006 21:28:58 -0700
Message-ID: <m3hczcpeyd.fsf@guaranine.beaverton.ibm.com>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
	<m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
	<200609130201.k8D21V3e014353@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1505935676=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609130201.k8D21V3e014353@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Wed, 13 Sep 2006 11:01:31 +0900")
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

--===============1505935676==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> Surely, we need to replace the request list with hash list.

I have done that now.  It helps performance quite a bit, although it
does not perform at the same level with lots of threads.  I'll keep
working on it.

FT> Another possible improvement is that simplifying dmu_ctl_write()
FT> by using kernel thread. Now the user-space daemon calls
FT> dmu_ctl_write() and does lots of work in kernel mode. It is better
FT> for a user-space daemon to just notify kernel of new events, go
FT> back to user space, and receive new events from kernel in SMP
FT> boxes. I like to create kernel threads, dmu_ctl_write just wakes
FT> up the threads, and they call dmu_event_recv().

Yes, I think this would be a good idea.

FT> Yep, I dropped some of the features because of my laziness, though
FT> if endio means that the kernel notifies user-space of I/O
FT> completion, I think that I implemented it.

We need more than just notification of endio, but also the ability to
delay the endio completion until userspace has acknowledged the
endio.  This is crucial for us to maintain metadata consistency in the
CoW case.

FT> One possible feature is support for multiple destinations. If user
FT> space can tell kernel to write multiple devices, we can implement
FT> kinda RAID daemons in user space.

Yes, my original version supported this, which would allow RAID from
userspace, as well as lots of other neat tricks :)

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFB4kQwtEf7b4GJVQRAvSfAJ42bAQ2OhcZY8+7NQhsbwsgWYMt6gCeNsGr
4wgE/7ZN/NLqzxv/HS5E2hk=
=T44k
-----END PGP SIGNATURE-----
--=-=-=--


--===============1505935676==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1505935676==--
