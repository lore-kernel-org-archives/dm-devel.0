From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: 3.12.y: srcu warning during free_dev() with
	dm-multipath
Date: Mon, 22 Jun 2015 14:22:54 +0200
Message-ID: <5587FE1E.5000503@profitbricks.com>
References: <55819FD1.4010306@profitbricks.com>	<5587CD74.40401@profitbricks.com>
	<5587E281.5030606@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5587E281.5030606@gmail.com>
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

On 22.06.2015 12:25, Zdenek Kabelac wrote:
> Dne 22.6.2015 v 10:55 Sebastian Parschauer napsal(a):
>> Really, no response? Again?
>>
>> Why doesn't that surprise me if sending a bug report to Red Hat not
>> using their kernel,... Thanks a lot! So this is how discrimination feels
>> like,...
>>
> 
> Have you checked your problem exists in the latest upstream kernel ?

It likely doesn't. I can't roll out the latest greatest unstable
upstream kernel into a public IaaS cloud where I can see the problem
from time to time but in a test environment it's more difficult to
reproduce. We also have custom code running in different unrelated parts
which would have to be adapted.

> If you are resolving issue with kernel 3.12 -  it's likely a thing for
> your distribution and its maintenance support?

We are our own distribution. So I'm just the distribution maintainer
asking the authors of a patch if that one could be related instead of
doing reverse engineering. Maintainers should have a feeling for their
code and also care for important fixes so that these find their way into
the stable trees - no matter which distribution.

Maybe that's the difference between homebrew FOSS and commercial FOSS.
But there are upstream kernel maintainers who do care for linux-stable.
I'd like to mention md maintainer Neil Brown here.

> Upstream (and this is upstream ml) is close to release 4.1 kernel - so
> you are fixing couple years old issue? What kind of action do you expect ?

Just a hint at which patches to look at.

You maintain a 3.10 kernel for RHEL 7. That one is also old and not
latest upstream.

I'll try the patch.

Cheers,
Sebastian


>> On 17.06.2015 18:26, Sebastian Parschauer wrote:
>>> Hi dm developers,
>>>
>>> we hit the srcu warning in cleanup_srcu_struct() when removing
>>> dm-multipath devices. We run v3.12.40 but there is no change compared to
>>> v3.12.44 in drivers/md/dm.c or kernel/srcu.c.
>>>
>>> Would the following upstream commit fix this?
>>>
>>> 63a4f06 dm: fix add_disk() NULL pointer due to race with free_dev()
>>>
>>> Thanks,
>>> Sebastian
>>
> 
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
