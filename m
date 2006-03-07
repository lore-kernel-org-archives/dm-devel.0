From: egoggin@emc.com
Subject: 2nd patch
Date: Tue, 7 Mar 2006 13:22:00 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B09F@SRMANNING.eng.emc.com>
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
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Christophe,

Turns out the previous patch needs the additional 2 line change to
checkloop() in multipathd/main.c
in order to reinstate the dmstate of a newly passive path.  Code goes at the
end of the block
which is controlled by the following conditional.

	else if (newstate == PATH_UP || newstate == PATH_GHOST) {


+				if (pp->dmstate == PSTATE_FAILED)
+					reinstate_path(pp, 1);


Ed
