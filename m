From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [dm-devel] Re: grub 0.96 bug
Date: Tue, 22 Mar 2005 08:53:15 +0100
Message-ID: <62b0912f050321235348c20525@mail.gmail.com>
References: <62b0912f05031606396a3a47db@mail.gmail.com>
	<62b0912f050318142923419b20@mail.gmail.com>
	<62b0912f05031914513909bcfb@mail.gmail.com>
	<62b0912f050319145547c4a7db@mail.gmail.com>
	<20050320163001.GB643@percy.comedia.it>
	<62b0912f05032019262c009465@mail.gmail.com>
	<62b0912f0503202121607bd38a@mail.gmail.com>
	<62b0912f05032104052e78fd60@mail.gmail.com>
	<62b0912f050321065558fc956@mail.gmail.com> <423F0F74.3030007@gmx.at>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	Promise Fasttrak / Highpoint 370 driver discussion <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <423F0F74.3030007@gmx.at>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
Cc: bug-grub@gnu.org, dm-devel@redhat.com, ataraid-list@redhat.com
List-Id: dm-devel.ids

Wilfried Weissmann wrote:
>> It must be severely broken; since if it just sticked to writing to the
>> device I pointed it at (hpt37x_ehgjaggaf) which is a RAID0 "virtual
>> disk" / whatever, it should never be able to overwrite metadata out on
>> the physical disk.
> 
> HPT desided to make the metadata accessable from the virtual disk. Just
> look at sector 9 of a working array and enjoy the show...

That's an awful decision.

> Grub is fine. At least the version that I am using. You have to do some
> tricks to get grub running on the old hpt controllers (I think the new
> ones are better, but I cannot tell for sure).
> 
> Just copy the stage 1.5 reiserfs module to sector 16 instead of sector 8
> which is the grub default that destroys the metadata in case of a hpt.
> [explanation snipped]

Thanks for the explanation!
There should be an option in the GRUB configuration to do this, so
that the RAID won't get overwritten the next time I do a grub-install,
I think.

Or even better, dmraid could protect the metadata blocks by some magic
flag to dm-mod.
This isn't possible as is, is it?


>> Gerte has a GRUB example on his page where he does setup (hd0,5)
>> instead of setup (hd0), perhaps that's how it's meant to work.
> 
> But you still need a MBR that invokes the loader in (hd0,5) then!

Hrm, I think LILO has an option to slam out a generic MBR that does
something like that?
But perhaps it requires an active flag on (hd0,5), which violates the specs..
