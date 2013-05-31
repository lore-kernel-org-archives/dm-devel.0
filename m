From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: DM-Verity Tool
Date: Fri, 31 May 2013 08:31:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1305310828100.9885@file.rdu.redhat.com>
References: <22416.192.168.200.1.1369149109.squirrel@gesmail.globaledgesoft.com>
	<519CA6F0.3000309@redhat.com> <519CF66C.8010808@gmail.com>   
	<20204.192.168.200.1.1369291275.squirrel@gesmail.globaledgesoft.com>
	<519E806C.1050903@gmail.com>
	<7641.192.168.200.1.1369931315.squirrel@gesmail.globaledgesoft.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7641.192.168.200.1.1369931315.squirrel@gesmail.globaledgesoft.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: pavankumar.p@globaledgesoft.com
Cc: device-mapper development <dm-devel@redhat.com>, Marian Csontos <mcsontos@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids



On Thu, 30 May 2013, pavankumar.p@globaledgesoft.com wrote:

> Hi All,
>    Thanks for your answers to previous questions. I have some more doubts
> regarding DM-Verity please clarify it.
> 
> 
> 1. When dm-verity validation fails, do we lose access to the file?  And how
> about accessing the rest of the filesystem?

You lose access to the affected files, but the rest of the filesystem is 
still accessible.

> 2. Is there any recovery mechanism for a validation failure?

No.

> 3. How do we update a DM-Verity filesystem?  Can it be done on a file basis?
> I believe that dm-verity works on the blocks & not on the file system, is
> that true?

You don't update it. You create the filesystems, then calculate dm-verity 
checksums and then mount it read only.

Yes, dm-verity works on blocks.

> 4. Can we use dm-verity for any filesystem (say UBIFS)? Is there any
> restriction on filesystem?

You can use it for any filesystem.

> 5. How to update DM-Veirty device without removing device mapping. I tried
> mounting the dm-verity target but it fails

You can't update it.

If you want to update it, you need to unmount the filesystem, unload the 
dm-verity target, mount the underlying device read-write, make changes, 
unmount it, recreate checksums with veritysetup, load the dm-verity target 
and mount it read only.

> Thanks in advance,
> Pavan Kumar P

Mikulas
