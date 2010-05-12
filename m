From: Will Drewry <wad@chromium.org>
Subject: Re: [dm-devel] [RFC PATCH] init: boot to device-mapper targets
	without an initr*
Date: Wed, 12 May 2010 16:41:10 -0500
Message-ID: <AANLkTikJrrq7vfr9VwRsE92wfW8smJe8WNwOJoZQygk1@mail.gmail.com>
References: <20100512203054.GA22104@z600>
	 <20100512205846.GG2377@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100512205846.GG2377@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 12, 2010 at 3:58 PM, Alasdair G Kergon <agk@redhat.com> wro=
te:
> On Wed, May 12, 2010 at 03:30:54PM -0500, Will Drewry wrote:
>> The format is dm=3Dminor,rwmode,begin,length,target,target,params,wi=
th,commas
>
> 1. If we go down this route, pick a format that gives access to the f=
ull
> set of allowed table formats (or which can be extended trivially to d=
o
> so in future). =A0So cope with multi-line tables e.g. with a marker (=
empty
> field?) to start a new table line.

Sounds good.  That shouldn't add any serious code complexity either.
An empty field (,,) would probably work nicely.

> 2. It would be wise to define a name and optional uuid too, so the de=
vice is
> fully visible and accessible from userspace through existing mechanis=
ms.
> Originally the name+uuid were decoupled from the mapped device itself=
,
> but that got changed, though the code layout (dm-ioctl.c vs. dm.c) st=
ill
> makes them appear to be separate.

It wasn't clear how I could define those externally to the dm-ioctl cod=
e.

>> + =A0 =A0 char target[24];
>> + =A0 =A0 char target_params[256];
>
> I'm never a fan of hard-coded restrictions, but at least make them
> explicit as #defines, so people can see at a glance what to change
> if they get errors for exceeding them.

Agreed. I'll add defines or see if I can use the existing ones.
(Alternately, it might be possible to use the passed in string in place
 depending on the changes.)

>> +static void __init dm_setup_drive(void)
>
> Arguably most of this code could be a helper function exported from d=
rivers/md.

True, or I could follow the do_mounts_md model and just use the ioctl i=
nterface.
Would a parallel function to ctl_ioctl which behaved the same but didn'=
t expect
user-sourced dm_ioctl struct be a reasonable compromise?

That'd limit the code to parsing the parameter line and calling through=
 without
duplicating the code in dev_create and table_load to yield the same beh=
avior.

thanks!
will
