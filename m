From: "goggin, edward" <egoggin@emc.com>
Subject: How to avoid lots of read ios to passive paths of
	active-passive storage devices?
Date: Fri, 8 Jul 2005 00:21:21 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB50@SRMANNING.eng.emc.com>
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

How sould device scanning utilities like blkid, pvscan,
vgscan, and lvscan (others?) be made to avoid issuing
a significant number of read ios to passive paths of
active-passive storage devices?

Possibly they could be changed to use device specific
command interfaces like SCSI pass through ioctls to
read the native device paths in order to avoid sending
lots of ios down the passive paths to active-passive
storage devices?

This way they could parse the sense key, ASC, and ASCQ
returned via the SG_IO interface, see values like
"Not Ready, Manual Intervention Required" and avoid
sending subsequent reads to the same path.

Or should they be changed to scan the multipath devices
if they exist instead of the path specific devices?

While this isn't an issue now, it could become one later
when/if linux hosts are configured with hundreds/thousands
of passive paths.
