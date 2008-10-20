From: "Dong-Jae Kang" <baramsori72@gmail.com>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
	v1.8.0: Introduction
Date: Mon, 20 Oct 2008 19:13:14 +0900
Message-ID: <2891419e0810200313j5cac8541qff80614e3d784b1b@mail.gmail.com>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	<2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
	<20081020.180129.193689104.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081020.180129.193689104.ryov@valinux.co.jp>
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

Thank you for fast reply.

2008/10/20 Ryo Tsuruta <ryov@valinux.co.jp>:
> Hi Dong-Jae,
>
>> I am trying to install your new released dm-ioband v1.8.0
>> I/O bandwidth controller v1.8.0 could be adjusted to  the latest
>> stable kernel 2.6.27.1
>> it was good news for me
>> but, I had a problem when I try to patch bio-cgroup files to  stable
>> kernel 2.6.27.1
>> many patch failure and hunk messages were occured.
>>
>> Can you check bio-cgroup patch files against stable kernel 2.6.27.1?
>
> bio-cgroup patch can apply only to 2.6.27-rc5-mm1 so far.
> Please use 2.6.27-rc5-mm1 to try both bio-cgroup and dm-ioband,
> dm-ioband v1.8.0 can also apply to 2.6.27-rc5-mm1.

OK, I will use kernel-2.6.27-rc5-mm1 as your comments

Well, do you have any plan to upgrade bio-cgroup patches for stable
latest kernel?
but, I think it will be not easy job ^^
Thank you

Regards,
Dong-Jae Kang


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
