From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipathd init script errors
Date: Mon, 13 Apr 2009 14:27:15 -0500
Message-ID: <20090413192715.GG15911@ether.msp.redhat.com>
References: <1239620726.30476.3.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1239620726.30476.3.camel@jaspav.missionsit.net.missionsit.net>
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

On Mon, Apr 13, 2009 at 07:05:25AM -0400, John A. Sullivan III wrote:
> Hello, all.  Whenever we stop multipathd, we get the following errors:
> 
> [root@kvm01 sysconfig]# service multipathd stop
> /etc/init.d/multipathd: line 32: cd: HOME not set
> /etc/init.d/multipathd: line 50: read: read error: 0: Is a directory
> 
> 
> When we looked at the init script, it appears to be a problem with the
> parameters passed to the teardown_slaves function.  We put a little echo
> statement in to tell us what was being passed as ${1} since the first
> line of the function and the one which seems to be causing the grief is
> "cd ${1}"
> 
> We got:
> [root@kvm01 init.d]# service multipathd stop
> /sys/block/dm-0
> /sys/block/md1
> /sys/block/sda/sda2
> 
> /etc/init.d/multipathd: line 33: cd: HOME not set
> /etc/init.d/multipathd: line 51: read: read error: 0: Is a directory
> 
> Any idea how we fix this? Thanks - John

Here is a patch to the source code. You need to apply this to
/etc/init.d/multipathd.  This fix is going into RHEL 5.4 and will be
in the next 5.3.z package.

-Ben

Index: multipath-tools/multipathd/multipathd.init.redhat
===================================================================
RCS file: /cvs/dm/multipath-tools/multipathd/multipathd.init.redhat,v
retrieving revision 1.2.4.3
retrieving revision 1.2.4.4
diff -u -r1.2.4.3 -r1.2.4.4
--- multipath-tools/multipathd/multipathd.init.redhat	28 Aug 2008 19:22:33 -0000	1.2.4.3
+++ multipath-tools/multipathd/multipathd.init.redhat	6 Apr 2009 16:50:44 -0000	1.2.4.4
@@ -29,6 +29,7 @@
 
 teardown_slaves()
 {
+pwd=`pwd`
 cd $1; 
 if [ -d "slaves" ]; then
 for slave in slaves/*;
@@ -54,6 +55,7 @@
 			exit 1
 		fi
 fi
+cd $pwd
 }
 
 #
