From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Not able to create a device mapper target node
Date: Tue, 25 Jun 2013 10:19:24 +0200
Message-ID: <51C9528C.6010700@redhat.com>
References: <CABmd-rm-6P-+bkoHVAK25pEVgVBNswELepV5qvweTUd1J2Poag@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABmd-rm-6P-+bkoHVAK25pEVgVBNswELepV5qvweTUd1J2Poag@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: monica g <monica.knmt@gmail.com>
List-Id: dm-devel.ids

Dne 24.6.2013 09:19, monica g napsal(a):
> Hi,
>
> I wrote a basic device mapper driver which caches reads.
>
> I gave dm msg prefix as below
>   #define DM_MSG_PREFIX "cacheread".
>
> When i try to create a device mapper node using the below command
> echo "0 `blockdev --getsize /dev/sda2` cacheread /dev/sda2 0" | dmsetup create
> cacheread
>
> the system hangs.I am not getting any error messages.

Why not looking into a basic linear driver -

linux/drivers/md/dm-stripe.c

and start updating this driver for your needs.
Kernel device driver development is not easily debugable from userspace.

Also you might be interested to look at  dm-cache driver available from 3.9
kernel and which does much more advanced caching of reads as well as writes....

Regards

Zdenek


>
> When i try to create a device mapper node for linear target(this target is
> already present with the device mapper code) using below command
>
> echo "0 `blockdev --getsize /dev/sda2` linear /dev/sda2 0" | dmsetup create linear
> it succeeds and creates device node linear in /dev/mapper directory.
>
> I am stuck with this issue and not able to proceed furthur.
>
> Please let me know if you have any suggestions.
>
> Any help is truely appreciated.
>
> Thanks in advance.
>
> Regards,
> Monica
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
