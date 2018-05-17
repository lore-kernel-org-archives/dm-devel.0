From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: dm-thin: Why is DATA_DEV_BLOCK_SIZE_MIN_SECTORS set to
	64k?
Date: Thu, 17 May 2018 23:36:26 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1805172332520.20870@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hello all,

Is there a technical reason that DATA_DEV_BLOCK_SIZE_MIN_SECTORS is 
limited to 64k?  

I realize that the metadata limits the maximum mappable pool size, so it 
needs to be bigger for big pools---but it is also the minimum COW size.  

Looking at the code this is enforced in pool_ctr() but isn't used anywhere 
else in the code.  Is it strictly necessary to enforce this minimum?

Thanks for your help!

--
Eric Wheeler
