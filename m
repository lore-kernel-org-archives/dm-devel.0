From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] Changes to Userspace multipath code to
	support lsi-rdac
Date: Wed, 21 Mar 2007 11:38:33 -0800
Message-ID: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
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
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, christophe.varoqui@free.fr, agk@redhat.com
List-Id: dm-devel.ids

Hi All,

While working on lsi-rdac hardware handler, I found that the checkers "tur"
and "readsector0" are not serving the lsi-rdac properly. Also, the storage
device has a active/passive state which need to be handled properly.

So, I wrote a new path checker for lsi-rdac, to use the C4 inquiry page to get
the current owner of the lun and set the state as UP(active) or GHOST(passive).
Changes are in patch 1/3.

After applying the above patch, I realized the priorities are not set properly.
Made some changes to use the GHOST state while setting priorities. Changes are
in patch 2/3.

Debugging the above patches found that the wait time (5 seconds) in multipathd
was not sufficient for the devices to appear in /dev/ It was taking about 20
seconds. Changed the wait time to be 60 seconds. Change in patch 3/3.

Please provide me with your feedback/comment on these changes regarding
correctness, completeness etc.,

Thanks & regards,

chandra

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
