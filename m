From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: read-ahead in lvcreate
Date: Thu, 3 Mar 2005 20:24:48 +0530
Message-ID: <00a101c52000$f2ce43a0$11051aac@pcp41116>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1109861394-15001-111"
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

------------=_1109861394-15001-111
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

 I was going through the code of Device Mapper and I found that it doesnt
allow readahead option but read and write.

	Then I tried to use readahead in lvcreate but it gives error.

	If someone can explain this scenario and answer to my following queries i
will be greatfull.

	1) Can we use readahead option of lvcreate?
	2) If yes, will it effect readahed of scsi?
	3) If no, then why they have provided this option in lvcreate?



Thanks and Regards,
Shahid Shaikh.
Software Engineer.
Patni Computer Systems Ltd.





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

------------=_1109861394-15001-111
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------------=_1109861394-15001-111--
