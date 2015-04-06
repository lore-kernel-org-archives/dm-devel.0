From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Mon, 6 Apr 2015 09:00:46 -0400
Message-ID: <20150406130045.GA18583@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Apr 05 2015 at  1:20pm -0400,
Pali Roh=E1r <pali.rohar@gmail.com> wrote:

> This patch series increase security of suspend and hibernate actions.=
 It allows
> user to safely wipe crypto keys before suspend and hibernate actions =
starts
> without race conditions on userspace process with heavy I/O.
>=20
> To automatically wipe cryto key for <device> before hibernate action =
call:
> $ dmsetup message <device> 0 key wipe_on_hibernation 1
>=20
> To automatically wipe cryto key for <device> before suspend action ca=
ll:
> $ dmsetup message <device> 0 key wipe_on_suspend 1
>=20
> (Value 0 after wipe_* string reverts original behaviour - to not wipe=
 key)

Can you elaborate on the attack vector your changes are meant to protec=
t
against?  The user already authorized access, why is it inherently
dangerous to _not_ wipe the associated key across these events?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
