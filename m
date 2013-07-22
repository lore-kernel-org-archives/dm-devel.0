From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: pseudo block device as metadata and cache device
Date: Mon, 22 Jul 2013 13:39:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1307221330400.22240@file01.intranet.prod.int.rdu2.redhat.com>
References: <20130717172923.GA4371@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130717172923.GA4371@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Subbarao <vskerneldevel@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Wed, 17 Jul 2013, Vivek Subbarao wrote:

> Hi,
> 
> Can a pseudo block device create using mknod be used to hold metadata
> and cached blocks ?
> 
> Thank you,
> Vivek S

Hi

mknod doesn't create any devices, it creates a named REFERENCE to a 
device, not the device itself. The device itself is specified by major and 
minor number, and it must already exist, mknod doesn't create it.

Generally, you don't need to use mknod because on any modern Linux system, 
references to devices are created automatically by udev in the /dev/ 
directory.

Mikulas
