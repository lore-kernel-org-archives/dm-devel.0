From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: Discard support for dm-snap
Date: Thu, 02 Sep 2010 13:21:05 -0500
Message-ID: <4C7FEB11.8090903@filteredperception.org>
References: <4C7F5AE2.9020908@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C7F5AE2.9020908@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/02/2010 03:05 AM, Hannes Reinecke wrote:
> Hi all,
>
> now that we've got discard support in the block layer, are there plans
> to update dm-snap to actually implement discard?
> Looks like a valid addendum here; we could be freeing up unused blocks
> thus freeing up space.
> Especially helpful when using dm-snap to create a sparse device;
> cf
> http://www.mjmwired.net/kernel/Documentation/device-mapper/zero.txt
>
> Thoughts?

Here was my similar suggestion and the discussion with Mike that followed-

http://www.spinics.net/lists/dm-devel/msg11632.html

I still feel like there is a disconnect between my thinking and Mike's, 
as I think I have the same fundamental interest as you do Hannes.

I.e. a perfect example is a simple dm-snapshot used for a livecd root 
filesystem.  In that case, after boot, the user creates a new file in 
the rootfs, and that causes exception chunks (terminology?) to be 
created in the cow device of the dm-snapshot.  Then, at a later point, 
the user deletes that file.  It then seems 100% reasonable for the 
discard request to result in freeing the used resources in the cow 
device.  I see no semantic reason why that data need be kept around any 
more than it need be kept around on an SSD after a file is deleted.

Now, where I think the disconnect comes in, is that perhaps the majority 
use of snapshots in todays word is perhaps a snapshot-origin 
(terminology?) where the exception store (not quite a 'cow device'?) is 
not used to store the modified blocks, but instead, used to store the 
original blocks.  In _that_ case, things are different, perhaps more as 
Mike described them.

Now, I do understand that Mike is the person actually neck deep in all 
this code, so I could be completely misunderstanding the picture.  But 
I'm glad someone else also sees what I see here as far as potential 
benefit and use case.

-dmc

>
> Cheers,
>
> Hannes
