From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: RE: dm-devel Digest, Vol 19, Issue 1
Date: Fri, 2 Sep 2005 15:13:11 +0530
Message-ID: <006201c5afa2$bbef1da0$11051aac@pcp41116>
References: <20050901160007.6299F73886@hormel.redhat.com>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1125654614-29573-177"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050901160007.6299F73886@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1125654614-29573-177
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



Hi,

Probelm:

Whenever we create a partition on a scsi device, and do vgscan on that so
that it is reflected in /etc/lvm/.cache file, it shows newly created
partition only and not the whole device.

I observed this behaviour on AS4 UP1.
LVM2 version is lvm2-2.01.08-1.0.RHEL4.

Whereas on SLES9 SP1, whenever you do above scenario, it shows both
partition and whole device.

Is this because of any feature added to lvm2 in RHEL4.


Please help me out.

Warm Regards,
Shahid Shaikh.
" There are no shortcuts to any place worth going. "



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

------------=_1125654614-29573-177
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------------=_1125654614-29573-177--
