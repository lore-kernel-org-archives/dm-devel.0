From: "John Stoffel" <john@stoffel.org>
Subject: Re: fixing mangled UUIDs
Date: Wed, 9 Dec 2015 11:40:20 -0500
Message-ID: <22120.22900.364905.238586@quad.stoffel.home>
References: <22120.21444.300955.356941@quad.stoffel.home>
	<20151209162739.GR11127@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151209162739.GR11127@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, John Stoffel <john@stoffel.org>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids


Alasdair> Have you tried '--manglename none' if you aren't using a
Alasdair> udev system that mangles names?  (Also available via
Alasdair> environmnet variable - see man page.)

That seems to be working, using the default Debbian Jessie lvm tools:

  dmsetup --manglename none status --target cache
  data-home: 0 1153433600 cache 8 2443/32768 128 54020/819200 80721
  350897 64427 66938 0 23882 1 1 writeback 2 migration_threshold 2048
  smq 0 rw -
  data-local: 0 702545920 cache 8 2443/32768 128 1078/819200 6268 85795
  1492 2715 0 1057 0 1 writeback 2 migration_threshold 2048 smq 0 rw -


So now I can try to monitor my cache usage.

So the question still remains, what is the long term fix so I don't
have to deal with this breakage by default?  Do I have bad UUIDS on my
volumes?

John
