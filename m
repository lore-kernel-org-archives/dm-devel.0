From: Spelic <spelic@shiftmail.org>
Subject: Re: [NOTES] thinp zeroing
Date: Wed, 22 Feb 2012 17:30:04 +0100
Message-ID: <4F45180C.8030801@shiftmail.org>
References: <20120222141442.GA28145@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <20120222141442.GA28145@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, thornber@redhat.com
List-Id: dm-devel.ids

On 02/22/12 15:14, Joe Thornber wrote:
> * Requirements
>
>    There are two distinct requirements for zeroing applicable to the
>    thin-provisioning target:
>
>    - Avoid data leaks (DATA_LEAK)
>
> * Implementing DATA_LEAK
>
>
> * Implementing ERASE
>
> ** Erase on deallocation
>
>
> ** Erasing from userland.
>
> ** Crash recovery
>
> ** Discards
>
>

Hello
thanks for all your hard work regarding thinp

I was thinking: why don't you implement a bitmap that takes care of 
emulating the discard functionality?

This would take care of all your issues above, and also be great for a 
lot of use cases even outside thinp (*).

Every read would first hit the bitmap; if the bitmap says that the 
region has been discarded, thinp would return zeroes to the requestor.

When a discard comes, you first set the bits in the 
discard-emulation-bitmap, and then also pass the discard to layers 
below. Passing the discard below has no user-visible effects (because 
discard is already implemented in thinp) however it is still 
advantageous to pass it to lower layers because there might be SSDs 
below thinp which can benefit from the discard.

I suggest a bitmap of 4kbytes / bit, and then if a discard comes that is 
not 4K aligned (that would be a mistake of the above layers, at least a 
"performance" mistake), you set the bitmaps only for the bits which are 
completely covered by the discard, and then you are left with at most 
two misaligned edges one at the beginning and one at the end of the 
discard region, and for those you will need to write zeroes to the 
layers below. So in the worst case you need to set a few bits and then 
perform two small writes of zeroes, but in most cases you just set a few 
bits.

(*) remember that most MD Raid levels do not pass discards below, so we 
-raid users- cannot really see zeroes where discard has been triggered. 
That's a problem when we want to backup a virtual machine disk image (DM 
volume) from the outside: non-zeroes don't compress well; it's like we 
backup deleted files everytime.
