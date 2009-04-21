From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Re: dm-ioband: Test results.
Date: Tue, 21 Apr 2009 21:10:51 +0900 (JST)
Message-ID: <20090421.211051.183023683.ryov@valinux.co.jp>
References: <20090420.172959.193682665.ryov@valinux.co.jp>
	<e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com>
	<20090421.210614.112619728.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090421.210614.112619728.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nauman@google.com
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Nauman,

> > The real question is, once you create a version of dm-ioband that
> > co-operates with CFQ scheduler, how that solution would compare with
> > the patch set Vivek has posted? In my opinion, we need to converge to
> > one solution as soon as possible, so that we can work on it together
> > to refine and test it.
> 
> I think I can do some help for your work. but I want to continue the
> development of dm-ioband, because dm-ioband actually works well and
> I think it has some advantages against other IO controllers.
>   - It can use without cgroup.
>   - It can control bandwidth on a per partition basis.
>   - The driver module can be replaced without stopping the system.

In addition, dm-ioband can run on the RHEL5.

Thanks,
Ryo Tsuruta
