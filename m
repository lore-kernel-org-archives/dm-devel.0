From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: device-mapper: ioctl: ioctl interface mismatch:
 kernel(4.37.0), user(4.39.0), cmd(16)
Date: Wed, 19 Sep 2018 11:24:22 -0400
Message-ID: <20180919152421.GA9101@redhat.com>
References: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
	<09dfe022-a4a1-3fec-f998-ecfb0a477e44@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <09dfe022-a4a1-3fec-f998-ecfb0a477e44@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: =?iso-8859-1?Q?=D6zkan_G=F6ksu?= <ozkangksu@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 19 2018 at  8:52am -0400,
Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 19.9.2018 v 12:35 =D6zkan G=F6ksu napsal(a):
> >Hello.
> >I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper
> >2.02.181-1 | multipath-tools 0.7.7-1
> >After that multipathd started to giving the log: // device-mapper:
> >ioctl: ioctl interface mismatch: kernel(4.37.0), user(4.39.0),
> >cmd(16)
> >It was working great on my ex kernel "4.14.30-1-lts" with |
> >device-mapper 2.02.177-5 | multipath-tools 0.7.6-1
> >Also I tried multipath git version but nothing change.
> >
> >I think the problem related to device-mapper and my device mapper
> >Build Date: 2018-08-01 19:05 UTC =3D
> >https://www.archlinux.org/packages/core/x86_64/device-mapper/
> >Do I need to compile device mapper git version or what should I do?
> >
> =

> Hi
> =

> Can you pastebin how is your package linked while being compiled (gcc log=
) and
> how is then used runtime  (ldd) ?
> =

> It seems the code was linked with different .so library then it's
> using in runtime.
> =

> libdm  is supposed to handle all kernel versions.

Right, we need to get to the bottom of this.  This is _not_ something
that users should hit.
