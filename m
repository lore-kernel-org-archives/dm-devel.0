From: "goggin, edward" <egoggin@emc.com>
Subject: Block multipathing in an IP-SAN
Date: Tue, 1 Nov 2005 17:19:23 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AD90@SRMANNING.eng.emc.com>
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

I'm wondering about how block device multipathing works in conjunction with
the high availability
features of an IP-SAN.

Does the iSCSI initiator's session layer's retransmission capability and the
IP-takeover capability
of IP-SAN switches eliminate the need for block device multipathing in an
IP-SAN?

Does the iSCSI initiator present redundant paths to the SCSI mid-layer?

Do these answers differ with software verses hardware iSCSI initiators?
