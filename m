From: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
Subject: Re: Re: grub 0.96 bug
Date: Tue, 22 Mar 2005 23:42:45 +0100
Message-ID: <42409F65.5090507@gmx.at>
References: <62b0912f05031606396a3a47db@mail.gmail.com>	
	<62b0912f050319145547c4a7db@mail.gmail.com>	
	<20050320163001.GB643@percy.comedia.it>	
	<62b0912f05032019262c009465@mail.gmail.com>	
	<62b0912f0503202121607bd38a@mail.gmail.com>	
	<62b0912f05032104052e78fd60@mail.gmail.com>	
	<62b0912f050321065558fc956@mail.gmail.com>
	<423F0F74.3030007@gmx.at>	
	<62b0912f050321235348c20525@mail.gmail.com>
	<42407227.2020402@gmx.at>
	<62b0912f0503221211c21d0ec@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f0503221211c21d0ec@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: bug-grub@gnu.org, dm-devel@redhat.com, ataraid-list@redhat.com
List-Id: dm-devel.ids

Molle Bestefich wrote:
>>That would make my life a lot easier! On the other hand, the most
>>straight forward thing to do would be to move the stage 1.5 to another
>>default sector. So you can not forget to set any option that ruins your
>>array if missing. Also there is no need to add some autodetection code
>>for hpt controllers then.
> 
> 
> One step ahead of me, you are.
> 
> I was just thinking of doing autodetection of HPT magic in GRUB.
> 
> The autodetection has a plus side too, though.
> It can detect other stuff that should not be touched (Windows/Veritas
> dynamic partition information comes to mind?) and not touch sectors
> based on what is actually there on a particular system.  Would perhaps
> save the implementor the pain of choosing once there's just too many
> reserved sectors and the stage1.5 loader wont fit.

The problem with the autodetection code is that if you want to play safe 
then you have to check the pci-id of the controller. Even if the BIOS of 
the controller supports RAID if you are picky enough to do this. You 
cannot rely on the contents of sector 9 alone since the disk may have 
been installed on a hpt controller and then moved to another system. In 
this case the signature is still intact and will get picked up by grub.
There are also other things you might want to consider, like MBR + 
loaders for disk encryption software that is also located somewhere in 
this area.
My opinion is that a higher default offset gets the job done. A 
configuration option helps the people who know what they are doing in 
weird corner cases. I would not like to add some autodetection that 
breaks things for some people and make things compilcated when something 
goes wrong.

But I have to admit that I am getting tired of this controller.

I wrote my HPT370 RAID support for kernel 2.2 based on MD.
I debugged and extended the HPT370 ataraid module.
I wrote a EVMS plugin for HPT370 RAID support.
I write bug-reports for dmraid HPT370 support.
I write bug-reports for HALd which has autodetection problems.

> 
> I think I've read that the stage1.5 loader is not really necessary in
> some cases, think I'll go doc-hunting.

I think you can also use the blocks of the stage 1.5 loader _in_ the 
filesystem if you specify the file instead of the (hd0)16+18 blocklist. 
But for doing things like that I hate lilo. ;)

> 
> 
>>>Or even better, dmraid could protect the metadata blocks by some magic
>>>flag to dm-mod.
>>>This isn't possible as is, is it?
>>
>>One can make any I/O to this block fail. But I would like something like
>>discarding any writes and only perform reads. "dd" backups would still
>>work then.
> 
> 
> Right.  And perhaps a user-definable flag to turn the protection on or off :-).
> Is it possible without adding new code to dm-mod?

No, you have to add code that treats write request different than read 
requests. Should not be too complicated though...

Greetings,
Wilfried
