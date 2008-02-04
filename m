From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any of
 mine LVM-2 disks
Date: Mon, 4 Feb 2008 05:27:09 -0800
Message-ID: <20080204052709.12f4e0d3.akpm@linux-foundation.org>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	<20080202235103.20dd9768.akpm@linux-foundation.org>
	<47A71040.5000300@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47A71040.5000300@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: for.poige+linux@gmail.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny <for.poige+linux@gmail=
.com> wrote:

>    Hello, everybody! :-)
>=20
> On 2008-02-03 14:51, Andrew Morton wrote:
> > On Sun, 3 Feb 2008 14:35:23 +0700 Igor <for.poige+linux@gmail.com> wr=
ote:
> >> On 02/02/2008, Igor <for.poige+linux@gmail.com> wrote:
> [...]
> >>     And I've tried linux-2.6.24-rc8-mm1 =E2=80=94 it fails even runn=
ing MDs saying
> >> that do_md_run() returning -22.
> >=20
> > I'm pretty sure that got fixed, thanks.
> >=20
> > I'm trying to get 2.6.24-mm1 out.  Maybe tomorrow - please test that,=
 make
> > sure that we fixed it.
>=20
>    Yeah, you've fixed it now, MD's are running OK.
>=20
>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
> of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.

You may find that you need to update your lvm userspace tools.

Alasdair?  other-dm-people?  Did we break^Wchange the userspace interface=
?

I don't think DM has merged yet, so maybe it was something else.

>    Mine system's configuration is LVM-2 on MD (Software RAID); 2.6.24
> handles it just fine.

I guess it would be helpful if you could tell us the version of your lvm
userspace tools, and identify the distro.

>    P. S. I'm not subscribed to linux-kernel@vger.kernel.org (yet), so
> please keep my e-mail address intact :-) when replying.

Is OK, lots of people are in that situation.  We do reply-to-all as a
matter of course.
