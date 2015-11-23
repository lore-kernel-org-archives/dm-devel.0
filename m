From: Ian Pilcher <arequipeno@gmail.com>
Subject: dm-cache metadata size questions
Date: Mon, 23 Nov 2015 16:43:37 -0600
Message-ID: <n304qp$ttu$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

I am trying to come up with an algorithm to divide a single fast block
device into cache data and metadata, and I have several questions.

1.  Is metadata_size = 4MiB + 16 * nr_blocks still the correct formula
     for the metadata size?

2.  Am I correct in thinking that the number of blocks is based on the
     size of the cache data, rather than the origin device  -- i.e.
     nr_blocks = cache_size / block_size?

3.  Assuming that both of the above are correct, how does this look?

     AS: available space on "fast device"
     BS: block size
     MS: metadata size
     CS: cache data size
     NB: number of blocks

     NB = CS / BS

     MS = 4MiB + 16 * NB
        = 4MiB + 16 * (CS / BS)

     CS = AS - MS
        = AS - (4MiB + 16 * (CS / BS))
        = AS - 4MiB - 16 * CS / BS

     CS * BS = (AS - 4MiB) * BS - 16 * CS

     CS * BS + 16 * CS = (AS - 4MiB) * BS

     CS * (BS + 16) = (AS - 4MiB) * BS

     CS = (AS - 4MiB) * BS / (BS + 16)

     I.e. given the available space on my fast device, and the desired
     block size, I can calculate the cache data size as:

       cache_size = (available_size - 4MiB) * block_size /
                                                     (block_size + 16)

     and:

       metadata_size = available_size - cache_size

Yay algebra!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
