From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: DM-Delay
Date: Thu, 22 Jan 2015 10:12:29 -0500
Message-ID: <CAFTzLMOthP-P=XYQ9kpmCCAg2c61iaX1Qi69=wW2YNisM7yVyg@mail.gmail.com>
References: <CAE6Xt1tC7ifisESxLiQaRnJtY9puB8TwJaNv_05=EyVLnx1idQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAE6Xt1tC7ifisESxLiQaRnJtY9puB8TwJaNv_05=EyVLnx1idQ@mail.gmail.com>
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

Hi Sourav,

Delay target provides uniform latency with 1ms granularity. You can
specify different latency for reads or writes. No matter what is the
size of the request or the number of requests submitted - the delay
will remain the same.

To change granularity to microseconds the code need to be modified to
use high-res timers (instead of regular Linux timers). It is
relatively straight forward modification,  I did it once and have a
patch somewhere. Let me see if I can find it.

HTH,
Vasily

On Wed, Jan 21, 2015 at 12:15 PM, Sourav Basu <sourav.juit@gmail.com> wrote:
> Hello,
>    I have few questions regarding dm-delay component.
> 1. Why type of emulations is targeted while implementation of dm-delay?
>  2. Is the delay uniform across different i/o going to the device?
>  3. Can the granularity of be reduced from mili-sec to tens of micro-sec? If
> so how?
>
> My aim is to emulate ssd devices latency varying from 10us to 100ms on
> ramdisk using dm-delay.
>
> Regards,
> Sourav
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
