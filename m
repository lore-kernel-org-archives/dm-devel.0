From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: RE: LVM2- cant create a Volume Group over a multipath LUN
Date: Tue, 15 Feb 2005 11:51:20 +0530
Message-ID: <012b01c51326$9121e5d0$11051aac@pcp41116>
References: <42119087.9080309@free.fr>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1108448163-11810-106"
In-Reply-To: <42119087.9080309@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Christophe Varoqui' <christophe.varoqui@free.fr>
Cc: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1108448163-11810-106
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

this way then i cant achieve multipathing feature tooo....

Thanks and Regards, 
Shahid Shaikh. 
Software Engineer. 
Patni Computer Systems Ltd. 
Vashi, Navi Mumbai. 
Extn. 344 
Mobile : +91-9820986513 


-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]
Sent: Tuesday, February 15, 2005 11:33 AM
To: shahid.shaikh@patni.com
Cc: Dm-Devel (E-mail)
Subject: Re: LVM2- cant create a Volume Group over a multipath LUN


exclude your paths from the scan :
filter = [ "r/sd.*/" ]

shahid shaikh wrote:

> Hi chris,
> I have lvm2 and device-mapper which comes bundled with SLES9 and 
> nothing else.
> I have storage controller which has two path my storage device.
> I have 3 LUNs.
> I can see 6 devices for those 3 LUNs.
> so /dev/sda and/dev/sdd pointing to LUN 0
> similarly   /dev/sdb and /dev/sde to LUN 1
> and          /dev/sdc and /dev/sdf to LUN 2
>  
> now when I do pvcreate on ono these devices say /dev/sdb it succeeds.
> but when i do pvscan it shows me /dev/sde is as physical device.
>  
> now when i try to do vgcreate vg01 /dev/sdb or sde
> it succeeds but when i do vgscan    it doesnt show me anything.
> What should I do now so that i can see vg in vgscan.
> Thus kindly help me to create VG on multipath LUN.
>
> Thanks and Regards,
> Shahid Shaikh.
> Software Engineer.
> Patni Computer Systems Ltd.
> Vashi, Navi Mumbai.
> Extn. 344
> Mobile : +91-9820986513
>
>  
>
> http://www.patni.com
> World-Wide Partnerships. World-Class Solutions.
> _____________________________________________________________________
>
> This e-mail message may contain proprietary, confidential or legally 
> privileged information for the sole use of the person or entity to 
> whom this message was originally addressed. Any review, e-transmission 
> dissemination or other use of or taking of any action in reliance upon 
> this information by persons or entities other than the intended 
> recipient is prohibited. If you have received this e-mail in error 
> kindly delete this e-mail from your records. If it appears that this 
> mail has been forwarded to you without proper authority, please notify 
> us immediately at netadmin@patni.com and delete this mail.
> _____________________________________________________________________ 




http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1108448163-11810-106
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
------------=_1108448163-11810-106--
