From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 8 Sep 2009 08:52:55 +0530
Message-ID: <20090908032254.GJ8315@balbir.in.ibm.com>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
Reply-To: balbir@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090908.120119.71095369.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com
List-Id: dm-devel.ids

* Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-08 12:01:19]:

> I think there are some advantages to dm-ioband. That's why I post
> dm-ioband to the mailing list.
> 
> - dm-ioband supports not only proportional weight policy but also rate
>   limiting policy. Besides, new policies can be added to dm-ioband if
>   a user wants to control bandwidth by his or her own policy.
> - The dm-ioband driver can be replaced without stopping the system by
>   using device-mapper's facility. It's easy to maintain.
> - dm-ioband can use without cgroup. (I remember Vivek said it's not an
>   advantage.)

But don't you need page_cgroup for IO tracking?

-- 
	Balbir
