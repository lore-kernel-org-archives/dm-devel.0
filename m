From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFX PATCH 0/4] dm-log: make dm-log.c a seperate
	sharable module
Date: Tue,  4 Mar 2008 15:28:27 +0100
Message-ID: <1204640911-28469-1-git-send-email-hjm@redhat.com>
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

This is a series of 4 patches, aiming to support the replicator target
by exporting dm_disk from dm.c and factoring the dirty region log
(aka "mirror log" so far) out into a seperate kmod sharable by the
mirror and the replicator target (and others in the future).

If acceptable, please apply.
