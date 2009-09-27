From: Oren Held <oren@held.org.il>
Subject: RH init.d/multipathd refuses stop
Date: Sun, 27 Sep 2009 11:49:02 +0200
Message-ID: <200909271149.02712.oren@held.org.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
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

Hello,

On July 2008, a patch was added to multipathd init script that prevents the 
'stop' action if the root device is multipathed. It is described in BZ 
#456228. The patch is redhat-only, and isn't found in the upstream git.

I believe that as a general rule, we should let the sysadmin stop/restart her 
system services, in all cases that do not pose risk to the system. AFAIK, 
stopping multipathd does not pose risk in most cases, even when root is 
multipathed.

I've found myself needing to restart/stop multipathd on some cases, be it to 
fix a problem which reload didn't fix (i.e. remap everything from scratch) or 
put multipathed in debug mode, and not doing it through the init script 
doesn't seem right.

Can anybody shed light on the reason why it is dangerous to allow the sysadmin 
to manually restart or stop the service?
Is it iSCSI-only? should we really prevent stop also on the more common, 
FC/SATA cases?

Thanks,
Oren Held
