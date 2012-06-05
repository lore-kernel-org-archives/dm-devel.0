From: Andi Kleen <andi@firstfloor.org>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Tue, 05 Jun 2012 16:37:38 -0700
Message-ID: <m2aa0hjpod.fsf@firstfloor.org>
References: <471046920.20120604234941@eikelenboom.it>
	<20120605000356.GM29466@outflux.net>
	<1018371644.20120605224154@eikelenboom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1018371644.20120605224154@eikelenboom.it> (Sander Eikelenboom's
	message of "Tue, 5 Jun 2012 22:41:54 +0200")
Sender: linux-ext4-owner@vger.kernel.org
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Kees Cook <keescook@chromium.org>, Ted Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Sander Eikelenboom <linux@eikelenboom.it> writes:
>
> Hmm that seems consistent with this report which mentions 3.1.5 as last working kernel:
> http://comments.gmane.org/gmane.comp.file-systems.ext4/30575
>
> So somehow this only effects ext4 on DM (it's THE common factor in all reports) and fsck seems incapable of seeing the error (and thus repair it.)

I have a system that throws this error all the time and it's not using
DM.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
