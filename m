From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: sg_persist triggers block kernel event ???
Date: Sun, 04 May 2014 18:57:54 +0200
Message-ID: <53667192.4060102@redhat.com>
References: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

Dne 3.5.2014 22:12, Christophe Varoqui napsal(a):
> Hi list,
>
> I observe this on a debian 7.5 server with a udevadm monitor running in the
> background :
>
> # sg_persist -n -k /dev/sdbh
>    PR generation=0x0, there are NO registered reservation keys
>

Whoever opens   device in 'read-write' mode  and then closes device triggers 
udev change event. (udev rescans whatever has changed on device after this)

That's how it works for many years already.
It's not a bug and some even says it's a feature....

Zdenek
