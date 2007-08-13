From: Srini <v.vvsrini@gmail.com>
Subject: Re: Maximum number of MD devices
Date: Mon, 13 Aug 2007 20:15:04 +0530
Message-ID: <25b3869e0708130745x44b3245ctdb4aee5f30163f7c@mail.gmail.com>
References: <25b3869e0708021904jdb9777cj9d6ea918cc92deb9@mail.gmail.com>
	<25b3869e0708062116y72c026c8uef406d94525f774d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <25b3869e0708062116y72c026c8uef406d94525f774d@mail.gmail.com>
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

We have found out that that up to Linux kernel 2.6.16, this problem is
not appearing. However, when the Linux kernel is UPGRADED to Linux
kernel 2.6.17 onwards, we seem to be hitting upon the error.

This clearly indicates that the problem is arising IN BETWEEN the
changes from 2.6.16 to 2.6.17 versions.

Can someone please help and throw some lights what could trigger this situation?

Thanks,

Srini

On 8/7/07, Srini <v.vvsrini@gmail.com> wrote:
> Again retrying to see if some one can offer some clues here...
>
> Thanks in advance for your inputs,
>
> Srini
>
> ---------- Forwarded message ----------
> From: Srini <v.vvsrini@gmail.com>
> Date: Aug 3, 2007 7:34 AM
> Subject: Maximum number of MD devices
> To: device-mapper development <dm-devel@redhat.com>
>
>
> Hi all,
>
> We are currently using Linux kernel 2.6.20-rc6 and EVMS 2.5.4 (which
> internally uses device mapper) for volume management. On running the
> command for creating volumes in EVMS, we find that after around 230
> volumes, EVMS starts reporting that the whole region (md/md0 for
> example) has become corrupt.
>
> Is there a maximum limit on the number of devices that device mapper
> will create that is triggering this error message? If so, are there
> ways to increase the limit?
>
> Please let us know your inputs as it is very critical for us to
> increase this limit.
>
> Thanks in advance,
>
> Srini
>
