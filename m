From: Sachin Sant <sachinp@in.ibm.com>
Subject: Next March 20 : drivers/md/dm-exception-store build break
Date: Fri, 20 Mar 2009 14:35:26 +0530
Message-ID: <49C35C56.1010205@in.ibm.com>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757697AbZCTJFr@vger.kernel.org>
In-Reply-To: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Today's next tree randconfig build failed with

  CC      drivers/md/dm-exception-store.o
drivers/md/dm-exception-store.c: In function dm_exception_store_type_unregister:
drivers/md/dm-exception-store.c:133: error: implicit declaration of function module_refcount

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------
