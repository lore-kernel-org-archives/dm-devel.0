From: Cong Wang <amwang@redhat.com>
Subject: Re: [dm-devel] [PATCH 17/62] md: remove the second argument of k[un]map_atomic()
Date: Mon, 28 Nov 2011 13:10:51 +0800
Message-ID: <4ED317DB.30001@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-18-git-send-email-amwang@redhat.com> <20111127170013.20d180a9@notabene.brown> <4ED2108F.9000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ED2108F.9000203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

=E4=BA=8E 2011=E5=B9=B411=E6=9C=8827=E6=97=A5 18:27, Milan Broz =E5=86=99=
=E9=81=93:
> On 11/27/2011 07:00 AM, NeilBrown wrote:
>> On Sun, 27 Nov 2011 13:26:57 +0800 Cong Wang<amwang@redhat.com>  wro=
te:
>>
>>>
>>> Signed-off-by: Cong Wang<amwang@redhat.com>
>>
>> This and patch 57/62
>>
>>   Acked-by: NeilBrown<neilb@suse.de>
>>
>> thanks.
>>
>> Not sure why there are two separate patches to md/bitmap.c though...
>>
>> ... and I cannot offically 'ack' the dm-crypt.c parts of this as I'm=
 not the
>>      maintainer.  'md' and 'dm' are separate systems in the same dir=
ectory -
>>      confusing, isn't it :-(

That is my bad, I should fold the md parts into one... :-/
I will separate them correctly.

>
> These little walled gardens ... :)
>
> I hope I can ack that dm-crypt code, I added that chunk
> as part of loop-aes compatibility code.
> (Anyway Alasdair as dm maintainer should ack it too.)
>
> Acked-by: Milan Broz<mbroz@redhat.com>
>

Thanks, Neil and Milan!
