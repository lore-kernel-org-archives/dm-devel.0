From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: multipathd init script errors
Date: Mon, 13 Apr 2009 07:05:25 -0400
Message-ID: <1239620726.30476.3.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello, all.  Whenever we stop multipathd, we get the following errors:

[root@kvm01 sysconfig]# service multipathd stop
/etc/init.d/multipathd: line 32: cd: HOME not set
/etc/init.d/multipathd: line 50: read: read error: 0: Is a directory


When we looked at the init script, it appears to be a problem with the
parameters passed to the teardown_slaves function.  We put a little echo
statement in to tell us what was being passed as ${1} since the first
line of the function and the one which seems to be causing the grief is
"cd ${1}"

We got:
[root@kvm01 init.d]# service multipathd stop
/sys/block/dm-0
/sys/block/md1
/sys/block/sda/sda2

/etc/init.d/multipathd: line 33: cd: HOME not set
/etc/init.d/multipathd: line 51: read: read error: 0: Is a directory

Any idea how we fix this? Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
