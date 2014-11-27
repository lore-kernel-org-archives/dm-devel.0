From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 15:33:05 +0100
Message-ID: <54773621.5090301@redhat.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
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
List-Id: dm-devel.ids

Dne 27.11.2014 v 15:26 Gianluca Cecchi napsal(a):
> Hello,
> I'm unable to deactivate an lvm.
>
> My system is RHEL 6.5 with lvm2-2.02.100-8.el6.x86_64 and kernel
> 2.6.32-431.29.2.el6.x86_64
>
> I get error code 5 with message
>    Logical volume VG_AAA_TEMP/LV_AAA_TEMP in use.
>
> You can find output of
> lvchange -d -d -d -d -d -d -an VG_AAA_TEMP/LV_AAA_TEMP
> here:
> https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUbG9nczA/view?usp=sharing
>

Not really accessible.

But anyway - if you have problem with  'semaphore' resouces - you could 
'recycle' old ones -

'dmsetup  udevcomplete_all'

Of course it's hard to guess what experiments are you doing and would could 
lead to uncompleted cockies (stuck udev scans)

Do you happen to have some suspend devices in your table ?
(dmsetup info -c    should show them)

> [root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP
>    LV          VG          Attr       LSize    Pool Origin Data%  Move Log
> Cpy%Sync Convert
>    LV_AAA_TEMP VG_AAA_TEMP -wi-ao---- 1020.00m
>
> How can I see the responsible for the reference that apparently keeps it open?
>
> Open count:        1
> so I can check and eventually fix??
>

dmsetup ls --tree

is usually good in shows deps between devs (i.e.  target A holds target B)

Regards

Zdenek
