From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Status dm-cache
Date: Tue, 27 Aug 2013 12:33:25 +0200
Message-ID: <521C8075.7060903@redhat.com>
References: <521A7B1B.2070500@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <521A7B1B.2070500@rolffokkens.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 25.8.2013 23:46, Rolf Fokkens napsal(a):
> Hi!
>
> I'm trying to package some tools for "SSD caching" for Fedora 20, see:
> https://bugzilla.redhat.com/show_bug.cgi?id=998543
>
> bcache has some nice bcache-tools, and packaging progresses well:
> https://bugzilla.redhat.com/show_bug.cgi?id=999690
>
> Packaging dm-cache however seems seems hard. I'm not aware of any userland
> tools, and using dm-cache (without them) seems quite complex. Looks like all
> kinds of math are needed to make it work, e.g. :
> http://blog.kylemanna.com/linux/2013/06/30/ssd-caching-using-dmcache-tutorial/.
> - Is there a (well supported) toolset available that I'm missing?
> - Is there any kind of autodetect possible, e.g. during boot?
>
> Any information on the status of dm-cache is appreciated.


For direct usage of dm-cache target:

linux/Documentation/device-mapper/cache.txt
linux/Documentation/device-mapper/cache-policies.txt

Userland tool here is  dmsetup.

There will be a direct support for dm cache device stacking in lvm2 in the 
future. It will use nearly the same code as is used for thin provisioning,
so the code for now thinp is improved to handle recovery more autonomously 
first before the caching support will be added.

Zdenek
