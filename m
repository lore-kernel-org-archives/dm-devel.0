From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-crypt performance
Date: Mon, 25 Mar 2013 23:47:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I performed some dm-crypt performance tests as Mike suggested.

It turns out that unbound workqueue performance has improved somewhere 
between kernel 3.2 (when I made the dm-crypt patches) and 3.8, so the 
patches for hand-built dispatch are no longer needed.

For RAID-0 composed of two disks with total throughput 260MB/s, the 
unbound workqueue performs as well as the hand-built dispatch (both 
sustain the 260MB/s transfer rate).

For ramdisk, unbound workqueue performs better than hand-built dispatch 
(620MB/s vs 400MB/s). Unbound workqueue with the patch that Mike suggested 
(git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git) improves 
performance slighlty on ramdisk compared to 3.8 (700MB/s vs. 620MB/s).



However, there is still the problem with request ordering. Milan found out 
that under some circumstances parallel dm-crypt has worse performance than 
the previous dm-crypt code. I found out that this is not caused by 
deficiencies in the code that distributes work to individual processors. 
Performance drop is caused by the fact that distributing write bios to 
multiple processors causes the encryption to finish out of order and the 
I/O scheduler is unable to merge these out-of-order bios.

The deadline and noop schedulers perform better (only 50% slowdown 
compared to old dm-crypt), CFQ performs very badly (8 times slowdown).


If I sort the requests in dm-crypt to come out in the same order as they 
were received, there is no longer any slowdown, the new crypt performs as 
well as the old crypt, but the last time I submitted the patches, people 
objected to sorting requests in dm-crypt, saying that the I/O scheduler 
should sort them. But it doesn't. This problem still persists in the 
current kernels.


For best performance we could use the unbound workqueue implementation 
with request sorting, if people don't object to the request sorting being 
done in dm-crypt.


Mikulas
