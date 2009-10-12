From: Wes Felter <wesley@felter.org>
Subject: Re: dmcache project
Date: Mon, 12 Oct 2009 14:47:50 -0500
Message-ID: <hb0155$33r$1@ger.gmane.org>
References: <4bbcfcd40910101336t4cf3824bsf6fb58e12c350953@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4bbcfcd40910101336t4cf3824bsf6fb58e12c350953@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

ganesh kumar wrote:
> hello,
>       I am working on the dmcacheio project which is described in the
> http://kernelnewbies.org/KernelProjects/DmCache.I am newbie to he
> kernel modules..kindly give me the ideas to implement the project
> through device mapper.hoping replies

Someone already started on this: 
http://users.cis.fiu.edu/~zhaom/dmcache/index.html

There are plenty of possible improvements:
Parameter tuning (e.g. block size)
Replacing the set associative crap with a fully associative hash table
Sequential IO bypass
Flash-optimized writeback (e.g. log-structured)

Wes Felter
