From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: md_component_detection = 1
Date: Tue, 15 Feb 2005 22:20:19 +0100
Message-ID: <42126793.4030407@free.fr>
References: <000001c5136d$3b3502a0$11051aac@pcp41116>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <000001c5136d$3b3502a0$11051aac@pcp41116>
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

All I can comment is LVM over the multipath implementation from 
Alasdair, RedHat.

For that, you need to set in /etc/lvm/lvm.conf :

    scan = [ "/dev", "/dev/mapper" ]  (you may or may not need this one, 
depending on your distro)
    filter = [ "r/sd.*/", "a/.*/" ]
    types = [ "device-mapper", 254 ]

Here the 254 may vary depending on your setup. To find out for your 
case, do :

[root@cl039 root]# grep mapper /proc/devices
254 device-mapper

Then everything should work as expected :

[root@cl039 root]# multipath -l -v2
red (3600a0b80000b596a000003113d9c5381)
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 4:0:3:9 sdan 66:112  [ready ][active]
  \_ 5:0:1:9 sdbh 67:176  [ready ][active]
\_ round-robin 0 [enabled]
  \_ 5:0:3:9 sdcb 68:240  [ready ][active]
  \_ 4:0:1:9 sdt  65:48   [ready ][active]

[root@cl039 root]# pvcreate /dev/mapper/red
  Physical volume "/dev/mapper/red" successfully created

[root@cl039 root]# pvscan
  PV /dev/mapper/red         lvm2 [33.86 GB]
  Total: 1 [33.86 GB] / in use: 0 [0   ] / in no VG: 1 [33.86 GB]


That's the more precise info I can share onn the subject.
Now your on your own.

Regards,
cvaroqui


shahid shaikh wrote:

>
>Hello Chris,
>
>    I have written a sample psuedo driver which is basically consolidating
>multiple paths to LUNs.
>So I need prevent SCSI devices from scanning.
>
>I gone thro' lvm.conf and found out that md is doing the similar thing by
>setting following value in lvm.conf
>
>         md_component_detection = 1
>this parameter, if set, prevents scanning of all the SCSI devices
>contributed in the creation of md.
>
>So is there any parameter in LVM2 or device mapper, setting or clearing
>which can prevent scanning of SCSI devices used for my psuedo driver.
>Obviously other than filtering it out.
>
>Thanks and Regards,
>Shahid Shaikh.
>Software Engineer.
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
