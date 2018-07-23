From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Is thin provisioning still experimental?
Date: Sun, 22 Jul 2018 22:06:05 -0700
Message-ID: <CAN-y+EK612pGsJTH-zO=FU0DpcFJxKfEHuDNs+6ufE6we9aK+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5850193988108805883=="
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

--===============5850193988108805883==
Content-Type: multipart/alternative; boundary="0000000000004888520571a39a62"

--0000000000004888520571a39a62
Content-Type: text/plain; charset="UTF-8"

I love all of the work you guys do @dm-devel . Thanks for taking the time
to read this.


I would like to use thin provisioning targets in production, but it's hard
to ignore the warning in the documentation. It seems like, with an
understanding of how thin provisioning works, it should be safe to use.


Quoting from this page:
https://raw.githubusercontent.com/torvalds/linux/master/Documentation/device-mapper/thin-provisioning.txt

"These targets are very much still in the EXPERIMENTAL state.  Please do
not yet rely on them in production.  But do experiment and offer us
feedback.  Different use cases will have different performance
characteristics, for example due to fragmentation of the data volume."

I believe that similar suggestions have been in place for more than 7 years
now, based on this post:
https://www.redhat.com/archives/dm-devel/2011-July/msg00012.html


Is it still the case that thin provisioning should never be used in
production? There are plenty of articles online (including from redhat)
which make no mention of the fact that the underlying technology is unsafe.
LVM does not offer any warnings about the inherit risk of using thin
provisioning.

Is that advisory still necessary? If so, can you provide some insight
specifically into what is unsafe about the thin targets at this point? Is
the concern that the underlying software device drivers are still not
tested well enough to avoid bugs? Is this more a situation where someone
might run into extremely poor performance for a very bad implementation of
the targets? Is it more about people directly using the targets instead of
using LVM, and maybe it's not bullet-proof for bad integrations?


If the metadata and data device for the thin pool have enough space and are
both error free, the kernel has plenty of free RAM, block sizes are set
large enough to never run into performance issues (64 MiB), all of the
underlying hardware is redundant on high performance NVME (no worries of
fragmentation of data volume)... is it still unsafe for production? If so,
can you shed some light on why that is?


Thin provisioning is so cool. It would be a shame to not use it!


Thank you so much!

--0000000000004888520571a39a62
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I love all of the work you guys do @dm-devel . Thanks=
 for taking the time to read this.</div><div><br></div><div><br></div><div>=
I would like to use thin provisioning targets in production, but it&#39;s h=
ard to ignore the warning in the documentation. It seems like, with an unde=
rstanding of how thin provisioning works, it should be safe to use.=C2=A0</=
div><div><br></div><div><br></div>Quoting from this page:=C2=A0<a href=3D"h=
ttps://raw.githubusercontent.com/torvalds/linux/master/Documentation/device=
-mapper/thin-provisioning.txt">https://raw.githubusercontent.com/torvalds/l=
inux/master/Documentation/device-mapper/thin-provisioning.txt</a><br><br>&q=
uot;These targets are very much still in the EXPERIMENTAL state.=C2=A0 Plea=
se do not yet rely on them in production.=C2=A0 But do experiment and offer=
 us feedback.=C2=A0 Different use cases will have different performance cha=
racteristics, for example due to fragmentation of the data volume.&quot;<br=
><br>I believe that similar suggestions have been in place for more than 7 =
years now, based on this post:=C2=A0<a href=3D"https://www.redhat.com/archi=
ves/dm-devel/2011-July/msg00012.html">https://www.redhat.com/archives/dm-de=
vel/2011-July/msg00012.html</a><br><br><br>Is it still the case that thin p=
rovisioning should never be used in production? There are plenty of article=
s online (including from redhat) which make no mention of the fact that the=
 underlying technology is unsafe. LVM does not offer any warnings about the=
 inherit risk of using thin provisioning.=C2=A0<br><br>Is that advisory sti=
ll necessary? If so, can you provide some insight specifically into what is=
 unsafe about the thin targets at this point? Is the concern that the under=
lying software device drivers are still not tested well enough to avoid bug=
s? Is this more a situation where someone might run into extremely poor per=
formance for a very bad implementation of the targets? Is it more about peo=
ple directly using the targets instead of using LVM, and maybe it&#39;s not=
 bullet-proof for bad integrations?<br><br><br>If the metadata and data dev=
ice for the thin pool have enough space and are both error free, the kernel=
 has plenty of free RAM, block sizes are set large enough to never run into=
 performance issues (64 MiB), all of the underlying hardware is redundant o=
n high performance NVME (no worries of fragmentation of data volume)... is =
it still unsafe for production? If so, can you shed some light on why that =
is?<div><br></div><div><br></div><div>Thin provisioning is so cool. It woul=
d be a shame to not use it!<br><div><br></div><div><br></div><div>Thank you=
 so much!</div></div></div>

--0000000000004888520571a39a62--


--===============5850193988108805883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5850193988108805883==--
