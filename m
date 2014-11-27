From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 16:24:16 +0100
Message-ID: <54774220.7080709@redhat.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>	<54773621.5090301@redhat.com>
	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
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

Dne 27.11.2014 v 16:01 Gianluca Cecchi napsal(a):
> On Thu, Nov 27, 2014 at 3:33 PM, Zdenek Kabelac <zkabelac@redhat.com
> <mailto:zkabelac@redhat.com>> wrote:
>
>     Dne 27.11.2014 v 15:26 Gianluca Cecchi napsal(a):
>
>         Hello,
>         I'm unable to deactivate an lvm.
>
>         My system is RHEL 6.5 with lvm2-2.02.100-8.el6.x86_64 and kernel
>         2.6.32-431.29.2.el6.x86_64
>
>         I get error code 5 with message
>             Logical volume VG_AAA_TEMP/LV_AAA_TEMP in use.
>
>         You can find output of
>         lvchange -d -d -d -d -d -d -an VG_AAA_TEMP/LV_AAA_TEMP
>         here:
>         https://drive.google.com/file/__d/__0BwoPbcrMv8mvTjlBMkRUbG9nczA/__view?usp=sharing
>         <https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUbG9nczA/view?usp=sharing>
>
>
>     Not really accessible.
>
>
> strange, do you mean the google docs link?
> I tried with a browser without access to any gmail account and I'm able to
> download it....
>

Ahh - I'd too strict  adblock filter - however passed info is not that useful.
Prefered output is   'lvchange -vvvv -an'


>
>     But anyway - if you have problem with  'semaphore' resouces - you could
>     'recycle' old ones -
>
>     'dmsetup  udevcomplete_all'
>
>
> This is actually a production server with many other LVs... Is there any
> drawback in the command above?

You could 'complete' all cookies older then i.e. 1 minute.
Nothing should be holding cookie for that long time.


> Nov 26 17:35:34 orapr2 rgmanager[5908]: [lvm] lv_activate_resilient stop
> failed on VG_AAA_TEMP/LV_AAA_TEMP
> Nov 26 17:35:34 orapr2 rgmanager[5928]: [lvm] Unable to deactivate
> VG_AAA_TEMP/LV_AAA_TEMP

Well - here we need to know the reason why it has failed -

Is there some user of  VG_AAA_TEMP/LV_AAA_TEMP ?

Mounted, opened, used as a device for something else ?


>         [root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP
>             LV          VG          Attr       LSize    Pool Origin Data%
>         Move Log
>         Cpy%Sync Convert
>             LV_AAA_TEMP VG_AAA_TEMP -wi-ao---- 1020.00m
>
>         How can I see the responsible for the reference that apparently keeps
>         it open?
>
>         Open count:        1
>         so I can check and eventually fix??

lsof  - look for user of 253,49

Zdenek
