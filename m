From: "Thomas S. Iversen" <zensonic@zensonic.dk>
Subject: Help tracking down problem --- endless loop in
	__find_get_block_slow
Date: Mon, 21 Feb 2005 11:46:50 +0100
Message-ID: <4219BC1A.1060007@zensonic.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi There

I am trying to develop a device mapper plugin which does transparent 
block encryption and sector shuffling in the style freebsd does it (GBDE)

Reads are support and working, but have trouble getting writes to work 
properly.

If I do a simple:

echo "test" > /mnt/test (where /mnt is /dev/mapper/gbde)
sync

it works just fine. If I do

dd if=/dev/zero of=/mnt/testfile count=N, N=1..6 it works fine

But if I do

dd if=/dev/zero of=/mnt/testfile count=N, N>6

I get into an endless loop in __find_get_block_slow. My write path does 
something like this:

recieve original BIO (eg. size=4096). Split BIO into sectorsize chunks.
map chunks to physical sectors.
encrypt sectors
generate keys
write sectors
update keysectors
... when all sectors are written call bio_endio on the original request.

To awoid allocating alot of pages during writes, I use the mem from the 
original request to do encryption "inplace". Could that be the cause of 
my problems? I would clearly like to minimize the need for page 
allocation in my dm-module, so I hope it isn't.

Whats going on here? Every comments appriciated!

Regards Thomas
