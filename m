From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: How dm multipath handle IO
Date: Fri, 14 Mar 2014 09:44:03 +0100
Message-ID: <CAO5znatnsF_x=-EOKHpezw0M4QNZ5KXiawEGKQ7hkXMCwfQy2Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0318240075799050210=="
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

--===============0318240075799050210==
Content-Type: multipart/alternative; boundary=001a1134a7e468572504f48d1267

--001a1134a7e468572504f48d1267
Content-Type: text/plain; charset=UTF-8

Hello Guys,

It's a general question about how dm and particularly multipathd handle IO?
I mean, is it a transaction? Is each IO initiated from the OS get back an
acknowledgement? If it is, is there a retry mechanism?
Or are the IO sent blindingly to the block device?

If someone have some good article on it, I would be very interested in
understanding more deeply how IO are handled.

Thanks a lot,

-- 
Nicolas MICHEL

--001a1134a7e468572504f48d1267
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello Guys,<div><br></div><div>It&#39;s a general question=
 about how dm and particularly multipathd handle IO? I mean, is it a transa=
ction? Is each IO initiated from the OS get back an acknowledgement? If it =
is, is there a retry mechanism?</div>
<div>Or are the IO sent blindingly to the block device?</div><div><br></div=
><div>If someone have some good article on it, I would be very interested i=
n understanding more deeply how IO are handled.</div><div><br></div><div>
Thanks a lot,<br clear=3D"all"><div><br></div>-- <br>Nicolas MICHEL
</div></div>

--001a1134a7e468572504f48d1267--


--===============0318240075799050210==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0318240075799050210==--
