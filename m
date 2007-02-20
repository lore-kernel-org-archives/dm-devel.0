From: Neil Brown <neilb@suse.de>
Subject: Re: forwarded message from Vignesh Babu BM
Date: Tue, 20 Feb 2007 12:38:16 +1100
Message-ID: <17882.20744.39637.22780@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/FGeBtjy+P"
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


--/FGeBtjy+P
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit


mis-directed patch for you....

NeilBrown


--/FGeBtjy+P
Content-Type: message/rfc822
Content-Description: forwarded message
Content-Transfer-Encoding: 7bit

Mime-Version: 1.0
Content-Type: text/plain
Return-Path: <vignesh.babu@wipro.com>
Received: from imap.suse.de ([unix socket])
	by imap-dhs (Cyrus v2.1.16) with LMTP; Fri, 16 Feb 2007 13:06:32 +0100
X-Sieve: CMU Sieve 2.2
Received: from Relay1.suse.de (relay1.suse.de [149.44.160.87])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(Client CN "relay.suse.de",
	Issuer "SuSE Linux AG internal IMAP-Server CA" (verified OK))
	by imap.suse.de (Postfix) with ESMTP id BBD349FBAFF
	for <nfbrown@imap-dhs.suse.de>; Fri, 16 Feb 2007 13:06:32 +0100 (CET)
Received: by Relay1.suse.de (Postfix)
	id A2BC9C94B4; Fri, 16 Feb 2007 13:06:32 +0100 (CET)
Received: from Relay1.suse.de (localhost [127.0.0.1])
	by Relay1.suse.de (Postfix) with ESMTP id 892A3C8D92
	for <neilb@suse.de>; Fri, 16 Feb 2007 13:06:32 +0100 (CET)
Received: from Relay1.suse.de ([127.0.0.1])
	by Relay1.suse.de (Relay1 [127.0.0.1]) (amavisd-new,
	port 10026) with ESMTP
	id 01632-08 for <neilb@suse.de>; Fri, 16 Feb 2007 13:06:30 +0100 (CET)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by Relay1.suse.de (Postfix) with ESMTP id 2597AC975D
	for <neilb@suse.de>; Fri, 16 Feb 2007 13:06:30 +0100 (CET)
Received: from wip-ectls-mx3.wipro.com (wip-ectls-mx3.wipro.com
	[203.91.193.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id ACD5212471
	for <neilb@suse.de>; Fri, 16 Feb 2007 13:06:29 +0100 (CET)
Received: from wip-ectls-mx3.wipro.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with ESMTP id 359C12242A9
	for <neilb@suse.de>; Fri, 16 Feb 2007 17:36:17 +0530 (IST)
Received: from blr-ec-bh01.wipro.com (blr-ec-bh01.wipro.com [10.201.50.91])
	by wip-ectls-mx3.wipro.com (Postfix) with ESMTP id 28C1B224028
	for <neilb@suse.de>; Fri, 16 Feb 2007 17:36:17 +0530 (IST)
Received: from BLR-EC-MBX06.wipro.com ([10.201.50.168]) by
	blr-ec-bh01.wipro.com with Microsoft SMTPSVC(6.0.3790.1830);
	Fri, 16 Feb 2007 17:36:16 +0530
Received: from 10.200.209.67 ([10.200.209.67]) by BLR-EC-MBX06.wipro.com
	([10.201.50.183]) with Microsoft Exchange Server HTTP-DAV ;
	Fri, 16 Feb 2007 12:06:16 +0000
Received: from wriver-t81fb058.linuxcoe by BLR-EC-MBX06.wipro.com;
	16 Feb 2007 17:35:16 +0530
Message-Id: <1171627516.6127.2.camel@wriver-t81fb058.linuxcoe>
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 16 Feb 2007 12:06:16.0616 (UTC)
	FILETIME=[DC606A80:01C751C2]
X-Virus-Scanned: by amavisd-new at Relay1.suse.de
X-Spam-Status: No, hits=-1.0 tagged_above=-20.0 required=5.0 tests=BAYES_50,
	MY_LINUX, UNPARSEABLE_RELAY
X-Spam-Level: 
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.5
From: Vignesh Babu BM <vignesh.babu@wipro.com>
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Cc: mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
Subject: [KJ][PATCH] is_power_of_2 in md
Date: Fri, 16 Feb 2007 17:35:16 +0530



Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2


diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0821a2b..f2d4b23 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
 
 #include "dm-snap.h"
 #include "dm-bio-list.h"
@@ -414,7 +415,7 @@ static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
 	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
 
 	/* Check chunk_size is a power of 2 */
-	if (chunk_size & (chunk_size - 1)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"


The information contained in this electronic message and any attachments to this message are intended for the exclusive use of the addressee(s) and may contain proprietary, confidential or privileged information. If you are not the intended recipient, you should not disseminate, distribute or copy this e-mail. Please notify the sender immediately and destroy all copies of this message and any attachments. 

WARNING: Computer viruses can be transmitted via email. The recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.
 
www.wipro.com

--/FGeBtjy+P
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--/FGeBtjy+P--
