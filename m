From: "goggin, edward" <egoggin@emc.com>
Subject: multipath affinity to SCSI
Date: Wed, 27 Apr 2005 13:00:51 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A94C@SRMANNING.eng.emc.com>
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

Has anyone tried multipathing to non-SCSI target devices, e.g., LOOP, NBD,
USB?
While the architecture looks fully capable of supporting such, it looks like
both the
kernel and user implementation would have some problems due to some SCSI
affinity.
