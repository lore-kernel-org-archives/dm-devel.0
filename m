From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin vs lvm performance
Date: Mon, 16 Jan 2012 12:42:01 +0000
Message-ID: <20120116124158.GA4426@ubuntu>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jagan Reddy <gjmsreddy@yahoo.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Jagan,

On Thu, Jan 12, 2012 at 04:55:16PM -0800, Jagan Reddy wrote:
> Hi,

> I =A0recently started using dm-thin module and first of all, thank you
> for the good work. It works great, well documented and the comments
> in the code are very useful. =A0I tried to run some performance tests
> using a high performance flash device and the performance of dm thin
> is about 30% of LVM performance on a full allocated thin provisioned
> volume. ( ie after all pages/blocks are allocated using
> dd). Performance test does only reads and no writes.=A0

Thanks very much for taking the time to try thinp out properly.
People testing different scenarios is very useful to us.

You're probably aware that the thinp test suite is available here:

    https://github.com/jthornber/thinp-test-suite

I've added a little set of tests that recreate your scenario here:

    https://github.com/jthornber/thinp-test-suite/blob/master/ramdisk_tests=
.rb

I used a 2G ramdisk for these tests, and a variety of thinp block
sizes and 'dd' options.  I'll just summarise the main results, also I
should point out that my testing was done on a VM hosted on a 4G
machine, so the machine was under a lot of memory pressure and there
was a lot of variance in the benchmarks.

writes across various volumes
-----------------------------

write1
------

Testing write performance.

dd if=3D/dev/zero of=3D/dev/mapper/<thin> oflags=3Ddirect bs=3D64M

zeroing new blocks turned on.

thinp block size =3D 64k

| Linear              | 2.2 G/s |
| Unprovisioned thin  | 1.4 G/s |
| Provisioned thin    | 1.9     |
| Snap totally shared | 1.5 G/s |
| Snap no sharing     | 1.9     |

Pretty good.  Not showing the drastic drop that you were seeing.  The
small thinp block size means the snaps perform nicely (not many
copy-on-writes).

write2
------

As test1, but with 8M thinp block size as in your tests.

| Linear              | 2.2 G/s |
| Unprovisioned thin  | 1.5 G/s |
| Provisioned thin    | 2.2     |
| Snap totally shared | 882 Ms  |
| Snap no sharing     | 2.2     | =


Good results, breaking sharing performance is down because the large
block size mean there will be more actual copying incurred.

write3
------

As test2, but no oflags=3Ddirect option to dd.

| Linear              | 900 M/s |
| Unprovisioned thin  | 579 M/s |
| Provisioned thin    | 694 M/s |
| Snap totally shared | 510 M/s |
| Snap no sharing     | 654 M/s | =


Alarming.  Results are similar for thinp block size of 64k.

read1
-----

Testing read performance.

dd if=3D/dev/mapper/<thin> of=3D/dev/null iflags=3Ddirect bs=3D64M

thinp block size =3D 64k

| Linear              | 3.3 G/s |
| Provisioned thin    | 2.7 G/s |
| Snap no sharing     | 2.8 G/s | =



read2
-----

read1 but with 8M thinp block size

| Linear              | 3.3 G/s |
| Provisioned thin    | 3.2 G/s |
| Snap no sharing     | 3.3 G/s | =


read3
-----

As read2, but without the iflags=3Ddirect option to 'dd'.

| Linear              | 1.0 G/s |
| Provisioned thin    | 594 M/s |
| Snap no sharing     | 605 M/s | =




I think there are a couple of conclusions we can draw from this:

i) dd isn't great for benchmarking block devices
ii) if you are going to use it, then make sure you use O_DIRECT

Using an instrumented kernel, I've confirmed that these read tests
are taking the fast path through the code.  The mapping tables are all
in memory.  The bio_map function is always returning DM_MAPIO_REMAPPED.

Will you be using a filesystem on these block devices?

- Joe
