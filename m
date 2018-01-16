From: Mauro Condarelli <ziobyte@gmail.com>
Subject: Limiting in-flight requests
Date: Tue, 16 Jan 2018 10:36:06 +0100
Message-ID: <CABDgG8-Ka8er6-14W5uUv0NyiNe3o=Nt3JcYFvpEoxc5kvE7ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1154113764904661337=="
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

--===============1154113764904661337==
Content-Type: multipart/alternative; boundary="001a1141234cc3634b0562e17548"

--001a1141234cc3634b0562e17548
Content-Type: text/plain; charset="UTF-8"

Hi,
this is my first post here, so feel free to redirect me if I'm trespassing
in some way.

I'm trying to build a custom dm target to be used as filter for normal
filesystem operations.

I managed to build a working prototype, but field-testing it I found that,
in certain conditions (e.g.: untarring a large tar full of many small
files) the number of in-flight requests rapidly rises to several thousands.

This is a problem since I allocate some pages for each remapping (I
essentially double the allocation for the time request is fully handled by
underlying device); this leads to memory starvation and, possibly, even to
kernel panics.

I tried limiting the number/size of in-flight requests by returning
DM_MAPIO_REQUEUE when resource consumption exceeded a certain threshold;
This doesn't seem to work because the error is not trapped at dm-stage, but
it is reported directly to filesystem and, from there, to application (tar
or mkfs.ext4).

What is the correct way to tell dm to stop sending more requests, for a
short while (i.e.: till some old requests are completed)?

Note: I'm using kernel v4.4.9 so I don't have DM_MAPIO_DELAY_REQUEUE

Note2: in my target.map I re-allocate the scatterlist, save the original
one and substitute; I do the reverse in .end_io.

Thanks in advance
Mauro

--001a1141234cc3634b0562e17548
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div><div><div>Hi,<br><=
/div>this is my first post here, so feel free to redirect me if I&#39;m tre=
spassing in some way.<br><br></div>I&#39;m trying to build a custom dm targ=
et to be used as filter for normal filesystem operations.<br><br></div>I ma=
naged to build a working prototype, but field-testing it I found that, in c=
ertain conditions (e.g.: untarring a large tar full of many small files) th=
e number of in-flight requests rapidly rises to several thousands.<br><br><=
/div>This is a problem since I allocate some pages for each remapping (I es=
sentially double the allocation for the time request is fully handled by un=
derlying device); this leads to memory starvation and, possibly, even to ke=
rnel panics.<br><br></div>I tried limiting the number/size of in-flight req=
uests by returning DM_MAPIO_REQUEUE when resource consumption exceeded a ce=
rtain threshold; This doesn&#39;t seem to work because the error is not tra=
pped at dm-stage, but it is reported directly to filesystem and, from there=
, to application (tar or mkfs.ext4).<br><br></div>What is the correct way t=
o tell dm to stop sending more requests, for a short while (i.e.: till some=
 old requests are completed)?<br><br></div>Note: I&#39;m using kernel v4.4.=
9 so I don&#39;t have DM_MAPIO_DELAY_REQUEUE<br><br></div>Note2: in my targ=
et.map I re-allocate the scatterlist, save the original one and substitute;=
 I do the reverse in .end_io.<br><br></div>Thanks in advance<br></div>Mauro=
<br></div>

--001a1141234cc3634b0562e17548--


--===============1154113764904661337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1154113764904661337==--
