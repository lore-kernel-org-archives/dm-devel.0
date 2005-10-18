From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: racing libdevmapper calls
Date: Wed, 19 Oct 2005 01:05:55 +0200
Message-ID: <1129676755.7313.26.camel@zezette>
References: <1129674646.7313.15.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1129674646.7313.15.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mer, 2005-10-19 at 00:30 +0200, Christophe Varoqui wrote:
> Hello,
> 
> The following command :
> # dmsetup remove foo;echo "0 10 linear 8:16 63"|dmsetup create foo &
> echo "0 20 linear 8:16 63"|dmsetup create foo
> 
> will quite easily produce error message like :
> "device-mapper ioctl cmd 3 failed: Device or resource busy"
> 
> Is it designed behaviour ?
> Can't we expect libdevmapper to serialize its ioctls ?
> 
> multipath(8), being run in storms by udev, has trouble with this.
> Ideas ?
> 
I realize this example is trivially flawed : 2nd ioctl will necessarily
fail, and the message is appropriate in this case.

But in multipath(8), I tried something like :

if (map exists) /* through DM_DEVICE_INFO */
	DM_DEVICE_RELOAD
else
	DM_DEVICE_CREATE

Which translate like :
# dmsetup remove foo;echo "0 10 linear 8:16 63"|dmsetup create foo &
dmsetup info foo || echo "0 20 linear 8:16 63"|dmsetup create foo

But I can't seem to avoid the "device-mapper ioctl cmd 3 failed: Device
or resource busy" messages.

Regards,
cvaroqui
