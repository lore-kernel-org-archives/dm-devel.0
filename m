From: Ryan Norwood <ryan.p.norwood@gmail.com>
Subject: max_sectors_kb limitations with VDO and dm-thin
Date: Fri, 19 Apr 2019 10:40:19 -0400
Message-ID: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3636175410872427122=="
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

--===============3636175410872427122==
Content-Type: multipart/alternative; boundary="000000000000b82c1e0586e319b4"

--000000000000b82c1e0586e319b4
Content-Type: text/plain; charset="UTF-8"

We have been using dm-thin layered above VDO and have noticed that our
performance is not optimal for large sequential writes as max_sectors_kb
and max_hw_sectors_kb for all thin devices are set to 4k due to the VDO
layer beneath.

This effectively eliminates the performance optimizations for sequential
writes to skip both zeroing and COW overhead when a write fully overlaps a
thin chunk as all bios are split into 4k which always be less than the 64k
thin chunk minimum.

Is this known behavior? Is there any way around this issue?

We are using RHEL 7.5 with kernel 3.10.0-862.20.2.el7.x86_64.

Thanks!

--000000000000b82c1e0586e319b4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">We have=
 been using dm-thin layered above VDO and have noticed that our performance=
 is not optimal for large sequential writes as max_sectors_kb and=C2=A0max_=
hw_sectors_kb=C2=A0for all thin devices are set to 4k due to the VDO layer =
beneath.</div><div dir=3D"ltr"><br></div><div>This effectively eliminates t=
he performance optimizations for sequential writes to skip both zeroing and=
 COW overhead when a write fully overlaps a thin chunk as all bios are spli=
t into 4k which always be less than the 64k thin chunk minimum.</div><div><=
br></div><div>Is this known behavior? Is there any way around this issue?</=
div><div><br></div><div>We are using RHEL 7.5 with kernel=C2=A03.10.0-862.2=
0.2.el7.x86_64.</div><div><br></div><div>Thanks!</div></div></div></div>

--000000000000b82c1e0586e319b4--


--===============3636175410872427122==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3636175410872427122==--
