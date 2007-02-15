From: "Yury Konovalov" <ykonovalov@gmail.com>
Subject: Re: Question about dm-multipath and Sun StorageTek 6140
Date: Thu, 15 Feb 2007 10:10:44 +0300
Message-ID: <744db6db0702142310g22cd3477v8c3666982e657954@mail.gmail.com>
References: <45CC4540.7020707@informatik.uni-stuttgart.de>
	<744db6db0702112336r4d83ed3eucaa590975e5f0b52@mail.gmail.com>
	<AF2D2B62FD3A3EDB492DEDAA@sigh.heise.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AF2D2B62FD3A3EDB492DEDAA@sigh.heise.de>
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

Hi Eckebrecht,

2007/2/14, Eckebrecht von Pappenheim <evp@heise.de>:
> > It's true only for non-AVT mode (set host type to Linux to turn AVT mode
> on)
>
> at least for the 6140 this is not correct. It sets the mode to RDAC for the
> Sun-RDAC-Driver ( http://www.sun.com/download/products.xml?id=44d12115 ).
>
> You have to choose 'Solaris (with Veritas DMP or other)' (named SOLAVT in
> the
> CLI) to enable AVT.

You're right. It seems that Sun uses different host types from those
used by IBM http://sunsolve.sun.com/search/document.do?assetkey=1-9-83529-1
-----
...
Linux: This setting is for all Linux OE's using explicit failover via
either STM for linux or the mpp(RDAC) driver.
...
Solaris (with Veritas DMP): This is for Solaris hosts using Symantec
Veritas DMP driver for implicit failover.
...
----

Following Sun terminology, host type with implicit failover should be
used for dm multipathing. At least until (if ever) rdac hwhandler will
be implemented in device mapper.


All best wishes,
Yury.
