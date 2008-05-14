From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [Notice] multipath-tools changes upstream
Date: Wed, 14 May 2008 22:21:51 +0200
Message-ID: <1210796511.7714.6.camel@Nokia-N810-51-3>
Reply-To: Christophe Varoqui <christophe.varoqui@free.fr>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1481974723=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


--===============1481974723==
Content-Type: multipart/alternative; boundary="=-m57RwKz9YYO0YzN0lhmh"


--=-m57RwKz9YYO0YzN0lhmh
Content-Type: text/plain; charset=utf-8
Content-ID: <1210796510.7714.3.camel@Nokia-N810-51-3>
Content-Transfer-Encoding: quoted-printable

In fact, the main incentive for this patchset is the netapp bug tracked o=
n bugzilla (multipathed root device with a transient no-path situation, a=
nd no way to exec a paged prio callout).

Ben chose to resurrect the ramfs callout cache trick. But I feel much mor=
e comfortable with the mem-locked shared objects.

About your concern for static-only early userspace, I'm confident it is n=
o longer a problem. Guido, from the Debian project, already aknowledged t=
he changeset and did not react to this change. But maybe now he will ...

Thanks for your input.
cvaroqui

----- Original message -----
Hi Christophe and all,

Sorry for the late reply.
I took a quick look at the patch series and got some concerns.
Please see below for details.

On Tue, 15 Apr 2008 19:02:08 +0200, Christophe Varoqui wrote:
> please take notice I updated the upstream git tree for the
> multipath-tools project. This tree includes lots of code shuffling :
>
> 1) prioritizers as dlopen'ed shared libs (/lib/libmultipath/libprio*.so=
)
> 2) checkers as dlopen'ed shared libs (/lib/libmultipath/libcheck*.so)

Dynamic loading is a nice feature for out-of-tree prioritizers
and checkers.
But I think it's better to avoid using dlopen for in-tree
prioritizers and checkers.
(Or at least provide configuration option to build them as built-in.)


I believe most distros want to use multipath-tools on installer
environment and initrd environment for root volume multipathing.
However, some distros may not be supporting dynamic loading
on such environments, and such distros are using static linked
binaries.
This change prevents such distros from using root volume multipath,
since the change dropped static build capability completely.

