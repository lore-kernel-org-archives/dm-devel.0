From: "goggin, edward" <egoggin@emc.com>
Subject: How is the multipath pg policy group-by-nodename any
	different th an the failover policy ...
Date: Wed, 27 Apr 2005 15:42:11 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A950@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

... especially for SCSI paths where the multipathing is designed to be
indifferent to both transport and network route between SCSI initiator
and SCSI target?  Don't they both result in one path per path group
for a given SCSI logical unit as long as the node name is defined to
be the "host number/channel number/target id" triple setup by
sysfs_devinfo in libmultipath/discovery.c?

BTW, this is an example of the SCSI affinity I was mentioning in my
previous submission.
