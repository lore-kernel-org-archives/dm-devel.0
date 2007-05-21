From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/2] Path priority for RDAC devices
Date: Mon, 21 May 2007 14:50:31 -0700
Message-ID: <20070521215031.29373.63818.sendpatchset@localhost.localdomain>
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Hi Christophe,

Few months ago I submitted path checker code for RDAC devices.

Recently I found that the priority of the paths are not being set properly.

Here are 2 patches that fix the problem and set the priority appropriately.

Please let me know what do you think.

Thanks

chandra

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
