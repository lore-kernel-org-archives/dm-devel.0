From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH] dm: introduce DM_GET_TARGET_VERSION
Date: Tue, 17 Sep 2019 09:56:17 -0400
Message-ID: <CAMeeMh9t4LBwJn_CPQgFNa_Tyj22fJYHK-4qAnyn0RXm9RzCnw@mail.gmail.com>
References: <alpine.LRH.2.02.1909160553360.11421@file01.intranet.prod.int.rdu2.redhat.com>
	<20190916180107.GA725@infradead.org>
	<127b8c4e-a6dc-6d5e-caff-fe1a0ca3a5bb@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3403680359777632028=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <127b8c4e-a6dc-6d5e-caff-fe1a0ca3a5bb@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, lvm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--===============3403680359777632028==
Content-Type: multipart/alternative; boundary="000000000000461cf00592c016e6"

--000000000000461cf00592c016e6
Content-Type: text/plain; charset="UTF-8"

I'm confused here:
>...and then it fails on activation because DM table load detects old (or
missing) dm-crypt feature.
>(There was no way to get dm target version before table load if module is
not loaded.)
>And I tried to avoid modprobe calls from libcryptsetup.

I'm not understanding how this could work. Let's say there's a module
providing target 'splice' which is currently unloaded. Then `dmsetup
target-version splice` is unaware of the splice target, and thus reports
nothing. So in order to get the proper version number, we do have to do a
modprobe first.
But, if the module providing splice *is* already loaded, `dmsetup targets`
will report splice's version number already, so `dmsetup target-version
splice` is a convenience instead of parsing `dmsetup targets` output?

--000000000000461cf00592c016e6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">I&#39;m confused here:<br>&gt;...and then=
 it fails on activation because DM table load detects old (or missing) dm-c=
rypt feature.<br>&gt;(There was no way to get dm target version before tabl=
e load if module is not loaded.)<br>&gt;And I tried to avoid modprobe calls=
 from libcryptsetup.<br><br></div><div>I&#39;m not understanding how this c=
ould work. Let&#39;s say there&#39;s a module providing target &#39;splice&=
#39; which is currently unloaded. Then `dmsetup target-version splice` is u=
naware of the splice target, and thus reports nothing. So in order to get t=
he proper version number, we do have to do a modprobe first. <br>But, if th=
e module providing splice *is* already loaded, `dmsetup targets` will repor=
t splice&#39;s version number already, so `dmsetup target-version splice` i=
s a convenience instead of parsing `dmsetup targets` output?<br><br><br></d=
iv></div>

--000000000000461cf00592c016e6--


--===============3403680359777632028==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3403680359777632028==--
