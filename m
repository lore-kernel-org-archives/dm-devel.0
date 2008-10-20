From: "Dong-Jae Kang" <baramsori72@gmail.com>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
	v1.8.0: Introduction
Date: Mon, 20 Oct 2008 17:40:49 +0900
Message-ID: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081017.160950.71109894.ryov@valinux.co.jp>
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
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, corsetproject@googlegroups.com, fernando@oss.ntt.co.jp, agk@redhat.com
List-Id: dm-devel.ids

Hi, Ryo Tsuruta

I am trying to install your new released dm-ioband v1.8.0
I/O bandwidth controller v1.8.0 could be adjusted to  the latest
stable kernel 2.6.27.1
it was good news for me
but, I had a problem when I try to patch bio-cgroup files to  stable
kernel 2.6.27.1
many patch failure and hunk messages were occured.

Can you check bio-cgroup patch files against stable kernel 2.6.27.1?

If the dm-ioband and bio-cgroup patches had different base kernel, i
think it is not natural.
I think it is more reasonable to release dm-ioband and bio-cgroup
patches in pair.
In my situation, both direct IO and buffered IO are same important.

thank you

Regard,
Dong-Jae Kang

2008/10/17 Ryo Tsuruta <ryov@valinux.co.jp>:
> Hi Alasdair and all,
>
> This is the dm-ioband version 1.8.0 release.
>
> Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
> driver, which gives specified bandwidth to each job running on the same
> physical device.
>
> This release is a minor bug fix and confirmed running on the latest
> stable kernel 2.6.27.1.
>
> - Can be applied to the kernel 2.6.27.1 and 2.6.27-rc5-mm1.
> - Changes from 1.7.0 (posted on Oct 3, 2008):
>  - Fix a minor bug in io_limit setting that causes dm-ioband to stop
>    issuing I/O requests when a large value is set to io_limit.
>
> Alasdair, could you please review this patch and give me any comments?
>
> Thanks,
> Ryo Tsuruta
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
>



-- 
-------------------------------------------------------------------------------------------------
   DONG-JAE, KANG
   Senior Member of Engineering Staff
   Internet Platform Research Dept, S/W Content Research Lab
   Electronics and Telecommunications Research Institute(ETRI)
   138 Gajeongno, Yuseong-gu, Daejeon, 305-700 KOREA
   Phone : 82-42-860-1561 Fax : 82-42-860-6699
   Mobile : 82-10-9919-2353 E-mail : djkang@etri.re.kr (MSN)
-------------------------------------------------------------------------------------------------
