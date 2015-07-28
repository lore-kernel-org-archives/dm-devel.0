From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 3/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Tue, 28 Jul 2015 16:44:19 +0200
Message-ID: <20150728144419.GA19760@amd>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-4-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434885634-19895-4-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Sun 2015-06-21 13:20:34, Pali Roh=E1r wrote:
> This patch adds dm message commands and option strings to optionally =
wipe key
> from dm-crypt device before entering suspend or hibernate state.
>=20
> Before key is wiped dm device must be suspended. To prevent race cond=
itions with
> I/O and userspace processes, wiping action must be called after proce=
sses are
> freezed. Otherwise userspace processes could start reading/writing to=
 disk after
> dm device is suspened and freezing processes before suspend/hibernate=
 action
> will fail.

Are you sure this is enough?

We still may need to allocate memory after userspace is frozen, and
that could mean writing dirty buffers out to make some memory free...

								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
