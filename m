From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: md_component_detection = 1
Date: Tue, 15 Feb 2005 20:17:10 +0530
Message-ID: <000001c5136d$3b3502a0$11051aac@pcp41116>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1108478518-32660-196"
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Christophe Varoqui (E-mail)" <christophe.varoqui@free.fr>
Cc: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1108478518-32660-196
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline




Hello Chris,

    I have written a sample psuedo driver which is basically consolidating
multiple paths to LUNs.
So I need prevent SCSI devices from scanning.

I gone thro' lvm.conf and found out that md is doing the similar thing by
setting following value in lvm.conf

         md_component_detection = 1
this parameter, if set, prevents scanning of all the SCSI devices
contributed in the creation of md.

So is there any parameter in LVM2 or device mapper, setting or clearing
which can prevent scanning of SCSI devices used for my psuedo driver.
Obviously other than filtering it out.

Thanks and Regards,
Shahid Shaikh.
Software Engineer.



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

------------=_1108478518-32660-196
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
------------=_1108478518-32660-196--
