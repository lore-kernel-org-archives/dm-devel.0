From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 33] Generalized device-mapper exception
	store API
Date: Wed, 25 Mar 2009 16:44:36 -0500
Message-ID: <1238017479.20668.6.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

I've updated the patches for 2.6.29.  I've pulled in 3 patches that
weren't applying cleanly from "group 1", added 1 more patch to "group
2", and pulled the shared exception store patch (I'll send that
separately).

I have adjusted the bundles appropriately:
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%
20group2/

The bundle for group1 had been removed.

Please be aware if you are working off of agk's series file, the first
three patches in this group supersede what is there.

 brassow
