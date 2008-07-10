From: "Xinwei Hu" <hxinwei@gmail.com>
Subject: Re: [PATCH 1/2] dm-ioband: I/O bandwidth controller
	v1.2.0: Source code and patch
Date: Thu, 10 Jul 2008 15:22:37 +0800
Message-ID: <1cafab770807100022l3c8f9c7fy4d63caa0c49c286c@mail.gmail.com>
References: <20080704.124038.193696173.ryov@valinux.co.jp>
	<20080704.124142.226792170.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080704.124142.226792170.ryov@valinux.co.jp>
Content-Disposition: inline
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
List-Id: dm-devel.ids

Hi Ryo,
2008/7/4 Ryo Tsuruta <ryov@valinux.co.jp>:
> +static void prevent_burst_bios(struct ioband_group *gp, struct bio *bio)
> +{
> +       struct ioband_device *dp = gp->c_banddev;
> +
> +       if (current->flags & PF_KTHREAD) {
> +               /*
> +                * Kernel threads shouldn't be blocked easily since each of
> +                * them may handle BIOs for several groups on several
> +                * partitions.
> +                */
  Might be a stupid question, but doesn't that make more sense to just
check if current->mm == NULL ?
  I think PF_BORROWED_MM is only used when kernel threads doing AIO
for user process, and that should be counted as normal user processes.
Am I miss anything ?
