From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Fix race-condition when reading sysfs
	attributes.
Date: Tue, 24 Mar 2009 16:34:38 +0100
Message-ID: <ac3eb2510903240834h13c0848foe84d11f94999179c@mail.gmail.com>
References: <1237908301-2339-1-git-send-email-konrad@virtualiron.com>
	<1237908301-2339-2-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237908301-2339-2-git-send-email-konrad@virtualiron.com>
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

On Tue, Mar 24, 2009 at 16:24, Konrad Rzeszutek <konrad@virtualiron.com> wrote:
> This fix re-introduces a wait loop when reading sysfs attributes.
> The reason a wait is necessary is due to the way the kernel
> sends the event.

> There are four uevents sent from the kernel in the creation of
> a SysFS representation of the device. After the last event, the
> SysFs entries for vendor,model, rev are populated. The window
> time between the uevent with /block/sdX sent and the sysfs
> attributes being populated is small.

What kernel version are you using? I thought we fixed all that long ago.

Thanks,
Kay
