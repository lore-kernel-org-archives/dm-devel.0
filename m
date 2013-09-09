From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Subject: Re: [3.10.7] Reproductible soft lockup, recover but freeze even the mouse
Date: Mon, 9 Sep 2013 12:48:15 +0200
Message-ID: <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
References: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com>
	<20130909194826.74d5df39@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130909194826.74d5df39@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
List-Id: dm-devel.ids

On Mon, Sep 9, 2013 at 11:48 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
>
>> Hi,
>>
>> I experiment a soft lockup. during 20 s I have no mouse, could not
>> switch back to console and so on.
>>
>> I achieve to get a backtrace by echo 15 >
>> /proc/sys/kernel/hung_task_timeout_secs
>>
>> Seems file system related (hdd led is on).
>>
>> My filesystems are ext4 over raid0 so add some cc
>
> Appears to be "dm" raid0 rather than "md" raid0 - so not my area.
> May help to include dm-devel@redhat.com, and maybe include a description of
> the dm configuration.  e.g. "dmsetup table" output.

dmsetup  table
VOL-ROOT: 0 195305472 linear 9:1 2048
VOL-HOME: 0 1562501120 linear 9:1 195307520

>
> NeilBrown
