From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin vs lvm performance
Date: Fri, 20 Jan 2012 17:03:35 +0000
Message-ID: <20120120170335.GA10518@ubuntu>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120116124158.GA4426@ubuntu>
	<1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jagan Reddy <gjmsreddy@yahoo.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Jagan,

On Wed, Jan 18, 2012 at 11:30:54AM -0800, Jagan Reddy wrote:
> Joe,
> =A0Thanks for looking into the issue and running the tests and suggesting=
 to use "direct" flag. I do see a difference with "direct" flag using dd. H=
owever the difference is significant when using bs=3D64M compared to bs=3D4=
k.=A0

I've spent a couple of days tinkering with aio-stress and thinp on
ramdisks.  More tests can be found here:

https://github.com/jthornber/thinp-test-suite/blob/master/ramdisk_tests.rb

It appears that wiping the device (ie. to ensure total allocation) is
causing the issue, and what's more this is a more general problem than
just thinp.

For instance see this test:

  def test_linear_aio_stress
    linear_table =3D Table.new(Linear.new(@volume_size, @data_dev, 0))
    @dm.with_dev(linear_table) do |linear_dev|
      aio_stress(linear_dev)
      wipe_device(linear_dev)   # cause slow down                          =
                          =

      aio_stress(linear_dev)
    end
  end

For me, the first run of aio_stress manages a throughput of ~9G/s.
After the wipe, which is just a simple dd across the device,
performance drops to ~5.5 G/s.  Also throughput on the device under
the linear target also drops.  Permanently.

I don't know if this is specific to aio, or a more general slowdown.

Once we have got to the bottom of this I've written a couple of
experimental patches that we can try to boost read performance
further.

- Joe
