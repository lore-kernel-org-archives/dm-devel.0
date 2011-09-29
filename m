From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] dm: verity target
Date: Wed, 28 Sep 2011 21:07:51 -0400
Message-ID: <20099.50407.346360.216442@quad.stoffel.home>
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
	<CABqD9hYWK2czEKN87xDu7YPbRcp9xrumJ5PZ8aQTzBLafrnBMw@mail.gmail.com>
	<21505.1317245414@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21505.1317245414@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Will Drewry <wad@chromium.org>, Mandeep Singh Baines <msb@chromium.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "Valdis" == Valdis Kletnieks <Valdis.Kletnieks@vt.edu> writes:

Valdis> On Tue, 27 Sep 2011 14:02:05 CDT, Will Drewry said:
>> I was just curious if there is any interest in pulling this change, or
>> if not, if there is any particular set of concerns, fixes, etc.

Valdis> Out of curiosity, how much of the stack does this end up eating?  My root
Valdis> filesystem is already ext4 on an LVM partition that's on a LUKS/dm-crypt
Valdis> partition on a hard drive, and I'm sure somebody out there will have used xfs
Valdis> instead - and then exported it via NFS or something. Are we going to get weird
Valdis> stack overflows if people throw dm-verity into this sort of mix?

>> realize it's not a small amount of code to digest (though it is
>> smaller than the post from last year[1]).   Would re-posting with an
>> added blob explaining the name be useful,

Valdis> Probably will need it to be merged, unless you set up an
Valdis> auto-reply that says "Patch rejected, 'verity' is *not* a typo
Valdis> for 'verify'" ;)

God, I've been reading this as veriFy all along.  I think your name
stinks because it's too close to Verify, and too obscure otherwise.

John
