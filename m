From: christophe.varoqui@free.fr
Subject: [RFC] dm snapshot based asynchronous replication
Date: Mon, 13 Apr 2009 23:08:20 +0200 (CEST)
Message-ID: <177494415.1766861239656900680.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <1567864196.1766411239656669717.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1567864196.1766411239656669717.JavaMail.root@zimbra16-e3.priv.proxad.net>
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

dm developers,

I'm in need of an asynchronous replication method for active/passive clusters using direct-attached disks. Please advise if you know tools (other than drdb an rsync) to do the job. (How goes dm-replicator btw ?).

Pending an existing project, I toyed with a replication scheme I'd like to sketch here for comments and fool-proofing.

Source and destination are logical volumes : lv_src => lv_dst
Upon cold start lv_src and lv_dst are unsynchronized.

==== pseudo-code start
snap lv_src (lv_src_snap0)
full copy lv_src_snap0 on lv_dst
while true:
  wait n seconds
  snap lv_src (lv_src_snap1)
  for each changed chunk in lv_src_snap0 cow table:
    copy chunk from lv_src_snap1 to lv_dst
  drop lv_src_snap0, and rename lv_src_snap1 to lv_src_snap0
==== pseudo-code end

Snapshoting the lv_dst would make sense as a rollback safety net ... even if the rollback is a bit hard pending the snapshot merging  patchset inclusion.

If this sketch looks sane to you, I'm interested in how to list the changed chunks for a snap. A pointer to existing code would do great.

Regards,
cvaroqui
