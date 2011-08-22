From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] kobj_uevent: Ignore if some listeners cannot handle message
Date: Mon, 22 Aug 2011 18:24:19 +0200
Message-ID: <CAPXgP10dYJv0aS_WwUqJr=YEz7WVp1abvED=fKEmOPp42ZRP6A@mail.gmail.com>
References: <4E4ECA5D.1020907@redhat.com> <1314021094-15453-1-git-send-email-mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1314021094-15453-1-git-send-email-mbroz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, ebiederm@xmission.com, greg@kroah.com
List-Id: dm-devel.ids

On Mon, Aug 22, 2011 at 15:51, Milan Broz <mbroz@redhat.com> wrote:
> kobject_uevent() uses a multicast socket and should ignore
> if one of listeners cannot handle messages or nobody is
> listening at all.
>
> Easily reproducible when a process in system is cloned
> with CLONE_NEWNET flag.

> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (retval =3D=3D -ENOBUFS)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (retval =3D=3D -ENOBUFS || retval =3D=3D -ESRCH)

Looks good to me.

Kay
