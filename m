From: Andy Grover <agrover@redhat.com>
Subject: How big should raid metadata device be?
Date: Mon, 2 Nov 2015 11:55:43 -0800
Message-ID: <5637BFBF.3010603@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

In looking at md-raid one question I had was exactly how large does the 
metadata device need to be in comparison to the data device? It contains 
a padded-to-4Kbyte sized raid metadata struct, and then also a write 
intent bitmap that is sized based upon the number of stripes, with 16 
bits per stripe.

Is it correct to say the minimum size of the metadata device should be:

4096 + (2 * stripe_count)

bytes?

Thanks -- Andy

p.s. LVM2 allocates 1 extent (default 4MiB) for the raid meta device. 
But it's not clear if given a large enough raid dev, and configured with 
a much smaller extent size than the default, if one extent might not be 
enough.
