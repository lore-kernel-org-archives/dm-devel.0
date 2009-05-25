From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks data integrity
Date: Mon, 25 May 2009 14:22:23 +0200
Message-ID: <87my91qsn4.fsf@frosties.localdomain>
References: <20090521161317.GU1376@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090521161317.GU1376@blitiri.com.ar> (Alberto Bertogli's
	message of "Thu, 21 May 2009 13:13:17 -0300")
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Alberto Bertogli <albertito@blitiri.com.ar> writes:

> Hi!
>
> I'm writing this device mapper target that stores checksums on writes and
> verifies them on reads.
>
> It's not widely tested, but you can run mke2fs on it and do basic file
> operations. The to-do list is still large, and most of it can be found within
> the code.
>
> To test it, you will need to format the device using the (very rough) attached
> tool, and then create the dm device with something like:
>
> 	echo 0 $SIZE csum $REALDEVICE 0 | dmsetup create $NAME
>
>
> I think it can be useful for people who want to detect data corruption and are
> either using the block layer directly or a filesystem that doesn't check data
> integrity (which are most, if not all, of the popular ones today). Maybe it
> could also be used for testing the bio-integrity extensions, although at the
> moment it's completely independent and I haven't looked much, but it's on my
> to-do list.
>
> It does NOT pretend to be useful for consistency checks for security purposes.
> Use something else if you do not want someone evil tampering with your data.
>
>
> Comments are obviously welcome. There are also some questions embedded in the
> code, if anyone cares to answer any of them, I'd really appreciate it.
>
> Thanks a lot,
> 		Alberto

How does that behave on crashes? Will checksums be out of sync with data?
Will pending blocks recalculate their checksum?

MfG
        Goswin
