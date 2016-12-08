From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: dm-cache: please check/repair metadata
Date: Thu, 8 Dec 2016 08:53:10 -0600
Message-ID: <efe12356-a132-c517-914d-4a4cf3a902fc@gmail.com>
References: <o2adej$eaa$1@blaine.gmane.org>
	<2d776d72-744a-7aa7-a5ae-35192fe145d8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2d776d72-744a-7aa7-a5ae-35192fe145d8@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/08/2016 04:23 AM, Zdenek Kabelac wrote:
> I'm sorry but you've attached so little information there is no way to
> give you some useful hint.

Actually you did.  :-)  I was just asking what tool(s) I should be using
to "check/repair" the metadata.  (Google is oddly silent on the
subject.)

Your reference to "cache_check" was the hint I needed to get started.

Running cache_repair against the metadata device gives me this error:

   transaction_manager::new_block() couldn't allocate new block

I strongly suspect that my metadata device is too small.  It was sized
with the algorithm that I posted to this list about a year ago:

   https://www.redhat.com/archives/dm-devel/2015-November/msg00221.html

Looking at the source code for cache_metadata_size, I see that it adds
additional space for "hints", which the old algorithm didn't account
for.

Assuming that my suspicion is correct, is there any straightforward way
to recover this cache device?  I do need to reclaim the storage used by
the origin device, so I'm guessing that my best course of action will be
to simply recreate the cache device with a sufficiently large metadata
device.

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
