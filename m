From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2 3/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Tue, 28 Jul 2015 16:48:12 +0200
Message-ID: <20150728144812.GS13765@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-4-git-send-email-pali.rohar@gmail.com>
 <20150728144419.GA19760@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150728144419.GA19760@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Tuesday 28 July 2015 16:44:19 Pavel Machek wrote:
> On Sun 2015-06-21 13:20:34, Pali Roh=C3=A1r wrote:
> > This patch adds dm message commands and option strings to optionall=
y wipe key
> > from dm-crypt device before entering suspend or hibernate state.
> >=20
> > Before key is wiped dm device must be suspended. To prevent race co=
nditions with
> > I/O and userspace processes, wiping action must be called after pro=
cesses are
> > freezed. Otherwise userspace processes could start reading/writing =
to disk after
> > dm device is suspened and freezing processes before suspend/hiberna=
te action
> > will fail.
>=20
> Are you sure this is enough?
>=20
> We still may need to allocate memory after userspace is frozen, and
> that could mean writing dirty buffers out to make some memory free...
>=20
> 								Pavel
> 							=09

Hm... good question. Maybe it is needed to also flush all buffers?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
