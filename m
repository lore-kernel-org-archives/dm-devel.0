From: Stephen Beynon <lists@octopus-technologies.com>
Subject: dm mirror with failed device
Date: Sun, 7 Sep 2008 11:49:46 +0100
Message-ID: <200809071149.46888.lists@octopus-technologies.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
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


This is probably a stupid question, in which case I apologise in advance.

I am looking to set up a number of machines with internal disks mirrored onto 
an iscsi server.  I aim to provide resiliance against disk failures, and the 
iscsi server will be a handy single point to backup.

I set up the following test mirror.

# dmsetup status mirror
0 16777216 mirror 2 254:8 8:16 32768/32768 0 1 core
# dmsetup table mirror
0 16777216 mirror core 1 512 2 254:8 0 8:16 0

As a test I shutdown the iscsi server and continued writes to the mirror 
device.  As expected syslog recorded i/o errors on the iscsi lun, but writes 
to the mirror continued.  After waiting a few minutes I expected to see that 
parts of the mirror were out of sync, however dmsetup status gave exactly the 
same results as above.

When I restarted the iscsi server blocks started to be written to the iscsi 
server again, but the changes that happened during the iscsi server down time 
were never replicated.  Clearly this left the mirror in an inconsistent state 
with the only indication of problems being in syslog.

Is there any way I can configure dm-mirror to either mark the blocks as out of 
sync when a write fails, and re-try the write later ?

I am currently running Ubuntu gutsy on the client machines, so it does not 
have dmeventd, but from reading the docs it it not clear that dmeventd would 
help.

Regards

Stephen 
