From: Roland Paterson-Jones <rolandpj@amazon.com>
Subject: Help/Info on basic snapshot for CoW
Date: Tue, 21 Nov 2006 17:56:09 +0200
Message-ID: <45632199.9000308@amazon.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi all

I am trying to use dm snapshots to provide copy-on-write (CoW) support 
using a static (read-only) origin which is to be shared by several CoW 
overlays.

So, I prepare a (sparse) loop-back image and device with the origin in 
/dev/loop0, and create an overlay onto a 'real' logical volume, using:

echo "0 $((152704*1024*1024/512)) snapshot /dev/loop0 
/dev/mapper/VolGroup_store_3 p 128" | dmsetup create store3_pref

This seems to work OK, and indeed if I recreate the same dm device after 
reboot or power cycle, I seem to recover the overlay changes.

So, where is the overlay mapping stored? I believe that this is known as 
the 'exception store', and I can see some stuff about it in the source, 
but where does a persistent overlay map end up?

Also, how is the overlay (snapshot) device used? Is there a one-to-one 
mapping of (logical device) block offsets onto the overlay (snapshot) 
device? If so, where does the overlay map fit in?

Lastly, how do I flush the overlay mapping? Suppose I have had quite 
enough of the (modified) snapshot and I want to revert to the original 
origin in a snapshot using the same overlay (snapshot) device. I notice 
empirically that if I 'dmsetup remove' then 'dmsetup create ... n ...', 
then 'dmsetup remove ...' once more, and finally 'dmsetup create ... p 
...', then I have a clean snapshot of the origin again. I'm guessing 
there's a better way ;)

Is this a sensible way to implement CoW? I realise that my use case is 
an inversion of the original intention of snapshots, where the origin 
was intended to be modified and the snapshot remained static (for 
back-up purposes). In my CoW usage, the origin remains static and I 
mutate several snapshots of the origin.

Thanks for any pointers
Roland
