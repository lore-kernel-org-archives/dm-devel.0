From: roucaries.bastien@gmail.com
Subject: Re: [3.10.7] Reproductible soft lockup, recover but freeze even the mouse
Date: Fri, 13 Sep 2013 09:29:49 +0200
Message-ID: <eef6aca5-3ec5-488c-bd9f-09930313ba37@email.android.com>
References: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com> <20130909194826.74d5df39@notabene.brown> <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
List-Id: dm-devel.ids




Bastien ROUCARIES <roucaries.bastien@gmail.com> a =C3=A9crit=C2=A0:
>On Mon, Sep 9, 2013 at 11:48 AM, NeilBrown <neilb@suse.de> wrote:
>> On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES
>> <roucaries.bastien@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> I experiment a soft lockup. during 20 s I have no mouse, could not
>>> switch back to console and so on.
>>>
>>> I achieve to get a backtrace by echo 15 >
>>> /proc/sys/kernel/hung_task_timeout_secs
>>>
>>> Seems file system related (hdd led is on).

If needed I could add trace. Sorry for double post Google phone mail is=
 by default HTML I expect now plain text.

Bastien


>>> My filesystems are ext4 over raid0 so add some cc
>>
>> Appears to be "dm" raid0 rather than "md" raid0 - so not my area.
>> May help to include dm-devel@redhat.com, and maybe include a
>description of
>> the dm configuration.  e.g. "dmsetup table" output.
>
>dmsetup  table
>VOL-ROOT: 0 195305472 linear 9:1 2048
>VOL-HOME: 0 1562501120 linear 9:1 195307520
>
>>
>> NeilBrown

--=20
Envoy=C3=A9 de mon t=C3=A9l=C3=A9phone Android avec K-9 Mail. Excusez l=
a bri=C3=A8vet=C3=A9.
