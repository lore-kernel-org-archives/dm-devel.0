From: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
Subject: Re: Re: grub 0.96 bug
Date: Tue, 22 Mar 2005 20:29:43 +0100
Message-ID: <42407227.2020402@gmx.at>
References: <62b0912f05031606396a3a47db@mail.gmail.com>	
	<62b0912f050318142923419b20@mail.gmail.com>	
	<62b0912f05031914513909bcfb@mail.gmail.com>	
	<62b0912f050319145547c4a7db@mail.gmail.com>	
	<20050320163001.GB643@percy.comedia.it>	
	<62b0912f05032019262c009465@mail.gmail.com>	
	<62b0912f0503202121607bd38a@mail.gmail.com>	
	<62b0912f05032104052e78fd60@mail.gmail.com>	
	<62b0912f050321065558fc956@mail.gmail.com>
	<423F0F74.3030007@gmx.at>
	<62b0912f050321235348c20525@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f050321235348c20525@mail.gmail.com>
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
> Wilfried Weissmann wrote:
> 
>>>It must be severely broken; since if it just sticked to writing to the
>>>device I pointed it at (hpt37x_ehgjaggaf) which is a RAID0 "virtual
>>>disk" / whatever, it should never be able to overwrite metadata out on
>>>the physical disk.
>>
>>HPT desided to make the metadata accessable from the virtual disk. Just
>>look at sector 9 of a working array and enjoy the show...
> 
> 
> That's an awful decision.

It is, isn't it?

>>Grub is fine. At least the version that I am using. You have to do some
>>tricks to get grub running on the old hpt controllers (I think the new
>>ones are better, but I cannot tell for sure).
>>
>>Just copy the stage 1.5 reiserfs module to sector 16 instead of sector 8
>>which is the grub default that destroys the metadata in case of a hpt.
>>[explanation snipped]
> 
> 
> Thanks for the explanation!
> There should be an option in the GRUB configuration to do this, so
> that the RAID won't get overwritten the next time I do a grub-install,
> I think.

That would make my life a lot easier! On the other hand, the most 
straight forward thing to do would be to move the stage 1.5 to another 
default sector. So you can not forget to set any option that ruins your 
array if missing. Also there is no need to add some autodetection code 
for hpt controllers then.

> 
> Or even better, dmraid could protect the metadata blocks by some magic
> flag to dm-mod.
> This isn't possible as is, is it?

One can make any I/O to this block fail. But I would like something like 
discarding any writes and only perform reads. "dd" backups would still 
work then.

Greetings,
Wilfried
