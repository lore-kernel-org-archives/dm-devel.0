From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: Getting mapped device namw
Date: Mon, 6 Jul 2015 13:20:38 +0200
Message-ID: <559A6486.3010704@gmail.com>
References: <DUB115-W139FD64ED5BB7A83E674F2696930@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DUB115-W139FD64ED5BB7A83E674F2696930@phx.gbl>
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

Dne 6.7.2015 v 11:20 Gili B napsal(a):
> hi
> when a user run :
> dmsetup create [device name] ....
> Can a device mapper target find out the device name that the user entered ?
> I need it for creating entries in proc for example.

It's probably worth to note here - the dm target should always care ONLY about 
major:minor - it should never care about the name of device.
It looks like you are doing something weird in your target.

Regards

Zdeenk
