From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-thin: Why is DATA_DEV_BLOCK_SIZE_MIN_SECTORS set
 to 64k?
Date: Fri, 18 May 2018 09:59:37 +0200
Message-ID: <8bde7e8c-d2c1-c67d-f0ca-5b121053b34f@redhat.com>
References: <alpine.LRH.2.11.1805172332520.20870@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1805172332520.20870@mail.ewheeler.net>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 18.5.2018 v 01:36 Eric Wheeler napsal(a):
> Hello all,
> 
> Is there a technical reason that DATA_DEV_BLOCK_SIZE_MIN_SECTORS is
> limited to 64k?
> 
> I realize that the metadata limits the maximum mappable pool size, so it
> needs to be bigger for big pools---but it is also the minimum COW size.
> 
> Looking at the code this is enforced in pool_ctr() but isn't used anywhere
> else in the code.  Is it strictly necessary to enforce this minimum?
> 


Hi

Selection of 64k  was chosen as compromise between used space for metadada, 
locking contention, kernel memory usage and overall speed performance.

If there is a case, where using 4K chunks for snapshot is giving a major 
advantage, there is still availability to use old snapshot target.


Regards

Zdenek