Does the change come from my comment below?
(http://marc.info/?l=3Ddm-devel&m=3D119817423831745&w=3D2)

On Thu, 20 Dec 2007 13:10:39 -0500 (EST), Kiyoshi Ueda wrote:
> I would like to note that we lost the priority callout feature
> completely to fix the stall problem of root multipath.
>
> Although below is just my humble opinion, I guess it was useful
> for people who want to use new prioritizers on official distro's
> environments until an update package including the prioritizer
> is released.
> So if such a case often happens, adding other ways to use external
> prioritizers (perhaps dynamic loading library module like LVM2)
> would be required in the near future.

If so, I apologize very much for confusing you.
What I meant on the comment above was:
=C2=A0 o stay all in-tree codes as built-in
=C2=A0 o add a new dynamic loading feature for out-of-tree codes

My exact image is like crash command (http://people.redhat.com/anderson/)=
.
It has many built-in sub-commands for kernel core components
(e.g. bt, list).=C2=A0 And it has 'extend' sub-command to load a shared
library and to add extra sub-commands.

In multipath-tools, I thought we could specify shared libraries
in multipath.conf like below:
=C2=A0 =C2=A0 defaults {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extention=C2=A0 new_prioritizer=
1.so
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extention=C2=A0 new_prioritizer=
2.so
=C2=A0 =C2=A0 }



Anyway, if all distros support dynamic loading on initrd environment
like Fedora, the patch series shouldn't matter.=C2=A0 But I'm not sure.
If there are such distros, we should take the approach above or
another solution like:
=C2=A0 o specify at build time whether in-tree prioritizers/checkers
=C2=A0 =C2=A0 are built into the binary or built as shared libraries
=C2=A0 o they are built as shared libraries by default to minimize
=C2=A0 =C2=A0 the binary size of multipath/multipathd commands

Thanks,
Kiyoshi Ueda



--=-m57RwKz9YYO0YzN0lhmh
Content-Type: text/html; charset=utf-8
Content-ID: <1210796511.7714.5.camel@Nokia-N810-51-3>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>In fact, the main incentive for this patchset is the netapp bug tracked on bugzilla (multipathed root device with a transient no-path situation, and no way to exec a paged prio callout).<br></p>
<p><br></p>
<p>Ben chose to resurrect the ramfs callout cache trick. But I feel much more comfortable with the mem-locked shared objects.<br></p>
<p><br></p>
<p>About your concern for static-only early userspace, I'm confident it is no longer a problem. Guido, from the Debian project, already aknowledged the changeset and did not react to this change. But maybe now he will ...<br></p>
<p><br></p>
<p>Thanks for your input.<br></p>
<p>cvaroqui<br></p>
<p><br></p>
<p>----- Original message -----<br></p>
<p>Hi Christophe and all,<br></p>
<p><br></p>
<p>Sorry for the late reply.<br></p>
<p>I took a quick look at the patch series and got some concerns.<br></p>
<p>Please see below for details.<br></p>
<p><br></p>
<p>On Tue, 15 Apr 2008 19:02:08 +0200, Christophe Varoqui wrote:<br></p>
<p>&gt; please take notice I updated the upstream git tree for the<br></p>
<p>&gt; multipath-tools project. This tree includes lots of code shuffling :<br></p>
<p>&gt;<br></p>
<p>&gt; 1) prioritizers as dlopen'ed shared libs (/lib/libmultipath/libprio*.so)<br></p>
<p>&gt; 2) checkers as dlopen'ed shared libs (/lib/libmultipath/libcheck*.so)<br></p>
<p><br></p>
<p>Dynamic loading is a nice feature for out-of-tree prioritizers<br></p>
<p>and checkers.<br></p>
<p>But I think it's better to avoid using dlopen for in-tree<br></p>
<p>prioritizers and checkers.<br></p>
<p>(Or at least provide configuration option to build them as built-in.)<br></p>
<p><br></p>
<p><br></p>
<p>I believe most distros want to use multipath-tools on installer<br></p>
<p>environment and initrd environment for root volume multipathing.<br></p>
<p>However, some distros may not be supporting dynamic loading<br></p>
<p>on such environments, and such distros are using static linked<br></p>
<p>binaries.<br></p>
<p>This change prevents such distros from using root volume multipath,<br></p>
<p>since the change dropped static build capability completely.<br></p>
<p><br></p>
<p>Does the change come from my comment below?<br></p>
<p>(http://marc.info/?l=dm-devel&amp;m=119817423831745&amp;w=2)<br></p>
<p><br></p>
<p>On Thu, 20 Dec 2007 13:10:39 -0500 (EST), Kiyoshi Ueda wrote:<br></p>
<p>&gt; I would like to note that we lost the priority callout feature<br></p>
<p>&gt; completely to fix the stall problem of root multipath.<br></p>
<p>&gt;<br></p>
<p>&gt; Although below is just my humble opinion, I guess it was useful<br></p>
<p>&gt; for people who want to use new prioritizers on official distro's<br></p>
<p>&gt; environments until an update package including the prioritizer<br></p>
<p>&gt; is released.<br></p>
<p>&gt; So if such a case often happens, adding other ways to use external<br></p>
<p>&gt; prioritizers (perhaps dynamic loading library module like LVM2)<br></p>
<p>&gt; would be required in the near future.<br></p>
<p><br></p>
<p>If so, I apologize very much for confusing you.<br></p>
<p>What I meant on the comment above was:<br></p>
<p>&nbsp; o stay all in-tree codes as built-in<br></p>
<p>&nbsp; o add a new dynamic loading feature for out-of-tree codes<br></p>
<p><br></p>
<p>My exact image is like crash command (http://people.redhat.com/anderson/).<br></p>
<p>It has many built-in sub-commands for kernel core components<br></p>
<p>(e.g. bt, list).&nbsp; And it has 'extend' sub-command to load a shared<br></p>
<p>library and to add extra sub-commands.<br></p>
<p><br></p>
<p>In multipath-tools, I thought we could specify shared libraries<br></p>
<p>in multipath.conf like below:<br></p>
<p>&nbsp; &nbsp; defaults {<br></p>
<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; extention&nbsp; new_prioritizer1.so<br></p>
<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; extention&nbsp; new_prioritizer2.so<br></p>
<p>&nbsp; &nbsp; }<br></p>
<p><br></p>
<p><br></p>
<p><br></p>
<p>Anyway, if all distros support dynamic loading on initrd environment<br></p>
<p>like Fedora, the patch series shouldn't matter.&nbsp; But I'm not sure.<br></p>
<p>If there are such distros, we should take the approach above or<br></p>
<p>another solution like:<br></p>
<p>&nbsp; o specify at build time whether in-tree prioritizers/checkers<br></p>
<p>&nbsp; &nbsp; are built into the binary or built as shared libraries<br></p>
<p>&nbsp; o they are built as shared libraries by default to minimize<br></p>
<p>&nbsp; &nbsp; the binary size of multipath/multipathd commands<br></p>
<p><br></p>
<p>Thanks,<br></p>
<p>Kiyoshi Ueda<br></p>
<p><br></p>
<p><br></p>
</body>
</html>

--=-m57RwKz9YYO0YzN0lhmh--


--===============1481974723==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1481974723==--
