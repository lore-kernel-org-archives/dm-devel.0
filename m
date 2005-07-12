From: "goggin, edward" <egoggin@emc.com>
Subject: adding dm-x device file names to "multipath -l" display
	output
Date: Tue, 12 Jul 2005 16:30:36 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB66@SRMANNING.eng.emc.com>
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

Useful in cases where other OS commands/files, (e.g., mount(8) and
/proc/partitions),
are displaying the device-mapper's dm-x device file names in /dev and not
the
multipath specific names, symlink or alias.
