From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Mon, 28 Nov 2011 16:14:05 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168436252-1244938477-1322514845=:11895"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valerie Aurora <val@vaaconsulting.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Christopher Chaltain <christopher.chaltain@canonical.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168436252-1244938477-1322514845=:11895
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

> >> The following patch fixes the deadlock. When the quota subsystem takes=
 s_umount,
> >> it checks if the filesystem is frozen. If it is, we drop s_umount, wai=
t for
> >> the filesystem to resume and retry.
> > =A0Thanks for the patch. I'm aware of the deadlock and Val Henson is wo=
rking
> > on resolving these types of deadlocks more systematically. But since I
> > haven't heard from her for a while, I guess I'll merge your fix and she=
'll
> > update her series to reflect your change since those patches are going =
to
> > go in at earliest in the next merge window.
> > =A0To sum up: I've merged your patch.
>=20
> FYI, I no longer have time to consult in addition to my full-time job.
>  Canonical is taking over this patch set.
>=20
> -VAL

Hi

Where can I get that patch set?

We are experiencing other similar deadlocks on RHEL-6, caused by sync or=20
background writeback (these code paths take s_umount and wait trying to do=
=20
I/O), but I wasn't able to reproduce these deadlocks on upstream kernel?=20
Are there other known deadlock possibilities?

Mikulas
--168436252-1244938477-1322514845=:11895--
