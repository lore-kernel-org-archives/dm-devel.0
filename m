From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 17:05:32 +0100
Message-ID: <54774BCC.6020709@redhat.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>	<54773621.5090301@redhat.com>	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>	<54774220.7080709@redhat.com>	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>	<5477469A.1080103@redhat.com>
	<CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>
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

Dne 27.11.2014 v 16:56 Gianluca Cecchi napsal(a):
> On Thu, Nov 27, 2014 at 4:43 PM, Zdenek Kabelac <zkabelac@redhat.com
> <mailto:zkabelac@redhat.com>> wrote:
>

>    LV Path                /dev/VG_AAA_TEMP/LV_AAA_TEMP
>    LV Name                LV_AAA_TEMP
>    VG Name                VG_AAA_TEMP
>    LV UUID                azFNtf-L1CY-3rdz-OQLA-7oF4-3rMX-uWfXpH
>    LV Write Access        read/write
>    LV Creation host, time ,
>    LV Status              available
>    # open                 1
>    LV Size                1020.00 MiB
>    Current LE             255
>    Segments               1
>    Allocation             inherit
>    Read ahead sectors     auto
>    - currently set to     256
>    Block device           253:49
>    --- Physical volumes ---
>    PV Name               /dev/mapper/360a9800037543544465d424130533177
>    PV UUID               LnsWgD-XfYe-axfJ-nBgC-Gew5-jBH3-oXpiIO
>    PV Status             allocatable
>    Total PE / Free PE    255 / 0
>
>
>
>     I'd probably need to see your whole 'dmsetup table'
>     (at least do a grep for VG_AAA_TEMP/LV_AAA_TEMP minor)
>
>
>
> [root@orapr2 ~]# dmsetup table | egrep
> "AAA_TEMP|360a9800037543544465d424130533177|253:4"

So it's likely a time to look through 'dmesg' output if there is not something 
suspicious ?

Kernel bug/report showing some error behavior which may lead to openned 
descriptor being leaked?

Is there anything in  /sys/block/dm-49/holders ?

cat /proc/self/mountinfo | grep 253:49 ?


Zdenek
