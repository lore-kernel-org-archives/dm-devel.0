From: Rik van Riel <riel@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 08 Sep 2009 12:47:33 -0400
Message-ID: <4AA68AA5.10505@redhat.com>
References: <20090904231129.GA3689@redhat.com>	
	<20090907.200222.193693062.ryov@valinux.co.jp>	
	<4AA51065.6050000@redhat.com>	
	<20090908.120119.71095369.ryov@valinux.co.jp>	
	<20090908134244.GA15974@redhat.com>
	<e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nauman Rafique <nauman@google.com>
Cc: guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, jens.axboe@oracle.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Nauman Rafique wrote:

> I think this is probably the key deal breaker. dm-ioband has no
> mechanism to anticipate or idle for a reader task. Without such a
> mechanism, a proportional division scheme cannot work for tasks doing
> reads. 

That is a really big issue, since most reads tend to be synchronous
(the application is waiting for the read), while many writes are not
(the application is doing something else while the data is written).

Having writes take precedence over reads will really screw over the
readers, while not benefitting the writers all that much.

-- 
All rights reversed.
