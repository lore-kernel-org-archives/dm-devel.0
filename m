From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: Can't create PVs on partitions
Date: Thu, 26 May 2005 15:20:01 +0530
Message-ID: <009201c561d8$49ca44b0$11051aac@pcp41116>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1117100748-16442-14"
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
To: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
Cc: "Christophe Varoqui (E-mail)" <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1117100748-16442-14
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

	I have a block driver "SampleDrv" which creates devices on sd devices.
	I want to use LVM2 on that SampleDrv devices.

 I changed settings of /etc/lvm/lvm.conf (type and filter entries) file and
its working fine for whole devices.

 But when i partitioned my SampleDrv devices , LVM2 is not scanning those
partition in /etc/lvm/.cache and

 hence i am unable to create PVs on partitioned SampleDrv devices.

 If any body can tell how this can be resolved, I will be very greatful.


Regards,
Shahid Shaikh.
 
 



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

------------=_1117100748-16442-14
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------------=_1117100748-16442-14--
