From: Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Mon, 13 Nov 2006 08:35:33 +0100
Message-ID: <20061113073533.GA18022@suse.de>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <20061109232438.GS30653@agk.surrey.redhat.com> <20061109233258.GH2616@elf.ucw.cz> <200611101303.33685.rjw@sisk.pl> <20061112184310.GC5081@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754228AbWKMHjN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061112184310.GC5081@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: dm-devel.ids

On Sun, Nov 12, 2006 at 06:43:10PM +0000, Pavel Machek wrote:
> Hi!
=20
> > (b) it prevents journaling filesystems in general from replaying jo=
urnals
> > after a failing resume.
>=20
> I do not see b) as an useful goal.

I'm not sure, but i guess it also solves "GRUB takes a minute to load k=
ernel
and initrd from /boot on suspended reiserfs"-problem, which i see as a =
_very_
useful goal.

Often, most of the time needed for resume is spent by GRUB loading the
kernel/initrd from a journaled FS.
--=20
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, N=FCrnberg  | "Well, surrounding them's out."=
=20
