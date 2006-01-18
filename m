From: Administrator <admin@photoresearchers.com>
Subject: current status of mirroring in devel cycle?
Date: Wed, 18 Jan 2006 14:05:46 -0500
Message-ID: <43CE918A.10805@photoresearchers.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm wondering if anyone can give me some insight into the current status of 
mirroring in the development cycle.  Based on the recent discussion on this list 
and the outstanding bugs in bugzilla, it appears that the much-appreciated 
effort is largely being directed at snapshots and multipath at the moment.

However I noticed this message in the RHEL4 U3 beta announcement:

 > ** Please note that although the beta release notes describe
 > ** LVM mirroring support, this feature will not be included in
 > ** this Update.

What does that mean in terms of functionality?  For example, I have a RHEL4 
server from which I'm itching to offline one of its dm devices for 
maintenance/repair/upgrade.  Ideally I'd like to use pvmove to shift its data 
onto other available PVs; with backups available I'm not sure I am as concerned 
with "supported" so much as "stable".  Will this be possible in RHEL4 U3, or 
must I modify it with upstream patches or use a more recent 2.6 kernel?  Or is 
this kind of operation still considered unstable such that manual coying on the 
filesystem level is still recommended?

Thanks,
Brian
