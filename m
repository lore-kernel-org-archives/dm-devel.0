From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Replicator part for lvm
Date: Mon,  2 Nov 2009 15:20:04 +0100
Message-ID: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

Generic code updates:

[PATCH 01/18] Adding fflush after yes/no prompt
[PATCH 02/18] Export outnl and indent functions for modules
[PATCH 03/18] Export outsz() and outhnt() for modules
[PATCH 04/18] Export outfc() macro and out_text_with_comment()
[PATCH 05/18] Use outsz macro

Replicator related code:

[PATCH 06/18] Replicator: add libdm support
[PATCH 07/18] Replicator: suspend/deactivate replicator
[PATCH 08/18] Replicator: add lvm support
[PATCH 09/18] Replicator: vg validation
[PATCH 10/18] Replicator: extend _lv_each_dependency() rep. deps
[PATCH 11/18] Replicator: update _create_partial_dtree()
[PATCH 12/18] Replicator: add replicator to dtree
[PATCH 13/18] Replicator: do not remove of replicators' LVs
[PATCH 14/18] Replicator: activate change for vgchange
[PATCH 15/18] Replicator: add new options for replicator
[PATCH 16/18] Replicator: update copyright dates
[PATCH 17/18] Replicator: new variable in generated file
[PATCH 18/18] Replicator: update of generated configure file
