From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Removing a failed device from LVM2/DM
Date: Tue, 01 Sep 2009 14:42:19 -0400
Message-ID: <1251830539.5459.135.camel@cail>
References: <1251731770.6817.31.camel@cail> <1251821775.5459.21.camel@cail>
	<20090901162537.GA15197@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090901162537.GA15197@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2009-09-01 at 09:25 -0700, malahal@us.ibm.com wrote:
> Alan D. Brunelle [Alan.Brunelle@hp.com] wrote:
> > The vgreduce --removemissing helped a lot, thanks! But I still remain
> > with all these error messages about the removed device. I tried
> > everything again - using devices sda, sdab & sdad (failing sdab), and
> > now every time I issue an LVM2/DM command I get all sorts of error
> > messages about /dev/sdab failures. The 'pvs -a -o +devices' command not
> > only puts out a ton - but also has a messed up display about the devices
> > left working:
> > 
> > # pvs -a -o +devices
> >   /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
> >   Volume group name (null) has invalid characters
> >   Skipping volume group (null)
> > ...
> >   Volume group name (null) has invalid characters
> >   Skipping volume group (null)
> >   Volume group name (null) has invalid characters
> >   Skipping volume group (null)
> >   PV         VG   Fmt  Attr PSize   PFree   Devices    
> >   /dev/sda   vg   lvm2 a-   271.34G 239.34G /dev/sda(0)
> >   /dev/sda   vg   lvm2 a-   271.34G 239.34G            
> >   /dev/sda   vg   lvm2 a-   271.34G 239.34G            
> >   /dev/sdad  vg   lvm2 a-   271.34G 271.34G            
> >   /dev/sdad  vg   lvm2 a-   271.34G 271.34G
> > 
> > Why the 5 lines for 2 devices?
> > 
> > I've attached a log of commands & results.
> > 
> > I have tried adding in "/dev/sdab" as being filtered out
> > in /etc/lvm/lvm.conf but that doesn't change things. Here is first part
> > of the output from lvm dumpconfig:
> > 
> > # lvm dumpconfig
> >   devices {
> >   	dir="/dev"
> >   	scan="/dev"
> >   	preferred_names=[]
> >   	filter=["r|sdab|", "a/.*/"]
> >   	cache_dir="/etc/lvm/cache"
> >   	cache_file_prefix=""
> >   	write_cache_state=1
> >   	sysfs_scan=1
> >   	md_component_detection=1
> >   	md_chunk_alignment=1
> >   	ignore_suspended_devices=0
> >   }
> > 
> > but commands still error on /dev/sdab:
> 
> Did you remove the cache or ran vgscan?
> /etc/lvm/lvm.conf recommends running 'vgscan -vvvv' to see what is going
> on with filters.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

#device/dev-cache.c:245         /dev/sdab: Already in device cache

How does one remove the cache? I tried remove /etc/lvm/cache/.cache &
running vgscan, but no difference.

Alan
