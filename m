From: "goggin, edward" <egoggin@emc.com>
Subject: queue_if_no_paths timeout handling
Date: Tue, 12 Jul 2005 22:28:09 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB67@SRMANNING.eng.emc.com>
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

May need to be able to at least offer the option of timing out ios to
multipath
block devices enabled with the queue_if_no_paths feature which are in an
all-paths-down use case for a configurable amount of time.

Christophe, could you remove this attribute from the hwtable.c entry for the
EMC CLARiiON?  Its the one with the vendor string of "DGC".  The feature
is no longer needed.
