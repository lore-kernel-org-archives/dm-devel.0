From: "Navin P.S" <navinp1912@gmail.com>
Subject: Re: write directly to device mapper snapshot origin
	device ?
Date: Fri, 15 Jul 2016 13:59:04 +0530
Message-ID: <CAA=4086b_9xz32cU+DnuUMGU=rZhWZ=+UVfjwq0AKnX3C7k3qA@mail.gmail.com>
References: <CAA=4086wdhAxNsWjAYgZG3bWORV2vF3YpMQk9OTjAg22MJi07Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAA=4086wdhAxNsWjAYgZG3bWORV2vF3YpMQk9OTjAg22MJi07Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

Resend ..

On Thu, Jul 14, 2016 at 7:55 PM, Navin P.S <navinp1912@gmail.com> wrote:
> Hi,
>   Can i do dd if=/dev/zero of=/dev/mapper/dmo count=20 ? where dmo is
> a dm snapshot origin created through dmsetup command. Instead of
> /dev/zero i can write valid devices.
>
> I could create the dmo through some lvm2 commands. Is direct write
> with 4k (page size values ) allowed when it is mapped to 2 block
> devices in linear mode ?
>
>
> Regards,
> -- Navin

I'm seeing  OOM followed by reboot of host machine.
Does this mean this device cannot to exported to containers for writing ?


-- 
-- Navin
