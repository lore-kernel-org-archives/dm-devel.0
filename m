From: k-ueda@ct.jp.nec.com
Subject: each device filtering for multipath
Date: Wed, 30 Mar 2005 10:03:08 -0500 (EST)
Message-ID: <11955.1276941367$1112194984@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hello,

I think that finer-grained device filtering (e.g. by each device)
is needed in multipath-tools.
Has anyone already started tackling this feature?
Any comments about following approach are welcome.


Background
----------
Problem#1 : Multipath command configures not only multipath devices
            (like Fibre Channel storages) but also local devices
            (like SCSI disks) as multipath.
            Then, as dm holds the reference to the source device,
            local devices can't be used through /dev/sd* name.

Problem#2 : Even for Fibre Channel storages, there is a case such that
            we need to configure multipath for one but don't want for
            the other.

We have 2 options to configure specific devices only.

  o Specify a device name as multipath command argument.
  o Specify white lists (vendor/model combination) in scsi_id.config,
    and don't use -g option for scsi_id callout.

But these are not enough.
The first option breaks if the device names are not persistent.
The second option can solve the problem#1, but can't solve the problem#2.


Proposal
--------
As multipath command already has a black listing feature, adding
wwid filtering to it is straightforward solution.  I've created
a tentative patch as proposal.  (patch for multipath-tools-0.4.3)
I also think that adding whitelist filtering may be useful.


Patch (tentative)
-----------------
-----------------------------------------------------------------------
--- multipath-tools-0.4.3/multipath/main.c      2005-03-23 10:18:42.000000000 -0500
+++ wwidfilter-0.4.3/multipath/main.c     2005-03-28 16:11:51.000000000 -0500
@@ -746,7 +746,8 @@ coalesce_paths (vector curmp, vector pat
                /* skip this path for some reason */

                /* 1. if path has no unique id */
-               if (memcmp(empty_buff, pp1->wwid, WWID_SIZE) == 0)
+               if ((memcmp(empty_buff, pp1->wwid, WWID_SIZE) == 0) ||
+                               blacklist(conf->blist, pp1->wwid))
                        continue;

                /* 2. if path already coalesced */
--- multipath-tools-0.4.3/multipath/dict.c      2005-03-19 07:59:15.000000000 -0500
+++ wwidfilter-0.4.3/multipath/dict.c     2005-03-28 16:12:40.000000000 -0500
@@ -249,6 +249,7 @@ init_keywords(void)

        install_keyword_root("devnode_blacklist", &blacklist_handler);
        install_keyword("devnode", &devnode_handler);
+       install_keyword("blackwwid", &devnode_handler);

        install_keyword_root("devices", &devices_handler);
        install_keyword("device", &device_handler);
-----------------------------------------------------------------------

With above patch, we can filter each devices by specifing multipath.conf
like following.

-----------------------------------------------------------------------
devnode_blacklist {
        devnode c0d
	...
	snip
	...
        devnode loop
        blackwwid SSEAGATE_ST373307LC_____3HZ6XQWB00007431GBM4
        blackwwid SSEAGATE_ST373307LC_____3HZ70N5S000074343PL8
}
-----------------------------------------------------------------------


Best regards,
Ky (Kiyoshi Ueda)
