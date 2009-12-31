From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: dm multipath kernel driver version too old - 2.6.32
Date: Thu, 31 Dec 2009 02:59:26 -0500
Message-ID: <1262246366.8333.13.camel@jaspav.ssiservices.biz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello, all.  We are attempting to upgrade our kernel on our VServer
hosts from 2.6.28 to 2.6.32.1.  After some initial grief, we thought we
were successful until multipath kicked in and we received an error
message:

DM multipath kernel driver version too old

In the RAID and LVM section of our kernel configuration, we have enabled
Multipath I/O support.  We have then created modules for Multipath
target and both I/O Path Selectors (in-flight I/Os and service time).

We are running fully patched CentOS 5.4.  What have we done wrong?
Thanks - John
