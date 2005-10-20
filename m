From: Alasdair G Kergon <agk@redhat.com>
Subject: uuid prefix
Date: Thu, 20 Oct 2005 22:21:23 +0100
Message-ID: <20051020212123.GP30611@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I've added the prefix 'LVM-' to the uuids of all devices created by LVM2.

This means that it's trivial to identify them as 'belonging' to the
lvm2 application.

libdevmapper is being extended at the moment to incorporate higher-level
functions.

One of the new library calls I've added so far is capable of acting on
several devices.  One of its parameters is a uuid prefix so that it
only acts on devices with a matching prefix.

This is a simple way of providing application ownership so that LVM2 will 
never be able to do anything to a device created by multipath-tools, for 
example.

When you list those devices with 'dmsetup' you can tell immediately whether
or not LVM2 created them, and easily grep / sort the output.

I suggest EVMS, cryptsetup, ddraid, multipath tools etc. also consider
adding short application prefixes to the uuids of devices they create.

Alasdair
-- 
agk@redhat.com
