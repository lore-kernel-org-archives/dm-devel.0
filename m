From: Antonello Piemonte <apiemont@eso.org>
Subject: raw devices with multipathing and SUN Storedge 3511
Date: Tue, 8 Aug 2006 11:00:50 +0200
Message-ID: <200608081100.50317.apiemont@eso.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello

I have two questions:

1) is it ok to use raw devices with device mapper and multipathing?

I have the following simple setup under RHEL4.3 (x86_64), e.g. one LUN
exported from a SUNStoredge 3511 directly to the host which has two HBA,
therefore I see the same LUN twice, as sdc and sdd:

# multipath -l
mpath2 (3600c0ff00000000009279811b3f44a00)
[size=1862 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:0:0     sdc 8:32  [active][ready]
 \_ 2:0:0:0     sdd 8:48  [active][ready]

I made 2 partitions on the mpath2 device and used kpartx to make is 
visible to device mapper, e.g.

# ll /dev/mpath/
total 0
lrwxrwxrwx  1 root root 7 Aug  7 17:50 mpath2 -> ../dm-0
lrwxrwxrwx  1 root root 7 Aug  8 10:32 mpath2p1 -> ../dm-1
lrwxrwxrwx  1 root root 7 Aug  8 10:32 mpath2p2 -> ../dm-2

if I then proceed to asssigne raw devices, it seems to work
# raw /dev/raw/raw2 /dev/dm-2
/dev/raw/raw2:  bound to major 253, minor 2
# raw -qa
/dev/raw/raw2:  bound to major 253, minor 2

is then suitable to use /dev/raw/raw2 with databases
(namely sybase ASE 15)?

2) second question: is the SUN Storedge 3511 an active/active array and if 
not, do I need to worry about hardware handlers specific for it?

many thanks for your help!
antonello
