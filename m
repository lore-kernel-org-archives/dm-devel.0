From: "goggin, edward" <egoggin@emc.com>
Subject: nit with reinstate_path for dm-mpath.c
Date: Mon, 25 Apr 2005 15:25:36 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A93F@SRMANNING.eng.emc.com>
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

Should reinstate_path() in dm-mpath.c only conditionally reset
current_pgpath if
the restored path is in the same path priority group as the current_pgpath
instead
of doing so unconditionally as is done currently?  Albeit this change makes
sense
IFF it is architecturally invalid to have a path selection policy which
spans multiple
path priority groups -- as I think is currently the case.
