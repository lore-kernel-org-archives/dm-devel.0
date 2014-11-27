From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 16:43:22 +0100
Message-ID: <5477469A.1080103@redhat.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>	<54773621.5090301@redhat.com>	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>	<54774220.7080709@redhat.com>
	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
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

Dne 27.11.2014 v 16:36 Gianluca Cecchi napsal(a):
> On Thu, Nov 27, 2014 at 4:24 PM, Zdenek Kabelac <zkabelac@redhat.com
> <mailto:zkabelac@redhat.com>> wrote:
>
>
>
>     Ahh - I'd too strict  adblock filter - however passed info is not that useful.
>     Prefered output is   'lvchange -vvvv -an'
>
>
> Thanks!
> here it is:
> https://drive.google.com/file/d/0BwoPbcrMv8mvellaS1FtVXpqU2c/view?usp=sharing
>
>

Well yes - it shows the device is being held open - lvm2 retries to several 
times if the device does not get close - but it doesn't so it refuses o 
deactivate.

So if you are sure there is no user - then maybe you have some kpartx 
partition this device ?

I'd probably need to see your whole 'dmsetup table'
(at least do a grep for VG_AAA_TEMP/LV_AAA_TEMP minor)


>
>     You could 'complete' all cookies older then i.e. 1 minute.
>     Nothing should be holding cookie for that long time.
>
>
> So the command would be
>
> dmsetup udevcomplete_all 1
> correct?

Yes

Zdenek
