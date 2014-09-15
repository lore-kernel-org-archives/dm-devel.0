From: Romu Hu <huruomu@gmail.com>
Subject: RHEL6.6 dm-cache and dm-era
Date: Mon, 15 Sep 2014 10:24:00 +0800
Message-ID: <54164DC0.3020907@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

According to 
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6-Beta/html-single/6.6_Release_Notes/index.html#bh-storage, 
dm-cache and dm-era have been added into RHEL6.6 as technology preview, 
but I couldn't find any other documentation about using dm-cache and 
dm-era.  I found the following utilities in

/usr/sbin/era_check
/usr/sbin/era_dump
/usr/sbin/era_invalidate

/usr/sbin/cache_check
/usr/sbin/cache_dump
/usr/sbin/cache_repair
/usr/sbin/cache_restore

I guess these utilities are related to dm-era and dm-cache, 
respectively.  There are only manpages for the cache utilities. After 
reading the manpages I still have no clue how to use these 
technologies.  I want to do a sanity check of these technologies on my 
SAN storage.  Is it possible to try dm-cache and dm-era without a SSD?  
e.g. using ram to imitate a fast block device..

Any idea?


Thanks
Romu
