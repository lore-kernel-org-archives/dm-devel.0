From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: dm-cache (lack-of) efficiency
Date: Sun, 23 Jun 2019 07:38:33 +0200
Message-ID: <20190623053832.GA29748@qmqm.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Dear DM Developers,

I stumbled on a weird (and annoing) behaviour of dm-cache: after unclean
reboot (sysrq + s,u,b) it marks all the cache as dirty and starts to
write it back. This takes a few hours every time (cache data is on SSD,
but backing storage is very slow for random access) and mostly kills
interactivity for anything that touches the cached volume.

This seems to ignore cache mode: write-through is also affected, even when
it should not ever have a dirty state. Switching from write-through to
write-back also resets cache to all-dirty and generates the same situation.

Why is write-through cache considered dirty when switching to write-back?

Is there a way to sort the requests, so the writes are monotonic wrt
sector number?

Can the dirty state be written to metadata storage on SysRq+S?

Best Regards,
Micha=B3=A0Miros=B3aw

---
# uname -a
Linux qmqm 5.1.13mq+ #321 SMP PREEMPT Sun Jun 23 03:14:18 CEST 2019 x86_64 =
GNU/Linux

# dmsetup table |grep sources
fox-sources_corig: 0 335544320 linear 253:6 209717248
fox-sources_corig: 335544320 83886080 linear 253:6 1048578048
fox-sources_corig: 419430400 104857600 linear 253:6 1174407168
fox-c_sources_cdata: 0 31350784 linear 253:4 116736
fox-sources: 0 524288000 cache 253:12 253:11 253:13 64 2 metadata2 writethr=
ough smq 0
fox-c_sources_cmeta: 0 57344 linear 253:4 59392

# lvmcache-stats fox/sources
start              0
end                524288000
segment_type       cache
md_block_size      8
md_utilization     1480/7168
cache_block_size   64
cache_utilization  489856/489856
read_hits          2027069
read_misses        144887
read_hit_ratio     93.33%
write_hits         331428
write_misses       112870
write_hit_ratio    74.60%
demotions          0
promotions         0
dirty              314362
features           3
