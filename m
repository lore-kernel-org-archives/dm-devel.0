From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: LVM Multipathing
Date: Sun, 13 Feb 2005 11:28:32 +0100
Message-ID: <420F2BD0.4020707@free.fr>
References: <000001c5119d$7dfb5c50$11051aac@pcp41116>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <000001c5119d$7dfb5c50$11051aac@pcp41116>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: shahid.shaikh@patni.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

This is documented in the multipath-tools' FAQ.
In lvm2.conf, you need to exclude the paths from the scaning, and allow 
DM devices to be scaned.

regards,
cvaroqui

shahid shaikh wrote:

>Hi,
>
>I am trying to test multipathing on lvm2.
>
>Configuration that i am using is as below:
>
>OS                     : SLES9 ( kernel 2.6.5)
>lvm                     : lvm2-2.00.15-0.3
>multipath-tools    : multipath-tools-0.2.1
>udev                   : udev-021-36.32
>sysfs                  : sblim-cmpi-sysfs-1.1.5-0.2
>hotplug               : hotplug-0.44-32.21 and hotplugctl-0.08-264.1
>device-mapper     : device-mapper-1.00.09-17.5
>
>I tried following things :
>
>When I dont have multipaths for LUNs:
>1) I tried to create PVs on LUNs using pvcreate
>2) Then VGs using above PVs by command vgcreate
>3) Then I have created some LVs on VGs.
>4) I also fire some I/O on these LVs.
>All aboe commands worked succesfully reflecting changes in pvscan, vgscan
>and lvscan.
>
>When I have multiplepaths to LUNs:
>I tried to create PV on one of the device but on doing pvscan it shows me
>some other device.
>    e.g  My LUN no 5 has for paths so I can see these four paths as
>/dev/sdb, /dev/sdg, /dev/sdl and /dev/sdq.
>          then i did following
>	   linux# pvcreate /dev/sdb
>	   /dev/sdb successfully created
>         linux# pvscan
>	 	Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdb not
>/dev/sdq
>		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdg not
>/dev/sdq
>  		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdl not
>/dev/sdq
> 		PV /dev/sdq    VG vg01   lvm2 [1.00 GB / 972.00 MB free]
>  		Total: 1 [1.00 GB] / in use: 1 [1.00 GB] / in no VG: 0 [0   ]
>
>	  linux# vgcreate vg01
>		succesfully created
>
>	  linux# vgscan
> 		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdb not
>/dev/sdq
>		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdg not
>/dev/sdq
>  		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdl not
>/dev/sdq
>
> I tried the same thing with all permutations but i couldnt create a volume
>group.
>
> I also have  multipath-tools-0.3.9 and  multipath-tools-0.4.2.
> But I am not sure whether they will compatible with kernel 2.6.5.
>
>If you can help me in this scenario I will be thankfull to you.
>Please let me know the steps through which I can achieve multipathing on my
>configuration.
>
>Thanks and Regards,
>Shahid Shaikh.
>
>
>
>http://www.patni.com
>World-Wide Partnerships. World-Class Solutions.
>_____________________________________________________________________
>
>This e-mail message may contain proprietary, confidential or legally
>privileged information for the sole use of the person or entity to
>whom this message was originally addressed. Any review, e-transmission
>dissemination or other use of or taking of any action in reliance upon
>this information by persons or entities other than the intended
>recipient is prohibited. If you have received this e-mail in error
>kindly delete  this e-mail from your records. If it appears that this
>mail has been forwarded to you without proper authority, please notify
>us immediately at netadmin@patni.com and delete this mail. 
>_____________________________________________________________________
>  
>
>------------------------------------------------------------------------
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
