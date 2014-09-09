From: Rob <robertfreeman83@gmail.com>
Subject: Powerpath vs dm-multipath - two points of FUD?
Date: Tue, 9 Sep 2014 17:50:49 +0100
Message-ID: <CA+ZWeLBUXK_kWjNkUcsg_5rP8ruew6ipupzdL_kw_K4v70p_5g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0336150380571021457=="
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

--===============0336150380571021457==
Content-Type: multipart/alternative; boundary=047d7b10ce51d537570502a4bc2e

--047d7b10ce51d537570502a4bc2e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi List,

Firstly, apologies if this is a common topic and my intentions are not to
start a flame war. I've googled extensively but haven't found specific
information to address my queries, so I thought I would turn here.

We have a rather large multi-tenant infrastructure using PowerPath. Since
this inherently comes with increased maintenance costs (recompiling the
module, requiring extra steps / care when upgrading etc) we are looking at
using dm-multipath as the defacto standard SAN-connection abstraction layer
for installations of RHEL 7+.

After discussions with our SAN Architect team, we were given the below
points to chew over and we were met with stiff resistance to moving away
from Powerpath. Since there was little right-of-reply, I'd like to run
these points past the minds of this list to understand if these are valid
enough to justify a valid business case of keeping Powerpath over Multipath=
.












*Here=E2=80=99s a couple of reasons to stick with powerpath:* Load
Balancing: Whilst dm-multipath can make use of more than one of the paths
to an array, .i.e with round-robin, this isn=E2=80=99t true load-balancing.
 Powerpath is able to examine the paths down to the array and balance
workload based on how busy the storage controller / ports are.  AFAIK Rhel6
has added functionality to make path choices based on queue depth and
service time, which does add some improvement over vanilla round-robin. For
VMAX and CX/VNX, powerpath uses the following parameters to balance the
paths out: Pending I/Os on the path, Size of I/Os, Types of I/Os, and Paths
most recently used. * Flakey Path Detection: The latest versions of
powerpath can proactively take paths out of service should it observe
intermittent IO failures (remember any IO failure can hold a thread for
30-60 seconds whilst the SCSI command further up the stack times out, and a
retry is sent).  dm-multipath doesn=E2=80=99t have functionality to remove =
a flakey
path, paths can only be marked out of service on hard failure.*

Many thanks
--
Rob

--047d7b10ce51d537570502a4bc2e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi List,<br><br>Firstly, apologies if this is a common top=
ic and my intentions are not to start a flame war. I&#39;ve googled extensi=
vely but haven&#39;t found specific information to address my queries, so I=
 thought I would turn here.<br><br>We have a rather large multi-tenant infr=
astructure using PowerPath. Since this inherently comes with increased main=
tenance costs (recompiling the module, requiring extra steps / care when up=
grading etc) we are looking at using dm-multipath as the defacto standard S=
AN-connection abstraction layer for installations of RHEL 7+.<div><br></div=
><div>After discussions with our SAN Architect team, we were given the belo=
w points to chew over and we were met with stiff resistance to moving away =
from Powerpath. Since there was little right-of-reply, I&#39;d like to run =
these points past the minds of this list to understand if these are valid e=
nough to justify a valid business case of keeping Powerpath over Multipath.=
<br><br><br><i>Here=E2=80=99s a couple of reasons to stick with powerpath:<=
br><br>* Load Balancing:<br><br>=C2=A0Whilst dm-multipath can make use of m=
ore than one of the paths to an array, .i.e with round-robin, this isn=E2=
=80=99t true load-balancing. =C2=A0Powerpath is able to examine the paths d=
own to the array and balance workload based on how busy the storage control=
ler / ports are. =C2=A0AFAIK Rhel6 has added functionality to make path cho=
ices based on queue depth and service time, which does add some improvement=
 over vanilla round-robin.<br><br>=C2=A0For VMAX and CX/VNX, powerpath uses=
 the following parameters to balance the paths out: Pending I/Os on the pat=
h, Size of I/Os, Types of I/Os, and Paths most recently used.<br><br>=C2=A0=
* Flakey Path Detection:<br><br>=C2=A0The latest versions of powerpath can =
proactively take paths out of service should it observe intermittent IO fai=
lures (remember any IO failure can hold a thread for 30-60 seconds whilst t=
he SCSI command further up the stack times out, and a retry is sent). =C2=
=A0dm-multipath doesn=E2=80=99t have functionality to remove a flakey path,=
 paths can only be marked out of service on hard failure.</i></div><div><br=
></div><div>Many thanks</div><div>--</div><div>Rob</div></div>

--047d7b10ce51d537570502a4bc2e--


--===============0336150380571021457==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0336150380571021457==--
