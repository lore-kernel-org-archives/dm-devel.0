From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 11:14:51 -0400
Message-ID: <7b13a0f81003190814y56a3ed76yf06ed23a11747b4@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com> <4BA38567.1050106@suse.de>
	<4BA392B2.50903@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2842373049232397288=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA392B2.50903@redhat.com>
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

--===============2842373049232397288==
Content-Type: multipart/alternative; boundary=00c09f8a54ea194368048228cf34

--00c09f8a54ea194368048228cf34
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 19, 2010 at 11:05 AM, Peter Rajnoha <prajnoha@redhat.com> wrote:

> As for the variables, we already carry some important
> information within uevents.
>
> Generally, it carries hints for udev rules to instruct them
> how they should be applied correctly, which parts should be
> run based on the type of the device, it's real meaning with all
> relations to other devices taken into account within that
> DM subsystem used (e.g. LVM2's snapshots, mirrors...).
>
> Most of this information is really not suitable to be stored
> as a sysfs attribute since it deals with userspace notions,
> an abstraction layer above device-mapper...
>

Presumably this information originates from user space when
setting up the device-mapper device, right? Why can't you
simply store it in, say, /var/run/device-mapper?

(Or, better, store it in /dev/.device-mapper/ to avoid hitting
the real disk - /dev is guaranteed to be on tmpfs)

Thanks,
David

--00c09f8a54ea194368048228cf34
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 19, 2010 at 11:05 AM, Peter Rajnoha <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:prajnoha@redhat.com">prajnoha@redhat.com</a>&gt;</span> wrote:=
<br><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">As for the variables, we already carry some important</di=
v>
information within uevents.<br>
<br>
Generally, it carries hints for udev rules to instruct them<br>
how they should be applied correctly, which parts should be<br>
run based on the type of the device, it&#39;s real meaning with all<br>
relations to other devices taken into account within that<br>
DM subsystem used (e.g. LVM2&#39;s snapshots, mirrors...).<br>
<br>
Most of this information is really not suitable to be stored<br>
as a sysfs attribute since it deals with userspace notions,<br>
an abstraction layer above device-mapper...<br></blockquote><div><br></div>=
<div>Presumably this information originates from user space when</div><div>=
setting up the device-mapper device, right? Why=A0can&#39;t=A0you</div><div=
>
simply store it in, say, /var/run/device-mapper?</div><div><br></div><div>(=
Or, better, store it in /dev/.device-mapper/ to avoid hitting</div><div>the=
 real disk - /dev is guaranteed to be on tmpfs)</div><div><br></div><div>
Thanks,</div><div>David</div><div><br></div></div>

--00c09f8a54ea194368048228cf34--


--===============2842373049232397288==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2842373049232397288==--
