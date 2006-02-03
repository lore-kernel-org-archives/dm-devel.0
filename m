From: David James <david.james@morris.com>
Subject: Multipath unable to see drives
Date: Fri, 03 Feb 2006 09:54:12 -0500
Message-ID: <43E36E94.1040902@morris.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I am trying to setup multipathing on a RHEL4 U2 server but when ever I
run multipath -v2 I get:

# multipath -v2
error calling out /sbin/scsi_id -g -u -s /block/sda

and when I run multipath -v3 I get:

# multipath -v3
load path identifiers cache
ux_socket_connect error
#
# all paths in cache :
#
dm-0 blacklisted
dm-1 blacklisted
dm-2 blacklisted
dm-3 blacklisted
dm-4 blacklisted
dm-5 blacklisted
dm-6 blacklisted
fd0 blacklisted
hda blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
path sda not found in pathvec

===== path info sda (mask 0x1f) =====
bus = 1
dev_t = 8:0
size = 28452960
vendor = HP     
product = OPEN-E         
rev = 2113
h:b:t:l = 0:0:0:0
tgt_node_name = 0x50060e8003c38913
serial = 50057
path checker = tur (controler setting)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
error calling out /sbin/scsi_id -g -u -s /block/sda
uid =  (callout)
#
# all paths :
#
  0:0:0:0 sda 8:0  [ready] HP      /OPEN-E          /2113


I have looked all over the dm-devel mailing list and google and can't
find any hints or tips.  Any help would be greatly appreciated.

-David James
