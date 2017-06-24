From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: dm-cache coherence issue
Date: Sat, 24 Jun 2017 20:21:02 +0200
Message-ID: <b49afbe7-f3c6-442a-15c1-5165df9e1176@gmx.de>
References: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
Content-Language: de-LU
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

On 24.06.2017 15:56, Johannes Bauer wrote:

> So I seem to have a very basic misunderstanding of what the cleaner
> policy/dirty pages mean. Is there a way to force the cache to flush
> entirely? Apparently, "dmsetup wait" and/or "sync" don't do the job.

I'd like to expand on this, since I discovered something that worries me
a bit just now:

I do have a dm-cache setup for my main drive as well (3 TB HDD cached by
128 GB SSD). On top of dm-cache runs dm-crypt (LUKS). When playing
around with my root fs, I tried to discard the whole cache. Therefore, I
did -- with the LUKS container NOT open:

dmsetup suspend cache-device
dmsetup reload cache-device --table '0 5858433935 cache 253:1 253:0 8:19
512 0 cleaner 0'
dmsetup resume cache-device
dmsetup wait cache-device

Again, "dmsetup wait" hung, with no obvious I/O being done (i.e., all
disks were idle). I Ctrl-Ced out of it. The status showed no dirty pages.

Since I was suspicious, I left the device with the "cleaner" policy and
opened the LUKS container, then did an e2fsck -fn on the opened device.
No errors found.

Then I closed the LUKS container and performed "dmsetup remove" on the
cache device (as well as the two other linear mappings).

Then I re-opened LUKS on the origin device and ran e2fsck -fn there.
File system errors!

I am fully prepared to restore everything from backup. However, is this
normal behavior or an issue? How am I supposed to discard an attached
cache? How do I get the origin device back in sync with the cached device?

Best regards,
Johannes
