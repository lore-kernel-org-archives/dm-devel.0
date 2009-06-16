From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Updated cluster log patch (take 5)
Date: Mon, 15 Jun 2009 19:08:24 -0500
Message-ID: <279E8D80-4F3A-4236-9869-578CC1374365@redhat.com>
References: <1244845317.19994.3.camel@hydrogen.msp.redhat.com>
	<20090613110733.GA7895@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090613110733.GA7895@infradead.org>
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
Cc: hch@infradead.org
List-Id: dm-devel.ids


On Jun 13, 2009, at 6:07 AM, Christoph Hellwig wrote:

> On Fri, Jun 12, 2009 at 05:21:57PM -0500, Jonathan Brassow wrote:
>> The structure used for communication between kernel and userspace are
>> located in include/linux/dm-log-cluster.h.  Due to the frequency,
>> diversity, and 2-way communication nature of the exchanges between
>> kernel and userspace, 'connector' is used as the interface for
>> communication.
>
> Maye I misremember it, but isn't the connector code strongly  
> deprecated
> in favour of genetlink?

I'm not sure.  I saw the generic netlink come in, but I didn't think  
connector was deprecated.  In fact, I thought that 2.6.30 introduced  
"pohmelfs" and "dst" (both written by the maintainer of 'connector').

If this is a show-stopper, you should tell me, so I can change it.   
Otherwise, I may defer the change to a later kernel (since there is  
not much time in this merge window).  The change would require  
userspace to change their socket and bind calls... so perhaps you  
think it might be better to get this out of the way now?

Please inform,
  brassow
