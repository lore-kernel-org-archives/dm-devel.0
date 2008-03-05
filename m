From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 0/13] dm headers: move headers to
	include/linux
Date: Wed,  5 Mar 2008 19:55:51 +0100
Message-ID: <1204743364-3248-1-git-send-email-hjm@redhat.com>
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

Hi Alasdair,

this is a series of 13 patches, which move dm-{io,log}.h and kcopyd.h to
include/linux, renaming the later to dm-kcopyd.h, to better allow for their
interfaces to be sharable beyond the scope of Device-Mapper.

Structure and function identifiers (e.g. io_region -> dm_io_region)
get a "dm_", macros a "DM_" prefix respectively.

Existing callers are adjusted to use the new structure/function/macro names.

The Makefile now generates dm-{io,kcopyd,log} as kmods.
This potentially needs a future change in case of a static kernel *and*
more callers sharing the dm-{io,kcopyd,log} modules.

dm_disk(), which belongs to our external interface since long time, is
exported now to allow for future callers to actually be able to access it.

If acceptable, please apply.
